module ComprehensiveTests exposing (..)

import Array exposing (Array)
import Dict
import Expect exposing (Expectation)
import Test exposing (Test, describe, test)
import Logic.App.Patterns.PatternRegistry exposing (getPatternFromName, getPatternFromSignature)
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
    describe "Comprehensive Hex Casting Operations Test Suite"
        [ describe "Arithmetic and Math Operations"
            [ test "Additive Distillation (add) adds two numbers" <|\_ ->
                let
                    -- Stack: [5, 10, add] -> 5 + 10 = 15 (10 on top, 5 below)
                    result =
                        applyToStackStopAtErrorOrHalt
                            (Array.fromList [ Number 10, Number 5 ])
                            emptyContext
                            (Array.fromList [ pattern "waaw" ])
                in
                Expect.equal result.stack (Array.fromList [ Number 15 ])
            , test "Subtractive Distillation (sub) subtracts two numbers" <|\_ ->
                let
                    -- Stack: [3, 10, sub] -> 10 - 3 = 7 (10 on top, 3 below)
                    result =
                        applyToStackStopAtErrorOrHalt
                            (Array.fromList [ Number 3, Number 10 ])
                            emptyContext
                            (Array.fromList [ pattern "wddw" ])
                in
                Expect.equal result.stack (Array.fromList [ Number 7 ])
            , test "Length Purification (abs) computes absolute value" <|\_ ->
                let
                    -- Stack: [-5, abs] -> |-5| = 5
                    result =
                        applyToStackStopAtErrorOrHalt
                            (Array.fromList [ Number -5 ])
                            emptyContext
                            (Array.fromList [ pattern "wqaqw" ])
                in
                Expect.equal result.stack (Array.fromList [ Number 5 ])
            ]
        , describe "Logic and Comparison Operations"
            [ test "Equality Distillation (equals) compares two equal numbers" <|\_ ->
                let
                    -- Stack: [5, 5, equals] -> True
                    result =
                        applyToStackStopAtErrorOrHalt
                            (Array.fromList [ Number 5, Number 5 ])
                            emptyContext
                            (Array.fromList [ pattern "ad" ])
                in
                Expect.equal result.stack (Array.fromList [ Boolean True ])
            , test "Maximus Distillation (greater) compares numbers" <|\_ ->
                let
                    -- Stack: [5, 10, greater] -> 10 > 5 -> True (10 on top, 5 below)
                    result =
                        applyToStackStopAtErrorOrHalt
                            (Array.fromList [ Number 5, Number 10 ])
                            emptyContext
                            (Array.fromList [ pattern "e" ])
                in
                Expect.equal result.stack (Array.fromList [ Boolean True ])
            , test "Negation Purification (not) inverts boolean" <|\_ ->
                let
                    -- Stack: [True, not] -> False
                    result =
                        applyToStackStopAtErrorOrHalt
                            (Array.fromList [ Boolean True ])
                            emptyContext
                            (Array.fromList [ pattern "dw" ])
                in
                Expect.equal result.stack (Array.fromList [ Boolean False ])
            , test "Similarity Distillation (type_equals) compares types of two numbers" <|\_ ->
                let
                    result =
                        applyToStackStopAtErrorOrHalt
                            (Array.fromList [ Number 10, Number 5 ])
                            emptyContext
                            (Array.fromList [ pattern "wawdw" ])
                in
                Expect.equal result.stack (Array.fromList [ Boolean True ])
            , test "Similarity Distillation (type_equals) compares number and bool" <|\_ ->
                let
                    result =
                        applyToStackStopAtErrorOrHalt
                            (Array.fromList [ Boolean True, Number 5 ])
                            emptyContext
                            (Array.fromList [ pattern "wawdw" ])
                in
                Expect.equal result.stack (Array.fromList [ Boolean False ])
            , test "Similarity Distillation II (type_not_equals) compares number and bool" <|\_ ->
                let
                    result =
                        applyToStackStopAtErrorOrHalt
                            (Array.fromList [ Boolean True, Number 5 ])
                            emptyContext
                            (Array.fromList [ pattern "wdwaw" ])
                in
                Expect.equal result.stack (Array.fromList [ Boolean True ])
            ]
        , describe "Stack Manipulation Operations"
            [ test "Jester's Gambit (swap) swaps top two iotas" <|\_ ->
                let
                    -- Stack: [2, 1, swap] -> [1, 2] (1 on top, 2 below)
                    result =
                        applyToStackStopAtErrorOrHalt
                            (Array.fromList [ Number 2, Number 1 ])
                            emptyContext
                            (Array.fromList [ pattern "aawdd" ])
                in
                Expect.equal result.stack (Array.fromList [ Number 1, Number 2 ])
            , test "Gemini Decomposition (dup) duplicates top iota" <|\_ ->
                let
                    -- Stack: [7, dup] -> [7, 7]
                    result =
                        applyToStackStopAtErrorOrHalt
                            (Array.fromList [ Number 7 ])
                            emptyContext
                            (Array.fromList [ pattern "aadaa" ])
                in
                Expect.equal result.stack (Array.fromList [ Number 7, Number 7 ])
            , test "Flock's Reflection (stack_len) pushes stack size" <|\_ ->
                let
                    -- Stack: [3, 2, 1, stack_len]
                    result =
                        applyToStackStopAtErrorOrHalt
                            (Array.fromList [ Number 3, Number 2, Number 1 ])
                            emptyContext
                            (Array.fromList [ pattern "qwaeawqaeaqa" ])
                in
                Expect.equal result.stack (Array.fromList [ Number 3, Number 3, Number 2, Number 1 ])
            ]
        , describe "Reflection and Constants"
            [ test "True Reflection (const/true) pushes boolean true" <|\_ ->
                let
                    result =
                        applyToStackStopAtErrorOrHalt
                            Array.empty
                            emptyContext
                            (Array.fromList [ pattern "aqae" ])
                in
                Expect.equal result.stack (Array.fromList [ Boolean True ])
            , test "Nullary Reflection (const/null) pushes null" <|\_ ->
                let
                    result =
                        applyToStackStopAtErrorOrHalt
                            Array.empty
                            emptyContext
                            (Array.fromList [ pattern "d" ])
                in
                Expect.equal result.stack (Array.fromList [ Null ])
            ]
        , describe "List & Set Operations"
            [ test "Uniqueness Purification (unique) removes duplicates from list" <|\_ ->
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
            ]
        , describe "Bookkeeper's & Novice's Gambit"
            [ test "Novice's Gambit search returns bookkeeper pattern" <|\_ ->
                let
                    ( pat, _ ) =
                        getPatternFromName Nothing "Novice's Gambit"
                in
                Expect.equal pat.displayName "Novice's Gambit"
            , test "Bookkeeper's Gambit search returns bookkeeper pattern" <|\_ ->
                let
                    ( pat, _ ) =
                        getPatternFromName Nothing "Bookkeeper's Gambit: --"
                in
                Expect.equal pat.internalName "mask"
            ]
        ]
