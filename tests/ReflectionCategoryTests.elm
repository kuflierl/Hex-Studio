module ReflectionCategoryTests exposing (..)

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
    describe "Reflection and Constants Category Test Suite"
        [ test "True Reflection (const/true)" <|\_ ->
            let
                result =
                    applyToStackStopAtErrorOrHalt
                        Array.empty
                        emptyContext
                        (Array.fromList [ pattern "aqae" ])
            in
            Expect.equal result.stack (Array.fromList [ Boolean True ])
        , test "False Reflection (const/false)" <|\_ ->
            let
                result =
                    applyToStackStopAtErrorOrHalt
                        Array.empty
                        emptyContext
                        (Array.fromList [ pattern "dedq" ])
            in
            Expect.equal result.stack (Array.fromList [ Boolean False ])
        , test "Nullary Reflection (const/null)" <|\_ ->
            let
                result =
                    applyToStackStopAtErrorOrHalt
                        Array.empty
                        emptyContext
                        (Array.fromList [ pattern "d" ])
            in
            Expect.equal result.stack (Array.fromList [ Null ])
        , test "Vector Reflection Zero (const/vec/0)" <|\_ ->
            let
                result =
                    applyToStackStopAtErrorOrHalt
                        Array.empty
                        emptyContext
                        (Array.fromList [ pattern "qqqqq" ])
            in
            Expect.equal result.stack (Array.fromList [ Vector ( 0, 0, 0 ) ])
        ]
