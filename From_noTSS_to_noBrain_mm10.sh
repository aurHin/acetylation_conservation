#!/bin/bash

#GENOME WIDE original macs2 files, narrowPeak format
inputFolder="/Users/Hintermann/Desktop/LAB/ChIP/conservedSeqAndAc_mm_gg_PT_skin/B_PT_WP_Skin_CTCF/H3K27ac_mm10/bed4col_resizeAndNoTSS/Tissues"

#Folder with two output files per input file: noBrain50 ; noBrain150
outputFolder="bed4colnoTSS_noBrain"
cd "$inputFolder"
cd ../../
mkdir -p "$outputFolder"

# Brain files
Br150="/Users/Hintermann/Desktop/LAB/ChIP/conservedSeqAndAc_mm_gg_PT_skin/B_PT_WP_Skin_CTCF/H3K27ac_mm10/bed4col_resizeAndNoTSS/Brain/H3K27ac_E125_B_r1_150mio_macs2narrowPeak_nonTSS.bed"
Br150_resize="/Users/Hintermann/Desktop/LAB/ChIP/conservedSeqAndAc_mm_gg_PT_skin/B_PT_WP_Skin_CTCF/H3K27ac_mm10/bed4col_resizeAndNoTSS/Brain/H3K27ac_E125_B_r1_150mio_macs2narrowPeak_resizeAndMerged_nonTSS.bed"
Br50="/Users/Hintermann/Desktop/LAB/ChIP/conservedSeqAndAc_mm_gg_PT_skin/B_PT_WP_Skin_CTCF/H3K27ac_mm10/bed4col_resizeAndNoTSS/Brain/H3K27ac_E125_B_r1_macs2narrowPeak_nonTSS.bed"
Br50_resize="/Users/Hintermann/Desktop/LAB/ChIP/conservedSeqAndAc_mm_gg_PT_skin/B_PT_WP_Skin_CTCF/H3K27ac_mm10/bed4col_resizeAndNoTSS/Brain/H3K27ac_E125_B_r1_macs2narrowPeak_resizeAndMerged_nonTSS.bed"

for i in $(find "$inputFolder"/*eak_res*.bed); do

filename=$(basename -- "$i" .bed)
output_basicname="$outputFolder"/"$filename"

#subtract brain from resize
echo "$filename"

bedtools intersect -a "$i" -b "$Br150_resize" -v > "$output_basicname"_noBrain150.bed
bedtools intersect -a "$i" -b "$Br50_resize" -v > "$output_basicname"_noBrain50.bed
done

for j in $(find "$inputFolder"/*eak_non*.bed); do

filename=$(basename -- "$j" .bed)
output_basicname="$outputFolder"/"$filename"

#subtract brain from file
echo "$filename"

bedtools intersect -a "$j" -b "$Br150" -v > "$output_basicname"_noBrain150.bed
bedtools intersect -a "$j" -b "$Br50" -v > "$output_basicname"_noBrain50.bed

done
