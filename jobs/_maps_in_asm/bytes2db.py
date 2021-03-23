#!/usr/bin/python
""" Convert Frantic JOB binaries into asm files
use:
    python bytes2db.py input output
"""

import sys

def chunks(lst, n):
    """Yield succesive n-sized chunks from lst."""
    for i in range(0, len(lst), n):
        yield lst[i:i + n]

file_in = sys.argv[1]
file_out = sys.argv[2]
bytelist = []
with open(file_in, 'rb') as f:
    while 1:
        byte = f.read(1)
        if not byte:
            break
        bytelist.append(("0"+byte.hex()+"H").upper())

with open(file_out, 'wt') as f:
    f.write("; BLOAD header\n")
    f.write("\tDB ")
    for i, val in enumerate(bytelist[:7]):
        f.write(val)
        if i<len(bytelist[:7])-1:
            f.write(", ")
    f.write("\n\n")
    f.write("; Map data, 768 rows of 16x16 bitmaps\n")
    data = list(chunks(bytelist[7:], 16))
    for r, row in enumerate(data):
        f.write("\tDB ")
        for c, col in enumerate(row):
            f.write(col)
            if c<len(row)-1:
                f.write(", ")
        f.write(" ; row "+str(r+1)+"\n")