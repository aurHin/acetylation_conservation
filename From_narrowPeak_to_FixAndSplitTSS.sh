#!/bin/bash

inputFolder=$1 #Folder with GENOME WIDE original macs2 files, narrowPeak format
#/Users/Hintermann/Desktop/LAB/CompSeqFonc/macs2

TSSbed=$2 #bed file with TSS coordinates
#/Users/Hintermann/Desktop/LAB/genomicData/genomicData_mm10/mm10_all_TSS_2kbminus500bpplus.bed

chromSizes=$3
#/Users/Hintermann/Desktop/LAB/genomicData/genomicData_mm10/mm10.chrom.sizes

#Folder with two output files per input file: 4col_noTSS ; 4col_resized_noTSS
outputFolder="bed4col_resizeAndNoTSS"
cd "$inputFolder"
cd ..
mkdir -p "$outputFolder"

printf "\n#########\n\nSTART LOOP \n"

for i in $(find "$inputFolder"/*.bed); do

  filename=$(basename -- "$i" .bed)
  output_basicname="${outputFolder}/$filename"

  # Step1 - reformat narrow peak format to 4 columns bed format
  awk -F $'\t' 'BEGIN {OFS = FS} {{print $1,$2,$3,$4}}' "$i" > "$output_basicname"_4col.bed
  # In linux, I would do:
  # cat "$i" | cut -f 1-4 > "$output_basicname"_4col.bed

  # Step2 - get intervals that do not overlap promoters.
  bedtools intersect -a "$output_basicname"_4col.bed -b "$TSSbed" -v > "$output_basicname"_nonTSS.bed

  # Step3 - center on summit. Change start and end to summit coordinates.
  awk -F $'\t' 'BEGIN {OFS = FS} {{print $1,$2+$10,$2+$10,$4}}' "$i" > "$output_basicname"_summit.bed

  # Step4 - resize and merge intervals. Advantage to use slop from bedtools, you do not get negative values.
  bedtools slop -i "$output_basicname"_summit.bed -g "$chromSizes" -b 1000 > "$output_basicname"_resize.bed
  bedtools merge -i "$output_basicname"_resize.bed > "$output_basicname"_resizeAndMerged.bed

  # Step5 - get intervals that do not overlap promoters AFTER resizing.
  bedtools intersect -a "$output_basicname"_resizeAndMerged.bed -b "$TSSbed" -v > "$output_basicname"_resizeAndMerged_nonTSS.bed

  # Step6 - remove temporary files.
  
  rm "$output_basicname"_summit.bed
  rm "$output_basicname"_resize.bed
  rm "$output_basicname"_resizeAndMerged.bed
  
  printf "\nNew files saved under:\n$output_basicname"_nonTSS.bed"and\n$output_basicname"_resizeAndMerged_nonTSS.bed"\n"

done

printf "\nFINISH LOOP\n\n#########\n\n"
