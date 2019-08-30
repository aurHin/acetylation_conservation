#!/bin/bash

inputFolder=$1 #Folder with GENOME WIDE original macs2 files, narrowPeak format
#/Users/Hintermann/Desktop/LAB/CompSeqFonc/macs2

TSSbed=$2 #bed file with TSS coordinates
#/Users/Hintermann/Desktop/LAB/genomicData/genomicData_mm10/mm10_all_TSS_2kbminus500bpplus.bed

chromSizes=$3
#/Users/Hintermann/Desktop/LAB/genomicData/genomicData_mm10/mm10.chrom.sizes

outputFolder="resizeAndMerge_nonTSS"
cd "$inputFolder"
cd ..
mkdir -p "$outputFolder"

printf "\n#########\n\nSTART LOOP \n"

for i in $(find "$inputFolder"/*.bed); do

  filename=$(basename -- "$i" .bed)
  output_basicname="${outputFolder}/$filename"  

  # Step1 - center on summit. Change start and end to summit coordinates.
  awk -F $'\t' 'BEGIN {OFS = FS} {{print $1,$2+$10,$2+$10,$4}}' "$i" > "$output_basicname"_summit.bed
 
  # Step2 - resize and merge intervals. Advantage to use slop from bedtools, you do not get negative values.
  bedtools slop -i "$output_basicname"_summit.bed -g "$chromSizes" -b 1000 > "$output_basicname"_resize.bed
  bedtools merge -i "$output_basicname"_resize.bed > "$output_basicname"_resizeAndMerged.bed

  # Step3 - get intervals that do not overlap promoters AFTER resizing.
  bedtools intersect -a "$output_basicname"_resizeAndMerged.bed -b "$TSSbed" -v > "$output_basicname"_resizeAndMerged_nonTSS.bed

  # Step4 - remove temporary files.
  
  rm "$output_basicname"_summit.bed
  rm "$output_basicname"_resize.bed
  rm "$output_basicname"_resizeAndMerged.bed
  
  printf "\nNew file saved under:\n$output_basicname"_resizeAndMerged_nonTSS.bed"\n"

done

printf "\nFINISH LOOP\nOutput files are 3-columns-bed files\n\n#########\n\n"
