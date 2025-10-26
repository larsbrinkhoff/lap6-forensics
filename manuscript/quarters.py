#!/usr/bin/env python3

import re, sys

image = [0] * 2048


def oct(x):
    return int(x, 8)


def parse(line):
    m = re.compile(r'^([0-7][0-7][0-7][0-7]) ([0-7][0-7][0-7][0-7])$').match(line)
    if m:
        addr = oct(m.group(1))
        data = oct(m.group(2))
        image[addr] = data


if __name__ == "__main__":
    start = oct(sys.argv[1]) * 0o400
    if len(sys.argv) > 2:
        end = oct(sys.argv[2]) * 0o400
    else:
        end = start + 0o400

    for line in sys.stdin:
        parse(line)

    for i in range(start, end):
        x1 = image[i] & 0xFF
        x2 = image[i] >> 8
        sys.stdout.buffer.write(bytes([x1, x2]))
