sub ptp_sequence_list_gen{

   my %hash=@_;

   my $vip_en= $hash{"vip_en"};
   my $r_type=$hash{"reg_type"};
   my $lf_val=$hash{"lf_val"};
   my $bytes_to_remove_val=$hash{"bytes_to_remove_val"};
   my $stats_val=$hash{"stats_val"};
   my $rsfec_val=$hash{"rsfec_val"};
   my $pam4_val=$hash{"pam4_val"};
   my $ptp_val=$hash{"ptp_val"};
   my $official=$hash{"official"};
   my $dr=$hash{"dr"};
   my @reg_type_list=();
   print "r_type=$r_type\n";


   print "Inside PTP regression type\n";
   @reg_type_list=$r_type;


    open($fh,"<","sequence.txt");
    chomp(my @lines = <$fh>);
    my @s;

   if ($dr==1) {
	foreach(@lines)
	{ 
	    $_ =~ s/^\s+|\s+$//g ;
	    my $variant="";
	    my $seq_name;
	    my $testname;
	    my $mode1;
	    my $mode2;
	    
	    
	    if (($_ =~ m/DR_SANITY/g) && ($r_type eq "sanity")) 
	    {
		print "DR SANITY\n";
		my @ss=split(',',$_);
		$seq_name = $ss[0];
		$testname = $ss[4];
		$mode1 = $ss[5];
		$mode2 = $ss[6];
		$variant = "$seq_name";
		$variant .= "__";
		$variant .= "$testname";
		
		if($mode1 ne "") 
		{
		    $variant .= "__";
		    $variant .= "$mode1";
		}
		
		if($mode2 ne "")
		{
		    $variant .= "__";
		    $variant .= "$mode2";	
		}
		print "variant : $variant\n";
		
		#$_ =~ s/\,/__/g ;
		
		chomp ();
		push (@seq_list,$variant);
	    } elsif (($_ =~ m/,DR,/g)  && ($r_type ne "sanity")) {
		print "Just DR\n";
		my @ss=split(',',$_);
		$seq_name = $ss[0];
		$testname = $ss[4];
		$mode1 = $ss[5];
		$mode2 = $ss[6];
		$variant = "$seq_name";
		$variant .= "__";
		$variant .= "$testname";
		
		if($mode1 ne "") 
		{
		    $variant .= "__";
		    $variant .= "$mode1";
		}
		
		if($mode2 ne "")
		{
		    $variant .= "__";
		    $variant .= "$mode2";	
		}
		print "variant : $variant\n";
		
		#$_ =~ s/\,/__/g ;
		
		chomp ();
		push (@seq_list,$variant);
	    }

	}
	
    }  

    else
    {

	foreach (@lines)
	{
	    @s =split(/\,/,$_);
	    @sequence_list=(@sequence_list,@s);	
	}

	$count=0;
	foreach(@sequence_list)
	{ 
      #if($_ eq $vip_en )
	   #{
		   if($official eq "yes")
		   {
		      if( @sequence_list[$count-1] eq "PASS")
		      {
			      foreach (@reg_type_list)
			      {				
			         if($_ eq @sequence_list[$count-2])
			         {
				         @seq_list=(@seq_list,@sequence_list[$count-3]);
			         }				
			    
			      }  				
		      }
		    
		   }
		   else
		   {	
		      if(@reg_type_list[0] eq "failed_sequences")
		      {	
			      if( @sequence_list[$count-1] eq "FAIL")
			      {
			         @seq_list=(@seq_list,@sequence_list[$count-3]);
			    
			      }

		      }
		      else	
		      {
			      foreach (@reg_type_list)
			      {	
			         if($_ eq @sequence_list[$count-2])
			         {
				         @seq_list=(@seq_list,@sequence_list[$count-3]);
			         }
			      }
		      }	

		   }

      #}

	   $count=$count+1;
	}

	
    }

    return(@seq_list);
    close $fh;

}

1;
