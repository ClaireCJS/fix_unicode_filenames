@Echo Off

:REQUIRES: set-colors.bat (to define certain environment variables that represent ANSI character control sequences)

:USAGE: call print-message MESSAGE_TYPE "message" [0|1]               - arg1=message/colorType, arg2=message, arg3=pause (1) or not (0)
:USAGE: call print-message TEST                                       - to run internal test suite
:USAGE: call print-message message without quotes                     - no 3rd arg of 0|1 will cause the whole line to be treated as a message without a message type. This is really only meant for processing malformed calls. We're not supposed to do it this way.
:USAGE: NOTE: arg1 must match an existing message type i.e. "ERROR" "WARNING" "DEBUG" "SUCCESS" "IMPORTANT" "INPUT" "LESS_IMPORTANT"
:USAGE: ENVIRONMENT: set PRINTMESSAGE_OPT_SUPPRESS_AUDIO=1  to suppress audio effects. Must be set each call.
:USAGE: ENVIRONMENT:                         If SLEEPING=1, we suppress audio effects as well! This doesn't need to be set each call.
:USAGE: ENVIRONMENT:              if NEWLINE_REPLACEMENT=1, we replace \n with newlines so that the message can becomes longer than 1 line. Must be set each call.
:USAGE: MESSAGE CONTENTS:    Use "{PERCENT}" in your message contents to display a % sign, if you have problems.




rem MESSAGE TYPES LIST: PLEASE ADD ANY NEW MESSAGE TYPES TO THIS LIST BEFORE IMPLEMENTING THEM!!!!!!!!!!!!!!!!!!!!!!!!!!!
    set MESSAGE_TYPES=FATAL_ERROR ERROR_FATAL ERROR WARNING WARNING_LESS WARNING_SOFT ALARM DEBUG IMPORTANT IMPORTANT_LESS LESS_IMPORTANT CELEBRATION COMPLETION SUCCESS REMOVAL ADVICE NORMAL UNIMPORTANT SUBTLE
    set MESSAGE_TYPES_WITHOUT_ALIASES=FATAL_ERROR ERROR WARNING WARNING_LESS ALARM DEBUG IMPORTANT IMPORTANT_LESS CELEBRATION COMPLETION SUCCESS REMOVAL ADVICE NORMAL UNIMPORTANT SUBTLE
    if "%1" eq "vars_only" (goto :END) %+ rem we like to grab these 2 env varibles when environm is run, even before print-message is ever run, via this call: if not defined MESSAGE_TYPES (call print-message vars_only)
    rem ^^^ Gther all these into a nice looking environment variable where they are each appropriately ansi-colored with: gather-message-types-into-pretty-environment-variable.bat






REM DEBUG:
    set DEBUG_PRINTMESSAGE=0


REM Initialize variables:
    set PM_PARAMS=%*
    set PM_PARAMS2=%2$
    set PM_PARAM1=%1
    set PM_PARAM2=%2
    set PM_PARAM3=%3
    set TYPE=
    set DO_PAUSE=-666
    set OUR_COLORTOUSE=
    if %SLEEPING eq 1 (set PRINTMESSAGE_OPT_SUPPRESS_AUDIO=1)
REM Ensure correct environment
    setdos /x0

REM Process parameters
    if "%PM_PARAM1%" eq "test" (goto :TestSuite)
    if "%PM_PARAM1%" eq "none" (goto :None     )
    rem if "%PM_PARAM3%" eq ""                     (
    rem         set MESSAGE=%@UNQUOTE[`%PM_PARAMS`]``
    rem         if %DEBUG_PRINTMESSAGE eq 1 (%COLOR_DEBUG% %+ echo debug branch 2: message is now %MESSAGE %+ %COLOR_NORMAL%)
    rem         REM set TYPE=NORMAL                                         making this assumption hurts flexibility for misshappen calls to this script. We like to alzheimer's-proof things around here.
    rem         REM set OUR_COLORTOUSE=%COLOR_NORMAL%                       making this assumption hurts flexibility for misshappen calls to this script. We like to alzheimer's-proof things around here.
    rem         REM changed my mind: set DO_PAUSE=1                         we pause by default becuase calling this way means the user doesn't know what they are doing quite as well
    rem )
    set MESSAGE=Null
                                 set MESSAGE=%@UNQUOTE[`%PM_PARAMS2`]
    if "%PM_PARAM3%" eq ""      (set MESSAGE=%@UNQUOTE[`%PM_PARAM2%`])
    if "%PM_PARAM3%" eq "1"     (set DO_PAUSE=1)
    if "%PM_PARAM2%" eq "yes"   (set DO_PAUSE=1)                    %+ REM capture a few potential call mistakes
    if "%PM_PARAM2%" eq "pause" (set DO_PAUSE=1)                    %+ REM capture a few potential call mistakes
    if %DEBUG_PRINTMESSAGE% eq 1 (echo %ANSI_COLOR_DEBUG%- debug branch 1 because %%PM_PARAM3 is %PM_PARAM3 - btw %%PM_PARAM2=%PM_PARAM2 - message is now %MESSAGE%ANSI_RESET% )
    set TYPE=%PM_PARAM1%                                            %+ REM both the color and message type


    if %DEBUG_PRINTMESSAGE% eq 1 (echo DEBUG: TYPE=%TYPE%,DO_PAUSE=%DO_PAUSE%,MESSAGE=%MESSAGE%)
    if defined COLOR_%TYPE% (
        set OUR_COLORTOUSE=%[COLOR_%TYPE%]
        set OUR_ANSICOLORTOUSE=%[ANSI_COLOR_%TYPE%]
     )
    if not defined OUR_COLORTOUSE  (
        if %DEBUG_PRINTMESSAGE% eq 1 (echo %ANSI_COLOR_DEBUG% %RED_FLAG% Oops! Let's try setting OUR_COLORTOUSE to %%COLOR_%@UPPER[%PM_PARAM1])
        set TYPE=%PM_PARAM1%
        set OUR_COLORKEY=COLOR_%TYPE%
        if %DEBUG_PRINTMESSAGE eq 1 (
            echo colorkey is ``%OUR_COLORKEY%
            echo     next is %[%OUR_COLORKEY%]
        )
        set OUR_COLORTOUSE=%[%OUR_COLORKEY%]
        set MESSAGE=%@UNQUOTE[`%PM_PARAMS2`]
    )
    if %DEBUG_PRINTMESSAGE eq 1 (echo TYPE=%TYPE% OUR_COLORTOUSE=%OUR_COLORTOUSE% DO_PAUSE=%DO_PAUSE% MESSAGE is: %MESSAGE% )

REM Validate parameters
    if %VALIDATED_PRINTMESSAGE_ENV ne 1 (
        if not defined COLOR_%TYPE%  (call fatal_error "This variable COLOR_%TYPE% should be an existing COLOR_* variable in our environment")
        if not defined MESSAGE       (call fatal_error "$0 called without a message")
        call validate-in-path beep.bat 
        REM call validate-environment-variables BLINK_ON BLINK_OFF REVERSE_ON REVERSE_OFF ITALICS_ON ITALICS_OFF BIG_TEXT_LINE_1 BIG_TEXT_LINE_2 OUR_COLORTOUSE DO_PAUSE EMOJI_TRUMPET ANSI_RESET EMOJI_FLEUR_DE_LIS ANSI_COLOR_WARNING ANSI_COLOR_IMPORTANT RED_FLAG EMOJI_WARNING BIG_TOP_ON BIG_BOT_ON FAINT_ON FAINT_OFF
        set VALIDATED_PRINTMESSAGE_ENV=1
    )


REM convert special characters
    set MESSAGE=%@UNQUOTE[%MESSAGE]
    set ORIGINAL_MESSAGE=%MESSAGE%
    REM might want to do if %NEWLINE_REPLACEMENT eq 1 instead:
    if %NEWLINE_REPLACEMENT eq 1 (
        set MESSAGE=%@REPLACE[\n,%@CHAR[12]%@CHAR[13],%@REPLACE[\t,%@CHAR[9],%MESSAGE]]
        unset /q NEWLINE_REPLACEMENT
    )
    rem sixteen percent symbols is insane, but what is needed:
    set MESSAGE=%@REPLACE[{PERCENT},%%%%%%%%%%%%%%%%,%MESSAGE]
    


REM Type alias/synonym handling
    if "%TYPE%" eq "ERROR_FATAL"    (set TYPE=FATAL_ERROR)
    if "%TYPE%" eq "IMPORTANT_LESS" (set TYPE=LESS_IMPORTANT)
    if "%TYPE%" eq "WARNING_SOFT"   (set TYPE=WARNING_LESS)


REM Behavior overides and message decorators depending on the type of message?
                                       set DECORATOR_LEFT=              %+ set DECORATOR_RIGHT=
    if  "%TYPE%"  eq "UNIMPORTANT"    (set DECORATOR_LEFT=...           %+ set DECORATOR_RIGHT=)
    REM to avoid issues with the redirection character, ADVICE's left-decorator needs to be inserted at runtime if it contains a '>' character. Could proably avoid this with setdos
    REM "%TYPE%"  eq "ADVICE"         (set DECORATOR_LEFT=`-->`         %+ set DECORATOR_RIGHT=) 
    if  "%TYPE%"  eq "ADVICE"         (set DECORATOR_LEFT=%EMOJI_BACKHAND_INDEX_POINTING_RIGHT% `` %+ set DECORATOR_RIGHT= %EMOJI_BACKHAND_INDEX_POINTING_LEFT%) 
    if  "%TYPE%"  eq "NORMAL"         (set DECORATOR_LEFT=              %+ set DECORATOR_RIGHT=) 
    if  "%TYPE%"  eq "DEBUG"          (set DECORATOR_LEFT=- DEBUG: ``   %+ set DECORATOR_RIGHT=)
    if  "%TYPE%"  eq "LESS_IMPORTANT" (set DECORATOR_LEFT=%STAR% ``     %+ set DECORATOR_RIGHT=)
    if  "%TYPE%"  eq "IMPORTANT_LESS" (set DECORATOR_LEFT=%STAR% ``     %+ set DECORATOR_RIGHT=)
    rem "%TYPE%"  eq "IMPORTANT"      (set DECORATOR_LEFT=%ANSI_RED%%EMOJI_TRUMPET_COLORABLE%%@ANSI_FG[255,127,0]%EMOJI_TRUMPET_COLORABLE%%@ansi_fg[212,234,0]%EMOJI_TRUMPET_COLORABLE%%ANSI_BRIGHT_GREEN%%EMOJI_TRUMPET_COLORABLE%%ANSI_BRIGHT_BLUE%%EMOJI_TRUMPET_COLORABLE%%@ANSI_FG[200,0,200]%EMOJI_TRUMPET_COLORABLE%  %ANSI_RESET%%@ANSI_FG[255,0,0]%reverse_on%%blink_on%%EMOJI_FLEUR_DE_LIS%%blink_off%%reverse_off%%ANSI_COLOR_IMPORTANT% `` %+ set DECORATOR_RIGHT= %ANSI_RESET%%@ANSI_FG[255,0,0]%reverse_on%%blink_on%%EMOJI_FLEUR_DE_LIS%%blink_off%%reverse_off%%ANSI_COLOR_IMPORTANT%  %@ANSI_FG[200,0,200]%EMOJI_TRUMPET_FLIPPED%%ANSI_BRIGHT_BLUE%%EMOJI_TRUMPET_FLIPPED%%ANSI_BRIGHT_GREEN%%EMOJI_TRUMPET_FLIPPED%%@ansi_fg[212,234,0]%EMOJI_TRUMPET_FLIPPED%%@ANSI_FG[255,127,0]%EMOJI_TRUMPET_FLIPPED%%ANSI_RED%%EMOJI_TRUMPET_FLIPPED%)
    rem "%TYPE%"  eq "IMPORTANT"      (set DECORATOR_LEFT=%ANSI_RED%%EMOJI_TRUMPET_COLORABLE%%@ANSI_FG[255,127,0]%EMOJI_TRUMPET_COLORABLE%%@ansi_fg[212,234,0]%EMOJI_TRUMPET_COLORABLE%%ANSI_BRIGHT_GREEN%%EMOJI_TRUMPET_COLORABLE%%ANSI_BRIGHT_BLUE%%EMOJI_TRUMPET_COLORABLE%%@ANSI_FG[200,0,200]%EMOJI_TRUMPET_COLORABLE%  %ANSI_RESET%%BLINKING_PENTAGRAM%%ANSI_COLOR_IMPORTANT% %DOUBLE_UNDERLINE_ON%`` %+ set DECORATOR_RIGHT=%DOUBLE_UNDERLINE_OFF% %ANSI_RESET%%BLINKING_PENTAGRAM%%ANSI_COLOR_IMPORTANT%  %@ANSI_FG[200,0,200]%EMOJI_TRUMPET_FLIPPED%%ANSI_BRIGHT_BLUE%%EMOJI_TRUMPET_FLIPPED%%ANSI_BRIGHT_GREEN%%EMOJI_TRUMPET_FLIPPED%%@ansi_fg[212,234,0]%EMOJI_TRUMPET_FLIPPED%%@ANSI_FG[255,127,0]%EMOJI_TRUMPET_FLIPPED%%ANSI_RED%%EMOJI_TRUMPET_FLIPPED%)
    if  "%TYPE%"  eq "IMPORTANT"      (set DECORATOR_LEFT=%ANSI_RED%%EMOJI_TRUMPET_COLORABLE%%@ANSI_FG[255,127,0]%EMOJI_TRUMPET_COLORABLE%%@ansi_fg[212,234,0]%EMOJI_TRUMPET_COLORABLE%%ANSI_BRIGHT_GREEN%%EMOJI_TRUMPET_COLORABLE%%ANSI_BRIGHT_BLUE%%EMOJI_TRUMPET_COLORABLE%%@ANSI_FG[200,0,200]%EMOJI_TRUMPET_COLORABLE% %ANSI_RESET%%BLINKING_PENTAGRAM%%ANSI_COLOR_IMPORTANT%  `` %+ set DECORATOR_RIGHT=  %ANSI_RESET%%BLINKING_PENTAGRAM%%ANSI_COLOR_IMPORTANT%  %@ANSI_FG[200,0,200]%EMOJI_TRUMPET_FLIPPED%%ANSI_BRIGHT_BLUE%%EMOJI_TRUMPET_FLIPPED%%ANSI_BRIGHT_GREEN%%EMOJI_TRUMPET_FLIPPED%%@ansi_fg[212,234,0]%EMOJI_TRUMPET_FLIPPED%%@ANSI_FG[255,127,0]%EMOJI_TRUMPET_FLIPPED%%ANSI_RED%%EMOJI_TRUMPET_FLIPPED%)
    rem "%TYPE%"  eq "WARNING"        (set DECORATOR_LEFT=%EMOJI_WARNING%%EMOJI_WARNING%%EMOJI_WARNING% %blink%!!%blink_off% `` %+ set DECORATOR_RIGHT= %blink%!!%blink_off% %EMOJI_WARNING%%EMOJI_WARNING%%EMOJI_WARNING%)
    if  "%TYPE%"  eq "WARNING"        (set DECORATOR_LEFT=%RED_FLAG%%RED_FLAG%%RED_FLAG%%ANSI_COLOR_WARNING% %EMOJI_WARNING%%EMOJI_WARNING%%EMOJI_WARNING% %@ANSI_BG_RGB[0,0,255]%blink%!!%blink_off% ``  %+  set DECORATOR_RIGHT= %blink%!!%blink_off%%ANSI_COLOR_WARNING% %EMOJI_WARNING%%EMOJI_WARNING%%EMOJI_WARNING% %RED_FLAG%%RED_FLAG%%RED_FLAG%)
    if  "%TYPE%"  eq "SUCCESS"        (set DECORATOR_LEFT=%REVERSE%%BLINK%%EMOJI_CHECK_MARK%%EMOJI_CHECK_MARK%%EMOJI_CHECK_MARK%%BLINK_OFF%%REVERSE_OFF% ``        %+ set DECORATOR_RIGHT= %REVERSE%%BLINK%%EMOJI_CHECK_MARK%%EMOJI_CHECK_MARK%%EMOJI_CHECK_MARK%%REVERSE_OFF%%BLINK_OFF% %PARTY_POPPER%%EMOJI_BIRTHDAY_CAKE%)
    if  "%TYPE%"  eq "CELEBRATION"    (set DECORATOR_LEFT=%EMOJI_GLOWING_STAR%%EMOJI_GLOWING_STAR%%EMOJI_GLOWING_STAR% %BLINK_ON%%EMOJI_PARTYING_FACE% %ITALICS%``        %+ set DECORATOR_RIGHT=%ITALICS_OFF%! %EMOJI_PARTYING_FACE%%BLINK_OFF% %EMOJI_GLOWING_STAR%%EMOJI_GLOWING_STAR%%EMOJI_GLOWING_STAR%)
    if  "%TYPE%"  eq "COMPLETION"     (set DECORATOR_LEFT=*** ``        %+ set DECORATOR_RIGHT=! ***)
    if  "%TYPE%"  eq "ALARM"          (set DECORATOR_LEFT=* ``          %+ set DECORATOR_RIGHT= *)
    if  "%TYPE%"  eq "REMOVAL"        (set DECORATOR_LEFT=%RED_SKULL%%SKULL%%RED_SKULL% ``        %+ set DECORATOR_RIGHT= %RED_SKULL%%SKULL%%RED_SKULL%)
    if  "%TYPE%"  eq "ERROR"          (set DECORATOR_LEFT=*** ``        %+ set DECORATOR_RIGHT= ***)
    if  "%TYPE%"  eq "FATAL_ERROR"    (set DECORATOR_LEFT=***** !!! ``  %+ set DECORATOR_RIGHT= !!! *****)
    rem 20240419 moved to after setting COLOR_TO_USE so we can start setting that before the right decorator in case the message contents changed the color: set DECORATED_MESSAGE=%DECORATOR_LEFT%%MESSAGE%%DECORATOR_RIGHT%


REM We're going to update the window title to the message. If possible, strip any ANSI color codes from it:
    rem this became unreliable: if not "1"== "%PLUGIN_STRIPANSI_LOADED" (goto :No_Title_Stripping)
    if not plugin stripansi (goto :No_Title_Stripping)
        set CLEAN_MESSAGE=%@STRIPANSI[%ORIGINAL_MESSAGE]
        goto :Set_Title_Var_Now
    :No_Title_Stripping
        set CLEAN_MESSAGE=%ORIGINAL_MESSAGE%
    :Set_Title_Var_Now
        set TITLE=%CLEAN_MESSAGE%

    REM But first let's decorate the window title for certain message types Prior to actually updating the window title:
        if "%TYPE%" eq          "DEBUG" (set            TITLE=DEBUG: %title%)
        if "%TYPE%" eq   "WARNING_LESS" (set          TITLE=Warning: %title%)
        if "%TYPE%" eq        "WARNING" (set          TITLE=WARNING: %title% !)
        if "%TYPE%" eq "LESS_IMPORTANT" (set                 TITLE=! %title% !)
        if "%TYPE%" eq "IMPORTANT_LESS" (set                 TITLE=! %title% !)
        if "%TYPE%" eq      "IMPORTANT" (set                TITLE=!! %title% !!)
        if "%TYPE%" eq          "ALARM" (set          TITLE=! ALARM: %title% !)
        if "%TYPE%" eq          "ERROR" (set         TITLE=!! ERROR: %title% !!)
        if "%TYPE%" eq    "FATAL_ERROR" (set TITLE=!!!! FATAL ERROR: %title% !!!!)

    title %title%


REM Some messages will be decorated with audio:
    if %PRINTMESSAGE_OPT_SUPPRESS_AUDIO ne 1 (
        if "%TYPE%" eq "DEBUG"  (beep  lowest 1)
        if "%TYPE%" eq "ADVICE" (beep highest 3)
    )

REM Pre-Message pause based on message type (pausable messages need a litle visual cushion):
        if %DO_PAUSE% eq 1 (echo.)           

REM Pre-Message determination of if we do a big header or not:
                                                                                         set BIG_HEADER=0
        if  "%TYPE%" eq "ERROR" .or. "%TYPE%" eq "FATAL_ERROR" .or. "%TYPE%" eq "ALARM" (set BIG_HEADER=1)

REM Pre-Message determination of how many times we will display the message:
        set HOW_MANY=1 
        if "%TYPE%" eq "CELEBRATION" (set HOW_MANY=1 2)
        if "%TYPE%" eq       "ERROR" (set HOW_MANY=1 2 3)
        if "%TYPE%" eq "FATAL_ERROR" (set HOW_MANY=1 2 3 4 5)

REM Actually display the message:
        setdos /x-6

        REM display our opening big-header, if we are in big-header mode
        if %BIG_HEADER eq 1 (set COLOR_TO_USE=%OUR_COLORTOUSE% %+ call bigecho %@ANSI_MOVE_TO_COL[0]****%DECORATOR_LEFT%%@UPPER[%TYPE%]%DECORATOR_RIGHT%****)

        rem Assemble our message, including resetting the color via ansi codes (%OUR_ANSICOLORTOUSE%) before adding the right decorator, in case the color was changed within the message itself
        rem DECORATED_MESSAGE=%DECORATOR_LEFT%%MESSAGE%%DECORATOR_RIGHT% ———————————— this was the old way
        set DECORATED_MESSAGE=%DECORATOR_LEFT%%MESSAGE%%OUR_ANSICOLORTOUSE%%DECORATOR_RIGHT%

        REM repeat the message the appropriate number of times
        for %msgNum in (%HOW_MANY%) do (           
            REM handle pre-message formatting [color/blinking/reverse/italics/faint], based on what type of message and which message in the sequence of repeated messages it is
            %OUR_COLORTOUSE%
            if  %BIG_HEADER eq    1           (echos %BLINK_ON%)
            if "%TYPE%"     eq "SUBTLE"       (echos %FAINT_ON%)
            if "%TYPE%"     eq "UNIMPORTANT"  (echos %FAINT_ON%)
            if "%TYPE%"     eq "SUCCESS"      (echos %BOLD_ON%)
            if "%TYPE%"     eq "CELEBRATION"  (
                if        %msgNum        == 1 (echos %BIG_TOP_ON%``)
                if        %msgNum        == 2 (echos %BIG_BOT_ON%``)
            )
            if "%TYPE%"     eq "ERROR"   (
                if %@EVAL[%msgNum mod 2] == 1 (echos %REVERSE_ON%)
                if %@EVAL[%msgNum mod 2] == 0 (echos %REVERSE_OFF%%BLINK_OFF%)
            )
            if "%TYPE%" eq "FATAL_ERROR" (
                if %@EVAL[%msgNum mod 3] == 0 (echos %BLINK_OFF%)
                if %@EVAL[%msgNum mod 2] == 1 (echos %REVERSE_OFF%)
                if %@EVAL[%msgNum mod 2] == 0 (echos %REVERSE_ON%)
                if        %msgNum        != 3 (echos %ITALICS_OFF%)
                if        %msgNum        == 3 (echos %ITALICS_ON%)
            )

            REM HACK: Decorators with ">" in them need to be manually outputted here at the last minute to avoid issues with ">" being the redirection character, though setdos could work around this
            if "%TYPE%" eq "ADVICE" (echos `----> `)

            REM actually print the message:
            echos %DECORATED_MESSAGE% 

            REM handle post-message formatting
            if "%TYPE%"     eq "UNIMPORTANT" (echos %FAINT_OFF%)
            if "%TYPE%"     eq "SUBTLE"      (echos %FAINT_OFF%)
            if "%TYPE%"     eq "SUCCESS"     (echos %BOLD_OFF%)
            if "%TYPE%"     eq "CELEBRATION_OLD_CODE_TODO_REMOVE" (
                if 1 == %msgNum% (echos     ``)
                if 2 == %msgNum% (echos     ``)
            )
            if  %BIG_HEADER eq    1          (echos %BLINK_OFF%)

            REM setting color to normal (black on black) and using the erase-to-end-of-line sequence fixes the Windows Termina+TCC bug where a big of the background color is shown in the rightmost column
            echo %ANSI_COLOR_NORMAL%%ANSI_ERASE_TO_EOL%`` 
        )
        REM display our closing big-header, if we are in big-header mode
        if %BIG_HEADER eq 1 (set COLOR_TO_USE=%OUR_COLORTOUSE% %+ call bigecho ****%DECORATOR_LEFT%%@UPPER[%TYPE%]%DECORATOR_RIGHT%****)



REM Post-message delays and pauses
        setdos /x0
        set DO_DELAY=0    
        REM DO_PAUSE=0 WOULD BE FATAL beause we set this from calling scripts for automation
        if "%TYPE%" eq "WARNING"                        (set DO_DELAY=1)
        if "%TYPE%" eq "FATAL_ERROR"                    (set DO_DELAY=2)
        if "%TYPE%" eq "ERROR" .or. "%TYPE%" eq "ALARM" (set DO_PAUSE=1)
        if "%TYPE%" eq "FATAL_ERROR"                    (set DO_PAUSE=2)

REM Post-message beeps and sound effects
        if %PRINTMESSAGE_OPT_SUPPRESS_AUDIO eq 1 (goto :No_Beeps_2)
            if "%TYPE%" eq "CELEBRATION" .or. "%TYPE%" eq "COMPLETION" (beep exclamation)
            if "%TYPE%" eq "ERROR" .or. "%TYPE%" eq "ALARM"   (
                beep 145 1 
                beep 120 1 
                beep 100 1 
                beep  80 1 
                beep  65 1 
                beep  50 1 
                beep  40 1 
                beep hand
            )         
            if "%TYPE%" eq "WARNING" (
                *beep 60 1 
                *beep 69 1        
                REM beep hand was overkil
                beep question
            )                                                                                                                              
            if "%TYPE%" eq "FATAL_ERROR" (
                for %alarmNum in (1 2 3) do (beep %+ beep 145 1 %+ beep 120 1 %+ beep 100 1 %+ beep 80 1 %+ beep 65 1 %+ beep 50 1 %+ beep 40 1)
                beep hand
             )        
        :No_Beeps_2

    REM Do delay:
        if %DO_DELAY gt 0 (delay %DO_DELAY)
    
REM For errors, give chance to gracefully exit the script (no more mashing of ctrl-C / ctrl-Break)
        if "%TYPE%" eq "FATAL_ERROR" .or. "%TYPE%" eq "ERROR" (
            set DO_IT=
            call askyn "Cancel all execution and return to command line?" yes
            if %DO_IT eq 1 CANCEL
        )

REM Hit user with the 'pause' prompt several times, to prevent accidental passthrough from previous key mashing
        if %DO_PAUSE% gt 0 (echo. %+ for %pauseNum in (1 2 3 4 5) do (call randcolor %+ *pause %+ %COLOR_NORMAL%))
        if %DO_PAUSE% gt 1 (         for %pauseNum in (1 2 3 4 5) do (call randcolor %+ *pause %+ %COLOR_NORMAL%))

goto :END


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

        :TestSuite
                call validate-in-path colors.bat important 
                cls
                call colors silent %+ REM sets ALL_COLORS
                echo.
                call important "System print test - press N to go from one to the next --- any other key will cause tests to not complete -- if you get stuck hit enter once, then N -- if that doesn't work hit enter twice, then N"
                echo.
                pause>nul
                for %clr in (%ALL_COLORS%) (
                    set clr4print=%clr%
                    REM if "%clr%" eq "question"    set "clr4print=%CLR%    (windows: 'Question')"
                    echo.
                    cls
                    call important  "about to test %clr4print:"
                    echo.
                    pause>nul
                    cls
                    call print-message %clr "%clr4print"
                    REM sleep 1
                    pause>nul
                )
        goto :END


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::



:None
:END


if defined PRINTMESSAGE_OPT_SUPPRESS_AUDIO (set PRINTMESSAGE_OPT_SUPPRESS_AUDIO=)

