BEGIN{
  new=0;
  tooShort=0
}
{ 
  if ($1~"^>"){
    if ($0 !~ /pseudo=true/){
       comment=$1;
       new=1
    } else {
       new=0
    }
  } else {
       if(new==1){
         if(length($1)>=size){
           print(comment"\nATG"substr($1,4,57))
           new=0
         }else{
           tooShort++;
           new=0
         }
       }
    }
}
END{
  print tooShort >>"get_nt.log" 
}
