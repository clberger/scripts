#!/bin/bash

while [ $# -gt 0 ]; do
  case $1 in
    -script)          script=$2;;
    -aggregate)       aggregate=$2;;
    -results)         results=$2;;
    -mapfn)           mapfn=$2;;
    -reducefn)        reducefn=$2;;
    -combinefn)       combinefn=$2;;
    -shellscr)        shellscr=$2;;
    -nnodes)          nnodes=$2;;
    *) echo "$0: bad args" 1>&2
       exit 1;;
  esac
  shift 2
done

for i in `seq 0 ${nnodes}`
do
  new_red_fn=`echo ${reducefn} | awk '{print $1 $i ".py"}'`
  cp ${reducefn} ${new_red_fn}
done
swift ${script} -reducefn ${reducefn}
python ${aggregate} ${results}
