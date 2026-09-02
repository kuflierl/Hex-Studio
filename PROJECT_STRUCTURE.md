# Project Structure & Comprehensive Hex Implementation: Hex-Studio

Hex-Studio is an Elm implementation and interactive studio for **Hex Casting**. This document details the project's architecture, code flow, and the complete inventory of hexes/patterns implemented across the project modules.

---

## 1. Directory Overview & Architecture

```text
/workspaces/Hex-Studio/
├── src/
│   ├── Main.elm                     -- Application entry point and Elm architecture wiring
│   ├── Components/                  -- UI view components (Grid, Timeline, Content, LeftBox, RightBox, Panels, Menus)
│   ├── Logic/
│   │   └── App/
│   │       ├── Model.elm            -- Main application state model
│   │       ├── Msg.elm              -- Message types for Elm updates
│   │       ├── Grid.elm             -- Hex grid geometry and stroke handling
│   │       ├── PatternList/         -- Pattern sequence management
│   │       ├── ImportExport/        -- Project import/export and text/give command serializers
│   │       ├── Stack/               -- Evaluation VM stack execution engine (EvalStack.elm)
│   │       ├── Patterns/            -- Registry and implementations of all Hex Casting patterns
│   │       │   ├── PatternRegistry.elm -- Central registry mapping signatures to patterns & actions
│   │       │   ├── OperatorUtils.elm   -- Action helpers (arity checks, input getters, constants)
│   │       │   ├── Stack.elm           -- Stack manipulation (swap, rotate, dup, drop, fisherman, etc.)
│   │       │   ├── Math.elm            -- Arithmetic, vector math, comparisons
│   │       │   ├── Lists.elm           -- List construction, indexing, slice, car, cdr
│   │       │   ├── Spells.elm          -- World spells, raycast, entity interactions
│   │       │   ├── Selectors.elm       -- Entity and block selectors
│   │       │   ├── MetaActions.elm     -- Introspection, retrospection, escape
│   │       │   ├── ReadWrite.elm       -- Focus read/write, bookkeepers
│   │       │   ├── GreatSpells.elm     -- Great spells (teleport, flight, etc.)
│   │       │   ├── Circles.elm         -- Circles and slate actions
│   │       │   └── Misc.elm            -- Miscellaneous utilities
│   │       ├── Macros/              -- Macro expansion logic
│   │       └── Utils/               -- General utility helpers (array insertion, unshift, etc.)
│   └── Ports/                       -- JavaScript interop ports
├── tests/
│   ├── IrisTests.elm                -- Regression tests for eval/cc and continuation semantics
│   └── FishermanTests.elm           -- Tests for Fisherman's Gambit and Gambit II (positive & negative indices)
├── HexMod/                          -- Upstream Hex Casting mod reference codebase (Java/Kotlin)
└── .github/workflows/               -- CI/CD build and test workflows
```

---

## 2. Code Flow: UI -> Parsing -> Evaluation -> State & Timeline

1. **User Input / UI (`Components/`)**:
   - The user draws a pattern stroke on the hex grid (`Grid.elm`) or selects/imports a pattern sequence.
   - Pattern signatures and sequence lists are managed in `PatternList/` and project state (`Model.elm`).
2. **Parsing & Resolution (`PatternRegistry.elm`, `ImportParser.elm`)**:
   - Signatures are resolved to `Pattern` records via `getPatternFromSignature`, handling number literals (`aqaa...`), bookkeeper codes (`--`, `-+`), macros, and great spells.
3. **VM Evaluation (`EvalStack.elm`)**:
   - `applyToStackStopAtErrorOrHalt` processes the pattern list against the stack and casting context.
   - `applyPatternToStack` executes individual pattern actions, managing introspection (`open_paren` / `close_paren`), consideration (`escape`), and meta-evaluation (`eval`, `eval_cc`, `for_each`).
   - Continuation iotas (`ContinuationIota`) handle control flow escapes/jumps correctly.
4. **State & Timeline (`Model.elm`, `Timeline.elm`)**:
   - The resulting stack state, execution success, and step-by-step timeline of stack states are returned and stored in the application model to render the timeline and stack UI.

---

## 3. Comprehensive Inventory of Implemented Hexes in Hex-Studio

Hex-Studio implements a wide subset of Hex Casting patterns across its pattern modules:

- **Stack Manipulation (`Stack.elm`)**:
  - `swap` (Jester's Gambit), `rotate`, `rotate/reverse`, `dup` (Twin Gambit), `drop` (Seer's Gambit), `fisherman` (Fisherman's Gambit - supporting positive pull-up and negative move-down), `fisherman/copy` (Fisherman's Gambit II), `swizzle`, `duplicate/n`.
- **Math & Arithmetic (`Math.elm`)**:
  - `add`, `sub`, `mul`, `div`, `abs`, `pow`, `mod`, vector dot/cross products, vector length, vector normalization, comparisons (`equals`, `greater`, `less`, etc.).
- **Lists (`Lists.elm`)**:
  - `list/construct`, `list/concat`, `list/append`, `list/index`, `list/slice`, `list/size`, `empty_list` (Vacant Reflection), `list/car`, `list/cdr`.
- **Reflection & Constants (`PatternRegistry.elm` / `OperatorUtils.elm`)**:
  - `const/true`, `const/false`, `const/null`, unit vectors (`const/vec/0`, `+x`, `+y`, `+z`, `-x`, `-y`, `-z`), mathematical constants (`pi`, `tau`, `e`), number literals.
- **Meta-Evaluation & Control Flow (`EvalStack.elm`, `MetaActions.elm`)**:
  - `eval` (Hermes' Gambit), `eval_cc` (Iris' Gambit), `for_each` (Thoth's Gambit), `halt` (Charon's Gambit), `escape` (Consideration), `open_paren` (Introspection), `close_paren` (Retrospection), bookkeeper patterns.
- **Read / Write (`ReadWrite.elm`)**:
  - Focus `read` and `write`, item count/tag queries.
- **Selectors & Spells (`Selectors.elm`, `Spells.elm`)**:
  - Entity look, radius, block selection, raycast.
- **Great Spells & Circles (`GreatSpells.elm`, `Circles.elm`)**:
  - Flight, teleport, create water, destroy block, brainsweep, slate actions.
