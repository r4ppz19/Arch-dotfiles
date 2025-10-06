local function dedent(str)
  str = str:gsub("^\n", "")
  local indent = str:match "\n([ \t]+)%S"
  if not indent then
    return str
  end
  return str:gsub("\n" .. indent, "\n")
end

return {
  "CopilotC-Nvim/CopilotChat.nvim",
  branch = "main",
  lazy = true,
  build = "make tiktoken || true",
  dependencies = {
    {
      "zbirenbaum/copilot.lua",
      event = "InsertEnter",
      config = function()
        require("copilot").setup {
          suggestion = { enabled = false },
          panel = { enabled = false },
        }
      end,
      dependencies = {
        {
          "zbirenbaum/copilot-cmp",
          config = function()
            require("copilot_cmp").setup()
          end,
        },
      },
    },
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
  },

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
      ExplainHighLevel = {
        prompt = dedent [[
          #selection
          Give a **high-level explanation** of what this code does in [language/framework]:
          - Summarize the overall purpose and role of this code
          - Describe the logic flow and main components
          - Explain how this fits into typical usage patterns or architecture
          - Avoid excessive syntax detail — focus on intent and design
        ]],
        system_prompt = dedent [[
          You are an expert software engineer explaining the conceptual purpose of this code.
          Assume the reader knows general programming principles but not this language or framework.
          Be technical, structured, and concise. Prioritize clarity over depth.
          Use markdown sections like **Purpose**, **Flow**, and **Concepts**.
        ]],
        description = "Explain code at a high level",
      },

      ExplainLowLevel = {
        prompt = dedent [[
          #selection
          Give a **low-level explanation** of this code in [language/framework]:
          - Break down syntax and keywords line by line or block by block
          - Clarify how the language’s semantics influence behavior
          - Explain runtime effects, data flow, and control structures
          - Mention language-specific idioms, conventions, or pitfalls
        ]],
        system_prompt = dedent [[
          You are an expert explainer focusing on the fine details of this code.
          The reader knows general programming, but not this specific language.
          Be precise, technical, and explicit about what each part does.
          Use markdown sections like **Syntax Breakdown**, **Execution Flow**, and **Language Notes**.
        ]],
        description = "Explain code at a low level",
      },

      Explain = {
        prompt = dedent [[
          #selection
          Provide a **mid-level explanation** of this code in [language/framework]:
          - Describe the functionality and logical flow
          - Explain how each major construct or section contributes to the result
          - Mention key syntax and language features where relevant, but don’t explain every token
          - Highlight important patterns, idioms, or design choices
          - Clarify both the “what” (behavior) and “how” (mechanics) at a practical depth
        ]],
        system_prompt = dedent [[
          You are an experienced developer explaining code to another competent programmer unfamiliar with this language.
          Focus on the logic and implementation details at a practical level — not too abstract, not too granular.
          Explain purpose, structure, and relevant syntax with clarity.
          Use markdown sections like **Overview**, **Logic Flow**, **Key Constructs**, and **Notes**.
        ]],
        description = "Explain code at a balanced depth",
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
    -- Idiomatic check
    { "<leader>ci", "<cmd>CopilotChatIdiomatic<cr>", mode = { "n", "v" }, desc = "Check if code is idiomatic" },

    -- Explain
    { "<leader>ce", "<cmd>CopilotChatExplain<cr>", mode = { "n", "v" }, desc = "Explain code" },

    -- Suggest alternatives
    { "<leader>cs", "<cmd>CopilotChatSuggest<cr>", mode = { "n", "v" }, desc = "Suggest alternatives" },

    -- Toggle chat
    { "<M-c>", "<cmd>CopilotChatToggle<cr>", mode = { "n", "v" }, desc = "Toggle CopilotChat" },

    -- View/select prompt templates
    {
      "<leader>cp",
      function()
        local chat = require "CopilotChat"
        chat.open()
        chat.select_prompt()
      end,
      mode = { "n", "v" },
      desc = "View/select prompt templates",
    },

    -- Open chat with current buffer
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

    -- Open chat with all buffers
    {
      "<leader>ca",
      function()
        local chat = require "CopilotChat"
        chat.open()
        chat.chat:add_message({ role = "user", content = "#buffers\n\n" }, true)
      end,
      mode = { "n", "v" },
      desc = "Open chat with all buffers",
    },

    -- Workspace scan for React/TS/CSS stacks
    {
      "<leader>cw",
      function()
        local chat = require "CopilotChat"
        chat.open()
        chat.chat:add_message({
          role = "user",
          content = table.concat({
            "#glob:**/*.{ts,tsx,js,jsx,json,css,scss,less,sass,html,md}",
            "",
            "#exclude:node_modules/**",
            "#exclude:.next/**",
            "#exclude:dist/**",
            "#exclude:build/**",
            "#exclude:coverage/**",
            "#exclude:.git/**",
          }, "\n"),
        }, true)
      end,
      mode = { "n" },
      desc = "Full codebase scan + architecture summary (React+TS+CSS)",
    },

    -- Pick files with Telescope and feed them as #file: paths
    {
      "<leader>cf",
      function()
        local builtin = require "telescope.builtin"
        local actions = require "telescope.actions"
        local action_state = require "telescope.actions.state"
        local chat = require "CopilotChat"

        builtin.find_files {
          attach_mappings = function(prompt_bufnr, map)
            local run = function()
              local picker = action_state.get_current_picker(prompt_bufnr)
              local multi = picker:get_multi_selection()
              if #multi == 0 then
                local entry = action_state.get_selected_entry()
                multi = { entry }
              end
              local lines = {}
              for _, entry in ipairs(multi) do
                table.insert(lines, "#file:" .. entry.path)
              end
              actions.close(prompt_bufnr)
              chat.open()
              chat.chat:add_message({
                role = "user",
                content = table.concat(lines, "\n") .. "\n\n",
              }, true)
            end

            -- Replace default <CR> in both insert and normal modes
            map("i", "<CR>", run)
            map("n", "<CR>", run)
            return true
          end,
        }
      end,
      desc = "Pick files with Telescope",
    },
  },
}
