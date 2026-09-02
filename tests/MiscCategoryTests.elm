module MiscCategoryTests exposing (..)

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
    describe "Misc Actions Category Test Suite"
        [ test "Exclusion Distillation signature lookup" <|\_ ->
            let
                p =
                    getPatternFromSignature Nothing "dwa"
            in
            Expect.equal p.displayName "Exclusion Distillation"
        , test "Novice's Gambit signature lookup" <|\_ ->
            let
                p =
                    getPatternFromSignature Nothing "a"
            in
            Expect.equal p.displayName "Novice's Gambit"
        ]
