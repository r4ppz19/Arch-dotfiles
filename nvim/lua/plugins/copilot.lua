return {
	"CopilotC-Nvim/CopilotChat.nvim",
	branch = "main",
	dependencies = {
		"zbirenbaum/copilot.lua",
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
	build = "make tiktoken",
	opts = {
		-- model = "grok-code-fast-1",
		model = "gpt-4.1",
		temperature = 0.1,
		window = {
			layout = "vertical",
			width = 0.4,
		},

		headers = {
			user = " ",
			assistant = "󱚝 ",
			tool = " Tool",
		},

		separator = "─",
		auto_fold = false,
		auto_insert_mode = false,

		prompts = {
			Idiomatic = {
				prompt = "Please review this code for idiomatic usage in [language/framework]. Does it follow common conventions, style, and best practices?",
				system_prompt = "You are an expert in idiomatic programming for [language/framework]. Explain whether the code is idiomatic and why.",
				mapping = "<leader>ci",
				description = "Check if code is idiomatic",
			},
			Explain = {
				prompt = "Please explain what this code does in [language/framework]. Summarize its functionality and purpose.",
				system_prompt = "You are very good at explaining concepts clearly. Explain the code as if teaching someone familiar with programming but not this exact code.",
				mapping = "<leader>ce",
				description = "Explain code behavior",
			},
			ExplainSyntax = {
				prompt = "Please explain this code in [language/framework], focusing on syntax. Break down each construct, keyword, and operator.",
				system_prompt = "You are very good at explaining syntax. Go through the code line by line, explaining how the syntax works.",
				mapping = "<leader>cE",
				description = "Explain code with syntax details",
			},
			Fix = {
				prompt = "Please review this code in [language/framework] and fix any errors, bugs, or incorrect usage.",
				system_prompt = "You are a skilled debugger and language expert. Correct mistakes and explain the fixes.",
				mapping = "<leader>cf",
				description = "Fix errors in code",
			},
			Suggest = {
				prompt = "Please suggest alternative approaches or techniques for this code in [language/framework].",
				system_prompt = "You are an experienced developer. Suggest more efficient, safer, or more maintainable alternatives.",
				mapping = "<leader>cs",
				description = "Suggest alternatives",
			},
			Improve = {
				prompt = "Please refactor and improve this code in [language/framework] for readability, maintainability, or performance.",
				system_prompt = "You are a clean code expert. Improve the structure, readability, or performance of the code without changing its functionality.",
				mapping = "<leader>cI",
				description = "Improve and refactor code",
			},
			Optimize = {
				prompt = "Please analyze this code in [language/framework] for performance bottlenecks. Suggest or implement optimizations while preserving functionality.",
				system_prompt = "You are a performance tuning expert. Focus on algorithmic complexity, memory usage, and runtime speed.",
				mapping = "<leader>co",
				description = "Find and apply performance optimizations",
			},
			Security = {
				prompt = "Please review this code for potential security vulnerabilities, unsafe practices, or common attack vectors in [language/framework].",
				system_prompt = "You are a security expert. Identify vulnerabilities, explain risks, and suggest secure alternatives.",
				mapping = "<leader>cS",
				description = "Check code for security issues",
			},
			Tests = {
				prompt = "Please generate unit tests for this code in [language/framework]. Use common testing frameworks and cover normal, edge, and error cases.",
				system_prompt = "You are an expert in test-driven development. Write clean, idiomatic unit tests for this code.",
				mapping = "<leader>cT",
				description = "Generate unit tests",
			},
			Docs = {
				prompt = "Please generate documentation or docstrings for this code in [language/framework].",
				system_prompt = "You are an expert technical writer. Write clear and concise docstrings that explain purpose, parameters, return values, and usage.",
				mapping = "<leader>cd",
				description = "Generate documentation/docstrings",
			},
			Complexity = {
				prompt = "Please analyze the cyclomatic complexity and readability of this code in [language/framework]. Suggest how to simplify it.",
				system_prompt = "You are a code analysis expert. Explain complexity metrics and provide suggestions for simplification.",
				mapping = "<leader>cC",
				description = "Analyze code complexity",
			},
			DebugExplain = {
				prompt = "Please simulate the execution of this code step by step in [language/framework]. Show how variables change and how control flow progresses.",
				system_prompt = "You are an excellent debugger. Walk through the execution path in detail.",
				mapping = "<leader>cD",
				description = "Explain code execution step by step",
			},
		},
	},

	keys = {
		{ "<leader>ci", mode = { "n", "v" }, desc = "Check if code is idiomatic" },
		{ "<leader>ce", mode = { "n", "v" }, desc = "Explain code behavior" },
		{ "<leader>cE", mode = { "n", "v" }, desc = "Explain code with syntax details" },
		{ "<leader>cf", mode = { "n", "v" }, desc = "Fix errors in code" },
		{ "<leader>cs", mode = { "n", "v" }, desc = "Suggest alternatives" },
		{ "<leader>cI", mode = { "n", "v" }, desc = "Improve and refactor code" },
		{ "<leader>co", mode = { "n", "v" }, desc = "Find and apply performance optimizations" },
		{ "<leader>cS", mode = { "n", "v" }, desc = "Check code for security issues" },
		{ "<leader>cT", mode = { "n", "v" }, desc = "Generate unit tests" },
		{ "<leader>cd", mode = { "n", "v" }, desc = "Generate documentation/docstrings" },
		{ "<leader>cC", mode = { "n", "v" }, desc = "Analyze code complexity" },
		{ "<leader>cD", mode = { "n", "v" }, desc = "Explain code execution step by step" },

		{ "<leader>cp", "<cmd>CopilotChatPrompts<cr>", mode = { "n", "v" }, desc = "View/select Prompt" },
		{ "<leader>ct", "<cmd>CopilotChatToggle<cr>", mode = { "n", "v" }, desc = "Toggle CopilotChat" },
		{ "<leader>cr", "<cmd>CopilotChatReset<cr>", mode = "n", desc = "Reset CopilotChat" },

		{
			"<leader>ca",
			function()
				local chat = require("CopilotChat")
				chat.open()
				chat.chat:add_message({
					role = "user",
					content = "#buffers\n\n",
				}, true)
			end,
			mode = { "n", "v" },
			desc = "Open chat with all buffer",
		},

		{
			"<leader>cc",
			function()
				local chat = require("CopilotChat")
				chat.open()
				chat.chat:add_message({
					role = "user",
					content = "#buffer\n\n",
				}, true)
			end,
			mode = { "n", "v" },
			desc = "Open chat with current buffer",
		},
	},
}
