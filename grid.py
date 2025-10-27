#!/usr/bin/env python3

# Render a LAP6 character grid.  The input is a file of 126 12-bit
# wordcs in octal.  Each character is two words rendered as a 6x4
# grid.

import sys

def pixel(x):
    print(". " if x == 0 else "@@", end="")

def render(i, data):
    n = 8 if i < 0o70 else 7
    print(8 * 9 * "_")

    word1 = n*[0]
    word2 = n*[0]
    for j in range(i, i+n):
        o = f"{j:02o}"
        print(f"{o:9s}", end="")
        word1[j-i] = int(data[2*j], 8)
        word2[j-i] = int(data[2*j+1], 8)
    print("")
        
    for i in range(6):
        for j in range(n):
            pixel(word1[j] & 0o40)
            pixel(word1[j] & 0o4000)
            word1[j] = word1[j] << 1
            pixel(word2[j] & 0o40)
            pixel(word2[j] & 0o4000)
            word2[j] = word2[j] << 1
            print("|", end="")
        print("")


if __name__ == "__main__":
    with open(sys.argv[1]) as f:
        data = f.readlines()
        for i in range(0, 0o77, 8):
            render(i, data)
    print(7 * 9 * "_")
