#!/usr/bin/python
from sys import argv
import os

result = {}
files = os.listdir("files/")
files = [filename for filename in files if filename.contains(".reduce")]
fout = open(argv[1],"w")

def process_line(line,result):
  [word,countStr] = line.split(",")
  count = int(countStr)
  try:
    result[word]+=count
  except KeyError:
    result.update({word:count})

i=2
while(i):
  try:
    fin = open(argv[i],"r")
    i+=1
    for line in fin.readlines():
      process_line(line,result)
    fin.close()
  except IndexError:
    break

for key,value in result.items():
  #fout.write(key + "," + str(value)+"\n")
  print key + "," + str(value)
fout.close()
