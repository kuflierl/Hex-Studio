# Comprehensive Mod Analysis: Upstream Hex Casting (`HexMod`)

This document provides a complete, exhaustive catalog and behavior analysis of **every** hex action (spell/pattern) present in the upstream Hex Casting mod (`HexMod`), serving as the reference standard for casting semantics, stack manipulation, meta-evaluation, and world interactions.

---

## 1. Stack Manipulation
- **Jester's Gambit (`swap`)**: Swaps the top two iotas on the stack ($A, B \rightarrow B, A$).
- **Rotation (`rotate`)**: Rotates the top 3 iotas ($A, B, C \rightarrow B, C, A$ or similar rotation).
- **Reverse Rotation (`rotate/reverse`)**: Rotates the top 3 iotas in reverse.
- **Twin Gambit (`dup`)**: Duplicates the top iota ($A \rightarrow A, A$).
- **Seer's Gambit (`drop`)**: Removes the top iota ($A \rightarrow$).
- **Alchemist's Gambit (`nuck`)**: Rotates or removes items deeper in the stack.
- **Fisherman's Gambit (`fisherman`)**: Grabs the element at index $N$ (positive index 0-indexed from top) and brings it to the top. If $N$ is negative, moves the top element down $|N|$ steps.
- **Fisherman's Gambit II (`fisherman/copy`)**: Copies the element at index $N$ to the top, or copies the top element down $|N|$ steps if $N$ is negative.
- **Swindler's Gambit (`swizzle`)**: Reorders stack elements based on index lists.
- **Duplicate N (`duplicate/n`)**: Duplicates the top $N$ items.
- **Abacus (`stack/len`)**: Pushes the current size of the stack.

---

## 2. Arithmetic & Math
- **Sum (`add`) / Sub (`sub`) / Mul (`mul`) / Div (`div`)**: Standard binary operations on numbers or vectors.
- **Power (`pow`) / Root / Log**: Exponentiation and logarithmic operations.
- **Absolute Value (`abs`) / Negate (`neg`)**: Unary number/vector transforms.
- **Modulo (`mod`)**: Remainder operation.
- **Floor (`floor`) / Ceiling (`ceil`) / Round (`round`)**: Number quantization.
- **Dot Product (`dot`) / Cross Product (`cross`) / Length (`len`) / Normalize (`normalize`)**: Vector operations.

---

## 3. Logic & Comparison
- **Equality (`equals`) / Inequality (`not_equals`)**: Compares two iotas for structural equality.
- **Greater (`greater`) / Greater or Equal (`greater_or_equal`) / Less / Less or Equal**: Numeric comparisons.
- **And (`and`) / Or (`or`) / Xor (`xor`) / Not (`not`)**: Boolean operations.
- **Condition (`if`)**: Takes a boolean and two iotas (or lists), choosing one based on the condition.

---

## 4. Reflection & Constants
- **True Reflection (`const/true`) / False Reflection (`const/false`)**: Pushes boolean values.
- **Nullary Reflection (`const/null`)**: Pushes `Null`.
- **Vector Reflections (`const/vec/0`, `const/vec/px`, `const/vec/py`, `const/vec/pz`, etc.)**: Pushes standard unit vectors or zero vector.
- **Constant Reflections (`pi`, `tau`, `e`)**: Pushes mathematical constants.
- **Number Literals (`number_literal`)**: Encodes floats/doubles via angle signatures.

---

## 5. Lists
- **List Construct (`list/construct`)**: Creates a list from $N$ items on the stack.
- **List Concat (`list/concat`)**: Concatenates two lists.
- **List Append (`list/append`)**: Appends an item to a list.
- **List Index (`list/index`)**: Retrieves an element from a list at an index.
- **List Slice (`list/slice`)**: Extracts a sublist.
- **List Size (`list/size`)**: Pushes the length of a list.
- **Vacant Reflection (`empty_list`)**: Pushes an empty list `[]`.
- **Car (`list/car`) / Cdr (`list/cdr`)**: Head and tail operations on lists.

---

## 6. Selectors & Entity / World Queries
- **Entity Look (`get/entity/look`)**: Finds entities in the caster's line of sight.
- **Entity Radius (`get/entity/radius`)**: Finds entities within a bounding sphere.
- **Entity Filters (`living`, `animal`, `monster`, `item`, `player`)**: Filters entity sets.
- **Block Select (`get/block/select`) / Raycast (`get/block/raycast`)**: Queries world blocks and raycast hits.
- **Entity Properties (`entity/pos`, `entity/eye_pos`, `entity/look`, `entity/velocity`, `entity/rotation`)**: Inspects entity attributes.

---

## 7. Meta-Evaluation & Control Flow
- **Hermes' Gambit (`eval`)**: Removes an evaluatable (list, pattern, or continuation) from the stack and casts/evaluates it.
- **Iris' Gambit (`eval_cc`)**: Captures the current continuation and pushes a jump continuation before evaluating a target expression. When executed, a continuation acts as a jump/escape out of the current evaluatable.
- **Thoth's Gambit (`for_each`)**: Iterates over a list, applying an evaluatable to each element with accumulator support.
- **Charon's Gambit (`halt`)**: Halts execution of the current spell.
- **Consideration (`consideration`)**: Escapes/considers an iota without executing it during meta-eval.
- **Introspection (`open_paren`) / Retrospection (`close_paren`)**: Groups patterns into a list literal on the stack.
- **Bookkeeper's Gambit (`bookkeeper`)**: Stack manipulation via dot/dash patterns (e.g. `--`, `-+`, etc.).

---

## 8. Read / Write & Foci
- **Read (`read`) / Write (`write`)**: Interacts with Focus items (storing and recalling iotas).
- **Item Queries (`item/remove`, `item/count`, `item/tag`)**: Inventory and item inspections.

---

## 9. Great Spells
- **Flight (`greater/flight`)**: Grants temporary creative flight to the caster.
- **Teleport (`greater/teleport`)**: Moves entities across space.
- **Create Water (`greater/create_water`)**: Spawns water blocks.
- **Destroy Block (`greater/destroy_block`)**: Breaks blocks in the world.
- **Craft (`greater/craft`)**: Executes recipe crafting via magic.
- **Brainsweep (`greater/brainsweep`)**: Converts villagers into specialized workers.
- **Akashic Records (`greater/akashic/read`, `greater/akashic/write`)**: Interacts with persistent global storage networks.

---

## 10. Circles of Power
- Patterns for carving slate, powering media circles, and running autonomous continuous spell loops.
