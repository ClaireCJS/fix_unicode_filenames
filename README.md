# fix_unicode_filenames

fix_unicode_filenames is a filename fixer that removes all emoji, all unicode, and many other special/incovenient characters from filenames

It cleanses in two modes:

*   String mode: Cleanse all emoji/unicode characters 
* Filename mode: *Also* cleanse invalid/problematic file characters

It can be used in two ways:

* Standalone mode: Run in a folder to clean it
                   Will prompt for each change unless set to automatic
* Module mode: Incorporate into other program. 
                   Use it to cleanse strings, particularly for filenames



## What does it fix, generally?

It basically renames filename characters back to year-2000-ish-compliant level characters, along with removing other characters that can be problematic in command-line situations.

The idea is to reduce workflow tool breakage by purging special characters that must be addressed with every tool in a workflow. Avoid edge cases by avoiding the edge.




## How do I use it as a programming module?

```
import fix_unicode_filenames
cleaner_string = fix_unicode_filenames.convert_a_string  (dirty_string,   silent=True)
safer_filename = fix_unicode_filenames.convert_a_filename(dirty_filename, silent_if_unchanged=True)     
```
You can pass: 
* silent_if_unchanged=True - shut up about unchanged files, only tell me what you fixed
* silent=True              - shut up about everything, just do it silently



## How do I use it as a standalone tool?

It can be run in 5 usual modes, using "auto", "string", "file", and "test" as optional parameters:

```1. To cleanse all file/folder names in your dir with Yes/No prompting
2. To cleanse all file/folder names in your dir automatically
3. To convert a string mode (remove emoji/unicode) at the command line
4. To do the same, but in filename mode
5. To Run internal testing suite / lookup table validation```

```1. fix_unicode_filenames 	                
2. fix_unicode_filenames auto                    
3. fix_unicode_filenames string "😈🎉 💜😈"  
4. fix_unicode_filenames file   "😈🎉 💜😈"  
5. fix_unicode_filenames test```     




## What does it fix as an example?

Check out the entries from [this sample output log](https://raw.githubusercontent.com/ClaireCJS/fix_unicode_filenames/main/example-run-output.log) for how I use it to clean downloaded youtube video filenames.

Many are simply instances of changing unicode hyphens and apostrophes to standard ascii, but other things happen too, such as: changing "👑 " to "{CROWN}", removing the accent from the e in Beyonce, changing the half symbol (½) to "1--2". [Had it been run in string mode instead of filename mode, it would have converted it to "1/2", but slash is invalid in a filename], using different symbols to obscure Justin Bieber's name, removing the tilda from the Spanish ns, or the dots over the German as, changing the unicode quotes (＂) around Pink Elephants On Parade, changing the uincode colon, changing the eastern brackets around the "Cowboy Bebop", etc.
 

## What does it fix, exhaustively?

I created [this tool to print pretty much every printable unicode/emoji chracter ever](https://github.com/ClaireCJS/fix_unicode_filenames/blob/main/testdata-generate-every-character-ever.py), which then created [this output file of pretty much every printable unicode/emoji character ever](https://github.com/ClaireCJS/fix_unicode_filenames/blob/main/testdata-generate-every-character-ever.out), though I moved the emojis to the bottom of the file for testing purposes.  I then feed it through the script [to create this output file of every character ever as transformed by this tool](https://raw.githubusercontent.com/ClaireCJS/fix_unicode_filenames/main/testdata-generate-every-character-ever.out.scrubbed.by.our.tool).

[For testing, I also installed the [GNU Unifont](https://localfonts.eu/freefonts/traditional-cyrillic-free-fonts/unifont/), an open-source font that promises to display more of these characters than other fonts. Though typically I use Consolas Code in my console, this was good for testing. I used the TrueType font version, [unifont-15.0.06.ttf, which can be downloaded here](http://www.unifoundry.com/pub/unifont/unifont-15.0.06/font-builds/unifont-15.0.06.ttf).]

So basically, it turned:

* [ALL OF THIS UNICODE](https://raw.githubusercontent.com/ClaireCJS/fix_unicode_filenames/main/testdata-generate-every-character-ever.out)

...into...

* [ALL OF THESE ASCII](https://raw.githubusercontent.com/ClaireCJS/fix_unicode_filenames/main/testdata-generate-every-character-ever.out.scrubbed.by.our.tool)

Notice how much quicker the 2nd/cleaned one loads, even though the file is 24.61X larger in size? 

That's because we're avoiding all that unicode processing and rendering.

That's the results we're looking for with this tool: Less overall hassle by avoiding harder-to-process characters in our workflows.



## How does this work under the hood?

First, our custom/manually-created mapping library is used.  This was hand-made with some amount of care.

Then, emoji characters are de-emojied

Then, it uses the Polyglot library to attempt a language-agnostic all-languages translation, which can almost always fail. [It might be hard for someone else to get this part working.]

Then, Arabic, Bengali, and and Hindi characters are passed through a phonetically mapping table so they can sort of be pronounced.

Then, Thai, Japanese, Chinese, and Korean characters are run through 4 conversion libraries specific to those languages. [It might be hard for someone else to get all of these working.]

Then Unicode chracters are run through the unidecode library to convert them. ........... But this library is not well maintained and often gives no result. Thus, our custom mapping table. 

If nothing is found, an exception is thrown, explaining to add the character to the mapping table. Possibly necessary as new emojis come out.



## Internal mapping table format:

Lines are either in this format for when the alternative is valid for filenames:

    '∑' :   'E=',   #quite the stretch, maybe "sigma" would be better
    '∫' :   'S=',   #quite the stretch, maybe "sum"   would be better

Or this format, for when we have a good string mode alternative which would NOT work as a filename (most emoticons are not valid filenames due to the eyes being represented with colons):

    "😖": [">.<", "{confounded face}"],
    "😕": [":/" , "{confused face}"  ],
    "😢": [")':", "{crying face}"    ],



## Advanced usage

Wrap it up in a BAT file that captures the errorlevel.
If there is an errorlevel, automatically re-run it.
If there is no error, roll the log file to reycle bin.

An example TCC BAT (really BTM) file [can be found here](https://github.com/ClaireCJS/fix_unicode_filenames/blob/main/fix-unicode-filenames.bat), and if you want to run it, grab all the [dependency BAT files found here](https://github.com/ClaireCJS/fix_unicode_filenames/tree/main/BAT).



## Testing

A lot was done. I mean a lot. A ton. But nothing formal.

And then the code got corrupted due to the presence of unicode characters in it -- OH THE SWEET IRONY -- and a lot of stuff got redone with a quarter of the original effort :/


## Installation: Python


GOOD LUCK. I had a hell of a time getting the libraries right for this. I think you'll have to remove polyglot support unless you can get that running. It's hard. And the unidecode library is difficult too. And if you ask the author about it, he just replies with a form letter "I'm sorry it didn't meet your needs" rather than maintaining his code. So good luck.

In theory, though: install the appropriate packages:

```bash
pip install -r requirements.txt
```

In practice.... There are 2 wheel files for polyglot that you have to install in specific order. And python-romkan is hard to deal with too. So is unicode. Good luck.



## Those wacky BAT files?

I use TCC -- Take Command Command Line.
Technically, my .BAT files are .BTM files.
They're really for me, but sometimes I include them in my repo since I want them version controlled, too.

## License

[The Unlicense](https://choosealicense.com/licenses/unlicense/)

