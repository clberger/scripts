#!/usr/bin/python
import re
from sys import argv

fin = open(argv[1],"r+")

words = {}
for raw in fin.read().split():
  word=re.search('\w+',raw)
  try:
    match=word.group(0)
    try:
      words[match]+=1
    except KeyError:
      words.update({match:1})
  except AttributeError:
    pass
fin.close()

for key,value in words.items():
  print key + "," + str(value)
