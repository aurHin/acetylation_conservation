#!/bin/bash
inputFolder="$1"
#/Users/Hintermann/Desktop/LAB/ChIP/conservedSeqAndAc_mm_gg_PT_skin/B_PT_WP_Skin_CTCF/H3K27ac_mm10/bed4colnoTSS_noBrain

CNS_file="$2"
#/Users/Hintermann/Desktop/LAB/genomicData/genomicData_mm10/SortBed_on_MAF_to_BED_on_gG6_mm10_mm10_nonCoding.bed"

outputFolder="macs2_OL_CNS"
cd "$inputFolder"
mkdir -p "$outputFolder"

printf "\n#########\n\nSTART LOOP \n"

for i in $(find *.bed); do
  filename=$(basename -- "$i" .bed)
  output_basicname="$outputFolder"/"$filename"
  bedtools annotate -counts -i "$i" -files "$CNS_file" > "$output_basicname"_annotCNS.bed

  printf "\nNew file saved under:\n$output_basicname"_annotCNS.bed"\n"

done

printf "\nFINISH LOOP\n\n#########\n\n"
