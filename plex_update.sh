#!/bin/bash

plex_url="http://<url>"
token="<token>"
zurg_mount="/mnt/realdebrid"
section_ids=$(curl -sLX GET "$plex_url/library/sections" -H "X-Plex-Token: $token" | xmllint --xpath "//Directory/@key" - | grep -o 'key="[^"]*"' | awk -F'"' '{print $2}')
for arg in "$@"
do
    parsed_arg="${arg//\\}"
    echo $parsed_arg
    modified_arg="$zurg_mount/$parsed_arg"
    echo "detected update on: $arg"
    echo "absolute path: $modified_arg"
    for section_id in $section_ids
    do
        echo "Section ID: $section_id"
        curl -G -H "X-Plex-Token: $token" --data-urlencode "path=$modified_arg" $plex_url/library/sections/$section_id/refresh
    done
done
echo "all updated sections refreshed"
