@Echo OFF

:::: CONFIG:
    set    DEFAULT_SECONDS=1
    set BEEP_FREQUENCY_MIN=38
    set BEEP_FREQUENCY_MAX=9900
    set BEEP_INTERVALL_MIN=0
    set BEEP_INTERVALL_MAX=4
    set       EXITAFTER_WN=0                                                 %+ REM  A default that should probably never be changed!
    set COLOR_ALARM_ORIGINAL=%COLOR_ALARM%                                   %+ REM  Store, becuase we will be changing it.

:::: PARAMETERS:
    :201704 - this is the cause of "^C makes 4nt command line stop responding" - but it was here for a reason. ugh: setlocal
       if "%1" ne "" set SECONDS=%1
     if "%SECONDS%" eq "" set SECONDS=%DEFAULT_SECONDS%
     if %@LEN[%SECONDS%] gt 2 set SECONDS=%DEFAULT_SECONDS%                  %+ REM annoyance protection from more than 99 seconds!
        REM DEBUG: call print-if-debug [DEBUG/GOAT] white-noise %1 %2 %3 %4 %5 %6 %7 %8 %9 ...   set INTERVAL_TO_USE=%%@EVAL[%SECONDS% * 17]                           %+ REM  Is actually 18, but allowing for overhead. #GOAT
        set INTERVAL_TO_USE=%@EVAL[%SECONDS% * 17]                           %+ REM  Is actually 18, but allowing for overhead.
        if not defined INTERVAL_TO_USE set INTERVAL_TO_USE=17
            color bright red on black
                REM DEBUG: call print-if-debug `  * seconds=%SECONDS%, INTERVAL_TO_USE=%INTERVAL_TO_USE%`
            color white on black
    if "%@UPPER[%1]" eq "EXITAFTER" set EXITAFTER_WN=1
    if "%@UPPER[%2]" eq "EXITAFTER" set EXITAFTER_WN=1

:::: SETUP:
    if "%EXITAFTER_WN%" eq "1" window minimize

:::: NOISE!!:
    set INTERVAL_USED=0
    :Beep_Again
        set BEEP_INTERVALL_TEMP=%@RANDOM[%BEEP_INTERVALL_MIN%,%BEEP_INTERVALL_MAX%]
        set BEEP_FREQUENCY_TEMP=%@RANDOM[%BEEP_FREQUENCY_MIN%,%BEEP_FREQUENCY_MAX%]

        :: :::: LOGARITHMIC KLUDGE:
            if  %@RANDOM[1,10] gt 6 (set BEEP_FREQUENCY_TEMP=%@FLOOR[%@EVAL[BEEP_FREQUENCY_TEMP / 10]] %+ color bright black on black %+ REM call print-if-debug `         * log_reduce, beep_freq now %BEEP_FREQUENCY_TEMP%`)
            if  %@RANDOM[1,10] gt 9 (set BEEP_FREQUENCY_TEMP=%@FLOOR[%@EVAL[BEEP_FREQUENCY_TEMP / 10]] %+ color bright black on black %+ REM call print-if-debug `         * log_reduce, beep_freq now %BEEP_FREQUENCY_TEMP%`)
            if  %@RANDOM[1,10] gt 8 (set BEEP_FREQUENCY_TEMP=%@FLOOR[%@EVAL[BEEP_FREQUENCY_TEMP / 10]] %+ color bright black on black %+ REM call print-if-debug `         * log_reduce, beep_freq now %BEEP_FREQUENCY_TEMP%`)
:           if  %@RANDOM[1,10] gt 5 (set BEEP_FREQUENCY_TEMP=%@FLOOR[%@EVAL[BEEP_FREQUENCY_TEMP / 10]] %+ color bright black on black %+ REM call print-if-debug `         * log_reduce, beep_freq now %BEEP_FREQUENCY_TEMP%`)
            if %BEEP_FREQUENCY_TEMP% lt %BEEP_FREQUENCY_MIN% set BEEP_FREQUENCY_TEMP=%@EVAL[BEEP_FREQUENCY_MIN +  %@RANDOM[0,20]]

        set INTERVAL_USED=%@EVAL[INTERVAL_USED + BEEP_INTERVALL_TEMP]
                color red on black
                    REM DEBUG: echo call print-if-debug `   * temp-interval=%BEEP_INTERVALL_TEMP%, INTERVAL_USED=%INTERVAL_USED%, temp-freq = %BEEP_FREQUENCY_TEMP%`
                color white on black

        if %BEEP_INTERVALL_TEMP% == 0 delay /m 55                          %+ REM 55ms = 1/18th second = interval of 1
        if %BEEP_INTERVALL_TEMP% eq 0 goto :Silence
            SET FG=%@RANDOM[0,15] 
            :ReBG
            SET BG=%@RANDOM[0,15]
            if "%BG%" eq "%FG%" goto :ReBG
            set COLOR_ALARM=color %FG% on %BG%
            REM DEBUG: echo call beep.bat %BEEP_FREQUENCY_TEMP% %BEEP_INTERVALL_TEMP%
            set COLOR_ALARM=%COLOR_ALARM_ORIGINAL%
        :Silence
    if %INTERVAL_USED% gt %INTERVAL_TO_USE% goto :Beeping_Done
                                            goto :Beep_Again
    :Beeping_Done

:::: CLEANUP:
    if "%SLEEPING%"     eq "1" (echo.           )
    if "%EXITAFTER_WN%" eq "1" (echo (no longer: endlocal) %+ exit)
    :201704 - this is the cause of "^C makes 4nt command line stop responding" - but it was here for a reason. ugh: endlocal
