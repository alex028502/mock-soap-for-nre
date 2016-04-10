#!/usr/bin/env bash
# This is not in python or ruby since it is used outside docker
# container so better to avoid more dependencies

while read line
do
  if [[ $line == \!* ]] ;
  then
    >&2 echo cannot translate \! from .gitignore
    exit 1
  fi

  if [[ $line == /* ]] ;
  then
    echo $line
  else
    echo "/**/$line"
  fi
done < /dev/stdin
