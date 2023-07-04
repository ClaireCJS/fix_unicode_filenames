@echo off

::::: USAGE:
    :: call validate-environment-variable VARNAME_NO_PERCENT "some error message" or "skip_validation_existence"
    ::      where option can be:
    ::                           "skip_validation_existence" to skip existence validation
    ::                           "some error message"        to be additional information provided to user if there is an error

::::: GET PARAMETERS:
    set  VARNAME=%1                                                                           %+ if %DEBUG_VALIDATE_ENV_VAR% eq 1 echo %DEBUGPREFIX% if defined %VARNAME% goto :Defined_YES

::::: CLEAR LONGTERM ERROR FLAGS:
    set DEBUG_VALIDATE_ENV_VAR=0
    set DEBUG_NORMALIZE_MESSAGE=0

::::: CLEAR LONGTERM ERROR FLAGS:
    set ENVIRONMENT_VALIDATION_FAILED=0
    set ENVIRONMENT_VALIDATION_FAILED_NAME=
    set ENVIRONMENT_VALIDATION_FAILED_VALUE=
    set DEBUGPREFIX=- {validate-environment-variable} * ``
    set USER_MESSAGE=%2$
    set PARAM2=%2
    set PARAM3=%3


::::: VALIDATE PARAMETERS STRICTLY
    if "%PARAM3%" ne "" (
        color bright white on red
        echo  We can't be passing a third parameter to validate-environment-variable. Did you mean validate-environment-varaibles %*? 
        color white on black
        beep
        beep
        beep
        beep
        *pause
        *pause
        *pause
        *pause
        *pause
        *pause
        *pause
        *pause
        *pause
        *pause
        *pause
        *pause
        *pause
        *pause
        *pause
        *pause
        *pause
        *pause
        *pause
        *pause
        *pause
        *pause
        *pause
        *pause
        *pause
        goto :END
    )

    if "%PARAM2%" eq "skip_validation_existence" .or. "%PARAM2%" eq "skip_existence_validation" .or. "%PARAM2%" eq "skip_validation" (
        set SKIP_VALIDATION_EXISTENCE=1 
        set USER_MESSAGE=%3$
    ) else (
        set SKIP_VALIDATION_EXISTENCE=0
    )
    if %DEBUG_NORMALIZE_MESSAGE eq 1 (%COLOR_DEBUG% %+ echo - DEBUG: PARAM2: '%PARAM2%')

::::: SEE IF IT IS DEFINED:
    :Only_1_Arg
    if defined %VARNAME% goto :Defined_YES
    if ""  eq  %VARNAME% goto :Defined_NO

            ::::: REPOND IF IT IS NOT:
                :Defined_NO
                    set ERROR=1
                    set ERROR_MESSAGE=*** Environment variable %1 is not defined, and needs to be!!! ***
                    if %DEBUG_NORMALIZE_MESSAGE eq 1 (%COLOR_DEBUG% %+ echo - DEBUG: ERROR_MESSAGE[1]: %ERROR_MESSAGE% [length_diff=%LENGTH_DIFF%] [errlen=%ERROR_LENGTH,userlen=%USER_LENGTH])
                    if %DEBUG_NORMALIZE_MESSAGE eq 1 (%COLOR_DEBUG% %+ echo - DEBUG: `%`USER_MESSAGE`%` is '%USER_MESSAGE%')
                    if "%USER_MESSAGE%" ne "" (
                        REM Normalize width of ERROR_MESSAGE to be same width as USER_MESSAGE
                        if DEBUG_NORMALIZE_MESSAGE eq 1 (%COLOR_DEBUG% %+ echo - DEBUG: User message found)

                        rem Get the length of both variables
                        set "ERROR_LENGTH=%@LEN[%ERROR_MESSAGE]"
                        set  "USER_LENGTH=%@LEN[%USER_MESSAGE%]"

                        rem Calculate the difference in length
                        set /a "LENGTH_DIFF=!USER_LENGTH! - !ERROR_LENGTH!"

                        REM for /L %%i in (1,1,%LENGTH_DIFF%) do (set EXCLAMATION_MARKS=%EXCLAMATION_MARKS%!)
                        REM 
                        REM rem Substitute the final sequence of exclamation marks in ERROR_MESSAGE
                        REM if DEBUG_NORMALIZE_MESSAGE eq 1 (%COLOR_DEBUG% %+ echo - DEBUG: EXCLAMATION_MARKS is '%EXCLAMATION_MARKS%')
                        REM set NORMALIZED_ERROR_MESSAGE=%@REPLACE[!!!,%EXCLAMATION_MARKS%,%ERROR_MESSAGE%]

                        if %LENGTH_DIFF% lss 0 (
                            set /a "LENGTH_DIFF=-%LENGTH_DIFF% / 2"
                        )
                        if %LENGTH_DIFF% lss 0 (
                            rem If USER_MESSAGE is longer
                            for /L %%i in (1,1,%LENGTH_DIFF%)   do   (set "ERROR_MESSAGE=*%ERROR_MESSAGE%*")
                            if          %@MOD,[%LENGTH_DIFF%,2] == 0 (set "ERROR_MESSAGE=%ERROR_MESSAGE%*" )
                        ) else (
                            rem If ERROR_MESSAGE is longer
                            for /L %%i in (1,1,%LENGTH_DIFF%)   do   (set "USER_MESSAGE=*%USER_MESSAGE%*")
                            if            %MOD[%LENGTH_DIFF%,2] == 0 (set "USER_MESSAGE=%USER_MESSAGE%*" )
                        )

                        rem Output the updated ERROR_MESSAGE
                        set ERROR_MESSAGE=%NORMALIZED_ERROR_MESSAGE%
                    )
                    if %DEBUG_NORMALIZE_MESSAGE eq 1 (%COLOR_DEBUG% %+ echo ERROR_MESSAGE[2]: %ERROR_MESSAGE% [length_diff=%LENGTH_DIFF%] [errlen=%ERROR_LENGTH,userlen=%USER_LENGTH])
                    %COLOR_ALARM%       
                    echos %ERROR_MESSAGE% 
                    %COLOR_NORMAL% 
                    echo.
                    if "%USER_MESSAGE%" ne "" (
                        REM Although this is technically advice, we 
                        REM are coloring it warning-style because 
                        REM advice related to an error in this context
                        REM pretty much *DOES* mean a warning in the 
                        REM outer context of our calling script, and 
                        REM that level of importance shoudln't be as 
                        REM easily visually discarded as the advice 
                        REM color might usually be, because it's more
                        REM important than simply advice -- 
                        REM      -- it represents a system failure!!!
                        REM ...so let's put asterisks around it, too!
                        %COLOR_WARNING% 

                        echos *** %@UNQUOTE[%USER_MESSAGE%] *** 

                        %COLOR_NORMAL% 
                        echo. 
                    )
                        
                    %COLOR_ALARM%           %+ echos %ERROR_MESSAGE% %+ %COLOR_NORMAL% %+ echo.
                    REM call alarm-beep     %+ REM was too annoying for the severity of the corresponding situations
                    call white-noise 1      %+ REM reduced to 2 seconds, then after a year or few, reduced to 1 second
                    %COLOR_PROMPT% %+ pause %+ %COLOR_NORMAL%
                    %COLOR_PROMPT% %+ pause %+ %COLOR_NORMAL%
                    %COLOR_PROMPT% %+ pause %+ %COLOR_NORMAL%
                    %COLOR_PROMPT% %+ pause %+ %COLOR_NORMAL%
                    %COLOR_PROMPT% %+ pause %+ %COLOR_NORMAL%

                                 call exit-maybe

                    %COLOR_PROMPT% %+ pause %+ %COLOR_NORMAL%
                    %COLOR_PROMPT% %+ pause %+ %COLOR_NORMAL%
                    %COLOR_PROMPT% %+ pause %+ %COLOR_NORMAL%
                    %COLOR_PROMPT% %+ pause %+ %COLOR_NORMAL%
                    %COLOR_PROMPT% %+ pause %+ %COLOR_NORMAL%
                goto :END

::::: ADDITIONALLY, VALIDATE THAT IT EXISTS, IF IT SEEMS TO BE POINTING TO A FOLDER/FILE:
    :Defined_YES
    set VARVALUE=%[%VARNAME%]                        %+ if %DEBUG_VALIDATE_ENV_VAR% eq 1 (echo %DEBUGPREFIX%VARVALUE is %VARVALUE%)
    set VARVALUEDRIVE=%@INSTR[0,1,%VARVALUE%])       %+ set IS_FILE_LOCATION=0
    call   car>nul                                                                               %+ rem //Turn off the carat command-line separator so we can use it in regular expressions
    if "1" eq "%@REGEX[^.?[A-Z]:,%@UPPER[%VARVALUE%]]" (set IS_FILE_LOCATION=1)
    REM ON WINDOWS 10 AS OF 20220126 THIS CREATES PROBLEMS: call print-if-debug %DEBUGPREFIX%REGEXTEXT IS "%@REGEX[^[A-Z]:,%@UPPER[%VARVALUE%]]"
    call nocar>nul                                                                               %+ rem //Turn on  the carat command-line separator so we can use it in our normal fasion
    if  "0" eq "%IS_FILE_LOCATION%"         (goto :DontValidateIfExists)
    if  "0" eq "%@READY[%VARVALUEDRIVE%]"   (goto :DontValidateIfExists)                         %+ rem //Don't look for if drive letter doesn't exist--it's SLOWWWWW
    if   1  eq  %SKIP_VALIDATION_EXISTENCE% (goto :DontValidateIfExists)                         %+ rem //Don't look for if we want to validate the variable only
    if exist "%VARVALUE%"                   (                         goto :ItExistsAfterall)    %+ rem //Does it exist as a file?
    if isdir "%VARVALUE%"                   (                         goto :ItExistsAfterall)    %+ rem //Does it exist as a folder?
    if exist "%VARVALUE%.dep"               (gosub :ItIsDeprecated %+ goto :ItExistsAfterall)    %+ rem //Internal kludge for the way I do workflows
    if isdir "%VARVALUE%.dep"               (gosub :ItIsDeprecated %+ goto :ItExistsAfterall)    %+ rem //Internal kludge for the way I do workflows
    if exist "%VARVALUE%.deprecated"        (gosub :ItIsDeprecated %+ goto :ItExistsAfterall)    %+ rem //Internal kludge for the way I do workflows
    if isdir "%VARVALUE%.deprecated"        (gosub :ItIsDeprecated %+ goto :ItExistsAfterall)    %+ rem //Internal kludge for the way I do workflows

    ::::: SET ERROR FLAGS (store error specifics for debugging analysis):
        set ERROR=1
        set ERROR_ENVIRONMENT_VALIDATION_FAILED=1
        SET ERROR_ENVIRONMENT_VALIDATION_FAILED_NAME=%VARNAME%
        SET ERROR_ENVIRONMENT_VALIDATION_FAILED_VALUE=%VARNVALUE%
    ::::: LET USER KNOW OF ERROR:
        REM without messaging system
            REM %COLOR_ALARM%   %+ echos * Environment variable %@UPPER[%VARNAME%] appears to be a file location that does not exist: %VARVALUE%
            REM %COLOR_NORMAL%  %+ echo. %+ call white-noise 1
            REM %COLOR_SUBTLE%  %+ *pause
            REM %COLOR_NORMAL%
        REM with messaging system
            call fatalerror "Environment variable '%@UPPER[%VARNAME%]' appears to be a file location that does not exist: '%VARVALUE%'"


:::::::::::::::::::::::::::::::::::::::::::::::::::::::
goto :Past_The_End_Of_The_Sub-Routines
        ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        :ItIsDeprecated
            rem //Internal kludge for the way I do workflows.
            rem //WHICH IS: If "a.dep" or "a.deprecated" then I consider "a" to exist even if it doesn't. Don't ask.
            rem //When this happens, we display notification, with a custom sound effect,
            rem //but in a pleasant color, and less harsh sound effect, because this isn't an error,
            rem //just something that we want to pay extra attention to vs business-as-usual.

            echo. %+ echo. %+ echo.
            %COLOR_ADVICE%
                echo * Environment variable %@UPPER[%VARNAME%] points deprecated file:
                echo            "%VARVALUE%"
            %COLOR_NORMAL%

            beep 73 3
            beep 73 2                  %+ REM //Our custom sound
            beep 73 1
            *pause
        return
        ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:Past_The_End_Of_The_Sub-Routines
:::::::::::::::::::::::::::::::::::::::::::::::::::::::

:ItExistsAfterall
:DontValidateIfExists
:END
