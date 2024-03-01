# extract the n first nucleotides of a fna sequences file
#
# change 1srt codon to ATG
# exclude sequence tagged "pseudo"
# exclude sequence with length < input size value
#
# eg. of command line:
# rm get_x_nt.log ; awk -v size=60 -f get_nt.awk *.fna
#
BEGIN{
  tooShort=0; pseudo=0 ;
  seq=""; pseu="" ; shor="";
  if(size==0){print "abort due to no fixed size (need -v size=60)"}
}
{ 
if(size > 0){
  if ($1~"^>"){
       if(length(seq)==size){
           print comment"\n"seq;
       } else {
         if(length(comment)>1){ # pseudo have comment fixed to null
           tooshort=tooshort+1;
           tmp=sprintf("%s\n%s",shor,comment);
           shor=tmp;
         }
       }
       seq="" ; 
       if ($0 !~ /pseudo=true/){
         comment=$1;
         getSeq=1;
       } else {
         pseudo=pseudo+1; 
         tmp=sprintf("%s\n%s",pseu,$1);
         pseu=tmp;
         getSeq=0;
         comment="";
       }
  } else {
     if(getSeq){
        seql=length(seq);
        if (seql+length($1)<=size){
           tmp=sprintf("%s%s",seq,$1);
        } else {
           seqToAdd=substr($1,1,size-seql);
           tmp=sprintf("%s%s",seq,seqToAdd);
           getSeq=0;
        }
        seq=tmp;
      }
    }
  } 
}
END{
  if(length(seq)==size){
     print comment"\n"seq;
  } else {
     tooshort=tooshort+1;
     tmp=sprintf("%s\n%s",shor,comment);
     shor=tmp;
  }
  print tooshort" too_short: "shor >>"get_x_nt.log" ;
  print pseudo" pseudo: "pseu >>"get_x_nt.log"
}
