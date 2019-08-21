#!/usr/bin/env python3
from pprint import pprint
import os, json, uuid
from shutil import copyfile

dir = "/usr/share/snips/assistant/"
filename = dir + 'assistant.json'
copyfile(filename, filename + '.bak')
with open(filename, 'r') as f:
    data = json.load(f)
    data['language'] = 'pl'
    f.close()

with open(filename, 'w') as f:
    json.dump(data, f, indent=2)

