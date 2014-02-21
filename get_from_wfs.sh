#!/bin/bash

# written by Michael Maier (s.8472@aon.at)
# 
# 20.02.2014   - intial release
#

# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# version 2 as published by the Free Software Foundation.

###
### Standard help text
###

#if [ ! "$1" ] || [ "$1" = "-h" ] || [ "$1" = " -help" ] || [ "$1" = "--help" ]
if [ "$1" = "-h" ] || [ "$1" = " -help" ] || [ "$1" = "--help" ]
then 
cat <<EOH
Usage: $0 [OPTIONS] 

$0 is a program to download WFS data to geojson file

OPTIONS:
   -h -help --help     this help text

EOH
fi

###
### variables
###

filename=baum

lasturlpart="query?where=objectid+%3D+objectid&outfields=*&returnGeometry=true&f=json"

#numbers:
# 0 Baumkataster
# 1 Baumkataster Holding
# Umwelt (2)
# Getrennte Abfallsammelstellen (3)
# Problemstoff - Sammelstellen (4)
# Giftmuellexpress - Standorte (5)
# Christbaum - Sammelstellen (6)
# Infrastruktur (7)
# Zivilschutzsirenen (8)
# Schutzzonen und Denkmale (9)
# Naturdenkmale (10)
# Verkehr (11)
# Behindertenparkplaetze (12)
# Verwaltungseinheiten (13)
# Stadtgrenze (14)
# Bezirksgrenzen (15)
# Zaehlsprengel (16)
# Wahlsprengel (17)
# Wahlsprengel 2009 (18)
# Wahlsprengel 2013 (19)
# Oeffentliche Brunnen (20)
# Papierkoerbe (21)

number=1

GRAZURL="http://geodaten1.graz.at/ArcGIS_Graz/rest/services/Extern/OGD_WFS/MapServer/"
#GRAZ: http://geodaten1.graz.at/ArcGIS_Graz/rest/services/Extern/OGD_WFS/MapServer/

EXAMPLE_URL="http://geodata.epa.gov/arcgis/rest/services/OAR/USEPA_NEI_2005/MapServer/1/query?where=objectid+%3D+objectid&outfields=*&f=json"

URL="$GRAZURL/$number/$lasturlpart"

###
### working part
###

#ogr2ogr -f GeoJSON $filename.geojson "$URL" OGRGeoJSON -gt 1000

for i in 1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21; do
  URL="$GRAZURL/$i/$lasturlpart"
  ogr2ogr -f GeoJSON $i.geojson "$URL" OGRGeoJSON -gt 1000
done
#ogr2ogr shapefile/ $number.geojson
