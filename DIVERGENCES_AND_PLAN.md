# Comprehensive Divergences and Implementation Plan

This document details all current architectural and functional divergences between `Hex-Studio` (the Elm port) and upstream `HexMod` (Minecraft Java/Kotlin mod), followed by a structured implementation plan to achieve full feature and semantic parity.

---

## 1. Comprehensive Inventory of Divergences

### A. Meta-Evaluation & Control Flow
1. **Thoth's Gambit (`for_each`) Accumulator & Break Semantics**:
   - *Upstream (`HexMod`)*: Allows breaking out of loops or accumulating state across iterations with precise handling of nested halts and continuation capture.
   - *Hex-Studio*: Implements basic list iteration, but complex nested loop breaks and multi-level accumulator rollbacks differ in edge cases.
2. **Mishap & Error Diagnostic Parity**:
   - *Upstream (`HexMod`)*: Generates detailed, localized mishap messages with exact argument indices and contextual error data.
   - *Hex-Studio*: Uses standard mishap types (`NotEnoughIotas`, `IncorrectIota`, `MathematicalError`, `CatastrophicFailure`) without fully localized diagnostic descriptions.

### B. World Interaction & Great Spells
1. **World State & Physics Simulation**:
   - *Upstream (`HexMod`)*: Interacts directly with Minecraft blocks, entities, physics, server ticks, and player inventories.
   - *Hex-Studio*: Simulates casting purely as a stack/eval VM in browser memory. World-affecting great spells (e.g., `greater/flight`, `greater/teleport`, `greater/destroy_block`, `greater/brainsweep`) are mocked or operate on a simplified mock casting context.
2. **Akashic Records (`akashic/read`, `akashic/write`)**:
   - *Upstream (`HexMod`)*: Accesses persistent global data storage across dimensions/servers.
   - *Hex-Studio*: Uses an in-memory `libraries` dictionary in `CastingContext`.

### C. Entity & Item Contexts
1. **Trinkets, Foci, and Staff Integration**:
   - *Upstream (`HexMod`)*: Inspects actual player inventory, equipped foci, cyphers, artifacts, and trinket slots.
   - *Hex-Studio*: Relies on mock `entities` dictionary and `HeldItem` states in `CastingContext`.

---

## 2. Implementation Plan

### Phase 1: Core VM & Pattern Semantics (Completed)
- [x] Fix continuation jump semantics for `eval/cc` (`Iris' Gambit`) and `eval` (`Hermes' Gambit`).
- [x] Correct positive and negative indexing behavior for Fisherman's Gambit (`fisherman`) and Fisherman's Gambit II (`fisherman/copy`).
- [x] Centralize array insertion utility in `Utils.elm`.

### Phase 2: Control Flow & Loop Refinement (In Progress / Planned)
- [ ] **Task 2.1**: Enhance `for_each` (`Thoth's Gambit`) execution loop to mirror upstream accumulation and loop-break handling precisely.
- [ ] **Task 2.2**: Improve mishap propagation during meta-evaluation so that inner errors correctly bubble up and trigger immediate failure without corrupting timelines.

### Phase 3: Context & Environment Simulation
- [ ] **Task 3.1**: Expand `CastingContext` and mock entity/item management to support full focus read/write persistence across casting sessions.
- [ ] **Task 3.2**: Add support for macro expansion persistence and project sharing formats matching upstream Hexbook / give-command exports.

### Phase 4: Testing & Quality Assurance
- [ ] **Task 4.1**: Add comprehensive unit test suites for all arithmetic, list, selection, and stack manipulation operators.
- [ ] **Task 4.2**: Verify CI/CD pipeline (`build-deploy.yml`) successfully executes all tests on every push.
