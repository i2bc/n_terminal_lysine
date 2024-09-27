# script of the https://github.com/i2bc/n_terminal_lysine deposit
# compute 2 codon ratios for K amino-acid 
#
# input : 
# Lysine codon frequencies, one position by line, eg.
# AAA AAG
#
# output : AAA AAG AAA/AAG AAA/(AAA+AGG)
#
# -v md=0 # minimal threshold for denominator
#
# command line eg.:
#   SP="GCA_000009045.1"
#   rm Tmp/${SP}_ratio.txt ;
#   for f in "Tmp/${SP}_AAA.txt Tmp/${SP}_AAG.txt" ; do
#       paste ${f} | awk -v md=20 -f ratio_for_Kcodons.awk >> Tmp/${SP}_ratio.txt ;
#   done ;
#
{
   if(NR==1){
      print($1"\t"$2"\t"$1"/"$2"\t"$1"/("$1"+"$2") "md"\t("$1"+"$2")")
   }else{
      denominateur=$1+$2
      if(($2<=md)&&(denominateur<=md)){
         printf("%d\t%d\tNA\tNA\t%d\n",$1,$2,$1+$2)
      }else{
         if(($2<=md)&&(denominateur>md)){
            printf("%d\t%d\tNA\t%.3f\t%d\n",$1,$2,$1/($1+$2),$1+$2)
         }else{
            printf("%d\t%d\t%.3f\t%.3f\t%d\n",$1,$2,$1/$2,$1/($1+$2),$1+$2)
         }
      }
   }
}
