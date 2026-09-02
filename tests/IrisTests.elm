module IrisTests exposing (..)

import Array exposing (Array)
import Dict
import Expect exposing (Expectation)
import Test exposing (Test, describe, test)
import Logic.App.Patterns.OperatorUtils exposing (getPatternOrIotaList)
import Logic.App.Patterns.PatternRegistry exposing (getPatternFromSignature)
import Logic.App.Stack.EvalStack exposing (applyToStackStopAtErrorOrHalt, eval, evalCC)
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
    describe "Iris / eval-cc continuation semantics"
        [ test "Continuation iotas are accepted as evaluatable" <|\_ ->
            let
                continuation =
                    ContinuationIota
                        { stack = Array.fromList [ Number 1, Number 2 ]
                        , ctx = emptyContext
                        }
            in
            Expect.equal
                (getPatternOrIotaList continuation)
                (Just continuation)
        , test "Executing a continuation runs the saved remaining commands" <|\_ ->
            let
                emptyListPattern =
                    PatternIota (getPatternFromSignature Nothing "qqaeaae") False

                savedCommands = Array.fromList [ emptyListPattern ]
                result =
                    eval
                        (Array.fromList [ ContinuationIota { stack = savedCommands, ctx = emptyContext } ])
                        emptyContext
            in
            Expect.equal result.stack (Array.fromList [ IotaList Array.empty ])
        , test "Executing an empty continuation is a no-op jump to the end of the current execution" <|\_ ->
            let
                result =
                    eval
                        (Array.fromList [ ContinuationIota { stack = Array.empty, ctx = emptyContext }, Number 7, Number 9 ])
                        emptyContext
            in
            Expect.equal result.stack (Array.fromList [ Number 7, Number 9 ])
        , test "Nested eval/cc goto with Vacant Reflection leaves two true values" <|\_ ->
            let
                pattern sig =
                    PatternIota (getPatternFromSignature Nothing sig) False

                result =
                    applyToStackStopAtErrorOrHalt
                        Array.empty
                        emptyContext
                        (Array.fromList
                            [ pattern "qqq" -- Introspection
                            , pattern "qqaeaae" -- Vacant Reflection
                            , pattern "qwaqde" -- Iris' Gambit
                            , pattern "aqae" -- True Reflection
                            , pattern "eee" -- Retrospection
                            , pattern "deaqq" -- Hermes Gambit
                            , pattern "aawdd" -- Jester's Gambit
                            , pattern "deaqq" -- Hermes Gambit
                            ]
                        )
            in
            Expect.equal result.stack (Array.fromList [ Boolean True, Boolean True ])
        , test "eval/cc with internal jump returns one true value" <|\_ ->
            let
                pattern sig =
                    PatternIota (getPatternFromSignature Nothing sig) False

                result =
                    applyToStackStopAtErrorOrHalt
                        Array.empty
                        emptyContext
                        (Array.fromList
                            [ pattern "qqq" -- Introspection
                            , pattern "aqae" -- True Reflection
                            , pattern "aawdd" -- Jester's Gambit
                            , pattern "deaqq" -- Hermes Gambit
                            , pattern "aqae" -- True Reflection
                            , pattern "eee" -- Retrospection
                            , pattern "qwaqde" -- Iris' Gambit
                            ]
                        )
            in
            Expect.equal result.stack (Array.fromList [ Boolean True ])
        , test "User iris nested example leaves exactly two true values on stack from empty stack" <|\_ ->
            let
                pattern sig =
                    PatternIota (getPatternFromSignature Nothing sig) False

                result =
                    applyToStackStopAtErrorOrHalt
                        Array.empty
                        emptyContext
                        (Array.fromList
                            [ pattern "qqq" -- Introspection
                            , pattern "qqq" -- Introspection
                            , pattern "aadaa" -- Gemini Decomposition
                            , pattern "deaqq" -- Hermes Gambit
                            , pattern "dedq" -- False Reflection
                            , pattern "eee" -- Retrospection
                            , pattern "qwaqde" -- Iris' Gambit
                            , pattern "aqae" -- True Reflection
                            , pattern "eee" -- Retrospection
                            , pattern "deaqq" -- Hermes Gambit
                            , pattern "aawdd" -- Jester's Gambit
                            , pattern "deaqq" -- Hermes Gambit
                            ]
                        )
            in
            Expect.equal result.stack (Array.fromList [ Boolean True, Boolean True ])
        ]
