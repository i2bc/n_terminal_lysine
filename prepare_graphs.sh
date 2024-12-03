#!/bin/bash
#
# create shell to automatise graphs creation
# $1: species list files (with column1 for ncbi identifier and column2 for species name)
# $2: acces to script repository
# $3: number of aa positions
#
# command line eg.:
# bash prepare_graphs.sh *.list n_terminal_lysine-main 20
#
rm ${1}.KRNHYIaa_aaFreqByPos_graphes.sh
for SP in `cut -f1 ${1} ` ; do
   # ${SP/.*/\*}.prophecy suppress sequenceID version number if present
   # the sumByPos variable containt the number of aa by position and is used to compute percentages from counts
   tail -n+10 Tmp/${SP/.*/\*}.prophecy | head -n ${3} | awk '{sumByPos=0; for(i=1;i<=NF;i++){sumByPos=sumByPos+$i}; for(i=1;i<=NF-1;i++){printf("%1.2f ",$i*100/sumByPos)}; printf("%1.2f\n",$NF*100/sumByPos)}'| awk 'BEGIN{print "K,R,N,H,Y,I";OFS=","}{print $11,$18,$14,$8,$25,$9}' > Tmp/KRNHYIaa_${SP}.csv ;
   awk -v sp=${SP} -v tools=${2} -F "\t" '{if($1==sp){print "Rscript "tools"/aaFreqByPos.R -i Tmp/KRNHYIaa_"sp".csv -s \""$2"\""}}' ${1} >> ${1}.KRNHYIaa_aaFreqByPos_graphes.sh ; 
done
