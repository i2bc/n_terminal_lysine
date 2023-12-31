## load the tidyverse packages, incl. dplyr, readr, ggplot2, tidyr, tibble, purrr, stringr, forcats
library(tidyverse)
library(ggplot2)
# get data from command line:
args <- commandArgs(trailingOnly=TRUE)
# args affectations for testing into interactive R :
# args <- c("-i", "GCF_000005845.2.csv", "-s", "E.coli")
if (length(args)==0) {
  stop("Arguments to be supplied: -i inputFile.csv -s \"speciesNameForGarphTitle\"", call.=FALSE)
} else {
  for (i in seq(1,length(args))) {
    if(args[i]=="-i") { inFile <- args[i+1] } 
    if(args[i]=="-s") {species <- args[i+1] }
  }
}
# output definitions:
graphTitle <- paste(species)
position <- seq(1,20) # add a "position" column to graphical managment of positions
 
# get data:
aa <- read_csv(inFile)

# graph creation:
# dashed: +geom_line(aes(y=G,color="G"),linetype="dashed"))+
aaGraph <- ggplot(cbind(position,aa),aes(x=position))+geom_line(aes(y=K,color="K"))+geom_line(aes(y=R,color="R"))+geom_line(aes(y=N,color="N"))+geom_line(aes(y=H,color="H"))+geom_line(aes(y=Y,color="Y"))+geom_line(aes(y=I,color="I"))+labs(title = graphTitle, x = "aa position", y = "aa frequency", color="legend")+theme_bw()

# graph save (pdf and png formats):
outFilePdf <- str_replace_all(inFile, "csv", "pdf")
pdf(paste0(outFilePdf))
print(aaGraph)
dev.off()

outFilePng <- str_replace_all(inFile, "csv", "png")
ggsave(plot=aaGraph, filename=outFilePng, width=14, height=8, units = "cm")

