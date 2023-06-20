@echo off

:USAGE: askyn "question" "yes|no" - 1st param is question, 2nd is yes/no defult, 3rd is wait_time before expiration
:SIDE-EFFECTS: sets ANSWER to Y or N, and sets DO_IT to 1 (if yes) or 0 (if no)

REM Parameter catching:
        set question=%1
        set ANSWER=
        set default_answer=%2
        set DO_IT=

        set WAIT_OPS=
        set wait_time=%3
        if "%wait_time%" ne "" set WAIT_OPS=/T /W%wait_time% 

        
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

REM Ask the question:
        %COLOR_PROMPT% 
        echos *** %@UNQUOTE[%question]?  [
        if "%default_answer" eq "yes" echos Y
        if "%default_answer" eq "no"  echos y
        echos /
        if "%default_answer" eq "yes" echos n
        if "%default_answer" eq "no"  echos N
        echos ] 
        beep question
        %COLOR_INPUT% 
        echos  `` 
        %COLOR_INPUT% 
        inkey %WAIT_OPS% /c /k"yn[Enter]" %%OUR_ANSWER

        REM use default answer if we timed out, which should only happen if WAIT_OPS exists:
        if "%WAIT_OPS%" ne "" .and. "%OUR_ANSWER%" eq "" (
            echo.
            set OUR_ANSWER=%default_answer%
        )        

REM react to the answer
        call validate-environment-variable OUR_ANSWER
        set DO_IT=0
        set ANSWER=N
        call print-if-debug "our_answer is '%OUR_ANSWER'"

        if %OUR_ANSWER% eq "@28"  .or. "%@ASCII[%OUR_ANSWER]"=="64 50 56" (
            if     "%default_answer%"     eq "no"  ( set DO_IT=0 %+ set ANSWER=N )
            if     "%default_answer%"     eq "yes" ( set DO_IT=1 %+ set ANSWER=Y )                  
        ) 
        if %@UPPER["%OUR_ANSWER%"] eq "Y"   ( set DO_IT=1 %+ set ANSWER=Y )
        if %@UPPER["%OUR_ANSWER%"] eq "N"   ( set DO_IT=0 %+ set ANSWER=N )                  

goto :END

        :Oops
            call fatal_error "That was not a valid way to call %0 ... You need a 2nd parameter of 'yes' or 'no' to set a default_answer for when ENTER is pressed"
         goto :END

:END