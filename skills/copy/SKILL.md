---
name: copy
description: Rewrites and writes user-facing copy per the project style guide and i18n conventions. Prioritizes what the user needs—not product mechanics—with concise language. Use when editing UI strings, locale JSON, onboarding text, headings, hints, accessibility labels, prompt phrasing, or when the user asks for clearer/shorter copy.
---

# Copy

## Discover repo conventions

Load before rewriting:

1. **Copy / voice guide** (e.g. `docs/COPY_STYLE_GUIDE.md`, brand guidelines)
2. **i18n docs** (namespaces, key shape, locale paths, `$t` / equivalent)
3. Product vocabulary tables (what users say vs internal module names)

Do **not** invent a parallel i18n pattern. If no guide exists, apply the rewrite lens below and ask where durable vocabulary should live.

## The failure mode

**Bad copy explains how the product works.** Good copy answers **what matters to the user right now** — next action, outcome, or reassurance.

Fix: mechanistic tours, verbosity, technical plumbing, audience-blind developer jargon.

## Rewrite lens

1. **Audience** — would they say this aloud? Would they care?
2. **Job** — recover, approve, retry, acknowledge — not system flow
3. **Length** — default short; one idea per helper
4. **No-plumbing** — no implementation path or “where it appears” narration
5. **Surfaces** — use the guide’s product vocabulary, not internal module names

## Verification

1. Does this mainly educate about internals? → delete/replace
2. Can I halve the word count without losing the actionable idea?
3. Any developer-only terms? → guide jargon table
4. Trust/security claims match security docs / deployment truth
5. `aria-*` / `title` / placeholders meet the same bar

## i18n

When the project localizes UI:

- Put English (or source locale) strings in the documented locale files
- Stable keys; interpolate — don’t concatenate in the UI layer
- Localize visible text **and** accessibility strings
- Keep keys stable unless deliberately renaming with coordinated call sites

Agent prompts: same no-plumbing bar; localization may be intentionally separate — follow project i18n scope.
