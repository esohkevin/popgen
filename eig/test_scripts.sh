#!/bin/bash

#while read -p "Enter two numnbers ( - 1 to quit ) : " a b; do if [ $a -eq -1 ]; then break; fi; ans=$(( a + b )); echo $ans; done

file=EIGENSTRAT/var_colnum.txt

while read -r line; do
  echo $line
done < "$file"

