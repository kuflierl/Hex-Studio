# Master Divergences and Long-Running Implementation Plan

This document serves as the cumulative, long-running master plan for `Hex-Studio`. It tracks completed milestones, current divergences (including missing hexes), and phased implementation steps toward full feature and semantic parity with upstream `HexMod`.

---

## 1. Completed Milestones (Phased History)

### Phase 1: Core VM & Continuation Semantics
- [x] **Continuation Jumps**: Fixed `ContinuationIota` semantics in `EvalStack.elm` to act as an execution context escape/resume (jump out) rather than a raw stack overwrite.
- [x] **Fisherman's Gambit & Gambit II**: Corrected `fisherman` and `fishermanCopy` implementation in `Stack.elm` to support both positive indices (pull up / copy up) and negative indices (move / copy top iota down).
- [x] **Type Checking**: Implemented `type_equals` (`Similarity Distillation`) and `type_not_equals` (`Similarity Distillation II`).
- [x] **List Uniqueness**: Implemented `unique` (`Uniqueness Purification`) using robust deep equality (`checkEquality`).
- [x] **Novice's Gambit**: Registered Novice's Gambit with V-shape signature (`"a"`, start direction East, action `mask [ "v" ]`) and autocomplete/search dropdown support.
- [x] **CI & Testing Automation**: Configured CI workflow (`build-deploy.yml`) to execute all test files under `tests/` automatically via `elm-test`.
- [x] **Comprehensive & Integration Test Suites**: Implemented `ComprehensiveTests.elm` and `IntegrationTests.elm` covering arithmetic, comparisons, stack manipulation, reflection, type checking, uniqueness, conditional branching, list construction, and error edge cases (all 29 tests passing successfully).

---

## 2. Current Master Divergences & Missing Hexes

### A. Missing Hex Actions & Spells (Cataloged from `HexMod`)
As detailed in `MOD_ANALYSIS.md`, the following upstream actions are not yet fully implemented in Hex-Studio:
1. **World & Entity Action Spells**: `print`, `explode`, `explode/fire`, `add_motion`, `blink`, `place_block`, `colorize`, `cycle_variant`, `destroy_water`, `ignite`, `extinguish`, `conjure_block`, `conjure_light`, `bonemeal`, `recharge`, `erase`, `edify`, `beep`
2. **Item & Artifact Crafting**: `craft/cypher`, `craft/trinket`, `craft/artifact`
3. **Potion Effects**: `potion/weakness`, `levitation`, `wither`, `poison`, `slowness`, `regeneration`, `night_vision`, `absorption`, `haste`, `strength`
4. **Great Spells (World Effects)**: `lightning`, `summon_rain`, `dispel_rain`, `sentinel/create/great`, `akashic/organs`

### B. Control Flow & Evaluation Divergences
1. **Thoth's Gambit (`for_each`) Loop Break & Accumulator**:
   - Complex nested loop breaks and multi-level accumulator rollbacks differ from JVM bytecode execution.
2. **Mishap Diagnostic Parity**:
   - Standardized mishap types (`NotEnoughIotas`, `IncorrectIota`, etc.) are used, but detailed localized diagnostic messages are not yet fully ported.

---

## 3. Long-Running Implementation Plan

### Phase 2: World, Spell & Crafting Action Simulation
- [ ] **Task 3.1**: Implement simulation handlers in `Spells.elm` and `GreatSpells.elm` for world interaction spells (`print`, `add_motion`, `blink`, `conjure_block`, `conjure_light`, crafting cyphers/trinkets/artifacts).
- [ ] **Task 3.2**: Add integration tests validating simulated spell execution and effect output in `IntegrationTests.elm`.

### Phase 3: Advanced Control Flow & Diagnostics
- [ ] **Task 4.1**: Refine `for_each` (`Thoth's Gambit`) accumulator behavior.
- [ ] **Task 4.2**: Expand mishap logging to include detailed diagnostic context.
