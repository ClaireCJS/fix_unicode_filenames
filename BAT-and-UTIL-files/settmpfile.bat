:: 201506 trying to get a handle of this tmp bullshit, 
:: so i'm removing this as it came from settmp.bat: call settemp.bat %*

call validate-environment-variables TEMP KNOWN_NAME

:: components of our temp filename:
    SET TMPFILE_DIR=%TEMP%
    SET TMPFILE_FILE=%_DATETIME.%KNOWN_NAME%.%_PID.%@NAME[%@UNIQUE[%TEMP]]
    :: aliases:
        SET TMPFILE_PRE=%TMPFILE_DIR%
        SET TMPFILE_LEFT=%TMPFILE_DIR%
        SET TMPFILE_POST=%TMPFILE_FILE%
        SET TMPFILE_RIGHT=%TMPFILE_FILE%

:: the actual, full tmpfile:
    SET TMPFILE=%TMPFILE_DIR%\%TMPFILE_FILE%               %+ call print-if-debug * TMPFILE is %TMPFILE%
