# macs2peaks_conservation

**Compare different tracks of macs2 peaks from ChIP-seq, without or without comparison with sequence conservation.**

Start from macs2 narrowPeak files from ChIP-seq experiment and from conservation files which are bed adapted from MAF.
Here mouse mm10 vs chicken galGal6.

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

## Preapre macs2narrowPeak files

### Fromat peak files

*From_narrowPeak_to_FixAndSplitTSS_mm10.sh*

Takes one input file *narrowPeak.bed*, gives two outputfiles: *noTSS.bed* ; *resizedAndMerge_noTSS.bed*

* reformat narrowPeak format to 4 columns bed format
* get intervals that do not overlap promoters (TSS) (we are interest in enhancers)
* create new file with resized and merged intervals. *You can choose to give all the peaks the same size, centered on the summit called by macs2. If so, peaks may then overlap. In this case, they are merge in one, larger peak*
* get intervals that do not overlap promoters AFTER resizing
  
### Subtract negative tissue from positive one

*From_noTSS_to_noBrain_mm10.sh*

If you have both resized and original macs2peak tracks for positive tissues and you want to subtract negative tissue, provide negative tracks for both resized and original macs2peaks.

## Analyse

### Find which macs2peaks overlap with CNS

*peak_OL_CNS.sh*

Takes macs2peak file and return a bed with an additional column which containe "noCSoverlap" or "CSoverlap" for each peak. 1bp overlap is sufficient to qualify the whole peak as CNSoverlap.

*AddConservationColumnTomacs2.R*
