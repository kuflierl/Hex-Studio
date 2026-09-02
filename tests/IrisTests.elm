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
        , test "Nested eval/cc goto executes remaining outer commands and leaves two true values" <|\_ ->
            let
                pattern sig =
                    PatternIota (getPatternFromSignature Nothing sig) False

                result =
                    applyToStackStopAtErrorOrHalt
                        Array.empty
                        emptyContext
                        (Array.fromList
                            [ pattern "qqaeaae"
                            , pattern "qwaqde"
                            , pattern "aqae"
                            , pattern "deaqq"
                            , pattern "aawdd"
                            , pattern "deaqq"
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
                            [ pattern "qqq"
                            , pattern "aqae"
                            , pattern "aawdd"
                            , pattern "deaqq"
                            , pattern "aqae"
                            , pattern "eee"
                            , pattern "qwaqde"
                            ]
                        )
            in
            Expect.equal result.stack (Array.fromList [ Boolean True ])
        ]
