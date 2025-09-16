return {
	"nvim-java/nvim-java",
	dependencies = {
		"nvim-java/lua-async-await",
		"nvim-java/nvim-java-refactor",
		"nvim-java/nvim-java-core",
		"nvim-java/nvim-java-test",
		"nvim-java/nvim-java-dap",
		"MunifTanjim/nui.nvim",
		"neovim/nvim-lspconfig",
		"mfussenegger/nvim-dap",
		{
			"JavaHello/spring-boot.nvim",
			commit = "218c0c26c14d99feca778e4d13f5ec3e8b1b60f0",
		},
		{
			"mason-org/mason.nvim",
			opts = {
				registries = {
					"github:nvim-java/mason-registry",
					"github:mason-org/mason-registry",
				},
			},
		},
	},
	ft = { "java" },
	config = function()
		-- Setup nvim-java before lspconfig
		require("java").setup({
			-- Configuration options
			notifications = {
				dap = true,
			},
			verification = {
				invalid_order = true,
				duplicate_setup_calls = true,
				invalid_mason_registry = false,
			},
			jdk = {
				auto_install = false,
			},
		})

		-- Setup jdtls through lspconfig after nvim-java setup
		local lspconfig = require("lspconfig")
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- LSP keybindings function
		local function on_attach(_, bufnr)
			local map = vim.keymap.set

			-- Use LspUI commands instead of default LSP functions
			map("n", "K", "<cmd>LspUI hover<CR>", { buffer = bufnr, desc = "Hover Doc" })
			map("n", "gd", "<cmd>LspUI definition<CR>", { buffer = bufnr, desc = "Goto Definition" })
			map("n", "gi", "<cmd>LspUI implementation<CR>", { buffer = bufnr, desc = "Goto Implementation" })
			map("n", "gt", "<cmd>LspUI type_definition<CR>", { buffer = bufnr, desc = "Goto Type Definition" })
			map("n", "<leader>lr", "<cmd>LspUI reference<CR>", { buffer = bufnr, desc = "LSP References" })
			map("n", "<leader>la", "<cmd>LspUI code_action<CR>", { buffer = bufnr, desc = "Code Action" })
			map("n", "<leader>lI", "<cmd>LspUI inlay_hint<CR>", { buffer = bufnr, desc = "Toggle Inlay Hints" })
			map(
				"n",
				"<leader>lci",
				"<cmd>LspUI call_hierarchy incoming_calls<CR>",
				{ buffer = bufnr, desc = "Incoming Calls" }
			)
			map(
				"n",
				"<leader>lco",
				"<cmd>LspUI call_hierarchy outgoing_calls<CR>",
				{ buffer = bufnr, desc = "Outgoing Calls" }
			)

			-- Default LSP functions
			map("n", "<leader>lh", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature Help" })
			map("i", "<C-k>", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature Help" })
			map("n", "<leader>ln", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename Symbol" })
			map("n", "<leader>lq", vim.diagnostic.setloclist, { desc = "Diagnostics: Set Loclist" })
			map("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr, desc = "Next Diagnostic" })
			map("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr, desc = "Prev Diagnostic" })

			-- Telescope for symbols and diagnostics
			local tb = require("telescope.builtin")
			map("n", "<leader>ls", tb.lsp_document_symbols, { buffer = bufnr, desc = "LSP Document Symbols" })
			map("n", "<leader>lS", tb.lsp_workspace_symbols, { buffer = bufnr, desc = "LSP Workspace Symbols" })
			map("n", "<leader>ld", tb.diagnostics, { buffer = bufnr, desc = "Diagnostics" })

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

			-- Spring Boot keybindings (using Telescope/FzfLua for Spring symbols)
			map(
				"n",
				"<leader>jsb",
				"<cmd>Telescope lsp_workspace_symbols<CR>",
				{ buffer = bufnr, desc = "Spring Boot: Find Beans" }
			)
			map(
				"n",
				"<leader>jse",
				"<cmd>Telescope lsp_workspace_symbols<CR>",
				{ buffer = bufnr, desc = "Spring Boot: Find Endpoints" }
			)

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
		lspconfig.jdtls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				java = {
					configuration = {
						runtimes = {
							{
								name = "JavaSE-21",
								path = "/usr/lib/jvm/java-21-openjdk",
								default = true,
							},
						},
					},
				},
			},
		})
	end,
}
