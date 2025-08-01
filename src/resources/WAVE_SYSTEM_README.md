# Wave Management System

This system provides a comprehensive wave management solution for your game, allowing you to configure different enemy types and wave patterns using resources.

## Components

### 1. EnemyType Resource (`enemy_type.gd`)
Defines different types of enemies with their properties:
- **Visual**: texture, scale, modulate_color
- **Stats**: speed, max_health, damage
- **Behavior**: target_group, movement_type, special_abilities
- **Rewards**: score_value, currency_drop

### 2. WaveConfig Resource (`wave_config.gd`)
Defines wave behavior and composition:
- **Spawners**: which directional spawners to use
- **Enemies**: types of enemies and their spawn probabilities
- **Timing**: spawn intervals, duration, delays
- **Counts**: total enemies, simultaneous enemies
- **Behavior**: repeating waves, difficulty multipliers

### 3. EnemySpawner (`enemy_spawner.gd`)
Enhanced with enemy type support:
- Configure with different enemy types
- Apply enemy configurations automatically
- Support for weighted random enemy selection

### 4. GameMap (`game_map.gd`)
Central wave management system:
- References north, south, east, west spawners
- Manages multiple concurrent waves
- Handles wave timing and completion
- Supports repeating waves

## Setup Instructions

### 1. Scene Setup
1. Add your GameMap script to your main game scene
2. Add EnemySpawner nodes as children named:
   - `NorthSpawner`
   - `SouthSpawner` 
   - `EastSpawner`
   - `WestSpawner`
3. Or manually assign spawners to the GameMap's exported variables

### 2. Create Enemy Types
1. Create `.tres` files in `src/resources/enemy_types/`
2. Set the resource type to `EnemyType`
3. Configure properties like speed, health, damage, etc.

Example enemy types provided:
- `basic_enemy.tres` - Standard balanced enemy
- `fast_enemy.tres` - Fast, low health enemy  
- `heavy_enemy.tres` - Slow, high health enemy

### 3. Create Wave Configurations
1. Create `.tres` files in `src/resources/waves/`
2. Set the resource type to `WaveConfig`
3. Configure spawner directions, enemy types, timing, etc.

Example waves provided:
- `wave_north_south.tres` - Uses north and south spawners
- `wave_east_west.tres` - Uses east and west spawners

### 4. Assign to GameMap
In your GameMap scene:
1. Set the `wave_configs` array to include your wave resources
2. The system will automatically start the first two waves on `_ready()`

## Key Features

### Automatic Wave Management
- Waves start automatically based on configuration
- Supports multiple concurrent waves
- Handles wave completion detection
- Automatic cleanup of finished waves

### Repeating Waves
Set `is_repeating = true` and `repeat_interval` to create recurring waves.

### Weighted Enemy Selection
Use `enemy_type_weights` array to control spawn probability of different enemy types.

### Flexible Spawner Assignment
Each wave can use any combination of directional spawners.

## API Reference

### GameMap Functions
- `start_wave(index)` - Start a specific wave
- `stop_all_waves()` - Stop all active waves
- `get_total_living_enemies()` - Count all enemies on map
- `print_wave_status()` - Debug information

### EnemySpawner Functions
- `set_enemy_types(types, weights)` - Configure enemy types
- `configure_from_wave(wave_config)` - Auto-configure from wave
- `spawn_typed_enemy_at_position(pos, type)` - Spawn specific enemy type

## Signals
- `wave_started(wave_config)` - Emitted when wave begins
- `wave_completed(wave_config)` - Emitted when wave ends
- `all_waves_completed()` - Emitted when all waves finished

## Tips
1. Start with 2-3 basic enemy types
2. Use repeating waves for continuous action
3. Balance enemy stats for proper difficulty progression
4. Test wave timing to avoid overwhelming the player
5. Use the debug functions to monitor wave status