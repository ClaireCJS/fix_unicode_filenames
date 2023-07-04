@Echo Off

:PUBLISH:
:DESCRIPTION: Creates a set of environment variables that can be used for messaging improvement
:USAGE: call set-colors [test] - can add 'test' parameter to echo a test string
:EFFECTS: sets %COLOR_{messagety[e} variables for all the message types we intend to have
:RELATED: redefine-the-colorblack-randomly.bat (gives each command-line window a slightly different shade of black to make window edges easier to see)
:USED-BY:


REM  unexplored: Set text colour to index n in a 256-colour palette (e.g. \x1b[38;5;34m)
REM  unexplored: is \x1b[?25h and \x1b[?25l. These show and hide the cursor, respectively.
REM  unexplored: 
REM  unexplored: 
REM  unexplored: 
REM  unexplored: 
REM  unexplored: 
REM  unexplored: 
REM  unexplored: 
REM  unexplored: 
REM  unexplored: 


if "%1" eq "force" goto :Force
if %COLORS_HAVE_BEEN_SET eq 1 (goto :AlreadyDone)
:Force

REM colors for ANSI
        rem refactor annoying left bracket
            set ESCAPE=%@CHAR[27]
            set ANSI_ESCAPE=%@CHAR[27][
            set ANSI_RESET=%ANSI_ESCAPE%0m
        rem Foreground Colors
            set ANSI_BLACK=%ANSI_ESCAPE%30m
            set ANSI_RED=%ANSI_ESCAPE%31m
            set ANSI_GREEN=%ANSI_ESCAPE%32m
            set ANSI_YELLOW=%ANSI_ESCAPE%33m
            set ANSI_BLUE=%ANSI_ESCAPE%34m
            set ANSI_MAGENTA=%ANSI_ESCAPE%35m
            set ANSI_CYAN=%ANSI_ESCAPE%36m
            set ANSI_WHITE=%ANSI_ESCAPE%37m
            set ANSI_GRAY=%ANSI_ESCAPE%90m
            set ANSI_GREY=%ANSI_ESCAPE%90m
            set ANSI_BRIGHT_RED=%ANSI_ESCAPE%91m
            set ANSI_BRIGHT_GREEN=%ANSI_ESCAPE%92m
            set ANSI_BRIGHT_YELLOW=%ANSI_ESCAPE%93m
            set ANSI_BRIGHT_BLUE=%ANSI_ESCAPE%94m
            set ANSI_BRIGHT_MAGENTA=%ANSI_ESCAPE%95m
            set ANSI_BRIGHT_CYAN=%ANSI_ESCAPE%96m
            set ANSI_BRIGHT_WHITE=%ANSI_ESCAPE%97m
        rem Background Colors
            set ANSI_BACKGROUND_BLACK=%ANSI_ESCAPE%40m
            set ANSI_BACKGROUND_RED=%ANSI_ESCAPE%41m
            set ANSI_BACKGROUND_GREEN=%ANSI_ESCAPE%42m
            set ANSI_BACKGROUND_YELLOW=%ANSI_ESCAPE%43m
            set ANSI_BACKGROUND_BLUE=%ANSI_ESCAPE%44m
            set ANSI_BACKGROUND_MAGENTA=%ANSI_ESCAPE%45m
            set ANSI_BACKGROUND_CYAN=%ANSI_ESCAPE%46m
            set ANSI_BACKGROUND_WHITE=%ANSI_ESCAPE%47m
            set ANSI_BACKGROUND_GREY=%ANSI_ESCAPE%100m
            set ANSI_BACKGROUND_GRAY=%ANSI_ESCAPE%100m
            set ANSI_BACKGROUND_BRIGHT_RED=%ANSI_ESCAPE%101m
            set ANSI_BACKGROUND_BRIGHT_GREEN=%ANSI_ESCAPE%102m
            set ANSI_BACKGROUND_BRIGHT_YELLOW=%ANSI_ESCAPE%103m
            set ANSI_BACKGROUND_BRIGHT_BLUE=%ANSI_ESCAPE%104m
            set ANSI_BACKGROUND_BRIGHT_MAGENTA=%ANSI_ESCAPE%105m
            set ANSI_BACKGROUND_BRIGHT_CYAN=%ANSI_ESCAPE%106m
            set ANSI_BACKGROUND_BRIGHT_WHITE=%ANSI_ESCAPE%107m


REM As of Windows Terminal we can now actually display italic characters
            REM 0m=reset, 1m=bold, 2m=faint, 3m=italic, 4m=underline, 5m=blink slow, 6m=blink fast, 7m=reverse, 8m=conceal, 9m=strikethrough
            set ANSI_BOLD=%ANSI_ESCAPE%1m
            set ANSI_BOLD_ON=%ANSI_BOLD%
            set ANSI_BOLD_OFF=%ANSI_ESCAPE%22m
            set BOLD_ON=%ANSI_BOLD_ON%
            set BOLD_OFF=%ANSI_BOLD_OFF%
            set BOLD=%BOLD_ON%

            set ANSI_FAINT=%ANSI_ESCAPE%2m
            set ANSI_FAINT_ON=%ANSI_FAINT%
            set ANSI_FAINT_OFF=%ANSI_ESCAPE%22m
            set FAINT_ON=%ANSI_FAINT_ON%
            set FAINT_OFF=%ANSI_FAINT_OFF%
            set FAINT=%FAINT_ON%

            set ANSI_ITALICS=%ANSI_ESCAPE%3m
            set ANSI_ITALICS_ON=%ANSI_ITALICS%
            set ANSI_ITALICS_OFF=%ANSI_ESCAPE%23m
            set ITALICS_ON=%ANSI_ITALICS_ON%
            set ITALICS_OFF=%ANSI_ITALICS_OFF%
            set ITALICS=%ITALICS_ON%

            set ANSI_UNDERLINE=%ANSI_ESCAPE%4m
            set ANSI_UNDERLINE_ON=%ANSI_UNDERLINE%
            set ANSI_UNDERLINE_OFF=%ANSI_ESCAPE%24m
            set UNDERLINE_ON=%ANSI_UNDERLINE_ON%
            set UNDERLINE_OFF=%ANSI_UNDERLINE_OFF%
            set UNDERLINE=%UNDERLINE_ON%

            set ANSI_OVERLINE=%ANSI_ESCAPE%53m
            set ANSI_OVERLINE_ON=%ANSI_OVERLINE%
            set ANSI_OVERLINE_OFF=%ANSI_ESCAPE%55m
            set OVERLINE_ON=%ANSI_OVERLINE_ON%
            set OVERLINE_OFF=%ANSI_OVERLINE_OFF%
            set OVERLINE=%OVERLINE_ON%

            set ANSI_DOUBLE_UNDERLINE=%ANSI_ESCAPE%21m
            set ANSI_DOUBLE_UNDERLINE_ON=%ANSI_DOUBLE_UNDERLINE%
            set ANSI_DOUBLE_UNDERLINE_OFF=%ANSI_ESCAPE%24m
            set DOUBLE_UNDERLINE_ON=%ANSI_DOUBLE_UNDERLINE_ON%
            set DOUBLE_UNDERLINE_OFF=%ANSI_DOUBLE_UNDERLINE_OFF%
            set DOUBLE_UNDERLINE=%DOUBLE_UNDERLINE_ON%

                set ANSI_UNDERLINE_DOUBLE=%ANSI_DOUBLE_UNDERLINE%
                set ANSI_UNDERLINE_DOUBLE_ON=%ANSI_DOUBLE_UNDERLINE_ON%
                set ANSI_UNDERLINE_DOUBLE_OFF=%ANSI_DOUBLE_UNDERLINE_OFF%
                set UNDERLINE_DOUBLE_ON=%DOUBLE_UNDERLINE_ON%
                set UNDERLINE_DOUBLE_OFF=%DOUBLE_UNDERLINE_OFF%
                set UNDERLINE_DOUBLE=%DOUBLE_UNDERLINE%


            set ANSI_BLINK_SLOW=%ANSI_ESCAPE%5m
            set ANSI_BLINK_SLOW_ON=%ANSI_BLINK_SLOW%
            set ANSI_BLINK_SLOW_OFF=%ANSI_ESCAPE%25m
            set BLINK_SLOW_ON=%ANSI_BLINK_SLOW_ON%
            set BLINK_SLOW_OFF=%ANSI_BLINK_SLOW_OFF%
            set BLINK_SLOW=%BLINK_SLOW_ON%

            set ANSI_BLINK_FAST=%ANSI_ESCAPE%6m
            set ANSI_BLINK_FAST_ON=%ANSI_BLINK_FAST%
            set ANSI_BLINK_FAST_OFF=%ANSI_ESCAPE%25m
            set BLINK_FAST_ON=%ANSI_BLINK_FAST_ON%
            set BLINK_FAST_OFF=%ANSI_BLINK_FAST_OFF%
            set BLINK_FAST=%BLINK_FAST_ON%

            set ANSI_BLINK=%ANSI_BLINK_FAST%
            set ANSI_BLINK_ON=%ANSI_BLINK_FAST_ON%
            set ANSI_BLINK_OFF=%ANSI_BLINK_FAST_OFF%
            set BLINK_ON=%ANSI_BLINK_ON%
            set BLINK_OFF=%ANSI_BLINK_OFF%
            set BLINK=%BLINK_ON%

            set ANSI_REVERSE=%ANSI_ESCAPE%7m
            set ANSI_REVERSE_ON=%ANSI_REVERSE%
            set ANSI_REVERSE_OFF=%ANSI_ESCAPE%27m
            set REVERSE_ON=%ANSI_REVERSE_ON%
            set REVERSE_OFF=%ANSI_REVERSE_OFF%
            set REVERSE=%REVERSE_ON%

            set ANSI_CONCEAL=%ANSI_ESCAPE%8m
            set ANSI_CONCEAL_ON=%ANSI_CONCEAL%
            set ANSI_CONCEAL_OFF=%ANSI_ESCAPE%28m
            set CONCEAL_ON=%ANSI_CONCEAL_ON%
            set CONCEAL_OFF=%ANSI_CONCEAL_OFF%
            set CONCEAL=%CONCEAL_ON%

            set ANSI_STRIKETHROUGH=%ANSI_ESCAPE%9m
            set ANSI_STRIKETHROUGH_ON=%ANSI_STRIKETHROUGH%
            set ANSI_STRIKETHROUGH_OFF=%ANSI_ESCAPE%29m
            set STRIKETHROUGH_ON=%ANSI_STRIKETHROUGH_ON%
            set STRIKETHROUGH_OFF=%ANSI_STRIKETHROUGH_OFF%
            set STRIKETHROUGH=%STRIKETHROUGH_ON%


REM wow it even supports the vt100 2-line-tall text!
            set BIG_TEXT_LINE_1=%ESCAPE%#3
            set BIG_TEXT_LINE_2=%ESCAPE%#4
            set BIG_TOP=%BIG_TEXT_LINE_1%
            set BIG_TOP_ON=%BIG_TOP%
            set BIG_BOT=%BIG_TEXT_LINE_2%
            set BIG_BOT_ON=%BIG_BOT%
            set BIG_BOTTOM=%BIG_BOT%
            set BIG_BOTTOM_ON=%BIG_BOTTOM%
            REM this is a guess:
            set BIG_TEXT_END=%ESCAPE%#0
            set BIG_OFF=%BIG_TEXT_END%
            set BIG_TOP_OFF=%BIG_OFF%
            set BIG_BOT_OFF=%BIG_OFF%


REM test strings that demonstrate all this ANSI functionality
        set ANSI_TEST_STRING=concealed:'%CONCEAL%conceal%CONCEAL_off%' %ANSI_RED%R%ANSI_ORANGE%O%ANSI_YELLOW%Y%ANSI_GREEN%G%ANSI_CYAN%C%ANSI_BLUE%B%ANSI_MAGENTA%V%ANSI_WHITE% Hello, world. %BOLD%Bold!%BOLD_OFF% %FAINT%Faint%FAINT_OFF% %ITALICS%Italics%ITALIC_OFF% %UNDERLINE%underline%UNDERLINE_OFF% %OVERLINE%overline%OVERLINE_OFF% %DOUBLE_UNDERLINE%double_underline%DOUBLE_UNDERLINE_OFF% %REVERSE%reverse%REVERSE_OFF% %BLINK_SLOW%blink_slow%BLINK_SLOW_OFF% [non-blinking] %BLINK_FAST%blink_fast%BLINK_FAST_OFF% [non-blinking] %blink%blink_default%blink_off% [non-blinking] %STRIKETHROUGH%strikethrough%STRIKETHROUGH_OFF% 
        set ANSI_TEST_STRING_2=%BIG_TEXT_LINE_1%big% %ANSI_RESET% Normal One
        set ANSI_TEST_STRING_3=%BIG_TEXT_LINE_2%big% %ANSI_RESET% Normal Two


REM colors for our messaging system
        set COLOR_ADVICE=        color bright magenta on        black
        SET COLOR_ALARM=         color bright white   on        red    %+ set COLOR_ALARM_ANSI=1;41;37 %+ set COLOR_ERROR=%COLOR_ALARM% %+ set COLOR_FATAL_ERROR=%COLOR_ERROR% %+ set COLOR_ERROR_FATAL=%COLOR_FATAL_ERROR%
        SET COLOR_COMPLETION=    color bright white   on        green  %+ set COLOR_CELEBRATION=%COLOR_COMPLETION%
        SET COLOR_DEBUG=         color        green   on        black
        SET COLOR_IMPORTANT=     color bright cyan    on        black
        SET COLOR_IMPORTANT_LESS=color        cyan    on        black  %+ set COLOR_LESS_IMPORTANT=%COLOR_IMPORTANT_LESS%
        :ET COLOR_INPUT=         color bright white   on        black  %+ rem  had this set from inception til 2023
        SET COLOR_GREP=          color bright yellow  on        green
        :ET COLOR_LOGGING=       color bright blue    on        black  %+ rem  For logging temp filenames to screen, etc.
        SET COLOR_LOGGING=       COLOR        cyan    on        red    %+ rem  For logging temp filenames to screen, etc.
        SET COLOR_NORMAL=        color        white   on        black
        SET COLOR_PAUSE=         color        cyan    on        black
        :ET COLOR_PROMPT=        color        yellow  on        black  %+ rem tried changing to bright red on 20230605
        SET COLOR_PROMPT=        color bright red     on        black
        set COLOR_REMOVAL=       color bright red     on        black
        SET COLOR_RUN=           color        yellow  on        black
        SET COLOR_SUCCESS=       color bright green   on        black
        SET COLOR_SUBTLE=        color bright black   on        black
        SET COLOR_UNIMPORTANT=   color        blue    on        black
        :ET COLOR_WARNING=       color bright yellow  on        black  %+ rem from inception 'til 20230529
        SET COLOR_WARNING=       color bright yellow  on        blue   %+ rem 20230529-
        :ET COLOR_WARNING_LESS=  color        yellow  on        black  %+ set COLOR_WARNING_SOFT=%COLOR_WARNING_LESS% %+ REM inception-20230605
        SET COLOR_WARNING_LESS=  color bright yellow  on        black  %+ set COLOR_WARNING_SOFT=%COLOR_WARNING_LESS% %+ REM 2030606-

rem colors for GREP:
        set GREP_COLOR_NORMAL=mt=1;33;42           %+  set GREP_COLOR_HILITE=%COLOR_ALARM_ANSI%   %+ set GREP_COLOR=%GREP_COLOR_NORMAL%         
        set GREP_COLORS_NORMAL=fn=1;33:ln=1;36;44  %+  set GREP_COLORS_HILITE=fn=1;34:ln=1;37;44  %+ 
        set GREP_COLORS_NORMAL=fn=1;33:ln=1;36;44  %+  set GREP_COLORS_HILITE=fn=1;34:ln=1;37;44  %+ 
        set GREP_COLORS=%GREP_COLOR_NORMAL%
        :SET LC-ALL=C
        :^^^^^^^^^^^ LC-ALL=C actually gives an 86% speed grep increase [as of 2015ish on computer Thailog] at the expense of not being able to grep 2-byte-per-char type unicode files but in 20230504 it was decided unicode files are more common and our new computer is faster so this isn't worth it

set COLORS_HAVE_BEEN_SET=1
:AlreadyDone

if "%1" eq "test" (
    echo %ANSI_TEST_STRING%
    echo %ANSI_TEST_STRING_2%
    echo %ANSI_TEST_STRING_3%
)
