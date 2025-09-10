#!/usr/bin/env bash
set -eu -o pipefail

INSTALL_PATH_FILE="INSTALL.PATH"
SRC="datadir.sh"
TARGET="init-data-repo"

# treat this as a global to be set in the subfunction
INSTALL_PATH=""

select_writeable_path() {
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

    while read -p "Choose a destination for executable [1 - $nwriteable]: " user
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
        INSTALL_PATH=${writeable_paths[$arrind]}        
        break
    done
}


if [ -e "$INSTALL_PATH_FILE" ]
then
    echo -n "Reading INSTALL_PATH_FILE:$INSTALL_PATH_FILE: "
    pre_existing_path=$(cat $INSTALL_PATH_FILE) 
    echo $pre_existing_path

    if [ -w "$pre_existing_path" ]
    then 
        echo "$INSTALL_PATH_FILE lists $pre_existing_path as your install location. Do you wish to change it?"
        while read -p "Change install path? [y|n]: " user_continue
        do
            case "$user_continue" in
                [Yy])
                    select_writeable_path         # sets global variable INSTALL_PATH
                    echo "Selected $INSTALL_PATH"   # <- this is the global variable
                    cat $INSTALL_PATH_FILE >> .old.$INSTALL_PATH_FILE
                    rm $INSTALL_PATH_FILE 
                    echo $INSTALL_PATH > $INSTALL_PATH_FILE
                    break
                    ;;
                [Nn])
                    INSTALL_PATH="$pre_existing_path"
                    echo "OK, keeping current setting: $INSTALL_PATH"
                    break
                    ;;
            esac
        done
    fi
else
    select_writeable_path         # sets global variable INSTALL_PATH
    echo "Selected $INSTALL_PATH"   # <- this is the global variable
    echo $INSTALL_PATH > $INSTALL_PATH_FILE
fi


if [ -z "$INSTALL_PATH" ]
then 
    echo "Failed to set \$INSTALL_PATH (zero length)." 1>&2
    exit 1
fi

TARGET_PATH="$INSTALL_PATH/$TARGET"
if [ -e "$TARGET_PATH" ] && [ "$SRC" -nt "$TARGET_PATH" ]
then
    cp -v $SRC "$TARGET_PATH" && chmod 755 "$TARGET_PATH"
else
    echo "Source is not newer than Destination. Nothing done."
fi
