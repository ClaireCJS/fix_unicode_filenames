@Echo OFF
   
    REM gentle failure because this ends up being distributed sometimes simply because i call it personally and it would be an error to call something not distributed

    pushd
            set DIR=%UTIL\ColorTool   %+   if isdir %DIR%  (%DIR%\   )
            set TOOL=ColorTool.exe    %+   if exist %TOOL% (%TOOL% %*)
    popd

