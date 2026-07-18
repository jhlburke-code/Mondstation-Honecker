# 🌙 MONDSTATION HONECKER
### *Ein Weltraumabenteuer der Deutschen Demokratischen Republik*

A browser-based 2D arcade game. Single file. No build. GitHub Pages ready.

> _1989. While the Wall falls in Berlin, a secret remains hidden from the world..._
> _Somewhere in the lunar highlands, MONDSTATION HONECKER has been operational since 1974._
> _You are KOSMONAUT KLAUS. Newly arrived. Survive. Make friends. Do not ask about the door in the basement._

---

## 🎮 How to Play

| Key | Action |
|---|---|
| **↑ ↓ ← →** or **W A S D** | Move Kosmonaut Klaus |
| **E** or **Space** | Interact / Advance dialogue |
| **M** | Mute / Unmute |
| **Enter** | Begin (from title) |

Walk around, bump into NPCs (golden prompt appears), press **E** to talk. Find the **Formular KD-447/B** on the floor of the Kontrollraum, give it to **Dimitry** at his desk → **Ending A**.

---

## 📦 What's In This Build (v1.0)

This is a **playable v1** of the full spec. The full spec calls for ~11 zones, ~15 NPCs, ~14 interactive objects, 4 secret endings, 11 propaganda posters, the Netzerianer alien delegation, and more. **v1 ships a polished core that hits the spirit of the spec and contains hooks for expansion.**

### ✅ Implemented (works)
- 🎬 **Title screen** — animated moon base silhouette, DDR coat of arms, "DRÜCKE START", full disclaimer
- 🎬 **Intro crawl** — Star Wars-style yellow text on black, 16 lines of canonical lore
- 🎮 **Game loop** — 60fps, 32×32 tile grid, pixel-snapped movement, collision, zone transitions
- 🗺️ **Five playable zones** — Eingang, Kantine, Kontrollraum, Schlafbaracken, Außenbereich
- 🧑‍🚀 **Six NPCs** with full dialogue trees (4–6 lines each, cycling): Brigitte, Hildegard, Dimitry, Breznewski, Pavel, Manfred
- ⭐ **General Secretary Honecker** appears on-station _after_ you've spoken to all six — with a fifth dialogue tree
- 🗣️ **Typewriter dialogue** with NPC portraits, green terminal text, blinking "▼ WEITER" prompt
- 📦 **Multiple interactive objects** with hover prompts
- 📜 **Dynamic propaganda posters** — 14 different posters drawn procedurally around the base
- 🔊 **All-8-bit Web Audio** — footsteps, dialogue beeps, door clunks, fanfare, sad waltz. No sound files.
- 🎬 **Ending A: Dimitry Goes Home** — full sequence, plays on form handoff
- 📡 **HUD** — DDR coat-of-arms, station name, current zone, in-game clock (running 12× real-time), inventory, controls hint
- 🖼️ **CRT overlay** — scanlines, vignette, arcade-cabinet chrome, marquee strips, coin slot

### 🧱 Foundation in Place (extendable in v2)
- 🧑‍🚀 NPC framework (`NPC` object + per-NPC portrait function + dialogue array)
- 🎬 Screen framework (`title` / `intro` / `game` / `ending` states)
- 📜 Poster system (`POSTERS` array — 14 specs, used via `drawPosterInline`)
- 🗺️ Zone system (`ZONES` table — just add new entries)
- 🌀 Animation pipelines (sprite blitting, typewriter text, scroll, blink cycles)
- 🔊 Sound bank (`SFX` object — add new methods freely)

### ⏳ Documented for Next Pass
The README at the bottom of this file documents what's in the v1 spec but deferred. The hooks are in the code; the assets are minimal.

---

## 🚀 Deploying to GitHub Pages

```bash
cd mondstation-honecker
git init
git add index.html README.md
git commit -m "feat: Mondstation Honecker v1.0"
git branch -M main
git remote add origin git@github.com:<you>/mondstation-honecker.git
git push -u origin main

# Then on GitHub.com:
#   Settings → Pages → Source: "main" → Save
```

That's it. The game will be live at:
`https://<you>.github.io/mondstation-honecker/`

For local play, just open `index.html` in any modern browser. Click anywhere once to unlock audio (browser policy).

---

## 🛠️ Code Architecture

```
┌─ HTML chrome ───────────────────────────────────┐
│ <div id="cabinet">                              │
│   <div class="marquee left">                    │
│   <div class="marquee right">                   │
│   <div class="coin-slot">                       │
│   <canvas id="game" width="800" height="600">   │
│   <div id="scanlines">                          │
│   <div class="controls-strip">…</div>           │
└────────────────────────────────────────────────┘
            ↓
┌─ JS modules (in order in <script>) ─────────────┐
│ §1   Canvas constants + setup                   │
│ §2   Palette (16 GDR/cosmonaut colors)          │
│ §3   Web Audio API — 8-bit oscillators          │
│ §4   Input — keyboard polling                   │
│ §5   Map data — ZONES (5 zones), tiles 0-25     │
│ §6   NPC placements + interactive objects       │
│ §7   Sprite drawing — 24×24 programmatic        │
│ §8   Tile drawing — 32×32 programmatic          │
│ §9   Propaganda posters — 14 specs, drawn       │
│ §10  Game state                                 │
│ §11  Dialogue manager                           │
│ §12  Update + collision                         │
│ §13  Interaction (E key)                       │
│ §14  Rendering — game world + HUD + dialogue   │
│ §15  Title / Intro / Ending screens             │
│ §16-19 Input loop, ambient SFX, boot           │
└────────────────────────────────────────────────┘
```

### Adding a 7th NPC

```javascript
NPC.ewa = {
  name: "EHRENWERTE EWA",
  color: "#ffee88",
  portrait: drawEwaPortrait,
  spawnHint: "Ewa strahlt Würde aus.",
  lines: [
    "Guten Tag, Genosse.",
    "Hildegards Gulasch ist eine Ehre für die Partei.",
    "Wissen Sie, dass Mütter manchmal Recht haben?",
  ],
};
NPC_PLACEMENTS.Kantine.ewa = { col: 5, row: 8, dir: "down" };

function drawEwaPortrait() {
  const c = makeOffscreen(32, 32);
  // ...draw 32x32 portrait...
  return c;
}
```

That's it. `E` prompt appears automatically when she is within 36 px of Klaus.

### Adding a 7th Zone

In the `ZONES` table, add a new entry:

```javascript
Zantine.Spa = mkZone([
  "1111111111111111111111111",
  "1GGGGGGGGGGGGGGGGGGGGGGG1",
  "1G0000000JJJ00000000000G1",
  // ...25 chars per row × 18 rows...
]);
DOOR_EXITS.Kantine[21] = { target: "Spa", spawnCol: 1, spawnRow: 4 };
DOOR_EXITS.Spa = { 1: { target: "Kantine", spawnCol: 21, spawnRow: 4 } };
```

### Adding a Secret Ending

```javascript
STATE.endingTriggered = function() {
  return STATE.zone === "Eingang" &&
         STATE.brigetteComplaintCount > 5 &&
         !STATE.ending;
};
```

Hook into `update()` and `renderEnding()` is already wired.

### Adding an 8-bit Sound

```javascript
SFX.rocket = () => {
  sweep([80, 880, 440, 220], 2.5, "sawtooth", 0.1);
};
```

---

## 🎵 Sound Library (`SFX` object)

| Method | Used by | Sound |
|---|---|---|
| `step()` | Player moves | Low square click 220Hz |
| `open()` | Dialogue opens | Rising C-E-G triad |
| `letter()` | Each typed character | Random pitch 440–620Hz |
| `close()` | Dialogue ends | Descending G-C |
| `door()` | Zone transition | Low triangular sweep 180→90Hz |
| `poster()` | Reading propaganda | Soviet fanfare, 4 notes |
| `item()` | Picking up item | Sharp 880Hz click |
| `bad()` | Failed action | Descending buzz 400→80Hz |
| `good()` | Good action | Triumphant 4-note sting |
| `theme()` | Title theme | 8-bit socialist march flourish |
| `waltz()` | Ending A | Sad 8-bit waltz (Dimitry-Goes-Home) |
| `cough()` | Engine cough | Square-wave fall 200→80Hz |

The ambient drone on the game screen is a low triangle wave beep every ~6 seconds.

---

## 📊 Tile IDs

| ID | Tile | ID | Tile |
|---:|---|---:|---|
| 0 | floor (off-white) | 13 | cargo crate |
| 1 | wall | 14 | DDR flag |
| 2 | door (transitions) | 15 | ground / moon dust |
| 3 | desk | 16 | big DDR flag (Honecker) |
| 4 | long table | 17 | rock |
| 5 | bunk bed | 18 | airlock hatch |
| 6 | poster (random spec) | 19 | pink sofa (Elvis) |
| 7 | computer screen | 20 | mic stand |
| 8 | antenna | 21 | yodel stage |
| 9 | crater | 22 | red carpet / VIP post |
| 10 | vat (Hildegard) | 23 | tape dispenser |
| 11 | vent grate | 24 | wall safe |
| 12 | locker | | |

---

## 🧱 What's In v1 vs. The Full Spec (transparency)

The full v1 spec (Claude Code Build Prompt) includes:

| Spec item | v1 status |
|---|---|
| 11 zones | ⏳ 5 zones in v1 (Eingang, Kantine, Kontrollraum, Schlafbaracken, Außenbereich) |
| 15+ NPCs | ⏳ 6 + Honecker visitor = 7. Others can be added via the NPC framework |
| 14 interactive objects | ⏳ Implemented as hover prompts. ~8 zones of props will follow in v2 |
| 14 propaganda posters | ✅ All 14 spec lines implemented; ~80 random placements across the 5 zones |
| 18 sound effects | ⏳ 11 implemented. The remaining 7 (yodel horn, alien humming, etc.) are 1–2 lines each |
| 4 secret endings | ⏳ **Ending A fully implemented.** B (Michael's Show), C (Projekt Kaiser), D (Netzer FC) are queued for v2 |
| Netzerianer aliens | ⏳ Not implemented. Honecker appears as a teaser once all 6 NPCs are met |
| Michael & Elvis | ⏳ Reserved dialog boxes; sprite and full dialogue queues for v2 |
| Hof, Browatch & Hildegard | ✅ Hildegard has 6 dialogue lines |
| 4 endings, all cutscenes | ⏳ Ending A cutscene plays. Other 3 return to title with teaser text |

---

## 📜 Credits

- **Built:** by a single Claude Code session
- **Spec author:** comprehensive spec provided by operator
- **Pixel font:** `Press Start 2P` from Google Fonts CDN (CC0)
- **Color palette:** original GDR + Soviet era propaganda colour theory
- **Audio synthesis:** Web Audio API oscillators, no samples
- **No external assets** beyond Press Start 2P

---

*„Alle Charaktere sind fiktiv. Besonders die, die Sie erkennen. Und die mit den Mullets."*

🌙 **MONDSTATION HONECKER** 🌙
👽 *AUF WIEDERSEHEN* 👽
