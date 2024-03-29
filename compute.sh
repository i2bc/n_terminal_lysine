#!/bin/bash
# compute measurements (isoelectric point, CG%, Plong, Pavg, and P2nd) 
# for each *_cds_from_genomic.fna.gz listed in input file (one * by line) 
#
# run with:
#    compute.sh bact.list n_terminal_lysine 11
# where:
#    bact.list lists all * stored in ncbi_gca/*_cds_from_genomic.fna.gz 
#    n_terminal_lysine give acces to the code get_nt.awk
#    11 stands for Bacteria or Archaea, to replace by 0 for Eukaryota
#
# temporary files will be in Tmp/ 
# summary table files is *allAA_Plong_geeceeCDS_Toptave_iep_sp.tsv
#
mkdir -p Tmp
rm Tmp/${1}.P2nd_Pavg_Plong.tsv ;
rm Tmp/${1}.geeceeCDS.tsv ;
rm Tmp/${1}.iepCDS.tsv ;
rm Tmp/${1}.tempura_Topt_ave.tsv ;
for SP in `cut -f1 $1` ; do 
   gunzip ncbi_gca/${SP}*_cds_from_genomic.fna.gz ;
   # prophecy:  
   grep ">" -A3 ncbi_gca/${SP}*_cds_from_genomic.fna | grep -v "\-\-" | awk -v size=150 -f $2/get_nt.awk > Tmp/${SP}_150nt_cfg.fna ; 
   transeq -sequence Tmp/${SP}_150nt_cfg.fna -table $3 -frame 1 -outseq Tmp/${SP}_150nt.faa ; 
   prophecy -sequence Tmp/${SP}_150nt.faa -type F -name mymatrix -threshold 75 -outfile Tmp/${SP}.prophecy ;
   echo {A..Z} | sed 's/ /;/g' > Tmp/${SP}_allAA.csv ; 
   tail -n +10 Tmp/${SP}.prophecy | awk '{sumByPos=0; for(i=1;i<=(NF-1);i++){sumByPos=sumByPos+$i};for(i=1;i<(NF-1);i++){printf("%1.4f;",$i*100/sumByPos)}; printf("%1.4f\n",$(NF-1)*100/sumByPos)}'>> Tmp/${SP}_allAA.csv ;
   # Lysine peak (P2nd, Pave, Plong):
   awk 'BEGIN{FS=";";OFS=";"}{if(NR==1){bottom=$0}else{print $0}}END{print bottom}' Tmp/${SP}_allAA.csv | awk -f ${2}/transpose.awk | awk -v sp=${SP} 'BEGIN{FS="\t";OFS="\t";print sp}{print $21,$2-(($3+$4)/2),($2+$3)-($4+$5),($2+$3+$4+$5+$6+$7+$8+$9+$10)-(9*(($11+$12+$13+$14+$15)/5))}' | awk 'BEGIN{ORS="\t"}{print}END{print "\n"}' | sed 's/^\t//g' >> Tmp/${1}.P2nd_Pavg_Plong.tsv ; 
   # GC% on CDS:
   geecee -sequence ncbi_gca/${SP}*_cds_from_genomic.fna -outfile Tmp/${SP}.geecee ; 
   awk 'BEGIN{gcmean=0}{gcmean+=$2}END{print FILENAME"\t"gcmean*100/NR}' Tmp/${SP}.geecee | sed 's#Tmp/##;s/.geecee//' >> Tmp/${1}.geeceeCDS.tsv ; 
   # iso-electic point on CDS:
   transeq -frame 1 -table $3 -sequence ncbi_gca/${SP}*_cds_from_genomic.fna -outseq Tmp/${SP}.transeq # Eukaryota: -table 0 ; Prokaryota: -table 11
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
# reformat and adding a header line:
 awk -F "\t" '{GCA=$1;nbP=26*4+1;header="";Paa="";if(NR==1){for(i=2;i<=nbP-1;i=i+4){if($i !~ /^[0-9]+$/){tmp=sprintf("%s%s_P2nd\t%s_Pavg\t%s_Plong\t",header,$i,$i,$i);header=tmp}};printf("%s\t%s%s\t%s\t%s\t%s\n","GCA_ID",header,"geeceeCDS","tempura_Topt_ave","iepCDS","species_name")};for(i=3;i<=nbP;i=i+4){tmp=sprintf("%s%s\t%s\t%s\t",Paa,$i,$(i+1),$(i+2));Paa=tmp};printf("%s\t%s%s\t%s\t%s\t%s\n",GCA,Paa,$(NF-6),$(NF-4),$(NF-2),$NF);Paa=""}' Tmp/${1}.allAA_Plong_geeceeCDS_Toptave_iep_sp.tmp > ${1}.allAA_Plong_geeceeCDS_Toptave_iep_sp.tsv
 
