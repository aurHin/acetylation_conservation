# macs2peaks_conservation

Compare different tracks of macs2 peaks from ChIP-seq, without or without comparison with sequence conservation.


Start from macs2 narrowPeak files from ChIP-seq experiment and from conservation files which are bed adapted from MAF.
Here mouse mm10 vs chicken galGal6.

### Step - get conservation files

UCSC > galGal6 > Conservation > PhastCons > Parent directory > galGal6vsMm10
galGal6.mm10.synNet.maf.gz - filtered net file for syntenic alignments
               only, in MAF format, see also, description of MAF format:
               http://genome.ucsc.edu/FAQ/FAQformat.html#format5
 
### Step - format conservation files

To have the syntenic conserved regions, transform galGal6.mm10.synNet.maf.gz to be with galaxy tool "MAF to Interval".
