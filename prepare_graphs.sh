#!/bin/bash
#
# create shell to automatise graphs creation
# $1: species list files (with column1 for ncbi identifier and column2 for species name)
# $2: acces to script repository
# $3: number of aa positions
#
# command line eg.:
# bash prepare_graphs.sh species_Archaea n_terminal_lysine 20
#
rm graph_${1}_tmp.sh ; 
for SP in `cut -f1 ${2}/${1}.list ` ; do
   # ${SP/.*/\*}.prophecy suppress sequenceID version number if present
   # the sumByPos variable containt the number of aa by position and is used to compute percentages from counts
   tail -n+10 Tmp/${SP/.*/\*}.prophecy | head -n ${3} | awk '{sumByPos=0; for(i=1;i<=NF;i++){sumByPos=sumByPos+$i}; for(i=1;i<=NF-1;i++){printf("%1.2f ",$i*100/sumByPos)}; printf("%1.2f\n",$NF*100/sumByPos)}'| awk 'BEGIN{print "K,R,N,H,Y,I";OFS=","}{print $11,$18,$14,$8,$25,$9}' > Tmp/KRNHYIaa_${SP}.csv ;
   grep ${SP/.*/\*} n_terminal_lysine/OGT_nbCDS.tsv | awk -v tools="n_terminal_lysine" -v sp=${SP} -F "\t" '{print "Rscript "tools"/aaFreqByPos.R -i Tmp/KRNHYIaa_"sp"*.csv -s \""$2"\" -t ,"$3","$4}' >> graph_${1}_tmp.sh ; 
done
sort -t "," -nk2,2 graph_${1}_tmp.sh | sed 's/,/"(OGT: /;s/,/°C, /;s/$/ CDS)"/' > graph_${1}.sh
bash graph_${1}.sh

