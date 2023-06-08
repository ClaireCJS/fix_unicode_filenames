# fix_unicode_filenames

fix_unicode_filenames is a filename fixer that removes all emoji, all unicode, and many other special/incovenient characters from filenames

It cleanses in two modes:

*   String mode: Cleanse all emoji/unicode characters 
* Filename mode: *Also* cleanse invalid/problematic file characters

It can be used in two ways:

* Standalone mode: Run in a folder to clean it.  
                   Will prompt user for each change unless set to automatic mode.
* Module mode: Incorporate into other program. 
                   Use it to cleanse strings, particularly for filenames


## What does it fix, generally?

It basically renames filename characters back to year-2000-ish-compliant level characters, along with removing other characters that can be problematic in command-line situations.

The idea is to reduce workflow tool breakage by purging special characters that must be addressed with every tool in a workflow. Avoid edge cases by avoiding the edge.


## How do I use it as a standalone tool?

It can take "auto", "string", "file", and "test" as optional parameters:   

```    
* fix_unicode_filenames 	                 Cleanses all file/folder names in your dir with Yes/No prompting
* fix_unicode_filenames auto                     Cleanses all file/folder names in your dir automatically
* fix_unicode_filenames string "test filename"   Test out string mode (remove emoji/unicode) on a string at the command line
* fix_unicode_filenames file   "test filename"   Test out file   mode (remove   even   more) on a string at the command line
* fix_unicode_filenames test                     Run internal testing suite / validation



## Installation: Python


GOOD LUCK. I had a hell of a time getting the libraries right for this. I think you'll have to remove polyglot support unless you can get that running. It's hard. And the unidecode library is difficult too. And if you ask the author about it, he just replies with a form letter "I'm sorry it didn't meet your needs" rather than maintaining his code. So good luck.

In theory, though: install the appropriate packages:

```bash
pip install -r requirements.txt
```

In practice.... There are 2 wheel files for polyglot that you have to install in specific order. And python-romkan is hard to deal with too. So is unicode. Good luck.


## What does it fix as an example?

Check out the entries from [this sample output log](https://raw.githubusercontent.com/ClaireCJS/fix_unicode_filenames/main/example-run-output.log) for how I use it to clean downloaded youtube video filenames.

Many are simply instances of changing unicode hyphens and apostrophes to standard ascii, but other things happen too, such as: changing "👑 " to "{CROWN}", removing the accent from the e in Beyonce, changing the half symbol (½) to "1--2". [Had it been run in string mode instead of filename mode, it would have converted it to "1/2", but slash is invalid in a filename], using different symbols to obscure Justin Bieber's name, removing the tilda from the Spanish ns, or the dots over the German as, changing the unicode quotes (＂) around Pink Elephants On Parade, changing the uincode colon, changing the eastern brackets around the "Cowboy Bebop", etc.
 

## What does it fix, exhaustively?

I made [a list of almost every unicode chracter ever]() to feed it through this.

It turned:

* [ALL OF THIS UNICODE](https://raw.githubusercontent.com/ClaireCJS/fix_unicode_filenames/main/testdata-generate-every-character-ever.out)

...into...

* [ALL OF THESE ASCII](https://raw.githubusercontent.com/ClaireCJS/fix_unicode_filenames/main/testdata-generate-every-character-ever.out.scrubbed.by.our.tool). 

Notice how much quicker the 2nd/cleaned one loads, even though the file is 24.61X larger in size? 
That's because we're avoiding all that unicode processing and rendering.
That's the results we're looking for with this tool: Less overall hassle.


## How do I use it as a programming module?

```
import fix_unicode_filenames
cleaner_string = fix_unicode_filenames.convert_a_string  (original_with_unicode_and_emoji, silent_if_unchanged=True)
safer_filename = fix_unicode_filenames.convert_a_filename(original_with_unicode_and_emoji, silent_if_unchanged=True)     
```

You can pass: 

* silent_if_unchanged=True to make it shut up about all the changes it did NOT make, which is generally going to be the default in this situation
* silent=True              to make it shut up about all the changes it DID     make, which really depends on your preferences for  your situation


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



## Testing

A lot was done. I mean a lot. A ton. But nothing formal.

And then the code got corrupted due to the presence of unicode characters in it -- OH THE SWEET IRONY -- and a lot of stuff got redone with a quarter of the original effort :/


## Those wacky BAT files?

I use TCC -- Take Command Command Line.
Technically, my .BAT files are .BTM files.
They're really for me, but sometimes I include them in my repo since I want them version controlled, to.

## License

[The Unlicense](https://choosealicense.com/licenses/unlicense/)

