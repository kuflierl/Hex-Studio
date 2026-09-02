module ReadWriteCategoryTests exposing (..)

import Array exposing (Array)
import Dict
import Expect exposing (Expectation)
import Test exposing (Test, describe, test)
import Logic.App.Patterns.PatternRegistry exposing (getPatternFromSignature)
import Logic.App.Stack.EvalStack exposing (applyToStackStopAtErrorOrHalt)
import Logic.App.Types exposing (CastingContext, Iota(..))

emptyContext : CastingContext
emptyContext =
    { ravenmind = Nothing
    , libraries = Dict.empty
    , entities = Dict.empty
    , macros = Dict.empty
    }

pattern : String -> Iota
pattern sig =
    PatternIota (getPatternFromSignature Nothing sig) False

suite : Test
suite =
    describe "Read/Write & Libraries Category Test Suite"
        [ test "Scribe's Reflection signature lookup" <|\_ ->
            let
                p =
                    getPatternFromSignature Nothing "aqqqqq"
            in
            Expect.equal p.displayName "Scribe's Reflection"
        , test "Scribe's Gambit signature lookup" <|\_ ->
            let
                p =
                    getPatternFromSignature Nothing "deeeee"
            in
            Expect.equal p.displayName "Scribe's Gambit"
        ]
