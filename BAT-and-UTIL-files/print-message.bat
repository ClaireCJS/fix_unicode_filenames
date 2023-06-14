@Echo Off

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
    call validate-environment-variable  COLOR_%TYPE% "This variable should be an existing COLOR_* variable in our environment"
    call validate-environment-variables OUR_COLORTOUSE DO_PAUSE 
    call validate-environment-variable  MESSAGE skip_validation_existence
    set MESSAGE=%@UNQUOTE[%MESSAGE%]


REM Type alias/synonym handling
    if "%TYPE%" eq "ERROR_FATAL"    (set TYPE=FATAL_ERROR)
    if "%TYPE%" eq "IMPORTANT_LESS" (set TYPE=LESS_IMPORTANT)
    if "%TYPE%" eq "WARNING_SOFT"   (set TYPE=WARNING_LESS)


REM Behavior overides and message decorators depending on the type of message?
    if  "%TYPE%"  eq "UNIMPORTANT"    set MESSAGE=...%MESSAGE%
    REM "%TYPE%"  eq "ADVICE"         set MESSAGE=--> %MESSAGE%  To avoid issues with the redirection character, this decorator is inserted below just-in-time at runtime
    if  "%TYPE%"  eq "DEBUG"          set MESSAGE=- DEBUG: %MESSAGE%
    if  "%TYPE%"  eq "LESS_IMPORTANT" set MESSAGE=* %MESSAGE%
    if  "%TYPE%"  eq "IMPORTANT_LESS" set MESSAGE=* %MESSAGE%
    if  "%TYPE%"  eq "IMPORTANT"      set MESSAGE=*** %MESSAGE%
    if  "%TYPE%"  eq "WARNING"        set MESSAGE=!! %MESSAGE% !!
    if  "%TYPE%"  eq "CELEBRATION"    set MESSAGE=*** %MESSAGE%! ***
    if  "%TYPE%"  eq "COMPLETION"     set MESSAGE=*** %MESSAGE%! ***
    if  "%TYPE%"  eq "ALARM"          set MESSAGE=****** %MESSAGE% *******
    if  "%TYPE%"  eq "ERROR"          set MESSAGE=********** %MESSAGE% ***********
    if  "%TYPE%"  eq "FATAL_ERROR"    set MESSAGE=*********************** !!! %MESSAGE% !!! ***********************


REM Pre-message beep based on message type
    if "%TYPE%" eq "DEBUG"  (beep  lowest 1)
    if "%TYPE%" eq "ADVICE" (beep highest 3)

REM Actually output the message!

    REM pause or repeat the message if appliacble
        if %DO_PAUSE% eq 1 (echo.)                                                                                                     %+ REM pausable messages need a litle visual cushion
        set HOW_MANY=1 
        if "%TYPE%" eq       "ERROR" set HOW_MANY=1 2 3
        if "%TYPE%" eq "FATAL_ERROR" set HOW_MANY=1 2 3 4 5 6
    REM print the message
        for %msgNum in (%HOW_MANY%) do (
            %OUR_COLORTOUSE% 
            if  "%TYPE%" eq "ADVICE" echos `--> `
            echos %MESSAGE% 
            %COLOR_NORMAL% %+ echo ``
        )
        set TITLE=%MESSAGE%


REM Message-type-based behavior:

    rem Determine window titles
        if "%TYPE%" eq          "DEBUG" (set            TITLE=DEBUG: %title%)
        if "%TYPE%" eq   "WARNING_LESS" (set          TITLE=Warning: %title%)
        if "%TYPE%" eq        "WARNING" (set          TITLE=WARNING: %title% !)
        if "%TYPE%" eq "LESS_IMPORTANT" (set                 TITLE=! %title% !)
        if "%TYPE%" eq      "IMPORTANT" (set                TITLE=!! %title% !!)
        if "%TYPE%" eq          "ERROR" (set         TITLE=!! ERROR: %title% !!)
        if "%TYPE%" eq    "FATAL_ERROR" (set TITLE=!!!! FATAL ERROR: %title% !!!!)

    REM Determine delays and pauses
        set DO_DELAY=0    
        REM DO_PAUSE=0 WOULD BE FATAL beause we set this from calling scripts for automation
        if "%TYPE%" eq "WARNING"                        (set DO_DELAY=1)
        if "%TYPE%" eq "FATAL_ERROR"                    (set DO_DELAY=2)
        if "%TYPE%" eq "ERROR" .or. "%TYPE%" eq "ALARM" (set DO_PAUSE=1)
        if "%TYPE%" eq "FATAL_ERROR"                    (set DO_PAUSE=2)

    REM Post-message beep based on message type
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
    
    REM Determine type-based custom behavior
        if "%TYPE%" eq "FATAL_ERROR" (
            set DO_IT=
            call askyn "Cancel all execution and return to command line?" yes
            if %DO_IT eq 1 CANCEL
        )

    REM Do pause:
        if %DO_PAUSE% gt 0 (echo. %+ for %pauseNum in (1 2 3 4 5) do (call randcolor %+ *pause %+ %COLOR_NORMAL%))
        if %DO_PAUSE% gt 1 (         for %pauseNum in (1 2 3 4 5) do (call randcolor %+ *pause %+ %COLOR_NORMAL%))

goto :END


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

        :TestSuite
                cls
                call colors silent %+ REM sets ALL_COLORS
                echo.
                call important "System print test - press N to go from one to the next --- any other key will cause tests to not complete"
                echo.
                pause>nul
                for %clr in (error_fatal %ALL_COLORS%) (
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



