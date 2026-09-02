module FishermanTests exposing (..)

import Array exposing (Array)
import Dict
import Expect exposing (Expectation)
import Test exposing (Test, describe, test)
import Logic.App.Patterns.OperatorUtils exposing (getPatternOrIotaList)
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

suite : Test
suite =
    describe "Fisherman's Gambit / Fisherman's Gambit II behavior"
        [ test "Fisherman old behavior (positive index pulls up)" <|\_ ->
            let
                pattern sig =
                    PatternIota (getPatternFromSignature Nothing sig) False

                -- Stack: [0, 10, 20, 30] -> index 0 (top) is 0, pulls item at index 0 of newStack (10) to top
                result =
                    applyToStackStopAtErrorOrHalt
                        (Array.fromList [ Number 0, Number 10, Number 20, Number 30 ])
                        emptyContext
                        (Array.fromList [ pattern "ddad" ])
            in
            Expect.equal result.stack (Array.fromList [ Number 10, Number 20, Number 30 ])
        , test "Fisherman Copy old behavior (positive index copies up)" <|\_ ->
            let
                pattern sig =
                    PatternIota (getPatternFromSignature Nothing sig) False

                -- Stack: [0, 10, 20, 30] -> index 0 (top) is 0, copies item at index 0 of newStack (10) to top
                result =
                    applyToStackStopAtErrorOrHalt
                        (Array.fromList [ Number 0, Number 10, Number 20, Number 30 ])
                        emptyContext
                        (Array.fromList [ pattern "aada" ])
            in
            Expect.equal result.stack (Array.fromList [ Number 10, Number 10, Number 20, Number 30 ])
        , test "Fisherman new behavior (negative index moves top iota down)" <|\_ ->
            let
                pattern sig =
                    PatternIota (getPatternFromSignature Nothing sig) False

                -- Stack: [-1, 10, 20, 30] -> negative index moves top iota (10) down 1 step
                result =
                    applyToStackStopAtErrorOrHalt
                        (Array.fromList [ Number -1, Number 10, Number 20, Number 30 ])
                        emptyContext
                        (Array.fromList [ pattern "ddad" ])
            in
            Expect.equal result.stack (Array.fromList [ Number 20, Number 10, Number 30 ])
        , test "Fisherman Copy new behavior (negative index copies top iota down)" <|\_ ->
            let
                pattern sig =
                    PatternIota (getPatternFromSignature Nothing sig) False

                -- Stack: [-1, 10, 20, 30] -> negative index copies top iota (10) down 1 step
                result =
                    applyToStackStopAtErrorOrHalt
                        (Array.fromList [ Number -1, Number 10, Number 20, Number 30 ])
                        emptyContext
                        (Array.fromList [ pattern "aada" ])
            in
            Expect.equal result.stack (Array.fromList [ Number 10, Number 10, Number 20, Number 30 ])
        ]
