#!/bin/bash

inputFolder="$1"
#/Users/Hintermann/Desktop/LAB/CompSeqFonc/analyseMacs2_201909/tests/tryPlot
regionsForQuantif="$2"
#"/Users/Hintermann/Desktop/LAB/genomicData/genomicData_mm10/regionsForQuantif_HoxD.bed"

r_plot_script="/Users/Hintermann/Desktop/LAB/CompSeqFonc/macs2peaksAndConservation/Plot_acetylation_201907.R"

cd "$inputFolder"
for i in $(find *.bed); do
echo "$i"
Rscript "$r_plot_script" "$i" "$regionsForQuantif"
done
