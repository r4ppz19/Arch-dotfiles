return {
	"nvim-java/nvim-java",
	ft = { "java" },
	config = function()
		require("java").setup({
			root_markers = {
				"settings.gradle",
				"settings.gradle.kts",
				"pom.xml",
				"build.gradle",
				"mvnw",
				"gradlew",
				"build.gradle",
				"build.gradle.kts",
				".git",
			},

			spring_boot_tools = {
				enable = true,
				version = "1.59.0",
			},

			jdk = {
				auto_install = true,
				version = "21",
			},

			notifications = {
				dap = true,
			},

			verification = {
				invalid_order = true,
				duplicate_setup_calls = true,
				invalid_mason_registry = false,
			},

			mason = {
				registries = {
					"github:nvim-java/mason-registry",
				},
			},
		})

		-- Setup jdtls through lspconfig after nvim-java setup
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- LSP keybindings function
		local function on_attach(_, bufnr)
			local map = vim.keymap.set
			local tb = require("telescope.builtin")
			local themes = require("telescope.themes")

			-- Use Telescope LSP pickers
			map("n", "gd", tb.lsp_definitions, { buffer = bufnr, desc = "Goto Definition" })
			map("n", "gi", tb.lsp_implementations, { buffer = bufnr, desc = "Goto Implementation" })
			map("n", "gt", tb.lsp_type_definitions, { buffer = bufnr, desc = "Goto Type Definition" })
			map("n", "<leader>ls", tb.lsp_document_symbols, { buffer = bufnr, desc = "LSP Document Symbols" })
			map("n", "<leader>lS", tb.lsp_workspace_symbols, { buffer = bufnr, desc = "LSP Workspace Symbols" })
			map("n", "<leader>ld", function()
				tb.diagnostics(themes.get_dropdown({
					previewer = false,
					layout_config = {
						width = 0.7,
						height = 0.7,
					},
					prompt_title = "Diagnostics",
					include_declaration = true,
				}))
			end, { buffer = bufnr, desc = "Diagnostics" })
			map("n", "<leader>lr", function()
				tb.lsp_references({
					jump_type = "never",
				})
			end, { buffer = bufnr, desc = "LSP References (Dropdown)" })

			-- LSP functions
			map("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover Doc" })
			map("n", "<leader>la", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code Action" })
			map("n", "<leader>lh", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature Help" })
			map("i", "<C-k>", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature Help" })
			map("n", "<leader>ln", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename Symbol" })
			map("n", "<leader>lq", vim.diagnostic.setloclist, { desc = "Diagnostics: Set Loclist" })
			map("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr, desc = "Next Diagnostic" })
			map("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr, desc = "Prev Diagnostic" })

			-- Java runner keybindings
			map("n", "<leader>jrc", "<cmd>JavaRunnerRunMain<CR>", { buffer = bufnr, desc = "Java: Run Main Class" })
			map("n", "<leader>jrs", "<cmd>JavaRunnerStopMain<CR>", { buffer = bufnr, desc = "Java: Stop Main" })
			map("n", "<leader>jrl", "<cmd>JavaRunnerToggleLogs<CR>", { buffer = bufnr, desc = "Java: Toggle Logs" })
			map(
				"n",
				"<leader>jtc",
				"<cmd>JavaTestRunCurrentClass<CR>",
				{ buffer = bufnr, desc = "Java: Test Current Class" }
			)
			map(
				"n",
				"<leader>jtm",
				"<cmd>JavaTestRunCurrentMethod<CR>",
				{ buffer = bufnr, desc = "Java: Test Current Method" }
			)
			map(
				"n",
				"<leader>jtd",
				"<cmd>JavaTestDebugCurrentClass<CR>",
				{ buffer = bufnr, desc = "Java: Debug Test Class" }
			)
			map(
				"n",
				"<leader>jtr",
				"<cmd>JavaTestViewLastReport<CR>",
				{ buffer = bufnr, desc = "Java: View Test Report" }
			)
			map("n", "<leader>jp", "<cmd>JavaProfile<CR>", { buffer = bufnr, desc = "Java: Profiles" })

			-- Java build commands (using Lua APIs)
			map("n", "<leader>jbw", function()
				require("java").build.build_workspace()
			end, { buffer = bufnr, desc = "Java: Build Workspace" })
			map("n", "<leader>jbc", function()
				require("java").build.clean_workspace()
			end, { buffer = bufnr, desc = "Java: Clean Workspace" })

			-- Java refactoring keybindings (using Lua APIs)
			map("n", "<leader>jfv", function()
				require("java").refactor.extract_variable()
			end, { buffer = bufnr, desc = "Java: Extract Variable" })
			map("n", "<leader>jfa", function()
				require("java").refactor.extract_variable_all_occurrence()
			end, { buffer = bufnr, desc = "Java: Extract Variable All" })
			map("n", "<leader>jfc", function()
				require("java").refactor.extract_constant()
			end, { buffer = bufnr, desc = "Java: Extract Constant" })
			map("n", "<leader>jfm", function()
				require("java").refactor.extract_method()
			end, { buffer = bufnr, desc = "Java: Extract Method" })
			map("n", "<leader>jff", function()
				require("java").refactor.extract_field()
			end, { buffer = bufnr, desc = "Java: Extract Field" })

			-- Spring Boot keybindings (using Telescope for Spring symbols)
			map("n", "<leader>jsb", tb.lsp_workspace_symbols, { buffer = bufnr, desc = "Spring Boot: Find Beans" })
			map("n", "<leader>jse", tb.lsp_workspace_symbols, { buffer = bufnr, desc = "Spring Boot: Find Endpoints" })

			-- Maven build keybindings
			map("n", "<leader>jmc", "<cmd>!mvn clean<CR>", { buffer = bufnr, desc = "Maven: Clean" })
			map("n", "<leader>jmi", "<cmd>!mvn install<CR>", { buffer = bufnr, desc = "Maven: Install" })
			map("n", "<leader>jmp", "<cmd>!mvn package<CR>", { buffer = bufnr, desc = "Maven: Package" })
			map("n", "<leader>jmt", "<cmd>!mvn test<CR>", { buffer = bufnr, desc = "Maven: Test" })
			map(
				"n",
				"<leader>jmr",
				"<cmd>!mvn spring-boot:run<CR>",
				{ buffer = bufnr, desc = "Maven: Spring Boot Run" }
			)

			-- Gradle build keybindings
			map("n", "<leader>jgc", "<cmd>!./gradlew clean<CR>", { buffer = bufnr, desc = "Gradle: Clean" })
			map("n", "<leader>jgb", "<cmd>!./gradlew build<CR>", { buffer = bufnr, desc = "Gradle: Build" })
			map("n", "<leader>jgt", "<cmd>!./gradlew test<CR>", { buffer = bufnr, desc = "Gradle: Test" })
			map("n", "<leader>jgr", "<cmd>!./gradlew bootRun<CR>", { buffer = bufnr, desc = "Gradle: Boot Run" })

			-- Java settings keybindings
			map(
				"n",
				"<leader>jcr",
				"<cmd>JavaSettingsChangeRuntime<CR>",
				{ buffer = bufnr, desc = "Java: Change Runtime" }
			)
		end

		-- Setup jdtls with nvim-java
		require("lspconfig").jdtls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})
	end,
}
