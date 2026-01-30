--- @since 25.5.31

local M = {}
local shell = os.getenv("SHELL") or ""
local PackageName = "Restore"

---@class TrashItem
---@field trash_index number
---@field trashed_date_time string
---@field trashed_path string
---@field type File_Type

---@class Theme
---@field title? any
---@field header? any
---@field header_warning? any
---@field list_item? {odd?: any, even?: any}

---@class SetupOptions
---@field position? AsPos
---@field show_confirm? boolean
---@field theme? Theme
---@field suppress_success_notification? boolean

local function success(s, ...)
	ya.notify({ title = PackageName, content = string.format(s, ...), timeout = 5, level = "info" })
end

local function error(s, ...)
	ya.notify({ title = PackageName, content = string.format(s, ...), timeout = 5, level = "error" })
end

local set_state = ya.sync(function(state, key, value)
	if not state then
		state = {}
	end
	state[key] = value
end)

local get_state = ya.sync(function(state, key)
	return state and state[key]
end)

---@enum STATE
local STATE = {
	POSITION = "position",
	SHOW_CONFIRM = "show_confirm",
	SUPPRESS_SUCCESS_NOTIFICATION = "suppress_success_notification",
	THEME = "theme",
	INITIALIZED = "initialized",
}

---@enum File_Type
local File_Type = {
	File = "file",
	Dir = "dir_all",
	None_Exist = "unknown",
}

--- Get current working directory
---@return string
local get_cwd_raw = ya.sync(function()
	return tostring(cx.active.current.cwd.path or cx.active.current.cwd)
end)

--- Quote path for shell command
---@param path string Absolute path
---@return string
local function path_quote(path)
	local result = "'" .. string.gsub(path, "'", "'\\''") .. "'"
	return result
end

--- Check path is file or directory or none exist.
---@param path string Absolute path
---@return File_Type
local function get_file_type(path)
	local cha, _ = fs.cha(Url(path), true)
	if cha then
		return cha.is_dir and File_Type.Dir or File_Type.File
	end
	return File_Type.None_Exist
end

--- Get trash volume of current working directory.
---@return string|nil
local function get_trash_volume()
	local cwd_raw = get_cwd_raw()
	local trash_volumes_stream, cmr_err =
		Command("trash-list"):arg({ "--volumes" }):stdout(Command.PIPED):stderr(Command.PIPED):output()

	---@type string|nil
	local best_matched_vol_path
	if trash_volumes_stream then
		local previous_matched_vol_length = 0
		for vol in trash_volumes_stream.stdout:gmatch("[^\r\n]+") do
			local vol_length = utf8.len(vol) or 1
			if cwd_raw:sub(1, vol_length) == vol and vol_length > previous_matched_vol_length then
				-- NOTE: Don't break here, because we need to get the best match volume
				best_matched_vol_path = vol
				previous_matched_vol_length = vol_length
			end
		end
		if not best_matched_vol_path then
			error("Can't get trash directory")
		end
	else
		error("Failed to start `trash-list` with error: `%s`. Do you have `trash-cli` installed?", cmr_err)
	end
	return best_matched_vol_path
end

--- Get list of files/folders trashed in reversed order
---@param curr_working_volume string current working volume
local function get_latest_trashed_items(curr_working_volume)
	---@type TrashItem[], TrashItem[]
	local reversed_restorable_items, reversed_existed_items = {}, {}

	-- NOTE: use `tac` to reverse the list. So that we can pop items from the end faster
	local reversed_trashed_list_stream, err_cmd = Command(shell)
		:arg({ "-c", "printf '\n' | trash-restore " .. path_quote(curr_working_volume) .. " | tac" })
		:stdout(Command.PIPED)
		:stderr(Command.PIPED)
		:spawn()

	if reversed_trashed_list_stream then
		local last_item_datetime = nil

		while true do
			local line, event = reversed_trashed_list_stream:read_line()
			if event ~= 0 then
				break
			end
			-- remove leading spaces
			local trash_index, item_date, item_path = line:match("^%s*(%d+) (%S+ %S+) ([^\n]+)")
			if item_date and item_path and trash_index ~= nil then
				if last_item_datetime and last_item_datetime ~= item_date then
					break
				end
				local trash_item_type = get_file_type(item_path)
				local trash_item = {
					trash_index = tonumber(trash_index),
					trashed_date_time = item_date,
					trashed_path = item_path,
					type = trash_item_type,
				}
				table.insert(reversed_restorable_items, trash_item)
				if trash_item_type ~= File_Type.None_Exist then
					table.insert(reversed_existed_items, trash_item)
				end
				last_item_datetime = item_date
			end
		end
		reversed_trashed_list_stream:start_kill()

		if #reversed_restorable_items == 0 then
			success("Nothing left to restore")
			return
		end
	else
		error("Failed to start `trash-restore` with error: `%s`. Do you have `trash-cli` installed?", err_cmd)
		return
	end
	return reversed_restorable_items, reversed_existed_items
end

--- Restore files/folders from trash list based on trash item start and end index
---@param curr_working_volume string current working volume
---@param start_index integer trash item start index
---@param end_index integer trash item end index
local function restore_files(curr_working_volume, start_index, end_index)
	if type(start_index) ~= "number" or type(end_index) ~= "number" or start_index < 0 or end_index < 0 then
		error("Failed to restore file(s): out of range")
		return
	end

	local restored_status, _ = Command(shell)
		:arg({
			"-c",
			"echo " .. ya.quote(start_index .. "-" .. end_index) .. " | trash-restore --overwrite " .. path_quote(
				curr_working_volume
			),
		})
		:stdout(Command.PIPED)
		:stderr(Command.PIPED)
		:output()

	local file_to_restore_count = end_index - start_index + 1
	if restored_status then
		if not get_state(STATE.SUPPRESS_SUCCESS_NOTIFICATION) then
			success(
				"Restored " .. tostring(file_to_restore_count) .. " file" .. (file_to_restore_count > 1 and "s" or "")
			)
		end
	else
		error(
			"Failed to restore "
				.. tostring(file_to_restore_count)
				.. " file"
				.. (file_to_restore_count > 1 and "s" or "")
		)
	end
end

--- Convert trash list to UI component list
---@param reversed_trash_list TrashItem[]
---@return ui.List[]
local function get_components(reversed_trash_list)
	---@type Theme
	local theme = get_state(STATE.THEME)
	local item_odd_style = theme.list_item and theme.list_item.odd and ui.Style():fg(theme.list_item.odd)
		or th.confirm.list
	local item_even_style = theme.list_item and theme.list_item.even and ui.Style():fg(theme.list_item.even)
		or th.confirm.list

	local trashed_items_components = {}
	local display_index = 1

	for idx = #reversed_trash_list, 1, -1 do
		local item = reversed_trash_list[idx]
		table.insert(
			trashed_items_components,
			ui.Line({
				ui.Span(" "),
				ui.Span(item.trashed_path):style((display_index % 2 == 1) and item_odd_style or item_even_style),
			}):align(ui.Align.LEFT)
		)
		display_index = display_index + 1
	end
	return trashed_items_components
end

--- Setup plugin, add it to yazi/init.lua file
---@param opts? SetupOptions
function M:setup(opts)
	if opts and type(opts) ~= "table" then
		return
	end
	set_state(
		STATE.POSITION,
		(opts and type(opts.position) == "table") and opts.position or { "center", w = 70, h = 40 }
	)
	set_state(STATE.SHOW_CONFIRM, opts == nil or opts.show_confirm ~= false)
	set_state(STATE.THEME, (opts and type(opts.theme) == "table") and opts.theme or {})
	set_state(STATE.SUPPRESS_SUCCESS_NOTIFICATION, opts and opts.suppress_success_notification)
	set_state(STATE.INITIALIZED, true)
end

function M:entry(job)
	if not get_state(STATE.INITIALIZED) then
		M:setup()
	end
	local curr_working_volume = get_trash_volume()
	if not curr_working_volume then
		return
	end
	local interactive_mode = job.args.interactive
	local interactive_overwrite = job.args.interactive_overwrite
	if interactive_mode == true then
		ya.emit("shell", {
			"clear && trash-restore " .. (interactive_overwrite and "--overwrite" or "") .. " " .. path_quote(
				curr_working_volume
			),
			block = true,
		})
		return
	end
	--NOTE: No need to reverse the list here, waste of time and memory
	local reversed_trashed_items, reversed_collided_items = get_latest_trashed_items(curr_working_volume)
	if reversed_trashed_items == nil then
		return
	end
	local overwrite_confirmed = true
	local show_confirm = get_state(STATE.SHOW_CONFIRM)
	local pos = get_state(STATE.POSITION)

	---@type Theme
	local theme = get_state(STATE.THEME)
	theme.title = theme.title and ui.Style():fg(theme.title):bold() or th.confirm.title
	theme.header = theme.header and ui.Style():fg(theme.header) or th.confirm.content
	theme.header_warning = ui.Style():fg(theme.header_warning or "yellow")
	if show_confirm then
		local continue_restore = ya.confirm({
			title = ui.Line("Restore files/folders"):style(theme.title),
			body = ui.Text({
				ui.Line(""),
				ui.Line(
					#reversed_trashed_items
						.. " file"
						.. (#reversed_trashed_items <= 1 and " " or "s ")
						.. "and folder"
						.. (#reversed_trashed_items <= 1 and " " or "s ")
						.. (#reversed_trashed_items <= 1 and "is " or "are ")
						.. "going to be restored:"
				):style(theme.header),
				ui.Line(""),
				table.unpack(get_components(reversed_trashed_items)),
			})
				:align(ui.Align.LEFT)
				:wrap(ui.Wrap.YES),
			-- TODO: remove this after next yazi released
			content = ui.Text({
				ui.Line(""),
				ui.Line(
					#reversed_trashed_items
						.. " file"
						.. (#reversed_trashed_items <= 1 and " " or "s ")
						.. "and folder"
						.. (#reversed_trashed_items <= 1 and " " or "s ")
						.. (#reversed_trashed_items <= 1 and "is " or "are ")
						.. "going to be restored:"
				):style(theme.header),
				ui.Line(""),
				table.unpack(get_components(reversed_trashed_items)),
			})
				:align(ui.Align.LEFT)
				:wrap(ui.Wrap.YES),
			pos = pos,
		})
		-- stopping
		if not continue_restore then
			return
		end
	end

	-- show Confirm dialog with list of collided items
	if reversed_collided_items and #reversed_collided_items > 0 then
		overwrite_confirmed = ya.confirm({
			title = ui.Line("Restore files/folders"):style(theme.title),
			body = ui.Text({
				ui.Line(""),
				ui.Line(
					#reversed_collided_items
						.. " file"
						.. (#reversed_collided_items <= 1 and " " or "s ")
						.. "and folder"
						.. (#reversed_collided_items <= 1 and " " or "s ")
						.. (#reversed_collided_items <= 1 and "is " or "are ")
						.. "existed, overwrite?"
				):style(theme.header_warning),
				ui.Line(""),
				table.unpack(get_components(reversed_collided_items)),
			})
				:align(ui.Align.LEFT)
				:wrap(ui.Wrap.YES),
			-- TODO: remove this after next yazi released
			content = ui.Text({
				ui.Line(""),
				ui.Line(
					#reversed_collided_items
						.. " file"
						.. (#reversed_collided_items <= 1 and " " or "s ")
						.. "and folder"
						.. (#reversed_collided_items <= 1 and " " or "s ")
						.. (#reversed_collided_items <= 1 and "is " or "are ")
						.. "existed, overwrite?"
				):style(theme.header_warning),
				ui.Line(""),
				table.unpack(get_components(reversed_collided_items)),
			})
				:align(ui.Align.LEFT)
				:wrap(ui.Wrap.YES),
			pos = pos,
		})
	end
	if overwrite_confirmed then
		restore_files(
			curr_working_volume,
			reversed_trashed_items[#reversed_trashed_items].trash_index,
			reversed_trashed_items[1].trash_index
		)
	end
end

return M
