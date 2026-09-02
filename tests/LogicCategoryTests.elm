module LogicCategoryTests exposing (..)

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
    describe "Logic and Comparison Category Test Suite"
        [ test "Conjunction Distillation (and)" <|\_ ->
            let
                result =
                    applyToStackStopAtErrorOrHalt
                        (Array.fromList [ Boolean True, Boolean False ])
                        emptyContext
                        (Array.fromList [ pattern "wdw" ])
            in
            Expect.equal result.stack (Array.fromList [ Boolean False ])
        , test "Disjunction Distillation (or)" <|\_ ->
            let
                result =
                    applyToStackStopAtErrorOrHalt
                        (Array.fromList [ Boolean True, Boolean False ])
                        emptyContext
                        (Array.fromList [ pattern "waw" ])
            in
            Expect.equal result.stack (Array.fromList [ Boolean True ])
        , test "Negation Purification (not)" <|\_ ->
            let
                result =
                    applyToStackStopAtErrorOrHalt
                        (Array.fromList [ Boolean True ])
                        emptyContext
                        (Array.fromList [ pattern "dw" ])
            in
            Expect.equal result.stack (Array.fromList [ Boolean False ])
        , test "Equality Distillation (equals)" <|\_ ->
            let
                result =
                    applyToStackStopAtErrorOrHalt
                        (Array.fromList [ Number 42, Number 42 ])
                        emptyContext
                        (Array.fromList [ pattern "ad" ])
            in
            Expect.equal result.stack (Array.fromList [ Boolean True ])
        , test "Maximus Distillation (greater)" <|\_ ->
            let
                result =
                    applyToStackStopAtErrorOrHalt
                        (Array.fromList [ Number 5, Number 10 ])
                        emptyContext
                        (Array.fromList [ pattern "e" ])
            in
            Expect.equal result.stack (Array.fromList [ Boolean True ])
        ]
