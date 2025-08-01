# EnemyType Integration with Enemy.gd

This document explains how the EnemyType resource system integrates with your existing `enemy.gd` class.

## How It Works

### EnemyType Resource (`enemy_type.gd`)
The EnemyType resource is a simple configuration container that holds values to apply to Enemy instances:

```gdscript
# Properties that directly match Enemy.gd
@export var speed: float = 100.0          # -> enemy.speed
@export var max_health: float = 100.0     # -> enemy.max_health  
@export var damage: float = 25.0          # -> enemy.damage
@export var target_group: String = "loopOrigin"  # -> enemy.target_group

# Visual properties for the sprite
@export var texture: Texture2D           # -> enemy.sprite.texture
@export var sprite_scale: Vector2 = Vector2.ONE    # -> enemy.sprite.scale
@export var sprite_modulate: Color = Color.WHITE   # -> enemy.sprite.modulate
```

### Integration Process

1. **Enemy Spawning**: When `EnemySpawner` creates an Enemy instance, it calls `configure_enemy_with_type()`
2. **Configuration**: The function copies all EnemyType values to the Enemy instance
3. **Result**: You get customized Enemy instances without modifying enemy.gd

### Example Usage

```gdscript
# In your spawner or game manager
var fast_enemy_type = preload("res://src/resources/enemy_types/fast_enemy.tres")
var spawned_enemy = spawner.spawn_typed_enemy_at_position(position, fast_enemy_type)
# This enemy now has: speed=200, health=50, damage=15, red tint
```

## Creating Enemy Types

### 1. Create Resource Files
Create `.tres` files in `src/resources/enemy_types/`:

```
basic_enemy.tres    - Balanced stats
fast_enemy.tres     - High speed, low health  
heavy_enemy.tres    - Low speed, high health
```

### 2. Configure Properties
Set the resource type to `EnemyType` and configure:
- **name**: Display name for the enemy type
- **speed/max_health/damage**: Core stats from enemy.gd
- **target_group**: What this enemy can damage
- **texture**: Custom sprite texture (optional)
- **sprite_scale**: Size multiplier (e.g., Vector2(1.5, 1.5) for 150% size)
- **sprite_modulate**: Color tint (e.g., Color.RED for red enemies)

## Wave Integration

### WaveConfig Setup
```gdscript
# In your wave configuration
enemy_types = [basic_enemy_type, fast_enemy_type]  # Array of EnemyType resources
enemy_type_weights = [0.7, 0.3]  # 70% basic, 30% fast
```

### Automatic Application
The system automatically:
1. Selects random enemy types based on weights
2. Spawns Enemy instances from enemy.tscn
3. Applies EnemyType configuration to each instance
4. Handles all the complexity for you

## Key Benefits

- ✅ **No changes needed** to your existing `enemy.gd` class
- ✅ **Easy configuration** through resource files
- ✅ **Designer-friendly** - non-programmers can create enemy types
- ✅ **Flexible** - any property in Enemy.gd can be configured
- ✅ **Maintainable** - all enemy configurations in one place

## Advanced Usage

### Custom Textures
```gdscript
# Load different sprites for different enemy types
fast_enemy.texture = preload("res://sprites/fast_enemy.png")
heavy_enemy.texture = preload("res://sprites/tank_enemy.png")
```

### Visual Variants
```gdscript
# Create visual variants with different colors/sizes
red_enemy.sprite_modulate = Color.RED
red_enemy.sprite_scale = Vector2(0.8, 0.8)

blue_enemy.sprite_modulate = Color.BLUE  
blue_enemy.sprite_scale = Vector2(1.2, 1.2)
```

This system lets you create unlimited enemy varieties while keeping your core Enemy.gd class simple and focused on behavior!