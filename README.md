# macs2peaks_conservation

**Compare different tracks of macs2 peaks from ChIP-seq, without or without comparison with sequence conservation.**

Start from macs2 narrowPeak files from ChIP-seq experiment and from conservation files which are bed adapted from MAF.
Here mouse mm10 vs chicken galGal6.

## Conservation files

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
