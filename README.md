# fix_unicode_filenames

fix_unicode_filenames is a filename fixer that removes all emoji, all unicode, and many other special/incovenient characters from filenames

It cleanses in two modes:

	* String mode: Cleanse all emoji/unicode characters 
	* Filename mode: Additionally cleanse all invalid/problematic file characters

It can be used in two ways:

	* Standalone mode. Run in a folder to cleanse the files in a folder.  It will prompt for each file rename unless you pass "auto" as a parameter.
	* Incorporate into other program. Use it to cleanse strings in your programs, especially if you're creating new files and want safe filenames.


## What does it fix, generally?

It basically renames filename characters back to year-2000-ish-compliant level characters, along with removing other characters that can be problematic in command-line situations.

The idea is to reduce workflow tool breakage by purging special characters that must be addressed with every tool in a workflow. Avoid edge cases by avoiding the edge.


## What does it fix, specifically?

Check out the entries from [this sample output log](https://raw.githubusercontent.com/ClaireCJS/fix_unicode_filenames/main/example-run-output.log). 

Many are simply instances of changing unicode hyphens and apostrophes to standard ascii, but other things happen too.

* The 1st section is an example of how it handles emojis, changing "👑 " to "{CROWN}"
* The 3rd entry ("Beyonce")  removes the accent from the e in Beyonce. 
* The 4th ("Cartoon Sushi") changes the half symbol (½) to "1--2". Had it been run in string mode instead of filename mode, it would have converted it to "1/2". Remember: Slash is invalid in a filename.
* "Devi McCallion" (entry #6) used unicode characters to obscure Justin Bieber's name, and these were changed to hash symbols.
* "Gentlemen Lobsters" (entry #8) have the tilde removed from the spanish "n" enyay character.
* After that, "Haxan" removes the 2 dots over the a in "Hexan"
* Further down, "Pink Elephants On Parade", unicode quotes (＂) are turned into apostrophes (') because standard quotes (") are not valid for filenames. But in string mode, it would have been turned into non-unicode ascii quotes (").
* Right below that, a unicode colon is turned into "- " because colon is invalid in a filename. But in string mode, it would have been turned into a non-unicode ascii colon.
* The "Cowboy Bebop" one changes those interesting eastern corner brackets around "『Piano』" into normal brackets.
* etc
 





    USAGE:

        SETUP: To suppress user prompting: set AUTOMATIC_UNICODE_CLEANING=1

        MODE 1:  No      arguments  : Run with no arguments to cleanse everything in your existing folder of unicode characters
              :  "auto"  argum
              ent   : ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Do this, but suppress confirmation prompts
        MODE 2: "file   <arguments>": Use "file"   as your first argument to cleanse the rest of the command line of unicode, as if it were a windows filename
        MODE 3: "string <arguments>": Use "string" as your first argument to cleanse the rest of the command line of unicode, without restricting to only-valid-in-windows-fiklenames
        MODE 4: "test"              : to convert the internal testing string

    PROGRAMMATIC USAGE:
        import fixUnicodeFilenames
        a_string_without_unicode = fixUnicodeFilenames.convert_a_string  (original_stringval_with_unicode)
        filename_without_unicode = fixUnicodeFilenames.convert_a_filename(original_file_name_with_unicode,silent_if_unchanged=True)     #silent_if_unchanged=True suppresses output if nothing changes
         #silent=suppresses all output no matter what



    Uses Polyglot library to attempt a language-agnostic translation, which can easliy fail
    Then several internal custom mapping tables for phonetically romanizing characters & emojis
    Then several lingual libraries for romanizing individual characters for some "weirder alphabet" languages
    Then an emoji library for converting unconverted emojis






    (1) First, an amazing multi-language language-agnostic full translation library called polyglot is used
        to interpret the entire filename/string at a high ("smart") level to see if a language is detected,
        and then to make language-specific conversions to our ASCII/roman equivalent characters.

        But it throws an exception if a specific language is not detected, and it's also hard to install,
        so the entire thing is wrapped around an exception that just throws the original text if anything goes wrong.

        Also, polyglot will omit characters sometimes, so we do not want a null string

    (2) Then, each character is processed at a per-chracter level, checking its unicode range to see if it's a language,
        and then passing through either a language library or a phoenetic mapping table, to translate the chracters
        back to ASCII/roman.


def translate_thai_____to_ascii(text): return ThaiRomanize(text)                                                # Thai
def translate_japanese_to_ascii(char): return romkan.to_roma(char)                                              # Japanese
def translate_korean___to_ascii(text): return KoreanRomanizer(text).romanize()                                  # Korean
def translate_chinese__to_ascii(char): return ''.join(lazy_pinyin(char, style=PypinyinStyle.TONE3))             # Chinese
def translate_bengali__to_ascii(text): return ''.join(bengali_to_english_phonetic.get(c, '_') for c in text)    # Bengali  (no library used)
def translate_arabic___to_ascii(text): return ''.join( arabic_to_english_phonetic.get(c, '_') for c in text)    # Arabic   (no library used)
def translate_hindi____to_ascii(text): return ''.join(  hindi_to_english_phonetic.get(c, '_') for c in text)    # Hindi    (no library used)


    '∑' :   'E=',   #quite the stretch, maybe "sigma" would be better
    '∫' :   'S=',   #quite the stretch, maybe "sum"   would be better

    "🎉":      ["{party popper}",],
    '\ue0069':["i"],                #Latin Small Letter I
    '\uE005A':["Z"],                #Latin Capital Letter Z
    '\ue006c':["l"],                #Latin Small Letter L








## Installation: Python


GOOD LUCK. I had a hell of a time getting the libraries right for this. I think you'll have to remove polyglot support unless you can get that running. It's hard. And the unidecode library is difficult too. And if you ask the author about it, he just replies with a form letter "I'm sorry it didn't meet your needs" rather than maintaining his code. So good luck.

In theory, though: install the appropriate packages:

```bash
pip install -r requirements.txt
```

In practice.... There are 2 wheel files for polyglot that you have to install in specific order. And python-romkan is hard to deal with too. So is unicode. Good luck.


## Testing

A lot was done. I mean a lot. A ton. But nothing formal.

And then the code got corrupted due to the presence of unicode characters in it -- OH THE SWEET IRONY -- and a lot of stuff got redone with a quarter of the original effort :/


## Those wacky BAT files?

I use TCC -- Take Command Command Line.
Technically, my .BAT files are .BTM files.
They're really for me, but sometimes I include them in my repo since I want them version controlled, to.

## License

[The Unlicense](https://choosealicense.com/licenses/unlicense/)

