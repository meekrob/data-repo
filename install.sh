#!/usr/bin/env bash
SRC_NAME="datadir.sh"
TARGET="init-data-repo"
writeable_paths=()
i=1
echo "Choose install path:"
for path in ${PATH//:/ }
do
    if [ -w $path ]
    then
        echo -e "\t$i) $path"
        writeable_paths+=($path)
        i=$((i+1))
    fi
done

nwriteable=${#writeable_paths[*]}

if [ $nwriteable -eq 0 ] 
then
    echo "You have no writeable paths in your \$PATH variable... Cannot install/" 1>&2
    exit 1
fi

while read -p "Choose a destination for executable [1 - $nwriteable] : " user
do
    echo "$user"
    numtest=$(($user + 0)) # if user enters a non-castable string, the result is 0
    if [ "$numtest" -eq 0 ] || [ "$numtest" -gt $nwriteable ]
    then
        echo "Please enter a number between 1 - $nwriteable"
        continue
    fi

    # user input is valid
    arrind=$(($user - 1))
    echo "You chose ${writeable_paths[$arrind]}"
    break
done
