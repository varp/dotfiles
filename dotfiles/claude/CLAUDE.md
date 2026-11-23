# Personal instructions (all projects)

## Presentations

Every presentation must read comfortably on an iPad mini, without zoom and without eye strain.

- Build a hand-made HTML page (not the claude.ai Slides type: its page cannot be changed). Each slide is a fixed 1280×720 canvas scaled with `transform` and letterboxed; recompute the scale on resize and `fullscreenchange`; the page never scrolls.
- Minimum font sizes on the canvas: body text, list items, table cells, step captions ≥ 24 px; code, SVG labels, notes ≥ 20 px (draw SVG 1:1 with its box so labels render at their stated size); slide titles ≥ 44 px.
- When content does not fit, split the slide or reveal it in steps. Never shrink text.
- Navigation bar with Back/Next; keys: arrows, space, PageUp/PageDown, Home/End; a stepped slide advances one step per press.
- A «Полный экран» button calls `document.documentElement.requestFullscreen()` so the browser shows its own exit hint. In fullscreen the navigation bar is hidden, and invisible full-height zones at the left and right edges (about 15% each) go back and forward. Exiting fullscreen restores the bar. If fullscreen is disabled or rejected (for example inside an iframe), fall back to a pseudo-fullscreen mode: bar hidden, full viewport, edge zones, Esc leaves.
- Before publishing, verify with headless Chrome at the iPad mini viewports 1133×744 and 744×1133: an overflow and font-size audit of every slide at its last step, plus screenshots of the densest slides that you actually open.

## Specs and plans

- Specs (`docs/superpowers/specs/`) are written and revised only by the `spec-writer` subagent (Fable 5.2, effort high). The hook `~/.claude/hooks/spec-guard.py` blocks every other writer and any Agent call that overrides spec-writer's model or effort.
- The main thread holds the dialog with the user (brainstorming, questions, decisions), then passes spec-writer a brief: goal, decisions, constraints, research, target file. Open questions spec-writer returns go back to the user; their answers go to spec-writer again.
- If Fable is unavailable or its budget is spent, specs wait; do not work around the hook.
- Plans (`docs/superpowers/plans/`) are written and revised, review fixes included, only by the `planner` subagent (Opus 5.5, effort high), from the approved spec. The same hook enforces it.

## Pending reminders

- Remind the user to add `~/.claude/CLAUDE.md` to their dotfiles repository (asked 2026-11-12). Mention it once at the start of a session's first reply; remove this item when the user says the file is in dotfiles.
