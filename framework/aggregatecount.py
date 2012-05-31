#!/usr/bin/python
from sys import argv

result = {}

def process_line(line,result):
  [word,countStr] = line.split(",")
  count = int(countStr)
  try:
    result[word]+=count
  except KeyError:
    result.update({word:count})

i=1
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
  print key + "," + str(value)

