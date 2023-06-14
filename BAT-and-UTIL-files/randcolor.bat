@Echo OFF
set FGOLD=%_FG
set BGOLD=%_BG
:ReBG
    SET FG=%@RANDOM[0,15]                           
    SET BG=%@RANDOM[0,15]  
if "%BG%" eq "%BGOLD%" .and. "%FG%" eq "%FGOLD%" goto :ReBG
if "%BG%" eq "%FG%"                              goto :ReBG

set LAST_COLOR_RANDCOLOR=color %FG% on %BG%
   %LAST_COLOR_RANDCOLOR%

