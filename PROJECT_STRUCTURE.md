# Project Structure: Hex-Studio

Hex-Studio is an Elm-based implementation and interactive studio for **Hex Casting** (a Minecraft mod centered around stack-based spell programming and meta-evaluation).

---

## Directory Overview

```text
/workspaces/Hex-Studio/
├── src/
│   ├── Main.elm                     -- Application entry point and main Elm architecture wiring
│   ├── Components/                  -- UI view components (Grid, Timeline, Content, LeftBox, RightBox, Panels, Menus)
│   ├── Logic/
│   │   └── App/
│   │       ├── Model.elm            -- Main application state model
│   │       ├── Msg.elm              -- Message types for Elm architecture updates
│   │       ├── Grid.elm             -- Hex grid geometry and stroke handling
│   │       ├── PatternList/         -- Pattern sequence management
│   │       ├── ImportExport/        -- Project import/export and text/give command serializers
│   │       ├── Stack/               -- Evaluation VM stack execution engine (EvalStack.elm)
│   │       ├── Patterns/            -- Registry of all Hex Casting patterns, operators, and math/stack actions
│   │       ├── Macros/              -- Macro expansion logic
│   │       └── Utils/               -- General utility helpers (including array insertion, unshift, etc.)
│   └── Ports/                       -- JavaScript interop ports (GIF generation, bounding boxes, hex number generation)
├── tests/
│   ├── IrisTests.elm                -- Regression tests for Iris' Gambit (eval/cc) and continuation semantics
│   └── FishermanTests.elm           -- Tests for Fisherman's Gambit and Fisherman's Gambit II (old and new behaviors)
├── HexMod/                          -- Upstream Hex Casting mod reference codebase (Java/Kotlin)
└── .github/workflows/               -- CI/CD build and test workflows (GitHub Actions)
```

---

## Code Flow: UI -> Parsing -> Evaluation -> Back

### 1. User Interface (UI) Layer
- **Entry (`Main.elm`)**: Initializes the Elm `Browser.element` application, wiring up subscriptions, init state, update loop, and view rendering.
- **Components (`Components/App/`)**:
  - `Grid.elm` / `PatternAutoComplete.elm`: Users draw hex pattern strokes or select patterns from panels.
  - `Timeline.elm` & `StackPanel.elm`: Display the evolution of the stack and execution timeline across pattern steps.
  - `Menu.elm` & `FilePanel.elm`: Trigger project load/save, import/export, and pattern execution updates.

### 2. Parsing & Project Representation
- **Pattern Registry (`Logic/App/Patterns/PatternRegistry.elm`)**: Maps pattern signatures (angle sequences like `"ddad"`, `"qwaqde"`, `"aqae"`) to pattern metadata, display names, and internal action functions.
- **Import/Export (`Logic/App/ImportExport/`)**:
  - `ImportParser.elm` & `ExportAsText.elm`: Parse text representations or project files into internal `Iota` and `Pattern` data structures.

### 3. Evaluation & VM Layer (`Logic/App/Stack/EvalStack.elm`)
- **`applyToStackStopAtErrorOrHalt`**: The primary entry point for executing a sequence of iotas/patterns against a casting context and stack.
- **`applyToStackLoop` & `applyPatternToStack`**: Iterates through the pattern stream, managing control flow, introspection (`open_paren` / `close_paren`), consideration (`escape`), and meta-evaluation (`eval`, `eval/cc`, `for_each`).
- **Continuation Semantics (`eval`, `eval/cc`)**:
  - `eval` (`Hermes' Gambit`): Evaluates an evaluatable (IotaList, PatternIota, or ContinuationIota). When executing a jump `ContinuationIota`, it performs an escape/jump out of the current context.
  - `eval_cc` (`Iris' Gambit`): Captures the remaining execution continuation as a `ContinuationIota`, pushes it, and executes the target expression.

### 4. Back to State & UI
- **Model Update (`Model.elm` / `Msg.elm`)**: The result of stack evaluation (final stack, success status, timeline of intermediate states) is stored in the application model.
- **View Render**: The UI components re-render to display the updated stack items, execution timeline, and visual feedback for any mishaps or successes.
