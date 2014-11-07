#!/usr/bin/env python3

import sys, codecs

sys.stdout = codecs.getwriter("utf-8")(sys.stdout.detach())

with open("AutoHotkey/src/digraph.txt", encoding="utf-8") as f:
    sep = ''
    print("digraphMap := {}")
    for line in f:
        if not line.strip() or line[0] == '#':
            continue
        parts = line.split('\t')
        digraph, code, remark = parts[1], int(parts[3]), parts[4].strip()
        digraph = digraph.replace('"', '""')
        if 32 <= code and not (127 <= code < 160):
            print('digraphMap["{0}"] := {1} ; U+{1:04X} {2}'.format(digraph, code, remark))
