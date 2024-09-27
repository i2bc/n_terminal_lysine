# script of the https://github.com/i2bc/n_terminal_lysine deposit
# compute codon ratio for one couple of codons
#
# input : 
# codon frequencies, one position by line, eg.
# AGA AGG
#
# output : AGA AGG AGA/AGG
#
# -v md=0 # minimal threshold for denominator
#
# command line eg.:
#   SP="GCA_000009045.1"
#   rm Tmp/${SP}_ratio.txt ;
#   for f in "Tmp/${SP}_TAT.txt Tmp/${SP}_TAC.txt"  ; do
#       paste ${f} | awk -v md=20 -f ratio_for_2codons.awk >> Tmp/${SP}_ratio.txt ;
#   done ;
#
{
   if(NR==1){
      print($1"\t"$2"\t"$1"/"$2" "md)
   }else{
      if($2<=md){
         printf("%d\t%d\t%s\n",$1,$2,"NA")
      }else{
         printf("%d\t%d\t%.3f\n",$1,$2,$1/$2)
      }
   }
}
