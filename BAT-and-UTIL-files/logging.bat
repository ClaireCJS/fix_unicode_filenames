@Echo OFF

:PUBLISH:
:DESCRIPTION:  Sends a message at the appropriate messaging level, which we refer to as a logging level in this context
:DESCRIPTION:  
:DESCRIPTION:  Great for inserting a bunch of debug information into a script, then later setting LOGGING_LEVEL=None to turn them all off simultaneously.
:USAGE:        set  LOGGING_LEVEL={valid logging level, including None}
:USAGE:        call logging "message"
:EXAMPLE:      set  LOGGING_LEVEL=debug
:EXAMPLE:      call logging "Our debug value for result is '%RESULT%'"
:REQUIRES:     my messaging system
:DEPENDENCIES: print-message.bat (and associated BATs)


rem CONFIGURATION
        set DEFAULT_LOGGING_LEVEL=important


rem DETERMINE LOGGING LEVEL
        REM sometimes we screw up and set LOGGING instead of LOGGING_LEVEL.  Let's try to work with that a bit.
                if not defined LOGGING_LEVEL .and. defined LOGGING (set LOGGING_LEVEL=%LOGGING%)
                if not defined LOGGING_LEVEL (
                    call warning "Logging level was never set. Setting to '%DEFAULT_LOGGING_LEVEL%'"
                    set LOGGING_LEVEL=%DEFAULT_LOGGING_LEVEL%
                )


rem CHECK VALIDITY OF LOGGING LEVEL, OR IF WE DO NOT HAVE A SCRIPT TO LOG AT THAT LEVLE YET:
        call validate-environment-variable BAT
        set LOGGER_SCRIPT=%BAT%\%LOGGING_LEVEL%.bat
        if not exist %LOGGER_SCRIPT% (call error "Sorry, '%LOGGER_SCRIPT%' does not exist, so either '%LOGGING_LEVEL%' is not a valid LOGGING_LEVEL, or you need to create %LOGGER_SCRIPT% by copying another messaging script such as important.bat or debug.bat")


rem IF LOGGING LEVEL IS DEBUG, SET OUR DEBUG FLAG - this will turn on other "if %DEBUG%" statements that we can convert to our new messaging system
        if "%LOGGING_LEVEL%" eq "debug" (if not defined DEBUG .or. %DEBUG eq 0 set DEBUG=1)

rem ATUALLY DO THE LOGGING
        %LOGGER_SCRIPT% %*
        REM call debug "%0 run with level of '%LOGGING_LEVEL%', LOGGER_SCRIPT='%LOGGER_SCRIPT%'"

