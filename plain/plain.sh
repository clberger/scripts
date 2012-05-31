#!/bin/bash

while [ $# -gt 0 ]; do
  case $1 in
    -script)          script=$2;;
    -aggregate)       aggregate=$2;;
    -results)         results=$2;;
    *) echo "$0: bad args" 1>&2
       exit 1;;
  esac
  shift 2
done

swift ${script}
python ${aggregate} ${results}
