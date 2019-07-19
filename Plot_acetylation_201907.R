library(data.table)
library(ggplot2)
library(plyr)

y_limit <- 0.09
colWidth <- 0.7
pltWidth <- 9 #in cm
pltHeight <- 9 #in cm

fileForTesting <- "/Users/Hintermann/Desktop/LAB/ChIP/conservedSeqAndAc_mm_gg_PT_skin/B_PT_WP_Skin_CTCF/H3K27ac_mm10/macs2_toPlot/H3K27ac_WP_E125_macs2narrowPeak_noTSS_nonBrain_sub_ConservationColumns.bed"
regionsForQuantif <- commandArgs(T)[2]
regionsDF <- read.table(regionsForQuantif, sep = "\t", stringsAsFactors = T)
terminal <- "Y"

if (terminal == "Y"){
  #macs2 peak file
  arg1 <- commandArgs(T)[1]
} else{
  arg1 <- fileForTesting
}

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
}

#message(paste0("Keep only elements  with start and end included regions coordinates.\nNumber of peaks analyzed: ",))
tbl_toPlot <- tbl_toPlot[tbl_toPlot$xAxis %in% regionsDF$V4, ]
print(head(tbl_toPlot))
#print(dim(tbl_toPlot)[1])
tbl_toPlot$V4 <- factor(tbl_toPlot$V4, levels = c("noCSoverlap","CSoverlap"))
#print(head(tbl_toPlot))

outdir <- paste0(dirname(arg1), "/plots/")
dir.create(outdir, showWarnings = F)
pltName<-gsub(".bed", ".png", basename(arg1))
tblName<-gsub(".bed", "_plottedData.bed", basename(arg1))

message("Plotting")
# Initialise peakSize
peakSize <- "IDontKnow"
if (grepl("resize", pltName)){
  peakSize <- "resized peaks"
} else {
  peakSize <- "original peaks"
}
# Initialise tissue
tissue <- "IDontKnow"
if (grepl("PT", pltName)){
  tissue <- "PT"
}
if (grepl("WP", pltName)){
  tissue <- "WP"
}
if (grepl("noBrain150",pltName)){
  brainNb <- "Brain150"
} else {
  brainNb <- "Brain50"
}
labsTitle<-paste0("macs2 H3K27ac\n",peakSize,"\n",tissue," minus ",brainNb)

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

