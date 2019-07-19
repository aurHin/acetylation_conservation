arg1<-commandArgs(T)[1] #.bed
arg2<-commandArgs(T)[2] #onCS.bed

setwd(dirname(arg1))
dir.create("../macs2_toPlot",showWarnings = F)
fileName<-basename(arg1)
outputName=paste0("../macs2_toPlot/",gsub(strsplit(fileName,"[.]")[[1]][1],paste0(strsplit(fileName,"[.]")[[1]][1],"_ConservationColumn"),fileName))
df<-read.table(arg1, sep="\t",stringsAsFactors=F)
dfCS<-read.table(arg2, sep="\t",stringsAsFactors=F)

df$Conservation<-NA
df$Conservation[df$V2%in%dfCS$V2]<-"CNSoverlap"
df$Conservation[is.na(df$Conservation)]<-"noCNSoverlap"
message("\nHead of output df:\n")
head(df)
message(paste0("\ndf saved under: ",outputName,"\n"))
write.table(df,outputName,quote = F,row.names = F,col.names = F,sep = "\t")
