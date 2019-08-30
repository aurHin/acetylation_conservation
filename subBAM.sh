#!/bin/sh

#SBATCH --time=00:10:00
#SBATCH --partition=debug-EL7
#SBATCH --mail-type=END, FAIL

module load GCC/7.3.0-2.30 OpenMPI/3.1.1 SAMtools/1.9

samtools view -s 0.25 -b CTCF_E105_PT_rep1_mapping.bam > CTCF_E105_PT_rep1_mapping_025.bam

