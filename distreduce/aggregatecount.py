#!/usr/bin/python
from sys import argv
import os

result = {}
files = os.listdir("files/")
files = ["files/"+filename for filename in files if ".reduce" in filename]
fout = open(argv[1],"w")

def process_line(line,result):
  [word,countStr] = line.split(",")
  count = int(countStr)
  try:
    result[word]+=count
  except KeyError:
    result.update({word:count})

for f in files:
  fin = open(f,"r")
  for line in fin.readlines():
    process_line(line,result)
  fin.close()

for key,value in result.items():
  fout.write(key + "," + str(value)+"\n")
  #print key + "," + str(value)
fout.close()
