#!/bin/bash

# written by Michael Maier (s.8472@aon.at)
# 
# 19.02.2014   - intial release
#

# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# version 2 as published by the Free Software Foundation.

###
### Standard help text
###

#if [ ! "$1" ] || [ "$1" = "-h" ] || [ "$1" = " -help" ] || [ "$1" = "--help" ]
if  [ "$1" = "-h" ] || [ "$1" = " -help" ] || [ "$1" = "--help" ]
then 
cat <<EOH
Usage: $0 [OPTIONS] 

$0 is a program to check OGD sources for updates - to finally add it to this repository

OPTIONS:
   -h -help --help     this help text

EOH
fi

###
### variables
###

file_url_ending="\.url"
wfs_url_ending="\.wfsurl"

###
### working part
###


find . -maxdepth 1 -type d | while read -r line
do
  if [ "$line" = "." ]; then
    continue;
  fi
  echo "FOLDER: „$line“"

  cd "$line"

  urlfile=`ls -1 | grep "$file_url_ending\$"`
  #echo "urlfile(s): „$urlfile“"

  if [ "$urlfile" ]; then
    echo "$urlfile" | while read -r urlfilename
      do
        url=`cat "$urlfilename"`
        echo "Downloading file „$urlfilename“ from „$url“"
        wget -q -N $url
        if echo "${urlfilename%%.url}" | grep -q "zip$"; then
          cd Rohdaten
          echo "unzipping ${urlfilename%%.url}"
          unzip -f -o ../${urlfilename%%.url}
          cd ..
        fi
      done
  fi

  wfsurlfile=`ls -1 | grep "$wfs_url_ending\$"`
  if [ "$wfsurlfile" ]; then
    echo "$wfsurlfile" | while read -r urlfilename
      do
        url=`cat "$urlfilename"`
        echo "Downloading wfs „$urlfilename“ from „$url“"
        if [ -e "${urlfilename%%.wfsurl}.geojson" ]; then
          mv ${urlfilename%%.wfsurl}.geojson ${urlfilename%%.wfsurl}.geojson.tmp
        fi
        ogr2ogr -f GeoJSON ${urlfilename%%.wfsurl}.geojson "$url" OGRGeoJSON -gt 1000
        if [ -e "${urlfilename%%.wfsurl}.geojson.tmp" ]; then
          if [ "$(diff ${urlfilename%%.wfsurl}.geojson.tmp ${urlfilename%%.wfsurl}.geojson | head)" ]; then
            datestring="$(date '+%T')-save"
            mv ${urlfilename%%.wfsurl}.geojson.tmp ${urlfilename%%.wfsurl}.geojson.$datestring
            echo "change in ${urlfilename%%.wfsurl}.geojson detected, backuped to ${urlfilename%%.wfsurl}.geojson.$datestring"
          else
            rm ${urlfilename%%.wfsurl}.geojson.tmp
            echo "${urlfilename%%.wfsurl}.geojson not changed"
          fi
        fi
      done
  fi

  cd ..

done

# git add -u
# git commit -m "data update"
