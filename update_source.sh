#!/bin/sh

unpacker="../IPFUnpacker/ipf_unpacker.exe"
tos_path="$(cygpath "C:\Program Files (x86)\Steam\steamapps\common\TreeOfSavior")"

mkdir -pv ipf core

declare -x IFS=$'\n'

for ipf in $(find "$tos_path"/data -iname '*.ipf'); do
    file="$(basename "$ipf")"
    if [ ${file:0:1} != "_" ]; then
        if ! cmp -s -n 6000000 "$ipf" ipf/$file; then
            cp -fv "$ipf" ipf/$file
        else
            echo "$file already updated."
        fi
    fi
done

unset IFS

for file in $(find ipf -iname '*.ipf'); do
    $unpacker --decrypt $file core
    $unpacker --extract $file core
    $unpacker --encrypt $file core
done

echo Done.

exit 0