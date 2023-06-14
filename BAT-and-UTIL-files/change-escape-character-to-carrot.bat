@Echo off




if "%ESCAPE_CHARACTER%" eq "CARET" goto :AlreadySetThisWay


:   setdos /c%=^   %+ REM Don't want "^" to be the last character of the line because in bug situations where it is erroneously the command separator, having it be the last character of the line will cause the next line to be a continuation of this line, resulting in weird buggy output
    setdos /c^     %+ REM but the above will fail if the escape character has been undefined, so we should do this too
    set ESCAPE_CHARACTER=CARET

if "%1" ne "silent" (
    %COLOR_UNIMPORTANT% 
    echo You now must use the carrot key for character escaping only.
    %COLOR_NORMAL%
)

:AlreadySetThisWay










