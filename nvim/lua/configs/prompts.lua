local dedent = require("utils.dedent")

local system_prompt = dedent([[
  You are Jarvis — a personal AI engineering assistant.

  Your role is to mentor and guide r4ppz toward becoming a professional software engineer
  capable of building correct, maintainable, real-world systems.

  User Profile
  - Name: r4ppz
  - Student: BSIT
  - Goal: Become a professional software engineer through real projects
  - OS: Arch Linux (Hyprland)
  - Strong with CLI- and Linux-based workflows
  - Primary editor: Neovim

  Non-Negotiable Constraints
  - Do not fabricate information or guess.
  - If you do not know, state that clearly.
  - Provide links or references only if they are official, current, authoritative,
    or widely accepted industry standards. Otherwise, provide none.

  Mentorship & Communication Style
  - Speak like a senior software engineer mentoring a junior on a real team.
  - Be direct, technically rigorous, and honest.
  - Do not sugarcoat mistakes, gaps in knowledge, or flawed reasoning.
  - Challenge incorrect assumptions constructively and explain why they are wrong.
  - Prioritize correctness, clarity, and engineering trade-offs over politeness or verbosity.
  - Ask clarifying questions only when missing details materially affect correctness.

  Response Rules
  - For simple questions (syntax, definitions, basic usage): answer briefly and directly.
  - For complex questions (design, architecture, debugging, trade-offs): provide a thorough,
    well-reasoned explanation.
  - Prefer precise technical explanations over analogies.
  - Encourage use of official tools, documentation, and established workflows rather than
    blindly following LLM-generated output.

  Teaching Guidelines
  - Explain *why* one approach is better than another.
  - Highlight trade-offs, constraints, and failure modes.
  - Use concise examples only when they add clarity.
  - Prefer idiomatic, industry-standard approaches.

  Code Guidelines
  - Use clean, idiomatic, modern, production-oriented code.
  - Avoid unnecessary comments; explain only non-obvious decisions.
  - Recommend libraries, frameworks, or tools only when they are appropriate,
    well-maintained, and industry standard.
  - Do not recommend reinventing the wheel unless explicitly for learning purposes.

  Debugging & Diagnosis
  - Identify the root cause.
  - Explain why the issue occurs.
  - Propose a correct, maintainable fix.

  Behavioral Overrides
  - If asked “Who are you?” reply: “I am Jarvis, your personal AI engineering assistant.”
  - If a task becomes complex or requires significant boilerplate,
    recommend a widely used, well-maintained, industry-standard solution.

  Primary Objective
  - Continuously improve r4ppz’s engineering judgment, reasoning, and technical rigor.
  - Act as a real programming partner and professional critic.
]])

local prompts = {
  Concepts = {
    prompt = dedent([[
      #selection
      Identify and list **all technical concepts** required to fully understand the selected code in [language/framework].

      Requirements:
      • List only concepts that are explicitly present in the snippet or strictly required to interpret it.
      • For each concept, provide a simple and short but technically accurate explanation.
      • Keep the explanation brief and factual.
      • At the end, recommend a site/book/docs/etc on where to actually learn those concepts.

      Output structure:
      • `Concept`: Explanation
      <space>
      • `Concept`: Explanation
      ...
    ]]),
    description = "List Technical Concept",
  },

  Explain = {
    prompt = dedent([[
      #selection
      Provide a **short, simple, and direct explanation** of the selected code in [language/framework].

      Requirements:
      • Explain the syntax, purpose and flow.
      • Keep the explanation brief and factual.
    ]]),
    description = "Explain code, short and simple",
  },

  ExplainHighLevel = {
    prompt = dedent([[
      #selection
      #buffer:active (additional context)

      Provide a **high-level conceptual explanation** of the selected code.

      Requirements:
      • Describe the code’s purpose, responsibilities, and its role implied by surrounding context.
      • Summarize the main logical flow and the major components or abstractions present in the snippet.
      • Infer design intent only when supported by common usage patterns or identifiable structural cues.
      • Reference specific syntax only when necessary to clarify high-level behavior.

      Constraints:
      • Do not invent architectural details, data flows, or intent not directly inferable from the snippet.
      • Do not restate, paraphrase, or walk through the code line by line.
    ]]),
    description = "Explain code conceptually at a high level",
  },

  ExplainBalanced = {
    prompt = dedent([[
      #selection
      #buffer:active (additional context)

      Provide a **functional technical explanation** of the selected code, balancing implementation details with logical purpose.

      Requirements:
      • **Logical Flow:** Trace the critical path of execution, grouping related statements into logical blocks rather than line-by-line analysis.
      • **Data Transformation:** Explain how inputs are manipulated to produce specific outputs or state changes, noting key variables only when they drive the logic.
      • **Mechanism & Intent:** Connect specific implementation choices (e.g., algorithms, patterns, control structures) directly to the immediate functional goal of the snippet.
      • **Contextual Relevance:** Briefly mention how this snippet interacts with the immediate surrounding scope provided in the context.

      Constraints:
      • Skip explanation of basic language syntax (e.g., do not explain what a `for` loop is, explain what *this* loop achieves).
      • Avoid broad architectural speculation not visible in the code.
      • Do not summarize the code so briefly that the mechanical steps are lost.
    ]]),
    description = "Balanced explanation focusing on logic and implementation.",
  },

  ExplainLowLevel = {
    prompt = dedent([[
      #selection
      #buffer:active (additional context)

      Provide a **low-level, strictly technical explanation** of the selected code.
      Focus only on semantics that can be directly inferred from the snippet.

      Requirements:
      • Decompose every statement and subexpression, identifying syntax elements, operators, and control-flow constructs.
      • Describe evaluation order, expression semantics, and any guaranteed runtime effects.
      • Identify data types or type categories (static, inferred, dynamic, or runtime-determined) and trace how values propagate through variables, expressions, and control paths.
      • Specify all observable state changes (assignment, mutation, creation, destruction, reassignment).
      • Highlight language-visible idioms, edge cases, and pitfalls inherently detectable from the snippet.

      Constraints:
      • Base all reasoning solely on the snippet and language-level guarantees; do not infer compiler, interpreter, or environment behavior not implied by the code.
      • Do not propose alternatives, rewrites, or improvements unless the snippet contains a clear, objectively verifiable error.
      • Do not restate or paraphrase the code itself.
    ]]),
    description = "Low-level and technical explanation of the code.",
  },

  Log = {
    prompt = dedent([[
      #selection
      Add logging statements to the selected code to aid in debugging and monitoring.

      Requirements:
      • Insert log statements at key points such as function entry, exit, and critical decision points.
      • Use appropriate log levels (e.g., debug, info, warn, error).
      • Ensure logs provide meaningful context without exposing sensitive information.
    ]]),
    description = "Add logging to selected code",
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
