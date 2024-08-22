@echo off

set                            ASK_QUESTION=%[1]
if defined AskYN_question (set ASK_QUESTION=%AskYN_question% %+ unset /q AskYN_question)
set DEFAULT_ANSWER=%2
set WAIT_TIME=%3
set PARAM_4=%4
set PARAM_5=%5``                         



if "%ASK_QUESTION%" eq "help" .or. "%ASK_QUESTION%" eq "--help" .or. "%ASK_QUESTION%" eq "/?" .or. "%ASK_QUESTION%" eq "-?" .or. "%ASK_QUESTION%" eq "-h" (
    %color_advice%
    echo USAGE: askyn ["question"] ["yes" or "no"] - 1st param is question, 2nd is yes/no defult, 3rd is wait_time before expiration, 4th parameter is 'big' if it's big
    echo USAGE: askyn test - run our test suite
    goto :END
)
title %EMOJI_RED_QUESTION_MARK%%@UNQUOTE[%ASK_QUESTION%]%EMOJI_RED_QUESTION_MARK%

:USAGE: askyn "question" "yes|no" - 1st param is question, 2nd is yes/no defult, 3rd is wait_time before expiration (NULL for no wait time), 4th is "no_enter" do disallow enter key, 5th is "big" to make this a big-text prompt
:SIDE-EFFECTS: sets ANSWER to Y or N, and sets DO_IT to 1 (if yes) or 0 (if no)
:DEPENDENCIES: set-colors.bat validate-environment-variable.bat validate-environment-variables.bat print-if-debug.bat fatal_error.bat bigecho.bat bigechos.bat echobig.bat echosbig.bat test-askyn.bat



REM Test suite special case, including testing for the facts that higher timer values are wider timers which affect answer character placement:
        if "%1" ne "test" goto :Not_A_Test
                cls
                call important "About to do %0 test suite"
                echo ———————————————————————————————————————————————————————————————————
                call AskYN         "  Big question defaulting to  no d:0"  no      0 big
                call AskYN         "  Big question defaulting to yes d:0" yes      0 big
                call AskYN         "Timed question defaulting to  no d:1"  no      9 big
                call AskYN         "Timed question defaulting to yes d:1" yes      9 big
                call AskYN         "TIMED question defaulting to  no d:2"  no     99 big
                call AskYN         "TIMED question defaulting to yes d:2" yes     99 big
                call AskYN         "TIMED question defaulting to  no d:3"  no    999 big
                call AskYN         "TIMED question defaulting to yes d:3" yes    999 big
                call AskYN         "TIMED question defaulting to  no d:4"  no   9999 big
                call AskYN         "TIMED question defaulting to yes d:4" yes   9999 big
                call AskYN         "TIMED question defaulting to  no d:5"  no  99999 big
                call AskYN         "TIMED question defaulting to yes d:5" yes  99999 big
                call AskYN         "TIMED question defaulting to  no d:6"  no 999999 big
                call AskYN         "TIMED question defaulting to yes d:6" yes 999999 big
                call AskYN "Generic       question defaulting to yes"     yes
                call AskYN "Generic       question defaulting to  no"      no
                call AskYN "Generic timed question defaulting to yes"     yes      9
                call AskYN "Generic timed question defaulting to  no"      no      9
                call AskYN "Generic TIMED question defaulting to yes"     yes   9999
                call AskYN "Generic TIMED question defaulting to  no"      no   9999
                goto :END
        :Not_A_Test


REM Variable setup:
        set ANSWER=
        set DO_IT=
        set OUR_ANSWER=
        set  WAIT_OPS=
        SET  WAIT_TIMER_ACTIVE=0
        if "%WAIT_TIME%" ne "" .and. "%WAIT_TIME%" ne "NULL" .and. "%WAIT_TIME%" ne "0" (set WAIT_OPS=/T /W%wait_time% %+ set WAIT_TIMER_ACTIVE=1)

                                                                    set NO_ENTER_KEY=0
        if "%PARAM_4%" eq "noenter" .or. "%PARAM_4%" eq "no_enter" (set NO_ENTER_KEY=1)
        if "%PARAM_5%" eq "noenter" .or. "%PARAM_5%" eq "no_enter" (set NO_ENTER_KEY=1)
        rem DEBUG: echo PARAM_4 = %PARAM_4 ... NO_ENTER_KEY is %NO_ENTER_KEY

                                                           set BIG_QUESTION=0
        if "%PARAM_4%" eq "big" .or. "%PARAM_5%" eq "big" (set BIG_QUESTION=1)

        
REM Parameter validation:
        rem Let's not dip into all this for something used so often: call validate-environment-variable question skip_validation_existence
        if not defined ask_question (call fatal_error "$0 called without a question being passed as the 1st parameter (also, 'yes'/'no' must be a 2nd parameter)")
        if "%default_answer" ne "" .and. "%default_answer%" ne "yes" .and. "%default_answer%" ne "no" .and. "%default_answer%" ne "y" .and. "%default_answer%" ne "n" (
           call fatal_error "2nd parameter to %0 can only be 'yes', 'no', 'y', or 'n' but was '%DEFAULT_ANSWER%'"
        )
        if "%DEFAULT_ANSWER%" eq "" (
            set default_answer=no
            call warning "Answer is defaulting to %default_answer% because 2nd parameter was not passed"
        )


REM Parameter massaging:
        if "%default_answer%" eq "y" (set default_answer=yes)
        if "%default_answer%" eq "n" (set default_answer=no)


REM Build the question prompt:
                          unset /q WIN7DECORATOR
        if "%OS%" eq "7" (  set    WIN7DECORATOR=*** ``)
        set BRACKET_COLOR=224,0,0
        set PRETTY_QUESTION=%@UNQUOTE[%ASK_QUESTION]
        rem echo "pretty question is '%pretty_question%'"
        rem pause
                                      set PRETTY_QUESTION=%EMOJI_RED_QUESTION_MARK%%ANSI_COLOR_BRIGHT_RED%%ASKYN_DECORATOR%%WIN7DECORATOR%%PRETTY_QUESTION%%ITALICS_ON%%BLINK_ON%?%BLINK_OFF%%ITALICS_OFF%%ANSI_RESET% %@ANSI_FG_RGB[%BRACKET_COLOR][
        if "%default_answer" eq "yes" set PRETTY_QUESTION=%pretty_question%%bold%%underline%%ANSI_COLOR_PROMPT%Y%underline_off%%bold_off%
        if "%default_answer" eq "no"  set PRETTY_QUESTION=%pretty_question%%faint%y%faint_off%
                                      set PRETTY_QUESTION=%pretty_question%%italics_off%%bold_off%%underline_off%%double_underline_off%%@ANSI_FG_RGB[%BRACKET_COLOR]/
        if "%default_answer" eq "yes" set PRETTY_QUESTION=%pretty_question%%faint%n%faint_off%
        if "%default_answer" eq "no"  set PRETTY_QUESTION=%pretty_question%%bold%%underline%%ANSI_COLOR_PROMPT%N%underline_off%%bold_off%
                                      set PRETTY_QUESTION=%pretty_question%%@ANSI_FG_RGB[%BRACKET_COLOR]]%EMOJI_RED_QUESTION_MARK%
                                      set PRETTY_QUESTION_ANSWERED=%@REPLACE[%BLINK_ON%,,%PRETTY_QUESTION] %+ rem an unblinking version, so the question mark that blinks before we answer is still displayed——but stops blinking after we answer the question 
title %@STRIPANSI[%PRETTY_QUESTION]


REM Which keys will we allow?
                               set ALLOWABLE_KEYS=yn[Enter]
        if %NO_ENTER_KEY eq 1 (set ALLOWABLE_KEYS=yn)


:deprecated: REM Decide how to display the question prompt:
:deprecated:                                     set ECHO_COMMAND=echos
:deprecated:         if defined ASKYN_DECORATOR (set ECHO_COMMAND=echos %ASKYN_DECORATOR%)
:deprecated:         if %BIG_QUESTION eq 1      (set ECHO_COMMAND=%@REPLACE[echos ,call bigechos ,%ECHO_COMMAND])
:deprecated:         if defined ASKYN_DECORATOR (set ASKYN_DECORATOR=)


REM Print the question out if we aren't loading INKEY with the question:
        if %BIG_QUESTION eq 1 (call echosbig %PRETTY_QUESTION% ``)


REM Load INKEY with the question, unless we've already printed it out:
                                    set INKEY_QUESTION=%PRETTY_QUESTION%%ANSI_POSITION_SAVE%``
        rem   IT_TIMER_ACTIVE ne 0 (set INKEY_QUESTION=%INKEY_QUESTION% ``)
        if %WAIT_TIMER_ACTIVE eq 0 .and. %BIG_QUESTION eq 1 (set INKEY_QUESTION=)


REM Actually answer the question here —— make the windows 'question' noise first, then get the user input:
        *beep question                                                             
        inkey /x %WAIT_OPS% /c /k"%ALLOWABLE_KEYS%" %INKEY_QUESTION% %%OUR_ANSWER
        echos %BLINK_OFF%


REM set default answer if we hit ENTER, or timed out (which should only happen if WAIT_OPS exists):
        if "%WAIT_OPS%" ne "" .and. ("%OUR_ANSWER%" eq "" .or. "%OUR_ANSWER%" eq "@28") (
            set OUR_ANSWER=%default_answer%
            call print-if-debug "timed out, OUR_ANSWER set to '%OUR_ANSWER%'"
        )        


REM Make sure we have an answer, and initialize our return values
        if not defined OUR_ANSWER ( call error "OUR_ANSWER is not defined in %0" )
        set DO_IT=0
        set ANSWER=%OUR_ANSWER%


REM Process the enter key into our default answer:
        if %OUR_ANSWER% eq "@28" .or. "%@ASCII[%OUR_ANSWER]"=="64 50 56" (
            if  "%default_answer%" eq "no"  ( set DO_IT=0 %+ set ANSWER=N )
            if  "%default_answer%" eq "yes" ( set DO_IT=1 %+ set ANSWER=Y )                  
            echos  ``
            call print-if-debug "enter key processing, answer is now '%ANSWER%'"
        ) 

REM Title
title %@STRIPANSI[%PRETTY_QUESTION] %A


REM Set our 2 major return values that are referred to from calling scripts:
        if "%OUR_ANSWER%" eq "Y" .or. "%OUR_ANSWER%" eq "yes" (set DO_IT=1 %+ set ANSWER=Y)
        if "%OUR_ANSWER%" eq "N" .or. "%OUR_ANSWER%" eq "no"  (set DO_IT=0 %+ set ANSWER=N) 


REM Generate "pretty" answers & update the title:
        if "%ANSWER" eq "Y" .or. "%ANSWER" eq "yes" (set PRETTY_ANSWER=%ANSI_BRIGHT_GREEN%%ITALICS_ON%%DOUBLE_UNDERLINE_ON%Yes%DOUBLE_UNDERLINE_OFF%%BLINK_ON%!%BLINK_OFF%%ITALICS_OFF%)
        if "%ANSWER" eq "N" .or. "%ANSWER" eq "no"  (set PRETTY_ANSWER=%ANSI_BRIGHT_RED%%ITALICS_ON%%DOUBLE_UNDERLINE_ON%No%DOUBLE_UNDERLINE_OFF%%BLINK_ON%!%BLINK_OFF%%ITALICS_OFF%)
        call print-if-debug "our_answer is '%OUR_ANSWER', default_answer is '%DEFAULT_ANSWER%', answer is '%ANSWER%', PRETTY_ANSWER is '%PRETTY_ANSWER%'"
        title %@REPLACE[%EMOJI_RED_QUESTION_MARK,,%@STRIPANSI[%@UNQUOTE[%ASK_QUESTION]? %EMDASH% %PRETTY_ANSWER%]]


REM Change "pretty" question so that the auto-question mark is no longer blinking because it has now been answered, and
REM Print our "pretty" answers in the right spots (challenging with double-height), erasing any timer leftovers:
        if %BIG_QUESTION ne 1 (
            if %WAIT_TIMER_ACTIVE eq 0 (echo %ANSI_POSITION_SAVE%%@ANSI_MOVE_LEFT[1]%PRETTY_ANSWER_ANSWERED% %@ANSI_MOVE_TO_COL[1]%PRETTY_QUESTION_ANSWERED% %PRETTY_ANSWER%)  
            if %WAIT_TIMER_ACTIVE eq 1 (echo %@ANSI_MOVE_TO_COL[1]%PRETTY_QUESTION_ANSWERED% %PRETTY_ANSWER%      ``)                                                          
        )
        if %BIG_QUESTION eq 1 (
                                          set MOVE_LEFT_BY=1
            if  %WAIT_TIMER_ACTIVE eq 1  (set MOVE_LEFT_BY=4
                if %WAIT_TIME gt 10      (set MOVE_LEFT_BY=%@eval[%MOVE_LEFT_BY + 1])
                if %WAIT_TIME gt 100     (set MOVE_LEFT_BY=%@eval[%MOVE_LEFT_BY + 1])
                if %WAIT_TIME gt 1000    (set MOVE_LEFT_BY=%@eval[%MOVE_LEFT_BY + 1])
                if %WAIT_TIME gt 10000   (set MOVE_LEFT_BY=%@eval[%MOVE_LEFT_BY + 1])
                if %WAIT_TIME gt 100000  (set MOVE_LEFT_BY=%@eval[%MOVE_LEFT_BY + 1])
                if %WAIT_TIME gt 1000000 (set MOVE_LEFT_BY=%@eval[%MOVE_LEFT_BY + 1])
                if %LEFT_MORE gt 0       (set MOVE_LEFT_BY=%@eval[%MOVE_LEFT_BY + %LEFT_MORE])
                rem LEFT_MORE is a secret kludge in case the cursor doesn't quite move to the left enough
            )
            echo %@ANSI_MOVE_LEFT[%MOVE_LEFT_BY]%ANSI_POSITION_SAVE%%BLINK_ON%%PRETTY_ANSWER%%BLINK_OFF%%ANSI_ERASE_TO_END_OF_LINE%%ANSI_POSITION_RESTORE%%@ANSI_MOVE_UP[1]%BIG_TOP%%BLINK_ON%%PRETTY_ANSWER%%BLINK_OFF%%ANSI_ERASE_TO_END_OF_LINE%%ANSI_POSITION_RESTORE%
        )


goto :END

                :Oops
                    call fatal_error "That was not a valid way to call %0 ... You need a 2nd parameter of 'yes' or 'no' to set a default_answer for when ENTER is pressed"
                 goto :END


:END
