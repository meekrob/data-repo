#!/usr/bin/env bash
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
    preexisting_path=$(cat $INSTALL_PATH_FILE) 
    if [ -n -w "$preexisting_path" ]
    then 
        echo "$INSTALL_PATH_FILE lists $preexisting_path as your install location. Do you wish to change it?"
        while read -p "Change install path? [(Yyes|Nno)]: " user_continue
        do
            case "$user_continue" in
                [Yy]|[Yy][Ee][Ss])
                    select_writeable_path()         # sets global variable INSTALL_PATH
                    echo "Selected $INSTALL_PATH"   # <- this is the global variable
                    cat $INSTALL_PATH_FILE >> .old.$INSTALL_PATH_FILE
                    rm $INSTALL_PATH_FILE 
                    echo $INSTALL_PATH > $INSTALL_PATH_FILE
                    break
                    ;;
                [Nn]|[Nn][Oo])
                    INSTALL_PATH="$preexisting_path"
                    echo "OK, keeping current setting: $INSTALL_PATH"
                    ;;
            esac
        done
    fi
fi

cp -v $SRC $INSTALL_PATH/$TARGET && chmod 755 $INSTALL_PATH/$TARGET
