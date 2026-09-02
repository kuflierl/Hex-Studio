module MathCategoryTests exposing (..)

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
    describe "Arithmetic and Math Category Test Suite"
        [ test "Additive Distillation (add)" <|\_ ->
            let
                result =
                    applyToStackStopAtErrorOrHalt
                        (Array.fromList [ Number 10, Number 5 ])
                        emptyContext
                        (Array.fromList [ pattern "waaw" ])
            in
            Expect.equal result.stack (Array.fromList [ Number 15 ])
        , test "Subtractive Distillation (sub)" <|\_ ->
            let
                result =
                    applyToStackStopAtErrorOrHalt
                        (Array.fromList [ Number 3, Number 10 ])
                        emptyContext
                        (Array.fromList [ pattern "wddw" ])
            in
            Expect.equal result.stack (Array.fromList [ Number 7 ])
        , test "Length Purification (abs)" <|\_ ->
            let
                result =
                    applyToStackStopAtErrorOrHalt
                        (Array.fromList [ Number -12 ])
                        emptyContext
                        (Array.fromList [ pattern "wqaqw" ])
            in
            Expect.equal result.stack (Array.fromList [ Number 12 ])
        , test "Floor Purification (floor)" <|\_ ->
            let
                result =
                    applyToStackStopAtErrorOrHalt
                        (Array.fromList [ Number 3.7 ])
                        emptyContext
                        (Array.fromList [ pattern "ewq" ])
            in
            Expect.equal result.stack (Array.fromList [ Number 3 ])
        , test "Ceiling Purification (ceil)" <|\_ ->
            let
                result =
                    applyToStackStopAtErrorOrHalt
                        (Array.fromList [ Number 3.2 ])
                        emptyContext
                        (Array.fromList [ pattern "qwe" ])
            in
            Expect.equal result.stack (Array.fromList [ Number 4 ])
        ]
