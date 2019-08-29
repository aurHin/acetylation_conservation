#!/bin/bash

inputFolder="/Users/Hintermann/Desktop/LAB/CompSeqFonc/macs2_test"

for i in $(find "$inputFolder"/*.bed); do
filename=$(basename -- "$i" .bed)
echo "$filename"
done


