from contextlib import redirect_stdout
import random
import string

"""
INSTRUCTIONS FOR USE:
1. Open terminal/powershell/CLI to this directory ('helpers/test')
2. Run randomTextGeneratorScript.py
3. Output is given in out_newline.txt
"""

"""
This function generates random text using letters and digits from the ascii libraries and adds whitespaces and
newline characters at random intervals and exports the print output as a .txt file
"""
def generate_text_newline():
    numChars = int(input("Input desired length of string: " ))
    ref = string.ascii_letters + string.digits + '\n' + ' '
    newstr = random.choices(ref, k = numChars)
    res = ''.join(newstr)

    with open('out_newline_' + str(numChars) + 'chars.txt', 'w') as f:
        with redirect_stdout(f):
            print(res)
    return res

"""
This function generates random text using letters and digits from the ascii libraries and
adds only whitespaces at random intervals and exports the print output as a .txt file
"""
def generate_text_spaces():
    numChars = int(input("Input desired length of string: " ))
    ref = string.ascii_letters + string.digits + ' '
    newstr = random.choices(ref, k = numChars)
    res = ''.join(newstr)
    with open('out_spaces_' + str(numChars) + 'chars.txt', 'w') as f:
        with redirect_stdout(f):
            print(res)
    return res

if __name__ == "__main__":
    generate_text_newline() # modify to generate_text_spaces() to add only whitespaces randomly