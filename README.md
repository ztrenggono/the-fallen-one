# The Fallen One

A 3D Dark Fantasy Action RPG built with Godot 4.x

## Overview

Play as a former cult member betrayed by the organization that raised you. Wield a legendary weapon from hell and absorb the powers of your enemies as you seek vengeance against the corrupt caste system.

## Features

- **Souls-like Combat** - Methodical, timing-based combat with dodges, attacks, and combos
- **Absorb System** - Unique progression by absorbing abilities from defeated enemies
- **Boss Battles** - Multi-phase boss fights with unique attack patterns
- **Multiple Regions** - Explore 4 distinct areas from the slums to the capital

## Controls

| Action | Input |
|--------|-------|
| Move | WASD |
| Camera | Mouse |
| Attack | Left Click (combo) |
| Dodge | Right Shift / Space |
| Jump | Left Shift |
| Interact | E |
| Pause | ESC |

## Enemy Types

| Enemy | Description |
|-------|-------------|
| Cultist | Standard enemy, balanced stats |
| Fast Enemy | Quick, burst attacks, low health |
| Heavy Enemy | Tanky, charge attack, high damage |
| Ranged Enemy | Fires projectiles, maintains distance |

## Boss Phases

Each boss has 3 phases with increasing difficulty:
1. **Phase 1** (75% HP): Basic attacks
2. **Phase 2** (50% HP): Heavy attacks unlocked, ENRAGED
3. **Phase 3** (25% HP): AOE attacks, FINAL PHASE

## Project Structure

```
game/
├── assets/
│   ├── models/
│   ├── textures/
│   ├── audio/
│   └── animations/
├── scenes/
│   ├── player/
│   ├── enemies/
│   ├── bosses/
│   ├── worlds/
│   └── ui/
├── scripts/
│   ├── combat/
│   ├── movement/
│   ├── absorb_system/
│   ├── quest/
│   └── save_system/
└── resources/
    ├── enemies/
    ├── items/
    ├── abilities/
    └── quests/
```

## Development Status

- [x] Phase 1: Foundation
- [x] Phase 2: Core Systems
- [x] Phase 3: Content
- [x] Phase 4: Polish

## Requirements

- Godot 4.x
- GDScript

## Running the Game

1. Open project in Godot 4.x
2. Press F5 or click Play
3. Start from Main Menu

## Credits

Created with Godot Engine

## Assets

### Included (CC0 License)
- **KayKit Skeleton Pack** - Enemy 3D models
  - Skeleton_Mage.glb
  - Skeleton_Minion.glb
  - Skeleton_Rogue.glb
  - Skeleton_Warrior.glb

### Required (Download Manually)
1. **Player Character**
   - https://kaylousberg.itch.io/kaykit-adventurers (Free)
   - Extract to: `assets/models/characters/`

2. **Sound Effects**
   - https://freesound.org/browse/tags/sword/ (Free account)
   - Save to: `assets/audio/sfx/combat/`

3. **Music**
   - https://opengameart.org/art-search?keys=dark+fantasy (Free)
   - Save to: `assets/audio/music/`

Run `./download_assets.sh` to download available assets automatically.