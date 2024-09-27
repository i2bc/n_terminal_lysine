# script of the https://github.com/i2bc/n_terminal_lysine deposit
# compute 2 codon ratios for R amino-acid 
#
# input : 
# arginine codon frequencies, one position by line
# AGA AGG CGA CGC CGG CGT
#
# output : AGA AGG CGA CGC CGG CGT AGA/(AGA+AGG) (AGA+AGG)/(AGA+AGG+CGA+CGC+CGG+CGT)
# previous output with denominator3 in place of denominator2 : 
# AGA AGG CGA CGC CGG CGT (AGA+AGG)/(CGA+CGC+CGG) (AGA+AGG)/(AGA+AGG+CGA+CGC+CGG+CGT)
#
# -v md=0 # minimal threshold for denominator
#
# command line eg.:
#   SP="GCA_000009045.1"
#   rm Tmp/${SP}_ratio.txt ;
#   for f in "Tmp/${SP}_AGA.txt Tmp/${SP}_AGG.txt Tmp/${SP}_CGA.txt Tmp/${SP}_CGC.txt Tmp/${SP}_CGG.txt Tmp/${SP}_CGT.txt" ; do
#       paste ${f} | awk -v md=20 -f ratio_for_Rcodons.awk >> Tmp/${SP}_ratio.txt ;
#   done ;
#
{
  if(NR==1){
       print($1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$1"/("$1"+"$2") "md"\t("$1"+"$2")\t("$1"+"$2")/("$1"+"$2"+"$3"+"$4"+"$5"+"$6") "md"\t("$1"+"$2"+"$3"+"$4"+"$5"+"$6")") # AGA/(AGA+AGG)
     # print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t("$1"+"$2")/("$3"+"$4"+"$5") "md"\t("$1"+"$2")/("$1"+"$2"+"$3"+"$4"+"$5"+"$6") "md # (AGA+AGG)/(CGA+CGC+CGG)
  }else{
     denominateurs2=$1+$2; # AGA/(AGA+AGG)
     # denominateurs3=$3+$4+$5; # (AGA+AGG)/(CGA+CGC+CGG)
     denominateurs6=$1+$2+$3+$4+$5+$6; #(AGA+AGG)/(AGA+AGG+CGA+CGC+CGG+CGT)
     if((denominateurs2<=md)&&(denominateurs6<=md)){
        printf("%d\t%d\t%d\t%d\t%d\t%d\t%s\t%d\t%s\t%d\n",$1,$2,$3,$4,$5,$6,"NA",denominateurs2,"NA",denominateurs6)
     }else{
        if((denominateurs2<=md)&&(denominateurs6>md)){
           printf("%d\t%d\t%d\t%d\t%d\t%d\t%s\t%d\t%.3f\t%d\n",$1,$2,$3,$4,$5,$6,"NA",denominateurs2,($1+$2)/($1+$2+$3+$4+$5+$6),denominateurs6 )
        }else{
           # printf("%d\t%d\t%d\t%d\t%d\t%d\t%.3f\t%.3f\n",$1,$2,$3,$4,$5,$6,($1+$2)/($3+$4+$5),($1+$2)/($1+$2+$3+$4+$5+$6)) # (AGA+AGG)/(CGA+CGC+CGG)
           printf("%d\t%d\t%d\t%d\t%d\t%d\t%.3f\t%d\t%.3f\t%d\n",$1,$2,$3,$4,$5,$6,($1)/($1+$2),denominateurs2,($1+$2)/($1+$2+$3+$4+$5+$6),denominateurs6 ) # AGA/(AGA+AGG)
        }
     }
  }
}
