# Mod Analysis: Upstream Hex Casting (`HexMod`) vs Hex-Studio

This document analyzes the implementation of key casting mechanics and stack operations in the upstream Java/Kotlin Minecraft mod (`HexMod`) compared to the Elm implementation (`Hex-Studio`).

---

## 1. Stack Manipulation Operators (`Fisherman's Gambit` & `Fisherman's Gambit II`)

### Upstream (`HexMod`) Implementation
- **Fisherman's Gambit (`OpFisherman`)**:
  - Requires at least 2 arguments on the stack.
  - Pops the top integer index $N$ (`depth`).
  - If $N \ge 0$, removes the iota at index $N$ from the top of the remaining stack and pushes it to the top.
  - If $N < 0$ (negative index), pops the top iota of the remaining stack and inserts it $N$ steps down into the stack (`stack.size + depth`).
- **Fisherman's Gambit II (`OpFishermanButItCopies`)**:
  - Similar to Fisherman's Gambit, but instead of removing/moving the iota, it copies (duplicates) the selected iota (if $N \ge 0$) or copies the top iota down $N$ steps (if $N < 0$).

### Elm Port Implementation (`Stack.elm` & `Utils.elm`)
- Implements `fisherman` and `fishermanCopy`:
  - Extracts the top integer argument via `getInteger`.
  - Checks if `depth >= 0`: performs 0-indexed retrieval/removal (`removeFromArray` / `Array.get`) and pushes/copies to the top.
  - Checks if `depth < 0`: takes the top iota of the remaining stack, and inserts it $N$ steps down using `insertArray` (`List.take` / `List.drop` helper).

---

## 2. Meta-Evaluation and Continuation Semantics (`Hermes' Gambit` & `Iris' Gambit`)

### Upstream (`HexMod`) Implementation
- **Hermes' Gambit (`eval`)**: Executes an evaluatable (list of patterns, pattern, or continuation).
- **Iris' Gambit (`eval/cc`)**: Captures the current continuation (`SpellContinuation`) and pushes a jump continuation onto the stack before evaluating the target.
- **Continuations as Jumps**: Continuation iotas represent saved execution contexts. When evaluated, they act as a control-flow escape (goto/break) out of the current evaluation frame, resuming the saved execution context rather than resetting or replacing the entire data stack.

### Elm Port Implementation (`EvalStack.elm`)
- Modeled `ContinuationState` containing remaining execution instructions (`stack : Array Iota`) and `CastingContext`.
- When `eval` encounters a `ContinuationIota`, it evaluates the saved continuation instructions on the current data stack and sets `halted = true` to immediately break out of the enclosing pattern loop (`applyToStackLoop`).

---

## 3. Other Stack & Math Operators
- **Swap / Jester's Gambit (`aawdd`)**, **Rotate**, **Swizzle**, **Duplicate**, etc. operate on the top few stack elements according to standard Hex Casting specifications.
- Arithmetic and vector operations utilize safe evaluation with NaN/infinity checks and mishap handling (`MathematicalError`, `IncorrectIota`, `NotEnoughIotas`, etc.).
