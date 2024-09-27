#!/bin/bash
#
# script of the https://github.com/i2bc/n_terminal_lysine deposit
# compute measurements (isoelectric point, CG%, Plong, Pavg, and P2nd) 
# for each *_cds_from_genomic.fna.gz listed in input file (one * by line) 
#
# rely on the emboss tools package (transeq, prophecy, geecee, iep)
#
# run with:
#    bash compute.sh bact.list n_terminal_lysine 11 60


# fix:
# - ${1} chain: path/to/*.list (one ID by line) of identifiers of genome sequence (eg. GCA_000005845.2 from ncbi genbank, stored in ncbi_gca/*_cds_from_genomic.fna.gz)
# - ${2} chain: path/to/n_terminal_lysine deposit
# - ${3} integer: code for genetic code to used when translating nucleotidic sequence (Eukaryota: 0 ; Prokaryota: 11), see emboss::transeq documentation
# - ${4} integer : size in nt of the sequences to analyse
#
# input:
# - sequence files in ncbi_gca/${SP}*_cds_from_genomic.fna.gz ; ${SP} can be the 1srt column of ${1}
# - 200617_TEMPURA.csv downloaded from 
#
# output:
# - temporary files in Tmp/ 
# - summary table files is *allAA_Plong_geeceeCDS_Toptave_iep_sp.tsv
#
mkdir -p Tmp
rm Tmp/${1}.P2nd_Pavg_Plong.tsv ;
rm Tmp/${1}.geeceeCDS.tsv ;
rm Tmp/${1}.iepCDS.tsv ;
rm Tmp/${1}.tempura_Topt_ave.tsv ;
for SP in `cut -f1 ${1}` ; do 
   gunzip ncbi_gca/${SP}*_cds_from_genomic.fna.gz ;
   # prophecy:  
   awk -v size=${4} -f ${2}/get_x_nt.awk ncbi_gca/${SP}*_cds_from_genomic.fna > Tmp/${SP}_${4}nt_cfg.fna ; 
   transeq -sequence Tmp/${SP}_${4}nt_cfg.fna -table $3 -frame 1 -outseq Tmp/${SP}_${4}nt.faa ; 
   prophecy -sequence Tmp/${SP}_${4}nt.faa -type F -name mymatrix -threshold 75 -outfile Tmp/${SP}.prophecy ;
   echo {A..Z} | sed 's/ /;/g' > Tmp/${SP}_allAA.csv ; 
   tail -n +10 Tmp/${SP}.prophecy | awk '{if(NR<=20){sumByPos=0; for(i=1;i<=(NF-1);i++){sumByPos=sumByPos+$i};for(i=1;i<(NF-1);i++){printf("%1.4f;",$i*100/sumByPos)}; printf("%1.4f\n",$(NF-1)*100/sumByPos)}}'>> Tmp/${SP}_allAA.csv ; # (NR<=20) => only 20 first positions
   # Lysine peak (P2nd, Pave, Plong):
   awk 'BEGIN{FS=";";OFS=";"}{if(NR==1){bottom=$0}else{print $0}}END{print bottom}' Tmp/${SP}_allAA.csv | awk -f ${2}/transpose.awk | awk -v sp=${SP} 'BEGIN{FS="\t";OFS="\t";print sp}{print $21,$2-(($3+$4)/2),($2+$3)-($4+$5),($2+$3+$4+$5+$6+$7+$8+$9+$10)-(9*(($11+$12+$13+$14+$15)/5))}' | awk 'BEGIN{ORS="\t"}{print}END{print "\n"}' | sed 's/^\t//g' >> Tmp/${1}.P2nd_Pavg_Plong.tsv ; 
   # GC% on CDS:
   geecee -sequence ncbi_gca/${SP}*_cds_from_genomic.fna -outfile Tmp/${SP}.geecee ; 
   awk 'BEGIN{gcmean=0}{gcmean+=$2}END{print FILENAME"\t"gcmean*100/NR}' Tmp/${SP}.geecee | sed 's#Tmp/##;s/.geecee//' >> Tmp/${1}.geeceeCDS.tsv ; 
   # iso-electic point on CDS:
   transeq -frame 1 -table ${3} -sequence ncbi_gca/${SP}*_cds_from_genomic.fna -outseq Tmp/${SP}.transeq # Eukaryota: -table 0 ; Prokaryota: -table 11
   iep -sequence Tmp/${SP}.transeq -outfile Tmp/${SP}.iep ; 
   awk '{if($1=="Isoelectric"){sumIEP=sumIEP+$NF;nbSeq++}}END{print FILENAME"\t"sumIEP/nbSeq}' Tmp/${SP}.iep | sed 's#Tmp/##;s/.iep//' >> Tmp/${1}.iepCDS.tsv ;
   # OGT from TEMPURA DB:
   OGT_flag=`grep -c ${SP} 200617_TEMPURA.csv`
   if [ ${OGT_flag} = '0' ]; then
     echo ${SP}$'\t'NA >> Tmp/${1}.tempura_Topt_ave.tsv ;
   else
     echo -n ${SP}$'\t' >> Tmp/${1}.tempura_Topt_ave.tsv ;
     grep ${SP} 200617_TEMPURA.csv | cut -d "," -f 16 >> Tmp/${1}.tempura_Topt_ave.tsv ;
   fi
   gzip ncbi_gca/${SP}*_cds_from_genomic.fna
done

# combine:
paste Tmp/${1}.P2nd_Pavg_Plong.tsv Tmp/${1}.geeceeCDS.tsv Tmp/${1}.tempura_Topt_ave.tsv Tmp/${1}.iepCDS.tsv ${1} | awk -F "\t" 'BEGIN{OFS="\t"}{toprint=$1;for(i=2;i<=(NF-6);i++){toprint=sprintf("%s\t%s",toprint,$i)};print toprint"GC%CDS",$(NF-6),"Topt-av",$(NF-4),"iepCDS",$(NF-2),"species",$NF; toprint=""}' > Tmp/${1}.allAA_Plong_geeceeCDS_Toptave_iep_sp.tmp ;
# reformat and add a header line:
 awk -F "\t" '{GCA=$1;nbP=26*4+1;header="";Paa="";if(NR==1){for(i=2;i<=nbP-1;i=i+4){if($i !~ /^[0-9]+$/){tmp=sprintf("%s%s_P2nd\t%s_Pavg\t%s_Plong\t",header,$i,$i,$i);header=tmp}};printf("%s\t%s%s\t%s\t%s\t%s\n","GCA_ID",header,"geeceeCDS","tempura_Topt_ave","iepCDS","species_name")};for(i=3;i<=nbP;i=i+4){tmp=sprintf("%s%s\t%s\t%s\t",Paa,$i,$(i+1),$(i+2));Paa=tmp};printf("%s\t%s%s\t%s\t%s\t%s\n",GCA,Paa,$(NF-6),$(NF-4),$(NF-2),$NF);Paa=""}' Tmp/${1}.allAA_Plong_geeceeCDS_Toptave_iep_sp.tmp > ${1}.allAA_Plong_geeceeCDS_Toptave_iep_sp.tsv
 
