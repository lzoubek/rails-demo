#!/bin/bash

url=$1
if [ -z $url ];
then
  url="http://localhost:3000/products"
fi
cmd="wget $url -O /dev/null"


if [ -t 0 ]; then stty -echo -icanon -icrnl time 0 min 0; fi

count=0
keypress=''
while [ "x$keypress" = "x" ]; do
    let count+=1
    $cmd
    sleep 10s
      echo -ne $count'\r'
        keypress="`cat -v`"
      done

      if [ -t 0 ]; then stty sane; fi

      echo "You pressed '$keypress' after $count loop iterations"
      echo "Thanks for using this script."
      exit 0
