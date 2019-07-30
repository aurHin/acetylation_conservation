#!/bin/bash

# GENOME WIDE original macs2 files, narrowPeak format
inputFolder="/Users/Hintermann/Desktop/LAB/ChIP/conservedSeqAndAc_mm_gg_PT_skin/B_PT_WP_Skin_CTCF/H3K27ac_gG6/bed4col_resizeAndNoTSS"

# Folder with two output files per input file: noBrain50 ; noBrain150
outputFolder="bed4colnoTSS_noBrain"
cd "$inputFolder"
cd ../
mkdir -p "$outputFolder"

# Brain files
Brain="/Users/Hintermann/Desktop/LAB/ChIP/conservedSeqAndAc_mm_gg_PT_skin/B_PT_WP_Skin_CTCF/H3K27ac_gG6/bed4col_resizeAndNoTSS/H3K27_HH35_Brain_r1_macs2narrowPeak_nonTSS.bed"
Brain_resize="/Users/Hintermann/Desktop/LAB/ChIP/conservedSeqAndAc_mm_gg_PT_skin/B_PT_WP_Skin_CTCF/H3K27ac_gG6/bed4col_resizeAndNoTSS/H3K27_HH35_Brain_r1_macs2narrowPeak_resizeAndMerged_nonTSS.bed"

for i in $(find "$inputFolder"/*eak_res*.bed); do

  filename=$(basename -- "$i" .bed)
  output_basicname="${outputFolder}/$filename"

  #subtract brain from resize

  bedtools intersect -a "$i" -b "$Brain_resize" -v > "$output_basicname"_noBrain.bed

  echo "$output_basicname"_noBrain.bed written

done

for j in $(find "$inputFolder"/*eak_non*.bed); do

  filename=$(basename -- "$j" .bed)
  output_basicname="$outputFolder"/"$filename"

  #subtract brain from file

  bedtools intersect -a "$j" -b "$Brain" -v > "$output_basicname"_noBrain.bed
  echo "$output_basicname"_noBrain.bed written

done
