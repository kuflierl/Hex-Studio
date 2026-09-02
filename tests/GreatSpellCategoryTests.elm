module GreatSpellCategoryTests exposing (..)

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
    describe "Great Spells Category Test Suite"
        [ test "Lightning great spell signature lookup" <|\_ ->
            let
                p =
                    getPatternFromSignature Nothing "waadwawdaaweewq"
            in
            Expect.equal p.displayName "Summon Lightning"
        , test "Teleport great spell signature lookup" <|\_ ->
            let
                p =
                    getPatternFromSignature Nothing "wwwqqqwwwqqeqqwwwqqwqqdqqqqqdqq"
            in
            Expect.equal p.displayName "Greater Teleport"
        ]
