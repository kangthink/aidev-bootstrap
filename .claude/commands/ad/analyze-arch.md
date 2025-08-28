---
name: analyze-arch
description: "Analyze the architecture of a project in DSL"
category: utility
complexity: basic
mcp-servers: []
---

# /ad:analyze-arch

## process
- Trigger the skill-analyze-arch-in-dsl agent if the user wants to analyze the architecture of a project in DSL
- If the user wants to save the output, save it in `@.aidev/arch/analyze-arch.<datetime>.md`