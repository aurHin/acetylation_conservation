#!/bin/bash
inputFolder="/Users/Hintermann/Desktop/LAB/ChIP/conservedSeqAndAc_mm_gg_PT_skin/B_PT_WP_Skin_CTCF/H3K27ac_mm10/bed4colnoTSS_noBrain"

CNS_file="/Users/Hintermann/Desktop/LAB/genomicData/genomicData_mm10/SortBed_on_MAF_to_BED_on_gG6_mm10_mm10_nonCoding.bed"

cd "$inputFolder"

for i in $(find "$inputFolder"/*.bed); do

filename=$(basename -- "$i" .bed)
echo "$filename"
bedtools intersect -a "$i" -b "$CNS_file" -wa > "$filename"_onCNS.bed

Rscript /Users/Hintermann/Desktop/LAB/Bioinfo/AddConservationColumnTomacs2.R "$i" "$filename"_onCNS.bed

done
