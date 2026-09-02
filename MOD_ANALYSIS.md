# Comprehensive Mod Analysis: Upstream Hex Casting (`HexMod`) Functional Reference

This document provides a complete, exhaustive catalog and detailed functional description of every hex action, pattern, and spell present in the upstream Hex Casting mod (`HexMod`), serving as the definitive behavioral specification.

---

## 1. Stack Manipulation
- **Jester's Gambit (`swap`, signature: `aawdd`)**: Swaps the top two iotas on the stack ($A, B \rightarrow B, A$).
- **Rotation Gambit (`rotate`, signature: `aaeaa`)**: Rotates the top 3 iotas ($A, B, C \rightarrow B, C, A$).
- **Rotation Gambit II (`rotate_reverse`, signature: `ddqdd`)**: Rotates the top 3 iotas in reverse ($A, B, C \rightarrow C, A, B$).
- **Gemini Decomposition (`duplicate`, signature: `aadaa`)**: Duplicates the top iota ($A \rightarrow A, A$).
- **Prospector's Gambit (`over`, signature: `aaedd`)**: Duplicates the second iota to the top ($A, B \rightarrow A, B, A$).
- **Undertaker's Gambit (`tuck`, signature: `ddqaa`)**: Places the top iota beneath the second iota.
- **Dioscuri Gambit (`2dup`, signature: `aadadaaw`)**: Duplicates the top two iotas ($A, B \rightarrow A, B, A, B$).
- **Flock's Reflection (`stack_len`, signature: `qwaeawqaeaqa`)**: Pushes the current size of the stack as a number.
- **Gemini Gambit (`duplicate_n`, signature: `aadaadaa`)**: Duplicates the top $N$ items based on an integer argument.
- **Fisherman's Gambit (`fisherman`, signature: `ddad`)**: Grabs the element at index $N$ (positive index 0-indexed from top) and brings it to the top. If $N$ is negative, moves the top element down $|N|$ steps.
- **Fisherman's Gambit II (`fisherman/copy`, signature: `aada`)**: Copies the element at index $N$ to the top, or copies the top element down $|N|$ steps if $N$ is negative.
- **Swindler's Gambit (`swizzle`, signature: `qaawdde`)**: Reorders stack elements based on index arrays.
- **Bookkeeper's Gambit (`mask`, signatures: `v-`, `-v`, `vv`, etc.)**: Evaluates a bitmask of dashes and wedges to drop or keep specific items on the stack.
- **Novice's Gambit (`mask [ "v" ]`, signature: `a`)**: Removes the first iota from the stack as a special case of Bookkeeper's Gambit.
- **Uniqueness Purification (`unique`, signature: `aweaqa`)**: Removes duplicate elements from a list using deep equality.

---

## 2. Arithmetic & Math
- **Additive Distillation (`add`, signature: `waaw`)**: Adds two numbers or vectors together ($A + B$).
- **Subtractive Distillation (`sub`, signature: `wddw`)**: Subtracts two numbers or vectors ($A - B$).
- **Multiplicative Distillation (`mul`, signature: `waqaw`)**: Multiplies numbers or computes dot products for vectors.
- **Division Distillation (`div`, signature: `wdedw`)**: Divides numbers or computes cross products for vectors.
- **Length Purification (`abs`, signature: `wqaqw`)**: Computes absolute value or vector length.
- **Power Distillation (`pow`, signature: `wedew`)**: Computes exponentiation ($A^B$).
- **Floor Purification (`floor`, signature: `ewq`)**: Rounds number down.
- **Ceiling Purification (`ceil`, signature: `qwe`)**: Rounds number up.
- **Vector Exaltation (`construct_vec`, signature: `eqqqqq`)**: Constructs a vector from 3 numbers.
- **Vector Disintegration (`deconstruct_vec`, signature: `qeeeee`)**: Deconstructs a vector into 3 numbers.
- **Axial Purification (`coerce_axial`, signature: `qqqqqaww`)**: Snaps vector to nearest axis.
- **Trigonometric Functions (`sin`, `cos`, `tan`, `arcsin`, `arccos`, `arctan`, `arctan2`)**: Trigonometric operations.
- **Logarithmic Distillation (`logarithm`, signature: `eqaqe`)**: Computes logarithms.
- **Modulus Distillation (`modulo`, signature: `addwaad`)**: Computes remainder.
- **Bitwise Operations (`and_bit`, `or_bit`, `xor_bit`, `not_bit`)**: Bitwise logic on integers.

---

## 3. Logic & Comparison
- **Conjunction Distillation (`and`, signature: `wdw`)**: Boolean AND.
- **Disjunction Distillation (`or`, signature: `waw`)**: Boolean OR.
- **Negation Purification (`not`, signature: `dw`)**: Boolean NOT.
- **Exclusion Distillation (`xor`, signature: `dwa`)**: Boolean XOR.
- **Maximus Distillation (`greater`, signature: `e`)**: Greater than ($A > B$).
- **Minimus Distillation (`less`, signature: `q`)**: Less than ($A < B$).
- **Maximus Distillation II (`greater_eq`, signature: `ee`)**: Greater than or equal ($A \ge B$).
- **Minimus Distillation II (`less_eq`, signature: `qq`)**: Less than or equal ($A \le B$).
- **Equality Distillation (`equals`, signature: `ad`)**: Structural equality ($A = B$).
- **Inequality Distillation (`not_equals`, signature: `da`)**: Structural inequality ($A \neq B$).
- **Similarity Distillation (`type_equals`, signature: `wawdw`)**: Compares if two iotas have the same type.
- **Similarity Distillation II (`type_not_equals`, signature: `wdwaw`)**: Compares if two iotas have different types.
- **Augur's Purification (`bool_coerce`, signature: `aw`)**: Coerces iota to boolean truth value.
- **Augur's Exaltation (`if`, signature: `awdd`)**: Conditional branch selector.
- **Entropy Reflection (`random`, signature: `eqqq`)**: Pushes pseudorandom number between 0 and 1.

---

## 4. Reflection & Constants
- **True Reflection (`const/true`, signature: `aqae`)**: Pushes boolean `True`.
- **False Reflection (`const/false`, signature: `dedq`)**: Pushes boolean `False`.
- **Nullary Reflection (`const/null`, signature: `d`)**: Pushes `Null`.
- **Vector Reflections (`const/vec/0`, `+x`, `+y`, `+z`, `-x`, `-y`, `-z`)**: Pushes direction vectors.
- **Mathematical Reflections (`pi`, `tau`, `e`)**: Pushes mathematical constants.

---

## 5. Lists
- **List Construct (`list/construct`, signature: `qaw`)**: Constructs list from elements.
- **List Concat (`list/concat`, signature: `qaeaq`)**: Concatenates lists.
- **List Append (`list/append`, signature: `edqde`)**: Appends iota to list.
- **List Index (`list/index`, signature: `deeed`)**: Retrieves item at index.
- **List Slice (`list/slice`, signature: `qaeaqwded`)**: Extracts sublist.
- **List Size (`list/size`, signature: `aqaeaq`)**: Returns length of list.
- **Vacant Reflection (`empty_list`, signature: `qqaeaae`)**: Pushes empty list `[]`.
- **Car / Cdr (`construct`, `deconstruct`)**: Head and tail list operations.

---

## 6. Selectors & Entity / World Queries
- **Mind's Reflection (`get_caster`, signature: `qaq`)**: Pushes caster entity.
- **Compass' Purification (`entity_pos/eye`, `entity_pos/foot`)**: Pushes position vectors.
- **Alidade's Purification (`get_entity_look`, signature: `wa`)**: Pushes entity look vector.
- **Stadiometer's Purification (`get_entity_height`, signature: `awq`)**: Pushes entity height.
- **Pace Purification (`get_entity_velocity`, signature: `wq`)**: Pushes entity velocity.
- **Archer's Distillation (`raycast`, signature: `wqaawdd`)**: Raycasts to find block intersection.
- **Entity & Zone Selectors (`get_entity/*`, `zone_entity/*`)**: Queries entities by radius and type (animals, monsters, players, items, living).

---

## 7. Meta-Evaluation & Control Flow
- **Hermes' Gambit (`eval`, signature: `deaqq`)**: Evaluates evaluatable from stack.
- **Iris' Gambit (`eval_cc`, signature: `qwaqde`)**: Captures continuation and pushes jump continuation.
- **Thoth's Gambit (`for_each`, signature: `dadad`)**: Iterates over list applying evaluatable.
- **Charon's Gambit (`halt`, signature: `aqdee`)**: Halts execution.
- **Consideration (`escape`, signature: `qqqaw`)**: Escapes iota.
- **Introspection (`open_paren`, signature: `qqq`) / Retrospection (`close_paren`, signature: `eee`)**: Group patterns into list literal.

---

## 8. Read / Write & Foci
- **Scribe's Reflection (`read`, signature: `aqqqqq`)**: Reads from active Focus.
- **Scribe's Gambit (`write`, signature: `deeeee`)**: Writes iota to active Focus.
- **Chronicler's Purification / Gambit (`read/entity`, `write/entity`)**: Entity item inventory read/write.
- **Muninn's Reflection / Huginn's Gambit (`read/local`, `write/local`)**: Local variable storage.

---

## 9. Great Spells
- **Flight (`greater/flight`)**: Grants temporary creative flight.
- **Greater Teleport (`teleport`)**: Teleports entities across space.
- **Create Water (`create_water`) / Destroy Liquid (`destroy_water`)**: Fluid manipulation.
- **Break Block (`break_block`) / Place Block (`place_block`)**: World block editing.
- **Ignite (`ignite`) / Extinguish (`extinguish`)**: Fire manipulation.
- **Conjure Block (`conjure_block`) / Conjure Light (`conjure_light`)**: Conjuration spells.
- **Overgrow (`bonemeal`)**: Accelerates plant growth.
- **Flay Mind (`brainsweep`)**: Converts villagers into specialized workers.
- **Akasha's Distillation / Gambit (`akashic/read`, `akashic/write`)**: Persistent global storage networks.
- **Summon Lightning (`lightning`)**: Summons lightning bolt.
- **Summon/Dispel Rain (`summon_rain`, `dispel_rain`)**: Weather control.
- **Craft Cypher / Trinket / Artifact (`craft/*`)**: Magic item crafting.

---

## 10. Circles of Power
- **Waystone Reflection (`circle/impetus_pos`)**: Returns impetus position of rune circle.
- **Lodestone Reflection (`circle/impetus_dir`)**: Returns impetus facing direction.
- **Lesser / Greater Fold Reflection (`circle/bounds/*`)**: Returns rune circle boundaries.
