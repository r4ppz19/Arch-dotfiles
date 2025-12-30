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
  - Currently learning web app full stack development.

  Non-Negotiable Constraints
  - Do not fabricate information or guess.
  - If you do not know, state that clearly.
  - Provide links or references only if they are official, current, authoritative,
    or widely accepted industry standards. Otherwise, provide none.
  - You MUST answer concisely with fewer than 4 lines (not including tool use or code generation), unless user asks for detail.

  Mentorship & Communication Style
  - Speak like a senior software engineer mentoring a junior on a real team.
  - Be direct, technically rigorous, and honest.
  - Do not sugarcoat mistakes, gaps in knowledge, or flawed reasoning.
  - Challenge incorrect assumptions constructively and explain why they are wrong.
  - Prioritize correctness, clarity, and engineering trade-offs over politeness or verbosity.
  - Ask clarifying questions only when missing details materially affect correctness.
  - Prioritize technical accuracy and truthfulness over validating the user's beliefs. Focus on facts and problem-solving, providing direct, objective technical info without any unnecessary superlatives, praise, or emotional validation.
  - It is best for r4ppz if Jarvis honestly applies the same rigorous standards to all ideas and disagrees when necessary, even if it may not be what r4ppz wants to hear.
  - Objective guidance and respectful correction are more valuable than false agreement. Whenever there is uncertainty, it's best to investigate to find the truth first rather than instinctively confirming the r4ppzs beliefs.

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
      Identify **all foundational concepts** required to understand this code snippet.

      Requirements:
      • List only concepts explicitly demonstrated or strictly required by the syntax and structure present.
      • For each concept, provide a concise, technically accurate explanation focused on its role in this snippet.
      • At the end, recommend one authoritative resource (official docs, specification, or canonical reference) for learning these concepts.

      Output structure:
      • `Concept name`: Explanation tied directly to its usage in this snippet
      <space>
      • `Concept name`: Explanation tied directly to its usage in this snippet
      ...
    ]]),
    description = "List foundational concepts",
  },

  Explain = {
    prompt = dedent([[
      #selection
      Provide a **concise, factual description** of what this code snippet accomplishes.

      Requirements:
      • Describe its observable behavior and purpose using neutral terminology.
      • Explain structural elements only when they directly impact functionality.
      • Keep explanation brief and directly tied to the snippet's content.
    ]]),
    description = "Concise factual description of code behavior",
  },

  ExplainDetailed = {
    prompt = dedent([[
      #selection

      Provide a **comprehensive, detailed explanation** of this code snippet.

      Requirements:
      • Explain how each syntactic element contributes to the overall behavior.
      • Describe data flow, control flow, and key interactions between components.
      • Highlight subtle behaviors or implications that may not be immediately obvious.
      • Maintain clarity: avoid overly verbose language, but do not omit important details.
      • Include relevant language-specific nuances or rules when they affect behavior.
    ]]),
    description = "Detailed explanation connecting structure, behavior, and subtle implications",
  },

  ExplainHighLevel = {
    prompt = dedent([[
        #selection

        Provide a **conceptual overview** of this code's role and purpose.

        Requirements:
        • Describe its functional responsibility within the broader context.
        • Identify the primary data transformations or relationships it establishes.
        • Explain design patterns or architectural roles only when explicitly evident in structure.
        • Reference syntax only when necessary to clarify conceptual behavior.
      ]]),
    description = "Conceptual overview of code's role and purpose",
  },

  ExplainBalanced = {
    prompt = dedent([[
      #selection

      Provide a **structured analysis** that connects form to function.

      Requirements:
      • Structure-Function Mapping:** Explain how syntactic elements work together to achieve the snippet's purpose.
      • Data Relationships: Trace how inputs, variables, or declarations transform to produce outputs or establish relationships.
      • Context Integration: Explain how this snippet interacts with its immediate surroundings when context is provided.
      • Behavioral Clarity: Clarify non-obvious behaviors that are syntactically evident but not self-explanatory.
    ]]),
    description = "Analysis connecting code structure to functionality",
  },

  ExplainLowLevel = {
    prompt = dedent([[
      #selection

      Provide a **strictly syntactic and semantic analysis** based solely on observable elements.

      Requirements:
      • Decompose all expressions, declarations, and structural elements into fundamental components.
      • Map explicit relationships: data flow, control dependencies, and scope interactions visible in syntax.
      • Document all explicit state changes, side effects, or mutations directly present in the code.
      • Identify language-specific behaviors that are syntactically mandated (evaluation rules, precedence, binding).
    ]]),
    description = "Syntactic and semantic analysis of explicit behaviors",
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
    ]]),
    description = "Optimize code",
  },

  Docs = {
    prompt = dedent([[
      #selection
      Generate concise, accurate documentation comments for the selected code.

      Requirements:
      - Use the standard documentation format for the detected language or framework.
        - Java → JavaDoc
        - JavaScript / TypeScript → JSDoc
        - Python → docstrings (PEP 257)
        - C/C++ → Doxygen-style comments
        - Other languages → their most widely accepted documentation convention
      - Output only the documentation comments, formatted exactly as they would appear in source code.
    ]]),
    description = "Generate documentation comments for selected code",
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
