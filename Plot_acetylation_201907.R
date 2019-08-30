library(data.table)
library(ggplot2)
library(plyr)
install.packages("plyr")
y_limit <- 0.09
colWidth <- 0.7
pltWidth <- 9 #in cm
pltHeight <- 9 #in cm

fileForTesting <- "/Users/Hintermann/Desktop/LAB/CompSeqFonc/analyseMacs2_201909/tests/tryPlot/H3K27ac_E125_WP_r1_macs2narrowPeak_resizeAndMerged_nonTSS_negSubtracted_annotCNS.bed"
regionsForQuantif <- "/Users/Hintermann/Desktop/LAB/genomicData/genomicData_mm10/regionsForQuantif_HoxD.bed"
 
terminal <- "Y"

if (terminal == "Y"){
  arg1 <- commandArgs(T)[1]
  arg2 <- commandArgs(T)[2]
} else{
  arg1 <- fileForTesting
  arg2 <- regionsForQuantif
}

regionsDF <- read.table(regionsForQuantif, sep = "\t", stringsAsFactors = T)

message("\n\n########\n######\nPlot data from file: ")
print(basename(arg1))
message(paste0("On regions:\n"), paste(regionsDF$V4, collapse = "\n"))

tbl_toPlot <- read.csv(arg1, sep = "\t", header = F, stringsAsFactors = T)
if (dim(tbl_toPlot)[2] == 5){
  tbl_toPlot <- tbl_toPlot[, c(1, 2, 3, 5)]
  colnames(tbl_toPlot)[4] <- "V4"
}
tbl_toPlot$xAxis <- NA
tbl_toPlot$regionLength <- NA

message("\n\nAdd region names and region sizes to table.")
for (reg in regionsDF$V4){
  RegOfInt <- regionsDF[regionsDF$V4 == reg,]
  RegInterval <- c(RegOfInt$V2:RegOfInt$V3)
  chromosome <- as.character(RegOfInt$V1)
  #conditionToBeInReg<-tbl_toPlot$V1==RegOfInt$V3&tbl_toPlot$V2%in%RegInterval&tbl_toPlot$V3%in%RegInterval
  tbl_toPlot$xAxis[tbl_toPlot$V1 == chromosome &
                     tbl_toPlot$V2 %in% RegInterval &
                     tbl_toPlot$V3 %in% RegInterval] <- reg
  tbl_toPlot$regionLength[tbl_toPlot$xAxis %in% reg] <- RegOfInt$V3 - RegOfInt$V2
  tbl_toPlot$V4[tbl_toPlot$V4>0]<-1
}

#message(paste0("Keep only elements  with start and end included regions coordinates.\nNumber of peaks analyzed: ",))
tbl_toPlot <- tbl_toPlot[tbl_toPlot$xAxis %in% regionsDF$V4, ]
print(head(tbl_toPlot))
#print(dim(tbl_toPlot)[1])
tbl_toPlot$V4 <- factor(tbl_toPlot$V4, levels = c(0,1))
#print(head(tbl_toPlot))

outdir <- paste0(dirname(arg1), "/plots/")
dir.create(outdir, showWarnings = F)
pltName<-gsub(".bed", ".png", basename(arg1))
tblName<-gsub(".bed", "_plottedData.bed", basename(arg1))

message("Plotting")
# Initialise peakSize

#labsTitle<-strsplit(pltName,"macs")[[1]][1]

plt <- ggplot(tbl_toPlot, 
              aes(x = xAxis, y = (V3 - V2) / regionLength,
                  fill = V4, width = colWidth)) +
  geom_bar(stat = "identity") +
  theme_bw() +
  labs(title = labsTitle, x= " ", y = "[acetylated_bp/total_bp]", fill = " ") +
  coord_cartesian(ylim = c(0, y_limit))

dfData <- ggplot_build(plt)$plot$data
write.table(dfData, paste0(outdir, tblName), row.names = F, col.names = F,
            sep = "\t", quote = F)
ggsave(paste0(outdir, pltName), width = pltWidth, height = pltHeight,
       units = "cm")
# I think I would increase the dpi here: units = "cm", dpi = 1000)

message(paste0("Plot saved under: ", outdir, pltName))

