#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 </path/to/dir>"
    exit 1
fi

abs_path=$PWD/$1

if ! [ -d $abs_path ]; then
    echo "No such directory -> $abs_path"
    exit 1
fi

data=$(ls -l $PWD/$1 | awk '{if (NR > 1) printf "%s:%s:%s\n", $3, $4, $9}')

for val in $data; do
    user=$(echo $val | awk -F: '{print $1}')
    group=$(echo $val | awk -F: '{print $2}')
    file=$(echo $val | awk -F: '{print $3}')
    user_dir=$PWD/$1/$user
    if ! [ -d $user_dir ]; then
        mkdir $user_dir
    fi
    echo "Coping $PWD/$1/$file to $user_dir"
    cp $PWD/$1/$file $user_dir/ && sudo chown -R $user:$group $user_dir/
done
