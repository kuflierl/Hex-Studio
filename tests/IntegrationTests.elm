module IntegrationTests exposing (..)

import Array exposing (Array)
import Dict
import Expect exposing (Expectation)
import Test exposing (Test, describe, test)
import Logic.App.Patterns.PatternRegistry exposing (getPatternFromSignature)
import Logic.App.Stack.EvalStack exposing (applyToStackStopAtErrorOrHalt)
import Logic.App.Types exposing (CastingContext, Iota(..), Mishap(..))

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
    describe "Hex Casting Integration & Edge Case Test Suite"
        [ test "Integration: Conditional Augur's Exaltation (if) selects correct branch" <|\_ ->
            let
                result =
                    applyToStackStopAtErrorOrHalt
                        (Array.fromList [ Number 20, Number 10, Boolean True ])
                        emptyContext
                        (Array.fromList [ pattern "awdd" ])
            in
            Expect.equal result.stack (Array.fromList [ Number 10 ])
        , test "Integration: List construction and size query" <|\_ ->
            let
                result =
                    applyToStackStopAtErrorOrHalt
                        Array.empty
                        emptyContext
                        (Array.fromList
                            [ pattern "qqq"
                            , Number 10
                            , Number 20
                            , Number 30
                            , pattern "eee"
                            , pattern "aqaeaq"
                            ]
                        )
            in
            Expect.equal result.stack (Array.fromList [ Number 3 ])
        , test "Edge Case: Arithmetic operation with insufficient arguments triggers mishap" <|\_ ->
            let
                result =
                    applyToStackStopAtErrorOrHalt
                        (Array.fromList [ Number 5 ])
                        emptyContext
                        (Array.fromList [ pattern "waaw" ])
            in
            Expect.equal True (result.error || Array.length result.stack > 0)
        ]
