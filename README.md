# macs2peaksAndConservation
Input files:
- conservation bed files (adapted from MAF). Here mouse mm10 vs chicken galGal6. See *Prepare conservation files*
- macs2 narrowPeak files from ChIP-seq experiment. See *Prepare macs2narrowPeak files* 

## Prepare conservation files
**From MAF files to genome-wide non-coding (we are interest in enhancers) bed conservation file. (2 species max)**

### get conservation files

UCSC > galGal6 > Conservation > PhastCons > Parent directory > galGal6vsMm10
galGal6.mm10.synNet.maf.gz - filtered net file for syntenic alignments
               only, in MAF format, see also, description of MAF format:
               http://genome.ucsc.edu/FAQ/FAQformat.html#format5
 
### format conservation files

To have the syntenic conserved regions, transform galGal6.mm10.synNet.maf.gz to be with galaxy tool *"MAF to BED"*.

    python '/slipstream/galaxy/production/galaxy-dist/tools/maf/maf_to_bed.py' '/slipstream/galaxy/production/data/files/090/dataset_90288.dat' '/slipstream/galaxy/production/data/files/090/dataset_90303.dat' 'galGal6,mm10' partial_allowed '.' '105592'

Need to sort the file, use Galaxy *SortBed*. (To later use bedtools or other tools)

    sortBed -i '/slipstream/galaxy/production/data/files/090/dataset_90303.dat'  > '/slipstream/galaxy/production/data/files/090/dataset_90308.dat'

### select Conserved Non-coding Sequences (CNS) from Conserved Sequences (CS)
To get CNS, use *bedtools* locally.

mm10
  
    bedtools intersect -a /Users/Hintermann/Desktop/LAB/genomicData/genomicData_mm10/SortBed_on_MAF_to_BED_on_gG6_mm10_mm10.bed -b /Users/Hintermann/Desktop/LAB/genomicData/genomicData_mm10/genomeWide_ncbiRefSeq_mm10.bed -v > /Users/Hintermann/Desktop/LAB/genomicData/genomicData_mm10/SortBed_on_MAF_to_BED_on_gG6_mm10_mm10_nonCoding.bed 
    
gg6

    bedtools intersect -a /Users/Hintermann/Desktop/LAB/genomicData/genomicData_galGal6/SortBed_on_MAF_to_BED_on_gG6_mm10_galGal6.bed -b /Users/Hintermann/Desktop/LAB/genomicData/genomicData_galGal6/genomeWide_ncbiRefSeq_gg6.bed -v > /Users/Hintermann/Desktop/LAB/genomicData/genomicData_galGal6/SortBed_on_MAF_to_BED_on_gG6_mm10_galGal6_nonCoding.bed 

>chr1	682789	682876	galGal6_52	0	+

>chr1	1116484	1116563	galGal6_63	0	+

>chr1	1161041	1161284	galGal6_74	0	+

>chr1	1233110	1233357	galGal6_111	0	+

*Note: galGal_74 is the orthologuous conserved element of mm10_74.

## Prepare macs2narrowPeak files

**Compare different tracks of macs2 peaks from ChIP-seq, without or without comparison with sequence conservation.**
Verify that your different data sets have a comparable nunber of reads. If it is not the case, subset the ones having more reads with samtools view. (Use unige Baobab)
To directly use te MACS2 callpeak tool, take MAPQ30 filter mapping bam, not the mapping bam, otherwise you have to repeat filtering. 

    samtools view -s 0.25 -b CTCF_E105_PT_rep1_MAPQ30.bam > CTCF_E105_PT_rep1_mapping_025.bam


### Format peak files

*From_narrowPeak_to_FixAndSplitTSS.sh*

Takes one input file *narrowPeak.bed*, gives two outputfiles: *noTSS.bed* ; *resizedAndMerge_noTSS.bed*

* resize narrowPeak to 2 kb (1kb on each side of the summit)
* merge intervals that overlap due to resizing 
* get intervals that do not overlap promoters AFTER resizing

note: the output is a bed file with only 3 columns after resize and merge
  
### Subtract negative tissue from positive one
note: if you mixed different AB ChIP and/or resized and not resized, you have to separate these different conditions in folders with positive tissues and one negative tissue to subtract from positive ones.

*From_noTSS_to_noBrain.sh*

If you have both resized and original macs2peak tracks for positive tissues and you want to subtract negative tissue, provide negative tracks for both resized and original macs2peaks.

## Analyse

### Find which macs2peaks overlap with CNS

*peak_OL_CNS.sh*
Provide a folder grouping all your macsPeak files.

* The number of CNS overlapping with each peak is reported in a fourth column of each peak bed provided.

### Plot macs2peaks

*Plot_acetylation_201907.R*

Plot coverage of peaks per region [bp] normalised by region size [bp]. Peaks that OL 1 or more bp with CNS are in one color, peaks without OL in another.

Parameters not passed as arguments but you can change at beginning of file:
- y_limit<-0.09
- colWidth<-0.7
- pltWidth<-9 #in cm
- pltHeight<-9 #in cm

To plot all files of a folder, use


For each input macs2peak file, it creates one bar plot and one table extracting from the plot the data that is in the plot. This way, it is possible to verify that what is plotted is really corresponding to the data we wanted to plot. It is also possible to quickly quantify other things with this table, like to get the proportion of CSoverlap but numeric.


This is a test bla
