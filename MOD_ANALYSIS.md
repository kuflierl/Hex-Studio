# Comprehensive Mod Analysis & Missing Hexes Catalog

This document provides a complete catalog of upstream Hex Casting (`HexMod`) actions, their behaviors, and an explicit inventory of hexes currently missing from `Hex-Studio`.

---

## 1. Complete Inventory of Upstream Hexes (`HexMod`)

### A. Stack Manipulation
- `swap` (Jester's Gambit)
- `rotate` (Rotation Gambit)
- `rotate_reverse` (Rotation Gambit II)
- `duplicate` (Gemini Decomposition)
- `over` (Prospector's Gambit)
- `tuck` (Undertaker's Gambit)
- `2dup` (Dioscuri Gambit)
- `stack_len` (Flock's Reflection)
- `duplicate_n` (Gemini Gambit)
- `fisherman` (Fisherman's Gambit)
- `fisherman/copy` (Fisherman's Gambit II)
- `swizzle` (Swindler's Gambit)
- `unique` (Unique stack manipulation)

### B. Arithmetic & Math
- `add` (Additive Distillation)
- `sub` (Subtractive Distillation)
- `mul` (Multiplicative Distillation)
- `div` (Division Distillation)
- `abs` (Length Purification)
- `pow` (Power Distillation)
- `floor` (Floor Purification)
- `ceil` (Ceiling Purification)
- `construct_vec` (Vector Exaltation)
- `deconstruct_vec` (Vector Disintegration)
- `coerce_axial` (Axial Purification)
- `sin`, `cos`, `tan`, `arcsin`, `arccos`, `arctan`, `arctan2`
- `logarithm` (Logarithmic Distillation)
- `modulo` (Modulus Distillation)
- `and_bit`, `or_bit` (Bitwise operations)

### C. Logic & Comparison
- `and` (Conjunction Distillation)
- `or` (Disjunction Distillation)
- `not` (Negation Purification)
- `xor` (Exclusion Distillation)
- `greater` (Maximus Distillation)
- `less` (Minimus Distillation)
- `greater_eq` (Maximus Distillation II)
- `less_eq` (Minimus Distillation II)
- `equals` (Equality Distillation)
- `not_equals` (Inequality Distillation)
- `type_equals`, `type_not_equals` (Type checking)
- `bool_coerce` (Augur's Purification)
- `if` (Augur's Exaltation)
- `random` (Entropy Reflection)

### D. Selectors & Entity / World Queries
- `get_caster` (Mind's Reflection)
- `entity_pos/eye`, `entity_pos/foot` (Compass' Purification I & II)
- `get_entity_look` (Alidade's Purification)
- `get_entity_height` (Stadiometer's Purification)
- `get_entity_velocity` (Pace Purification)
- `raycast` (Archer's Distillation)
- `raycast/axis` (Architect's Distillation)
- `raycast/entity` (Scout's Distillation)
- `get_media` (Media queries)

### E. Spells & World Interaction
- `print` (Chat output)
- `explode`, `explode/fire` (Explosions)
- `add_motion`, `blink` (Movement spells)
- `break_block`, `place_block`
- `colorize`, `cycle_variant`
- `create_water`, `destroy_water`
- `ignite`, `extinguish`
- `conjure_block`, `conjure_light`
- `bonemeal`
- `recharge`, `erase`, `edify`, `beep`
- `craft/cypher`, `craft/trinket`, `craft/artifact`, `craft/battery`
- Potion spells (`potion/weakness`, `levitation`, `wither`, `poison`, `slowness`, `regeneration`, `night_vision`, `absorption`, `haste`, `strength`)

### F. Great Spells
- `lightning` (Summon Lightning)
- `summon_rain`, `dispel_rain`
- `teleport` (Greater Teleport)
- `sentinel/create/great` (Summon Greater Sentinel)
- `craft/battery` (Craft Phial)
- `brainsweep` (Flay Mind)
- `akashic/read`, `akashic/write`, `akashic/organs` (Akashic records)

---

## 2. Complete List of Missing Hexes in `Hex-Studio`

The following actions present in `HexMod` are currently missing or stubbed in `Hex-Studio`:
1. **Type Checking**: `type_equals`, `type_not_equals`
2. **Advanced Stack/List Utils**: `unique`
3. **Advanced Math**: `arctan2`, bitwise operations (`and_bit`, `or_bit`), and trigonometric variations (`arcsin`, `arccos`, `arctan`, `tan`).
4. **World/Entity Spells**: `print`, `explode`, `explode/fire`, `add_motion`, `blink`, `place_block`, `colorize`, `cycle_variant`, `destroy_water`, `ignite`, `extinguish`, `conjure_block`, `conjure_light`, `bonemeal`, `recharge`, `erase`, `edify`, `beep`.
5. **Crafting & Artifact Spells**: `craft/cypher`, `craft/trinket`, `craft/artifact`.
6. **Potion Spells**: All potion application spells (`weakness`, `levitation`, `wither`, `poison`, `slowness`, `regeneration`, `night_vision`, `absorption`, `haste`, `strength`).
7. **Great Spells (Full World Effect)**: `lightning`, `summon_rain`, `dispel_rain`, `sentinel/create/great`, `akashic/organs`.
