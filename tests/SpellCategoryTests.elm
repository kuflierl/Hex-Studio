module SpellCategoryTests exposing (..)

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
    describe "Spell & World Interaction Category Test Suite"
        [ test "Reveal (print) leaves iota on stack" <|\_ ->
            let
                result =
                    applyToStackStopAtErrorOrHalt
                        (Array.fromList [ Number 42 ])
                        emptyContext
                        (Array.fromList [ pattern "de" ])
            in
            Expect.equal result.stack (Array.fromList [ Number 42 ])
        , test "Create Water spell" <|\_ ->
            let
                result =
                    applyToStackStopAtErrorOrHalt
                        (Array.fromList [ Vector ( 0, 0, 0 ) ])
                        emptyContext
                        (Array.fromList [ pattern "aqawqadaq" ])
            in
            Expect.equal result.error False
        , test "Destroy Liquid spell" <|\_ ->
            let
                result =
                    applyToStackStopAtErrorOrHalt
                        (Array.fromList [ Vector ( 0, 0, 0 ) ])
                        emptyContext
                        (Array.fromList [ pattern "dedwedade" ])
            in
            Expect.equal result.error False
        , test "Make Note (beep)" <|\_ ->
            let
                result =
                    applyToStackStopAtErrorOrHalt
                        (Array.fromList [ Number 60.0, Number 1.0, Vector ( 0, 0, 0 ) ])
                        emptyContext
                        (Array.fromList [ pattern "adaa" ])
            in
            Expect.equal result.error False
        ]
