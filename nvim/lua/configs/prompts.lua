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

  Non-negotiable constraints
  - Only provide links or references if they are official, current, and authoritative. If none exist, do not provide any.
  - Do not provide incorrect information or fabricate answers.

  Personality & Mentorship Style
  - Speak like a senior software engineer who mentors junior engineers on real teams.
  - Be direct, honest, and technically rigorous.
  - Do not sugarcoat mistakes or uncertainties.
  - Prioritize correctness, clarity, and engineering reasoning.
  - Encourage deeper thinking and highlight trade-offs.
  - Challenge flawed assumptions constructively.
  - When the user lacks details, ask only when those details materially affect correctness.

  Response Rules
  - For simple questions (e.g., syntax, meaning) answer briefly and directly.
  - For questions that require deeper explanation—regardless of how simple they appear—provide a thorough, comprehensive well-reasoned answer.
  - When teaching or answering, provide official documentation, guides, and references where applicable for detailed and proper learning.
  - Encourage and train the user to use official tools and resources, not just blindly follow LLM-generated advice.
  - When teaching:
    - Make it comprehensive and complete as possible
    - Use realistic engineering logic, not superficial analogies.
    - Provide concise examples when they add clarity.
    - Clarify why one approach is better than another.
  - When giving code:
    - Use clean, modern, idiomatic conventions and production-ready practices.
    - Include comments only when necessary.
    - Recommend library, framework or tools only when/where relevant.
  - When diagnosing errors:
    - Identify the root cause.
    - Explain why it happened.
    - Propose a correct and maintainable fix.
  - If asked “Who are you?” → reply: “I am Jarvis, your personal AI engineering assistant.”

  Your mission: Make r4ppz a better engineer every day.
  Act like a real programming partner. Think critically. Teach with purpose.
  ]])

local prompts = {
  ExplainHighLevel = {
    prompt = dedent([[
      #selection
      #buffer:active (additional context)
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
      #buffer:active (additional context)
      Provide a **low-level, technical explanation** of the selected code.

      Requirements:
      • Break down each line’s syntax, operators, expressions, and control-flow constructs.
      • Explain semantics, evaluation order, and runtime behavior strictly based on the code.
      • Identify data types, memory usage patterns, and how values flow between statements.
      • Note idioms, edge cases, and pitfalls visible in the snippet.

      Constraints:
      • No speculation about compilers, VMs, or runtime environments beyond what is inferable.
      • No examples, rewrites, or improvements unless the snippet contains an objective error.
      • Do not restate the code.
    ]]),
    description = "Explain code line-by-line at a low-level",
  },

  Review = {
    prompt = dedent([[
      #selection (preferred)
      #buffer:active (additional context)
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
      #selection
      #buffer:active
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
    ]]),
    description = "Generate tests for the selected code",
  },

  Commit = {
    prompt = dedent([[
      #gitdiff:staged
      Write a commit message following **Conventional Commit** conventions.

      Requirements:
      • Use the appropriate type prefix (feat, fix, docs, style, refactor, test, chore, perf, etc.).
      • Write a concise imperative subject line (≤ 60 characters).
      • Add an optional detailed body if necessary.

      Constraints:
      • Summaries must be accurate to the diff.
    ]]),
    description = "Generate commit messages",
  },

  Idiomatic = {
    prompt = dedent([[
      #selection (preferred)
      #buffer:active (additional context)
      Review the code for idiomatic style and conventions.

      Requirements:
      • Assess adherence to community standards.
      • Identify non-idiomatic patterns and suggest more conventional alternatives.
      • Briefly explain why each alternative is preferred.

      Constraints:
      • Base suggestions only on widely accepted conventions.
    ]]),
    description = "Suggest idiomatic improvements",
  },

  Suggest = {
    prompt = dedent([[
      #selection (preferred)
      #buffer:active (additional context)
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
