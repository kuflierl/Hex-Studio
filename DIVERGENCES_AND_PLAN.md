# Divergences and Implementation Plan

This document outlines the current divergences between `Hex-Studio` (the Elm port) and upstream `HexMod`, followed by an implementation plan for achieving full semantic and feature parity.

---

## 1. Current Divergences

1. **Thoth's Gambit (`for_each`) & Complex Accumulators**:
   - Upstream Hex Casting handles list iteration and loop continuation capture with robust frame tracking. While `for_each` is implemented in Elm, certain nested loop escape or mishap propagation edge cases may differ slightly from Kotlin JVM execution.
2. **Great Spells & World Interaction**:
   - Hex-Studio operates primarily as a stack/eval VM simulator (patterns, math, lists, stack manipulation, meta-evaluation). World-altering great spells (e.g., Akashic records, teleportation, entity/block manipulation) are stubbed or mocked in the browser/Elm environment because there is no live Minecraft world state.
3. **Mishap System Granularity**:
   - Upstream HexMod features a very fine-grained mishap system with localized error types and feedback. Hex-Studio implements core mishaps (`NotEnoughIotas`, `IncorrectIota`, `MathematicalError`, `CatastrophicFailure`), but some specific niche mishap conditions might use fallback errors.

---

## 2. Implementation Plan

### Phase 1: Core VM & Continuation Semantics Parity (Completed)
- [x] Refactor `ContinuationIota` to model jump continuation semantics correctly (escape/resume rather than raw stack overwrite).
- [x] Ensure nested `eval/cc` and empty continuation jumps function identically to upstream Hex Casting models.
- [x] Implement correct positive and negative indexing for Fisherman's Gambit (`fisherman`) and Fisherman's Gambit II (`fisherman/copy`).

### Phase 2: Codebase Organization & Testing
- [x] Centralize helper functions (like array insertion) into `Logic.App.Utils.Utils.elm`.
- [x] Expand test coverage with dedicated test suites (`IrisTests.elm`, `FishermanTests.elm`).
- [x] Update CI workflow (`build-deploy.yml`) to automatically execute all Elm tests.

### Phase 3: Future Parity Enhancements (Roadmap)
- [ ] Refine `for_each` (Thoth's Gambit) execution states to match upstream loop escape semantics.
- [ ] Enhance macro expansion and library integration to mirror Akashic Record storage models more closely.
- [ ] Expand error reporting and mishap details to match HexMod's exact diagnostic messages.
