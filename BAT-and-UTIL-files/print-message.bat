@Echo Off

:REQUIRES: set-colors.bat (to define certain environment variables that represent ANSI character control sequences)

REM usage call print-message MESSAGE_TYPE "message" [0|1]               - arg1=message/colorType, arg2=message, arg3=pause (1) or not (0)
REM usage call print-message TEST                                       - to run internal test suite
REM usage call print-message message without quotes                     - no 3rd arg of 0|1 will cause the whole line to be treated as the message
REM                               NOTE: arg1 must match a color type i.e. "ERROR" "WARNING" "DEBUG" "SUCCESS" "IMPORTANT" "INPUT" "LESS_IMPORTANT", etc

REM DEBUG:
    set DEBUG_PRINTMESSAGE=0

REM Initialize variables
    set TYPE=
    set MESSAGE=Null
    set DO_PAUSE=-666
    set OUR_COLORTOUSE=

REM validate environment
    REM  we expect certain environment variables to be set to certain ANSI escape codes:
    call validate-environment-variables BLINK_ON BLINK_OFF REVERSE_ON REVERSE_OFF ITALICS_ON ITALICS_OFF BIG_TEXT_LINE_1 BIG_TEXT_LINE_2

REM Process parameters
    if "%1" eq "test" goto :TestSuite
    if "%1" eq "none" goto :None
    if %3 GE 0 .and. %3 LE 1 (
        if "%3" eq "1"     (set DO_PAUSE=1)
        if "%2" eq "yes"   (set DO_PAUSE=1)                         %+ REM capture a few potential call mistakes
        if "%2" eq "pause" (set DO_PAUSE=1)                         %+ REM capture a few potential call mistakes
        set MESSAGE=%@UNQUOTE[`%2`]
        if %DEBUG_PRINTMESSAGE% eq 1 echo debug branch 1 because %%3 is %3 - btw %%2=%2 - message is now %MESSAGE
        set TYPE=%1                                                 %+ REM both the color and message type
    ) else (
        set MESSAGE=%@UNQUOTE[`%*`]
        if %DEBUG_PRINTMESSAGE% eq 1 echo debug branch 2: message is now %MESSAGE
        REM set TYPE=NORMAL                                         making this assumption hurts flexibility for misshappen calls to this script. We like to alzheimer's-proof things around here.
        REM set OUR_COLORTOUSE=%COLOR_NORMAL%                       making this assumption hurts flexibility for misshappen calls to this script. We like to alzheimer's-proof things around here.
        REM changed my mind: set DO_PAUSE=1                         we pause by default becuase calling this way means the user doesn't know what they are doing quite as well
    )
    if %DEBUG_PRINTMESSAGE% eq 1 (echo DEBUG: TYPE=%TYPE%,DO_PAUSE=%DO_PAUSE%,MESSAGE=%MESSAGE%)
    if defined COLOR_%TYPE% (set OUR_COLORTOUSE=%[COLOR_%TYPE%])
    if not defined OUR_COLORTOUSE  (
        if %DEBUG_PRINTMESSAGE% eq 1 (echo - Oops! Let's try setting OUR_COLORTOUSE to %%COLOR_%@UPPER[%1])
        set TYPE=%1
        set OUR_COLORKEY=COLOR_%TYPE%
        if %DEBUG_PRINTMESSAGE% eq 1 (
            echo colorkey is %OUR_COLORKEY%
            echo     next is %[%OUR_COLORKEY%]
        )
        set OUR_COLORTOUSE=%[%OUR_COLORKEY%]
        set MESSAGE=%@UNQUOTE[`%2$`]
    )
    if %DEBUG_PRINTMESSAGE% eq 1 (echo TYPE=%TYPE% OUR_COLORTOUSE=%OUR_COLORTOUSE% DO_PAUSE=%DO_PAUSE% MESSAGE is: %MESSAGE% )

REM Validate parameters
    call validate-environment-variable  TYPE 
    call validate-environment-variable  COLOR_%TYPE% "This variable COLOR_%TYPE% should be an existing COLOR_* variable in our environment"
    call validate-environment-variables OUR_COLORTOUSE DO_PAUSE 
    call validate-environment-variable  MESSAGE skip_validation_existence
    set MESSAGE=%@UNQUOTE[%MESSAGE%]


REM Type alias/synonym handling
    if "%TYPE%" eq "ERROR_FATAL"    (set TYPE=FATAL_ERROR)
    if "%TYPE%" eq "IMPORTANT_LESS" (set TYPE=LESS_IMPORTANT)
    if "%TYPE%" eq "WARNING_SOFT"   (set TYPE=WARNING_LESS)


REM Behavior overides and message decorators depending on the type of message?
    if  "%TYPE%"  eq "UNIMPORTANT"    (set DECORATOR_LEFT=...           %+ set DECORATOR_RIGHT=)
    REM to avoid issues with the redirection character, ADVICE's left-decorator is inserted at runtime
    REM "%TYPE%"  eq "ADVICE"         (set DECORATOR_LEFT=`-->`         %+ set DECORATOR_RIGHT=) 
    if  "%TYPE%"  eq "ADVICE"         (set DECORATOR_LEFT=              %+ set DECORATOR_RIGHT=) 
    if  "%TYPE%"  eq "DEBUG"          (set DECORATOR_LEFT=- DEBUG: ``   %+ set DECORATOR_RIGHT=)
    if  "%TYPE%"  eq "LESS_IMPORTANT" (set DECORATOR_LEFT=* ``          %+ set DECORATOR_RIGHT=)
    if  "%TYPE%"  eq "IMPORTANT_LESS" (set DECORATOR_LEFT=* ``          %+ set DECORATOR_RIGHT=)
    if  "%TYPE%"  eq "IMPORTANT"      (set DECORATOR_LEFT=*** ``        %+ set DECORATOR_RIGHT=)
    if  "%TYPE%"  eq "WARNING"        (set DECORATOR_LEFT=!! ``         %+ set DECORATOR_RIGHT= !!)
    if  "%TYPE%"  eq "CELEBRATION"    (set DECORATOR_LEFT=*** ``        %+ set DECORATOR_RIGHT=! ***)
    if  "%TYPE%"  eq "COMPLETION"     (set DECORATOR_LEFT=*** ``        %+ set DECORATOR_RIGHT=! ***)
    if  "%TYPE%"  eq "ALARM"          (set DECORATOR_LEFT=* ``          %+ set DECORATOR_RIGHT= *)
    if  "%TYPE%"  eq "ERROR"          (set DECORATOR_LEFT=*** ``        %+ set DECORATOR_RIGHT= ***)
    if  "%TYPE%"  eq "FATAL_ERROR"    (set DECORATOR_LEFT=***** !!! ``  %+ set DECORATOR_RIGHT= !!! *****)
    set DECORATED_MESSAGE=%DECORATOR_LEFT%%MESSAGE%%DECORATOR_RIGHT%


REM Update the window title, with its own independent decorators 
    set TITLE=%MESSAGE%
    if "%TYPE%" eq          "DEBUG" (set            TITLE=DEBUG: %title%)
    if "%TYPE%" eq   "WARNING_LESS" (set          TITLE=Warning: %title%)
    if "%TYPE%" eq        "WARNING" (set          TITLE=WARNING: %title% !)
    if "%TYPE%" eq "LESS_IMPORTANT" (set                 TITLE=! %title% !)
    if "%TYPE%" eq "IMPORTANT_LESS" (set                 TITLE=! %title% !)
    if "%TYPE%" eq      "IMPORTANT" (set                TITLE=!! %title% !!)
    if "%TYPE%" eq          "ALARM" (set          TITLE=! ALARM: %title% !)
    if "%TYPE%" eq          "ERROR" (set         TITLE=!! ERROR: %title% !!)
    if "%TYPE%" eq    "FATAL_ERROR" (set TITLE=!!!! FATAL ERROR: %title% !!!!)

REM Pre-message beep based on message type
    if "%TYPE%" eq "DEBUG"  (beep  lowest 1)
    if "%TYPE%" eq "ADVICE" (beep highest 3)

REM Pre-Message pause based on message type
        if %DO_PAUSE% eq 1 (echo.)                                                                                                     %+ REM pausable messages need a litle visual cushion

REM Pre-Message determination of if we do a big header or not
                                                                                                                        set BIG_HEADER=0
        if  "%TYPE%" eq "ERROR" .or. "%TYPE%" eq "FATAL_ERROR" .or. "%TYPE%" eq "ALARM" .or. "%TYPE%" eq "CELEBRATION" (set BIG_HEADER=1)

REM Pre-Message determination of how many times we will display the msessage
        set HOW_MANY=1 
        if "%TYPE%" eq       "ERROR" (set HOW_MANY=1 2 3)
        if "%TYPE%" eq "FATAL_ERROR" (set HOW_MANY=1 2 3 4 5)

REM Actually display the message
        REM display our opening big-header, if we are in big-header mode
        if %BIG_HEADER eq 1 (set COLOR_TO_USE=%OUR_COLORTOUSE% %+ call bigecho ****%DECORATOR_LEFT%%@UPPER[%TYPE%]%DECORATOR_RIGHT%****)

        REM repeat the message the appropriate number of times
        for %msgNum in (%HOW_MANY%) do (           
            REM handle pre-message formatting [color/blinking/reverse/italics/faint], based on what type of message and which message in the sequence of repeated messages it is
            %OUR_COLORTOUSE%
            if  %BIG_HEADER eq    1           (echos %BLINK_ON%)
            if "%TYPE%"     eq "SUBTLE"       (echos %FAINT_ON%)
            if "%TYPE%"     eq "UNIMPORTANT"  (echos %FAINT_ON%)
            if "%TYPE%"     eq "SUCCESS"      (echos  %BOLD_ON%)
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

            REM HACK: This one decorator has to be manually displayed here at the last minute to avoid issues with ">" being the redirection character
            if "%TYPE%" eq "ADVICE" (echos `--> `)

            REM actually print the message:
            echos %DECORATED_MESSAGE% 

            REM handle post-message formatting
            if "%TYPE%"     eq "UNIMPORTANT" (echos %FAINT_OFF%)
            if "%TYPE%"     eq "SUBTLE"      (echos %FAINT_OFF%)
            if "%TYPE%"     eq "SUCCESS"     (echos  %BOLD_OFF%)
            if  %BIG_HEADER eq    1          (echos %BLINK_OFF%)
            %COLOR_NORMAL% 
            echo ``
        )
        REM display our closing big-header, if we are in big-header mode
        if %BIG_HEADER eq 1 (set COLOR_TO_USE=%OUR_COLORTOUSE% %+ call bigecho ****%DECORATOR_LEFT%%@UPPER[%TYPE%]%DECORATOR_RIGHT%****)



REM Post-message delays and pauses
        set DO_DELAY=0    
        REM DO_PAUSE=0 WOULD BE FATAL beause we set this from calling scripts for automation
        if "%TYPE%" eq "WARNING"                        (set DO_DELAY=1)
        if "%TYPE%" eq "FATAL_ERROR"                    (set DO_DELAY=2)
        if "%TYPE%" eq "ERROR" .or. "%TYPE%" eq "ALARM" (set DO_PAUSE=1)
        if "%TYPE%" eq "FATAL_ERROR"                    (set DO_PAUSE=2)

REM Post-message beeps and sound effects
        if "%TYPE%" eq "CELEBRATION" .or. "%TYPE%" eq "COMPLETION" (beep exclamation)
        if "%TYPE%" eq "ERROR" .or. "%TYPE%" eq "ALARM"   (
            beep 145 1 ^ beep 120 1 ^ beep 100 1 ^ beep 80 1 ^ beep 65 1 ^ beep 50 1 ^ beep 40 1 
            beep hand
        )         
        if "%TYPE%" eq "WARNING" (
            *beep 60 1 ^ *beep 69 1        
            REM beep hand was overkil
            beep question
        )                                                                                                                              
        if "%TYPE%" eq "FATAL_ERROR" (
            for %alarmNum in (1 2 3) do (beep ^ beep 145 1 ^ beep 120 1 ^ beep 100 1 ^ beep 80 1 ^ beep 65 1 ^ beep 50 1 ^ beep 40 1)
            beep hand
         )        

    REM Do delay:
        if %DO_DELAY gt 0 (delay %DO_DELAY)
    
REM For errors, give chance to gracefully exit the script (no more mashing of ^C / ^Break)
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



