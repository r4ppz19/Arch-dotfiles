local function dedent(str)
  str = str:gsub("^%s*\n", ""):gsub("\n%s*$", "")
  local min_indent
  for line in str:gmatch "[^\n]+" do
    local indent = line:match "^(%s*)%S"
    if indent then
      if not min_indent or #indent < #min_indent then
        min_indent = indent
      end
    end
  end
  if min_indent then
    str = str:gsub("\n" .. min_indent, "\n")
  end
  return str
end

return {
  "CopilotC-Nvim/CopilotChat.nvim",
  branch = "main",
  dependencies = {
    "zbirenbaum/copilot.lua",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
  },
  build = "make tiktoken",
  opts = {
    model = "gpt-4.1",
    temperature = 0.1,
    window = {
      layout = "vertical",
      width = 0.4,
    },

    headers = {
      user = " r4ppz",
      assistant = "󱚝  Jarvis",
      tool = " Tool",
    },

    separator = "─",
    auto_fold = true,
    auto_insert_mode = false,

    prompts = {
      Explain = {
        prompt = dedent [[
          #selection
          Explain what this code does in [language/framework]:
          - Describe functionality and purpose
          - Break down syntax, keywords, and structure
          - Clarify language-specific constructs or idioms
        ]],
        system_prompt = dedent [[
          You are an expert explainer. Teach a programmer who knows general programming but not this language.
          Be precise, technical, and concise. Use markdown headings and code blocks.
        ]],
        description = "Explain code with syntax and purpose",
      },

      Review = {
        prompt = dedent [[
          #selection (preferred)
          #buffer (additional context)
          Perform a detailed code review:
          - Highlight issues with exact lines
          - Categorize by severity (critical, warning, suggestion)
          - Suggest fixes with examples
        ]],
        system_prompt = dedent [[
          You are a meticulous reviewer. Focus on correctness, safety, readability, and maintainability.
          Be explicit and concise. Provide code snippets for fixes.
        ]],
        description = "Line-specific code review",
      },

      Fix = {
        prompt = dedent [[
          #selection (preferred)
          #diagnostics:current
          #buffer (additional context)
          Find and fix issues in this code:
          - Explain the problem
          - Provide corrected code
          - Justify why the fix works
        ]],
        system_prompt = dedent [[
          You are a debugger and language expert. Deliver minimal, correct fixes with explanations.
          Include validation hints if relevant.
        ]],
        description = "Debug and fix code with reasoning",
      },

      Optimize = {
        prompt = dedent [[
          #buffer
          Optimize this code:
          - Identify performance or readability issues
          - Suggest improvements
          - Show before/after examples with tradeoffs
        ]],
        system_prompt = dedent [[
          You are a performance engineer. Focus on efficiency without harming clarity.
          Explain tradeoffs clearly. Prioritize algorithmic and structural improvements.
        ]],
        description = "Optimize for speed and clarity",
      },

      Docs = {
        prompt = dedent [[
          #selection
          Write documentation for this code:
          - Document purpose, parameters, return values, and side effects
          - Use conventions of [language/framework]
          - Add examples where useful
        ]],
        system_prompt = dedent [[
          You are a technical writer. Create concise, idiomatic doc comments.
          Follow conventions and include short examples or caveats when needed.
        ]],
        description = "Generate documentation comments",
      },

      Tests = {
        prompt = dedent [[
          #selection
          Generate tests for this code:
          - Cover normal, edge, and error cases
          - Use proper framework for [language/framework]
          - Ensure tests are clear and maintainable
        ]],
        system_prompt = dedent [[
          You are a test-driven developer. Write idiomatic, reliable tests.
          Include setup/teardown if needed, and use clear assertions.
        ]],
        description = "Generate tests for code",
      },

      Commit = {
        prompt = dedent [[
          #gitstatus #gitdiff:staged
          Write a commit message:
          - Follow conventional commit (feat, fix, docs, style, refactor, test, chore)
          - Short, descriptive title
          - Detailed body if needed
          - Reference issues if applicable
        ]],
        system_prompt = dedent [[
          You are an expert commit author. Write concise, conventional commit messages.
          If changes are unrelated, suggest splitting commits.
        ]],
        description = "Generate commit message",
      },

      Idiomatic = {
        prompt = dedent [[
          #selection (preferred)
          #buffer (additional context)
          Check this code for idiomatic style:
          - Does it follow conventions and best practices?
          - Suggest more idiomatic alternatives if needed
        ]],
        system_prompt = dedent [[
          You are a style and idiom expert. Compare non-idiomatic vs idiomatic code and explain why.
        ]],
        description = "Check idiomatic usage",
      },

      Suggest = {
        prompt = dedent [[
          #selection (preferred)
          #buffer (additional context)
          Suggest alternative approaches for this code:
          - Consider readability, safety, maintainability, performance
          - Provide concrete code examples
        ]],
        system_prompt = dedent [[
          You are a seasoned developer. Offer alternatives with pros/cons and migration complexity.
        ]],
        description = "Suggest alternatives and tradeoffs",
      },

      Diagnostic = {
        prompt = dedent [[
          #diagnostics:current (preferred)
          #buffer (additional context)
          Analyze diagnostics and code:
          - List issues with severity
          - Explain root cause
          - Show specific fixes
          - Suggest prevention practices
        ]],
        system_prompt = dedent [[
          You are a diagnostics expert. Provide root cause, exact fixes, and preventive guidance.
        ]],
        description = "Analyze diagnostics and fix issues",
      },
    },
  },

  keys = {
    {
      "<leader>ci",
      mode = { "n", "v" },
      "<cmd>CopilotChatIdiomatic<cr>",
      desc = "Check if code is idiomatic",
    },
    {
      "<leader>ce",
      mode = { "n", "v" },
      "<cmd>CopilotChatExplain<cr>",
      desc = "Explain code",
    },
    {
      "<leader>cs",
      mode = { "n", "v" },
      "<cmd>CopilotChatSuggest<cr>",
      desc = "Suggest alternatives",
    },

    {
      "<leader>cp",
      function()
        local chat = require "CopilotChat"
        chat.open()
        chat.select_prompt()
      end,
      mode = { "n", "v" },
      desc = "Select Prompt",
    },

    {
      "<M-c>",
      "<cmd>CopilotChatToggle<cr>",
      mode = { "n", "v" },
      desc = "Toggle CopilotChat",
    },
    {
      "<leader>cr",
      "<cmd>CopilotChatReset<cr>",
      mode = "n",
      desc = "Reset CopilotChat",
    },

    {
      "<leader>cc",
      function()
        local chat = require "CopilotChat"
        chat.open()
        chat.chat:add_message({ role = "user", content = "#buffer\n\n" }, true)
      end,
      mode = { "n", "v" },
      desc = "Open chat with current buffer",
    },
    {
      "<leader>ca",
      function()
        local chat = require "CopilotChat"
        chat.open()
        chat.chat:add_message({ role = "user", content = "#buffers\n\n" }, true)
      end,
      mode = { "n", "v" },
      desc = "Open chat with all buffer",
    },

    {
      "<leader>cf",
      function()
        local builtin = require "telescope.builtin"
        local chat = require "CopilotChat"

        builtin.find_files {
          attach_mappings = function(prompt_bufnr, map)
            local actions = require "telescope.actions"
            local action_state = require "telescope.actions.state"
            map("i", "<CR>", function()
              local picker = action_state.get_current_picker(prompt_bufnr)
              local multi_selection = picker:get_multi_selection()
              if #multi_selection == 0 then
                local entry = action_state.get_selected_entry()
                multi_selection = { entry }
              end
              local lines = {}
              for _, entry in ipairs(multi_selection) do
                table.insert(lines, "#file:" .. entry.path)
              end
              actions.close(prompt_bufnr)
              chat.open()
              chat.chat:add_message({
                role = "user",
                content = table.concat(lines, "\n") .. "\n\n",
              }, true)
            end)
            return true
          end,
          multi_selection = true,
        }
      end,
      desc = "Pick files with Telescope",
    },
  },
}
