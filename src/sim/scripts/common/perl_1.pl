sub sequence_list_gen{

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
    if($r_type eq "ALL" or $r_type eq "SERDES_MODEL")
    {
	@reg_type_list=("COMP","FC","SANITY","REG","GENERAL");
	if($lf_val==1)
	{
	    @reg_type_list=(@reg_type_list,"LF_1");
	}
	elsif($lf_val==2)
	{
	    @reg_type_list=(@reg_type_list,"LF_2");
	}
	if($bytes_to_remove_val==0)
	{
	    @reg_type_list=(@reg_type_list,"CRC");
	}
	if($stats_val==1)
	{
	    @reg_type_list=(@reg_type_list,"STATS");
	}
	if($rsfec_val==1)
	{
	    @reg_type_list=	("RSFEC");		
	}
	if($ptp_val==1)
	{
	    @reg_type_list=("PTP_MODE");
	    if($lf_val==1 || $lf_val==2)
	    {
		@reg_type_list = ("PTP_MODE","PTP_MODE_LINK_FAULT");
	    }
	}

	if($pam4_val==1 && $rsfec_val==1)
	{
	    @reg_type_list=	("RSFEC_PAM4");		
	}
    }
    else
    {
	if($rsfec_val==1)
	{
	    if($pam4_val==1)
	    {
		if($r_type eq "otn_mode" or $r_type eq "otn_mode_serdes_model" or $r_type eq "OTN_MODE")
		{
		    @reg_type_list=	("OTN_MODE_RSFEC_PAM4");		
		}
		if($r_type eq "flexe_mode" or $r_type eq "flexe_mode_serdes_model" or $r_type eq "FLEXE_MODE")
		{
		    @reg_type_list=	("FLEXE_MODE_RSFEC_PAM4");		
		}
		if($r_type eq "pcs_only" or $r_type eq "pcs_only_serdes_model" or $r_type eq "PCS_ONLY")
		{
		    @reg_type_list=	("PCS_ONLY_RSFEC_PAM4");		
		}
		if($ptp_val==1)
		{
		    @reg_type_list = ("PTP_MODE");
		    if($lf_val==1 || $lf_val==2)
		    {
			@reg_type_list = ("PTP_MODE","PTP_MODE_LINK_FAULT");
		    }
		}
	    }
	    else
	    {
		@reg_type_list = ("RSFEC");		
		if($r_type eq "otn_mode" or $r_type eq "otn_mode_serdes_model" or $r_type eq "OTN_MODE")
		{
		    @reg_type_list=	("OTN_MODE_RSFEC");		
		}
		if($r_type eq "flexe_mode" or $r_type eq "flexe_mode_serdes_model" or $r_type eq "FLEXE_MODE")
		{
		    @reg_type_list=	("FLEXE_MODE_RSFEC");		
		}
		if($r_type eq "pcs_only" or $r_type eq "pcs_only_serdes_model" or $r_type eq "PCS_ONLY")
		{
		    @reg_type_list=	("PCS_ONLY_RSFEC");		
		}
		if($r_type eq "GDR_P0" or $r_type eq "GDR_P1" or $r_type eq "GDR_P2" or $r_type eq "GDR_P3")
		{
		    @reg_type_list=	$r_type;		
		}
		if($ptp_val==1)
		{
		    @reg_type_list = ("PTP_MODE");
		    if($lf_val==1 || $lf_val==2)
		    {
			@reg_type_list = ("PTP_MODE","PTP_MODE_LINK_FAULT");
		    }
		}
                 else 
         	    {
	             @reg_type_list=$r_type;
                    }
	    }
	}		  
    	elsif($ptp_val==1)
	{
	    @reg_type_list = ("PTP_MODE");
	    if($lf_val==1 || $lf_val==2)
	    {
		@reg_type_list = ("PTP_MODE","PTP_MODE_LINK_FAULT");
	    }
	}	
	elsif($dr==1) 
	{
	    if ($r_type eq "sanity") {
		@reg_type_list=("DR_SANITY");
	    } else {
		@reg_type_list=("DR");
	    }	
	}
    	else 
	{
	    @reg_type_list=$r_type;
	}
    }




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
	    if($_ eq $vip_en )
	    {
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

	    }

	    $count=$count+1;
	}

	
    }

    return(@seq_list);
    close $fh;

}

1;
