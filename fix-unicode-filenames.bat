@Echo OFF

:REDO_BECAUSE_OF_ERRORLEVEL

    set FIXER=%BAT%\fix_unicode_filenames.py
    call validate-env-var FIXER
    %FIXER% %*
    call errorlevel "fix_unicode_filenames probably had a mapping failure"



REM Capture errorlevel and automatically rerun if we fail, automatically delete the log file if we succeed
                                          
    if %REDO_BECAUSE_OF_ERRORLEVEL eq 1 (
        call validate-env-var EDITOR FIXER
        %EDITOR% %FIXER%
        call important "About to run again..."
        pause
        goto :REDO_BECAUSE_OF_ERRORLEVEL
    ) else (
        set LOG=fix-unicode-filenames.log
        if exist %LOG% (
            %COLOR_REMOVAL%
            mv %LOG% c:\recycled\%LOG.%_DATETIME.%_PID.log
        )
    )
