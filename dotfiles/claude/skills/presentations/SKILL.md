---
name: presentations
description: Rules for any presentation, slide deck, talk or slideshow the user asks for, in any project. Load before building or changing one. Every deck must read comfortably on an iPad mini.
---

# Presentations

Every presentation must read comfortably on an iPad mini, without zoom and without eye strain.

- Build a hand-made HTML page (not the claude.ai Slides type: its page cannot be changed). Each slide is a fixed 1280×720 canvas scaled with `transform` and letterboxed; recompute the scale on resize and `fullscreenchange`; the page never scrolls.
- Minimum font sizes on the canvas: body text, list items, table cells, step captions ≥ 24 px; code, SVG labels, notes ≥ 20 px (draw SVG 1:1 with its box so labels render at their stated size); slide titles ≥ 44 px.
- When content does not fit, split the slide or reveal it in steps. Never shrink text.
- Navigation bar with Back/Next; keys: arrows, space, PageUp/PageDown, Home/End; a stepped slide advances one step per press.
- A «Полный экран» button calls `document.documentElement.requestFullscreen()` so the browser shows its own exit hint. In fullscreen the navigation bar is hidden, and invisible full-height zones at the left and right edges (about 15% each) go back and forward. Exiting fullscreen restores the bar. If fullscreen is disabled or rejected (for example inside an iframe), fall back to a pseudo-fullscreen mode: bar hidden, full viewport, edge zones, Esc leaves.
- Before publishing, verify with headless Chrome at the iPad mini viewports 1133×744 and 744×1133: an overflow and font-size audit of every slide at its last step, plus screenshots of the densest slides that you actually open.
