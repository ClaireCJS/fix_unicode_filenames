CHARACTERS_ONLY = True

"""
Printing out every character in existence is not a practical task due to a few reasons:

1. There are over 143,000 characters in the Unicode Standard as of version 13.0, and this number grows with each new version.

2. Not all characters are printable. Some are control characters, and others may not be represented correctly depending on the platform and font you are using.

3. Some languages, such as Chinese, Japanese, and Korean, have tens of thousands of characters each.

4. Many Unicode characters require special handling to be displayed correctly. For example, some characters are combining marks that modify the previous character, some are right-to-left, and others are complex scripts where the shape of a character can depend on its surrounding characters.

For these reasons, it's generally not useful or practical to try to print every character. However, if you wish to generate a large range of Unicode characters, you can do it with a script.

Here is a simple Python script that prints Unicode characters in a specified range:

```python
# This script prints out Unicode characters in the range from 32 (space) to 127 (delete).
# This range includes basic Latin characters, digits, punctuation, and a few control characters.

for i in range(32, 128):
    print(chr(i))
```

You can modify the range as needed to print different ranges of characters, but keep in mind the considerations I mentioned earlier.

The Unicode Standard, as of version 13.0 (March 2020), defines codes from 0 to 0x10FFFF, which is 1,114,111 in decimal. It includes 143,859 characters for various scripts and symbols, including emoji, and provides the basis for processing, storage, and interchange of text data in any language.

So, in the Python script I provided earlier, you could technically set the range from 0 to 1,114,111 (`0x10FFFF`), but keep in mind that not all of these code points correspond to defined characters, or all characters will be printable or displayable, as I mentioned in the previous message. Many of the code points are reserved for future updates of the Unicode Standard.
"""

# This script prints out Unicode characters in the range from 32 (space) to 127 (delete).
# This range includes basic Latin characters, digits, punctuation, and a few control characters.


import unicodedata

#LAST_CHAR=128
#LAST_CHAR=1114111
LAST_CHAR = 0x10FFFF  # This is the maximum valid code point in Unicode.

import fix_unicode_filenames

def is_surrogate(char):
    return 0xD800  <= ord(char) <= 0xDFFF
def is_variation_selector(char):
    return 0xE0100 <= ord(char) <= 0xE01EF

def print_all(display_emoji=False):
    for i in range(32, LAST_CHAR + 1):
        char = chr(i)

        if     fix_unicode_filenames.is_emoji_character(char) and not display_emoji: continue
        if not fix_unicode_filenames.is_emoji_character(char) and     display_emoji: continue

        if (unicodedata.category(char) in ["Cc", "Cf", "Cs", "Co", "Cn"]) or (0xE000 <= i <= 0xF8FF  ) or (0xF0000  <= i <= 0xFFFFD ) or (0x100000 <= i <= 0x10FFFD):
            continue

        # if it's a high surrogate, try to combine it with the next character if it's a low surrogate
        if 0xD800 <= i <= 0xDBFF:
            if i+1 <= LAST_CHAR:
                low_surrogate = chr(i+1)
                if 0xDC00 <= ord(low_surrogate) <= 0xDFFF:
                    char += low_surrogate
                    i += 1  # skip the low surrogate in the next loop

        # if it's a low surrogate, it should have been processed in the previous loop, so we skip it
        if 0xDC00 <= i <= 0xDFFF:
            continue

        if is_variation_selector(char):
            char = "V" + char + "V"
        if not CHARACTERS_ONLY: print(f"{i:>7} {i:>5X} '",end="")
        try:
            print(char,end="")
        except:
            if not CHARACTERS_ONLY: print("{?}",end="")

        if not CHARACTERS_ONLY: print ("'")



print_all(False)
print_all(True)
