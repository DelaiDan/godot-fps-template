# Godot FPS Base Template

A starting point for first-person games in **Godot 4.5**, built around a strict separation between *state graph* and *behavior*. It gives you a working character controller, a camera rig, and a weapon system with both hitscan and projectile delivery — without hiding the wiring behind a monolith.

> Foundation, not a finished game. Some pieces are deliberately left open;

## Requirements

- Godot **4.5** or newer, standard build (no C#)
- Renderer: **GL Compatibility** (set in `project.godot`)

## Quick start

Open the project in the editor and press play, or from the command line:

```bash
godot --path .                           # run the game
godot --path . Scenes/Levels/test.tscn   # run a single scene
godot --headless --path . --quit         # import and report script errors
```

`Scenes/main_scene.tscn` is the entry point. It loads `Scenes/Levels/test.tscn`, a sandbox level with a floor, a ledge and a box to jump on.

## What's included

**Player controller** — `CharacterBody3D` with gravity, jump, sprint and crouch. Speed is recomposed every physics frame from additive modifiers (`default_speed + sprint_modifier + crouch_modifier`), so new movement modes plug in without touching the ones already there. Crouching swaps collision shapes and uses a `ShapeCast3D` to block standing up under geometry.

**Camera rig** — three nodes, each owning one part of the transform: mouse capture accumulates input, the controller applies yaw to the body and pitch to itself, and a camera-effects script owns the camera's local transform for run tilt and landing kick.

**State machines** — player movement and posture as two independent parallel regions, plus a separate chart for weapons. See [Architecture](#architecture).

**Weapons** — `Weapon` is a plain data `Resource`, subclassed by delivery method:

```
Weapon
├─ HitscanWeapon      instant raycast
└─ ProjectileWeapon   spawns a moving Area3D
```

Weapon references are typed as the base class, so both work anywhere. Swapping weapons means swapping the resource and respawning the view model. Ready-made resources live in `Assets/Weapons/Resources/`.

**UI** — a crosshair drawn procedurally by a `@tool` script, live-editable in the inspector.

**Addons** — [godot_state_charts](https://github.com/derkork/godot-statecharts) for the state machines, and [FuncGodot](https://github.com/func-godot/func_godot_plugin) for building levels in TrenchBroom. Each ships its own license.

## Architecture

The core idea is **two mirrored trees**. Read this before changing gameplay code.

| Tree | Contents | Responsibility |
|---|---|---|
| `StateChart/Root/…` | addon nodes (`CompoundState`, `ParallelState`, `AtomicState`, `Transition`) | **The graph only.** Which states exist, which is initial, which events cause which transitions. No game logic. |
| `StateMachine/…` | plain `Node`s with scripts | **The behavior only.** Handlers like `_on_idle_state_physics_processing`. |

The two are joined **exclusively by signal connections stored in the scene file**. No code links them. Matching node names are a convention, nothing more.

Adding a state takes four steps, three of them in the scene:

1. Add the state node to the chart.
2. Add a `Transition` node carrying the event that reaches it.
3. Add a scripted node to the mirror tree.
4. Connect the state's signal to the script's method.

**Editing only the `.gd` file does nothing.**

### Current graph

`StateChart/Root` is a `ParallelState` with two independent regions:

```
Movement                          Posture
├─ Grounded (initial)             ├─ Standing (initial)
│  ├─ Idle (initial)              └─ Crouching
│  └─ Moving
│     ├─ Walking (initial)
│     └─ Sprinting
└─ Airborne
   └─ Jumping (initial)
```

Weapons use a separate flat chart: `Idle`, `Firing`, `Empty`.

A `StateChartDebugger` is instanced in the player scene and shows active states at runtime — the main diagnostic tool.

## Layout

```
Assets/Weapons/     weapon resources and their scripts
Scenes/             main scene, player, levels, UI, weapons
Scripts/            gameplay code; one States/ folder per state machine
addons/             godot_state_charts, func_godot
```

Node references are `@export` fields filled with `NodePath` in the scene, grouped under `@export_category("References")`, rather than `get_node()` scattered through the code.

Physics layer 1 is `world`, layer 2 is `player`.

## Assets

Third-party art bundled under `Assets/Media/`, all free to use:

| Pack | Author | License | Contents |
|---|---|---|---|
| KayKit Character Pack: Skeletons 1.1 | [Kay Lousberg](https://www.kaylousberg.com) | CC0 | Four rigged skeletons — Mage, Minion, Rogue, Warrior — with textures and general/basic-movement animation sets |
| KayKit Character Animations 1.1 | [Kay Lousberg](https://www.kaylousberg.com) | CC0 | Animation library for the medium and large rigs: general, basic and advanced movement, melee and ranged combat, simulation, special |
| [Tiny Texture Pack 2](https://screamingbrainstudios.itch.io/tiny-texture-pack-2) | Screaming Brain Studios | CC0 | 160 tiling textures at 256×256 across eight sets: brick, dirt, elements, metal, plaster, stone, tile and wood |

Everything above is Creative Commons Zero — free for personal, educational and commercial use, with no attribution required. Models ship as both `.glb` and `.fbx`; Godot imports the `.glb`. Each KayKit pack keeps its own `License.txt` alongside the files.

Crediting Kay Lousberg is not required under CC0. The requested form, if you want to, is "Kay Lousberg, www.kaylousberg.com".

## License

Project code is MIT — see `LICENSE`. Bundled assets and addons keep their own licenses, listed above.
