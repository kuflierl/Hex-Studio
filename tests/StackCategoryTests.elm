module StackCategoryTests exposing (..)

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
    describe "Stack Manipulation Category Test Suite"
        [ test "Swap (Jester's Gambit)" <|\_ ->
            let
                result =
                    applyToStackStopAtErrorOrHalt
                        (Array.fromList [ Number 2, Number 1 ])
                        emptyContext
                        (Array.fromList [ pattern "aawdd" ])
            in
            Expect.equal result.stack (Array.fromList [ Number 1, Number 2 ])
        , test "Duplicate (Gemini Decomposition)" <|\_ ->
            let
                result =
                    applyToStackStopAtErrorOrHalt
                        (Array.fromList [ Number 7 ])
                        emptyContext
                        (Array.fromList [ pattern "aadaa" ])
            in
            Expect.equal result.stack (Array.fromList [ Number 7, Number 7 ])
        , test "Stack Length (Flock's Reflection)" <|\_ ->
            let
                result =
                    applyToStackStopAtErrorOrHalt
                        (Array.fromList [ Number 3, Number 2, Number 1 ])
                        emptyContext
                        (Array.fromList [ pattern "qwaeawqaeaqa" ])
            in
            Expect.equal result.stack (Array.fromList [ Number 3, Number 3, Number 2, Number 1 ])
        , test "Fisherman's Gambit (pull up positive)" <|\_ ->
            let
                result =
                    applyToStackStopAtErrorOrHalt
                        (Array.fromList [ Number 0, Number 10, Number 20, Number 30 ])
                        emptyContext
                        (Array.fromList [ pattern "ddad" ])
            in
            Expect.equal result.stack (Array.fromList [ Number 10, Number 20, Number 30 ])
        , test "Novice's Gambit (mask v)" <|\_ ->
            let
                result =
                    applyToStackStopAtErrorOrHalt
                        (Array.fromList [ Number 10, Number 20 ])
                        emptyContext
                        (Array.fromList [ pattern "a" ])
            in
            Expect.equal result.stack (Array.fromList [ Number 20 ])
        ]
