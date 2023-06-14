@echo off

if "%ESCAPE_CHARACTER%" eq "TILDE" goto :AlreadySetThisWay

    setdos /c~
    set ESCAPE_CHARACTER=TILDE

:AlreadySetThisWay


REM don't use our messaging bat files here because it creates a circular dependency
if "%1" ne "silent" (
    %COLOR_IMPORTANT_LESS% 
    echos You can now use the carrot key for things other than character escaping, ``
    color bright yellow on black
    echos but tilde is the temporary escape character now! 
    %COLOR_NORMAL%
    echo.
)

:END
%COLOR_NORMAL%

