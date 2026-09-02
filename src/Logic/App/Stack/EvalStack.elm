module Logic.App.Stack.EvalStack exposing (..)

import Array exposing (Array)
import Array.Extra as Array
import Dict
import List.Extra as List
import Logic.App.Patterns.OperatorUtils exposing (getIotaList, getPatternList, getPatternOrIotaList, mapNothingToMissingIota, moveNothingsToFront)
import Logic.App.Types exposing (ActionResult, ApplyToStackResult(..), CastingContext, Iota(..), IotaType(..), Mishap(..), Pattern, Timeline)
import Logic.App.Utils.Utils exposing (isJust, unshift)


type alias ApplyResult =
    { stack : Array Iota
    , resultArray : Array ApplyToStackResult
    , ctx : CastingContext
    , error : Bool
    , halted : Bool
    , timeline : Timeline
    }


applyToStackStopAtErrorOrHalt : Array Iota -> CastingContext -> Array Iota -> ApplyResult
applyToStackStopAtErrorOrHalt stack ctx iotas =
    applyToStackLoop ( stack, Array.empty ) ctx (Array.toList iotas) 0 Array.empty False True


applyPatternsToStack : Array Iota -> CastingContext -> List Pattern -> ApplyResult
applyPatternsToStack stack ctx patterns =
    let
        patternIotas =
            List.map (\pattern -> PatternIota pattern False) patterns

    in
    applyToStackLoop ( stack, Array.empty ) ctx patternIotas 0 Array.empty False False


applyToStackLoop : ( Array Iota, Array ApplyToStackResult ) -> CastingContext -> List Iota -> Int -> Timeline -> Bool -> Bool -> ApplyResult
applyToStackLoop stackResultTuple ctx patterns currentIndex timeline considerThis stopAtErrorOrHalt =
    let
        stack =
            Tuple.first stackResultTuple

        resultArray =
            Tuple.second stackResultTuple

        introspection =
            case Array.get 0 stack of
                Just (OpenParenthesis _) ->
                    True

                _ ->
                    False

        maybeIota =
            case List.head patterns of
                Just (PatternIota pattern considered) ->
                    if pattern.internalName == "constant" then
                        Array.get 0 (pattern.action Array.empty ctx).stack

                    else
                        Just (PatternIota pattern considered)

                head ->
                    head
    in
    case maybeIota of
        Nothing ->
            { stack = stack, resultArray = resultArray, ctx = ctx, error = False, halted = False, timeline = timeline }

        Just (PatternIota pattern _) ->
            if considerThis then
                let
                    applyResult =
                        ( addEscapedIotaToStack stack (PatternIota pattern True), unshift Considered resultArray )
                in
                applyToStackLoop
                    applyResult
                    ctx
                    (Maybe.withDefault [] <| List.tail patterns)
                    (currentIndex + 1)
                    (unshift { stack = Tuple.first applyResult, patternIndex = currentIndex } timeline)
                    False
                    stopAtErrorOrHalt

            else if pattern.internalName == "halt" && stopAtErrorOrHalt then
                { stack = stack, resultArray = resultArray, ctx = ctx, error = False, halted = True, timeline = timeline }

            else
                let
                    restPatterns =
                        Maybe.withDefault [] <| List.tail patterns

                    applyResult =
                        applyPatternToStack stack ctx pattern currentIndex restPatterns
                in
                if applyResult.halted then
                    { stack = applyResult.stack
                    , resultArray = unshift applyResult.result resultArray
                    , ctx = applyResult.ctx
                    , error = False
                    , halted = True
                    , timeline = Array.append applyResult.timeline timeline
                    }

                else if not stopAtErrorOrHalt || (stopAtErrorOrHalt && applyResult.result /= Failed) then
                    applyToStackLoop
                        ( applyResult.stack, unshift applyResult.result resultArray )
                        applyResult.ctx
                        restPatterns
                        (currentIndex + 1)
                        (Array.append applyResult.timeline timeline)
                        applyResult.considerNext
                        stopAtErrorOrHalt

                else
                    { stack = applyResult.stack
                    , resultArray = unshift applyResult.result resultArray
                    , ctx = applyResult.ctx
                    , error = True
                    , halted = False
                    , timeline = unshift { stack = applyResult.stack, patternIndex = currentIndex } timeline
                    }

        Just (ContinuationIota continuationState) ->
            if considerThis || introspection then
                let
                    applyResult =
                        ( addEscapedIotaToStack stack (ContinuationIota continuationState), unshift Considered resultArray )
                in
                applyToStackLoop
                    applyResult
                    ctx
                    (Maybe.withDefault [] <| List.tail patterns)
                    (currentIndex + 1)
                    (unshift { stack = Tuple.first applyResult, patternIndex = currentIndex } timeline)
                    False
                    stopAtErrorOrHalt

            else
                let
                    executed =
                        if Array.isEmpty continuationState.stack then
                            { stack = stack, ctx = continuationState.ctx, error = False, timeline = timeline }

                        else
                            let
                                res =
                                    applyToStackStopAtErrorOrHalt stack continuationState.ctx continuationState.stack
                            in
                            { stack = res.stack, ctx = res.ctx, error = res.error, timeline = Array.append res.timeline timeline }
                in
                { stack = executed.stack
                , resultArray = unshift Succeeded resultArray
                , ctx = executed.ctx
                , error = executed.error
                , halted = True
                , timeline = executed.timeline
                }

        Just iota ->
            if considerThis || introspection then
                let
                    applyResult =
                        ( addEscapedIotaToStack stack iota, unshift Considered resultArray )
                in
                applyToStackLoop
                    applyResult
                    ctx
                    (Maybe.withDefault [] <| List.tail patterns)
                    (currentIndex + 1)
                    (unshift { stack = Tuple.first applyResult, patternIndex = currentIndex } timeline)
                    False
                    stopAtErrorOrHalt

            else
                { stack = stack, resultArray = resultArray, ctx = ctx, error = True, halted = False, timeline = timeline }


applyPatternToStack : Array Iota -> CastingContext -> Pattern -> Int -> List Iota -> { stack : Array Iota, result : ApplyToStackResult, ctx : CastingContext, considerNext : Bool, halted : Bool, timeline : Timeline }
applyPatternToStack stack ctx pattern index restPatterns =
    case Array.get 0 stack of
        -- if intro on top of stack
        Just (OpenParenthesis list) ->
            let
                numberOfCloseParen =
                    Array.length
                        (Array.filter
                            (\iota ->
                                case iota of
                                    PatternIota pat False ->
                                        pat.internalName == "close_paren"

                                    _ ->
                                        False
                            )
                            list
                        )

                numberOfOpenParen =
                    (+) 1 <|
                        Array.length
                            (Array.filter
                                (\iota ->
                                    case iota of
                                        PatternIota pat False ->
                                            pat.internalName == "open_paren"

                                        _ ->
                                            False
                                )
                                list
                            )

                addToIntroList =
                    Array.set 0 (OpenParenthesis (Array.push (PatternIota pattern False) list)) stack
            in
            if pattern.internalName == "escape" then
                { stack = stack, result = Succeeded, ctx = ctx, considerNext = True, halted = False, timeline = Array.fromList [ { stack = stack, patternIndex = index } ] }

            else if pattern.internalName == "close_paren" then
                if pattern.internalName == "close_paren" && (numberOfCloseParen + 1) >= numberOfOpenParen then
                    let
                        newStack =
                            Array.map
                                (\iota ->
                                    case iota of
                                        OpenParenthesis l ->
                                            IotaList l

                                        otherIota ->
                                            otherIota
                                )
                                stack
                    in
                    { stack = newStack
                    , result = Succeeded
                    , ctx = ctx
                    , considerNext = False
                    , halted = False
                    , timeline = Array.fromList [ { stack = newStack, patternIndex = index } ]
                    }

                else
                    { stack = addToIntroList, result = Considered, ctx = ctx, considerNext = False, halted = False, timeline = Array.fromList [ { stack = addToIntroList, patternIndex = index } ] }

            else
                { stack = addToIntroList, result = Considered, ctx = ctx, considerNext = False, halted = False, timeline = Array.fromList [ { stack = addToIntroList, patternIndex = index } ] }

        _ ->
            -- if no intro on top
            if pattern.internalName == "escape" then
                { stack = stack, result = Succeeded, ctx = ctx, considerNext = True, halted = False, timeline = Array.fromList [ { stack = stack, patternIndex = index } ] }

            else if pattern.internalName == "close_paren" then
                { stack = unshift (PatternIota pattern False) stack, result = Failed, ctx = ctx, considerNext = False, halted = False, timeline = Array.fromList [ { stack = stack, patternIndex = index } ] }

            else if pattern.internalName == "eval" then
                --special cases for eval and for_each because they need to return multiple stack states for the timeline
                let
                    actionResult =
                        eval stack ctx
                in
                if actionResult.success == True then
                    { stack = actionResult.stack
                    , result = Succeeded
                    , ctx = actionResult.ctx
                    , considerNext = False
                    , halted = actionResult.halted
                    , timeline = Array.map (\x -> { stack = x, patternIndex = index }) actionResult.allStackStates
                    }

                else
                    { stack = actionResult.stack
                    , result = Failed
                    , ctx = actionResult.ctx
                    , considerNext = False
                    , halted = actionResult.halted
                    , timeline = Array.map (\x -> { stack = x, patternIndex = index }) actionResult.allStackStates
                    }

            else if pattern.internalName == "eval_cc" then
                let
                    actionResult =
                        evalCC stack ctx restPatterns
                in
                if actionResult.success == True then
                    { stack = actionResult.stack
                    , result = Succeeded
                    , ctx = actionResult.ctx
                    , considerNext = False
                    , halted = False
                    , timeline = Array.map (\x -> { stack = x, patternIndex = index }) actionResult.allStackStates
                    }

                else
                    { stack = actionResult.stack
                    , result = Failed
                    , ctx = actionResult.ctx
                    , considerNext = False
                    , halted = False
                    , timeline = Array.map (\x -> { stack = x, patternIndex = index }) actionResult.allStackStates
                    }

            else if pattern.internalName == "for_each" then
                let
                    actionResult =
                        forEach stack ctx
                in
                if actionResult.success == True then
                    { stack = actionResult.stack
                    , result = Succeeded
                    , ctx = actionResult.ctx
                    , considerNext = False
                    , halted = False
                    , timeline = Array.map (\x -> { stack = x, patternIndex = index }) actionResult.allStackStates
                    }

                else
                    { stack = actionResult.stack
                    , result = Failed
                    , ctx = actionResult.ctx
                    , considerNext = False
                    , halted = False
                    , timeline = Array.map (\x -> { stack = x, patternIndex = index }) actionResult.allStackStates
                    }

            else
                case Dict.get pattern.signature ctx.macros of
                    Just ( _, _, iota ) ->
                        let
                            actionResult =
                                eval (unshift iota stack) ctx
                        in
                        if actionResult.success == True then
                            { stack = actionResult.stack
                            , result = Succeeded
                            , ctx = actionResult.ctx
                            , considerNext = False
                            , halted = actionResult.halted
                            , timeline = Array.map (\x -> { stack = x, patternIndex = index }) actionResult.allStackStates
                            }

                        else
                            { stack = actionResult.stack
                            , result = Failed
                            , ctx = actionResult.ctx
                            , considerNext = False
                            , halted = actionResult.halted
                            , timeline = Array.map (\x -> { stack = x, patternIndex = index }) actionResult.allStackStates
                            }

                    Nothing ->
                        let
                            actionResult =
                                let
                                    preActionResult =
                                        pattern.action stack ctx
                                in
                                if preActionResult.success == True && isJust pattern.selectedOutput then
                                    { preActionResult | stack = unshift (Tuple.second <| Maybe.withDefault ( NullType, Null ) pattern.selectedOutput) preActionResult.stack }

                                else
                                    preActionResult
                        in
                        if actionResult.success == True then
                            { stack = actionResult.stack, result = Succeeded, ctx = actionResult.ctx, considerNext = False, halted = False, timeline = Array.fromList [ { stack = actionResult.stack, patternIndex = index } ] }

                        else
                            { stack = actionResult.stack, result = Failed, ctx = actionResult.ctx, considerNext = False, halted = False, timeline = Array.fromList [ { stack = actionResult.stack, patternIndex = index } ] }


addEscapedIotaToStack : Array Iota -> Iota -> Array Iota
addEscapedIotaToStack stack iota =
    case Array.get 0 stack of
        Just (OpenParenthesis list) ->
            Array.set 0 (OpenParenthesis (Array.push iota list)) stack

        _ ->
            unshift iota stack


eval : Array Iota -> CastingContext -> { stack : Array Iota, ctx : CastingContext, success : Bool, halted : Bool, allStackStates : Array (Array Iota) }
eval stack ctx =
    let
        maybeIota =
            Array.get 0 stack

        newStack =
            Array.slice 1 (Array.length stack) stack
    in
    case maybeIota of
        Nothing ->
            { stack = unshift (Garbage NotEnoughIotas) newStack, ctx = ctx, success = False, halted = False, allStackStates = Array.fromList [ unshift (Garbage NotEnoughIotas) newStack ] }

        Just iota ->
            case iota of
                IotaList list ->
                    let
                        applyResult =
                            applyToStackStopAtErrorOrHalt
                                newStack
                                ctx
                                list
                    in
                    { stack =
                        Array.filter
                            (\i ->
                                case i of
                                    OpenParenthesis _ ->
                                        False

                                    _ ->
                                        True
                            )
                            applyResult.stack
                    , ctx = applyResult.ctx
                    , success = not applyResult.error
                    , halted = applyResult.halted
                    , allStackStates = Array.map (\x -> x.stack) applyResult.timeline
                    }

                PatternIota pattern _ ->
                    let
                        applyResult =
                            applyToStackStopAtErrorOrHalt newStack ctx (Array.fromList [ PatternIota pattern False ])
                    in
                    { stack = applyResult.stack, ctx = applyResult.ctx, success = not applyResult.error, halted = applyResult.halted, allStackStates = Array.map (\x -> x.stack) applyResult.timeline }

                ContinuationIota continuationState ->
                    let
                        resumeResult =
                            if Array.isEmpty continuationState.stack then
                                { stack = newStack, ctx = continuationState.ctx, success = True, halted = True, allStackStates = Array.fromList [ newStack ] }

                            else
                                let
                                    restored =
                                        applyToStackStopAtErrorOrHalt newStack continuationState.ctx continuationState.stack
                                in
                                { stack = restored.stack
                                , ctx = restored.ctx
                                , success = not restored.error
                                , halted = True
                                , allStackStates = Array.map (\x -> x.stack) restored.timeline
                                }
                    in
                    resumeResult

                _ ->
                    { stack = unshift iota newStack, ctx = ctx, success = True, halted = False, allStackStates = Array.fromList [ unshift iota newStack ] }


evalCC : Array Iota -> CastingContext -> List Iota -> { stack : Array Iota, ctx : CastingContext, success : Bool, allStackStates : Array (Array Iota) }
evalCC stack ctx restPatterns =
    let
        maybeIota =
            Array.get 0 stack

        newStack =
            Array.slice 1 (Array.length stack) stack
    in
    case maybeIota of
        Nothing ->
            { stack = unshift (Garbage NotEnoughIotas) newStack, ctx = ctx, success = False, allStackStates = Array.fromList [ unshift (Garbage NotEnoughIotas) newStack ] }

        Just iota ->
            case getPatternOrIotaList iota of
                Nothing ->
                    { stack = unshift (Garbage IncorrectIota) newStack, ctx = ctx, success = False, allStackStates = Array.fromList [ unshift (Garbage IncorrectIota) newStack ] }

                _ ->
                    let
                        continuationState =
                            { stack = Array.fromList restPatterns, ctx = ctx }

                        continuationStack =
                            Array.append (Array.fromList [ iota, ContinuationIota continuationState ]) newStack

                        actionResult =
                            eval continuationStack ctx
                    in
                    { stack = actionResult.stack
                    , ctx = actionResult.ctx
                    , success = actionResult.success
                    , allStackStates = actionResult.allStackStates
                    }


forEach : Array Iota -> CastingContext -> { stack : Array Iota, ctx : CastingContext, success : Bool, allStackStates : Array (Array Iota) }
forEach stack ctx =
    let
        maybeIota1 =
            Array.get 1 stack

        maybeIota2 =
            Array.get 0 stack

        newStack =
            Array.slice 2 (Array.length stack) stack
    in
    if maybeIota1 == Nothing || maybeIota2 == Nothing then
        let
            newNewStack =
                Array.append (Array.map mapNothingToMissingIota <| Array.fromList <| moveNothingsToFront [ maybeIota1, maybeIota2 ]) newStack
        in
        { stack = newNewStack
        , ctx = ctx
        , success = False
        , allStackStates = Array.fromList [ newNewStack ]
        }

    else
        case ( Maybe.map getIotaList maybeIota1, Maybe.map getIotaList maybeIota2 ) of
            ( Just iota1, Just iota2 ) ->
                if iota1 == Nothing || iota2 == Nothing then
                    let
                        newNewStack =
                            Array.append
                                (Array.fromList
                                    [ Maybe.withDefault (Garbage IncorrectIota) iota1
                                    , Maybe.withDefault (Garbage IncorrectIota) iota2
                                    ]
                                )
                                newStack
                    in
                    { stack = newNewStack
                    , ctx = ctx
                    , success = False
                    , allStackStates = Array.fromList [ newNewStack ]
                    }

                else
                    case ( iota1, iota2 ) of
                        ( Just (IotaList patternList), Just (IotaList iotaList) ) ->
                            let
                                applyResult =
                                    Array.foldl
                                        (\iota accumulator ->
                                            if accumulator.continue == False then
                                                accumulator

                                            else
                                                let
                                                    subApplyResult =
                                                        applyToStackStopAtErrorOrHalt
                                                            (unshift iota newStack)
                                                            accumulator.ctx
                                                            patternList

                                                    thothList =
                                                        case Array.get 0 accumulator.stack of
                                                            Just (IotaList list) ->
                                                                list

                                                            _ ->
                                                                Array.empty

                                                    success =
                                                        if accumulator.success == True && subApplyResult.error then
                                                            False

                                                        else
                                                            accumulator.success
                                                in
                                                { stack = Array.set 0 (IotaList (Array.append thothList (Array.reverse subApplyResult.stack))) accumulator.stack
                                                , ctx = subApplyResult.ctx
                                                , success = success
                                                , continue =
                                                    if not success || subApplyResult.halted then
                                                        False

                                                    else
                                                        True
                                                , allStackStates =
                                                    Array.append
                                                        (unshift (Array.set 0 (IotaList (Array.append thothList (Array.reverse subApplyResult.stack))) accumulator.stack) <|
                                                            Array.map (\x -> x.stack) subApplyResult.timeline
                                                        )
                                                        accumulator.allStackStates
                                                }
                                        )
                                        { stack = unshift (IotaList Array.empty) newStack, ctx = ctx, success = True, continue = True, allStackStates = Array.empty }
                                        iotaList
                            in
                            { stack =
                                Array.filter
                                    (\i ->
                                        case i of
                                            OpenParenthesis _ ->
                                                False

                                            _ ->
                                                True
                                    )
                                    applyResult.stack
                            , ctx = applyResult.ctx
                            , success = applyResult.success
                            , allStackStates = applyResult.allStackStates
                            }

                        _ ->
                            { stack = Array.fromList [ Garbage CatastrophicFailure ], ctx = ctx, success = False, allStackStates = Array.fromList [ Array.fromList [ Garbage CatastrophicFailure ] ] }

            _ ->
                -- this should never happen
                { stack = unshift (Garbage CatastrophicFailure) newStack
                , ctx = ctx
                , success = False
                , allStackStates = Array.fromList [ unshift (Garbage CatastrophicFailure) newStack ]
                }
