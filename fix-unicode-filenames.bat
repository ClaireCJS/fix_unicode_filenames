@Echo Off

if "%1" eq "delete_log" (goto :Delete_Log)

:REDO_BECAUSE_OF_ERRORLEVEL
    set FIXER=%BAT%\fix_unicode_filenames.py
        if "%fix_unicode_filenames_env_validated" == "1" (goto :validated_env_already)
            call validate-env-var FIXER
            set fix_unicode_filenames_env_validated=1
        :validated_env_already
    %FIXER% %*
    call errorlevel "fix_unicode_filenames probably had a mapping failure"



REM Capture errorlevel and automatically rerun if we fail, automatically delete the log file if we succeed
                                          
    if %REDO_BECAUSE_OF_ERRORLEVEL eq 1 (
        call validate-env-var EDITOR FIXER
        %EDITOR% %FIXER%
        call important "About to run again..."
        pause
        goto :REDO_BECAUSE_OF_ERRORLEVEL
    ) 
    
    
    :Delete_Log
    set LOG=fix-unicode-filenames.log
    if not exist %LOG% (goto :NoLog)
        %COLOR_REMOVAL%
        echos %FAINT_ON%%OVERSTRIKE_ON%
        set MOVE_DECORATOR=%ANSI_COLOR_SUBTLE%%FAINT_ON%%OVERSTRIKE_ON%%ITALICS%
        mv %LOG% c:\recycled\%LOG.%_DATETIME.%_PID.log
        echos %FAINT_OFF%%OVERSTRIKE_OFF%
    :NoLog

:End
