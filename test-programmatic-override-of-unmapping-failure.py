#this test is tricky because you need to find a unicode character not accounted for
#when found, we will account for it
#thus making this test hard to run unless we comment out one of our custom mappings

#TODO: manually delete a key to force the error condition

import fixUnicodeFilenames
from colorama import Fore, Back, Style, just_fix_windows_console
just_fix_windows_console()
#init()
print (f"dir(fixUnicodeFilenames) = {dir(fixUnicodeFilenames)}")


fixUnicodeFilenames.run_internal_tests()


filename_without_unicode = fixUnicodeFilenames.convert_a_filename("🏼")
filename_without_unicode = fixUnicodeFilenames.convert_a_filename("🏼",silent_if_unchanged=True)     #silent_if_unchanged=True suppresses output if nothing changes
a_string_without_unicode = fixUnicodeFilenames.convert_a_string  ("🏼")

print(f"\n\n{Fore.YELLOW}Deleting '🐇' (:rabbit:) character from custom mapping table, which should throw a warning for our internal mapping test, but still output {Fore.GREEN}New string: _{Fore.YELLOW} to the screen...")
del fixUnicodeFilenames.unicode_to_ascii_custom_character_mapping["🐇"]                  #this character wasn't successfully decoded by unidecode in 2023/05


filename_without_unicode = fixUnicodeFilenames.convert_a_filename('🐇')
filename_without_unicode = fixUnicodeFilenames.convert_a_filename('🐇',silent_if_unchanged=True)     #silent_if_unchanged=True suppresses output if nothing changes
a_string_without_unicode = fixUnicodeFilenames.convert_a_string  ('🐇')

print(f"\n\n*** Now we should see warnings, but the program should still exit gracefully and output a new string to the screen:{Back.BLUE}\n")

filename_without_unicode = fixUnicodeFilenames.convert_a_filename('🐇')
filename_without_unicode = fixUnicodeFilenames.convert_a_filename('🐇',silent_if_unchanged=True)     #silent_if_unchanged=True suppresses output if nothing changes
a_string_without_unicode = fixUnicodeFilenames.convert_a_string  ('🐇')

print(f"{Style.RESET_ALL}\n\n{Fore.GREEN}{Style.BRIGHT}Everything went well!")
