local dedent = require("utils.dedent")

local system_prompt = dedent([[
  You are Jarvis — a personal AI engineering assistant.
  Your purpose is to mentor and guide **r4ppz** toward becoming a professional software engineer.

  User Profile
  - Name: r4ppz
  - Student: BSIT
  - Goal: Become a software engineer and build real-world projects
  - OS: Arch Linux (Hyprland)
  - Strong with CLI and Linux workflows
  - Uses Neovim as primary editor

  Personality & Mentorship Style
  - Speak like a **senior software engineer who mentors junior engineers on real teams**.
  - Be direct, honest, and technically rigorous.
  - Do not sugarcoat mistakes or uncertainties.
  - Prioritize correctness, clarity, and engineering reasoning.
  - Encourage deeper thinking and highlight trade-offs.
  - Challenge flawed assumptions constructively.
  - When the user lacks details, **ask only when those details materially affect correctness**.

  Response Rules
  - Simple questions (syntax, meaning) → answer briefly and directly.
  - Complex questions → provide reasoning, trade-offs, and alternatives.
  - When teaching:
    • Use realistic engineering logic, not superficial analogies.
    • Provide concise examples when they add clarity.
    • Clarify why one approach is better than another.
  - When giving code:
    • Use clean, modern, production-ready practices.
    • Include comments only when necessary.
    • Avoid unnecessary dependencies; suggest better options when relevant.
  - When diagnosing errors:
    • Identify the root cause.
    • Explain why it happened.
    • Propose a correct and maintainable fix.
  - If asked “Who are you?” → reply: “I am Jarvis, your personal AI engineering assistant.”

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
  ExplainHighLevel = {
    prompt = dedent([[
      #selection
      #buffer (additional context)
      Provide a **high-level conceptual explanation** of the selected code in [language/framework].

      Requirements:
      • Explain the code’s purpose, responsibilities, and role in the broader system **based only on visible context**.
      • Summarize the main logical flow and major interacting components.
      • Describe design intent and how it relates to common architectural or usage patterns.
      • Avoid syntax-level or token-level details.

      Constraints:
      • Do not invent context not inferable from the snippet.
      • Do not restate the code.
    ]]),
    description = "Explain code conceptually",
  },

  Explain = {
    prompt = dedent([[
      #selection
      Provide a **short, simple, and direct explanation** of the selected code in [language/framework].

      Requirements:
      • Explain the syntax and the purpose.
      • Keep the explanation brief and factual.
    ]]),
    description = "Explain code, short and simple",
  },

  ExplainLowLevel = {
    prompt = dedent([[
      #selection
      #buffer (additional context)
      Provide a **low-level, line-by-line technical explanation** of the selected code.

      Requirements:
      • Break down each line’s syntax, operators, expressions, and control-flow constructs.
      • Explain semantics, evaluation order, and runtime behavior strictly based on the code.
      • Identify data types, memory usage patterns, and how values flow between statements.
      • Note idioms, edge cases, and pitfalls visible in the snippet.

      Constraints:
      • No speculation about compilers, VMs, or runtime environments beyond what is inferable.
      • No examples, rewrites, or improvements unless the snippet contains an objective error.
      • Do not restate the code.
      • Avoid general tutorials.
    ]]),
    description = "Explain code line-by-line at a low-level",
  },

  Review = {
    prompt = dedent([[
      #selection (preferred)
      #buffer (additional context)
      Perform a **comprehensive code review**.

      Requirements:
      • Identify issues and reference specific lines.
      • Categorize findings by severity: Critical / Warning / Suggestion.
      • Evaluate correctness, safety, readability, maintainability, and style.
      • Provide concrete fixes or improvements with concise technical explanations.

      Constraints:
      • Base all analysis strictly on visible code.
      • Do not restate the code.
    ]]),
    description = "Perform a detailed review",
  },

  Fix = {
    prompt = dedent([[
      #buffer:active
      Identify and fix all issues in the given code.

      Requirements:
      • List each issue and explain why it’s a problem.
      • Provide corrected code, using modern and idiomatic conventions.
      • Justify each fix with precise technical reasoning.
      • Prefer solutions that prioritize correctness, maintainability, and clarity.

      Constraints:
      • Do not add features beyond what the original code intends.
    ]]),
    description = "Find, explain, and fix code issues",
  },

  Optimize = {
    prompt = dedent([[
      #buffer
      Optimize the given code for performance and clarity.

      Requirements:
      • Identify inefficiencies or redundant operations.
      • Suggest algorithmic or structural improvements.
      • Provide before/after examples and explain trade-offs.
      • Ensure optimizations do not harm readability or maintainability.

      Constraints:
      • Base recommendations strictly on visible code.
    ]]),
    description = "Optimize code",
  },

  Docs = {
    prompt = dedent([[
      #selection
      Write short, accurate documentation for the given code following conventions of [language/framework].

      Constraints:
      • Do not restate the code; describe its behavior and contract.
    ]]),
    description = "Generate documentation comments",
  },

  Tests = {
    prompt = dedent([[
      #selection
      Generate tests for the given code using the standard testing framework for [language/framework].

      Requirements:
      • Cover normal, edge, and error cases.
      • Ensure test structure is clear, maintainable, and logically organized.
      • Include setup/teardown only when necessary.

      Constraints:
      • Infer behavior strictly from the selected code.
    ]]),
    description = "Generate tests for the selected code",
  },

  Commit = {
    prompt = dedent([[
      #gitstatus
      #gitdiff:staged
      Write a commit message following **Conventional Commit** conventions.

      Requirements:
      • Use the appropriate type prefix (feat, fix, docs, style, refactor, test, chore, etc.).
      • Write a concise imperative subject line (≤ 72 characters).
      • Add an optional detailed body if necessary.
      • Reference issues or PRs when applicable.
      • Suggest splitting commits if changes are unrelated.

      Constraints:
      • Summaries must be accurate to the diff.
    ]]),
    description = "Generate commit messages",
  },

  Idiomatic = {
    prompt = dedent([[
      #selection (preferred)
      #buffer (additional context)
      Review the code for idiomatic style and conventions.

      Requirements:
      • Assess adherence to community standards.
      • Identify non-idiomatic patterns and suggest more conventional alternatives.
      • Briefly explain why each alternative is preferred.

      Constraints:
      • Base suggestions only on visible code and widely accepted conventions.
    ]]),
    description = "Suggest idiomatic improvements",
  },

  Suggest = {
    prompt = dedent([[
      #selection (preferred)
      #buffer (additional context)
      Propose alternative implementations or designs for the given code.

      Requirements:
      • Consider readability, safety, maintainability, and performance.
      • Provide concrete alternative examples with short reasoning.
      • Discuss trade-offs and migration complexity when relevant.

      Constraints:
      • Do not add features not present in the original intent.
    ]]),
    description = "Suggest alternative implementations",
  },

  Diagnostic = {
    prompt = dedent([[
      #buffer:active
      Analyze diagnostics and source code.

      Requirements:
      • List issues by severity.
      • Explain root causes and contributing factors.
      • Provide fixes and corrected code.
      • Suggest practices to prevent similar issues.

      Constraints:
      • Base analysis on diagnostic output and visible code only.
    ]]),
    description = "Analyze diagnostic data",
  },

  Refactor = {
    prompt = dedent([[
      #selection
      Refactor the given code for better structure and maintainability.

      Requirements:
      • Improve naming, modularity, and organization.
      • Remove redundancy or unnecessary complexity.
      • Preserve behavior and functionality.
      • Apply clean code principles and idiomatic patterns.

      Constraints:
      • Do not change semantics or add new features.
    ]]),
    description = "Refactor code",
  },
}

return {
  prompts = prompts,
  system_prompt = system_prompt,
}
