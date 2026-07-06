#!/usr/bin/perl

use warnings;
use strict;
use Spreadsheet::WriteExcel;
my @input = glob('/nfs/site/disks/ship_eth_coe_1/users/pipe_pg_3/LL10G_IP/ll10g_REPORT/ALL_CSV/ll10g_*.csv'); #/nfs/sc/disks/fm7_cryptosip_1/users/DM_REPORT/ALL_CSV/DM_ETH_10g.csv
my $wb = Spreadsheet::WriteExcel->new("/nfs/site/disks/ship_eth_coe_1/users/pipe_pg_3/LL10G_IP/ll10g_REPORT/ll10g_consolidatedreport.xls"); 
my $excel="/nfs/site/disks/ship_eth_coe_1/users/pipe_pg_3/LL10G_IP/ll10g_REPORT/ll10g_consolidatedreport.xls";
my $mailfile ="/nfs/site/disks/ship_eth_coe_1/users/pipe_pg_3/LL10G_IP/ll10g_REPORT/mailfile.txt";

my @MAC =("BASER_A10_10g","BASERS10_10g","BASERS10_HTILE_10g","MGE_2p5g");
my $sheet1 = $wb->addworksheet("PCS_MAC");
my $i=0;
my $j=0;
my $k=0;
my $l=0;
my $m=0;
my $n=0;
my $o=0;
my $p=0;
my $q=0;
my @var;
my $row1=0;
my $row2=0;
my $row3=0;
my $row4=0;
my $row5=0;
my $row6=0;
my $row7=0;
my $row8=0;
my $row9=0;
my $bluebg = $wb->addformat();
$bluebg->set_color('blue');
my $mail_cmd; 
my $word;
my ($key1,$key2,$key3,$key4,$key5,$key6,$key7,$key8,$key9);

sub write_sheet ($$) {
		my ($sheetname, $filename) = @_;
		print "Sheet Name = $sheetname\n";
		print "FILENAME=$filename\n";
		if( grep { $_ eq $sheetname } @MAC){
				if($i==0){
				open(CSV, "$filename") or die "cannot open $!";
			       		while ( <CSV>) {
					@var=split(/,/,$_);
                                	my $format = ($. == 1) ? $bluebg : undef;
						#if ($var[2]=~/ETH_*/){
						$key1=$var[2];
						#}
		  	        		foreach my $vidx (0..16) {
							$sheet1->write($row1, $vidx, $var[$vidx],$format);
        						$i++;
						}
					$row1++;
					}
				}else{  
					if($sheetname ne $key1){	      	      	         
					foreach my $vidx (0..16) {
					        $sheet1->write($row1,$vidx,$var[$vidx]);
                                              	$i++;
				    	}
				$row1++;
    				}}
		}
close(CSV);
return 1;
}


foreach my $f  (@input ) {
print "inside foreach\n";
open (FH, "<","$f") or die "$!";
		while(<FH>){
			@var = split(/,/);
                        #if ($var[2] =~ /*/) {
                  	$word =$var[2];
		        print "word = $word\n";
		        write_sheet("$word",$f);
                        #}
		}
}
$wb->close();

#----------------------------------------------------------------------------
#MAIL
#----------------------------------------------------------------------------------
my $subject ="LL10G VARIANTS CONSOLIDATED EXCEL";
open (MB, '>', $mailfile);
close (MB);
my $to_1 ='sunitha.marri@intel.com';
my $to_2 ='shruti.khajuria@intel.com';
my $to_3 ='chethan.k@intel.com';
my $to_4 ='siddenki.sushmitha@intel.com';
my $to_5 ='rohith.acharya@intel.com';
my $to_6 ='saideepx.bodla@intel.com';
my $to_7 ='mareboina.shankar@intel.com';
my $to_8 ='siva.shankar.kuppam@intel.com';

#$mail_cmd = "mail $to_1 $to_3 $to_4 $to_7 $to_8 -s \"$subject\" -a $excel <$mailfile" ;
#$mail_cmd = "mail $to_3 $to_4 $to_7 -s \"$subject\" -a $excel <$mailfile" ;
$mail_cmd = "mail $to_4 -s \"$subject\" -a $excel <$mailfile" ;

system($mail_cmd);
print "Mail sent\n";
