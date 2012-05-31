#!/bin/sh

#take care of the mapper args
while [ $# -gt 0 ]; do
  case $1 in
    -location)          location=$2;;
    -padding)           padding=$2;;
    -prefix)            prefix=$2;;
    -suffix)            suffix=$2;;
    -mod_index)         mod_index=$2;;
    -outer_index)       outer_index=$2;;
    *) echo "$0: bad mapper args" 1>&2
       exit 1;;
  esac
  shift 2
done

for i in `seq 0 ${outer_index}`
do
 for j in `seq -w 000 ${mod_index}`
 do
  fj=`echo ${j} | awk '{print $1 +0}'` #format j by removing leading zeros
  echo "["${i}"]["${fj}"]" ${location}"/"${prefix}${j}${suffix}
 done
done
