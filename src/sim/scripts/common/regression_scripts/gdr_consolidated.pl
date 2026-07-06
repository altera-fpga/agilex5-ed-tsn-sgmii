#!/usr/bin/perl

use warnings;
use strict;
use Spreadsheet::WriteExcel;
my @input = glob('/nfs/sc/disks/gdr_regression_3/users/GDR_REPORT/ALL_CSV/GDR_ETH_*.csv');
my $wb = Spreadsheet::WriteExcel->new("/nfs/sc/disks/gdr_regression_3/users/GDR_REPORT/gdr_consolidatedreport.xls"); 
my $excel="/nfs/sc/disks/gdr_regression_3/users/GDR_REPORT/gdr_consolidatedreport.xls";
my $mailfile ="/nfs/sc/disks/gdr_regression_3/users/GDR_REPORT/mailfile.txt";
my @PCS =("ETH_10_4","ETH_6","ETH_25_5","ETH_25_6","ETH_25_8","ETH_50_6","ETH_50_11","ETH_50_7","ETH_50_8","ETH_100_7","ETH_100_9","ETH_100_10","ETH_200_5","ETH_200_8","ETH_200_9","ETH_400_4");
my @FLEXE =("ETH_10_7","ETH_10_9","ETH_25_12","ETH_25_14" ,"ETH_25_16","ETH_50_13","ETH_50_15","ETH_50_17","ETH_50_19","ETH_100_14","ETH_100_16","ETH_100_18","ETH_200_11","ETH_200_13","ETH_200_15","ETH_400_6");
my @OTN=("ETH_10_6","ETH_25_11","ETH_25_17","ETH_40_6","ETH_50_12","ETH_50_14","ETH_50_18","ETH_100_13","ETH_100_15","ETH_100_19");
my @PS=("ETH_PS_13","ETH_PS_7","ETH_PS_16","ETH_PS_4","ETH_PS_9","ETH_PS_5");
my @MM =("ETH_mm1","ETH_mm2","ETH_mm3","ETH_mm4","ETH_mm5","ETH_mm6","ETH_mm7");
my $sheet1 = $wb->addworksheet("MAC");
my $sheet2 = $wb->addworksheet("PCS");
my $sheet3 = $wb->addworksheet("FLEXE");
my $sheet4 = $wb->addworksheet("OTN");
my $sheet5 = $wb->addworksheet("PS");
my $sheet6 = $wb->addworksheet("MM");
my $i=0;
my $j=0;
my $k=0;
my $l=0;
my $m=0;
my $n=0;
my @var;
my $row1=0;
my $row2=0;
my $row3=0;
my $row4=0;
my $row5=0;
my $row6=0;
my $bluebg = $wb->addformat();
$bluebg->set_color('blue');
my $mail_cmd; 
my $word;
my ($key1,$key2,$key3,$key4,$key5,$key6);


sub write_sheet ($$) {
		my ($sheetname, $filename) = @_;
		print "Sheet Name = $sheetname\n";
		print "FILENAME=$filename\n";
		if( grep { $_ eq $sheetname } @PCS){
				if($i==0){
				open(CSV, "$filename") or die "cannot open $!";
			       		while ( <CSV>) {
					@var=split(/,/,$_);
                                	my $format = ($. == 1) ? $bluebg : undef;
						if ($var[2]=~/ETH_*/){
						$key1=$var[2];
						}
		  	        		foreach my $vidx (0..$#var) {
							$sheet2->write($row1, $vidx, $var[$vidx],$format);
        						$i++;
						}
					$row1++;
					}
				}else{  
					if($sheetname ne $key1){	      	      	         
					foreach my $vidx (0..$#var) {
					        $sheet2->write($row1,$vidx,$var[$vidx]);
                                              	$i++;
				    	}
				$row1++;
    				}}
		}elsif(grep { $_ eq $sheetname } @FLEXE){
				if($j==0){
				open(CSV, "$filename") or die "cannot open $!";
			       		while ( <CSV>) {
					@var=split(/,/,$_);
                                	my $format = ($. == 1) ? $bluebg : undef;
						if ($var[2]=~/ETH_*/){
						$key2=$var[2];
						}						
		  	        		foreach my $vidx (0..$#var) {
							$sheet3->write($row2, $vidx, $var[$vidx],$format);
        						$j++;
						}
					$row2++;
					}
				}else{  
					if($sheetname ne $key2){		      	      	         
					foreach my $vidx (0..$#var) {
					        $sheet3->write($row2,$vidx,$var[$vidx]);
                                              	$j++;
				    	}
				$row2++;
    				}}
		}elsif(grep { $_ eq $sheetname } @OTN){
				if($k==0){
				open(CSV, "$filename") or die "cannot open $!";
			       		while ( <CSV>) {
					@var=split(/,/,$_);
                                	my $format = ($. == 1) ? $bluebg : undef;
						if ($var[2]=~/ETH_*/){
						$key3=$var[2];
						}
						foreach my $vidx (0..$#var) {
							$sheet4->write($row3, $vidx, $var[$vidx],$format);
        						$k++;
						}
					$row3++;
					}
				}else{  
					if($sheetname ne $key3){	      	      	         
					foreach my $vidx (0..$#var) {
					        $sheet4->write($row3,$vidx,$var[$vidx]);
                                              	$k++;
				    	}
				$row3++;
    				}}

		}elsif(grep { $_ eq $sheetname } @PS){
			 	if($l==0){
				open(CSV, "$filename") or die "cannot open $!";
			       		while ( <CSV>) {
					@var=split(/,/,$_);
                                	my $format = ($. == 1) ? $bluebg : undef;
						if ($var[2]=~/ETH_*/){
						$key4=$var[2];
						}
	  	        		foreach my $vidx (0..$#var) {
							$sheet5->write($row4, $vidx, $var[$vidx],$format);
        						$l++;
						}
					$row4++;
					}
				}else{  
					if($sheetname ne $key4){	      	      	         
					foreach my $vidx (0..$#var) {
					        $sheet5->write($row4,$vidx,$var[$vidx]);
                                              	$l++;
				    	}
				$row4++;
    				}}
		}elsif(grep { $_ eq $sheetname } @MM){
			 	if($m==0){
				open(CSV, "$filename") or die "cannot open $!";
			       		while ( <CSV>) {
					@var=split(/,/,$_);
                                	my $format = ($. == 1) ? $bluebg : undef;
						if ($var[2]=~/ETH_*/){
						$key5=$var[2];
						}
			        		foreach my $vidx (0..$#var) {
							$sheet6->write($row5, $vidx, $var[$vidx],$format);
        						$m++;
						}
					$row5++;
					}
				}else{  
					if($sheetname ne $key5){	      	      	         
					foreach my $vidx (0..$#var) {
					        $sheet6->write($row5,$vidx,$var[$vidx]);
                                              	$m++;
				    	}
				$row5++;
    				}}
		}else {
                             	if($n==0){
				print "INSIDE IF loop\n";
				open(CSV, "$filename") or die "cannot open $!";
			       		while ( <CSV>) {
					@var=split(/,/,$_);
                                	my $format = ($. == 1) ? $bluebg : undef;
						if ($var[2]=~/ETH_*/){
						$key6=$var[2];
						}
		  	        		foreach my $vidx (0..$#var) {
							$sheet1->write($row6, $vidx, $var[$vidx],$format);
        						$n++;
						}
					$row6++;
					}
				}else{ 
					if ($sheetname ne $key6){
					foreach my $vidx (0..$#var) {
					        $sheet1->write($row6,$vidx,$var[$vidx]);
                                              	$n++;
				    	}
				$row6++;
    				}}
}
close(CSV);
return 1;
}


foreach my $f  (@input ) {
open (FH, "<","$f") or die "$!";
		while(<FH>){
			@var = split(/,/);
			if ($var[2] =~ /ETH_*/) {
                  	$word =$var[2];
		        write_sheet("$word",$f);
			}
		}
}
$wb->close();

#----------------------------------------------------------------------------
#MAIL
#----------------------------------------------------------------------------------
my $subject ="GDR VARIANTS CONSOLIDATED EXCEL";
open (MB, '>', $mailfile);
close (MB);
my $to_1='siva.shankar.kuppam@intel.com';
my $to_2 ='sunitha.marri@intel.com';
my $to_3='siddenki.sushmitha@intel.com';
my $to_4='s.sushma@intel.com';
my $to_5='chethan.k@intel.com';
#my $to_6='shruti.khajuria@intel.com';
my $to_7='divyalakshmi.rajasekaran@intel.com';
#$mail_cmd = "mail $to_1 $to_2 $to_3 $to_4 $to_5 $to_6 $to_7 -s \"$subject\" -a $reg_file <$mailfile" ;
$mail_cmd = "mail $to_1 $to_2 $to_3 $to_4 $to_5 $to_7 -s \"$subject\" -a $excel <$mailfile" ;
#$mail_cmd = "mail $to_3 -s \"$subject\" -a $excel <$mailfile" ;

system ($mail_cmd);
