# fix_unicode_filenames

## Cleanses all emoji & unicode characters not just from filenames, but also from strings

It can be invoked in two ways:

* Standalone mode: Run in a folder to clean it
                   Will prompt for each change unless set to automatic
* Module mode: Incorporate into other program. 
                   Use it to cleanse strings, particularly for filenames

To cleanse in two ways:

*   String mode: Cleanse all emoji/unicode characters 
* Filename mode: *Also* cleanse invalid/problematic file characters




# What does it fix, generally?

It basically renames filename characters back to year-2000-ish-compliant level characters, along with removing other characters that can be problematic in command-line situations.

The idea is to reduce workflow tool breakage by purging special characters that must be addressed with every tool in a workflow. Avoid edge cases by avoiding the edge.




# How do I use it as a programming module?

```
import fix_unicode_filenames
cleaner_string = fix_unicode_filenames.convert_a_string  (dirty_string,   silent=True)
safer_filename = fix_unicode_filenames.convert_a_filename(dirty_filename, silent_if_unchanged=True)     
```
You can pass: 
* silent_if_unchanged=True - shut up about unchanged files, only tell me what you fixed
* silent=True              - shut up about everything, just do it silently



# How do I use it as a standalone tool?

It can be run in 5 usual modes:

```
1. To cleanse all file/folder names in your dir *with*  Yes/No prompting
2. To cleanse all file/folder names in your dir without Yes/No prompting
3. To cleanse a single string of unicode/emoji (keep bad-filename-chracters)
4. To cleanse a single string of unicode/emoji *AND* bad-filename-chracters 
5. To run internal testing suite / lookup table validation
```
Which can be invoked like this:
```
1. fix_unicode_filenames 	                
2. fix_unicode_filenames auto                    
3. fix_unicode_filenames string "😈𝚫🎉 💜Ꝁ🤠🤡🤢矲石矴🍕"  
4. fix_unicode_filenames file   "😈𝚫🎉 💜Ꝁ🤠🤡🤢矲石矴🍕"  
5. fix_unicode_filenames test
```     




# What does it fix as an example?

Check out the entries from [this sample output log](https://raw.githubusercontent.com/ClaireCJS/fix_unicode_filenames/main/example-run-output.log) for how I use it to clean downloaded youtube video filenames.

Many are simply instances of changing unicode hyphens and apostrophes to standard ascii, but other things happen too, such as: changing "👑 " to "{CROWN}", removing the accent from the e in Beyonce, changing the half symbol (½) to "1--2". [Had it been run in string mode instead of filename mode, it would have converted it to "1/2", but slash is invalid in a filename], using different symbols to obscure Justin Bieber's name, removing the tilda from the Spanish ns, or the dots over the German as, changing the unicode quotes (＂) around Pink Elephants On Parade, changing the uincode colon, changing the eastern brackets around the "Cowboy Bebop", etc.
 

# What does it fix, exhaustively?

I created [this tool to print pretty much every printable unicode/emoji chracter ever](https://github.com/ClaireCJS/fix_unicode_filenames/blob/main/testdata-generate-every-character-ever.py), which then created [this output file of pretty much every printable unicode/emoji character ever](https://github.com/ClaireCJS/fix_unicode_filenames/blob/main/testdata-generate-every-character-ever.out), though I moved the emojis to the bottom of the file for testing purposes.  I then feed it through the script [to create this output file of every character ever as transformed by this tool](https://raw.githubusercontent.com/ClaireCJS/fix_unicode_filenames/main/testdata-generate-every-character-ever.out.scrubbed.by.our.tool).

[For testing, I also installed the [GNU Unifont](https://localfonts.eu/freefonts/traditional-cyrillic-free-fonts/unifont/), an open-source font that promises to display more of these characters than other fonts. Though typically I use Consolas Code in my console, this was good for testing. I used the TrueType font version, [unifont-15.0.06.ttf, which can be downloaded here](http://www.unifoundry.com/pub/unifont/unifont-15.0.06/font-builds/unifont-15.0.06.ttf).]

So basically, it turned:

* [ALL OF THIS UNICODE](https://raw.githubusercontent.com/ClaireCJS/fix_unicode_filenames/main/testdata-generate-every-character-ever.out)

...into...

* [ALL OF THESE ASCII](https://raw.githubusercontent.com/ClaireCJS/fix_unicode_filenames/main/testdata-generate-every-character-ever.out.scrubbed.by.our.tool)

Notice how much quicker the 2nd/cleaned one loads, even though the file is 24.61X larger in size? 

That's because we're avoiding all that unicode processing and rendering.

That's the results we're looking for with this tool: Less overall hassle by avoiding harder-to-process characters in our workflows.



# How does this work under the hood?

First, our custom/manually-created mapping library is used.  This was hand-made with some amount of care.

Then, emoji characters are de-emojied

Then, it uses the Polyglot library to attempt a language-agnostic all-languages translation, which can almost always fail. [It might be hard for someone else to get this part working.]

Then, Arabic, Bengali, and and Hindi characters are passed through a phonetically mapping table so they can sort of be pronounced.

Then, Thai, Japanese, Chinese, and Korean characters are run through 4 conversion libraries specific to those languages. [It might be hard for someone else to get all of these working.]

Then Unicode chracters are run through the unidecode library to convert them. ........... But this library is not well maintained and often gives no result. Thus, our custom mapping table. 

If nothing is found, an exception is thrown, explaining to add the character to the mapping table. Possibly necessary as new emojis come out.



# Internal mapping table format:

Entries are either in this format [one key, one value] for when the alternative is valid for filenames:

    '∑' :   'E=',   #or change this to "Sigma=" if that is your opinion :)
    '∫' :   'S=',   #or change this to "Sum="   if that is your opinion :)

Or in this format [one key, array of two values], for when we have a good string mode alternative which would NOT work as a filename (most emoticons are not valid filenames due to the eyes being represented with colons), and have a separate mapping for our filenames (very common with face-related emoji):

    "😖": [">.<", "{confounded face}"], 
    "😕": [":/" , "{confused face}"  ], #change "😕" to ":/" in string mode, "{confused face}" in file mode
    "😢": [")':", "{crying face}"    ],

Some characters cannot be directly pasted into the lookup table -- they just don't process right in python or they get corrupted in the file after pasting -- so you must insert their code instead:

    '\u0081':      ["{control}"       ], #these characters are usually invisible
    '\u0090':      ["{device control}"], #but we want those converted too!

Still other characters _cannot even be referenced by their code directly_, and this is a hard situation to figure out, so an additional workaround had to be implemented for those chracters, and looks like this:

    "code u1f409":  ["{dragon}",],	 #probably the same dragon from the Atari 2600 Adventure game!

That pesky dragon!


# Advanced usage

Wrap it up in a BAT file that captures the errorlevel.
If there is an errorlevel, automatically re-run it.
If there is no error, roll the log file to reycle bin.

An example TCC BAT (really BTM) file [can be found here](https://github.com/ClaireCJS/fix_unicode_filenames/blob/main/fix-unicode-filenames.bat), and if you want to run it, grab all the [dependency BAT files found here](https://github.com/ClaireCJS/fix_unicode_filenames/tree/main/BAT).



# Testing

A lot was done. I mean a lot. A ton. But nothing formal until the very end with running every-character-ever through it, and it's too big a data set to manually check. But it seems to be working well in my presonal workflows.

Also, the code got corrupted due to the presence of unicode characters in it -- OH THE SWEET IRONY -- and a lot of stuff got redone with a quarter of the original effort :/  I had made some really well thought out mappings and didn't bother the second time. It was a mistake to ever paste unicode chracters into source code, but I wanted to test the validity of that approach, too. Alas, the easiest way to add new charactesr to the lookup table is to simply paste them in. If that fails, looking them up and doing them by code will work. A few pesky characters could ONLY be refererenced by code, and some only indirectly, so there are some weird code workarounds for those situtations, and a few outliers in the lookup table (documented above).


# Installation: Python


GOOD LUCK. I had a hell of a time getting the libraries right for this. I think you'll have to remove polyglot support unless you can get that running. It's hard. And the unidecode library is difficult too. And if you ask the author about it, he just replies with a form letter "I'm sorry it didn't meet your needs" rather than maintaining his code. So good luck.

In theory, though: install the appropriate packages:

```bash
pip install -r requirements.txt
```

In practice.... There are 2 wheel files for polyglot that you have to install in specific order. And python-romkan is hard to deal with too. So is unicode. Good luck.



# Those wacky BAT files?

I use TCC -- Take Command Command Line.
Technically, my .BAT files are .BTM files.
They're really for me, but sometimes I include them in my repo since I want them version controlled, too.

# License

[The Unlicense](https://choosealicense.com/licenses/unlicense/)

