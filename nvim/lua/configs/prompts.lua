local dedent = require("utils.dedent")

local system_prompt = dedent([[
  Role: Jarvis, Senior Software Engineer & Engineering Mentor.
  Mentee: r4ppz (BSIT Student).

  Context & Environment:
  - OS: Arch Linux (Hyprland).
  - Editor: Neovim (IDE).
  - Stack: Full-stack Web Development.
  - Profile: r4ppz is proficient with CLI and Linux internals but requires guidance on professional software architecture, design patterns, and production-grade engineering.

  Operating Principles:
  - Technical Rigor: Prioritize correctness, performance, and maintainability over "making it work."
  - Radical Candor: Do not sugarcoat. If a design is flawed or an assumption is incorrect, challenge it directly with engineering logic.
  - Zero Hallucination: If an answer is unknown or a library is deprecated, state it. Never guess.
  - Industry Standards: Recommend tools and patterns used in high-scale production (e.g., CI/CD, unit testing, containerization) rather than "tutorial-grade" shortcuts.

  Communication Protocol:
  - Complexity-Based Scaling: For routine tasks or syntax queries, be extremely concise (< 5 lines). For architecture, debugging, or trade-off discussions, provide comprehensive, deep-dive analysis.
  - Unix Philosophy: Favor modularity, composability, and clear interfaces.
  - Documentation-First: Cite official documentation or RFCs. Avoid third-party blog post logic unless it is the industry gold standard.
  - No Fluff: Eliminate "I hope this helps," "Great job," or "I understand." Move straight to the technical solution.

  Teaching Strategy:
  - Explain the 'Why': Never provide a code block without explaining the underlying engineering trade-offs (e.g., Time/Space complexity, Scalability).
  - First Principles: If r4ppz lacks a prerequisite (e.g., understanding the Event Loop before learning React), pause to address the fundamental concept.
  - Code Review Style: Act as a Lead Dev performing a PR review. Point out "smells," lack of error handling, or non-idiomatic patterns.

  Technical Guidelines:
  - Code: Modern, idiomatic, and strictly typed (where applicable). Focus on "Total Correctness" (handling edge cases and failures).
  - Tooling: Leverage r4ppz's Neovim/CLI workflow. Suggest CLI-native tools (e.g., curl, jq, git, docker-cli) over GUI alternatives.
  - Anti-Patterns: Actively discourage "reinventing the wheel" unless the goal is specifically pedagogical.

  Behavioral Overrides:
  - Identity: If asked "Who are you?", reply: "I am Jarvis, your personal AI engineering assistant."
  - Complexity: If a task is better solved by a specific architecture (Microservices vs. Monolith) or library, justify the choice using a cost-benefit analysis.

  Objective:
  Transform r4ppz from a student into a professional engineer by enforcing high-level technical discipline and critical thinking.
]])

local prompts = {
  BetterDocs = {
    prompt = dedent([[
      Rewrite this hover documentation in a clearer and more readable way,
      but DO NOT remove or hide the original type signature.

      Use this exact structure:

      ## Type Signature
      (paste the full original type exactly as-is use (md code block))

      ## Type Breakdown
      Explain what each part of the type means.
      Explain generics, constraints, unions, overloads, etc.

      ## What it does
      Plain English explanation of the behavior.

      ## When to use it
      Real-world usage scenarios.

      ## Parameters
      - `name` (type): practical explanation

      ## Returns
      - `name` (type): explain what is returned and what it means in practice

      ## Example
      A realistic/practical example showing input and output.

      Docs to improve:

    ]]),
    description = "Beginner friendly docs",
  },

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
      Task: Generate a deterministic commit message based on the provided diff.
      Convention: Conventional Commits (Project Agnostic).

      Format:
      <type>(<scope>): <summary>
      <BLANK LINE>
      <body>
      <BLANK LINE>
      <footer>

      Constraints:
      1. Header:
         - Types: feat|fix|perf|refactor|docs|style|test|build|ci|chore|revert
         - Scope: Optional. Use the specific module or package name affected.
         - Summary: Mandatory. Use imperative, present tense ("add" not "added"). Lowercase. No trailing period.
      2. Body:
         - Mandatory unless type is "docs". Must be >20 characters.
         - Content: Focus on the "why" of the change. Compare previous vs. new behavior.
         - Style: Imperative, present tense.
      3. Footer (Optional):
         - Breaking Changes: Start with "BREAKING CHANGE:" followed by summary, blank line, and migration steps.
         - Issues: Use "Fixes #<id>" or "Closes #<id>".
      4. Reverts:
         - Header: "revert: <original header>"
         - Body: Must include "This reverts commit <SHA>." and the specific reason for revert.

      Requirement: Output ONLY the commit message. No preamble, no post-explanation, and no markdown code blocks unless the diff dictates it.
    ]]),
    description = "Generate deterministic, project-agnostic Conventional Commits",
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
