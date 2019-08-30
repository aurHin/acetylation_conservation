#!/bin/bash

# GENOME WIDE original macs2 files, narrowPeak format
inputFolder="$1"
#/Users/Hintermann/Desktop/LAB/CompSeqFonc/analyseMacs2_201909/gg/bed4col_resizeAndNoTSS/H3K27ac

# Negative tissue file to substract
negFile="$2"
#/Users/Hintermann/Desktop/LAB/CompSeqFonc/analyseMacs2_201909/gg/bed4col_resizeAndNoTSS/H3K27ac/H3K27ac_HH35_Brain_r1_macs2narrowPeak_resizeAndMerged_nonTSS.bed

outputFolder="$inputFolder"_negSubtracted
cd "$inputFolder"
cd ../
mkdir -p "$outputFolder"

printf "\n#########\n\nSTART LOOP \n"

for i in $(find "$inputFolder"/*.bed); do

  filename=$(basename -- "$i" .bed)
  output_basicname="$outputFolder"/"$filename"

  #subtract brain from resize
  bedtools intersect -a "$i" -b "$negFile" -v > "$output_basicname"_negSubtracted.bed
  
  printf "\nNew file saved under:\n$output_basicname"_negSubtracted.bed"\n"
  
done

printf "\nFINISH LOOP\n\n#########\n\n"

printf "CLEAN\n\nEmpty file erased:\n$outputFolder"/$(basename -- "$2" .bed)_negSubtracted.bed"\n"
rm "$outputFolder"/$(basename -- "$2" .bed)_negSubtracted.bed

printf "\n#########\n\n"
