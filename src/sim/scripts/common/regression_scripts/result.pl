#!/usr/bin/perl

use warnings;
use strict;
use File::Find;
use File::Basename;
use Getopt::Long;
use POSIX qw(strftime);
use List::MoreUtils qw(uniq);
use Spreadsheet::WriteExcel; 
use File::Copy::Recursive qw(dircopy);
use File::Path;

my $regPath;
my $mode;
my $etitle;
my $covPath;
my $NEWll10g_COV;
my $ll10g_COV;
my $MYPATH;
my @config;
my $topology;
my $csvPath;
my $llvar;
my @link;
my @build;
my $filename = 'reg_exe';
my $local_run;
my @to;
my $num = 1;
my $result = undef;
my (@seqlist,@seqlistpass,@seqlistfail,@seqseedpass,@seqseedfail);
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
my @abbr = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
$year += 1900;
my $edate = strftime "%d %b %Y %H:%M %p", localtime;
my $date1 = strftime "%d_%b", localtime;
my $time;
my ($acdsrpt,$acdsver);
my @rows;
my @values;
my $build;
my $num_of_configs;

my $res_file;
my $reg_file;
my $errorlist;
my $mailfile;
my $ignorelist;
my $new_file;


my $el_path;
my $cc_el_path;
my $elfile_list_path;
my $count=0;
my $exc;
my $exc_path;
my @ilist;
my @ierror;
my $single_cov_path;
my @data;
my $total;
my $pass;
my $fail;
my $Year;
my $month;
my $Day;
#coverage variables
my @files;
my $mergestring;
my ($ipath,$opath,$type);
my $outpath;
my $cov_enable;
my $proj;
my $start;
my $timevar;
my $mail_cmd;
my @cov_details;
my @cov_details_1;
my $single_merge;
my @bucketlist;
my @error_list;
my @t_cov;
my @report;
my @new;
my @new_1;
my $i;
my $k;
my @cov_rows;
my $a;
my $b;
my $c;
my $d;
my @sim1;
my @sim2;
my @reg_array;
my @reg_array_1;
my @file_t;
my $case1;
my $case2;
my @itf1;
my @itf2;
my @cov_det;
my @cov_det_1;
my @merged;
my @unique_list;
my $title;
my $name_of_day;
my $s_outpath;
my $countpass=0;
my $countfail=0;
my $r;
my $pk;
my $o ;
my $Passrate;
my @cc =(4,5,6,7,9,13,16,10_6,10_9,25_6,25_11,25_16,40_6,50_11,50_14,50_15,100_9,100_15,100_16,200_8,200_11,400_4,400_6); #code coverage only for Lead variants
#****************************************Function to find the file with ACDS version******************
sub find_acdsrpt {

     my $F = $File::Find::name;

          if ($F =~ /(.*\/top_ip0\/top_ip0_generation.rpt.*)/g ) {
        
         $acdsrpt = $1;

     	   }

}
#***********************************Function to extract pass/fail sequences****************************
sub find_txt {
    my ($string) = @_;
    my $F = $File::Find::name;

    #Push into sip sequence if exist, add the test_itf path here
    if($local_run == 1) {
      if ($F =~ /funct_determonistic\LL10g_FTILE_RUN\/device.*\/.*\/rtl_sim_compile_only_vcs\/.*sequence__(.*_seq.*)\/rtl_sim_simulate_only_vcs__(.*)\/$string/g ) { 
         
          if($string eq "pass") {push @seqlistpass, $1; push @seqseedpass, $2;}
          else             {push @seqlistfail, $1; push @seqseedfail, $2; print "fail seq detected\n $1 \n";}
     }   

   } else {
       chomp($llvar);
       if($llvar eq "BASER_A10"){
       print "llvar is ,inside baser loop \n $llvar ";
       if ($F =~ /LL10g_BASER_A10\/device_.*\/qsys_.*\/rtl_sim_compile_.*\/.*sequence__(.*_seq.*)\/rtl_sim_simulate_only_vcs__(.*)\/$string/g ) { 
         print "inside baser loop \n";   
         if($string eq "pass") {push @seqlistpass, $1; push @seqseedpass, $2;}
         else                  {push @seqlistfail, $1; push @seqseedfail, $2; print "fail seq detected\n $1 \n";}
       } 
       }elsif($llvar eq "BASERS10"){
       if ($F =~ /LL10g_BASERS10_RUN\/device_.*\/qsys_.*\/rtl_sim_compile_.*\/.*sequence__(.*_seq.*)\/rtl_sim_simulate_only_vcs__(.*)\/$string/g ) { 
            
         if($string eq "pass") {push @seqlistpass, $1; push @seqseedpass, $2;}
         else                  {push @seqlistfail, $1; push @seqseedfail, $2; print "fail seq detected\n $1 \n";}
       }}elsif($llvar eq "BASERS10_HTILE"){
       if ($F =~ /LL10g_BASERS10_HTILE\/device_.*\/qsys_.*\/rtl_sim_compile_.*\/.*sequence__(.*_seq.*)\/rtl_sim_simulate_only_vcs__(.*)\/$string/g ) { 
            
         if($string eq "pass") {push @seqlistpass, $1; push @seqseedpass, $2;}
         else                  {push @seqlistfail, $1; push @seqseedfail, $2; print "fail seq detected\n $1 \n";}
       }}elsif($llvar eq "FTILE_RUN"){
       if ($F =~ /LL10g_FTILE_RUN\/device_.*\/qsys_.*\/rtl_sim_compile_.*\/.*sequence__(.*_seq.*)\/rtl_sim_simulate_only_vcs__(.*)\/$string/g ) { 
            
         if($string eq "pass") {push @seqlistpass, $1; push @seqseedpass, $2;}
         else                  {push @seqlistfail, $1; push @seqseedfail, $2; print "fail seq detected\n $1 \n";}
       }}elsif($llvar eq "MGBASET_S10_HTILE"){
       if ($F =~ /LL10g_MGBASET_S10_HTILE\/device_.*\/qsys_.*\/rtl_sim_compile_.*\/.*sequence__(.*_seq.*)\/rtl_sim_simulate_only_vcs__(.*)\/$string/g ) { 
            
         if($string eq "pass") {push @seqlistpass, $1; push @seqseedpass, $2;}
         else                  {push @seqlistfail, $1; push @seqseedfail, $2; print "fail seq detected\n $1 \n";}
       }}elsif($llvar eq "RUN_A10"){
       if ($F =~ /LL10g_RUN_A10\/device_.*\/qsys_.*\/rtl_sim_compile_.*\/.*sequence__(.*_seq.*)\/rtl_sim_simulate_only_vcs__(.*)\/$string/g ) { 
            
         if($string eq "pass") {push @seqlistpass, $1; push @seqseedpass, $2;}
         else                  {push @seqlistfail, $1; push @seqseedfail, $2; print "fail seq detected\n $1 \n";}
       }}elsif($llvar eq "RUN_C10gx"){
       if ($F =~ /LL10g_RUN_C10gx\/device_.*\/qsys_.*\/rtl_sim_compile_.*\/.*sequence__(.*_seq.*)\/rtl_sim_simulate_only_vcs__(.*)\/$string/g ) { 
            
         if($string eq "pass") {push @seqlistpass, $1; push @seqseedpass, $2;}
         else                  {push @seqlistfail, $1; push @seqseedfail, $2; print "fail seq detected\n $1 \n";}
       }}elsif($llvar eq "MGE"){
       if ($F =~ /LL10g_s10MGE\/device_.*\/qsys_.*\/rtl_sim_compile_.*\/.*sequence__(.*_seq.*)\/rtl_sim_simulate_only_vcs__(.*)\/$string/g ) { 
            
         if($string eq "pass") {push @seqlistpass, $1; push @seqseedpass, $2;}
         else                  {push @seqlistfail, $1; push @seqseedfail, $2; print "fail seq detected\n $1 \n";}
       } 
       }elsif($llvar eq "s10MGE_HTILE"){
       print "llvar is :\n $llvar \n";
       if ($F =~ /LL10g_s10MGE_HTILE\/device_.*\/qsys_.*\/rtl_sim_compile_.*\/.*sequence__(.*_seq.*)\/rtl_sim_simulate_only_vcs__(.*)\/$string/g ) { 
            
         if($string eq "pass") {push @seqlistpass, $1; push @seqseedpass, $2;}
         else                  {push @seqlistfail, $1; push @seqseedfail, $2; print "fail seq detected\n $1 \n";}
       }}elsif($llvar eq "MGBASET"){
       if ($F =~ /LL10g_MGBASET_S10\/device_.*\/qsys_.*\/rtl_sim_compile_.*\/.*sequence__(.*_seq.*)\/rtl_sim_simulate_only_vcs__(.*)\/$string/g ) { 
            
         if($string eq "pass") {push @seqlistpass, $1; push @seqseedpass, $2;}
         else                  {push @seqlistfail, $1; push @seqseedfail, $2; print "fail seq detected\n $1 \n";}
       } 
       }else{
       if ($F =~ /LL10g_RUN\/device_.*\/qsys_.*\/rtl_sim_compile_.*\/.*sequence__(.*_seq.*)\/rtl_sim_simulate_only_vcs__(.*)\/$string/g ) { 
            
         if($string eq "pass") {push @seqlistpass, $1; push @seqseedpass, $2;}
         else                  {push @seqlistfail, $1; push @seqseedfail, $2; print "fail seq detected\n $1 \n";}
       } 
       }  
   }
}   
#--------------------------------------------------------------------
#Print out the regression,coverage and result table for a particular mode (per instance)
sub print_mail {
    my ($mode,$link_local,$seqlistpass_local,$seqlistfail_local,$seqseedpass_local,$seqseedfail_local) = @_;
    my $temp_mode = $mode;
    my $num = 1;
    my ($totalpass,$totalfail,$realtotal);    
    $totalpass = scalar @{$seqlistpass_local};
    $totalfail = scalar @{$seqlistfail_local};
    $realtotal = $totalpass + $totalfail;   
    print "pass = $totalpass\n";
    print " fail=$totalfail\n";
}

#**************************************************************************************************
#----------
#Get option
#----------
GetOptions ( 'regpath=s' => \$regPath,
             'mode=s' => \$mode , 
             'covpath=s' => \$covPath,
             'NEWll10g_COV=s'=> \$NEWll10g_COV,
	     'csvpath=s' => \$csvPath,
             'time=s' => \$time,
             'cov_enable=i' => \$cov_enable,
	     'proj=s' => \$proj,
	     'ipath=s' => \$ipath,
             'topology=s'=> \$topology,
	     'num_of_configs=i'=>\$num_of_configs,
             'opath=s' => \$opath,
	      'start=s' =>\$start,
              'timevar=s' =>\$timevar,
	      'Day=s' =>\$Day,
	      'month=s' =>\$month,
	      'Year=s'=>\$Year,
              'name_of_day=s'=>\$name_of_day,
	      'title=s'=>\$title,
	      'exc_path=s' =>\$exc_path,
	      'exc=i' =>\$exc,
              'local_run=i' =>\$local_run,
	      'llvar=s' =>\$llvar,
	      'res_file=s' =>\$res_file,
	      'new_file=s' =>\$new_file,
	      'reg_file=s' =>\$reg_file,
	      'errorlist=s' =>\$errorlist,
	      'mailfile=s' =>\$mailfile,
	      'ignorelist=s' =>\$ignorelist,
            'etitle=s' => \$etitle);


print "topology is :$topology\n";
print "llvar is :$llvar\n";

#regpath = path to regression result example: /p/psg/pipe/etile/25ganltdv_1/users/chihweit/daily_regress_04Aug2018/regtest/ip/ethernet/alt_ethernet_crete/alt_ehip_c3/ehip/$mode/
#covpath = path to coverage (nfs directory), directory before mode example: /nfs/site/disks/etile_25ganltdv_1/users/chihweit/COVERAGE/

#if(defined($covPath)) {#$covPath =~ s/\//\\/g;
#print "INSIDE covPath:$covPath\n";
#}

#-----------------------------------------------------------------
#Extract the pert links
#-----------------------------------------------------------------
#Read from the reg_exe.log

if($local_run == 1) {
      $reg_file ="$regPath/regression_run_status.csv";
      my  @newregPath = split /qhip/, $regPath;
      $exc_path = "$newregPath[0]testbench/coverage_excl/common";
      $ipath ="$regPath/ACC_COV";
      $opath = "$regPath/MERGED_COV";
      $mode = "QHIP";
      $name_of_day= strftime "%a",localtime;
      $time=strftime "%d%b%Y", localtime;
      $proj="LL10G";
	$title="ETH_$topology"; 
}
###------------------------variant----
my $variants;
if( grep( /^$topology$/, @cc ) ){
 $variants = " LV";
}
elsif($title=~/ETH_mm*/ ){
 $variants = " ";
}
elsif($title =~ /ETH_PS_*/ ){
 $variants = " ";
}
else{
 $variants = "NLV";}
print "variant is : $variants";



###----------------------------------- Capture Spetclink 
if($local_run == 0) {
    $filename = $filename."_".$topology.".log";
    print" $regPath$filename\n";
    open(FH25,'<', $regPath.$filename)|| die "Can't open log$!";
    foreach my $line3 (<FH25>){
           chomp($line3);
           if($line3 =~  /Targeted build:/g){
                                             push @build,$line3;
				             @values=split('/',$line3);
         				     $build="$values[1]/$values[2]";
				  	     print "build is $build";
				             }
    
                              }
    close FH25;
    open(FH26,'<', $regPath.$filename)|| die "Can't open log$!";
    foreach my  $line2 (<FH26>){
          chomp($line2);
          if($line2 =~  /Link to SPeTC: https:/g){
                                                  print "INSIDE CAPTURE SPECTC LINK:$line2\n";
                                                  push @link, $line2;  
                                                 } 
    
                              }
    close FH26;
}
#------------------------------------------------------------------
#Extract the pass/fail sequences
find( sub {find_txt("pass");}, $regPath);
find( sub {find_txt("fail");}, $regPath);
find({ wanted => \&find_acdsrpt, no_chdir=>0}, $regPath);
#-----------------------------------------------------------------
#Extract the ACDS version
if ($acdsrpt =~ /.gz$/) {
    open(FHACDS,"gunzip -c  $acdsrpt |");
} else {
    open(FHACDS,'<', $acdsrpt);
}
foreach my $line2 (<FHACDS>){
     chomp($line2);
     if($line2 =~ /Generated by version:(.*)/g){
            $acdsver = $1;
     }

}     
close FHACDS;

#-----------------------------------------------------------------
#Mail the pert link for the test
#-----------------------------------------------------------------
#Begin HTML
if($mode eq "QSIP") {print_mail($mode,\@link,\@seqlistpass,\@seqlistfail,\@seqseedpass,\@seqseedfail);}
$pass=scalar(@seqlistpass);
$fail=scalar(@seqlistfail);
$total=$pass+$fail;

#------------------------------------------------
#Coverage 
#------------------------------------------------
my @MYPATH;
if ($cov_enable==1){

   GetOptions("ipath=s" => \$ipath,
           "time=s"  => \$time,
           "opath=s" => \$opath,
           "cov_enable=i" => \$cov_enable,
	       "covpath=s" => \$covPath,
           "NEWll10g_COV=s"=> \$NEWll10g_COV,
           "proj=s"  => \$proj,
	       "title=s"=>\$title,
           "mode=s"  => \$mode);
           
          
	if ($local_run == 1 ){
 		 my $usr=`whoami`;
  		 my $user  = chomp($usr); 
         print "user:$usr";
         $covPath ="/nfs/sc/disks/fm7_cryptosip_1/users/$usr/COV_DIR";
         print "COVERAGRE PATH: $covPath";
         $NEWll10g_COV="/nfs/sc/disks/fm7_cryptosip_1/users/ll10g_COV_VDBS/Eth_$topology";
         $MYPATH =`ls -t $regPath/device_*/ | head -1`;
 	} else {
		if($title =~ /ETH_PS_*/){
		   @MYPATH =`ls -t $regPath/regtest/ip/ethernet/alt_ethernet_crete_ll10g/qhip/scripts/funct_deterministic/LL10g_RUN/device_*/ | head -$num_of_configs`;
		   print "NUMBER OF CONFIGS:$num_of_configs\n";
		   foreach my $q(@MYPATH){
		      print "MYPATH:$q\n";
 	       }
		} else {
		   $MYPATH =`ls -t $regPath/regtest/ip/ethernet/alt_ethernet_crete_ll10g/qhip/scripts/funct_deterministic/LL10g_FTILE_RUN/device_*/ | head -1`;
		   print "MYPATH:$MYPATH\n";
		}
	}

    #$ll10g_COV="$NEWll10g_COV/$date1";
    #mkdir $ll10g_COV	;

    ###################################################### 
    ##### copy generated  local VDBs to central path #####
    ###################################################### 
   # if($title =~ /ETH_PS_*/){
   #     foreach my $h(@MYPATH){
   #        @config=split('__',$h);
   #        chomp($config[1]);
   #        print "CONFIG is:$config[1]_PS\n";
   #        `cp -rf $covPath/${config[1]}_PS $GDR_COV/`;
   #     }
   # }else{
   #     print"IN else loop\n";
   #     #@config=split('__',$MYPATH);
   #     @config=split('_n0_',$MYPATH);
   #     $ll10g_COV="$NEWll10g_COV/$date1";
   #     mkdir $ll10g_COV	;
   #     chomp($config[1]);
   #     print "CONFIG is:$config[1]\n";
   #     `cp -rf $covPath/t0_${config[1]}_ $ll10g_COV/`;
   # }

    ###################################################### 
    ####   copy central all VDBS to regression path ######
    ###################################################### 
    #`cp -rf $NEWll10g_COV/ $ipath/$name_of_day/`;

    #---------For merging daily vdbs'----------------
	chdir($ipath);
    print "topology: $topology\n";
    #$single_cov_path=$ipath."/".$name_of_day."/".$date1 ."/";
    $single_cov_path=$ipath."/".$name_of_day."/";
    #$single_cov_path=$ipath."/".$name_of_day."/Eth_".$topology."/".$date1 ."/";
	print "SINGLE_COVERAGE PATH:$single_cov_path\n";

    #--------Find directories with vdb files-------
	find( sub {find_vdb();}, $ipath);
    print "IPATH:$ipath\n";

    #-------vdb's--------------------------------------
    sub find_vdb {   
       my $N = $File::Find::name;        
       if ($N =~ /\/*.vdb$/g ) {        
           if($N !~ /xml/){
              chomp($N);
              $mergestring .= $N." ";                 
            }                
       }
    }

    
    chdir ($single_cov_path);
    find ( sub {find_sim_vdb();},$single_cov_path);
    #------------sim_vdb's------------------
    sub find_sim_vdb {    
       my $C = $File::Find::name;         
       if ($C =~ /\/*.vdb$/g ) {        
          if($C !~ /xml/){
               chomp($C);
               $single_merge .= $C." ";                   
          }                
       }
    }

    #---------------------------------------
    print "[INFO] Merging all found vdbs\n";
    print "output path: $opath\/mergedcov\_$time \n";

    $outpath=$opath."/mergedcov_".$time."/dashboard.txt";
    $s_outpath=$opath."/single_cov_".$time."/dashboard.txt";

    print "$s_outpath\n";
    print "DBG: outpath      : $outpath\n";
    print "DBG: single_merge : $single_merge\n";
    print "DBG: merge_string : $mergestring\n";


    if ($exc){
	   chdir ($exc_path);
       find ( sub {find_exc();},$exc_path);
	   
       sub find_exc {     
        	print "DBG inside find exc\n";                    
  		 my $H = $File::Find::name;          
                 #    if ($H =~ /el$/g ) {       
                 #          chomp($H);
                 #         $el_path .= $H." ";
                 # $el_path = '/nfs/sc/disks/swuser_work_ssushmit/GDR_REGRESSION_Eth_7/depot/acds/main/regtest/ip/ethernet/alt_ethernet_crete_gdr/testbench/coverage_excl/common/gdr_tb.el'; 
		 if($topology == 7){
		        $el_path = "$exc_path/gdr_tb_25G.el";
	         }
		 else {
       		        $el_path = "$exc_path/gdr_tb.el";
		 }
        	 print "INSIDE EXC_PATH:$el_path\n";                    
                 #         }        
       		if( grep( /^$topology$/, @cc ) ) {
       	    	#if( $topology== "25_11" ) {
        	 	print "DBG1:$title\n";                    
  		 	my $I = $File::Find::name;          
		    	#$cc_el_path = "$exc_path/Eth$topology\_cc.el";
		    	$cc_el_path = "$exc_path$title\_cc.el";
		    	$elfile_list_path = "$exc_path$title\_ELFILE.el";
        	 	print "INSIDE CC_EXC_PATH:$cc_el_path\n";  
        	 	print "INSIDE elfilelist_EXC_PATH:$elfile_list_path\n";  
		 }                  
       }
       #MERGE_COV :`urg -dir $mergestring -dbname $opath/mergedcov_$time/mergedcov_$time -full64 -report $opath/mergedcov_$time -format both -elfile $el_path`; 
       #MERGE_COV : print "COVERAGE : Merged report generated\n";
      if( grep( /^$topology$/, @cc ) ) {
        print "DBG: urg -dir $single_merge -dbname $opath/single_cov_$time/single_cov_$time -full64 -report $opath/single_cov_$time -format both -elfile $el_path -elfile $cc_el_path\n";  
	`urg -dir $single_merge -dbname $opath/single_cov_$time/single_cov_$time -full64 -report $opath/single_cov_$time -format both`; 
	} 
	else {
  	`urg -dir $single_merge -dbname $opath/single_cov_$time/single_cov_$time -full64 -report $opath/single_cov_$time -format both`; 
	}
    print "COVERAGE : single report generated\n";

}
else{
  	`urg -dir $mergestring -dbname $opath/mergedcov_$time/mergedcov_$time -full64 -report $opath/mergedcov_$time -format both`;
  	`urg -dir $single_merge -dbname $opath/single_cov_$time/single_cov_$time -full64 -report $opath/single_cov_$time -format both`;
}
sleep(150);
    if(-e $opath) {
      #do nothing
    } else {
	  `mkdir $opath`;
    }

    if($opath =~ /\/$/) {
	  #do nothing
    } else {	
	  $opath .= "/";
    }


    #MERGE_COV: open (FILE, $outpath) or die $!;
    #MERGE_COV: my @array;
    #MERGE_COV: 
    #MERGE_COV: while (@array = <FILE>) {
    #MERGE_COV:     $i = 0;
    #MERGE_COV:     foreach my $l (@array) {
    #MERGE_COV:         if ($l =~/Total Coverage Summary/ ) {
    #MERGE_COV:             $a = $array[$i+1];
    #MERGE_COV:             push (@new, $a);
    #MERGE_COV:             $b = $array[$i+2];
    #MERGE_COV: 	        push (@new, $b);
    #MERGE_COV:         }
    #MERGE_COV:         $i++;
    #MERGE_COV:     }
    #MERGE_COV: }
    #MERGE_COV: close(FILE);


    open (FI, $outpath);
    my @array_1;
    
    while (@array_1 = <FI>) {
        $k = 0;
        foreach my $li (@array_1) {
            if ($li =~/Total Coverage Summary/ ) {
                $c = $array_1[$k+1];
                push (@new_1, $c);
                $d = $array_1[$k+2];
    	        push (@new_1, $d);
            }
            $k++;
        }
    }
   close(FI);

#MERGE_COV: @cov_det = split /  /, $b;
#MERGE_COV: chop $cov_det[-1];
 @cov_det_1 = split / /, $d;

my $index=0;

#MERGE_COV: foreach (@cov_det_1){ #MERGE_COV: foreach (@cov_det){
#MERGE_COV: if ($_=~/--$/){
#MERGE_COV: my $f=$_;
#MERGE_COV: $f=substr($f, 0, -2);
#MERGE_COV: push @cov_details, $f;
#MERGE_COV: push @cov_details, "--";
#MERGE_COV: $index=$index+2;
#MERGE_COV: }
#MERGE_COV: elsif ($_ ==" "){
#MERGE_COV: $index++;
#MERGE_COV: }
#MERGE_COV: else {
#MERGE_COV: push @cov_details, $_;
#MERGE_COV: $index++;
#MERGE_COV: }
#MERGE_COV: }


my $index_1=0;

foreach (@cov_det_1){
if ($_=~/--$/){
my $fq=$_;
$fq=substr($fq, 0, -2);
push @cov_details_1, $fq;
push @cov_details_1, "--";
$index_1=$index_1+2;
}
elsif ($_ ==" "){
$index_1++;
}
else {
push @cov_details_1, $_;
$index_1++;
}
}
#MERGE_COV: foreach my $z (@cov_details){
#MERGE_COV: print "$z\n";
#MERGE_COV: }
print "cov_details_1\n";
foreach my $z (@cov_details_1){
print "$z\n";
}


}

#-----------------------------------------------------------------------------------------------
#..........................................Setting up Ignore List ............................................

open my $handle, '<', $ignorelist;
chomp(@error_list = <$handle>);
close ($handle);

#------------------------------------------------pass rate ----
foreach my $k (@seqlistpass){
$countpass=$countpass+1;
}
foreach my $v (@seqlistfail){
$countfail=$countfail+1;

}
print " countfail: $countfail \n";
my $Passrate1;
if($countpass+$countfail==0){
 $Passrate1=0;
}else{
$Passrate1=($countpass / ($countpass +$countfail))*100;
}
print "Passrate1:$Passrate1";

$Passrate = sprintf("%.2f", $Passrate1);
print "Passrate :$Passrate";

#----------------------------------------------
#preparing fm68_sip.csv
#----------------------------------------------
push @rows, ",,,,,,,,,,";
push @rows, "MERGED COVERAGE,";
push @rows, ",,,,,,,";
push @rows, "SINGLE COVERAGE\n";
push @rows, "DATE,";
push @rows, "IP,";
push @rows, "VARIANT,";
push @rows, "Lead Variant,";
push @rows,"BUILD,";
push @rows, "PERT Link,";
push @rows,"PASS RATE,";
push @rows, "Tests,";
push @rows, "Pass,";
push @rows, "Fail,";
push @rows, "SCORE,";
push @rows, "LINE,";
push @rows, "COND,";
push @rows, "TOGGLE,";
push @rows, "FSM,";
push @rows, "BRANCH,";
push @rows, "ASSERT,";
push @rows, "GROUPS,";
push @rows, "SCORE,";
push @rows, "LINE,";
push @rows, "COND,";
push @rows, "TOGGLE,";
push @rows, "FSM,";
push @rows, "BRANCH,";
push @rows, "ASSERT,";
push @rows, "GROUPS";
push @rows, "\n";

push @cov_rows, $time;
push @cov_rows, ",";
push @cov_rows, "LL10G,";
push @cov_rows, "$title,";
push @cov_rows, "$variants,";
push @cov_rows,"$build,";
push @cov_rows, @link;
push @cov_rows, ",";
push @cov_rows, $Passrate;
push @cov_rows, ",";
push @cov_rows, $total;
push @cov_rows, ",";
push @cov_rows, $pass;
push @cov_rows, ",";
push @cov_rows, $fail;

if($cov_enable==1){
#MERGE_COV: push @t_cov, @cov_details;
push @t_cov, @cov_details_1;
foreach my $rt (@t_cov){
print "$rt\n";
}
my $j=0;
foreach my $c (@t_cov){
 push @cov_rows, ",";
 push @cov_rows, $t_cov[$j];
 $j++
}
}
if(($cov_enable==0)) {# or ($variant eq "PS")){
push @cov_rows,",NA,";
push @cov_rows,"NA,";
push @cov_rows,"NA,";
push @cov_rows,"NA,";
push @cov_rows,"NA,";
push @cov_rows,"NA,";
push @cov_rows,"NA,";
push @cov_rows,"NA,";
push @cov_rows,"NA,";
push @cov_rows,"NA,";
push @cov_rows,"NA,";
push @cov_rows,"NA,";
push @cov_rows,"NA,";
push @cov_rows,"NA,";
push @cov_rows,"NA,";
push @cov_rows,"NA";
push @cov_rows, " \n";
}
if($local_run == 0) {
if ( -z $res_file ){
print "new_file\n";
open(FH, '>', $res_file) or die $!;
print FH @rows;
print FH @cov_rows;
close(FH);
}
else {
print "appending\n";
open (FH1, ">>", $res_file) or die $!;
print FH1 @cov_rows;
close FH1;
}
##-----------------------------------------
my $remain;
my $remain1;
my $remain2;
my @line;
my $totalline;
my $first;


if ( -z $new_file ){
print "newcsv_file\n";
open(FH2, '>', $new_file) or die $!;
print FH2 @rows;
print FH2 @cov_rows;
close(FH2);
}
else {
print "appending csv\n";
open (FH3, ">>", $new_file) or die $!;
chomp;
print FH3 @cov_rows;
#print FH3 "\n";
close FH3;
open (FH4, "<", $new_file) or die $!;
@line =<FH4>;
$totalline = @line;
print "last no. : $totalline \n";
$first = 2;
$remain = $totalline - $first;
 if($remain >= 12){
 `sed -i '3d' $new_file`;
 }
 elsif($remain < 12){
 print "No change";
 }
print "No change";
}




#---------------------------------------------------------
##code to get consolidated xls 
#sub write_sheet ($$$) {
#  	my ($excelfile, $sheetname, $filename) = @_;
#               	 	print "Sheet Name = $sheetname\n";
#	                 print "File Name  = $filename\n";
#                	 my $sheet = $excelfile->addworksheet($sheetname);
#                   	 my $bluebg = $excelfile->addformat();
#                 	 $bluebg->set_color('blue');
#			open(CSV, "$filename") or die "cannot open $!";
#			while (<CSV>) {
#    				chomp;
#    				my(@vals)=split(/,/, $_);
#                       		my $format = ($. == 1) ? $bluebg : undef;
#      				foreach my $vidx (0..$#vals) {
#        			$sheet->write(($.-1), $vidx, $vals[$vidx],$format);
#    					}
#					}
#				close(CSV);
#				return 1;
#			}
#my @input = glob('/nfs/sc/disks/gdr_regression_3/users/GDR_REPORT/ALL_CSV/GDR_ETH_*.csv');
#my $wb = Spreadsheet::WriteExcel->new("/nfs/sc/disks/gdr_regression_3/users/GDR_REPORT/gdr_report.xls"); 
#foreach my $f  (@input ) {
#my @colc;
#my $word;
#open (FH, "<","$f") or die "$!";
#	while(<FH>){
#     		@colc = split(/,/);
#        	if ($colc[2] =~ /ETH_*/) {
#                   $word =$colc[2];
#  			 print "$colc[2]";
#			} 
#           	}
# 	write_sheet($wb,"$word",$f);
#}
#$wb->close();
}

#---------------------------------------------------------
#Preparing regression_result.csv
#---------------------------------------------------------
push @reg_array, 'FAILED TEST,';
push @reg_array, 'PATH,';
push @reg_array, "FIRST FAILED CASE";
push @reg_array, "\n";

find (sub{failed_seq();},$regPath);
sub failed_seq{
	my $simfile = $File::Find::name;

	push @sim2, $simfile;
}

my @newseqlistfail=uniq(@seqlistfail);

foreach  $r (@newseqlistfail){
	push @reg_array_1,$r;
	push @reg_array_1,",";
	@file_t=grep (/$r\/.*seed_*.*sim.log$/ || /.*$r\/.*seed_*.*sim.log.gz$/,@sim2);
   	foreach my $w (@file_t){
		push @reg_array_1,$w;
                push @reg_array_1,",";
	        if ($w=~/gz$/){
			print "entered if, detected gz\n";
			open (FHG,"gunzip -c $w |");
			push @itf1,grep (/UVM_ERROR/ || /UVM_FATAL/ || ((/error/i) && !("pma_aib_tx_clk_expected_setting")) , <FHG>); 
			close (FHG);
				foreach  $pk (@itf1){
				if ($pk=~/UVM_INFO/g){
				}
				elsif (($pk=~/UVM_ERROR/g)|| ($pk=~/UVM_FATAL/g) ){
		 			if (($pk =~/:    0/g) || ($pk=~/:    0/g)){
					}
					else{
						push @itf2, $pk;
					}
				}
				else{
					(my $y = $pk) =~ s/(\w+).*/$1/;
					foreach $o (@error_list){
                          		if ($y eq $o){
						$count=1;
					}
					}
					if($count ==0){
						push @itf2, $pk;
						}
					else{
					$count=0;
					}
				}
			}

		$case1=$itf2[0];
                $case2=$itf2[1];
		print "$case1\n";
                print "$case2\n";
		chomp ($case1);
               chomp($case2);
        	push (@bucketlist, @itf2);
       		push @reg_array_1,$case1;
                push @reg_array_1,"\n";
                push @reg_array_1,",";
                 push @reg_array_1,",";
               push @reg_array_1,$case2;
		undef @itf1;
		undef @itf2;
		}
            
	else{
		  open (FHR , '<', $w) ;
               	  print"\n normal file\n";
		  push @itf1, grep (((/UVM_ERROR/) && !(/UVM_ERROR :/)) || ((/UVM_FATAL/)&& !(/UVM_FATAL :/)) || ((/error/i) && !("pma_aib_tx_clk_expected_setting"))   , <FHR>);
                  close (FHR);
			foreach $pk (@itf1){
				if ($pk=~/UVM_INFO/g){
				}
				elsif (($pk=~/UVM_ERROR/g)|| ($pk=~/UVM_FATAL/g) ){
		 			if (($pk =~/:    0/g) || ($pk=~/:    0/g)){
					}
					else{
						push @itf2, $pk;
					}
				}
				else{
					(my $y = $pk) =~ s/(\w+).*/$1/;
					foreach  $o (@error_list){
                          		if ($y eq $o){
						$count=1;
					}
					}
					if($count ==0){
						push @itf2, $pk;
						}
					else{
					$count=0;
					}
				}
			}
			$case1=$itf2[0];
                $case2=$itf2[1];
		print "$case1\n";
                print "$case2\n";
		chomp ($case1);
               chomp($case2);
        	push (@bucketlist, @itf2);
       		push @reg_array_1,$case1;
                push @reg_array_1,"\n";
                push @reg_array_1,",";
                 push @reg_array_1,",";
               push @reg_array_1,$case2;
		undef @itf1;
		undef @itf2;
		}
            push @reg_array_1,"\n";
            push @reg_array_1,",";
       	}
   	 push @reg_array_1, "\n";
        
}




#...................................................................................................................
open (FR, '>', $reg_file);
print FR @reg_array;
print FR @reg_array_1;
close (FR);
@unique_list= uniq(@bucketlist);

open (FRL, '>', $errorlist);
print FRL @unique_list;
close (FRL);

if ($local_run == 1 ){
 $mailfile ="$regPath/mailfile.txt";
}

######################################################
############        Send MAIL               ###########
#######################################################
#my $subject ="$proj $variant $title DAILY REGRESSION RESULT";

my $subject ="$proj $title DAILY REGRESSION RESULT";
open (MB, '>', $mailfile);
print MB "$proj $title DAILY TEST REGRESSION RESULT $time \n\n";
if($local_run==0){ 
   print MB "\nStarted at : $Day $month $Year $start $timevar \n";
}
print MB "\nEnded at : $edate\n";
print MB "\nACDS Version:$build\n";
print MB "\n@link\n";
print MB "Regression Path :$regPath \n";
print MB "\n*****************************************************************************************\n";
printf MB "OVERALL PASS RATE\t\t\t: $Passrate%\n";	
print MB "Total number of passed sequences\t: $countpass\n";
print MB "Total number of failed sequences\t: $countfail\n";
print MB "*****************************************************************************************\n";
if ($cov_enable==1){
   print MB "Coverage details:\n\n";
   print MB "\tCode_SCORE\t:$cov_details_1[0]\n";
   print MB "\tLINE\t\t:$cov_details_1[1]\n";
   print MB "\tCOND\t\t:$cov_details_1[2]\n";
   print MB "\tTOGGLE\t:$cov_details_1[3]\n";
   print MB "\tFSM\t\t:$cov_details_1[4]\n";
   print MB "\tBRANCH\t:$cov_details_1[5]\n";
   print MB "\tASSERT\t\t:$cov_details_1[6]\n";
   print MB "\tFunctional_GROUPS:$cov_details_1[7]\n";
   print MB "****************************************************************************************\n\n";
}
#print MB "*****************************************************************************************\n";
#print MB "FAILED SEQUENCES\n";
#print MB "*****************************************************************************************\n\n";
#foreach my $v (@seqlistfail){
#print MB "$v\n";
#}
#print MB "\n";
#print MB "****************************************************************************************\n";
#print MB "PASSED SEQUENCES\n";
#print MB "****************************************************************************************\n\n";
#foreach my $k (@seqlistpass){
#print MB "$k\n";
#}
#print MB "\n**************************************************************************************\n";
close (MB);

my $to_1='siva.shankar.kuppam@intel.com';
#my $to_2='amruthax.varanasi@intel.com';
#my $to_3='monikax.prashant.nagarnaik@intel.com';
my $to_4 ='sunitha.marri@intel.com';
my $to_3='siddenki.sushmitha@intel.com';
#my $to_4='s.sushma@intel.com';
my $to_5='chethan.k@intel.com';
my $to_6='mareboina.shankar@intel.com';
#my $to_7='divyalakshmi.rajasekaran@intel.com';
#my $to_8='abhishek3.tiwari@intel.com';
#my $to_9='mridula.karmakar@intel.com';
#my $to_10='abhishekx.kumar.prasad@intel.com';
#$mail_cmd = "mail $to_1 $to_2 $to_3 $to_4 $to_5 $to_6 $to_7 $to_8 $to_9 $to_10 -s \"$subject\" -a $res_file -a $reg_file -a $errorlist<$mailfile" ;
#$mail_cmd = "mail $to_1 $to_2 $to_4 $to_5 $to_7 $to_9 -s \"$subject\" -a $annotated_hvp -a $reg_file <$mailfile" ;
#if(($cov_enable==1) and ($variant ne "PS")){
#$$mail_cmd = "mail $to_1 $to_2 $to_4 $to_9 -s \"$subject\" -a $annotated_hvp -a $reg_file <$mailfile" ;
#} else {
$mail_cmd = "mail $to_1 $to_4 $to_6 $to_3 $to_5 -s \"$subject\" -a $reg_file <$mailfile" ;
#}
system ($mail_cmd);
