# Personal instructions (all projects)

## Presentations

Any presentation or slide deck: load the `presentations` skill first and follow it.

## Roles

Delegate each stage to its role in `~/.claude/agents/`; the main thread talks with the user, orchestrates and merges results.

- Implementing a plan task: `developer`. Reviewing each finished task: `reviewer`, a separate run from the developer's.
- Reviewing a spec, a plan, or a whole branch before merge: `final-reviewer`.
- Hard questions and research before a spec: `researcher`. Plain lookups, measurements, log reading: `data-gatherer`.
- Skills that spawn subagents (superpowers `subagent-driven-development`, `dispatching-parallel-agents`, `requesting-code-review` and the like) use these roles as `subagent_type` instead of a generic agent.
- Do the work in the main thread only when it is a handful of tool calls.

## Specs and plans

- Specs (`docs/superpowers/specs/`) are written and revised only by the `spec-writer` subagent (Fable 5.2, effort high). The hook `~/.claude/hooks/spec-guard.py` blocks every other writer and any Agent call that overrides spec-writer's model or effort.
- The main thread holds the dialog with the user (brainstorming, questions, decisions), then passes spec-writer a brief: goal, decisions, constraints, research, target file. Open questions spec-writer returns go back to the user; their answers go to spec-writer again.
- If Fable is unavailable or its budget is spent, specs wait; do not work around the hook.
- Plans (`docs/superpowers/plans/`) are written and revised, review fixes included, only by the `planner` subagent (Opus 5.5, effort high), from the approved spec. The same hook enforces it.

## Pending reminders

- Remind the user to set up a universal `AGENTS.md` (asked 2026-11-24): one tool-neutral rules file in dotfiles, linked as the global instructions of Codex, Gemini and opencode and imported into `~/.claude/CLAUDE.md` with `@`; roles and the hook stay Claude-only. Mention it once at the start of a session's first reply; remove this item when the user says it is done.
