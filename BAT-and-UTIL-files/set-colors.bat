@Echo Off

:PUBLISH:
:DESCRIPTION: Creates a set of environment variables that can be used for messaging improvement
:USAGE: call set-colors [test] - can add 'test' parameter to echo a test string
:EFFECTS: sets %COLOR_{messagety[e} variables for all the message types we intend to have
:RELATED: redefine-the-colorblack-randomly.bat (gives each command-line window a slightly different shade of black to make window edges easier to see)
:USED-BY:


REM  unexplored: Set text colour to index n in a 256-colour palette (e.g. \x1b[38;5;34m)
REM  unexplored: is \x1b[?25h and \x1b[?25l. These show and hide the cursor, respectively.


if "%1" eq "force" goto :Force
if %COLORS_HAVE_BEEN_SET eq 1 (goto :AlreadyDone)
:Force


rem ANSI: Initialization 
        rem set up basic beginning of all ansi codes
            set ESCAPE=%@CHAR[27]
            set ANSI_ESCAPE=%@CHAR[27][

rem ANSI: special stuff: reset
            set ANSI_RESET=%ANSI_ESCAPE%0m

rem ANSI: special stuff: position save/restore
            set ANSI_POSITION_SAVE=%ESCAPE%7%ANSI_ESCAPE%s                  %+ REM we do this the DEC way, then the SCO way
            set ANSI_POSITION_RESTORE=%ESCAPE%8%ANSI_ESCAPE%u               %+ REM we do this the DEC way, then the SCO way
                set ANSI_SAVE_POSITION=%ANSI_POSITION_SAVE%                
                set ANSI_RESTORE_POSITION=%ANSI_POSITION_RESTORE%          
            set ANSI_POSITION_REQUEST=%ANSI_ESCAPE%6n	                    %+ REM request cursor position (reports as ESC[#;#R)
                set ANSI_REQUEST_POSITION=%ANSI_POSITION_REQUEST%

rem ANSI: position movement
        rem To Home
            set ANSI_HOME=%ANSI_ESCAPE%H	                                %+ REM moves cursor to home position (0, 0)
                set ANSI_MOVE_HOME=%ANSI_HOME%
                set ANSI_MOVE_TO_HOME=%ANSI_HOME%

        rem To a specific position
            function ANSI_MOVE_TO_POS1=`%@CHAR[27][%1;%2H`                  %+ rem moves cursor to line #, column #\_____ both work
            function ANSI_MOVE_TO_POS2=`%@CHAR[27][%1;%2f`                  %+ rem moves cursor to line #, column #/
                function ANSI_MOVE_POS=`%@CHAR[27][%1;%2H`                  %+ rem alias
                function ANSI_MOVE=`%@CHAR[27][%1;%2H`                      %+ rem alias
            function ANSI_MOVE_TO_COL=`%@CHAR[27][%1G`	                    %+ rem moves cursor to column #
            function ANSI_MOVE_TO_ROW=`%@CHAR[27][%1H`                      %+ rem unfortunately does not preserve column position! not possible! cursor request ansi code return value cannot be captured

        rem Up/Down/Left/Right
            set ANSI_MOVE_UP_1=%ESCAPE%M	                                %+ rem moves cursor one line up, scrolling if needed
                set ANSI_MOVE_UP_ONE=%ANSI_MOVE_UP_1%                       %+ rem alias
            function ANSI_MOVE_UP=`%@CHAR[27][%1A`	                        %+ rem moves cursor up # lines
                function ANSI_UP=`%@CHAR[27][%1A`	                        %+ rem alias
            function ANSI_MOVE_DOWN=`%@CHAR[27][%1B`	                    %+ rem moves cursor down # lines
                function ANSI_DOWN=`%@CHAR[27][%1B`	                        %+ rem alias
            function ANSI_MOVE_RIGHT=`%@CHAR[27][%1C`	                    %+ rem moves cursor right # columns
                function ANSI_RIGHT=`%@CHAR[27][%1C`	                    %+ rem alias
            function ANSI_MOVE_LEFT=`%@CHAR[27][%1D`	                    %+ rem moves cursor left # columns
                function ANSI_LEFT=`%@CHAR[27][%1D`	                        %+ rem alias

        rem Line-based
            function ANSI_MOVE_LINES_DOWN=`%@CHAR[27][%1E`                  %+ rem moves cursor to beginning of next line, # lines down
            function ANSI_MOVE_LINES_UP=`%@CHAR[27][%1F`                    %+ rem moves cursor to beginning of previous line, # lines up




rem ANIS: colors 
        rem custom rgb colors
             set ANSI_RGB_PREFIX=%ANSI_ESCAPE%38;2;
             set ANSI_RGB_SUFFIX=m
             function ANSI_RGB=`%@CHAR[27][38;2;%1;%2;%3m`
                 function ANSI_FG=`%@CHAR[27][38;2;%1;%2;%3m`               %+ rem alias
                 function ANSI_RGB_FG=`%@CHAR[27][38;2;%1;%2;%3m`           %+ rem alias
                 function ANSI_FG_RGB=`%@CHAR[27][38;2;%1;%2;%3m`           %+ rem alias
             function ANSI_RGB_BG=`%@CHAR[27][48;2;%1;%2;%3m`               
                 function ANSI_BG=`%@CHAR[27][48;2;%1;%2;%3m`               %+ rem alias
                 function ANSI_BG_RGB=`%@CHAR[27][48;2;%1;%2;%3m`           %+ rem alias

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
            set ANSI_BLACKGROUND_BLACK=%@ANSI_BG[0,0,0]
            set ANSI_BACKGROUND_BLACK_NON_EXPERIMENTAL=%ANSI_ESCAPE%40m
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
            set      BOLD_ON=%ANSI_BOLD_ON%
            set      BOLD_OFF=%ANSI_BOLD_OFF%
            set      BOLD=%BOLD_ON%

            set ANSI_FAINT=%ANSI_ESCAPE%2m
            set ANSI_FAINT_ON=%ANSI_FAINT%
            set ANSI_FAINT_OFF=%ANSI_ESCAPE%22m
            set      FAINT_ON=%ANSI_FAINT_ON%
            set      FAINT_OFF=%ANSI_FAINT_OFF%
            set      FAINT=%FAINT_ON%

            set ANSI_ITALICS=%ANSI_ESCAPE%3m
            set ANSI_ITALICS_ON=%ANSI_ITALICS%
            set ANSI_ITALICS_OFF=%ANSI_ESCAPE%23m
            set      ITALICS_ON=%ANSI_ITALICS_ON%
            set      ITALICS_OFF=%ANSI_ITALICS_OFF%
            set      ITALICS=%ITALICS_ON%

            set ANSI_UNDERLINE=%ANSI_ESCAPE%4m
            set ANSI_UNDERLINE_ON=%ANSI_UNDERLINE%
            set ANSI_UNDERLINE_OFF=%ANSI_ESCAPE%24m
            set      UNDERLINE_ON=%ANSI_UNDERLINE_ON%
            set      UNDERLINE_OFF=%ANSI_UNDERLINE_OFF%
            set      UNDERLINE=%UNDERLINE_ON%

            set ANSI_OVERLINE=%ANSI_ESCAPE%53m
            set ANSI_OVERLINE_ON=%ANSI_OVERLINE%
            set ANSI_OVERLINE_OFF=%ANSI_ESCAPE%55m
            set      OVERLINE_ON=%ANSI_OVERLINE_ON%
            set      OVERLINE_OFF=%ANSI_OVERLINE_OFF%
            set      OVERLINE=%OVERLINE_ON%

            set ANSI_DOUBLE_UNDERLINE=%ANSI_ESCAPE%21m
            set ANSI_DOUBLE_UNDERLINE_ON=%ANSI_DOUBLE_UNDERLINE%
            set ANSI_DOUBLE_UNDERLINE_OFF=%ANSI_ESCAPE%24m
            set      DOUBLE_UNDERLINE_ON=%ANSI_DOUBLE_UNDERLINE_ON%
            set      DOUBLE_UNDERLINE_OFF=%ANSI_DOUBLE_UNDERLINE_OFF%
            set      DOUBLE_UNDERLINE=%DOUBLE_UNDERLINE_ON%

                set ANSI_UNDERLINE_DOUBLE=%ANSI_DOUBLE_UNDERLINE%
                set ANSI_UNDERLINE_DOUBLE_ON=%ANSI_DOUBLE_UNDERLINE_ON%
                set ANSI_UNDERLINE_DOUBLE_OFF=%ANSI_DOUBLE_UNDERLINE_OFF%
                set      UNDERLINE_DOUBLE_ON=%DOUBLE_UNDERLINE_ON%
                set      UNDERLINE_DOUBLE_OFF=%DOUBLE_UNDERLINE_OFF%
                set      UNDERLINE_DOUBLE=%DOUBLE_UNDERLINE%


            set ANSI_BLINK_SLOW=%ANSI_ESCAPE%5m
            set ANSI_BLINK_SLOW_ON=%ANSI_BLINK_SLOW%
            set ANSI_BLINK_SLOW_OFF=%ANSI_ESCAPE%25m
            set      BLINK_SLOW_ON=%ANSI_BLINK_SLOW_ON%
            set      BLINK_SLOW_OFF=%ANSI_BLINK_SLOW_OFF%
            set      BLINK_SLOW=%BLINK_SLOW_ON%

            set ANSI_BLINK_FAST=%ANSI_ESCAPE%6m
            set ANSI_BLINK_FAST_ON=%ANSI_BLINK_FAST%
            set ANSI_BLINK_FAST_OFF=%ANSI_ESCAPE%25m
            set      BLINK_FAST_ON=%ANSI_BLINK_FAST_ON%
            set      BLINK_FAST_OFF=%ANSI_BLINK_FAST_OFF%
            set      BLINK_FAST=%BLINK_FAST_ON%

            set ANSI_BLINK=%ANSI_BLINK_FAST%
            set ANSI_BLINK_ON=%ANSI_BLINK_FAST_ON%
            set ANSI_BLINK_OFF=%ANSI_BLINK_FAST_OFF%
            set      BLINK_ON=%ANSI_BLINK_ON%
            set      BLINK_OFF=%ANSI_BLINK_OFF%
            set      BLINK=%BLINK_ON%

            set ANSI_REVERSE=%ANSI_ESCAPE%7m
            set ANSI_REVERSE_ON=%ANSI_REVERSE%
            set ANSI_REVERSE_OFF=%ANSI_ESCAPE%27m
            set      REVERSE_ON=%ANSI_REVERSE_ON%
            set      REVERSE_OFF=%ANSI_REVERSE_OFF%
            set      REVERSE=%REVERSE_ON%

            set ANSI_CONCEAL=%ANSI_ESCAPE%8m
            set ANSI_CONCEAL_ON=%ANSI_CONCEAL%
            set ANSI_CONCEAL_OFF=%ANSI_ESCAPE%28m
            set      CONCEAL_ON=%ANSI_CONCEAL_ON%
            set      CONCEAL_OFF=%ANSI_CONCEAL_OFF%
            set      CONCEAL=%CONCEAL_ON%

            set ANSI_STRIKETHROUGH=%ANSI_ESCAPE%9m
            set ANSI_STRIKETHROUGH_ON=%ANSI_STRIKETHROUGH%
            set ANSI_STRIKETHROUGH_OFF=%ANSI_ESCAPE%29m
            set      STRIKETHROUGH_ON=%ANSI_STRIKETHROUGH_ON%
            set      STRIKETHROUGH_OFF=%ANSI_STRIKETHROUGH_OFF%
            set      STRIKETHROUGH=%STRIKETHROUGH_ON%
                set OVERSTRIKE_ON=%STRIKETHROUGH_ON%
                set OVERSTRIKE_OFF=%STRIKETHROUGH_OFF%
                set OVERSTRIKE=%OVERSTRIKE_ON%


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
        set COLOR_ADVICE=        color bright magenta on        black  %+ set ANSI_COLOR_ADVICE=%ANSI_RESET%%ANSI_BRIGHT_MAGENTA%%ANSI_BACKGROUND_BLACK%%+ 
        SET COLOR_ALARM=         color bright white   on        red    %+ set ANSI_COLOR_ALARM=%ANSI_RESET%%ANSI_BRIGHT_WHITE%%ANSI_BACKGROUND_RED%                         %+ set COLOR_ERROR=%COLOR_ALARM% %+ set ANSI_COLOR_ERROR=%ANSI_COLOR_ALARM% %+ set COLOR_FATAL_ERROR=%COLOR_ERROR% %+ SET ANSI_COLOR_FATAL_ERROR=%ANSI_COLOR_ALARM% %+ set COLOR_ERROR_FATAL=%COLOR_FATAL_ERROR% %+ set ANSI_COLOR_ERROR_FATAL=%ANSI_COLOR_FATAL_ERROR%
        SET COLOR_COMPLETION=    color bright white   on        green  %+ set ANSI_COLOR_COMPLETION=%ANSI_RESET%%ANSI_BRIGHT_WHITE%%ANSI_BACKGROUND_GREEN%                  %+ set COLOR_CELEBRATION=%COLOR_COMPLETION%
        SET COLOR_DEBUG=         color        green   on        black  %+ set ANSI_COLOR_DEBUG=%ANSI_RESET%%ANSI_BRIGHT_GREEN%%ANSI_BACKGROUND_BLACK%
        SET COLOR_IMPORTANT=     color bright cyan    on        black  %+ set ANSI_COLOR_IMPORTANT=%ANSI_RESET%%ANSI_BRIGHT_CYAN%%ANSI_BACKGROUND_BLACK%
        SET COLOR_IMPORTANT_LESS=color        cyan    on        black  %+ set ANSI_COLOR_IMPORTANT_LESS=%ANSI_RESET%%ANSI_BRIGHT_RED%%ANSI_BACKGROUND_BLACK%%faint_on%      %+ set COLOR_LESS_IMPORTANT=%COLOR_IMPORTANT_LESS%
        SET COLOR_INPUT=         color bright white   on        black  %+ set ANSI_COLOR_INPUT=%ANSI_RESET%%ANSI_BRIGHT_WHITE%%ANSI_BACKGROUND_BLACK%                       %+ rem  had this set from inception til 2023
        SET COLOR_GREP=          color bright yellow  on        green  %+ set ANSI_COLOR_GREP=%ANSI_RESET%%ANSI_BRIGHT_YELLOW%%ANSI_BACKGROUND_GREEN%                      
        :ET COLOR_LOGGING=       color bright blue    on        black  %+ set ANSI_COLOR_LOGGING=%ANSI_RESET%%ANSI_BRIGHT_BLUE%%ANSI_BACKGROUND_BLACK%                      %+ rem  For logging temp filenames to screen, etc.
        SET COLOR_LOGGING=       COLOR        cyan    on        red    %+ set ANSI_COLOR_LOGGING=%ANSI_RESET%%ANSI_CYAN%%ANSI_BACKGROUND_RED%%OVERSTRIKE_ON%%ITALICS_ON%    %+ rem  For logging temp filenames to screen, etc.
        SET COLOR_NORMAL=        color        white   on        black  %+ set ANSI_COLOR_NORMAL=%ANSI_RESET%
        SET COLOR_PAUSE=         color        cyan    on        black  %+ set ANSI_COLOR_PAUSE=%ANSI_RESET%%ANSI_CYAN%%ANSI_BACKGROUND_BLACK%
        :ET COLOR_PROMPT=        color        yellow  on        black  %+ set ANSI_COLOR_PROMPT=%ANSI_RESET%%ANSI_YELLOW%%ANSI_BACKGROUND_BLACK%                            %+ rem tried changing to bright red on 20230605
        SET COLOR_PROMPT=        color bright red     on        black  %+ set ANSI_COLOR_PROMPT=%ANSI_RESET%%ANSI_BRIGHT_RED%%ANSI_BACKGROUND_BLACK%                        
        set COLOR_REMOVAL=       color bright red     on        black  %+ set ANSI_COLOR_REMOVAL=%ANSI_RESET%%ANSI_BRIGHT_RED%%ANSI_BACKGROUND_BLACK%                       
        SET COLOR_RUN=           color        yellow  on        black  %+ set ANSI_COLOR_RUN=%ANSI_RESET%%ANSI_YELLOW%%ANSI_BACKGROUND_BLACK%                               
        SET COLOR_SUCCESS=       color bright green   on        black  %+ set ANSI_COLOR_SUCCESS=%ANSI_RESET%%ANSI_BRIGHT_GREEN%%ANSI_BACKGROUND_BLACK%                     
        SET COLOR_SUBTLE=        color bright black   on        black  %+ set ANSI_COLOR_SUBTLE=%ANSI_RESET%%ANSI_BRIGHT_BLACK%%ANSI_BACKGROUND_BLACK%                      
        SET COLOR_UNIMPORTANT=   color        blue    on        black  %+ set ANSI_COLOR_UNIMPORTANT=%ANSI_RESET%%ANSI_BLUE%%ANSI_BACKGROUND_BLACK%                         
        :ET COLOR_WARNING=       color bright yellow  on        black  %+ set ANSI_COLOR_WARNING=%ANSI_RESET%%ANSI_BRIGHT_YELLOW%%ANSI_BACKGROUND_BLACK%                    %+ rem from inception 'til 20230529
        SET COLOR_WARNING=       color bright yellow  on        blue   %+ set ANSI_COLOR_WARNING=%ANSI_RESET%%ANSI_BRIGHT_YELLOW%%ANSI_BACKGROUND_BLUE%                     %+ rem 20230529-
        :ET COLOR_WARNING_LESS=  color        yellow  on        black  %+ set ANSI_COLOR_WARNING_LESS=%ANSI_RESET%%ANSI_YELLOW%%ANSI_BACKGROUND_BLACK%                      %+ set COLOR_WARNING_SOFT=%COLOR_WARNING_LESS% %+ REM inception-20230605
        SET COLOR_WARNING_LESS=  color bright yellow  on        black  %+ set ANSI_COLOR_WARNING_LESS=%ANSI_RESET%%ANSI_BRIGHT_YELLOW%%ANSI_BACKGROUND_BLACK%               %+ set COLOR_WARNING_SOFT=%COLOR_WARNING_LESS% %+ REM 2020606-

rem colors for GREP:
        set GREP_COLOR_NORMAL=mt=1;33;42           %+  set GREP_COLOR_HILITE=1;41;37              %+ set GREP_COLOR=%GREP_COLOR_NORMAL%         
        set GREP_COLORS_NORMAL=fn=1;33:ln=1;36;44  %+  set GREP_COLORS_HILITE=fn=1;34:ln=1;37;44  %+ set GREP_COLORS=%GREP_COLOR_NORMAL% %+ REM do NOT change set GREP_COLORS= to be GREP_COLORS_NORMAL, those are the highlight colors actually
        :SET LC-ALL=C
        :^^^^^^^^^^^ LC-ALL=C actually gives an 86% speed grep increase [as of 2015ish on computer Thailog] at the expense of not being able to grep 2-byte-per-char type unicode files but in 20230504 it was decided unicode files are more common and our new computer is faster so this isn't worth it

set COLORS_HAVE_BEEN_SET=1
:AlreadyDone

if "%1" eq "test" (
    echo %ANSI_TEST_STRING%
    echo %ANSI_TEST_STRING_2%
    echo %ANSI_TEST_STRING_3%
)



REM unrelated to colors, but nice-to-have variables:
        set QUOTE=%@CHAR[34]  
        set TAB=%CHAR[9]
        set NEWLINE=%@CHAR[12]%@CHAR[13]
