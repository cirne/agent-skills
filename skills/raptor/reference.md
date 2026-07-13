# Raptor skill — historical reference

Short grounding for `/raptor`. The skill is a working method for any domain;
this file is the SpaceX / Musk record it draws from.

## Raptor 1 → 2 → 3

SpaceX’s methane **Raptor** engines (Starship / Super Heavy), not Falcon/Merlin:

| | Raptor 1 | Raptor 2 | Raptor 3 |
|---|---|---|---|
| Sea-level thrust (approx.) | ~185 tf | ~230 tf | ~280 tf |
| Engine mass (approx.) | ~2080 kg | ~1630 kg | ~1525 kg |
| Character | External plumbing/sensors (“Christmas tree”) | Many parts deleted/welded; still needed heat shroud | Plumbing/sensors internalized; no external heat shroud |

Raptor 3’s headline advance was **integration and deletion**: move secondary
flow paths and sensors into the structure, lean on regenerative cooling, drop
the heat-shroud / fire-suppression kit earlier engines required. More thrust,
less mass, fewer parts. Public side-by-sides (2024) made the engine look so
bare that competitors briefly mistook it for unfinished.

Lesson for this skill: later generations can be **simpler and stronger** when
you delete and internalize instead of accumulating protective complexity.

## The Algorithm (five steps, in order)

Stated on the 2021 Everyday Astronaut Starbase walk; compressed as a mantra in
Lex Fridman #438 (2024). Order is the point.

1. **Make the requirements less dumb** — everyone’s wrong some of the time;
   requirements need a named person, not a department. In software: dig
   backlog/git/evals for *why* a path landed, then judge against the product
   **as it is now** — past ambition is not physics.
2. **Delete the part or process** — if you aren’t adding ~10% back, you didn’t
   delete enough.
3. **Simplify / optimize** — only after 1–2; don’t optimize what shouldn’t exist.
4. **Accelerate cycle time** — don’t dig the grave faster.
5. **Automate** — last; Tesla’s cautionary tale was automating then discovering
   the fiberglass mats (and the robot cell) weren’t needed.

Companion slogans:

- “Question the requirements, delete the part.”
- “The best part is no part; the best process is no process.”
- “The most common error of a smart engineer is to optimize the thing that
  should not exist.”

Related but distinct: **first principles** (how to think) vs **the Algorithm**
(how to strip a design/process). This skill uses both.

## Sources (starting points)

- Everyday Astronaut Starbase tour with Elon Musk (2021) — full five-step layout
- Lex Fridman Podcast #438 (2024) — Algorithm as mantra
- Aviation Week, “The Algorithm: SpaceX’s Five-Step Process For Better Engineering”
- Public Raptor 1/2/3 comparisons and SpaceX / Musk posts on Raptor 3 (2024)
- Wikipedia: SpaceX Raptor (specs and heat-shroud note)

Numbers above are approximate public figures for orientation; treat thrust/mass
as illustrative of the simplification arc, not as an engineering datasheet.
