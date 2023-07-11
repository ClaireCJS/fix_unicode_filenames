@echo off

:USAGE: askyn "question" "yes|no" - 1st param is question, 2nd is yes/no defult, 3rd is wait_time before expiration
:SIDE-EFFECTS: sets ANSWER to Y or N, and sets DO_IT to 1 (if yes) or 0 (if no)
:DEPENDENCIES: set-colors.bat validate-environment-variable.bat validate-environment-variables.bat print-if-debug.bat fatal_error.bat bigecho.bat bigechos.bat echobig.bat echosbig.bat

REM Parameter catching:
        set question=%1
        set ANSWER=
        set default_answer=%2
        set DO_IT=

        set WAIT_OPS=
        set wait_time=%3
        if "%wait_time%" ne "" set WAIT_OPS=/T /W%wait_time% 

        set PARAM_4=%4
                                                                    set NO_ENTER_KEY=0
        if "%PARAM_4%" eq "noenter" .or. "%PARAM_4%" eq "no_enter" (set NO_ENTER_KEY=1)
        if "%PARAM_5%" eq "noenter" .or. "%PARAM_5%" eq "no_enter" (set NO_ENTER_KEY=1)
        REM DEBUG: echo PARAM_4 = %PARAM_4 ... NO_ENTER_KEY is %NO_ENTER_KEY

        set PARAM_5=%5                             
                                                           set BIG_QUESTION=0
        if "%PARAM_4%" eq "big" .or. "%PARAM_5%" eq "big" (set BIG_QUESTION=1)

        
REM Parameter validation:
        call validate-environment-variable question skip_validation_existence
        if "%default_answer" ne "" .and. "%default_answer%" ne "yes" .and. "%default_answer%" ne "no" .and. "%default_answer%" ne "y" .and. "%default_answer%" ne "n" (
           call fatal_error "2nd parameter can only be 'yes', 'no', 'y', or 'n'"
        )
        if "%2" eq "" (
            set default_answer=no
            call warning "Answer is defaulting to %default_answer% because 2nd parameter was not passed"
        )

REM Parameter processing/massaging:
        if "%default_answer%" eq "y" (set default_answer=yes)
        if "%default_answer%" eq "n" (set default_answer=no)


REM Build the question prompt:
                                      set QUESTION=%ASKYN_DECORATOR%*** %@UNQUOTE[%question]? [
        if "%default_answer" eq "yes" set QUESTION=%question%Y
        if "%default_answer" eq "no"  set QUESTION=%question%y
                                      set QUESTION=%question%/
        if "%default_answer" eq "yes" set QUESTION=%question%n
        if "%default_answer" eq "no"  set QUESTION=%question%N
                                      set QUESTION=%question%] 
                                      set QUESTION=%question%

REM Which keys will we allow?
                               set ALLOWABLE_KEYS="yn[Enter]"
        if %NO_ENTER_KEY eq 1 (set ALLOWABLE_KEYS="yn")

REM Decide how to display the question prompt:
                                    set ECHO_COMMAND=echos ``
        rem if defined ASKYN_DECORATOR (set ECHO_COMMAND=echos %ASKYN_DECORATOR%)
        if %BIG_QUESTION eq 1      (set ECHO_COMMAND=%@REPLACE[echos,call bigechos,%ECHO_COMMAND])
        if defined ASKYN_DECORATOR (set ASKYN_DECORATOR=)


REM Actually ask the question (and use the system sound for 'question')
        %COLOR_PROMPT% 
        %ECHO_COMMAND% %QUESTION%`` %+ REM yes, there should be no space between %ECHO_COMMAND% and %QUESTION%
        echos  ``
        echos %ANSI_COLOR_INPUT%

        REM goat beep question

REM Actually ask the question here:
        %COLOR_INPUT% 
        inkey /x %WAIT_OPS% /c /k"%ALLOWABLE_KEYS%" %%OUR_ANSWER
        echos %ANSI_COLOR_INPUT%


REM use default answer if we timed out, which should only happen if WAIT_OPS exists:
        if "%WAIT_OPS%" ne "" .and. "%OUR_ANSWER%" eq "" (
            echo.
            set OUR_ANSWER=%default_answer%
        )        

REM Make sure we have an answer, and initialize our return values
        call validate-environment-variable OUR_ANSWER
        set DO_IT=0
        set ANSWER=N
        call print-if-debug "our_answer is '%OUR_ANSWER'"

REM Process the enter key into our default answer
        if %OUR_ANSWER% eq "@28" .or. "%@ASCII[%OUR_ANSWER]"=="64 50 56" (
            if  "%default_answer%" eq "no"  ( set DO_IT=0 %+ set ANSWER=N )
            if  "%default_answer%" eq "yes" ( set DO_IT=1 %+ set ANSWER=Y )                  
            echos  ``
        ) 

REM Set our return values
        if "%OUR_ANSWER%" eq "Y" ( set DO_IT=1 %+ set ANSWER=%OUR_ANSWER% )
        if "%OUR_ANSWER%" eq "N" ( set DO_IT=0 %+ set ANSWER=%OUR_ANSWER% )           
        

REM Echo out what we just typed
REM In the case of big text, we need to go up a line and fill in the top-half of the letter we just typed!
        if %BIG_QUESTION ne 1 (echo %@ANSI_LEFT[1]%ITALICS%%BOLD%%BLINK_ON%%ANSWER%%BLINK_OFF%%BOLD_OFF%%ITALICS_OFF%)
        if %BIG_QUESTION eq 1 (echo %ANSI_POSITION_SAVE%%@ANSI_MOVE_LEFT[1]%BLINK_ON%%ANSWER%%@ANSI_MOVE_LEFT[1]%@ANSI_MOVE_UP[1]%BIG_TOP%%ANSWER%%ANSI_POSITION_RESTORE%%ANSI_RESET%)
        REM echo OUR_ANSWER=%OUR_ANSWER%


goto :END


                :Oops
                    call fatal_error "That was not a valid way to call %0 ... You need a 2nd parameter of 'yes' or 'no' to set a default_answer for when ENTER is pressed"
                 goto :END


:END
