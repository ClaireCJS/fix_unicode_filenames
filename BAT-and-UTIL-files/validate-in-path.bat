@echo off

:PUBLISH:
:DESCRIPTION: validates if commands are valid
:USAGE:       validate-in-path {list of commands to validate}
:EXAMPLE:     validate-in-path grep awk whatever.exe whatever.bat


rem    Complication #1: What if we are pasased an alias?   
rem                     [Solution: add isalias check]
rem    Complication #2: Windows command lines let us do commands like "dir/s" without space before the slash, 
rem                     [Solution: use regular epressions to strip things off past a slash into a clean command]
   
set OUR_LOGGING_LEVEL=None

for %command in (%*) do (
    set clean_command=%command%
    if "%@REGEXSUB[1,(.*)/(.*),%command]" ne "" (set clean_command=%@REGEXSUB[1,(.*)/(.*),%command])
    call logging "command=%command, clean_command=%clean_command"
    set search_results=%@SEARCH[%clean_command]
    if not isalias %clean_command .and. not isInternal %clean_command .and. "%search_results%" eq "" (
        call fatal_error "FATAL ERROR! %clean_command is not in your path, and needs to be."
    )
)
