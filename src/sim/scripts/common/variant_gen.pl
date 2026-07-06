sub reduce_variant(){
my $tm=localtime;
my ($day,$month,$year)=($tm->mday,$tm->mon,$tm->year);
if($month%2==0)
{
if($day<7){
     return (1,0,0);
	     
}
elsif($day >7 && $day <14)
{

     return (1,1,0);	

}
elsif($day >14 && $day <21)
{
     return (1,0,1);	

     
}
else
{
     return (1,1,1);	
     
}

}
else
{
if($day<7){
     return (0,0,0);	
    
}
elsif($day >7 && $day <14)
{
     return (0,1,0);	

}
elsif($day >14 && $day <21)
{
     return (0,0,1);	
     
}
else
{
     return (0,1,1);	
     
}

}

}
1;
