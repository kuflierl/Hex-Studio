module ListCategoryTests exposing (..)

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
    describe "List Category & Fisherman Tests"
        [ test "Uniqueness Purification (unique)" <|\_ ->
            let
                listIota =
                    IotaList (Array.fromList [ Number 1, Number 2, Number 2, Number 3, Number 1 ])

                result =
                    applyToStackStopAtErrorOrHalt
                        (Array.fromList [ listIota ])
                        emptyContext
                        (Array.fromList [ pattern "aweaqa" ])
            in
            Expect.equal result.stack (Array.fromList [ IotaList (Array.fromList [ Number 1, Number 2, Number 3 ]) ])
        , test "Fisherman old behavior (positive index pulls up)" <|\_ ->
            let
                result =
                    applyToStackStopAtErrorOrHalt
                        (Array.fromList [ Number 0, Number 10, Number 20, Number 30 ])
                        emptyContext
                        (Array.fromList [ pattern "ddad" ])
            in
            Expect.equal result.stack (Array.fromList [ Number 10, Number 20, Number 30 ])
        , test "Fisherman Copy old behavior (positive index copies up)" <|\_ ->
            let
                result =
                    applyToStackStopAtErrorOrHalt
                        (Array.fromList [ Number 0, Number 10, Number 20, Number 30 ])
                        emptyContext
                        (Array.fromList [ pattern "aada" ])
            in
            Expect.equal result.stack (Array.fromList [ Number 10, Number 10, Number 20, Number 30 ])
        , test "Fisherman new behavior (negative index moves top iota down)" <|\_ ->
            let
                result =
                    applyToStackStopAtErrorOrHalt
                        (Array.fromList [ Number -1, Number 10, Number 20, Number 30 ])
                        emptyContext
                        (Array.fromList [ pattern "ddad" ])
            in
            Expect.equal result.stack (Array.fromList [ Number 20, Number 10, Number 30 ])
        , test "Fisherman Copy new behavior (negative index copies top iota down)" <|\_ ->
            let
                result =
                    applyToStackStopAtErrorOrHalt
                        (Array.fromList [ Number -1, Number 10, Number 20, Number 30 ])
                        emptyContext
                        (Array.fromList [ pattern "aada" ])
            in
            Expect.equal result.stack (Array.fromList [ Number 10, Number 20, Number 10, Number 30 ])
        ]
