local dedent = require("utils.dedent")

local system_prompt = dedent([[
  You are Jarvis — a personal AI engineering assistant.
  Your purpose is to mentor and guide r4ppz toward becoming a professional software engineer.

  User Profile
  - Name: r4ppz
  - Currently studying: BSIT (IT Student)
  - Goal: Become a software engineer and build real-world software projects
  - Operating System: Arch Linux (Hyprland)
  - Comfortable with CLI, Linux configs, and custom workflows (love ricing)

  Personality & Style
  - Speak like a **senior software engineer + mentor**
  - Be direct, honest, and helpful. Don't sugarcoat mistakes.
  - Encourage **deeper thinking**, ask clarifying questions when needed.
  - When giving explanations, **use real engineering logic**, not fluff.
  - Use **technical language properly**. Prefer depth over simplicity.
  - If code or logic is flawed, point it out **bluntly but constructively**.

  Response Rules
  - Always explain reasoning and trade-offs.
  - Prefer examples and better design suggestions.
  - If the question is unclear, ask for missing details before answering.
  - Provide step-by-step guidance** when teaching.
  - When giving code:
    - Use clean, modern, and production-ready standards
    - Include comments only when necessary
    - Avoid unnecessary dependencies
  - If a tool, library, or framework is not ideal, recommend a better alternative.
  - For errors: diagnose, explain root cause, propose fix.
  - If asked "Who are you?" → reply: `"I am Jarvis, your personal AI engineering assistant."`

  Your mission: Make r4ppz a better engineer every day.
  Act like a real programming partner. Think critically. Teach with purpose.

  The user works in editor called Neovim which has these core concepts:
  - Buffer: An in-memory text content that may be associated with a file
  - Window: A viewport that displays a buffer
  - Tab: A collection of windows
  - Quickfix/Location lists: Lists of positions in files, often used for errors or search results
  - Registers: Named storage for text and commands (like clipboard)
  - Normal/Insert/Visual/Command modes: Different interaction states
  - LSP (Language Server Protocol): Provides code intelligence features like completion diagnostics, and code actions
  - Treesitter: Provides syntax highlighting, code folding, and structural text editing based on syntax tree parsing
  - Visual selection: Text selected in visual mode that can be shared as context
  The user is working on a Arch Linux machine. Please respond with system specific commands if
  applicable.
  The user is currently in workspace directory {DIR} (project root). File paths are relative to this
  directory.

  Context is provided to you in several ways:
  - Resources: Contextual data shared via "# <uri>" headers and referenced via "##<uri>" links
  - Code blocks with file path labels and line numbers (e.g., ```lua path=/file.lua start_line=1 end_line=10```)

  Note: Each line in code block can be prefixed with <line_number>: for your reference only. NEVER
  include these line numbers in your responses.
  - Visual selections: Text selected in visual mode that can be shared as context
  - Diffs: Changes shown in unified diff format (+, -, etc.)
  - Conversation history

  When resources (like buffers, files, or diffs) change, their content in the chat history is
  replaced with the latest version rather than appended as new data.
  ]])

local prompts = {
  ExplainV2 = {
    prompt = dedent([[
      #selection
      Provide a detailed explanation of the selected code.
      - Include syntax, semantics, conventions, and idioms.
      - Explain what each construct does and why it’s used.
      - Clarify both intent and behavior precisely.
    ]]),
    description = "Explicate code syntax",
  },

  ExplainHighLevel = {
    prompt = dedent([[
      #selection
      #buffer (additional context)
      Provide a **high-level conceptual explanation** of the selected code in [language/framework]:
      - Summarize its overall purpose and role in the broader application or system.
      - Describe the main logical flow and major components or modules.
      - Explain its design intent and how it fits into common architectural or usage patterns.
      - Avoid syntax-level details; focus on design, purpose, and interactions.
    ]]),
    description = "Explain code conceptually",
  },

  Explain = {
    prompt = dedent([[
      #selection
      #buffer (additional context)
      Provide a **mid-level explanation** of the selected code in [language/framework]:
      - Describe its functionality and logical flow for a competent programmer.
      - Explain how each major construct or function contributes to behavior.
      - Highlight important syntax, patterns, and idioms without excessive granularity.
      - Clarify both **what** the code does and **how** it achieves that behavior.
    ]]),
    description = "Explain code at an intermediate",
  },

  ExplainLowLevel = {
    prompt = dedent([[
      #selection
      #buffer (additional context)
      Provide a **low-level, technical explanation** of the selected code in [language/framework]:
      - Break down syntax, expressions, and control flow line by line.
      - Explain semantics, runtime behavior, and evaluation order.
      - Discuss data types, structures, and their interactions in detail.
      - Highlight idioms, pitfalls, and low-level implementation effects.
    ]]),
    description = "Explain code line-by-line",
  },

  Review = {
    prompt = dedent([[
      #selection (preferred)
      #buffer (additional context)
      Perform a **comprehensive code review**:
      - Identify issues and reference specific lines.
      - Categorize findings by severity (Critical / Warning / Suggestion).
      - Evaluate correctness, safety, readability, and maintainability.
      - Suggest concrete fixes or improvements with brief explanations.
    ]]),
    description = "Perform a detailed review",
  },

  Fix = {
    prompt = dedent([[
      #buffers
      #diagnostics:current
      Identify and fix all issues in the given code.
      - List each issue clearly and explain why it’s a problem.
      - Provide corrected code with modern, idiomatic improvements.
      - Justify each fix concisely with technical reasoning.
      - Prioritize correctness, maintainability, and clarity.
      - If multiple solutions exist, choose the safest and most maintainable approach.
    ]]),
    description = "Find, explain, and fix code issues",
  },

  Optimize = {
    prompt = dedent([[
      #buffer
      Optimize the given code for performance and clarity.
      - Identify inefficiencies or redundant operations.
      - Suggest algorithmic or structural improvements.
      - Provide before/after examples with trade-offs explained.
      - Ensure optimizations do not compromise readability or maintainability.
    ]]),
    description = "Optimize code",
  },

  Docs = {
    prompt = dedent([[
      #selection
      Write short and accurate documentation for the given code:
      - Follow conventions of [language/framework].
    ]]),
    description = "Generate documentation comments",
  },

  Tests = {
    prompt = dedent([[
      #selection
      Generate tests for the given code:
      - Cover normal, edge, and error cases.
      - Use the standard testing framework for [language/framework].
      - Ensure tests are maintainable, clear, and logically structured.
      - Include setup/teardown if necessary.
    ]]),
    description = "Generate tests for the selected code",
  },

  Commit = {
    prompt = dedent([[
      #gitstatus
      #gitdiff:staged
      Write a commit message following **Conventional Commit** conventions:
      - Use type prefixes like `feat`, `fix`, `docs`, `style`, `refactor`, `test`, or `chore`.
      - Write a concise, imperative subject line (≤ 72 characters).
      - Add an optional detailed body if necessary.
      - Reference issues or PRs when applicable.
      - If changes are unrelated, suggest splitting commits.
    ]]),
    description = "Generate commit messages",
  },

  Idiomatic = {
    prompt = dedent([[
      #selection (preferred)
      #buffer (additional context)
      Review the given code for idiomatic style and conventions:
      - Assess adherence to community standards and best practices.
      - Identify non-idiomatic constructs and suggest more conventional alternatives.
      - Explain briefly why each alternative is preferred.
    ]]),
    description = "Suggest idiomatic improvements",
  },

  Suggest = {
    prompt = dedent([[
      #selection (preferred)
      #buffer (additional context)
      Suggest alternative implementations or designs for the given code:
      - Consider readability, safety, maintainability, and performance.
      - Propose concrete alternative examples with short reasoning.
      - Discuss trade-offs and migration complexity when relevant.
    ]]),
    description = "Suggest alternative implementations",
  },

  Diagnostic = {
    prompt = dedent([[
      #diagnostics:current (preferred)
      #buffer (additional context)
      Analyze diagnostics and source code:
      - List issues by severity.
      - Explain root causes and contributing factors.
      - Show specific fixes and demonstrate corrected code.
      - Suggest preventive best practices to avoid similar issues.
    ]]),
    description = "Analyze diagnostic data",
  },

  Refactor = {
    prompt = dedent([[
      #selection
      Refactor the given code for better structure and maintainability:
      - Improve naming, modularity, and organization.
      - Eliminate redundancy, tight coupling, or unnecessary complexity.
      - Preserve the original behavior and functionality.
      - Apply clean code principles and idiomatic patterns.
      - Ensure the refactored code is easier to read, test, and extend.
    ]]),
    description = "Refactor code",
  },
}

return {
  prompts = prompts,
  system_prompt = system_prompt,
}
