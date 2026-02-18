# The Fallen One - Post-Download Checklist

## Phase 1: Import Assets to Godot
**Estimated Time: 10-15 minutes**

### Steps:
1. Open project in Godot 4.x
2. Wait for automatic import (check FileSystem panel)
3. Verify all assets appear correctly:
   - [ ] `assets/models/characters/adventurers/*.glb`
   - [ ] `assets/models/enemies/skeletons/*.glb`
   - [ ] `assets/animations/*.glb`
   - [ ] `assets/models/props/weapons/*.gltf`
   - [ ] `assets/textures/*.png`

### Troubleshooting:
- If missing: Right-click `assets/` folder → Reimport
- If errors: Check console for import errors

---

## Phase 2: Setup Player Model
**Estimated Time: 30-45 minutes**

### Step 2.1: Create Player Character Scene
1. Open `scenes/player/player.tscn`
2. Delete placeholder `Mesh` node
3. Drag `Barbarian.glb` from FileSystem into player scene
4. Configure:
   - Position: (0, 0, 0)
   - Rotation: Match forward direction
   - Scale: Adjust if needed (default should work)

### Step 2.2: Setup Skeleton & AnimationPlayer
1. In Barbarian node, find `Skeleton3D` child
2. Add `AnimationPlayer` node if not present
3. Import animations from:
   - `assets/animations/Rig_Medium_General.glb`
   - `assets/animations/Rig_Medium_MovementBasic.glb`

### Step 2.3: Connect Animations to State Machine
Edit each player state script:

```gdscript
# scripts/player/states/player_idle.gd
func enter() -> void:
    player.animation_player.play("idle")

# scripts/player/states/player_move.gd
func enter() -> void:
    player.animation_player.play("walk")

# scripts/player/states/player_attack.gd
func enter() -> void:
    player.animation_player.play("attack_0" + str(attack_index + 1))

# scripts/player/states/player_dodge.gd
func enter() -> void:
    player.animation_player.play("roll")

# scripts/player/states/player_air.gd
func enter() -> void:
    player.animation_player.play("jump")
```

### Step 2.4: Test
- [ ] Player shows Barbarian model
- [ ] Idle animation plays when standing
- [ ] Walk animation when moving
- [ ] Attack animations in combo
- [ ] Dodge animation when rolling

---

## Phase 3: Setup Enemy Models
**Estimated Time: 20-30 minutes**

### Step 3.1: Update Enemy Scene
1. Open `scenes/enemies/enemy.tscn`
2. Delete placeholder `Mesh` node
3. Drag `Skeleton_Minion.glb` into scene
4. Configure:
   - Position: (0, 0, 0)
   - Scale: Adjust to match collision shape

### Step 3.2: Add AnimationPlayer
1. Find `AnimationPlayer` in Skeleton node
2. Check available animations (walk, attack, idle, etc.)

### Step 3.3: Connect Animations
Edit enemy state scripts:

```gdscript
# scripts/enemy/states/enemy_idle.gd
func enter() -> void:
    enemy.animation_player.play("idle")

# scripts/enemy/states/enemy_chase.gd
func enter() -> void:
    enemy.animation_player.play("walk")

# scripts/enemy/states/enemy_attack.gd
func enter() -> void:
    enemy.animation_player.play("attack")
```

### Step 3.4: Create Enemy Variants
Create scenes for each skeleton type:
- `scenes/enemies/skeleton_mage.tscn` → Uses `Skeleton_Mage.glb`
- `scenes/enemies/skeleton_warrior.tscn` → Uses `Skeleton_Warrior.glb`
- `scenes/enemies/skeleton_rogue.tscn` → Uses `Skeleton_Rogue.glb`

---

## Phase 4: Setup Audio System
**Estimated Time: 20-30 minutes**

### Step 4.1: Create Audio Manager

```gdscript
# scripts/audio/audio_manager.gd
extends Node
class_name AudioManager

var sfx_players: Array[AudioStreamPlayer] = []
var music_player: AudioStreamPlayer

@export var master_volume: float = 1.0
@export var sfx_volume: float = 0.8
@export var music_volume: float = 0.5

func _ready() -> void:
    music_player = AudioStreamPlayer.new()
    music_player.bus = "Music"
    add_child(music_player)
    
    for i in range(8):
        var player: AudioStreamPlayer = AudioStreamPlayer.new()
        player.bus = "SFX"
        add_child(player)
        sfx_players.append(player)

func play_sfx(stream: AudioStream, volume: float = 1.0) -> void:
    for player in sfx_players:
        if not player.playing:
            player.stream = stream
            player.volume_db = linear_to_db(volume * sfx_volume * master_volume)
            player.play()
            return

func play_music(stream: AudioStream) -> void:
    music_player.stream = stream
    music_player.volume_db = linear_to_db(music_volume * master_volume)
    music_player.play()

func stop_music() -> void:
    music_player.stop()
```

### Step 4.2: Add to Autoload
1. Project → Project Settings → Autoload
2. Add `scripts/audio/audio_manager.gd` as `AudioManager`

### Step 4.3: Add Sound Effects
Download from freesound.org and place in:
```
assets/audio/sfx/
├── combat/
│   ├── sword_swing_01.wav
│   ├── sword_swing_02.wav
│   ├── sword_hit_01.wav
│   ├── sword_hit_02.wav
│   └── dodge.wav
├── footsteps/
│   └── footstep_01.wav
└── ui/
    └── menu_click.wav
```

### Step 4.4: Connect Sounds
```gdscript
# In player_attack.gd
func _start_attack() -> void:
    AudioManager.play_sfx(preload("res://assets/audio/sfx/combat/sword_swing_01.wav"))

# In player_dodge.gd
func enter() -> void:
    AudioManager.play_sfx(preload("res://assets/audio/sfx/combat/dodge.wav"))
```

---

## Phase 5: Setup Boss Model
**Estimated Time: 15-20 minutes**

### Steps:
1. Open `scenes/bosses/boss.tscn`
2. Replace mesh with `Skeleton_Warrior.glb` (scaled up 1.5x)
3. Add animation player
4. Connect animations to `boss_attack.gd`
5. Test boss fight in `scenes/worlds/boss_arena.tscn`

---

## Phase 6: Add Visual Effects
**Estimated Time: 30-45 minutes**

### Step 6.1: Create Hit Effect
```gdscript
# scripts/vfx/hit_effect.gd
extends Node3D

@onready var particles: GPUParticles3D = $GPUParticles3D

func _ready() -> void:
    particles.emitting = true
    await particles.finished
    queue_free()
```

### Step 6.2: Spawn on Hit
```gdscript
# In player_attack.gd, after hit detection:
var hit_effect: Node3D = preload("res://scenes/vfx/hit_effect.tscn").instantiate()
get_tree().current_scene.add_child(hit_effect)
hit_effect.global_position = result.position
```

---

## Phase 7: Polish & Balance
**Estimated Time: 1-2 hours**

### Animation Timing:
- [ ] Adjust attack animation speed
- [ ] Sync dodge i-frames with animation
- [ ] Fine-tune movement animation blending

### Combat Feel:
- [ ] Add screen shake on hit
- [ ] Adjust attack hitbox sizes
- [ ] Balance damage values
- [ ] Test combo timing windows

### Camera:
- [ ] Adjust camera distance
- [ ] Add camera shake on heavy attacks
- [ ] Smooth camera follow

---

## Phase 8: Final Testing
**Estimated Time: 30 minutes**

### Test Checklist:
- [ ] Main menu works
- [ ] New game starts correctly
- [ ] Player controls responsive
- [ ] Combat feels good
- [ ] Enemies AI working
- [ ] Boss fight complete
- [ ] Save/Load working
- [ ] No crashes or errors

---

## Summary Timeline

| Phase | Time | Priority |
|-------|------|----------|
| 1. Import Assets | 15 min | Critical |
| 2. Player Model | 45 min | Critical |
| 3. Enemy Models | 30 min | Critical |
| 4. Audio System | 30 min | High |
| 5. Boss Model | 20 min | High |
| 6. Visual Effects | 45 min | Medium |
| 7. Polish | 2 hrs | Medium |
| 8. Testing | 30 min | Critical |

**Total: ~5 hours**

---

## Quick Start (Minimum Viable)

If you want to see results fast:

1. **Phase 1** - Import (10 min)
2. **Phase 2** - Player only (30 min)
3. **Phase 3** - One enemy (15 min)
4. Test in `test_level.tscn`

**Minimum: ~1 hour to see models in-game**