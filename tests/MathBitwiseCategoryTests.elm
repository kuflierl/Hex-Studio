module MathBitwiseCategoryTests exposing (..)

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
    describe "Bitwise and Advanced Math Category Test Suite"
        [ test "Intersection Distillation (and_bit)" <|\_ ->
            let
                -- Stack: [3, 5, and_bit] -> 3 & 5 = 1 (5 on top, 3 below)
                result =
                    applyToStackStopAtErrorOrHalt
                        (Array.fromList [ Number 3, Number 5 ])
                        emptyContext
                        (Array.fromList [ pattern "wdweaqa" ])
            in
            Expect.equal result.stack (Array.fromList [ Number 1 ])
        , test "Unifying Distillation (or_bit)" <|\_ ->
            let
                -- Stack: [3, 5, or_bit] -> 3 | 5 = 7 (5 on top, 3 below)
                result =
                    applyToStackStopAtErrorOrHalt
                        (Array.fromList [ Number 3, Number 5 ])
                        emptyContext
                        (Array.fromList [ pattern "waweaqa" ])
            in
            Expect.equal result.stack (Array.fromList [ Number 7 ])
        , test "Exclusionary Distillation (xor_bit)" <|\_ ->
            let
                -- Stack: [3, 5, xor_bit] -> 3 ^ 5 = 6 (5 on top, 3 below)
                result =
                    applyToStackStopAtErrorOrHalt
                        (Array.fromList [ Number 3, Number 5 ])
                        emptyContext
                        (Array.fromList [ pattern "dwaeaqa" ])
            in
            Expect.equal result.stack (Array.fromList [ Number 6 ])
        ]
