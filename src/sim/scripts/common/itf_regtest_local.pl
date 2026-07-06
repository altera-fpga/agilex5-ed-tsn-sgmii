#These give you extra warnings/errors your perl code.  Don't remove them!
use strict;
use warnings;
require 'perl_1.pl'; 
require 'perl_ptp.pl'; 
use RegTest;
use SetEnv;
#use File::Copy qw(move);
use File::Copy;
use File::Copy::Recursive qw(rcopy);
use Cwd;
use Time::localtime;
use List::Util qw(shuffle);
use Switch;
require "variant_gen.pl";
# sets up environment variables
&SetEnv::setup_env();
my $snps;
# New variable introduced for enabling the right version of VCS for ANLT pert.conf:
my $vcsv;
#ITF::set_option('use_unencrypted_rtl','qsys',1);
#ITF::set_option('use_unencrypted_rtl','qsys',1);
## Always needed when providing HDL testbench
#ITF::set_option('search_path', 'qsys', "$ENV{'ACDS_DEST_ROOT'}/not_shipped/ip/**/*,\$"); # Need to removed later 
ITF::set_option('run_spd_flow', 'simulation', 1);
ITF::set_option('enable_qsys_reg_exe_flags','ITF',0);
ITF::set_option('use_ip_setup_simulation_flow', 'simulation', 1);
#ITF::set_option('no_generated_ip_files', 'simulation', 1);
ITF::set_option('testbench_name', 'simulation', "eth_env_top"); #top-level module
my @failing_patterns = ("ALT_RTL_ASSERT","Assertion offending");
ITF::set_option('additional_sim_log_err_patterns_arr_ref', 'simulation.vcs', \@failing_patterns);
my @my_pass_patterns = ( "UVM_FATAL :    0", "UVM_ERROR :    0" );
ITF::set_option('sim_log_passing_patterns_arr_ref', 'simulation', \@my_pass_patterns);
# Use both UVM_FATAL and UVM_ERROR, if both are not present or differ, then it is a fail
ITF::set_option("use_all_passing_patterns", "simulation", 1);
ITF::set_option('disable_vhdl', 'ITF', 1);  
ITF::set_option("no_testbench_source_files", "simulation.vcs", 1);
#ITF::set_option('fast_vcs_serdes_mode', 'simulation.vcs', 1); 
#ITF::set_option("itf_verbose_mode",'ITF',7);
ITF::pass_files_to_children("*.f");
      ITF::pass_files_to_children(".*hex");     
ITF::pass_files_to_children("top_level_attributes.json");
ITF::pass_files_to_children("top_level_attributes_2.json");
my $current_path;
my $enable_an=ITF::get_option("enable_an","ITF")||1; 
my $enable_lt=ITF::get_option("enable_lt","ITF")||1;
my $topology = ITF::get_option("topology", "ITF") || '10g';
my $plaintext = ITF::get_option("plaintext", "ITF") || 0;
my $cov_dir= ITF::get_option("cov_dir","ITF");
my $ptp_en = ITF::get_option("ptp_en", "ITF") || 0;

 
if ($cov_dir == 1)
{
      if(($enable_an==1) || ($enable_lt==1))
      {
	ITF::itf_print_info("Coverage location not defined by user: $cov_dir");
        $cov_dir="/nfs/sc/disks/swip_sipeth_1/users/$ENV{'USER'}/cov_$topology.vdb";
      }
      else {
	ITF::itf_print_info("Coverage location not defined by user: $cov_dir");
        $cov_dir="$ENV{'MRPHY_COVERAGE_PATH'}/$topology/cov_$topology.vdb";
        #$cov_dir="$ENV{'REG_LOCAL_ROOT_DIR_PATH'}/ip/ethernet/alt_ethernet_crete_gdr/qhip/scripts/funct_deterministic/GDR_RUN/cov.vdb";
      }
} 
ITF::itf_print_info("Coverage location is at: $cov_dir");

###################### simulation user defined options ######################
sub get_mem_resources{ 
my $sequence=ITF::get_option('sequence','ITF');
my $topology = ITF::get_option("topology", "ITF") || '10g';
my $memlimit = "20000"; #20GB 


if(($sequence =~ m/stat/) || ($sequence =~ m/register/) || ($sequence =~ m/hip_reg_access_sequence/) || ($sequence =~ m/max_payload_frame_sequence/)){ 
  $memlimit = "40000"; #30GB
}
print " Memory requested : $memlimit ";
return $memlimit; 
 } 
ITF::register_user_function('rtl_sim_simulate_only_vcs', 'get_mem_resources', \&get_mem_resources);

###################### simulation user defined options ######################
sub rtl_simulate_pre_process {
    ITF::itf_print_info("RTL Simulation Pre Process setup");
    my $test_config = "eth_100g_test";
    my $cov = ITF::get_option('cov', "ITF") || 0;
    my $sequence = ITF::get_option("sequence", "ITF");
    my $seed = ITF::get_subtest_option("variant_name");
    my $seed_def = ITF::get_option("seed","ITF") || "";
    my $plusargs = ITF::get_option("plusargs", "ITF");
    my $verbosity =ITF::get_option("verbosity") || "UVM_NONE";
    my $error_count=ITF::get_option("error_count") || 10;
    my $num_of_frames =ITF::get_option("num_of_frames");
    my $ehip_mode = ITF::get_option("ehip_mode", "ITF");
    my $dr=ITF::get_option("dr","ITF");
    my $testname ;
    my $reconfig_fast=ITF::get_option("reconfig_fast","ITF") || 1;
    my $var=ITF::get_option("VARIANT_NAME","variant");
    my $variant = ITF::get_subtest_option("variant_name"); 
    my $xprop = ITF::get_option("xprop", "ITF");
    my $ptp_en = ITF::get_option("ptp_en", "ITF") || 0;
    my $enable_an=ITF::get_option("enable_an",$var)||0; 
    my $enable_lt=ITF::get_option("enable_lt",$var)||0;
    my $llvar=ITF::get_option("llvar",$var)||0;
    my $devicemode=ITF::get_option("devicemode",$var)||0;
    my $func_cov_only = ITF::get_option("func_cov_only", "ITF");
    if(!defined($xprop)){
      #if($ptp_en==0){$xprop=1;}
      #else {$xprop=0;}
      $xprop=1;
    }
    print "XPROP=$xprop \n";
    my $topology = ITF::get_option("topology", "ITF") || '10g';
      $testname = ITF::get_option("testname", "ITF") || "eth_gdr_base_test";
    my $mode1 = ITF::get_option("mode1","ITF");
    my $mode2 = ITF::get_option("mode2","ITF");
    my $ptp_debug_acc_en = ITF::get_option("ptp_debug_acc_en", 'update_qsys');
    print "\n DBG: ptp_debug_acc_en -- 4 : $ptp_debug_acc_en\n";	 
    my $options ;
    $plusargs = "+".$plusargs;
    $plusargs = join(" +", split(',',$plusargs));
    my $registers = ITF::get_option("registers","ITF") || "All"; #SoftCsr,EhipMacCfg,EhipPcsCfg,EhipMacStat,EhipPcsStat,LphyFec
    my $minimal_test = ITF::get_option("minimal_test","ITF") || 0;
    ITF::itf_print_info("registers_type: $registers");
    ITF::itf_print_info("minimal_test: $minimal_test");
    print " What seed_def  value i got here : $seed_def \n";
    print " what seed value i got here :$seed \n";
    print("simulate: func_cov_only is : $func_cov_only \n");
    print( "ll10g variant: $llvar \n"); 
    
    if($seed_def eq "") {

		my $seed_conversion = ITF::get_option("seed_sweep_name_conversion__rtl_sim_simulate_only_vcs", "ITF");
		print " Trying to get seed number \n";	
		print  " SEED_CONVERSION ::: $seed_conversion \n "  ;
		$seed = $seed_conversion->{$variant};
		print " seed_value is ::: $seed \n "  ;
		print "VAR_OBATINED ::: $variant \n ";
		print ITF::Dumper ($seed_conversion);
	}


    ITF::itf_print_info("Sequence is: $sequence");
    ITF::itf_print_info("testname is: $testname");
    ITF::itf_print_info("mode1 is: $mode1");
    ITF::itf_print_info("mode2 is: $mode2");


	  $test_config = $testname;

		  
		  

if(($enable_an==0) && ($enable_lt==0) && ($ptp_en==0)){
    $cov_dir="$ENV{'MRPHY_COVERAGE_PATH'}/$topology/cov_$topology.vdb";
    #$cov_dir = "$ENV{'MRPHY_COVERAGE_PATH'}/${var}_$ehip_mode/simv.vdb";
    ITF::itf_print_info("coverage directory: $cov_dir");
}
#muralasx:  Updating cov directory path to user specified path
#commenting below line and enabling line 176 
#my $cov_dir = "$ENV{'REG_LOCAL_ROOT_DIR_PATH'}ip/ethernet/alt_ethernet_crete_gdr/qhip/scripts/funct_deterministic/GDR_RUN/COV_DIR/${var}_$ehip_mode/simv.vdb";
$seed =~ s/[s|0]*//g;
    ITF::itf_print_info("Seed is: $seed");

    if( $cov == 1) {
        ITF::itf_print_info("coverage data generation is enabled and it is at: $cov_dir");
        
if (defined($mode1) && defined($mode2)){
        $options = " -l sim.log +vcs+lic+wait +UVM_MAX_QUIT_COUNT=$error_count +UVM_LOG_RECORD  +UVM_TR_RECORD +ntb_random_seed=$seed +UVM_VERBOSITY=$verbosity  -cm_hier ../../cov_config_file.txt -cm_name ${sequence}_${test_config}_${mode1}_${mode2}_${seed} -cm_dir $cov_dir +UVM_TESTNAME=$test_config +m_sequence=$sequence $plusargs +disable_pause=0 +disable_ptp=1 +mode1=$mode1 +mode2=$mode2";
} elsif(defined($mode1)) {
        $options = " -l sim.log +vcs+lic+wait +UVM_MAX_QUIT_COUNT=$error_count +UVM_LOG_RECORD   +UVM_TR_RECORD +ntb_random_seed=$seed +UVM_VERBOSITY=$verbosity  -cm_hier ../../cov_config_file.txt -cm_name ${sequence}_${test_config}_${mode1}_${seed} -cm_dir $cov_dir +UVM_TESTNAME=$test_config +m_sequence=$sequence $plusargs +disable_pause=0 +disable_ptp=1 +mode1=$mode1";
}
else {
my $temp1 ;
my $temp2 ;
($temp1 ,$temp2 ) = split(/seq/, $sequence); 
print("Compliance is : $temp1");
print("Case No. : $temp2");
print("Sequence is : $sequence");
if ($temp1 eq "an_cl73_comp_") {
	 ITF::itf_print_info("cov_enabled_details we got here 3 AN : $test_config \n");
	$options = "-l sim.log +vcs+lic+wait +UVM_MAX_QUIT_COUNT=$error_count +UVM_LOG_RECORD +ETH_TS_TEST_0=ETH_AN_CL73_COMP_TP +ETH_TS_FIRST_CASE_0=$temp2 +ETH_TS_LAST_CASE_0=$temp2  +UVM_TR_RECORD +ntb_random_seed=$seed  -cm_hier ../../cov_config_file.txt -cm_name ${sequence}_${seed} -cm_dir $cov_dir +UVM_TESTNAME=$test_config +UVM_VERBOSITY=$verbosity +m_sequence=$sequence $plusargs +disable_pause=0 +disable_ptp=1";
}
else {
if ($temp1 eq "lt_cl72_comp_") {
	 ITF::itf_print_info("cov_enabled_details we got here 3 LT: $test_config \n");
	$options = "-l sim.log +vcs+lic+wait +UVM_MAX_QUIT_COUNT=$error_count +UVM_LOG_RECORD +ETH_TS_TEST_0=ETH_AD_CL72_COMP_TP +ETH_TS_FIRST_CASE_0=$temp2 +ETH_TS_LAST_CASE_0=$temp2  +UVM_TR_RECORD +ntb_random_seed=$seed -cm_hier ../../cov_config_file.txt -cm_name ${sequence}_${seed} -cm_dir $cov_dir +UVM_TESTNAME=$test_config +UVM_VERBOSITY=$verbosity +m_sequence=$sequence $plusargs +disable_pause=0 +disable_ptp=1";
}
else {
if ($temp1 eq "lt_cl136_comp_") {
	 ITF::itf_print_info("cov_enabled_details we got here 3 LT: $test_config \n");
	$options = "-l sim.log +vcs+lic+wait +UVM_MAX_QUIT_COUNT=$error_count +UVM_LOG_RECORD +ETH_TS_TEST_0=ETH_AD_CL136_COMP_TP +ETH_TS_FIRST_CASE_0=$temp2 +ETH_TS_LAST_CASE_0=$temp2  +UVM_TR_RECORD +ntb_random_seed=$seed -cm_hier ../../cov_config_file.txt -cm_name ${sequence}_${seed} -cm_dir $cov_dir +UVM_TESTNAME=$test_config +UVM_VERBOSITY=$verbosity +m_sequence=$sequence $plusargs +disable_pause=0 +disable_ptp=1";
}
else{
        $options = " -l sim.log +vcs+lic+wait +UVM_MAX_QUIT_COUNT=$error_count +UVM_LOG_RECORD   +UVM_TR_RECORD +ntb_random_seed=$seed +UVM_VERBOSITY=$verbosity  -cm_hier ../../cov_config_file.txt -cm_name ${sequence}_${seed} -cm_dir $cov_dir +UVM_TESTNAME=$test_config +m_sequence=$sequence $plusargs +disable_pause=0 +disable_ptp=1";
}
}
}
}
if($sequence =~ m/cl46/) {
my $temp1 ;
my $temp2 ;
($temp1 ,$temp2 ) = split(/seq/, $sequence); 
print("Compliance is : $temp1");
print("Case No. : $temp2");
print("Sequence is : $sequence");
if ($temp1 eq "eth_testsuite_10g_cl46_comp_") {
	 ITF::itf_print_info("cov_enabled_details we got here : $test_config \n");
	$options = "-l sim.log +vcs+lic+wait +UVM_MAX_QUIT_COUNT=$error_count +UVM_LOG_RECORD +ETH_TS_TEST_0=ETH_XGMII_CL46_COMP_TP +ETH_TS_FIRST_CASE_0=$temp2 +ETH_TS_LAST_CASE_0=$temp2  +UVM_TR_RECORD +ntb_random_seed=$seed -cm_hier ../../cov_config_file.txt -cm_name ${sequence}_${seed} -cm_dir $cov_dir +UVM_TESTNAME=$test_config +UVM_VERBOSITY=$verbosity +m_sequence=$sequence $plusargs +disable_pause=0 +disable_ptp=1";
}
}
if($sequence =~ m/cl36/) {
my $temp1 ;
my $temp2 ;
($temp1 ,$temp2 ) = split(/seq/, $sequence); 
print("Compliance is : $temp1");
print("Case No. : $temp2");
print("Sequence is : $sequence");
if ($temp1 eq "eth_testsuite_tbi_cl36_comp_") {
	 ITF::itf_print_info("cov_enabled_details we got here : $test_config \n");
	$options = "-l sim.log +vcs+lic+wait +UVM_MAX_QUIT_COUNT=$error_count +UVM_LOG_RECORD +ETH_TS_TEST_0=ETH_TBI_CL36_COMP_TP +ETH_TS_FIRST_CASE_0=$temp2 +ETH_TS_LAST_CASE_0=$temp2  +UVM_TR_RECORD +ntb_random_seed=$seed -cm_hier ../../cov_config_file.txt -cm_name ${sequence}_${seed} -cm_dir $cov_dir +UVM_TESTNAME=$test_config +UVM_VERBOSITY=$verbosity +m_sequence=$sequence $plusargs +disable_pause=0 +disable_ptp=1";
}
}


	if(defined($num_of_frames)) { 
          $options = "$options +num_of_frames=$num_of_frames";
	}
        if(defined($registers)) {
	       $options = "$options +registers=$registers";
        }
        if(defined($minimal_test)) {
	       $options = "$options +minimal_test=$minimal_test";
        }
	
        if($xprop==1) {
          $options = "$options -report=xprop";
        }
        if($sequence eq "eth_register_timeout_seq") {
          $options = (!defined($reconfig_fast) || ($reconfig_fast==1))? "$options +cmd_timeout=3200 +waitrequest_timeout=3200":"$options +cmd_timeout=320 +waitrequest_timeout=320";
              print "waitrequest timeout increased";
	}
   
      if($func_cov_only eq undef){
         print "simulate: running full code coverage";
         $options = $options.' -cm line+assert+cond+branch+fsm+tgl ';
      } else {
         print "simulate: running functional coverage only";
         $options = $options.' -cm assert ';
      } 

      if($sequence eq "ptp_tod_valid_down_sequence") {
         print "simulate: Running TOD VALID DOWN sequence";
         $options = "$options +TOD_VALID_DOWN";
      }
      
      if($sequence eq "ptp_tx_err_mix_sequence" or $sequence eq "ptp_err_mix_offset_sequence" or $sequence eq "ptp_err_mix_invalid_sequence") {
         print "simulate: Disable PTP RX Ingress VS Tx Egress check";
         $options = "$options +DIS_RX_VS_TX_ING_TS_CHK";
      }
      
      if($sequence eq "ptp_register_access_sequence_1" or $sequence eq "ptp_register_access_sequence_2" or $sequence eq "ptp_register_access_sequence_3" or $sequence eq "ptp_register_access_sequence_4") {
         print "simulate: Enable Fast clk for register testing \n";
         $options = "$options +PTP_REG_TEST";
      }      
      
      #TODO: To be removed once HSD https://hsdes.intel.com/resource/16012059992 is resolved
   
      ITF::set_option('USER_DEFINED_SIM_OPTIONS', 'simulation.vcs', $options);
   }
    else {
        ITF::itf_print_info("coverage data base generation is disable");
        

	if (defined($mode1) && defined($mode2)){
	 ITF::itf_print_info("details we got here 1  : $test_config , $mode1 , $mode2 \n");
	$options = "-l sim.log +vcs+lic+wait +UVM_MAX_QUIT_COUNT=$error_count +UVM_LOG_RECORD   +UVM_TR_RECORD +ntb_random_seed=$seed +UVM_TESTNAME=$test_config +UVM_VERBOSITY=$verbosity +m_sequence=$sequence $plusargs +disable_pause=0 +disable_ptp=1 +num_of_frames=$num_of_frames +mode1=$mode1 +mode2=$mode2";
} elsif(defined($mode1)) {
	 ITF::itf_print_info("details we got here 2 : $test_config , $mode1 \n");
	$options = "-l sim.log +vcs+lic+wait +UVM_MAX_QUIT_COUNT=$error_count +UVM_LOG_RECORD   +UVM_TR_RECORD +ntb_random_seed=$seed +UVM_TESTNAME=$test_config +UVM_VERBOSITY=$verbosity +m_sequence=$sequence $plusargs +disable_pause=0 +disable_ptp=1 +num_of_frames=$num_of_frames +mode1=$mode1";
        ITF::itf_print_info("details we got here 22 : $test_config , $mode1 \n");
}else {
my $temp1 ;
my $temp2 ;
($temp1 ,$temp2 ) = split(/seq/, $sequence); 
print("Compliance is : $temp1");
print("Case No. : $temp2");
print("Sequence is : $sequence");
if ($temp1 eq "an_cl73_comp_") {
	 ITF::itf_print_info("details we got here 3 AN : $test_config \n");
	$options = "-l sim.log +vcs+lic+wait +UVM_MAX_QUIT_COUNT=$error_count +UVM_LOG_RECORD +ETH_TS_TEST_0=ETH_AN_CL73_COMP_TP +ETH_TS_FIRST_CASE_0=$temp2 +ETH_TS_LAST_CASE_0=$temp2  +UVM_TR_RECORD +ntb_random_seed=$seed +UVM_TESTNAME=$test_config +UVM_VERBOSITY=$verbosity +m_sequence=$sequence $plusargs +disable_pause=0 +disable_ptp=1";
}
else {
if ($temp1 eq "lt_cl72_comp_") {
	 ITF::itf_print_info("details we got here 3 LT: $test_config \n");
	$options = "-l sim.log +vcs+lic+wait +UVM_MAX_QUIT_COUNT=$error_count +UVM_LOG_RECORD +ETH_TS_TEST_0=ETH_AD_CL72_COMP_TP +ETH_TS_FIRST_CASE_0=$temp2 +ETH_TS_LAST_CASE_0=$temp2  +UVM_TR_RECORD +ntb_random_seed=$seed +UVM_TESTNAME=$test_config +UVM_VERBOSITY=$verbosity +m_sequence=$sequence $plusargs +disable_pause=0 +disable_ptp=1";
}
else {
if ($temp1 eq "lt_cl136_comp_") {
	 ITF::itf_print_info("details we got here 3 LT: $test_config \n");
	$options = "-l sim.log +vcs+lic+wait +UVM_MAX_QUIT_COUNT=$error_count +UVM_LOG_RECORD +ETH_TS_TEST_0=ETH_AD_CL136_COMP_TP +ETH_TS_FIRST_CASE_0=$temp2 +ETH_TS_LAST_CASE_0=$temp2  +UVM_TR_RECORD +ntb_random_seed=$seed +UVM_TESTNAME=$test_config +UVM_VERBOSITY=$verbosity +m_sequence=$sequence $plusargs +disable_pause=0 +disable_ptp=1";
}
else{
	 ITF::itf_print_info("details we got here 3 : $test_config \n");
	$options = "-l sim.log +vcs+lic+wait +UVM_MAX_QUIT_COUNT=$error_count +UVM_LOG_RECORD   +UVM_TR_RECORD +ntb_random_seed=$seed +UVM_TESTNAME=$test_config +UVM_VERBOSITY=$verbosity +m_sequence=$sequence $plusargs +disable_pause=0 +disable_ptp=1";
}
}
} 
}             
if($sequence =~ m/cl46/) {
my $temp1 ;
my $temp2 ;
($temp1 ,$temp2 ) = split(/seq/, $sequence); 
print("Compliance is : $temp1");
print("Case No. : $temp2");
print("Sequence is : $sequence");
if ($temp1 eq "eth_testsuite_10g_cl46_comp_") {
	 ITF::itf_print_info("cov_enabled_details we got here : $test_config \n");
	$options = "-l sim.log +vcs+lic+wait +UVM_MAX_QUIT_COUNT=$error_count +UVM_LOG_RECORD +ETH_TS_TEST_0=ETH_XGMII_CL46_COMP_TP +ETH_TS_FIRST_CASE_0=$temp2 +ETH_TS_LAST_CASE_0=$temp2  +UVM_TR_RECORD +ntb_random_seed=$seed +UVM_TESTNAME=$test_config +UVM_VERBOSITY=$verbosity +m_sequence=$sequence $plusargs +disable_pause=0 +disable_ptp=1";
}
}
if($sequence =~ m/cl36/) {
my $temp1 ;
my $temp2 ;
($temp1 ,$temp2 ) = split(/seq/, $sequence); 
print("Compliance is : $temp1");
print("Case No. : $temp2");
print("Sequence is : $sequence");
if ($temp1 eq "eth_testsuite_tbi_cl36_comp_") {
	 ITF::itf_print_info("cov_enabled_details we got here : $test_config \n");
	$options = "-l sim.log +vcs+lic+wait +UVM_MAX_QUIT_COUNT=$error_count +UVM_LOG_RECORD +ETH_TS_TEST_0=ETH_TBI_CL36_COMP_TP +ETH_TS_FIRST_CASE_0=$temp2 +ETH_TS_LAST_CASE_0=$temp2  +UVM_TR_RECORD +ntb_random_seed=$seed +UVM_TESTNAME=$test_config +UVM_VERBOSITY=$verbosity +m_sequence=$sequence $plusargs +disable_pause=0 +disable_ptp=1";
}
}

         if(defined($num_of_frames)) { 
            $options = "$options +num_of_frames=$num_of_frames";
         }
         if(defined($registers)) {
            $options = "$options +registers=$registers";
         }
         if(defined($minimal_test)) {
            $options = "$options +minimal_test=$minimal_test";
         }
         if($xprop==1) {
            $options = "$options -report=xprop";
         }
         if($sequence eq "eth_register_timeout_seq") {
            $options = (!defined($reconfig_fast) || ($reconfig_fast==1))? "$options +cmd_timeout=3200 +waitrequest_timeout=3200":"$options +cmd_timeout=320 +waitrequest_timeout=320";
            print "waitrequest timeout increased";
         }
         
         if($sequence eq "ptp_tod_valid_down_sequence") {
            print "simulate: Running TOD VALID DOWN sequence";
            $options = "$options +TOD_VALID_DOWN";
         }
         
         if($sequence eq "ptp_tx_err_mix_sequence" or $sequence eq "ptp_err_mix_offset_sequence" or $sequence eq "ptp_err_mix_invalid_sequence") {
            print "simulate: Disable PTP RX Ingress VS Tx Egress check";
            $options = "$options +DIS_RX_VS_TX_ING_TS_CHK";
         }
         
      if($sequence eq "ptp_register_access_sequence_1" or $sequence eq "ptp_register_access_sequence_2" or $sequence eq "ptp_register_access_sequence_3" or $sequence eq "ptp_register_access_sequence_4") {
         print "simulate: Enable Fast clk for register testing \n";
         $options = "$options +PTP_REG_TEST";
      }         
         
         
         ITF::set_option('USER_DEFINED_SIM_OPTIONS', 'simulation.vcs', $options);
   }
}
ITF::register_function('rtl_sim_simulate_only_vcs', 'run_pre_process', \&rtl_simulate_pre_process);


###################### compilation user defined options ######################
sub get_mem_compile_resources{ 
my $compilelimit = "20000"; #20GB
print " compile Memory requested : $compilelimit ";
return $compilelimit; 
 } 

ITF::register_user_function('rtl_sim_compile_only_vcs', 'get_mem_resources', \&get_mem_compile_resources);

###################### compilation user defined options ######################
sub rtl_compile_pre_process {
		#my $cr_mode=ITF::get_option("cr_mode",'update_qsys');
	  #my $an_chan0=ITF::get_option("an_chan0",'update_qsys');
	  #print "REG_LOCAL_ROOT_DIR_PATH is set to : $ENV{REG_LOCAL_ROOT_DIR_PATH} \n";
    #$current_path=cwd;
    #print " I AM at Current path is $current_path";
		#Nipoon changed this to itf run as suggested by Davdid   
    #ITF::itf_run_system_command("python gdr.py $current_path $cr_mode $an_chan0 $ENV{REG_LOCAL_ROOT_DIR_PATH}");
    ITF::itf_print_info("RTL Compile Pre Process setup");
    my $dump_from0time = ITF::get_option("dump_from0time", "ITF") || 0;
    my $cov = ITF::get_option("cov", "ITF") || 0;
    my $vip_en = ITF::get_option("vip_en", "ITF") ;
    my $fsdb_en = ITF::get_option("fsdb_en", "ITF") || 0;
    my $dump_mac_pcs_only = ITF::get_option("dump_mac_pcs_only", "ITF") || 0;
    my $skip_rtl = ITF::get_option("skip_rtl", "ITF") || 0;   ###PRASH by default it is set to 0                            
    my $rst_dump_off = ITF::get_option("rst_dump_off", "ITF") || 0;
    my $ehip_mode = ITF::get_option("ehip_mode", "ITF");
    my $var=ITF::get_option("VARIANT_NAME","variant");    
    my $dr=ITF::get_option("dr","ITF");
    my $reconfig_fast=ITF::get_option("reconfig_fast","ITF") || 1;
    my $sequence=ITF::get_option("sequence"."ITF");    
    my $xprop = ITF::get_option("xprop", "ITF");
    my $topology = ITF::get_option("topology", "ITF") || '10g';
    my $ptp_en = ITF::get_option("ptp_en", "ITF") || 0;
    my $acc = ITF::get_option("acc", "ITF") || "0";
    my $meta = ITF::get_option("meta", "ITF");
    my $enable_an=ITF::get_option("enable_an",$var)||0; 
    my $enable_lt=ITF::get_option("enable_lt",$var)||0;
    my $num_phylane  =			ITF::get_option("num_phylane",$var);
    my $transtype  =   			ITF::get_option("transceiver_type",$var);
    my $func_cov_only = ITF::get_option("func_cov_only", "ITF");
    my $llvar=ITF::get_option("llvar",$var)||0;
    my $devicemode=ITF::get_option("devicemode",$var)||0;

	 #$filename1 = 'gdr_'.$topology.'.csv';
     #my $filename = 'gdr.csv';
     #open(my $fh, '<:encoding(UTF-8)', $filename) or die "Could not open file '$filename' $!";
     #open(my $fh2, '>', 'param_rtl.csv');
     #open(my $fh1, '>', 'param_tb.csv');




	my $cr_mode=0;
	my $an_chan0=0;
	my $anlt_val=0;
    my $single_var_multi_inst=0;
    my $ptp_debug_acc_en = 0;
    $current_path=cwd;
    print "Current path is $current_path";
    print "REG_LOCAL_ROOT_DIR_PATH is set to : $ENV{REG_LOCAL_ROOT_DIR_PATH} \n";
    print "ll10g variant : $llvar";
    ITF::itf_run_system_command("python gdr.py $current_path $cr_mode $an_chan0 $ENV{REG_LOCAL_ROOT_DIR_PATH} $single_var_multi_inst $ptp_debug_acc_en");

    if ($topology =~ m/sm/){
    if ($topology =~ m/^sm.*d1g$/){
     ITF::itf_run_system_command("cp $current_path/dut_top_avst_template_mgbaset_sm_1G.v $current_path/gdr_gen_qhip_files/dut_top.v");
   }
   elsif($topology =~ m/^sm.*d2p5g$/){
     ITF::itf_run_system_command("cp $current_path/dut_top_avst_template_mgbaset_sm.v $current_path/gdr_gen_qhip_files/dut_top.v");
   }
   } 
    else {
    if( $llvar eq 'MGE') {
    ITF::itf_run_system_command("cp $current_path/dut_top_avst_template_mgeS10.v $current_path/gdr_gen_qhip_files/dut_top.v");
    }
    elsif ( $llvar eq 'BASERS10') {
    ITF::itf_run_system_command("cp $current_path/dut_top_avst_template_baserS10.v $current_path/gdr_gen_qhip_files/dut_top.v");
    }
    elsif ( $llvar eq 'BASERA10') {
    ITF::itf_run_system_command("cp $current_path/dut_top_avst_template_baserS10_ARRIA.v $current_path/gdr_gen_qhip_files/dut_top.v");
    }
    elsif ( $llvar eq 'MGBASET') {
    ITF::itf_run_system_command("cp $current_path/dut_top_avst_template_mgbaset.v $current_path/gdr_gen_qhip_files/dut_top.v");
    }
    elsif ( $llvar eq 'MGBASETA10') {
    ITF::itf_run_system_command("cp $current_path/dut_top_avst_template_mgbaset_a10.v $current_path/gdr_gen_qhip_files/dut_top.v");
    }
    elsif ( $llvar eq 'MGE_A10') {
    ITF::itf_run_system_command("cp $current_path/dut_top_avst_template_MGE_A10.v $current_path/gdr_gen_qhip_files/dut_top.v");
    } 
    elsif ( $llvar eq 'MGE_V') {
    ITF::itf_run_system_command("cp $current_path/dut_top_avst_template_MGE_V.v $current_path/gdr_gen_qhip_files/dut_top.v");
    }
    elsif ( $llvar eq 'NF10G') {
    ITF::itf_run_system_command("cp $current_path/dut_top_avst_template_NF_10G.v $current_path/gdr_gen_qhip_files/dut_top.v");
    }
    elsif ( $llvar eq 'NF1G') {
    ITF::itf_run_system_command("cp $current_path/dut_top_avst_template_NF_10G.v $current_path/gdr_gen_qhip_files/dut_top.v");
    }
    else {
    ITF::itf_run_system_command("cp $current_path/dut_top_avst_template.v $current_path/gdr_gen_qhip_files/dut_top.v");
    }
}
    ITF::pass_files_to_children("*.v","*.sv","*.txt");
      ITF::pass_files_to_children(".*hex");     

    if(!defined($xprop)){
      #if($ptp_en==0){$xprop=1;}
      #else {$xprop=0;}
      $xprop=1;
    }
    print "XPROP=$xprop \n";
    my $multi_inst = ITF::get_option("multi_inst", "ITF") || 0;
    my $pli_tab = ITF::get_option("pli_tab", "ITF") || 0;
    if($vip_en eq "no")
    {
	  $vip_en=0;
    }
    else
    {
	$vip_en=1;
    }

    my $json_en = ITF::get_option("json_en", "ITF");
    #if(!defined($json_en)){
    # if($enable_an==1 ||$enable_lt==1){
    #  $json_en = 1;
    #  }
    # else{
    # $json_en= 0; }
    #}
print("Number of lanes : $num_phylane\n");
print("VIP : $vip_en");
print " dr value in ompile stage: $dr\n";
print("compile: func_cov_only is : $func_cov_only \n");
print("ehip mode is : $ehip_mode \n");
print("cov mode is : $cov \n");
print("json_en is  : $json_en \n");


# ITF::itf_run_system_command("cp -r gdr_gen_qhip_files ../../../../../../../testbench/tb/"); 
# ITF::itf_run_system_command("cp dut_top.v ../../../../../../../testbench/tb/gdr_gen_qhip_files/");
#ITF::itf_run_system_command("cp top.v ../../../../../../../testbench/tb/gdr_gen_qhip_files/");
print "REG_LOCAL_ROOT_DIR_PATH is set to : $ENV{REG_LOCAL_ROOT_DIR_PATH} \n";
print "Here I am in COMPILE\n";
print `pwd`;
# ITF::itf_run_system_command('cp -vrf gdr_gen_qhip_files '.$ENV{REG_LOCAL_ROOT_DIR_PATH});  


    my $preamble = ITF::get_option("pp_val", $var) ;
    my $rdy_lat = ITF::get_option("rl_val", $var) ;
    my $phy_refclk = ITF::get_option("phy_refclk", $var);
    my $rsfec_val = ITF::get_option("rsfec_val", $var) ;
    my $pam4_val = ITF::get_option("pam4_val", $var) ;
    my $profiler=ITF::get_option("profiler",$var)||0; 
    my $enable_stats_count = ITF::get_option("stats_val", $var) ;
    my $ptp = ITF::get_option("ptp_val", $var) ;
    my $flow_control = ITF::get_option("fc_val", $var) ;
    my $short_am = ITF::get_option("short_am", "ITF")||1;
    print "\n VARIANT $var \n"; 
    my $intf_mode = ITF::get_option("interface", $var) ;
    print "intf_mode $intf_mode \n"; 

    print("SHORT=$short_am");

my $tb_files; 
my $tb_files_mac_plus_pcs; 
   # $tb_files_mac_plus_pcs = ($vip_en)?  ($short_am) ? "-f ../../vip_files_new1.f -f ../../tb_files.f +define+ENABLE_ETH_VIP +define+EN_UX_XCVR_RAL +define+SVT_ETHERNET_CLKGEN" : "-f ../../vip_files_new1.f -f ../../tb_files.f +define+ENABLE_ETH_VIP +define+EN_UX_XCVR_RAL +define+SVT_ETHERNET_CLKGEN +define+STD_AM" : "-f ../../tb_files.f " ; 

   if($fsdb_en == 1) {
      if($llvar eq 'USXGMII') {	   
         print "\n Compiler defines for USXGMII variant\n";
         $tb_files_mac_plus_pcs =($vip_en)? "  +fsdb+mda -f ../../vip_files_new.f -f ../../tb_files.f -f ../../wrapper_files.f  +define+ENABLE_ETH_VIP " : "-f ../../tb_files.f -f ../../wrapper_files.f "; 
      } else {
         print "\n Compiler defines for Non-USXGMII variant\n";
         $tb_files_mac_plus_pcs = ($vip_en)? " +fsdb+mda -f ../../vip_files.f -f ../../tb_files.f +define+ENABLE_ETH_VIP " : "-f ../../tb_files.f "; 
	 }
      

   } else {

      if($llvar eq 'USXGMII') {	   
         print "\n Compiler defines for USXGMII variant\n";
         $tb_files_mac_plus_pcs = ($vip_en)? " -f ../../vip_files_new.f -f ../../tb_files.f  -f ../../wrapper_files.f +define+ENABLE_ETH_VIP ": "-f ../../tb_files.f  -f ../../wrapper_files.f ";
      } else {
         print "\n Compiler defines for non-USXGMII variant\n";
         $tb_files_mac_plus_pcs = ($vip_en)?  " -f ../../vip_files.f -f ../../tb_files.f  +define+ENABLE_ETH_VIP " :  "-f ../../tb_files.f ";
      }

   }
  if($topology =~ m/sm/) {
        $tb_files_mac_plus_pcs = $tb_files_mac_plus_pcs."+define+IP7521SERDES_UXS2T1R1PGD_PIPE_SPEC_FORCE +define+IP7521SERDES_UXS2T1R1PGD_PIPE_SIMULATION +define+SIMULATION +define+IP7521SERDES_UXS2T1R1PGD_PIPE_FAST_SIM +define+IP7521SERDES_UXS2T1R1PGD_PIPE_APMA_FAST_SIM +define+IP7581SERDES_UXS2T1R1PGD_PIPE_SPEC_FORCE +define+IP7581SERDES_UXS2T1R1PGD_PIPE_SIMULATION +define+IP7581SERDES_UXS2T1R1PGD_PIPE_FAST_SIM +define+IP7581SERDES_UX_SIMSPEED +define+INTEL_NO_PWR_PINS +define+NO_PWR_PINS +define+INTCNOPWR +define+INTC_FUNCTIONAL +define+INTEL_SIMONLY +define+INTC_SVA_OFF +define+QUARTUS +define+PFEDV_ONLY_MODEL_MACRO_DIS +define+PMADIR_4A ";
   }

  $tb_files_mac_plus_pcs = $tb_files_mac_plus_pcs.'+vcs+lic+wait -notice +warn=noTFIPC -debug -full64 +v2k -sverilog -lca -kdb +lint=TFIPC-L +lint=PCWM -timescale=1ns/1ps';   
  
  if($llvar eq 'USXGMII') {  
    $tb_files_mac_plus_pcs = $tb_files_mac_plus_pcs.' +define+ETH_MULTI_PORT +define+NUM_OF_PORTS=8 ';
## compliance testing
#defines added from DVT testsuite multi port UG : https://spdocs.synopsys.com/dow_retrieve/qsc-t/vg/snps_vip_lib/T-2022.03/olh/Ethernet/index.html#page/Ethernet%2520Test%2520Suite%2520UVM%2520User%2520Guide%2F06_Configuration.6.3.htm%23ww1128082
    if($vip_en) { 
      if($sequence =~ m/cl46/ or $sequence =~ m/cl36/) {
         $tb_files_mac_plus_pcs = $tb_files_mac_plus_pcs.' +define+SVT_ETH_QSGMII_USGMII_NEW_ARCH +define+SVT_ETHERNET_TEST_SUITE_SINGLE_PORT +define+UVM_NO_DEPRECATED +define+PHY_TYPE=1 +define+NUM_OF_PHYS=1 +define+SVT_ETHERNET_TX_TRANSACTION +define+SVT_ETHERNET_USXGMII_TESTSUITE +define+SVT_ETHERNET_TEST_SUITE_SINGLE_PORT '; 
      } 
    }
  } elsif($llvar eq 'MGE') {  
      print "MGE Define is being set from gdr.py file\n";
  } elsif($llvar eq 'BASERS10') {
      $tb_files_mac_plus_pcs = $tb_files_mac_plus_pcs.' +define+ETH_BASERS10';
  } elsif($llvar eq 'BASERA10') {
      $tb_files_mac_plus_pcs = $tb_files_mac_plus_pcs.' +define+ETH_BASERS10_ARRIA';
  } elsif($llvar eq 'MGBASET')  {
	 if($topology =~ m/sm/){
	    $tb_files_mac_plus_pcs = $tb_files_mac_plus_pcs.' +define+ETH_SM_MGBASET +define+ETH_MGBASET +define+SKIP_SIMPLE_MODEL +define+PLL_CAL_BYPASS';
	  }
	else {  
	    $tb_files_mac_plus_pcs = $tb_files_mac_plus_pcs.' +define+ETH_MGBASET';
	  }    
  } elsif($llvar eq 'MGE_A10') {
    $tb_files_mac_plus_pcs = $tb_files_mac_plus_pcs.' +define+ETH_MGE +define+ETH_MGE_A10';
  }
   elsif($llvar eq 'MGE_V') {
    $tb_files_mac_plus_pcs = $tb_files_mac_plus_pcs.' +define+ETH_MGE +define+ETH_MGE_V';
  }
   elsif($llvar eq 'NF10G') {
    $tb_files_mac_plus_pcs = $tb_files_mac_plus_pcs.' +define+ETH_NF_10G ';
  }
   elsif($llvar eq 'MGBASETA10') {
    $tb_files_mac_plus_pcs = $tb_files_mac_plus_pcs.' +define+ETH_MGBASET +define+ETH_MGBASET_A10 ';
  }   
  elsif($llvar eq 'NF1G') {
    $tb_files_mac_plus_pcs = $tb_files_mac_plus_pcs.'  +define+ETH_NF_10G +define+ETH_NF_1G ';
  }

  $tb_files = $tb_files_mac_plus_pcs;


  ITF::set_option('custom_gen_spd_sim_script_fn', 'simulation.vcs', \&modify_spd);
  if($sequence =~ m/cl46/ or $sequence =~ m/cl36/) {
     $tb_files = $tb_files.' +define+COMPL_TC ';
  ## Defines added for compliance testing
     $tb_files = $tb_files.'+define+SVT_ETHERNET100G_TESTSUITE ';
  }

  if($enable_stats_count == 1) {
     $tb_files = $tb_files.' +define+ENABLE_STATS ';
   }
    
    if ($intf_mode==1){	
        $tb_files = $tb_files.' +define+AVST_MODE ';
    }
    elsif ($intf_mode==0){
        $tb_files = $tb_files.' +define+MACSEG_MODE ';
    }
    else{
     print STDERR "INCORRECT INTERFACE select passed from variant .Will not run SIMULATION RUN \n";
     exit;
    }

	 #TODO: Only for eth10/11?
    if ($topology eq "10" or $topology eq "11" or $topology eq "other_9"){
        $tb_files = $tb_files.' +define+ACCURATE_ANA ';
    }

    #For PTP enable accuracy
    if($acc == 1){
       print "Define Accuracy\n";
       $tb_files = $tb_files.' +define+QHIP_ACC_TESTING ';
    }
    
    #Enable/Disable metastability, default is enable
   if($meta == 1 || $meta eq undef){
      print "Define Metastability\n";
      $tb_files = $tb_files.' +define+__ALTERA_STD__METASTABLE_SIM ';
   }

   #SVA for WB assertion - currently only enable for PTP
   if($ptp_en==1){

      print "Enable PTP WB SVA \n";
      $tb_files = $tb_files.' -f ../../tb_files_ptp_sva.f ';
     
      print "Enable Internal LOG2MRK \n";
      $tb_files = $tb_files.' +define+SKIP_SIM_MODEL_LOG2_MRK ';

   }

   if($enable_an==1 ||$enable_lt==1) {
     if($transtype == 0) { 
        #$tb_files = $tb_files.' +define+SKIP_SIM_MODEL_LOG2_MRK  +define+SKIP_SET_BASE_FREQ  ';
        $tb_files = $tb_files.' +define+SKIP_SET_BASE_FREQ  +define+INTC_SIM_AN_LT_ENABLE';
      } else {
        #$tb_files = $tb_files.' +define+SKIP_SIM_MODEL_LOG2_MRK  +define+RTL  ';
        $tb_files = $tb_files.' +define+RTL  ';
     }  
   }
   
    if ($profiler==1) {
	$tb_files = $tb_files.' -simprofile ';
    }

    #muralasx: Defining macro with rl value to update AVST's ST_READY_LATENCY parameter 
    print "\n \n \n Ready latency: $rdy_lat \n \n \n"; 
        $tb_files = $tb_files.' +define+RDY_LAT='.$rdy_lat;

    my $variant_name = ITF::get_option("eth_variant_name", 'ITF');
    my $gui_debug=ITF::get_option("gui_debug")||0;
    my $acds_version = "ACDS_$ENV{'ACDS_VERSION'}";
    my $acds_build = $ENV{'ACDS_BUILD_NUMBER'};
    my $new_acds_version = "ACDS_$ENV{'ACDS_VERSION'}";
    $new_acds_version =~ s/\./_/g;
    my $cov_dir_set =0;
    if(($enable_an==0) && ($enable_lt==0) && ($ptp_en==0)){
    if($ehip_mode eq 'PARAMETER_SWEEP') {
     print "ehip mode1\n ";
    $cov_dir = "$ENV{'MRPHY_COVERAGE_PATH'}/${var}_PS/simv.vdb";
    } else {
    $cov_dir="$ENV{'MRPHY_COVERAGE_PATH'}/$topology/cov_$topology.vdb";
    #$cov_dir= "$ENV{'MRPHY_COVERAGE_PATH'}/${var}_$ehip_mode/simv.vdb";
        ITF::itf_print_info("coverage directory: $cov_dir");
    }
    }
    #my $cov_dir ="$ENV{'MRPHY_COVERAGE_PATH'}/${var}_$ehip_mode/simv.vdb"; 
    #muralasx: Upda ting cov_dir as per user specific directory path
    #chethan1 commenting below line and enabling line 4O3 line 
    #my $cov_dir = "$ENV{'REG_LOCAL_ROOT_DIR_PATH'}ip/ethernet/alt_ethernet_crete_gdr/qhip/scripts/funct_deterministic/GDR_RUN/COV_DIR/${var}_$ehip_mode/simv.vdb";
    $sequence =  ITF::get_option("sequence", "ITF") || undef;
    my $compile_coverage_option=undef;
    print "\n \n \n COVERAGE DIR: COMP: $cov_dir \n \n \n"; 
    ITF::set_option("cov_dir", "ITF", $cov_dir);
    if(defined($cov) && ($cov == 1)) {
       $compile_coverage_option = "-cm_hier ../../cov_config_file.txt -cm_dir $cov_dir -cm_libs yv+celldefine -cm_noconst -cm_seqnoconst ";
		 
		if($func_cov_only eq undef){
			print "compile: running full code coverage";
			$compile_coverage_option = $compile_coverage_option.' -cm line+assert+cond+branch+fsm+tgl ';
		} else {
			print "compile: running functional coverage only";
			$compile_coverage_option = $compile_coverage_option.' -cm assert ';
		}		 
		 
     }

    my $USER_DEFINED_OPTIONS=undef;
    print "\n \n \n COMPILE COVERAGE OPTION: $compile_coverage_option \n \n \n";
    if($pli_tab == 1) {
      if($topology eq "9" or $topology eq "18" ) {
       $USER_DEFINED_OPTIONS = $USER_DEFINED_OPTIONS. '-ntb_opts uvm -l compile.log -P $REG_LOCAL_ROOT_DIR_PATH/ip/ethernet/alt_ethernet_crete_gdr/qhip/scripts/funct_deterministic/common/pli_learn.tab -debug_access+r +define+UNHIDE_cr3v0 ';
       }
        elsif($topology eq "5" or $topology eq "200_1" ) {
       $USER_DEFINED_OPTIONS = $USER_DEFINED_OPTIONS. '-ntb_opts uvm -l compile.log -P $REG_LOCAL_ROOT_DIR_PATH/ip/ethernet/alt_ethernet_crete_gdr/qhip/scripts/funct_deterministic/common/pli_learn.tab_1 -debug_access+r +define+UNHIDE_cr3v0 ';
       }
    }
    else {
    if ($gui_debug==0) {
       $USER_DEFINED_OPTIONS = $USER_DEFINED_OPTIONS. '-ntb_opts uvm -l compile.log -debug_pp -debug_access+all +define+UNHIDE_cr3v0 -override_timescale=1ps/1fs';
   } else {
       $USER_DEFINED_OPTIONS = $USER_DEFINED_OPTIONS. '-ntb_opts uvm -l compile.log -debug_all -debug_access+all +define+UNHIDE_cr3v0 -gui ';
   }
      }
    $USER_DEFINED_OPTIONS = $USER_DEFINED_OPTIONS. " $tb_files ";

  print("\n USER_DEFINED_OPTIONS = $USER_DEFINED_OPTIONS");

  # Refer HSD : 16011780370 ( added switches to reduce simulation dir space)
  $USER_DEFINED_OPTIONS = $USER_DEFINED_OPTIONS. ' +define+EHIP  -diskopt -noIncrComp ';
 
  if($dump_from0time==1) {
     $USER_DEFINED_OPTIONS = $USER_DEFINED_OPTIONS. ' +memcbk +vcdplusmemon ';
  }

     $USER_DEFINED_OPTIONS = $USER_DEFINED_OPTIONS. ' +define+G10 +define+G10_25 +define+VIP_ETHERNET_40G100G_OPT_SVT +define+NUM_CHANNELS=1 +define+DR ';

 if($reconfig_fast==1) {
      $USER_DEFINED_OPTIONS = $USER_DEFINED_OPTIONS. ' +define+FAST_CLK ';
      print("\n FAST_CLK ENABLED USER_DEFINED_OPTIONS = $USER_DEFINED_OPTIONS");
    } else {
      print("\n FAST_CLK Disabled USER_DEFINED_OPTIONS = $USER_DEFINED_OPTIONS");
}
 if($ehip_mode eq 'PARAMETER_SWEEP') {
 $USER_DEFINED_OPTIONS = $USER_DEFINED_OPTIONS. ' +define+PARAMETER_SWEEP ';
 }
 if($preamble==1){
 $USER_DEFINED_OPTIONS = $USER_DEFINED_OPTIONS. ' +define+PREAMBLE ';
 }
 if($ptp_en==1){
	$USER_DEFINED_OPTIONS = $USER_DEFINED_OPTIONS. ' +define+PTP_EN'; 
 }
 if($json_en==1) {
	$USER_DEFINED_OPTIONS = $USER_DEFINED_OPTIONS. ' +define+JSON_EN'; 
 }
 if(($ptp_en!=1) && ($enable_an!=1 && $enable_lt!=1 )){
 $USER_DEFINED_OPTIONS = $USER_DEFINED_OPTIONS. ' +define+NON_ANLT_PTP';
 #print "Enable Internal LOG2MRK \n";
 #$USER_DEFINED_OPTIONS = $USER_DEFINED_OPTIONS. ' +define+SKIP_SIM_MODEL_LOG2_MRK';
 }
 if($devicemode eq 'SM'){
	$USER_DEFINED_OPTIONS = $USER_DEFINED_OPTIONS. ' +define+DEVICE_SM'; 
 }
 print("\n USER_DEFINED_OPTIONS = $USER_DEFINED_OPTIONS");
  $USER_DEFINED_OPTIONS = $USER_DEFINED_OPTIONS. ' +define+CRETE3 ';
   
       $USER_DEFINED_OPTIONS = $USER_DEFINED_OPTIONS . "${compile_coverage_option}";
   

  if($dump_from0time==1) {
     if($fsdb_en==1) {
        $USER_DEFINED_OPTIONS = $USER_DEFINED_OPTIONS. ' +define+FSDB_ON';
        if($dump_mac_pcs_only==1) {
           $USER_DEFINED_OPTIONS = $USER_DEFINED_OPTIONS. ' +define+DUMP_MAC_PCS_ONLY'; 
        }
        if($rst_dump_off==1) {
           $USER_DEFINED_OPTIONS = $USER_DEFINED_OPTIONS. ' +define+RESET_DUMP_OFF'; 
        }
     }
  else {
      $USER_DEFINED_OPTIONS = $USER_DEFINED_OPTIONS. ' +define+DUMP_ON';
       }
  }

  #Obselete, no TB component is using `RSFEC or `PAM4 define
  #TODO: PTP will remove `RSFEC define in some of the ptp sequences
  #if($rsfec_val == 1){
  #    $USER_DEFINED_OPTIONS = $USER_DEFINED_OPTIONS. ' +define+RSFEC';
  #    if($pam4_val == 1) {
  #    $USER_DEFINED_OPTIONS = $USER_DEFINED_OPTIONS. ' +define+PAM4';
  #    }
  #}

    if( $cov == 1) {
       $USER_DEFINED_OPTIONS = $USER_DEFINED_OPTIONS. ' +define+COV ';
     }
  if(($enable_an==1) || ($enable_lt==1)){
       $USER_DEFINED_OPTIONS = $USER_DEFINED_OPTIONS. ' +define+ANLT ';
     if($num_phylane == 1) {
         $USER_DEFINED_OPTIONS = $USER_DEFINED_OPTIONS. ' +define+LANES_1 ';
     }
      if($num_phylane == 2) {
         $USER_DEFINED_OPTIONS = $USER_DEFINED_OPTIONS. ' +define+LANES_2 ';
     }
      if($num_phylane == 4) {
         $USER_DEFINED_OPTIONS = $USER_DEFINED_OPTIONS. ' +define+LANES_4 ';
     }
      if($num_phylane == 8) {
         $USER_DEFINED_OPTIONS = $USER_DEFINED_OPTIONS. ' +define+LANES_8 ';
     }
   }

   $USER_DEFINED_OPTIONS = $USER_DEFINED_OPTIONS. ' +define+ACDS_19_1';
if ($topology =~ m/^sm.*d1g$/){
     $USER_DEFINED_OPTIONS = $USER_DEFINED_OPTIONS. '+define+1G_SPEED';
   }
   if($topology =~ m/^sm.*d2p5g$/){
     $USER_DEFINED_OPTIONS = $USER_DEFINED_OPTIONS. '+define+2_5G_SPEED';
   }
   if(($topology eq 'sm_10m100m1g2p5g_8bit_d2p5g') || ($topology eq 'sm_1g2p5g_8bit_d2p5g')) {
     $USER_DEFINED_OPTIONS = $USER_DEFINED_OPTIONS. '+define+SM_8BIT_2_5_G_SPEED';
 }  
  if($sequence eq "bandwidth_sequence"){
      $USER_DEFINED_OPTIONS = $USER_DEFINED_OPTIONS. ' +define+BANDWIDTH_ON';
  }	
	
  if($xprop==1) {
      if($ptp_en==1){
      $USER_DEFINED_OPTIONS = $USER_DEFINED_OPTIONS. ' -xprop=$REG_LOCAL_ROOT_DIR_PATH/ip/ethernet/intel_mge_phy_scripts/qhip/scripts/funct_deterministic/common/xprop_config_ptp_file  +define+XPROP';
  }
      else{
      $USER_DEFINED_OPTIONS = $USER_DEFINED_OPTIONS. ' -xprop=$REG_LOCAL_ROOT_DIR_PATH/scripts/common/xprop_config_file  +define+XPROP';
  }
}
#if($ptp_en!=1){
#    $USER_DEFINED_OPTIONS = $USER_DEFINED_OPTIONS. ' +define+__SRC_TEST__ '; #auto-SRC 
#    }
#TODO SRC_AUTO 
    my $rst_defines = "+define+__SRC_TEST__";
    if($ptp_en==1){ 
       ITF::set_option('USER_DEFINED_ELAB_OPTIONS', 'simulation.vcs.verilog', "$USER_DEFINED_OPTIONS $rst_defines");
    } else {
      print "final USER_DEFINED_OPTIONS --> $USER_DEFINED_OPTIONS ";
       ITF::set_option('USER_DEFINED_ELAB_OPTIONS', 'simulation.vcs', "$USER_DEFINED_OPTIONS");
    }
#TODO SRC_AUTO 
    print "Here I am: Before copying gdr_modes.txt \n";
    print `pwd`; 
    my @files_read_by_tb_file = ( "eth_param_tb.sv", "./gdr_gen_qhip_files/gdr_modes.txt");
    ITF::set_option('files_to_be_copied_to_run_directory', 'simulation', \@files_read_by_tb_file);
    `sed -i -e 's/10NM6AGDRA/10nm6agdra/'  dut_top__tiles.v`;
    if($json_en == 1) {
      ITF::pass_files_to_children("dut_top__tiles__dut_top__tile_0.mif");
    } else {
      ITF::pass_files_to_children("dut_top__tiles__z1577a_x0_y0_n0.mif");      
    }
      ITF::pass_files_to_children(".*hex");     
    ###PRASH when "skip_rtl" set to  1 no rtl files will be compiled  (worked with qtlg bypassed)
    if($skip_rtl == 1){
    print "SKIP_RTL \n";
    ITF::set_option('no_generated_ip_files','simulation.vcs',1);
   }
if($llvar eq 'MGBASET') {
my $rtl_mge_files;
  print "\n Adding IP component file for MGBASE-T variant\n";
   if($topology =~ m/^sm_10m100m1g2p5g_16bit_.*g$/){
  $rtl_mge_files = "+vcs+lic+wait -notice +warn=noTFIPC -debug -full64 +v2k -sverilog -lca -kdb +lint=TFIPC-L +lint=PCWM +fsdb+mda -f ../../rtl_files_mgbaset_sm_10m100m1g2p5g_16bit.f";
  }
  elsif($topology eq 'sm_10m100m1g2p5g_8bit_d2p5g'){
  $rtl_mge_files = "+vcs+lic+wait -notice +warn=noTFIPC -debug -full64 +v2k -sverilog -lca -kdb +lint=TFIPC-L +lint=PCWM +fsdb+mda -f ../../rtl_files_mgbaset_sm_10m100m1g2p5g_8bit_d2p5g.f";
  }
  elsif($topology =~ m/^sm_1g2p5g_16bit_.*g$/){
  $rtl_mge_files = "+vcs+lic+wait -notice +warn=noTFIPC -debug -full64 +v2k -sverilog -lca -kdb +lint=TFIPC-L +lint=PCWM +fsdb+mda -f ../../rtl_files_mgbaset_sm_1g2p5g_16bit.f";
  }
  elsif($topology =~ m/^sm_10m100m1g2p5g_8bit_.*g$/){
  $rtl_mge_files = "+vcs+lic+wait -notice +warn=noTFIPC -debug -full64 +v2k -sverilog -lca -kdb +lint=TFIPC-L +lint=PCWM +fsdb+mda -f ../../rtl_files_mgbaset_sm_10m100m1g2p5g_8bit.f";
  }
  elsif($topology =~ m/^sm_1g2p5g_8bit_.*g$/){
  $rtl_mge_files = "+vcs+lic+wait -notice +warn=noTFIPC -debug -full64 +v2k -sverilog -lca -kdb +lint=TFIPC-L +lint=PCWM +fsdb+mda -f ../../rtl_files_mgbaset_sm_1g2p5g_8bit.f";
  }
  else {
  $rtl_mge_files = "+vcs+lic+wait -notice +warn=noTFIPC -debug -full64 +v2k -sverilog -lca -kdb +lint=TFIPC-L +lint=PCWM +fsdb+mda -f ../../rtl_files_mgbaset.f";
  }
  my $USER_IP_COMPONENT = undef;
  $USER_IP_COMPONENT = $USER_IP_COMPONENT. " $rtl_mge_files ";
  ITF::set_option('USER_DEFINED_ELAB_OPTIONS_APPEND', 'simulation.vcs', "$USER_IP_COMPONENT");
   }
if($llvar eq 'MGBASETA10') {
my $rtl_mge_files;
  print "\n Adding IP component file for MGE variant\n";
  $rtl_mge_files = "+vcs+lic+wait -notice +warn=noTFIPC -debug -full64 +v2k -sverilog -lca -kdb +lint=TFIPC-L +lint=PCWM +fsdb+mda -f ../../rtl_files_mgbaset_a10.f";
  my $USER_IP_COMPONENT = undef;
  $USER_IP_COMPONENT = $USER_IP_COMPONENT. " $rtl_mge_files ";
  ITF::set_option('USER_DEFINED_ELAB_OPTIONS_APPEND', 'simulation.vcs', "$USER_IP_COMPONENT");
   }
if($llvar eq 'MGE') {
  my $rtl_mge_files;
  print "\n Adding IP component file for MGE variant\n";
  $rtl_mge_files = "+vcs+lic+wait -notice +warn=noTFIPC -debug -full64 +v2k -sverilog -lca -kdb +lint=TFIPC-L +lint=PCWM +fsdb+mda -f ../../rtl_files_mgeS10.f";
  my $USER_IP_COMPONENT = undef;
  $USER_IP_COMPONENT = $USER_IP_COMPONENT. " $rtl_mge_files ";
  ITF::set_option('USER_DEFINED_ELAB_OPTIONS_APPEND', 'simulation.vcs', "$USER_IP_COMPONENT");
   }
if($llvar eq 'BASERS10') {
  my $rtl_mge_files;
  print "\n Adding IP component file for BASERS10 variant\n";
  $rtl_mge_files = "+vcs+lic+wait -notice +warn=noTFIPC -debug -full64 +v2k -sverilog -lca -kdb +lint=TFIPC-L +lint=PCWM +fsdb+mda -f ../../rtl_files_basers10.f";
  my $USER_IP_COMPONENT = undef;
  $USER_IP_COMPONENT = $USER_IP_COMPONENT. " $rtl_mge_files ";
  ITF::set_option('USER_DEFINED_ELAB_OPTIONS_APPEND', 'simulation.vcs', "$USER_IP_COMPONENT");
   }
if($llvar eq 'BASERA10') {
  my $rtl_mge_files;
  print "\n Adding IP component file for BASERA10 variant\n";
  $rtl_mge_files = "+vcs+lic+wait -notice +warn=noTFIPC -debug -full64 +v2k -sverilog -lca -kdb +lint=TFIPC-L +lint=PCWM +fsdb+mda -f ../../rtl_files_basers10_arria.f";
  my $USER_IP_COMPONENT = undef;
  $USER_IP_COMPONENT = $USER_IP_COMPONENT. " $rtl_mge_files ";
  ITF::set_option('USER_DEFINED_ELAB_OPTIONS_APPEND', 'simulation.vcs', "$USER_IP_COMPONENT");
   }
  if($llvar eq 'MGE_A10') {
  my $rtl_mge_files;
  print "\n Adding IP component file for MGE_A10 variant\n";
  $rtl_mge_files = "+vcs+lic+wait -notice +warn=noTFIPC -debug -full64 +v2k -sverilog -lca -kdb +lint=TFIPC-L +lint=PCWM +fsdb+mda -f ../../rtl_files_MGE_A10.f";
  my $USER_IP_COMPONENT = undef;
  $USER_IP_COMPONENT = $USER_IP_COMPONENT. " $rtl_mge_files ";
  ITF::set_option('USER_DEFINED_ELAB_OPTIONS_APPEND', 'simulation.vcs', "$USER_IP_COMPONENT");
   }
if($llvar eq 'MGE_V') {
  my $rtl_mge_files;
  print "\n Adding IP component file for MGE_V variant\n";
  $rtl_mge_files = "+vcs+lic+wait -notice +warn=noTFIPC -debug -full64 +v2k -sverilog -lca -kdb +lint=TFIPC-L +lint=PCWM +fsdb+mda -f ../../rtl_files_MGE_V.f";
  my $USER_IP_COMPONENT = undef;
  $USER_IP_COMPONENT = $USER_IP_COMPONENT. " $rtl_mge_files ";
  ITF::set_option('USER_DEFINED_ELAB_OPTIONS_APPEND', 'simulation.vcs', "$USER_IP_COMPONENT");
   }
if($llvar eq 'NF10G') {
  my $rtl_mge_files;
  print "\n Adding IP component file for NF10G variant\n";
  $rtl_mge_files = "+vcs+lic+wait -notice +warn=noTFIPC -debug -full64 +v2k -sverilog -lca -kdb +lint=TFIPC-L +lint=PCWM +fsdb+mda -f ../../rtl_files_NF_10G.f";
  my $USER_IP_COMPONENT = undef;
  $USER_IP_COMPONENT = $USER_IP_COMPONENT. " $rtl_mge_files ";
  ITF::set_option('USER_DEFINED_ELAB_OPTIONS_APPEND', 'simulation.vcs', "$USER_IP_COMPONENT");
   }
if($llvar eq 'NF1G') {
  my $rtl_mge_files;
  print "\n Adding IP component file for NF1G variant\n";
  $rtl_mge_files = "+vcs+lic+wait -notice +warn=noTFIPC -debug -full64 +v2k -sverilog -lca -kdb +lint=TFIPC-L +lint=PCWM +fsdb+mda -f ../../rtl_files_NF_1G.f";
  my $USER_IP_COMPONENT = undef;
  $USER_IP_COMPONENT = $USER_IP_COMPONENT. " $rtl_mge_files ";
  ITF::set_option('USER_DEFINED_ELAB_OPTIONS_APPEND', 'simulation.vcs', "$USER_IP_COMPONENT");
   }
}

sub modify_spd{
    my $topology = ITF::get_option("topology", "ITF") || 1;
    my $ptp_en = ITF::get_option("ptp_en", "ITF") || 0;
    my $var=ITF::get_option("VARIANT_NAME","variant");
    my $enable_an  =				ITF::get_option("enable_an",$var);
    my $enable_lt  =				ITF::get_option("enable_lt",$var);
    my $json_en = ITF::get_option("json_en", "ITF");

	 $snps = 'synopsys_vip_common/vip_Q-2020.06D';
	$vcsv = 'vcs';

    #if(!defined($json_en)){
    #if($enable_an==1 ||$enable_lt==1){
    #  $json_en = 1;
    #  }
    # else{
    #  $json_en = 0; }
    #}
    my ($orig_spd_script) = @_;
	 print "Inside modify_spd, ptp_en is $ptp_en $orig_spd_script ";
    ITF::itf_run_system_command("cat $orig_spd_script >> ${orig_spd_script}.new");
    if($topology =~ m/sm/){
	 print "Inside SM topology using sed command  ";
     if($plaintext == 1){
	   print "Inside SM plaintext   ";
       ITF::itf_run_system_command("sed -i 's#$ENV{'ACDS_DEST_ROOT'}/devices/sim_lib/tennm_agilex5_hssi_a_ncrypt.sv#$ENV{'ACDS_DEST_ROOT'}/not_shipped/devices/sim_lib/tennm_agilex5_hssi_a_plaintext.sv#'  ${orig_spd_script}.new");
      }
      ITF::itf_run_system_command("sed -i 's#$ENV{'ACDS_DEST_ROOT'}/devices/sim_lib/tennm_sm7_io96_ncrypt.sv# #'  ${orig_spd_script}.new");
      #ITF::itf_run_system_command("sed -i 's#$ENV{'ACDS_DEST_ROOT'}/devices/sim_lib/tennm_sm7_hssi_a_ncrypt.sv#$ENV{'ACDS_DEST_ROOT'}/not_shipped/devices/sim_lib/tennm_sm7_hssi_a_plaintext.sv#'  ${orig_spd_script}.new");
      ITF::itf_run_system_command("sed -i 's#$ENV{'ACDS_DEST_ROOT'}/devices/sim_lib/tennm_hvio_ncrypt.sv# #'  ${orig_spd_script}.new");  
    }
    ITF::itf_run_system_command("sed -i 's#vcs \-lca \-timescale\=1ps/1ps \-sverilog \+verilog2001ext\+\.v#vcs \-lca  \-sverilog #'  ${orig_spd_script}.new");
   
    return "${orig_spd_script}.new";
}

ITF::register_function("rtl_sim_compile_only_vcs", "run_pre_process", \&rtl_compile_pre_process);

# set timeout to a higher timeout, just in case
sub compile_timeout {
	    
    return "3h";
}
ITF::register_user_function('rtl_sim_compile_only_vcs','get_subtest_timeout',\&compile_timeout);

sub sequence_variants {
    ITF::itf_print_info("RLT Compile Post Process setup");
    my $sequence = ITF::get_option("sequence", "ITF");
    my $dr = ITF::get_option("dr","ITF");
    my $seed = ITF::get_option("seed", "ITF");
    my $type = ITF::get_option("type", "ITF")|| "GDR_ALL";
    my $vip_en_s = ITF::get_option("vip_en", "ITF")|| "yes";
 
    my $official = ITF::get_option("official", "ITF")|| "yes";
    my $var=ITF::get_option("VARIANT_NAME","variant");    
    my $vip_en=undef;

    if($vip_en_s eq "no")
    {
	    $vip_en=0;
    }
   else
    {	    
	$vip_en=1;
	$vip_en_s="yes";
    }
    my $testname ;
#   if($dr==1) {
#       $testname = ITF::get_option("testname", "ITF") || "eth_dr_base_test";
#   } else {
        $testname = ITF::get_option("testname", "ITF") || "eth_gdr_base_test";
#   }
    my $ehip_mode = ITF::get_option("ehip_mode", "ITF");
    
    my $ip_params = ITF::get_option("ip_param_settings", "qsys");
    my $stats_val = ITF::get_option("stats_val",$var);
    my $lf_val = ITF::get_option("lf_val",$var);
    my $rsfec_val = ITF::get_option("rsfec_val",$var);
    my $pam4_val = ITF::get_option("pam4_val",$var);
    my $ptp_val= ITF::get_option("ptp_val",$var);
    my $rx_bytes_to_remove_val=ITF::get_option("rx_bytes_to_remove",$var);
     
my $seq_loopback= ITF::get_option("seq_loopback","ITF")|| undef;
my $short_am=ITF::get_option("short_am",$var)|| 1;
    my $cov = ITF::get_option("cov",'ITF')|| 0;
    my $variants=[];
    my @seq_list = ();
    my @temp_seq_list=();


      if($type eq "lf_alone") {
        $type="LF_"."$lf_val";      
    }

       if($type eq "pcs_alone") {
	   $type="COMP";	   
       }
      #muralasx: Added below logic to pass type of regression to select respective set of sequences.
      if(defined($ehip_mode) && $ehip_mode ne ("PCS+MAC" and "pcs_only"))
      {
      $type=uc $ehip_mode;
      }
   

print "ehip_mode value in itf file : $ehip_mode\n";
print " dr value in itf file : $dr\n";
print " type value in itf file : $type\n";
print " rsfec_val value in itf file : $rsfec_val\n";
print " pam4_val value in itf file : $pam4_val\n";
print " ptp_val value in itf file : $ptp_val\n";

if($ptp_val == 0){
   @seq_list=sequence_list_gen(vip_en=>$vip_en_s,reg_type=>$type,lf_val=>$lf_val,bytes_to_remove_val=>$rx_bytes_to_remove_val,stats_val=>$stats_val,official=>$official,rsfec_val=>$rsfec_val,pam4_val=>$pam4_val,ptp_val=>$ptp_val,dr=>$dr);
} else {
   @seq_list=ptp_sequence_list_gen(vip_en=>$vip_en_s,reg_type=>$type,lf_val=>$lf_val,bytes_to_remove_val=>$rx_bytes_to_remove_val,stats_val=>$stats_val,official=>$official,rsfec_val=>$rsfec_val,pam4_val=>$pam4_val,ptp_val=>$ptp_val,dr=>$dr);  
}

my @failed_seq={"vip_decoder_sequence5_to_10","eth_rxmax_payload_frame_sequence","eth_stat_pause_cnt_sequence","eth_stat_octetsok_cnt_sequence","eth_stat_counter_overflow","eth_stat_mcast_ctrl_cnt_sequence","eth_stat_ucast_ctrl_cnt_sequence","eth_stat_bcast_ctrl_cnt_sequence","vip_decoder_sequence5_to_10","vip_decoder_sequence11_to_14","vip_decoder_sequence28","vip_decoder_sequence24_26_27","vip_decoder_sequence2","vip_decoder_sequence16_21","vip_decoder_sequence20_22_23","eth_register_write_reserved_space_FF","eth_hard_reset_recovery_sequence","eth_hard_reset_recovery_sequence","eth_phy_deskew_reg_sequence","eth_read_in_between_test_sequence","vip_strict_sfd_sequence","eth_vip_control_frame_coverage_sequence","eth_register_ip_hard_reset_sequence","fc_rand_seq"};


   


    my %ip_param;
    my $tmpvar1;
    my $tmpvar2;
    my $tmpvar3;
    #my $var;

# basic_test_param.v is not in GDR
#    open (LIST1, "basic_test_params.v") || die "File not found\n";
#         while (<LIST1>) {
#              ($tmpvar1, $tmpvar2, $tmpvar3) = split(/\s/, $_);
#              $ip_param{$tmpvar2} = $tmpvar3;
#         }
#    close(LIST1);

    print "@seq_list";

 
    if(defined($sequence)){
      if ($dr==1) {
    	$var="$sequence"."__$testname";
      } else {
    	$var="$sequence";
      }
	$variants=[$var] 
}
	else
	{

	$variants=[@seq_list];
}
    ITF::itf_print_info("Printing sequence: @seq_list");

return $variants;
}
ITF::register_function("sequence", "get_variant_list", \&sequence_variants);

sub sequence_update {
    ITF::itf_print_info("Updating sequence variant \n");
    my $variant = ITF::get_subtest_option("variant_name");
    my $sequence = "" ;
    my $testname ="" ;
    my $mode1 = "" ;
    my $mode2 = "" ;
    my @ss=split('__',$variant);
    my $size = @ss;
    my $dr = ITF::get_option("dr","ITF");
	print " dr value in sequence update 1 : $dr\n";
    
	if ($dr==1){
		 $sequence=$ss[0];
    		 $testname=$ss[1];
   
		if ($size==4) {
    				$mode1=$ss[2];
    				$mode2=$ss[3];
    				ITF::set_option("mode1", "ITF", $mode1);
    				ITF::set_option("mode2","ITF",$mode2);

			      }


		if ($size==3){
   				$mode1=$ss[2];
   				ITF::set_option("mode1", "ITF", $mode1);
			     }
    
    		ITF::set_option("sequence", "ITF", $sequence);
    		ITF::set_option("testname", "ITF", $testname);
      
		}else{
			print " dr value in sequence update 2 : $dr\n";

			ITF::itf_print_info("Updating sequence variant");
   			$variant = ITF::get_subtest_option("variant_name");
   			ITF::set_option("sequence", "ITF", $variant);


			}  
}
ITF::register_function("sequence", "update_variant", \&sequence_update);


sub sequence_post_process {
    my $seed = ITF::get_option("seed", "ITF");
    my $num_seeds = 2;
    my $dr = ITF::get_option("dr","ITF");
    print " dr value in sequence post process : $dr\n";
    my $num_seeds_cl = ITF::get_option("num_seeds", "ITF");
    my $json_en = ITF::get_option("json_en", "ITF");
    my $var=ITF::get_option("VARIANT_NAME","variant");
    my $enable_an  =				ITF::get_option("enable_an",$var);
    my $enable_lt  =				ITF::get_option("enable_lt",$var);
    
    #if(!defined($json_en)){
    #if($enable_an==1 ||$enable_lt==1){
    #  $json_en = 1;
    #  }
    # else{
    #  $json_en = 0; }
    #}

    if( defined $num_seeds_cl ) {
	$num_seeds = $num_seeds_cl;
    } else {
	$num_seeds=2;
    }
    
    my $sequence = ITF::get_option("sequence", "ITF");
    my $type = ITF::get_option("type", "ITF");
    my $variants = undef;

    if( defined $seed ) {
	my @seeds = ($seed);
	ITF::set_option('run_seed_sweep__rtl_sim_simulate_only_vcs', 'ITF', \@seeds);
	ITF::enable_seed_sweep({'seed_type'=> 'user', 'stage' => 'rtl_sim_simulate_only_vcs'});
	ITF::set_option("sequence", "ITF", $sequence);
	
    }
    else {
	if($sequence =~ m/comp/) {
	    $num_seeds = 1;

	} elsif ($sequence =~ m/pcs/) {
	    $num_seeds = 1;
	    
	}
	if(defined($seed)) {
	    ITF::enable_seed_sweep({'seed_type' => 'random', 'stage' => 'rtl_sim_simulate_only_vcs', 'seed' => $num_seeds, 'seed_max' => 10000});
	} else {
	    ITF::enable_seed_sweep({'seed' => $num_seeds, 'stage' => 'rtl_sim_simulate_only_vcs', 'seed_type' => 'named_random'});
	}

	ITF::set_option("sequence", "ITF", $sequence);
    }
    if($json_en == 1) {
      ITF::pass_files_to_children("dut_top__tiles__dut_top__tile_0.mif");
    } else {
      ITF::pass_files_to_children("dut_top__tiles__z1577a_x0_y0_n0.mif");
    }
      ITF::pass_files_to_children(".*hex");     
}

ITF::register_function("sequence", "run_post_process", \&sequence_post_process);

sub sim_timeout{
	my $timeout = '20';
       my $short_am=ITF::get_option('short_am','ITF')|| 1;
       my $sequence=ITF::get_option('sequence','ITF');
       my $topology = ITF::get_option("topology", "ITF") || 17;
       my $ptp_en = ITF::get_option("ptp_en", "ITF") || 0;
       my $enable_an=ITF::get_option("enable_an","ITF")||0; 
       my $enable_lt=ITF::get_option("enable_lt","ITF")||0;

       
   	     if($short_am == 0) {
		 $timeout = '12h';
	     } else{
		$timeout = '8h';
	}
	       if($sequence =~ m/an_cl73/) {
		   $timeout = '72h';
	       } elsif ($sequence =~ m/lt_cl72/) {		   	
		   $timeout = '72h';
	       } elsif ($sequence =~ m/pcs/) {		   	
		   $timeout = '24h';
	       } elsif ($sequence =~ m/hard_reset_recovery/) {
		   $timeout = '48h';
	       } elsif ($sequence =~ m/soft_reset_recovery/) {
		   $timeout = '48h';
	       } elsif ($sequence =~ m/reg_access/) {
		   $timeout = '48h';  
	       } elsif ($sequence =~ m/an_/) {
		   $timeout = '144h';
	       } elsif ($sequence =~ m/lt_/) {
		   $timeout = '96h';
	       } elsif ($sequence =~ m/sfd/) {
		   $timeout = '24h';
	       } elsif ($sequence =~ m/bandwidth/) {
		   $timeout = '24h';
	       }	       
	       elsif($sequence =~ m/comp_seq_deskew/) {
		   $timeout = '24h';
	       } 
	       elsif($sequence =~ m/stat/ ) {
	           $timeout = '120h';  #previously 24h,temporary fix-Need to revisit
	       }elsif($sequence =~ m/max_payload_frame_sequence/) {
		       $timeout = '72h';
           }
	       elsif($sequence =~ m/multi_instance/) {
		      if(($topology eq "mm6") || ($topology eq "mm3"))	
		        {$timeout = '72h';}
		      else {$timeout = '48h';}
	       } 
	       else {
		   $timeout = '24h';
	       }


        if($ptp_en==1){
           $timeout = '72h';

	         print("TIMEOUT_BETA PTP $topology: $timeout");
        }


    if($topology == '10m' || $topology == '100m') {
      $timeout = '72h';
    }

    print("TIMEOUT_BETA: $timeout");

return $timeout;
	 
}

ITF::register_user_function('rtl_sim_simulate_only_vcs','get_subtest_timeout',\&sim_timeout);


####################### additional resources for compiling + simulate #######################
sub device_resources {
	 $snps = 'synopsys_vip_common/vip_Q-2020.06D';
	$vcsv = 'vcs';
	 return "$vcsv,vcs-vcsmx-lic,$snps,synopsys_vip_ethernet-lic,synopsys_verdi/Q-2020.03,synopsys-vip-lic,altuvm/0.9p8,vnc_display";


}
ITF::register_user_function("device", "get_arc_resources", \&device_resources);

sub vcs_compile_only_resources {
	$snps = 'synopsys_vip_common/vip_Q-2020.06D';  #move to vip_U-2022.12B for testsuite compliance testing
	$vcsv = 'vcs';

    return "vcs,vcs-vcsmx-lic,$snps,synopsys_vip_ethernet-lic,synopsys_verdi/Q-2020.03,synopsys-vip-lic,altuvm,vnc_display";
}

sub vcs_simulate_only_resources {
    $snps = 'synopsys_vip_common/vip_Q-2020.06D'; #move to vip_U-2022.12B for testsuite compliance testing
    $vcsv = 'vcs';
    return "$vcsv,vcs-vcsmx-lic,$snps,synopsys_vip_ethernet-lic,synopsys_verdi/Q-2020.03,synopsys-vip-lic,altuvm/0.9p8,vnc_display";
}
ITF::register_user_function("rtl_sim_compile_only_vcs", "get_arc_resources", \&vcs_simulate_only_resources);
ITF::register_user_function("rtl_sim_simulate_only_vcs", "get_arc_resources", \&vcs_simulate_only_resources);


####################### qsys variants #######################
# this sections spawns the first stage with random selected
# parameters to be generated.
sub spawn_qsys {
    # set the "loop" number (number of tests to be spawned) in itf_regtest_local.pl
    
    my $test_number = ITF::get_option("loop_count", "ITF") || 128;
    my $variants = [];
    my $official = ITF::get_option("official", "ITF")|| "yes";
    my $param_seed = ITF::get_option("param_seed", "ITF") || int(rand(10000));
    my $type = ITF::get_option("type", "ITF");
    my $cov = ITF::get_option("cov", "ITF") || 0;
    my $topology = ITF::get_option("topology", "ITF") || 17;
    my $ptp_en = ITF::get_option("ptp_en", "ITF") || 0;
    my $multi_inst = ITF::get_option("multi_inst", "ITF") || 0;
    my $ehip_mode =ITF::get_option("ehip_mode", "ITF"); 
    my $num_of_configs =ITF::get_option("num_of_configs", "ITF") || 20; 
    my @bw;
    my @transtype;
    my @ptp;
    my @anlt;
    my @enable_an; 
    my @enable_lt; 
    my @mapport0;
    my @rxfcfwd;
    my @sa;
    my @txvlan;
    my @rxvlan;
    my @enmxfrsize;
    my @enasyncad;
    my @pp;
    my @s_preamble;
    my @sfd;
    my @lf;
    my @fc;
    my @rxbyterem;
    my @rdydrop;
    my @rdylat;
    my @phyrefclk;
    my @syspll;
    my @ipg;
    my @ifc;
    my @fec;
    my @txfrmsize;
    my @rxfrmsize;
    my @ipgrem;
    my @mode;
    my $var;
    my @syspllcst;
    my @cadnum;
    my @cadden;
    my @fp_width;
	my @cadgui;
	my @enable_aib7clk;
    my @ll_speed;
    my @llvar;
    my @devicemode;
 
print("loop_count= $test_number");

my $filename1;
if ($ptp_en==1 && $multi_inst==0) {
    $filename1 = 'gdr_'.$topology.'_ptp.csv';
} elsif ($ptp_en==1 && $multi_inst==1) {
    $filename1 = 'gdr_'.$topology.'_multi_ptp.csv';
} elsif ($multi_inst==1) {
    $filename1 = 'gdr_'.$topology.'_multi.csv';
} else {
    $filename1 = 'll10g_'.$topology.'.csv';
}
copy($filename1,'gdr.csv') or die "Copy failed: $!";
my $filename = 'gdr.csv';
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";
open(my $fh2, '>', 'param_rtl.csv');
open(my $fh1, '>', 'param_tb.csv');
my @new_word;
my @new_word1;
my @words;
my $first_word;
my $speed;
my @phylane;
my @lanemode; 
my $lane_m;
my $lane;
my $num_phylane;
my $i=0;
my @num_entry;
my $count=0;
my $num_inst=0;

if($ehip_mode eq undef) 
{
$num_of_configs=1;
}	
if($ehip_mode eq "pcs_only") 
{
$num_of_configs=1;
}	
print("EHIP_MODE= $ehip_mode");

while (my $row = <$fh>) {
 chomp $row;
 @words = split /,/, $row;
 $first_word=shift @words;
 push @new_word,$first_word;
 push @new_word1,$first_word;
 $first_word =~ s/\s+//g;
 foreach (@words) {
 $speed= $bw[$i];
 $num_phylane=$phylane[$i];

if ( $first_word eq "PTP") {
if ($ptp_en==1) {
    push @ptp,1;
   }
  else{
    push @ptp,0;
}
}


if ( grep( /^$first_word$/, ("TRANSTYPE","ENABLE_AN","ENABLE_LT","RXPAUSEFWD","SA","TXVLAN","RXVLAN","ENMXFRSIZE","ENASYNCAD","PP","S_PREAMBLE","SFD","PTP","MAPPORT0","ENABLE_PTP_AIB7CLK","CUSTOM_CADENCE_GUI","LL10G_SPEED","LL10G_VAR","DEVICE_MODE"))) {
 if ($_ =~ /^\s+$/) {
   $_ = int(rand(1));
 }
 elsif ( (int($_)>1) || ($first_word eq "TRANSTYPE" && ( (($speed==10 || $speed==40) && $_==1) || ($speed==100 && $num_phylane==1 && $_==0) || ($speed==200 && $num_phylane==2 && $_==0) || ($speed==200 && $num_phylane==8 && $_==1) || ($speed==400 && $num_phylane==4 && $_==0) || ($speed==400 && $num_phylane==8 && $_==1) ))) {
  print STDERR "INCORRECT DUT CFG for TRANSTYPE FOUND IN FILE.WILL NOT RUN SIMULATION\n";
  exit;
   }
 $_ =~ s/\s+//g;
  if($first_word eq "TRANSTYPE") {
    push @transtype,$_;
   }
  if($first_word eq "ENABLE_AN") {
    push @enable_an,$_;
   }
   if($first_word eq "ENABLE_LT") {
    push @enable_lt,$_;
   }
   if($first_word eq "MAPPORT0") {
    push @mapport0,$_;
   }
  if($first_word eq "RXPAUSEFWD") {
    push @rxfcfwd,$_;
   }
  if($first_word eq "SA") {
    push @sa,$_;
   }
  if($first_word eq "TXVLAN") {
    push @txvlan,$_;
   }
  if($first_word eq "RXVLAN") {
    push @rxvlan,$_;
   }
  if($first_word eq "ENMXFRSIZE") {
   push @enmxfrsize,$_;
   }
  if($first_word eq "ENASYNCAD") {
    push @enasyncad,$_;
   }
  if($first_word eq "PP") {
    push @pp,$_;
   }
  if($first_word eq "S_PREAMBLE") {
    push @s_preamble,$_;
   }
  if($first_word eq "SFD") {
    push @sfd,$_;
   }
  if($first_word eq "ENABLE_PTP_AIB7CLK") {
    push @enable_aib7clk,$_;
   }
  if($first_word eq "CUSTOM_CADENCE_GUI") {
    push @cadgui,$_;
   }
  if($first_word eq "LL10G_SPEED") {
    push @ll_speed,$_;
   }   
  if($first_word eq "LL10G_VAR") {
    push @llvar,$_;
   }   
  if($first_word eq "DEVICE_MODE") {
    push @devicemode,$_;
   }   
  } #when1

if ( grep( /^$first_word$/, ("SYSPLLCST") ) ) {
 if($syspll[$i]==3 && $_ =~ /^\s+$/){
  print STDERR "PROVIDE FREQ IN CUSTOM MODE.WILL NOT RUN SIMULATION\n";
  exit;
}
 else {
   $_ =~ s/\s+//g;
   push @syspllcst,$_;
   }
}

if ( grep( /^$first_word$/, ("READYDROP","RXBYTEREM","LF","FC") ) ) {
 if($_ =~ /^\s+$/){
   $_ = int(rand(2));
 }
 elsif(int($_) > 2){
         print STDERR "INCORRECT DUT CFG FOUND IN FILE.WILL NOT RUN SIMULATION\n";
         exit;
   }
 $_ =~ s/\s+//g;
  if($first_word eq "READYDROP") {
    push @rdydrop,$_;
   }
  if($first_word eq "RXBYTEREM") {
    push @rxbyterem,$_;
   }
  if($first_word eq "LF") {
    push @lf,$_;
   }
  if($first_word eq "FC") {
    push @fc,$_;
   }
 } #when2

if ( grep( /^$first_word$/, ("RDYLAT","PHYREFCLK","SYSPLL") ) ) {
 if($_ =~ /^\s+$/){
   $_ = int(rand(3));
 }
 elsif(int($_) >3){
  print STDERR "INCORRECT DUT CFG FOUND IN FILE.WILL NOT RUN SIMULATION\n";
  exit;
   }
 $_ =~ s/\s+//g;
  if($first_word eq "RDYLAT") {
    push @rdylat,$_;
   }
 if($first_word eq "SYSPLL") {
    push @syspll,$_;
   }
  if($first_word eq "PHYREFCLK") {
    push @phyrefclk,$_;
   }
 } #when3


if ( $first_word eq "IPG") {
  if($_ =~ /^\s+$/){
   $_ = int(rand(3));
 }
 elsif(int($_) >3){
  print STDERR "INCORRECT IPG FOUND IN FILE.WILL NOT RUN SIMULATION\n";
  exit;
   }
 else {
  if (int($_)==0) {
  $_=1;
   }
  elsif (int($_)==1) {
  $_=8;
   }
  elsif (int($_)==2) {
  $_=10;
   }
  else {
  $_=12;
   }
  }
 $_ =~ s/\s+//g;
    push @ipg,$_;
 } #when3

if ( grep( /^$first_word$/, ("FEC","INTERFACE") ) ) {
 if($_ =~ /^\s+$/){
   $_ = int(rand(4));
 }
 elsif((int($_) >4) || (($speed==200 || $speed==400) && $_==1 && $first_word=="INTERFACE")){
  print STDERR "INCORRECT DUT CFG FOUND IN FILE.WILL NOT RUN SIMULATION\n";
  exit;
   }
 $_ =~ s/\s+//g;
  if($first_word eq "FEC") {
    push @fec,$_;
   }
  if($first_word eq "INTERFACE") {
    push @ifc,$_;
   }
 } #when4

 if($first_word eq "MODE") {
 if($_ =~ /^\s+$/){
  print STDERR "MODE CANT BE LEFT BLANK.WILL NOT RUN SIMULATION\n";
  exit;
   }
 else{
 $_ =~ s/\s+//g;
   if($_ eq "10G_1") {
    push @bw,10;
    push @phylane,1;
    }
   if($_ eq "25G_1" ) { 
    push @bw,25;
    push @phylane,1;
    }
   if($_ eq "40G_4") {
    push @bw,40;
    push @phylane,4;
    }
   if($_ eq "50G_2") {
    push @bw,50;
    push @phylane,2;
    }
   if($_ eq "50G_1") {
    push @bw,50;
    push @phylane,1;
    }
   if($_ eq "100G_4") {
    push @bw,100;
    push @phylane,4;
    }
   if($_ eq "100G_2") {
    push @bw,100;
    push @phylane,2;
    }
   if($_ eq "100G_1") {
    push @bw,100;
    push @phylane,1;
    }
   if($_ eq "200G_8") {
    push @bw,200;
    push @phylane,8;
    }
   if($_ eq "200G_4") {
    push @bw,200;
    push @phylane,4;
    }
   if($_ eq "200G_2") {
    push @bw,200;
    push @phylane,2;
    }
   if($_ eq "400G_8") {
    push @bw,400;
    push @phylane,8;
    }
   if($_ eq "400G_4") {
    push @bw,400;
    push @phylane,4;
    }
    $lane= $bw[-1]/$phylane[-1];
    if(($lane==25) || ($lane==10)) { 
    $lane_m=$bw[-1]."G ".""."NRZ";
    }
    else { 
   	$lane_m=$bw[-1]."G ".""."PAM-4";
    }
    push @lanemode,$lane_m;
}

 push @mode,$_;
} #mode

if ( grep( /^$first_word$/, ("TXMXFRSIZE","RXMXFRSIZE") ) ) {
 if($_ =~ /^\s+$/){
   $_= int(rand(65535));
   }
  elsif(int($_) >65535){
  print STDERR "INCORRECT FRAMESIZE FOUND IN FILE.WILL NOT RUN SIMULATION\n";
  exit;
 }
 $_ =~ s/\s+//g;
  if($first_word eq "TXMXFRSIZE") {
    push @txfrmsize,$_;
   }
  if($first_word eq "RXMXFRSIZE") {
    push @rxfrmsize,$_;
   }
 } #when6

if($first_word eq "IPGREM") {
 if($_ =~ /^\s+$/){
   $_= int(rand(16536));
   }
  elsif(int($_) >16536){
  print STDERR "INCORRECT IPGREM VAL FOUND IN FILE.WILL NOT RUN SIMULATION\n";
  exit;
 }
 $_ =~ s/\s+//g;
    push @ipgrem,$_;
 } #when6
 
 if($first_word eq "FP_WIDTH") {
 if($_ =~ /^\s+$/){
   $_= int(rand(32));
   }
  elsif(int($_) >32){
  print STDERR "INCORRECT FP_WIDTH VAL FOUND IN FILE.WILL NOT RUN SIMULATION\n";
  exit;
 }
 $_ =~ s/\s+//g;
   print "PUSH fp_width $_ \n";
   push @fp_width,$_;
 }

if($first_word eq "INSTANCE") {
 if(($_ =~ /^\s+$/) || int($_)>16){
  print STDERR "INSTANCES CANT BE LEFT BLANK OR CANT BE MORE THAN 16 \n";
  exit;
  } #blank space
  else {
   $num_inst=$_;
   $num_inst =~ s/\s+//g;
   $num_inst=int($num_inst);
   print $num_inst;
   push @num_entry,$num_inst;
 }
 } #if

 push @new_word, sprintf "%10s", $_;
 if($first_word ne "INSTANCE") {
  for(my $j=0; $j<$num_entry[$i]; $j++)
    {push @new_word1, sprintf "%10s", $_;
    } 
  }
   $i++;
} #foreach

my $scal = join(",", @new_word);
print $fh1 $scal;
print $fh1 "\n";
 if($first_word ne "INSTANCE") {
my $scal = join(",", @new_word1);
print $fh2 $scal;
print $fh2 "\n";
}

@new_word=();
@new_word1=();
$i=0;
}#while

print "\ndone with param files\n";
close $fh1;
close $fh2;
#Please remove this code after 1.0
#===========================================================================================================
my $file = "param_tb.csv";
open(my $fh, "<", "param_tb.csv") or die "Unable to open file";
$i=0;
my @lines;
while(<$fh>){
chomp $_;
push(@lines,$_);
}
close $fh;
if(grep(/S_PREAMBLE/,@lines)){
 print "Preamble parameter is defined";
}
else{
  die "Please define Preamble parameter";
}
#===========================================================================================================

print "\n Variant space: \n";
print "\n Preamble: "; print @pp;
print "\n MODE: "; print @mode;
print "\n TRANSCEIVER TYPE: "; print @transtype;
print "\n PTP "; print @ptp;
print "\n ANLT: "; print @anlt;
print "\n Flow_control_rx_frame_fwd: "; print @rxfcfwd;
print "\n Source Address Insertion: "; print @sa;
print "\n RX VLAN VALUE ";print @rxvlan;
print "\n TX VLAN VALUE ";print @txvlan;
print "\n enforce Max Frame Size Enable: "; print @enmxfrsize;
print "\n async : "; print @enasyncad;
print "\n Preamble Passthrough: "; print @pp;
print "\n Strict Preamble: "; print @s_preamble;
print "\n SFD: "; print @sfd;
print "\n LinkFault: "; print @lf;
print "\n FlowControl: "; print @fc;
print "\n rx_bytes_to_remove: "; print @rxbyterem;
print "\n Flow_control_ready_drop: "; print @rdydrop;
print "\n ReadyLatency: "; print @rdylat;
print "\n PHY REF CLK "; print @phyrefclk;
print "\n IPG VALUE. "; print @ipg;
print "\n INTERFACE: "; print @ifc;
print "\n FEC TYPE: "; print @fec;
print "\n SYS PLL CLK: "; print @syspll;
print "\n SYS PLL CUSTOM FREQ: "; print @syspllcst;

print "\n RX frame size "; print @rxfrmsize;
print "\n TX frame size "; print @txfrmsize;
print "\n IPG REM PER PERIOD "; print @ipgrem;
print "\n FP_WIDTH "; print @fp_width;
print "\n ENABLE PTP AIB7CLK "; print @enable_aib7clk;
print "\n CUSTOM_CADENCE_GUI "; print @cadgui;
print "\n LL10G_SPEED "; print @ll_speed;
print "\n LL10G_VAR "; print @llvar;
print "\n DEVICE_MODE "; print @devicemode;
print "\n";


$count = 0;

 for( my $i=0 ; $i < scalar(@bw) ;$i++) {
  for( my $j=0 ; $j < $num_of_configs ;$j++) {

if($ehip_mode eq 'PARAMETER_SWEEP') 
{

 #MODE randomization
 #@mode = ("10G_1","25G_1","40G_4","50G_2","50G_1","100G_4","100G_2","100G_1","200G_8","200G_4","200G_2","400G_8","400G_4");
 if ($ptp_en==1) {
    @mode = ("25G_1","50G_2","50G_1","100G_4","100G_2","100G_1","200G_8","200G_4","200G_2","400G_8","400G_4");
 } else {
    @mode = ("10G_1","25G_1","40G_4","50G_2","50G_1","100G_4","100G_2","100G_1","200G_8","200G_4","200G_2","400G_8","400G_4");
 }
 @mode = shuffle(@mode);

 if($mode[$i] eq "10G_1") {
    $speed = 10;
 }elsif($mode[$i] eq "25G_1") {
    $speed = 25;
 }elsif($mode[$i] eq "40G_4") {
    $speed = 40;
 }elsif($mode[$i] eq "50G_2" || $mode[$i] eq "50G_1") {
    $speed = 50;
 } elsif($mode[$i] eq "100G_4" || $mode[$i] eq "100G_2" || $mode[$i] eq "100G_1") {
    $speed = 100;
 } elsif($mode[$i] eq "200G_8" || $mode[$i] eq "200G_4" || $mode[$i] eq "200G_2") {
    $speed = 200;
 } else {
    $speed = 400;
 }

 print "\nMS_DBG mode : mode = $mode[$i], speed = $speed\n";
 #XCVR type randomization
 if($mode[$i] eq "10G_1" || $mode[$i] eq "40G_4" || $mode[$i] eq "200G_8" || $mode[$i] eq "400G_8") {
    @transtype = (0);
 } elsif($mode[$i] eq "100G_1" || $mode[$i] eq "200G_2" || $mode[$i] eq "400G_4") {
    @transtype = (1);
 } else {
    @transtype =(0,1);
 }
 @transtype = shuffle(@transtype);

 # Interface randomization       
 if ($speed==200 || $speed==400) {
   @ifc = (0);
 }else {
   @ifc = (0,1);
 }
 @ifc = shuffle(@ifc);

 @enasyncad = (0,1);
 @enasyncad = shuffle(@enasyncad);
 if($ifc[$i]!=1) {
  @enasyncad = (0);
 }
 @rxvlan = (0,1);
 @rxvlan = shuffle(@rxvlan);
 @txvlan = (0,1);
 @txvlan = shuffle(@txvlan);
 @rdylat = (0,1,2,3);
 @rdylat = shuffle(@rdylat);
 @rxbyterem = (0,1,2);
 @rxbyterem = shuffle(@rxbyterem);
 @lf = (0,1,2);
 @lf = shuffle(@lf);
 #Range is 65-65536 for rxfrmsize/txfrmsize as per FS
 @rxfrmsize = int(rand(65470)) + 65;   
 @txfrmsize = int(rand(65470)) + 65;
 if ($ptp_en==1) {
    push @ptp,1;
 } else{
    push @ptp,0;
 }
 #@ptp = (0);
 #@ptp = shuffle(@ptp);
 @rxfcfwd = (0,1);
 @rxfcfwd = shuffle(@rxfcfwd);
 @sa = (0,1);
 @sa = shuffle(@sa);
 @enmxfrsize = (0,1);
 @enmxfrsize = shuffle(@enmxfrsize);
 if (($speed==40 || $speed==50) && $ifc[$i] == 1) {
      @pp = (1);
   }else {
      @pp = (0,1);
   }
 @pp = shuffle(@pp);
 @sfd = (0,1);
 @sfd = shuffle(@sfd);
 @s_preamble = (0,1);
 @s_preamble = shuffle(@s_preamble);
 @fc = (0,1,2);
 @fc = shuffle(@fc);
 @rdydrop = (0,1,2,3);
 @rdydrop = shuffle(@rdydrop);
 @phyrefclk = (0);
 @phyrefclk = shuffle(@phyrefclk);
 @ipg = (1,8,10,12);
 @ipg = shuffle(@ipg);
 @ipgrem = int(rand(16536));
 
 #FEC randomization
 if($speed == 400) {
    if($mode[$i] eq "400G_8") {
       @fec = (3,4);
    } elsif ($mode[$i] eq "400G_4") {
       @fec = (3);
    }   
 } elsif($speed==200) {
    if($mode[$i] eq "200G_8" || $mode[$i] eq "200G_2") {
       @fec = (3);     
    } elsif ($mode[$i] eq "200G_4") {        
       @fec = (3,4);
    }   
 } elsif ($speed == 100) {
    if($mode[$i] eq "100G_4") {
       print "\n MS_DBG: Inside FEC 100G_4\n";     
       @fec = (0,2,3);     
    } elsif($mode[$i] eq "100G_2") {
       @fec = (3,4);      
    } elsif($mode[$i] eq "100G_1") {
       @fec = (3);      
    }        
 } elsif ($speed == 50) {
    if($mode[$i] eq "50G_2") {      
       @fec = (0,2,3);
    } elsif($mode[$i] eq "50G_1") {
       @fec = (3,4);      
    }
 } elsif ($speed == 40) {
   @fec = (0);
 } elsif ($speed == 25) {
   @fec = (0,1,2,3);      
 } elsif ($speed == 10) {
   @fec = (0);      
 }
 @fec = shuffle(@fec);

 # SYSPLL randomization
 if($fec[$i] == 3 || $fec[$i] == 4) {
     @syspll = (1,3); 
     # @syspll = (3);#(1);
 } else {
    @syspll = (0,3);
    # @syspll = (3);#(1);
 }
 #@syspll = (0,1,2,3);
 @syspll = shuffle(@syspll);
 if($syspll[$i]==1 || $syspll[$i]==0 ) {
    @syspllcst = (8300781250);
    @cadnum= (16); 
    @cadden= (17);
 } elsif ($syspll[$i]==3) {
  #TODO 16012204509	 
  #@syspllcst = (8300781250,9031250000,9500000000,10000000000,8700000000);
  @syspllcst = (8300781250,9031250000,8700000000);
  @syspllcst = shuffle(@syspllcst);
  @cadgui    = (0,1);
  @cadgui    = shuffle(@cadgui);
  if($speed==40 || $speed==10) {
   if($syspllcst[$i]==8300781250) {
    @cadnum= (32); 
    @cadden= (85);
    }
   if($syspllcst[$i]==9031250000) {
    @cadnum= (100); 
    @cadden= (289);
    }
   if($syspllcst[$i]==9500000000) {
    @cadnum= (25); 
    @cadden= (76);
    }
   if($syspllcst[$i]==10000000000) {
    @cadnum= (5); 
    @cadden= (16);
    }
   if($syspllcst[$i]==8700000000) {
    @cadnum= (125); 
    @cadden= (348);
    }
  }
  else {
    if($syspllcst[$i]==8300781250) {
    @cadnum= (16); 
    @cadden= (17);
   }
    elsif($syspllcst[$i]==9031250000) {
    @cadnum= (250); 
    @cadden= (289);
   }
    elsif($syspllcst[$i]==9500000000) {
    @cadnum= (125); 
    @cadden= (152);
   }
    elsif($syspllcst[$i]==10000000000) {
    @cadnum= (25); 
    @cadden= (32);
   }
    elsif($syspllcst[$i]==8700000000) {
    @cadnum= (625); 
    @cadden= (696);
   }
   else {print "SYSPLLCST is out of Rnange";}
  }
 }
 else {$syspllcst[$i]=8300781250;}
 print "SYSPLLCST value is $syspllcst[$i] CADNUM=$cadnum[$i],cadden=$cadden[$i] \n";
}
#my $variant_name="mode${mode[$i]}_trans${transtype[$i]}_ptp${ptp[$i]}_enablean${enable_an[$i]}_enablelt${enable_lt[$i]}_rxfcfwd${rxfcfwd[$i]}_sa${sa[$i]}_txvlan${txvlan[$i]}_rxvlan${rxvlan[$i]}_enmaxfs${enmxfrsize[$i]}_async${enasyncad[$i]}_pp${pp[$i]}_s_preamble${s_preamble[$i]}_sfd${sfd[$i]}_lf${lf[$i]}_fc${fc[$i]}_rxbyterem${rxbyterem[$i]}_fcrdydrop${rdydrop[$i]}_rlat${rdylat[$i]}_phyrefclk${phyrefclk[$i]}_ipg${ipg[$i]}_ifc${ifc[$i]}_fec${fec[$i]}_txfrmsz${txfrmsize[$i]}_rxfrmsz${rxfrmsize[$i]}_syspll${syspll[$i]}_syspllcst${syspllcst[$i]}_cadnum${cadnum[$i]}_cadden${cadden[$i]}_ipgrm${ipgrem[$i]}";   
my $variant_name;
if ($ehip_mode eq 'PARAMETER_SWEEP') {
    $variant_name="mode${mode[$i]}_trans${transtype[$i]}_llvar${llvar[$i]}_ptp${ptp[$i]}_an${enable_an[$i]}_lt${enable_lt[$i]}_rxfcfwd${rxfcfwd[$i]}_sa${sa[$i]}_txvlan${txvlan[$i]}_rxvlan${rxvlan[$i]}_enmaxfs${enmxfrsize[$i]}_async${enasyncad[$i]}_pp${pp[$i]}_s_preamble${s_preamble[$i]}_sfd${sfd[$i]}_lf${lf[$i]}_fc${fc[$i]}_rxbyterem${rxbyterem[$i]}_fcrdydrop${rdydrop[$i]}_rlat${rdylat[$i]}_phyrefclk${phyrefclk[$i]}_ipg${ipg[$i]}_ifc${ifc[$i]}_fec${fec[$i]}_txfrmsz${txfrmsize[$i]}_rxfrmsz${rxfrmsize[$i]}_syspll${syspll[$i]}_syspllcst${syspllcst[$i]}_cadgui${cadgui[$i]}_ipgrm${ipgrem[$i]}";   
} else {
    $variant_name="mode${mode[$i]}_trans${transtype[$i]}_lvar${llvar[$i]}_ptp${ptp[$i]}_an${enable_an[$i]}_lt${enable_lt[$i]}_rxfw${rxfcfwd[$i]}_sa${sa[$i]}_tx${txvlan[$i]}_rx${rxvlan[$i]}_enmaxfs${enmxfrsize[$i]}_async${enasyncad[$i]}_pp${pp[$i]}_s_pp${s_preamble[$i]}_sfd${sfd[$i]}_lf${lf[$i]}_fc${fc[$i]}_rxbrem${rxbyterem[$i]}_fcrd${rdydrop[$i]}_rlat${rdylat[$i]}_fclk${phyrefclk[$i]}_ipg${ipg[$i]}_ifc${ifc[$i]}_fec${fec[$i]}_txfrmsz${txfrmsize[$i]}_rxfrmsz${rxfrmsize[$i]}_syspll${syspll[$i]}_syspllc${syspllcst[$i]}_ll_speed${ll_speed[$i]}_dev${devicemode[$i]}";   
}
   ITF::set_option("t${count}_$variant_name", "qsys", $variant_name);
			$var = "t${count}_$variant_name";	
					ITF::set_option("transceiver_type",$var,$transtype[$i]);
					ITF::set_option("ptp",$var,$ptp[$i]);
					ITF::set_option("enable_an",$var,$enable_an[$i]);
					ITF::set_option("enable_lt",$var,$enable_lt[$i]);
					ITF::set_option("mapport0",$var,$mapport0[$i]);
					ITF::set_option("rx_fc_fwd",$var,$rxfcfwd[$i]);
					ITF::set_option("sa",$var,$sa[$i]);
					ITF::set_option("rxvlan",$var,$rxvlan[$i]);
					ITF::set_option("txvlan",$var,$txvlan[$i]);
					ITF::set_option("force_max_size",$var,$enmxfrsize[$i]);
					ITF::set_option("mode",$var,$mode[$i]);
					ITF::set_option("async",$var,$enasyncad[$i]);
                                	ITF::set_option("pp_val",$var,$pp[$i]);
                                	ITF::set_option("s_preamble_val",$var,$s_preamble[$i]);
					ITF::set_option("sfd_val",$var,$sfd[$i]);
					ITF::set_option("lanemode",$var,$lanemode[$i]);
					ITF::set_option("lf_val",$var,$lf[$i]);
					ITF::set_option("fc_val",$var,$fc[$i]);
					ITF::set_option("rx_bytes_to_remove",$var,$rxbyterem[$i]);
					ITF::set_option("rx_rdy_drop",$var,$rdydrop[$i]);
					ITF::set_option("rl_val",$var,$rdylat[$i]);
					ITF::set_option("ipg",$var,$ipg[$i]);
                                	ITF::set_option("syspll",$var,$syspll[$i]);
                                	ITF::set_option("syspllcst",$var,$syspllcst[$i]);
                                	ITF::set_option("cadnum",$var,$cadnum[$i]);
                                	ITF::set_option("cadden",$var,$cadden[$i]);
					ITF::set_option("phy_refclk",$var,$phyrefclk[$i]);
					ITF::set_option("num_phylane",$var,$phylane[$i]);
					ITF::set_option("interface",$var,$ifc[$i]);
					ITF::set_option("rsfec_val",$var,$fec[$i]);
					ITF::set_option("rx_fr_size",$var,$rxfrmsize[$i]);
					ITF::set_option("tx_fr_size",$var,$txfrmsize[$i]);
					ITF::set_option("ipg_rem_per_period",$var,$ipgrem[$i]);
					ITF::set_option("enable_aib7clk",$var,$enable_aib7clk[$i]);
					ITF::set_option("cadgui",$var,$cadgui[$i]);
					ITF::set_option("ll_speed",$var,$ll_speed[$i]);
					ITF::set_option("llvar",$var,$llvar[$i]);
					ITF::set_option("devicemode",$var,$devicemode[$i]);
		   		ITF::set_option("number",$var,($num_inst-1));
		   		ITF::set_option("ptp_val",$var,$ptp[$i]);
               if($topology eq '17a_aib20ux12'){
		  $topology = "17a_20";
	       }else {
                  $topology = $topology;
               }
               if($ptp[$i] == 1){
                  if($fp_width[$i] eq undef){
                     ITF::set_option("fp_width",$var,32);
                  } else {
                     ITF::set_option("fp_width",$var,$fp_width[$i]);
                  }
               } else {
                  ITF::set_option("fp_width",$var,8); #8 is the min valid value
               }
                if ($multi_inst==1) {
			     	if ($count eq "0") {
			    	  push @$variants, "t${topology}_n${count}_${variant_name}";
			        }  
                } elsif ($ehip_mode eq 'PARAMETER_SWEEP') {
                   push @$variants, "t${count}_${variant_name}";
                } else {
                   push @$variants, "t${topology}_n${count}_${variant_name}";
                }
          $count=$count+1;
				  ITF::set_option("variant_number",$i, $var);	   
}
 }

ITF::set_option("number_of_variants",0,$count); 

if ($count eq "1" ) { 
 ITF::set_option("number_of_instances",0,$num_inst ); 
}

if ($count > "1" ) { 
 ITF::set_option("number_of_instances",0,$count); 
} 
 print "\n DBG: variants : $variants\n";
 return $variants;
}

ITF::register_function('qsys', 'get_variant_list', \&spawn_qsys);


####################### qsys update variant #######################
# this section updates each individual spawned test case set up in qsys variants
# this will allow to randomize the selection of parameters for each test case
# insert perl randomization script here!
sub update_qsys {

    my $transtype    ; 
    my $ptp          ; 
    my $enable_an    ;
    my $enable_lt    ;
    my $mapport0     ;
    my $rxfcfwd      ;
    my $sa           ; 
    my $rxvlan       ;
    my $txvlan       ;
    my $enmxfrsize   ;
    my $enasyncad    ;
    my $pp           ;
    my $s_preamble   ;
    my $sfd          ;
    my $lanemode     ;
    my $lf           ;
    my $fc           ;
    my $rxbyterem    ;
    my $rdydrop      ;
    my $rdylat       ;
    my $ipg          ;
    my $syspll       ;
    my $syspllcst    ;
    my $cadnum       ;
    my $cadden       ;
    my $phyrefclk    ;
    my $num_phylane  ;
    my $ifc          ;
    my $fec          ;
    my $rxfrmsize    ;
    my $txfrmsize    ;
    my $ipgrem       ;
    my $mode         ;
    my $ip_num_h     ;
    my $num_var      ;
    my $single_var_multi_inst =0 ;
    my $ll_speed     ;
    my $llvar     ;
    my $devicemode     ;
    #PTP only
    my $fp_width;
	my $enable_aib7clk;
	my $cadgui;
    my $outname;
    my $outname_mge;
    my $outname_fpll;
    my $outname_ATX_pll;
    my $outname_ATX_pll_10g;
    my $outname_ATX_pll_2p5g;
    my $outname_core_fpll;
    my $outname_address_decoder_channel;
    my $outname_xcvr_reset_ctrl;
    my $outname_xcvr_fpll;
    my $outname_anlt;
    my $outname_syspll;
    my $outname_src;
    my $outname_iopll;
    my $outname_initdone;
    my @ipdeploy_list;
    my @qsys_ip_list;
    #MGE  related variables
    my $outname_xcvr_fpll;
    my $outname_jtag_avalon_master;

    my $project = ITF::get_project();
    my $ehip_mode =ITF::get_option("ehip_mode", "ITF"); 
    my $topology = ITF::get_option("topology", "ITF") || 17;
    my $sequence = ITF::get_option("sequence", "ITF");
    my $variant = ITF::get_subtest_option("variant_name");
    ITF::set_option("VARIANT_NAME","variant",$variant);

    my $multi_inst = ITF::get_option("multi_inst", "ITF") || 0;
    if($multi_inst==1) {
       $ip_num_h   =ITF::get_option("number_of_instances", 0);
       $num_var    =ITF::get_option("number_of_variants", 0);
       if($num_var eq "1" && $ip_num_h > 1) { $single_var_multi_inst =1;}
    } else {
       $ip_num_h  =	ITF::get_option("number",$variant);
       $ip_num_h  = $ip_num_h+1;
    }    
    
    ITF::set_option("single_var_multi_inst",'update_qsys',$single_var_multi_inst);
    print "\n DBG: ip_num_h : $ip_num_h\n";

    for(my $ip_num=0;$ip_num<$ip_num_h;$ip_num++) {
      
      print "\n DBG: inside for loop ip_num : $ip_num\n";   
      if($ehip_mode eq 'PARAMETER_SWEEP') {
        $variant = ITF::get_subtest_option("variant_name");
      } elsif($single_var_multi_inst == 1) {
         $variant  =ITF::get_option("variant_number",0);     
      } else {
         $variant  =ITF::get_option("variant_number",$ip_num);      
      }
      ITF::set_option("VARIANT_NAME","variant",$variant);

      print "DBG: variant_name : $variant\n";

      $transtype  =   			ITF::get_option("transceiver_type",$variant);
      $ptp  =				ITF::get_option("ptp",$variant);
      $enable_an  =				ITF::get_option("enable_an",$variant);
      $enable_lt  =				ITF::get_option("enable_lt",$variant);
      $mapport0  =				ITF::get_option("mapport0",$variant);
      $rxfcfwd  =				ITF::get_option("rx_fc_fwd",$variant);
      $sa  =				ITF::get_option("sa",$variant);
      $rxvlan  =				ITF::get_option("rxvlan",$variant);
      $txvlan  =				ITF::get_option("txvlan",$variant);
      $enmxfrsize  =				ITF::get_option("force_max_size",$variant);
      $enasyncad  =				ITF::get_option("async",$variant);
      $pp  =                        	ITF::get_option("pp_val",$variant);
      $s_preamble  =                        	ITF::get_option("s_preamble_val",$variant);
      $sfd  =				ITF::get_option("sfd_val",$variant);
      $lanemode  =				ITF::get_option("lanemode",$variant);
      $lf  =				ITF::get_option("lf_val",$variant);
      $fc  =				ITF::get_option("fc_val",$variant);
      $rxbyterem =				ITF::get_option("rx_bytes_to_remove",$variant);
      $rdydrop  =				ITF::get_option("rx_rdy_drop",$variant);
      $rdylat  =				ITF::get_option("rl_val",$variant);
      $ipg  =				ITF::get_option("ipg",$variant);
      $syspll  =			        ITF::get_option("syspll",$variant);
      $syspllcst  =			ITF::get_option("syspllcst",$variant);
      $cadnum  =			        ITF::get_option("cadnum",$variant);
      $cadden  =			        ITF::get_option("cadden",$variant);
      $phyrefclk  =			ITF::get_option("phy_refclk",$variant);
      $num_phylane  =			ITF::get_option("num_phylane",$variant);
      $ifc   =				ITF::get_option("interface",$variant);
      $fec  =				ITF::get_option("rsfec_val",$variant);
      $rxfrmsize   =			ITF::get_option("rx_fr_size",$variant);
      $txfrmsize  =			ITF::get_option("tx_fr_size",$variant);
      $ipgrem  =				ITF::get_option("ipg_rem_per_period",$variant);
      $mode  =				ITF::get_option("mode",$variant);
      $fp_width  =		ITF::get_option("fp_width",$variant);
	  $enable_aib7clk  =		ITF::get_option("enable_aib7clk",$variant);
	  $cadgui  =		ITF::get_option("cadgui",$variant);
      $ll_speed =       ITF::get_option("ll_speed",$variant);
      $llvar =       ITF::get_option("llvar",$variant);
      $devicemode =       ITF::get_option("devicemode",$variant);
      
      print "Finger Print value is $fp_width \n";
      print "ll Speed is <ITF> $ll_speed \n";
      print "ll Variant is <ITF> $llvar \n";
      my $ptp_debug_acc_en;
      $ptp_debug_acc_en = ITF::get_option("ptp_debug_acc_en", "ITF");
      if($ptp == 1) {
         if($ptp_debug_acc_en eq undef) {
            $ptp_debug_acc_en = 1; #default to 1
         } else {            
            print "\n DBG: ptp_debug_acc_en -- 1 : $ptp_debug_acc_en\n";
         }
      } else {
         $ptp_debug_acc_en = 0;         
      }
      print "\n DBG: ptp_debug_acc_en -- 2 : $ptp_debug_acc_en\n";		
		ITF::set_option("ptp_debug_acc_en",'update_qsys',$ptp_debug_acc_en);

      #updating param_tb csv to take the parameter sweep values
      if($ehip_mode eq 'PARAMETER_SWEEP'){ 
         my $filename_var;
         
         copy( "param_tb.csv" , "param_tb_paramsweep.csv" ) or die "Copy failed : $!";
         open( $filename_var , '+<' , 'param_tb_paramsweep.csv');

         `sed -i 's/.*RXVLAN.*/RXVLAN , $rxvlan/g' param_tb_paramsweep.csv` ;
         `sed -i 's/.*TXVLAN.*/TXVLAN , $txvlan/g' param_tb_paramsweep.csv` ;
         `sed -i 's/.*RDYLAT.*/RDYLAT , $rdylat/g' param_tb_paramsweep.csv` ;
         `sed -i 's/.*RXBYTEREM.*/RXBYTEREM , $rxbyterem/g' param_tb_paramsweep.csv` ;
         `sed -i 's/.*LF.*/LF , $lf/g' param_tb_paramsweep.csv` ;
         `sed -i 's/.*FC .*/FC , $fc/g' param_tb_paramsweep.csv` ;
         `sed -i 's/.*RXMXFRSIZE.*/RXMXFRSIZE , $rxfrmsize/g' param_tb_paramsweep.csv` ;
         `sed -i 's/.*TXMXFRSIZE.*/TXMXFRSIZE , $txfrmsize/g' param_tb_paramsweep.csv` ;
         `sed -i 's/.*PTP.*/PTP , $ptp/g' param_tb_paramsweep.csv` ;
         `sed -i 's/.*RXPAUSEFWD.*/RXPAUSEFWD , $rxfcfwd/g' param_tb_paramsweep.csv` ;
         `sed -i 's/.*SA.*/SA , $sa/g' param_tb_paramsweep.csv` ;
         `sed -i 's/.*ENMXFRSIZE.*/ENMXFRSIZE , $enmxfrsize/g' param_tb_paramsweep.csv` ;
         `sed -i 's/.*ENASYNCAD.*/ENASYNCAD , $enasyncad/g' param_tb_paramsweep.csv` ;
         `sed -i 's/.*PP.*/PP , $pp/g' param_tb_paramsweep.csv` ;
         `sed -i 's/.*S_PREAMBLE.*/S_PREAMBLE , $s_preamble/g' param_tb_paramsweep.csv` ;
         `sed -i 's/.*SFD.*/SFD , $sfd/g' param_tb_paramsweep.csv` ;
         `sed -i 's/.*READYDROP.*/READYDROP , $rdydrop/g' param_tb_paramsweep.csv` ;
         `sed -i 's/.*PHYREFCLK.*/PHYREFCLK , $phyrefclk/g' param_tb_paramsweep.csv` ;
         `sed -i 's/.*IPG .*/IPG , $ipg/g' param_tb_paramsweep.csv` ;
         `sed -i 's/.*SYSPLL .*/SYSPLL , $syspll/g' param_tb_paramsweep.csv` ;
         `sed -i 's/.*SYSPLLCST .*/SYSPLLCST , $syspllcst/g' param_tb_paramsweep.csv` ;
         `sed -i 's/.*CAD_NUM .*/CAD_NUM , $cadnum/g' param_tb_paramsweep.csv` ;
         `sed -i 's/.*CAD_DEN .*/CAD_DEN , $cadden/g' param_tb_paramsweep.csv` ;
         `sed -i 's/.*IPGREM .*/IPGREM , $ipgrem/g' param_tb_paramsweep.csv` ;
         `sed -i 's/.*FEC .*/FEC , $fec/g' param_tb_paramsweep.csv` ;
         `sed -i 's/.*INTERFACE .*/INTERFACE , $ifc/g' param_tb_paramsweep.csv` ;
         `sed -i 's/.*TRANSTYPE .*/TRANSTYPE , $transtype/g' param_tb_paramsweep.csv` ;
         `sed -i 's/.*MODE .*/MODE , $mode/g' param_tb_paramsweep.csv` ;
         `sed -i 's/.*CUSTOM_CADENCE_GUI.*/CUSTOM_CADENCE_GUI , $cadgui/g' param_tb_paramsweep.csv` ;
 
         move( "param_tb_paramsweep.csv" , "param_tb.csv" ) or die "Move failed : $!";
         close $filename_var;
     }


       	my $fname1 = "basic_test_params_ip$ip_num.v";
				my $fname2 = "eth_param_tb_ip$ip_num.sv";
				
				open(my $fh1, '>', $fname1) or die "Could not open file $fname1";
				open(my $fh, '>', $fname2) or die "Could not open file $fname2";
				


				print($fh "class eth_param_tb_ip$ip_num extends uvm_object;\n");
				print($fh "string eth_mode= $mode; \n");
				print($fh "string ll_speed= $ll_speed; \n");
				print($fh "string llvar= $llvar; \n");
				print($fh "string devicemode= $devicemode; \n");
				print($fh "bit trans_type= $transtype; \n");
				print($fh "bit ptp= $ptp; \n");
				print($fh "bit rx_fc_fwd= $rxfcfwd; \n");
				print($fh "bit sa= $sa; \n");
				print($fh "bit txvlan= $txvlan; \n");
				print($fh "bit rxvlan= $rxvlan; \n");
				print($fh "bit en_mx_frsz= $enmxfrsize; \n");
				print($fh "bit en_async_adp= $enasyncad; \n");
				print($fh "bit preamble_passthrough= $pp; \n");
				print($fh "bit strict_preamble= $s_preamble; \n");
				print($fh "bit sfd= $sfd; \n");
				print($fh "bit [1:0] lf=$lf; \n");
				print($fh "bit [1:0] fc=$fc; \n");
				print($fh "bit [1:0] rxbyte_rem= $rxbyterem; \n");
				print($fh "bit [1:0] fc_rdy_drop= $rdydrop; \n");
				print($fh "bit [1:0] rdy_lat= $rdylat; \n");
                                print($fh "bit [1:0] phyrefclk= $phyrefclk; \n");
                                print($fh "bit [1:0] ipg= $ipg; \n");
                                print($fh "bit [2:0] interface= $ifc; \n");
                                print($fh "bit [2:0] fec_type= $fec; \n");  
				print($fh "int tx_frm_size= $txfrmsize; \n");
				print($fh "int rx_frm_size= $rxfrmsize; \n");
				print($fh "int ipg_rm_perperiod= $ipgrem; \n\n");
				print($fh "`uvm_object_utils_begin(eth_param_tb_ip$ip_num)\n");
				print($fh "`uvm_field_string(eth_mode,UVM_ALL_ON)\n");
				print($fh "`uvm_field_string(ll_speed,UVM_ALL_ON)\n");
				print($fh "`uvm_field_string(llvar,UVM_ALL_ON)\n");
				print($fh "`uvm_field_string(devicemode,UVM_ALL_ON)\n");
				print($fh "`uvm_field_int(trans_type,UVM_ALL_ON)\n");
				print($fh "`uvm_field_int(ptp,UVM_ALL_ON)\n");
				print($fh "`uvm_field_int(anlt,UVM_ALL_ON)\n");
				print($fh "`uvm_field_int(rx_fc_fwd,UVM_ALL_ON)\n");
				print($fh "`uvm_field_int(sa,UVM_ALL_ON)\n");
				print($fh "`uvm_field_int(txvlan,UVM_ALL_ON)\n");
				print($fh "`uvm_field_int(rxvlan,UVM_ALL_ON)\n");
				print($fh "`uvm_field_int(en_mx_frsz,UVM_ALL_ON)\n");
				print($fh "`uvm_field_int(en_async_adp,UVM_ALL_ON)\n");
				print($fh "`uvm_field_int(preamble_passthrough,UVM_ALL_ON)\n");
				print($fh "`uvm_field_int(strict_preamble,UVM_ALL_ON)\n");
				print($fh "`uvm_field_int(sfd,UVM_ALL_ON)\n");
				print($fh "`uvm_field_int(lf,UVM_ALL_ON)\n");
				print($fh "`uvm_field_int(fc,UVM_ALL_ON)\n");
				print($fh "`uvm_field_int(rxbyte_rem,UVM_ALL_ON)\n");
                                print($fh "`uvm_field_int(fc_rdy_drop,UVM_ALL_ON)\n");
                                print($fh "`uvm_field_int(rdy_lat,UVM_ALL_ON)\n");
                                print($fh "`uvm_field_int(phyrefclk,UVM_ALL_ON)\n");
                                print($fh "`uvm_field_int(ipg,UVM_ALL_ON)\n");
				print($fh "`uvm_field_int(interface,UVM_ALL_ON)\n");
				print($fh "`uvm_field_int(fec_type,UVM_ALL_ON)\n");
				print($fh "`uvm_field_int(tx_frm_size,UVM_ALL_ON)\n");
				print($fh "`uvm_field_int(rx_frm_size,UVM_ALL_ON)\n");
				print($fh "`uvm_field_int(ipg_rm_perperiod,UVM_ALL_ON)\n");
				print($fh "`uvm_object_utils_end\n\n");
				print($fh "function new(string name=\"eth_param_tb_ip$ip_num\");\n");
				print($fh " super.new(name);\n");
				print($fh "endfunction \n");
				print($fh "endclass \n");
	            
				print($fh1 "`define eth_mode_ip$ip_num $mode\n");
				print($fh1 "`define ll_speed_ip$ip_num $mode\n");
				print($fh1 "`define llvar_ip$ip_num $mode\n");
				print($fh1 "`define trans_type_ip$ip_num $transtype\n");
				print($fh1 "`define ptp_ip$ip_num $ptp\n");
				print($fh1 "`define rx_fc_fwd_ip$ip_num $rxfcfwd \n");
				print($fh1 "`define sa_ip$ip_num $sa \n");
				print($fh1 "`define txvlan_ip$ip_num $txvlan \n");
				print($fh1 "`define rxvlan_ip$ip_num $rxvlan \n");
				print($fh1 "`define en_mx_frsz_ip$ip_num $enmxfrsize \n");
				print($fh1 "`define en_async_adp_ip$ip_num $enasyncad \n");
				print($fh1 "`define preamble_passthrough_ip$ip_num $pp \n");
				print($fh1 "`define strict_preamble_ip$ip_num $s_preamble \n");
				print($fh1 "`define sfd_ip$ip_num $sfd \n");
				print($fh1 "`define lf_ip$ip_num $lf \n");
				print($fh1 "`define fc_ip$ip_num $fc \n");
				print($fh1 "`define rxbyte_rem_ip$ip_num $rxbyterem \n");
                                print($fh1 "`define fc_rdy_drop_ip$ip_num $rdydrop \n");
                                print($fh1 "`define rdy_lat_ip$ip_num $rdylat \n");
                                print($fh1 "`define phy_refclk_ip$ip_num $phyrefclk \n");
                                print($fh1 "`define ipg_ip$ip_num $ipg \n");
				print($fh1 "`define interface_ip$ip_num $ifc \n");
				print($fh1 "`define fec_type_ip$ip_num $fec \n");
				print($fh1 "`define tx_frm_size_ip$ip_num $txfrmsize \n");
				print($fh1 "`define rx_frm_size_ip$ip_num $rxfrmsize \n");
				print($fh1 "`define ipg_rm_perperiod_ip$ip_num $ipgrem \n");
                        				
				close $fh1;
				close $fh;
  
      $variant="mode${mode}_trans${transtype}_ptp${ptp}_enablean${enable_an}_enablelt${enable_lt}_rxfcfwd${rxfcfwd}_sa${sa}_txvlan${txvlan}_rxvlan${rxvlan}_enmaxfs${enmxfrsize}_async${enasyncad}_pp${pp}_s_preamble${s_preamble}_sfd${sfd}_lf${lf}_fc${fc}_rxbyterem${rxbyterem}_fcrdydrop${rdydrop}_rlat${rdylat}_phyrefclk${phyrefclk}_ipg${ipg}_ifc${ifc}_fec${fec}_txfrmsz${txfrmsize}_rxfrmsz${rxfrmsize}_ipgrm${ipgrem}";   
      
      my $rx_bytes_to_remove;
      if ($rxbyterem eq "0") {$rx_bytes_to_remove = "None";}
      if ($rxbyterem eq "1") {$rx_bytes_to_remove = "Remove CRC bytes";}
      if ($rxbyterem eq "2") {$rx_bytes_to_remove = "Remove CRC and PAD bytes";}
      my $lf_mode;
      if ($lf eq "0") {$lf_mode = "Off";}
      if ($lf eq "1") {$lf_mode = "Unidirectional";}
      if ($lf eq "2") {$lf_mode = "Bidirectional";}
      
      my $fc_mode;
      if (($fc eq "0")or($fc eq "")) {$fc_mode = "No";}
      if ($fc eq "1") {$fc_mode = "Yes";}
      if ($fc eq "2") {$fc_mode = "Disable flow control";}

 my $phyclk;
 my $syspll_freq;
 my $syspll_cst_freq;
 my $ip_deploy;
 my $ip_deploy_anlt;
 my $ip_deploy_mge;
 my $ip_deploy_syspll;
 my $ip_deploy_src;
 my $ip_deploy_iopll;
 my $ip_deploy_initdone;
 my $ip_deploy_fpll;
 my $ip_deploy_ATX_pll;
 my $ip_deploy_xcvr_fpll;
 my $ip_deploy_ATX_pll_10g;
 my $ip_deploy_ATX_pll_2p5g;
 my $ip_deploy_core_pll;
 my $ip_deploy_xcvr_reset_ctrl;
 my $components_fpll;
 my $components_ATX_pll;
 my $components_ATX_pll_10g;
 my $components_ATX_pll_2p5g;
 my $components_core_pll;
 my $components_xcvr_fpll;
 my $components_xcvr_reset_ctrl;
 my $components;
 my $components_anlt;
 my $components_syspll;
 my $components_src;
 my $components_iopll;
 my $components_initdone;
 my $components_mge;
 my $cr_mode ; #0 or 1
 my $an_chan0 = int(rand($num_phylane-1));
 my $fec_anlt; 
 my $anlt_val;
 if($enable_an or $enable_lt) {$anlt_val=1;}
 else
 {$anlt_val=0;} #int(rand(2)) future change 
my $eth_preset;
my $manual_ref;
my $manual_m_counter;
my $manual_n_counter;
my $src_manual;
my $generate_syspll;
#MGE related variables
my $ip_deploy_xcvr_fpll;
my $ip_deploy_jtag_avalon_master;
my $components_xcvr_fpll;
my $components_altera_jtag_avalon_master;

switch($fec){
	case 0 {$fec_anlt= 0;}
	case 1 {$fec_anlt= 3;}
	case 2 {$fec_anlt= 1;}
	case 3 {$fec_anlt= 1;}
	case 4 {$fec_anlt= 2;}
}

 if($topology eq 12) {$cr_mode =0;}
 else {$cr_mode = int(rand(2));}

 ITF::set_option("cr_mode",'update_qsys',$cr_mode);
 ITF::set_option("anlt_val",'update_qsys',$anlt_val);

 print "Mode value for ip deploy";
 $mode=~ tr/_/-/;
 print $mode;


    if($phyrefclk ==0 ) {$phyclk="156.250000";}
    if($phyrefclk ==1 ) {$phyclk="322.265625";}
    if($phyrefclk ==2 ) {$phyclk="312.500000";}
    if($phyrefclk ==3 ) {$phyclk="644.531250";}
    if($syspll ==0 ) {$syspll_freq="805.6640625";}
    if($syspll ==1 ) {$syspll_freq="830.078125";}
    if($syspll ==2 ) {$syspll_freq="322.265625";}
    if($syspll ==3){
      if($syspllcst==10000000000) {
      substr $syspllcst,4,0,'.';}
      else {
      substr $syspllcst,3,0,'.'; }
 	print "CUSTOM FREQ";
	print $syspllcst;
	}


	if ($syspll<3) {$eth_preset="ETHERNET_FREQ_${syspll_freq}_$phyclk";print "debug:",$eth_preset}
	else
	{$eth_preset="ETHERNET_FREQ_OTHER";}

	switch($eth_preset){
		case "ETHERNET_FREQ_830_156" {$manual_ref=156250000; $manual_m_counter=85; $manual_n_counter=2;}
		case "ETHERNET_FREQ_805_156" {$manual_ref=156250000; $manual_m_counter=165; $manual_n_counter=4;}
		case "ETHERNET_FREQ_830_312" {$manual_ref=312500000; $manual_m_counter=85; $manual_n_counter=4;}
		case "ETHERNET_FREQ_805_312" {$manual_ref=312500000; $manual_m_counter=165; $manual_n_counter=8;}
		case "ETHERNET_FREQ_830_322" {$manual_ref=322265600; $manual_m_counter=165; $manual_n_counter=8;}
		case "ETHERNET_FREQ_805_322" {$manual_ref=322265600; $manual_m_counter=80; $manual_n_counter=4;}
		else  {$manual_ref=156250000; $manual_m_counter=165; $manual_n_counter=4;}
	}
   
   $src_manual = 2; 
if($topology eq 'sm_1g2p5g_16bit_d2p5g'){
        print "\n Inside SM_1G_2.5G IP deploy";

 #MAC
 $components = +{   
     'ENABLE_ED_FILESET_SIM'=>'1',
     'ENABLE_ED_FILESET_SYNTHESIS'=>'0',
     'SELECT_SUPPORTED_VARIANT'=>'6',
     'SELECT_NUMBER_OF_CHANNEL'=>'2',
     'ENABLE_1G10G_MAC'=>'3',
     # 'ENABLE_TXRX_DATAPATH'=>'0',
     'ENABLE_10GBASER_REG_MODE'=>'0',
     'ENABLE_TIMESTAMPING'=>'0',
     'ENABLE_PTP_1STEP'=>'0',
     'INSERT_XGMII_ADAPTOR'=>'0',
     'INSERT_CSR_ADAPTOR'=>'0',
     'INSERT_ST_ADAPTOR'=>'0',
   };

#PHY
 $components_mge = +{
     'DEFAULT_MODE'=>'1',
     'SPEED_VARIANT'=>'1',
     'ENABLE_SGMII'=>'0',
     'EXT_PHY_MGBASET'=>'1',
     'EXT_PHY_NBASET'=>'0',
 };

#SYS PLL 
 $components_syspll = +{
  'syspll_mod_0' => 'ETHERNET_FREQ_322_156',
  'default_value'=>'0',
  'syspll_freq_mhz_enanble_0'=>'true',   
  'syspll_freq_mhz_0'=>'322.265625', # '805.6640625  ',
  'dev_abilityrefclk_xcvr_freq_mhz_0'=>'156.250000',
  'syspll_use_case'=>'TRANSCEIVER_USE_CASE' ,  

  };

#SSS
 $components_src = +{
    'DEVICE_FAMILY' => 'SUNDANCEMESA',
    'NUM_LANES_SHORELINE' => 1
  };
 
$outname='alt_em10g32_0';
$outname_mge='alt_mge_phy_0';
$outname_syspll='intel_systemclk_gts';
$outname_src='intel_src_sss';
    
$ip_deploy = +{
    'output-name' => $outname ,
    #	'component-name' => 'alt_em10g32',
    'component-name' => 'intel_eth_em10g32',
    'component-param' => $components,
};
push(@ipdeploy_list,$ip_deploy);
$ip_deploy_mge = +{
    'output-name' => $outname_mge ,
    # 'component-name' => 'alt_mge_phy',
    'component-name' => 'intel_mge_phy',
    'component-param' => $components_mge,
};
push(@ipdeploy_list,$ip_deploy_mge);
$ip_deploy_syspll = +{
    'output-name' => $outname_syspll ,
    'component-name' => 'intel_systemclk_gts',
    'component-param' => $components_syspll,
};
push(@ipdeploy_list,$ip_deploy_syspll);
$ip_deploy_src = +{
    'output-name' => $outname_src,
    'component-name' => 'intel_srcss_gts',
    'component-param' => $components_src,
};
push(@ipdeploy_list,$ip_deploy_src);

    ITF::set_option('ip_deploy_list', 'ITF',\@ipdeploy_list);
    ITF::set_option('enable_ip_deploy', 'ITF', 1);
    print "drajasek enabled IP deploy\n";
    ITF::itf_run_system_command("cp ip_files_MGE_s10/* .");
    push(@qsys_ip_list, "${outname}.ip");
    push(@qsys_ip_list, "${outname_mge}.ip");
    push(@qsys_ip_list, "${outname_syspll}.ip");
    push(@qsys_ip_list, "${outname_src}.ip");
   
    ITF::set_option('qsys_ip_list', 'ITF', \@qsys_ip_list);  
    print "drajasek added to qsys ip list\n";
}
elsif($topology eq 'sm_10m100m1g2p5g_16bit_d2p5g'){
        print "\n Inside SM_10M_100M_1G_2.5G IP deploy";

 #MAC
 $components = +{   
     'ENABLE_ED_FILESET_SIM'=>'1',
     'ENABLE_ED_FILESET_SYNTHESIS'=>'0',
     'SELECT_SUPPORTED_VARIANT'=>'6',
     'SELECT_NUMBER_OF_CHANNEL'=>'2',
     'ENABLE_1G10G_MAC'=>'6',
     # 'ENABLE_TXRX_DATAPATH'=>'0',
     'ENABLE_10GBASER_REG_MODE'=>'0',
     'ENABLE_TIMESTAMPING'=>'0',
     'ENABLE_PTP_1STEP'=>'0',
     'INSERT_XGMII_ADAPTOR'=>'0',
     'INSERT_CSR_ADAPTOR'=>'0',
     'INSERT_ST_ADAPTOR'=>'0',
   };

#PHY
 $components_mge = +{
     'DEFAULT_MODE'=>'1',
     'SPEED_VARIANT'=>'1',
     'ENABLE_SGMII'=>'1',
     'EXT_PHY_MGBASET'=>'1',
     'EXT_PHY_NBASET'=>'0',
 };

#SYS PLL 
 $components_syspll = +{
  'syspll_mod_0' => 'ETHERNET_FREQ_322_156',
  'default_value'=>'0',
  'syspll_freq_mhz_enanble_0'=>'true',   
  'syspll_freq_mhz_0'=>'322.265625', # '805.6640625  ',
  #'refclk_xcvr_freq_mhz_0'=>'156.250000',
  'syspll_use_case'=>'TRANSCEIVER_USE_CASE' ,  

  };

#SSS
 $components_src = +{
    'DEVICE_FAMILY' => 'SUNDANCEMESA',
    'NUM_LANES_SHORELINE' => 1
  };
 
$outname='alt_em10g32_0';
$outname_mge='alt_mge_phy_0';
$outname_syspll='intel_systemclk_gts';
$outname_src='intel_src_sss';
    
$ip_deploy = +{
    'output-name' => $outname ,
    #	'component-name' => 'alt_em10g32',
    'component-name' => 'intel_eth_em10g32',
    'component-param' => $components,
};
push(@ipdeploy_list,$ip_deploy);
$ip_deploy_mge = +{
    'output-name' => $outname_mge ,
    # 'component-name' => 'alt_mge_phy',
    'component-name' => 'intel_mge_phy',
    'component-param' => $components_mge,
};
push(@ipdeploy_list,$ip_deploy_mge);
$ip_deploy_syspll = +{
    'output-name' => $outname_syspll ,
    'component-name' => 'intel_systemclk_gts',
    'component-param' => $components_syspll,
};
push(@ipdeploy_list,$ip_deploy_syspll);
$ip_deploy_src = +{
    'output-name' => $outname_src,
    'component-name' => 'intel_srcss_gts',
    'component-param' => $components_src,
};
push(@ipdeploy_list,$ip_deploy_src);

    ITF::set_option('ip_deploy_list', 'ITF',\@ipdeploy_list);
    ITF::set_option('enable_ip_deploy', 'ITF', 1);
    print "drajasek enabled IP deploy\n";
    ITF::itf_run_system_command("cp ip_files_MGE_s10/* .");
    push(@qsys_ip_list, "${outname}.ip");
    push(@qsys_ip_list, "${outname_mge}.ip");
    push(@qsys_ip_list, "${outname_syspll}.ip");
    push(@qsys_ip_list, "${outname_src}.ip");
   
    ITF::set_option('qsys_ip_list', 'ITF', \@qsys_ip_list);  
    print "drajasek added to qsys ip list\n";
}
elsif($topology eq 'sm_1g2p5g_8bit_d2p5g'){
        print "\n Inside sm_1g2p5g_8bit_d2p5g IP deploy";

 #MAC
 $components = +{   
     'ENABLE_ED_FILESET_SIM'=>'1',
     'ENABLE_ED_FILESET_SYNTHESIS'=>'0',
     'SELECT_SUPPORTED_VARIANT'=>'6',
     'SELECT_NUMBER_OF_CHANNEL'=>'2',
     'ENABLE_1G10G_MAC'=>'3',
     # 'ENABLE_TXRX_DATAPATH'=>'0',
     'ENABLE_10GBASER_REG_MODE'=>'0',
     'ENABLE_TIMESTAMPING'=>'0',
     'ENABLE_PTP_1STEP'=>'0',
     'INSERT_XGMII_ADAPTOR'=>'0',
     'INSERT_CSR_ADAPTOR'=>'0',
     'INSERT_ST_ADAPTOR'=>'0',
   };

#PHY
 $components_mge = +{
     'DEFAULT_MODE'=>'1',
     'SPEED_VARIANT'=>'1',
     'ENABLE_SGMII'=>'0',
     'EXT_PHY_MGBASET'=>'1',
     'EXT_PHY_NBASET'=>'0',
     'ENABLE_GMII_ADAPTER'=>'1',
 };

#SYS PLL 
 $components_syspll = +{
  'syspll_mod_0' => 'ETHERNET_FREQ_322_156',
  'default_value'=>'0',
  'syspll_freq_mhz_enanble_0'=>'true',   
  'syspll_freq_mhz_0'=>'322.265625', # '805.6640625  ',
  #'refclk_xcvr_freq_mhz_0'=>'156.250000',
  'syspll_use_case'=>'TRANSCEIVER_USE_CASE' ,  

  };

#SSS
 $components_src = +{
    'DEVICE_FAMILY' => 'SUNDANCEMESA',
    'NUM_LANES_SHORELINE' => 1
  };
 
  $components_iopll = +{
    'gui_refclk1_frequency' => '100',
    'gui_use_locked' => 1
  };
  
  $components_initdone = +{
  };

$outname='alt_em10g32_0';
$outname_mge='alt_mge_phy_0';
$outname_syspll='intel_systemclk_gts';
$outname_src='intel_src_sss';
$outname_iopll='iopll_iopll_0';
$outname_initdone='reset_ip_s10_user_rst_clkgate_0';

$ip_deploy = +{
    'output-name' => $outname ,
    #	'component-name' => 'alt_em10g32',
    'component-name' => 'intel_eth_em10g32',
    'component-param' => $components,
};
push(@ipdeploy_list,$ip_deploy);
$ip_deploy_mge = +{
    'output-name' => $outname_mge ,
    # 'component-name' => 'alt_mge_phy',
    'component-name' => 'intel_mge_phy',
    'component-param' => $components_mge,
};
push(@ipdeploy_list,$ip_deploy_mge);
$ip_deploy_syspll = +{
    'output-name' => $outname_syspll ,
    'component-name' => 'intel_systemclk_gts',
    'component-param' => $components_syspll,
};
push(@ipdeploy_list,$ip_deploy_syspll);
$ip_deploy_src = +{
    'output-name' => $outname_src,
    'component-name' => 'intel_srcss_gts',
    'component-param' => $components_src,
};
push(@ipdeploy_list,$ip_deploy_src);
$ip_deploy_iopll = +{
    'output-name' => $outname_iopll,
    'component-name' => 'altera_iopll',
    'component-param' => $components_iopll,
};
push(@ipdeploy_list,$ip_deploy_iopll);
$ip_deploy_initdone = +{
    'output-name' => $outname_initdone,
    'component-name' => 'altera_s10_user_rst_clkgate',
    'component-param' => $components_initdone,
};
push(@ipdeploy_list,$ip_deploy_initdone);

    ITF::set_option('ip_deploy_list', 'ITF',\@ipdeploy_list);
    ITF::set_option('enable_ip_deploy', 'ITF', 1);
    print "drajasek enabled IP deploy\n";
    ITF::itf_run_system_command("cp ip_files_MGE_s10/* .");
    push(@qsys_ip_list, "${outname}.ip");
    push(@qsys_ip_list, "${outname_mge}.ip");
    push(@qsys_ip_list, "${outname_syspll}.ip");
    push(@qsys_ip_list, "${outname_src}.ip");
    push(@qsys_ip_list, "${outname_iopll}.ip");
    push(@qsys_ip_list, "${outname_initdone}.ip");

    ##HPS
    #push(@qsys_ip_list, "hps_axi_bridge_clock_in.ip");
    #push(@qsys_ip_list, "hps_axi_bridge_intel_agilex_5_soc_0.ip");
    #push(@qsys_ip_list, "hps_axi_bridge_mm_bridge_0.ip");
    #push(@qsys_ip_list, "hps_axi_bridge_reset_in.ip");
    #push(@qsys_ip_list, "hps_axi_bridge.qsys");
    
    #SYSPLL
    push(@qsys_ip_list, "syspll_clk_bridge_clock_bridge_0.ip");
    push(@qsys_ip_list, "syspll_clk_bridge_intel_systemclk_gts_1.ip");
    push(@qsys_ip_list, "syspll_clk_bridge.qsys");
    
    ITF::set_option('qsys_ip_list', 'ITF', \@qsys_ip_list);  
    print "drajasek added to qsys ip list\n";
}
elsif($topology eq 'sm_10m100m1g2p5g_8bit_d2p5g'){
        print "\n Inside SM_10M_100M_1G_2.5G_8Bit IP deploy";

 #MAC
 $components = +{   
     'ENABLE_ED_FILESET_SIM'=>'1',
     'ENABLE_ED_FILESET_SYNTHESIS'=>'0',
     'SELECT_SUPPORTED_VARIANT'=>'6',
     'SELECT_NUMBER_OF_CHANNEL'=>'2',
     'ENABLE_1G10G_MAC'=>'6',
     # 'ENABLE_TXRX_DATAPATH'=>'0',
     'ENABLE_10GBASER_REG_MODE'=>'0',
     'ENABLE_TIMESTAMPING'=>'0',
     'ENABLE_PTP_1STEP'=>'0',
     'INSERT_XGMII_ADAPTOR'=>'0',
     'INSERT_CSR_ADAPTOR'=>'0',
     'INSERT_ST_ADAPTOR'=>'0',
   };

#PHY
 $components_mge = +{
     'DEFAULT_MODE'=>'1',
     'SPEED_VARIANT'=>'1',
     'ENABLE_SGMII'=>'1',
     'EXT_PHY_MGBASET'=>'1',
     'EXT_PHY_NBASET'=>'0',
     'ENABLE_GMII_ADAPTER'=>'1',
 };

#SYS PLL 
 $components_syspll = +{
  'syspll_mod_0' => 'ETHERNET_FREQ_322_156',
  'default_value'=>'0',
  'syspll_freq_mhz_enanble_0'=>'true',   
  'syspll_freq_mhz_0'=>'322.265625', # '805.6640625  ',
  #'refclk_xcvr_freq_mhz_0'=>'156.250000',
  'syspll_use_case'=>'TRANSCEIVER_USE_CASE' ,  

  };

#SSS
 $components_src = +{
    'DEVICE_FAMILY' => 'SUNDANCEMESA',
    'NUM_LANES_SHORELINE' => 1
  };
 
$outname='alt_em10g32_0';
$outname_mge='alt_mge_phy_0';
$outname_syspll='intel_systemclk_gts';
$outname_src='intel_src_sss';
    
$ip_deploy = +{
    'output-name' => $outname ,
    #	'component-name' => 'alt_em10g32',
    'component-name' => 'intel_eth_em10g32',
    'component-param' => $components,
};
push(@ipdeploy_list,$ip_deploy);
$ip_deploy_mge = +{
    'output-name' => $outname_mge ,
    # 'component-name' => 'alt_mge_phy',
    'component-name' => 'intel_mge_phy',
    'component-param' => $components_mge,
};
push(@ipdeploy_list,$ip_deploy_mge);
$ip_deploy_syspll = +{
    'output-name' => $outname_syspll ,
    'component-name' => 'intel_systemclk_gts',
    'component-param' => $components_syspll,
};
push(@ipdeploy_list,$ip_deploy_syspll);
$ip_deploy_src = +{
    'output-name' => $outname_src,
    'component-name' => 'intel_srcss_gts',
    'component-param' => $components_src,
};
push(@ipdeploy_list,$ip_deploy_src);

    ITF::set_option('ip_deploy_list', 'ITF',\@ipdeploy_list);
    ITF::set_option('enable_ip_deploy', 'ITF', 1);
    print "drajasek enabled IP deploy\n";
    ITF::itf_run_system_command("cp ip_files_MGE_s10/* .");
    push(@qsys_ip_list, "${outname}.ip");
    push(@qsys_ip_list, "${outname_mge}.ip");
    push(@qsys_ip_list, "${outname_syspll}.ip");
    push(@qsys_ip_list, "${outname_src}.ip");
   
    ITF::set_option('qsys_ip_list', 'ITF', \@qsys_ip_list);  
    print "drajasek added to qsys ip list\n";
}
elsif($topology eq 'sm_1g2p5g_16bit_d1g'){
        print "\n Inside SM_1G_2.5G IP deploy";

 #MAC
 $components = +{   
     'ENABLE_ED_FILESET_SIM'=>'1',
     'ENABLE_ED_FILESET_SYNTHESIS'=>'0',
     'SELECT_SUPPORTED_VARIANT'=>'6',
     'SELECT_NUMBER_OF_CHANNEL'=>'2',
     'ENABLE_1G10G_MAC'=>'3',
     # 'ENABLE_TXRX_DATAPATH'=>'0',
     'ENABLE_10GBASER_REG_MODE'=>'0',
     'ENABLE_TIMESTAMPING'=>'0',
     'ENABLE_PTP_1STEP'=>'0',
     'INSERT_XGMII_ADAPTOR'=>'0',
     'INSERT_CSR_ADAPTOR'=>'0',
     'INSERT_ST_ADAPTOR'=>'0',
   };

#PHY
 $components_mge = +{
     'DEFAULT_MODE'=>'0',
     'SPEED_VARIANT'=>'1',
     'ENABLE_SGMII'=>'0',
     'EXT_PHY_MGBASET'=>'1',
     'EXT_PHY_NBASET'=>'0',
 };

#SYS PLL 
 $components_syspll = +{
  'syspll_mod_0' => 'ETHERNET_FREQ_322_156',
  'default_value'=>'0',
  'syspll_freq_mhz_enanble_0'=>'true',   
  'syspll_freq_mhz_0'=>'322.265625', # '805.6640625  ',
  #'refclk_xcvr_freq_mhz_0'=>'156.250000',
  'syspll_use_case'=>'TRANSCEIVER_USE_CASE' ,  

  };

#SSS
 $components_src = +{
    'DEVICE_FAMILY' => 'SUNDANCEMESA',
    'NUM_LANES_SHORELINE' => 1
  };
 
$outname='alt_em10g32_0';
$outname_mge='alt_mge_phy_0';
$outname_syspll='intel_systemclk_gts';
$outname_src='intel_src_sss';
    
$ip_deploy = +{
    'output-name' => $outname ,
    #	'component-name' => 'alt_em10g32',
    'component-name' => 'intel_eth_em10g32',
    'component-param' => $components,
};
push(@ipdeploy_list,$ip_deploy);
$ip_deploy_mge = +{
    'output-name' => $outname_mge ,
    # 'component-name' => 'alt_mge_phy',
    'component-name' => 'intel_mge_phy',
    'component-param' => $components_mge,
};
push(@ipdeploy_list,$ip_deploy_mge);
$ip_deploy_syspll = +{
    'output-name' => $outname_syspll ,
    'component-name' => 'intel_systemclk_gts',
    'component-param' => $components_syspll,
};
push(@ipdeploy_list,$ip_deploy_syspll);
$ip_deploy_src = +{
    'output-name' => $outname_src,
    'component-name' => 'intel_srcss_gts',
    'component-param' => $components_src,
};
push(@ipdeploy_list,$ip_deploy_src);

    ITF::set_option('ip_deploy_list', 'ITF',\@ipdeploy_list);
    ITF::set_option('enable_ip_deploy', 'ITF', 1);
    print "drajasek enabled IP deploy\n";
    ITF::itf_run_system_command("cp ip_files_MGE_s10/* .");
    push(@qsys_ip_list, "${outname}.ip");
    push(@qsys_ip_list, "${outname_mge}.ip");
    push(@qsys_ip_list, "${outname_syspll}.ip");
    push(@qsys_ip_list, "${outname_src}.ip");
   
    ITF::set_option('qsys_ip_list', 'ITF', \@qsys_ip_list);  
    print "drajasek added to qsys ip list\n";
}
elsif($topology eq 'sm_10m100m1g2p5g_16bit_d1g'){
        print "\n Inside SM_10M_100M_1G_2.5G IP deploy";

 #MAC
 $components = +{   
     'ENABLE_ED_FILESET_SIM'=>'1',
     'ENABLE_ED_FILESET_SYNTHESIS'=>'0',
     'SELECT_SUPPORTED_VARIANT'=>'6',
     'SELECT_NUMBER_OF_CHANNEL'=>'2',
     'ENABLE_1G10G_MAC'=>'6',
     # 'ENABLE_TXRX_DATAPATH'=>'0',
     'ENABLE_10GBASER_REG_MODE'=>'0',
     'ENABLE_TIMESTAMPING'=>'0',
     'ENABLE_PTP_1STEP'=>'0',
     'INSERT_XGMII_ADAPTOR'=>'0',
     'INSERT_CSR_ADAPTOR'=>'0',
     'INSERT_ST_ADAPTOR'=>'0',
   };

#PHY
 $components_mge = +{
     'DEFAULT_MODE'=>'0',
     'SPEED_VARIANT'=>'1',
     'ENABLE_SGMII'=>'1',
     'EXT_PHY_MGBASET'=>'1',
     'EXT_PHY_NBASET'=>'0',
 };

#SYS PLL 
 $components_syspll = +{
  'syspll_mod_0' => 'ETHERNET_FREQ_322_156',
  'default_value'=>'0',
  'syspll_freq_mhz_enanble_0'=>'true',   
  'syspll_freq_mhz_0'=>'322.265625', # '805.6640625  ',
  #'refclk_xcvr_freq_mhz_0'=>'156.250000',
  'syspll_use_case'=>'TRANSCEIVER_USE_CASE' ,  

  };

#SSS
 $components_src = +{
    'DEVICE_FAMILY' => 'SUNDANCEMESA',
    'NUM_LANES_SHORELINE' => 1
  };
 
$outname='alt_em10g32_0';
$outname_mge='alt_mge_phy_0';
$outname_syspll='intel_systemclk_gts';
$outname_src='intel_src_sss';
    
$ip_deploy = +{
    'output-name' => $outname ,
    #	'component-name' => 'alt_em10g32',
    'component-name' => 'intel_eth_em10g32',
    'component-param' => $components,
};
push(@ipdeploy_list,$ip_deploy);
$ip_deploy_mge = +{
    'output-name' => $outname_mge ,
    # 'component-name' => 'alt_mge_phy',
    'component-name' => 'intel_mge_phy',
    'component-param' => $components_mge,
};
push(@ipdeploy_list,$ip_deploy_mge);
$ip_deploy_syspll = +{
    'output-name' => $outname_syspll ,
    'component-name' => 'intel_systemclk_gts',
    'component-param' => $components_syspll,
};
push(@ipdeploy_list,$ip_deploy_syspll);
$ip_deploy_src = +{
    'output-name' => $outname_src,
    'component-name' => 'intel_srcss_gts',
    'component-param' => $components_src,
};
push(@ipdeploy_list,$ip_deploy_src);

    ITF::set_option('ip_deploy_list', 'ITF',\@ipdeploy_list);
    ITF::set_option('enable_ip_deploy', 'ITF', 1);
    print "drajasek enabled IP deploy\n";
    ITF::itf_run_system_command("cp ip_files_MGE_s10/* .");
    push(@qsys_ip_list, "${outname}.ip");
    push(@qsys_ip_list, "${outname_mge}.ip");
    push(@qsys_ip_list, "${outname_syspll}.ip");
    push(@qsys_ip_list, "${outname_src}.ip");
   
    ITF::set_option('qsys_ip_list', 'ITF', \@qsys_ip_list);  
    print "drajasek added to qsys ip list\n";
}
elsif($topology eq 'sm_1g2p5g_8bit_d1g'){
        print "\n Inside SM_1G_2.5G_8BIT IP deploy";

 #MAC
 $components = +{   
     'ENABLE_ED_FILESET_SIM'=>'1',
     'ENABLE_ED_FILESET_SYNTHESIS'=>'0',
     'SELECT_SUPPORTED_VARIANT'=>'6',
     'SELECT_NUMBER_OF_CHANNEL'=>'2',
     'ENABLE_1G10G_MAC'=>'3',
     # 'ENABLE_TXRX_DATAPATH'=>'0',
     'ENABLE_10GBASER_REG_MODE'=>'0',
     'ENABLE_TIMESTAMPING'=>'0',
     'ENABLE_PTP_1STEP'=>'0',
     'INSERT_XGMII_ADAPTOR'=>'0',
     'INSERT_CSR_ADAPTOR'=>'0',
     'INSERT_ST_ADAPTOR'=>'0',
   };

#PHY
 $components_mge = +{
     'DEFAULT_MODE'=>'0',
     'SPEED_VARIANT'=>'1',
     'ENABLE_SGMII'=>'0',
     'EXT_PHY_MGBASET'=>'1',
     'EXT_PHY_NBASET'=>'0',
     'ENABLE_GMII_ADAPTER'=>'1',
 };

#SYS PLL 
 $components_syspll = +{
  'syspll_mod_0' => 'ETHERNET_FREQ_322_156',
  'default_value'=>'0',
  'syspll_freq_mhz_enanble_0'=>'true',   
  'syspll_freq_mhz_0'=>'322.265625', # '805.6640625  ',
  #'refclk_xcvr_freq_mhz_0'=>'156.250000',
  'syspll_use_case'=>'TRANSCEIVER_USE_CASE' ,  

  };

#SSS
 $components_src = +{
    'DEVICE_FAMILY' => 'SUNDANCEMESA',
    'NUM_LANES_SHORELINE' => 1
  };
 
$outname='alt_em10g32_0';
$outname_mge='alt_mge_phy_0';
$outname_syspll='intel_systemclk_gts';
$outname_src='intel_src_sss';
    
$ip_deploy = +{
    'output-name' => $outname ,
    #	'component-name' => 'alt_em10g32',
    'component-name' => 'intel_eth_em10g32',
    'component-param' => $components,
};
push(@ipdeploy_list,$ip_deploy);
$ip_deploy_mge = +{
    'output-name' => $outname_mge ,
    # 'component-name' => 'alt_mge_phy',
    'component-name' => 'intel_mge_phy',
    'component-param' => $components_mge,
};
push(@ipdeploy_list,$ip_deploy_mge);
$ip_deploy_syspll = +{
    'output-name' => $outname_syspll ,
    'component-name' => 'intel_systemclk_gts',
    'component-param' => $components_syspll,
};
push(@ipdeploy_list,$ip_deploy_syspll);
$ip_deploy_src = +{
    'output-name' => $outname_src,
    'component-name' => 'intel_srcss_gts',
    'component-param' => $components_src,
};
push(@ipdeploy_list,$ip_deploy_src);

    ITF::set_option('ip_deploy_list', 'ITF',\@ipdeploy_list);
    ITF::set_option('enable_ip_deploy', 'ITF', 1);
    print "drajasek enabled IP deploy\n";
    ITF::itf_run_system_command("cp ip_files_MGE_s10/* .");
    push(@qsys_ip_list, "${outname}.ip");
    push(@qsys_ip_list, "${outname_mge}.ip");
    push(@qsys_ip_list, "${outname_syspll}.ip");
    push(@qsys_ip_list, "${outname_src}.ip");
   
    ITF::set_option('qsys_ip_list', 'ITF', \@qsys_ip_list);  
    print "drajasek added to qsys ip list\n";
}
elsif($topology eq 'sm_10m100m1g2p5g_8bit_d1g'){
        print "\n Inside SM_10M_100M_1G_2.5G_8Bit IP deploy";

 #MAC
 $components = +{   
     'ENABLE_ED_FILESET_SIM'=>'1',
     'ENABLE_ED_FILESET_SYNTHESIS'=>'0',
     'SELECT_SUPPORTED_VARIANT'=>'6',
     'SELECT_NUMBER_OF_CHANNEL'=>'2',
     'ENABLE_1G10G_MAC'=>'6',
     # 'ENABLE_TXRX_DATAPATH'=>'0',
     'ENABLE_10GBASER_REG_MODE'=>'0',
     'ENABLE_TIMESTAMPING'=>'0',
     'ENABLE_PTP_1STEP'=>'0',
     'INSERT_XGMII_ADAPTOR'=>'0',
     'INSERT_CSR_ADAPTOR'=>'0',
     'INSERT_ST_ADAPTOR'=>'0',
   };

#PHY
 $components_mge = +{
     'DEFAULT_MODE'=>'0',
     'SPEED_VARIANT'=>'1',
     'ENABLE_SGMII'=>'1',
     'EXT_PHY_MGBASET'=>'1',
     'EXT_PHY_NBASET'=>'0',
     'ENABLE_GMII_ADAPTER'=>'1',
 };

#SYS PLL 
 $components_syspll = +{
  'syspll_mod_0' => 'ETHERNET_FREQ_322_156',
  'default_value'=>'0',
  'syspll_freq_mhz_enanble_0'=>'true',   
  'syspll_freq_mhz_0'=>'322.265625', # '805.6640625  ',
  #'refclk_xcvr_freq_mhz_0'=>'156.250000',
  'syspll_use_case'=>'TRANSCEIVER_USE_CASE' ,  

  };

#SSS
 $components_src = +{
    'DEVICE_FAMILY' => 'SUNDANCEMESA',
    'NUM_LANES_SHORELINE' => 1
  };
 
$outname='alt_em10g32_0';
$outname_mge='alt_mge_phy_0';
$outname_syspll='intel_systemclk_gts';
$outname_src='intel_src_sss';
    
$ip_deploy = +{
    'output-name' => $outname ,
    #	'component-name' => 'alt_em10g32',
    'component-name' => 'intel_eth_em10g32',
    'component-param' => $components,
};
push(@ipdeploy_list,$ip_deploy);
$ip_deploy_mge = +{
    'output-name' => $outname_mge ,
    # 'component-name' => 'alt_mge_phy',
    'component-name' => 'intel_mge_phy',
    'component-param' => $components_mge,
};
push(@ipdeploy_list,$ip_deploy_mge);
$ip_deploy_syspll = +{
    'output-name' => $outname_syspll ,
    'component-name' => 'intel_systemclk_gts',
    'component-param' => $components_syspll,
};
push(@ipdeploy_list,$ip_deploy_syspll);
$ip_deploy_src = +{
    'output-name' => $outname_src,
    'component-name' => 'intel_srcss_gts',
    'component-param' => $components_src,
};
push(@ipdeploy_list,$ip_deploy_src);

    ITF::set_option('ip_deploy_list', 'ITF',\@ipdeploy_list);
    ITF::set_option('enable_ip_deploy', 'ITF', 1);
    print "drajasek enabled IP deploy\n";
    ITF::itf_run_system_command("cp ip_files_MGE_s10/* .");
    push(@qsys_ip_list, "${outname}.ip");
    push(@qsys_ip_list, "${outname_mge}.ip");
    push(@qsys_ip_list, "${outname_syspll}.ip");
    push(@qsys_ip_list, "${outname_src}.ip");
   
    ITF::set_option('qsys_ip_list', 'ITF', \@qsys_ip_list);  
    print "drajasek added to qsys ip list\n";
}
else {   
##mprash2x
if ($llvar eq 'USXGMII') { 
      print "\n drajasek entering USXGMII IP-deploy\n";
	$components = +{
	'DEVICE_FAMILY' =>'Stratix 10',
        'ENABLE_ED_FILESET_SIM'=>'1',
        'ENABLE_ED_FILESET_SYNTHESIS'=>'1',
        'SELECT_SUPPORTED_VARIANT'=>'9',
        'SELECT_NUMBER_OF_CHANNEL'=>'2',
        'ENABLE_1G10G_MAC'=>'5',
        'ENABLE_10GBASER_REG_MODE'=>'0',
        'ENABLE_TIMESTAMPING'=>'0',
        'ENABLE_PTP_1STEP'=>'0',
        'INSERT_ST_ADAPTOR'=>'1',
        'INSERT_CSR_ADAPTOR'=>'0',
        'INSERT_XGMII_ADAPTOR'=>'0'
    };
   $components_mge = +{
        'DEVICE_FAMILY' =>'Stratix 10',
	'BASE_DEVICE' => 'ND5U',
	'DEVICE' => '1ST280EY1F55E2VG',
	'AUTO_DEVICE_SPEEDGRADE' => '2',
	'DEVICE_DIE_TYPES' => 'HSSI_CRETE2E,HSSI_CRETE3,MAIN_ND5'
      #	'EXT_PHY_NBASET' => '1'
      #  'ENABLE_ED_FILESET_SIM'=>'1',
       # 'ENABLE_ED_FILESET_SYNTHESIS'=>'1',
        #'SELECT_SUPPORTED_VARIANT'=>'9',
      #  'SELECT_NUMBER_OF_CHANNEL'=>'2',
      #  'ENABLE_1G10G_MAC'=>'5',
      #  'ENABLE_10GBASER_REG_MODE'=>'0',
      #  'ENABLE_TIMESTAMPING'=>'0',
       # 'ENABLE_PTP_1STEP'=>'0',
       # 'INSERT_ST_ADAPTOR'=>'1',
       # 'INSERT_CSR_ADAPTOR'=>'0',
       # 'INSERT_XGMII_ADAPTOR'=>'0'
    };
    $components_core_pll = +{
        'DEVICE_FAMILY' =>'Stratix 10',
        'set_primary_use' => '0',
        'set_refclk_cnt' => '1',
        'set_refclk_index' => '0',
        'set_power_mode' => '1_0V',
        'set_x2_core_clock' => 'true',
        'set_output_clock_frequency' => '312.5',
        'set_auto_reference_clock_frequency'=>'644.53125'
    };
    $components_ATX_pll = +{
        'DEVICE_FAMILY' =>'Stratix 10',
        'prot_mode'=>'Basic',
        'bw_sel'=>'medium',
        'refclk_cnt'=>'1',
        'refclk_index'=>'0',
        'usr_analog_voltage'=>'1_0V',
        'primary_pll_buffer'=>'GX clock output buffer',
        'enable_GXT_clock_source'=>'disabled',
        'set_output_clock_frequency'=>'5156.25',
        'set_auto_reference_clock_frequency'=>'644.53125',
        'enable_mcgb'=>'1',
        'mcgb_div'=>'1',
        'enable_hfreq_clk'=>'1',
        'mcgb_aux_clkin_cnt'=>'0'
    }; 
    $components_xcvr_reset_ctrl = +{
        'DEVICE_FAMILY' =>'Stratix 10',
        'CHANNELS' => '1',
        'PLLS' =>'1',
        'SYS_CLK_IN_MHZ' =>'125',
        'REDUCED_SIM_TIME'=>'1',
        'TX_ENABLE' =>'1',
        'TX_MANUAL_RESET'=>'Auto',
        'T_TX_ANALOGRESET'=>'70000',
        'T_TX_DIGITALRESET'=>'70000',
        'T_PLL_LOCK_HYST'=>'0',
        'gui_pll_cal_busy'=>'1',
        'RX_ENABLE' =>'1',
        'T_RX_ANALOGRESET' =>'70000',
        'T_RX_DIGITALRESET' =>'5000'
    };
$outname='alt_eth_top';
$outname_mge='alt_mge_channel';
$outname_fpll='alt_mge_core_pll';
$outname_ATX_pll='alt_mge_xcvr_atx_pll_10g';
$outname_xcvr_reset_ctrl='alt_mge_xcvr_reset_ctrl_channel';
    $ip_deploy = +{
	'output-name' => $outname ,
	'component-name' => 'alt_em10g32',
	'component-param' => $components,
    };
push(@ipdeploy_list,$ip_deploy);
#drajasek
   $ip_deploy_mge = +{
	'output-name' => $outname_mge ,
	'component-name' => 'alt_mge_phy',
	'component-param' => $components_mge,
   };
push(@ipdeploy_list,$ip_deploy_mge);

 $ip_deploy_core_pll = +{
	'output-name' => $outname_fpll ,
	'component-name' => 'altera_xcvr_fpll_s10_htile',
	'component-param' => $components_core_pll,
   };
push(@ipdeploy_list,$ip_deploy_core_pll);
#
 $ip_deploy_ATX_pll = +{
	'output-name' => $outname_ATX_pll ,
	'component-name' => 'altera_xcvr_atx_pll_s10_htile',
	'component-param' => $components_ATX_pll,
   };
push(@ipdeploy_list,$ip_deploy_ATX_pll);
#
 $ip_deploy_xcvr_reset_ctrl = +{
	'output-name' => $outname_xcvr_reset_ctrl ,
	'component-name' => 'altera_xcvr_reset_control_s10',
	'component-param' => $components_xcvr_reset_ctrl,
   };
push(@ipdeploy_list,$ip_deploy_xcvr_reset_ctrl);

ITF::set_option('ip_deploy_list', 'ITF',\@ipdeploy_list);
    ITF::set_option('enable_ip_deploy', 'ITF', 1);

    ITF::itf_run_system_command("cp ip_files/* .");

    push(@qsys_ip_list, "${outname}.ip");
    push(@qsys_ip_list, "${outname_mge}.ip");
    push(@qsys_ip_list, "${outname_fpll}.ip");
    push(@qsys_ip_list, "${outname_ATX_pll}.ip");
    push(@qsys_ip_list, "${outname_xcvr_reset_ctrl}.ip");
    ##decoderIP
    push(@qsys_ip_list, "address_decoder_channel_mac.ip");
    push(@qsys_ip_list, "address_decoder_channel_master.ip");
    push(@qsys_ip_list, "address_decoder_channel_phy.ip");
    push(@qsys_ip_list, "address_decoder_channel_csr_clk.ip");
    push(@qsys_ip_list, "address_decoder_channel_xcvr_rcfg.ip");
    push(@qsys_ip_list, "address_decoder_channel.qsys");
    ITF::set_option('qsys_ip_list', 'ITF', \@qsys_ip_list);  
}
if ($llvar eq 'MGE') { 
      print "\n entering MGE IP-deploy\n";
    $components = +{
	'DEVICE_FAMILY' =>'Stratix 10',
        'ENABLE_ED_FILESET_SIM'=>'1',
        'ENABLE_ED_FILESET_SYNTHESIS'=>'0',
        'SELECT_SUPPORTED_VARIANT'=>'6',
        'SELECT_NUMBER_OF_CHANNEL'=>'2',
        'ENABLE_1G10G_MAC'=>'3',
        'ENABLE_10GBASER_REG_MODE'=>'0',
        'ENABLE_TIMESTAMPING'=>'0',
        'ENABLE_PTP_1STEP'=>'0',
        'INSERT_ST_ADAPTOR'=>'0',
        'INSERT_CSR_ADAPTOR'=>'0',
        'INSERT_XGMII_ADAPTOR'=>'0'
    };
   $components_mge = +{
        'SPEED_VARIANT'=>'1',
        'DEFAULT_MODE'=>'1',
        'EXT_PHY_MGBASET'=>'1',
        'ENABLE_SGMII'=>'0',
        'EXT_PHY_NBASET'=>'0'
    };
    $components_core_pll = +{
        'base_device' => 'cr2v0',
        'set_primary_use' => '0',
        'set_output_clock_frequency' => '156.25',
        'set_auto_reference_clock_frequency'=>'125.0'
    };
   $components_xcvr_reset_ctrl = +{
    };	  

   $components_altera_jtag_avalon_master = +{
	   'PLLS' => '2',
	   'SYS_CLK_IN_MHZ' => '125',
	   'T_TX_ANALOGRESET' => '70000',
	   'T_TX_DIGITALRESET' => '70000'
    };	  
   $components_xcvr_fpll =+{
	'enable_mcgb'=>'1',
	'base_device'=>'cr2v0',
	'set_bw_sel'=>'low',
	'set_output_clock_frequency'=>'625.0',
	'set_auto_reference_clock_frequency'=>'125.0',
	'enable_hfreq_clk'=>'1'
   };
   $components_ATX_pll =+{
	'enable_mcgb'=>'1',
	'base_device'=>'cr2v0',
	'bw_sel'=>'medium',
	'set_output_clock_frequency'=>'1562.5',
	'set_auto_reference_clock_frequency'=>'125.0',
	'enable_hfreq_clk'=>'1'
    };	   
   $outname='alt_em10g32_0';
   $outname_mge='alt_mge_phy_0';
   $outname_fpll='xcvr_fpll_s10_htile_0';
   $outname_xcvr_fpll='xcvr_fpll_s10_htile_0';
   $outname_ATX_pll='xcvr_atx_pll_s10_htile_0';
   $outname_xcvr_reset_ctrl='xcvr_reset_control_s10_0';
   $outname_jtag_avalon_master='master_0';


    $ip_deploy = +{
	'output-name' => $outname ,
	'component-name' => 'alt_em10g32',
	'component-param' => $components,
    };
    push(@ipdeploy_list,$ip_deploy);
    $ip_deploy_mge = +{
	'output-name' => $outname_mge ,
	'component-name' => 'alt_mge_phy',
	'component-param' => $components_mge,
    };
    push(@ipdeploy_list,$ip_deploy_mge);
 $ip_deploy_core_pll = +{
	'output-name' => $outname_fpll ,
	'component-name' => 'altera_xcvr_fpll_s10_htile',
	'component-param' => $components_core_pll,
   };
push(@ipdeploy_list,$ip_deploy_core_pll);
 $ip_deploy_xcvr_fpll = +{
	'output-name' => $outname_xcvr_fpll ,
	'component-name' => 'altera_xcvr_fpll_s10_htile',
	'component-param' => $components_xcvr_fpll,
   };
push(@ipdeploy_list,$ip_deploy_xcvr_fpll);

 $ip_deploy_ATX_pll = +{
	'output-name' => $outname_ATX_pll ,
	'component-name' => 'altera_xcvr_atx_pll_s10_htile',
	'component-param' => $components_ATX_pll,
   };
push(@ipdeploy_list,$ip_deploy_ATX_pll);

 $ip_deploy_xcvr_reset_ctrl = +{
	'output-name' => $outname_xcvr_reset_ctrl ,
	'component-name' => 'altera_xcvr_reset_control_s10',
	'component-param' => $components_xcvr_reset_ctrl,
   };
push(@ipdeploy_list,$ip_deploy_xcvr_reset_ctrl);
 $ip_deploy_jtag_avalon_master = +{
	'output-name' => $outname_jtag_avalon_master ,
	'component-name' => 'altera_jtag_avalon_master',
	'component-param' => $components_altera_jtag_avalon_master,
   };
push(@ipdeploy_list,$ip_deploy_jtag_avalon_master);

ITF::set_option('ip_deploy_list', 'ITF',\@ipdeploy_list);
    ITF::set_option('enable_ip_deploy', 'ITF', 1);
      print "drajasek enabled IP deploy\n";

    ITF::itf_run_system_command("cp ip_files_MGE_S10/* .");

    push(@qsys_ip_list, "${outname}.ip");
    push(@qsys_ip_list, "${outname_mge}.ip");
    push(@qsys_ip_list, "${outname_fpll}.ip");
    push(@qsys_ip_list, "${outname_ATX_pll}.ip");
    push(@qsys_ip_list, "${outname_xcvr_reset_ctrl}.ip");
    push(@qsys_ip_list, "${outname_jtag_avalon_master}.ip");
    push(@qsys_ip_list, "${outname_xcvr_fpll}.ip");
    ##decoderIP
    #push(@qsys_ip_list, "address_decoder_channel_mac.ip");
    #push(@qsys_ip_list, "address_decoder_channel_master.ip");
    #push(@qsys_ip_list, "address_decoder_channel_phy.ip");
    #push(@qsys_ip_list, "address_decoder_channel_csr_clk.ip");
    #push(@qsys_ip_list, "address_decoder_channel_xcvr_rcfg.ip");
    #push(@qsys_ip_list, "address_decoder_channel.qsys");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_channel_0_1_traffic_controller.ip");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_channel_0_mac.ip");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_channel_0_native_phy_rcfg.ip");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_channel_0_phy.ip");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_channel_1_mac.ip");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_channel_1_native_phy_rcfg.ip");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_channel_1_phy.ip");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_csr_clk.ip");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_jtag_if.ip");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_mac_clk.ip");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_master_channel.ip");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_mge_reconfig.ip");
    push(@qsys_ip_list, "alt_mge_rd_avmm_mux_xcvr_rcfg_csr_clk.ip");
    push(@qsys_ip_list, "alt_mge_rd_avmm_mux_xcvr_rcfg_mge_rcfg_master.ip");
    push(@qsys_ip_list, "alt_mge_rd_avmm_mux_xcvr_rcfg_user_rcfg_master.ip");
    push(@qsys_ip_list, "alt_mge_rd_avmm_mux_xcvr_rcfg_xcvr_rcfg_slave.ip");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch.qsys");
    push(@qsys_ip_list, "alt_mge_rd_avmm_mux_xcvr_rcfg.qsys");
    ITF::set_option('qsys_ip_list', 'ITF', \@qsys_ip_list);  
      print "drajasek added to qsys ip list\n";
}

if ($llvar eq 'BASERS10') { 
      print "\n entering BASERS10 IP-deploy\n";
    $components = +{
	'DEVICE_FAMILY' =>'Stratix 10',
        'ENABLE_ED_FILESET_SIM'=>'1',
        'ENABLE_ED_FILESET_SIM'=>'1',
        'ENABLE_ED_FILESET_SYNTHESIS'=>'0',
        #'SELECT_SUPPORTED_VARIANT'=>'6',
        'SELECT_NUMBER_OF_CHANNEL'=>'2',
        'ENABLE_1G10G_MAC'=>'0',
        'DATAPATH_OPTION'=>'3',
        'ENABLE_10GBASER_REG_MODE'=>'0',
        'ENABLE_SUPP_ADDR'=>'1',
        'INSTANTIATE_STATISTICS'=>'1',
        'REGISTER_BASED_STATISTICS'=>'0',
        'ENABLE_TXRX_DATAPATH'=>'1',
        'ENABLE_TIMESTAMPING'=>'0',
        'ENABLE_PTP_1STEP'=>'0',
        'INSERT_ST_ADAPTOR'=>'0',
        'INSERT_CSR_ADAPTOR'=>'1',
        'INSERT_XGMII_ADAPTOR'=>'1'
    };
   $components_xcvr_reset_ctrl = +{
    };	  

   $components_ATX_pll =+{
	'enable_mcgb'=>'0',
	'base_device'=>'ND5_45',
	'bw_sel'=>'low',
        'refclk_cnt'=>'1',
        'refclk_index'=>'0',
        'usr_analog_voltage'=>'1_0V',
        'primary_pll_buffer'=>'GX clock output buffer',
        'enable_GXT_clock_source'=>'disabled',
	'set_output_clock_frequency'=>'5156.25',
	'set_auto_reference_clock_frequency'=>'644.53125',
        'enable_mcgb'=>'0',
	'enable_hfreq_clk'=>'0',
        'mcgb_aux_clkin_cnt'=>'0',
        'enable_pld_mcgb_cal_busy_port'=>'0',
        'pma_width'=>'64',
        'enable_mcgb_pcie_clksw'=>'0',
        'mcgb_div'=>'1',
        'set_fref_clock_frequency'=>'156.25',
        'set_fref_clock_frequency'=>'200'
    };	   
   $outname='altera_eth_10g_mac';
   $outname_ATX_pll='altera_xcvr_atx_pll_ip';
   $outname_xcvr_reset_ctrl='reset_control';


    $ip_deploy = +{
	'output-name' => $outname ,
	'component-name' => 'alt_em10g32',
	'component-param' => $components,
    };
    push(@ipdeploy_list,$ip_deploy);

 $ip_deploy_ATX_pll = +{
	'output-name' => $outname_ATX_pll ,
	'component-name' => 'altera_xcvr_atx_pll_s10_htile',
	'component-param' => $components_ATX_pll,
   };
push(@ipdeploy_list,$ip_deploy_ATX_pll);

 $ip_deploy_xcvr_reset_ctrl = +{
	'output-name' => $outname_xcvr_reset_ctrl ,
	'component-name' => 'altera_xcvr_reset_control_s10',
	'component-param' => $components_xcvr_reset_ctrl,
   };
push(@ipdeploy_list,$ip_deploy_xcvr_reset_ctrl);

ITF::set_option('ip_deploy_list', 'ITF',\@ipdeploy_list);
    ITF::set_option('enable_ip_deploy', 'ITF', 1);
      print "enabled IP deploy\n";

    ITF::itf_run_system_command("cp -rf ip_files_BASER_S10/* .");

    push(@qsys_ip_list, "${outname}.ip");
    push(@qsys_ip_list, "${outname_ATX_pll}.ip");
    push(@qsys_ip_list, "${outname_xcvr_reset_ctrl}.ip");
    push(@qsys_ip_list, "altera_eth_10gbaser_phy.ip");
    push(@qsys_ip_list, "address_decode_clk_csr.ip");
    push(@qsys_ip_list, "address_decode_merlin_master_translator_0.ip");
    push(@qsys_ip_list, "address_decode_mm_to_mac.ip");
    push(@qsys_ip_list, "address_decode_mm_to_phy.ip");
    push(@qsys_ip_list, "address_decode_rx_xcvr_half_clk.ip");
    push(@qsys_ip_list, "address_decode.qsys");
    ITF::set_option('qsys_ip_list', 'ITF', \@qsys_ip_list);
  
}
if ($llvar eq 'MGBASET') { 
   print "\n This is MGBASET IP-Deploy \n";	

 #MAC
 $components = +{
   'ENABLE_1G10G_MAC'=>'4',
   'DATAPATH_OPTION'=>'3',
   'ENABLE_MEM_ECC'=>'0',
   'ENABLE_SUPP_ADDR'=>'1',
   'INSTANTIATE_STATISTICS'=>'1',
   'REGISTER_BASED_STATISTICS'=>'0',
  # 'ENABLE_TXRX_DATAPATH'=>'0',
   'INSERT_XGMII_ADAPTOR'=>'1',
   'INSERT_CSR_ADAPTOR'=>'0',
   'INSERT_ST_ADAPTOR'=>'1',
   'USE_ASYNC_ADAPTOR'=>'0'
 };

#PHY
 $components_mge = +{
   'SPEED_VARIANT'=>'4',
   'ENABLE_SGMII'=>'0',
   'EXT_PHY_MGBASET'=>'1',
   'EXT_PHY_NBASET'=>'0',
   'PHY_IDENTIFIER'=>'0',
   'ANALOG_VOLTAGE'=>'1_0V',
   'REFCLK_FREQ_BASER'=>'0',
   'TX_PMA_CLK_DIV_1G'=>'1',
   'TX_PMA_CLK_DIV_2P5G'=>'1',
   'XCVR_RCFG_JTAG_ENABLE'=>'0',
   'XCVR_SET_CAPABILITY_REG_ENABLE'=>'0',
   'XCVR_SET_CSR_SOFT_LOGIC_ENABLE'=>'0',
   'XCVR_SET_PRBS_SOFT_LOGIC_ENABLE'=>'0'
 };	 

#Transceiver reset controlelr
 $components_xcvr_reset_ctrl = +{
	 'device'=>'ND5_45_PART1',
	 'PLLS'=>'3',
         'SYS_CLK_IN_MHZ'=>'125',
         'T_TX_ANALOGRESET'=>'70000',
         'T_TX_DIGITALRESET'=>'70000',
         'T_RX_ANALOGRESET'=>'70000',
         'T_RX_DIGITALRESET'=>'5000',
         'l_terminate_pll'=>'1',
         'l_terminate_tx'=>'0',
         'l_terminate_rx'=>'0',
         'l_pll_select_split'=>'0',
         'l_pll_select_width'=>'2',
         'l_pll_select_base'=>'2'
 }; 

#ATX PLL:10G
 $components_ATX_pll_10g =+{
	'device'=>'1SG085HN1F43E1VG', 
        'bw_sel'=>'low',
        'base_device'=>'ND5_45',
        'device_die_types'=>'HSSI_CRETE2E,MAIN_ND2',
        'device_die_revisions'=>'HSSI_CRETE2E_REVA,MAIN_ND2_REVA',
        'set_output_clock_frequency'=>'5156.25',
        'set_auto_reference_clock_frequency'=>'644.53125',
        'enable_mcgb'=>'0'
 };
#ATX PLL: 2.5G
 $components_ATX_pll_2p5g =+{
	'device'=>'1SG085HN1F43E1VG', 
        'bw_sel'=>'medium',
        'base_device'=>'ND5_45',
        'set_output_clock_frequency'=>'1562.5',
        'set_auto_reference_clock_frequency'=>'125.0',
        'enable_mcgb'=>'1',
        'enable_hfreq'=>'1',
        'enable_hfreq_clk'=>'1'
 };	 
#fPLL
 $components_xcvr_fpll =+{
	'device'=>'1SG280HU3F503VG', 
        'set_bw_sel'=>'low',
        'base_device'=>'cr2v0',
	'device_die_revisions'=>'HSSI_CRETE2P_REVA,MAIN_ND5_REVA',
        'set_output_clock_frequency'=>'625.0',
	'output_datarate'=>'1250.0',
	'output_clock_frequency'=>'625.0',
        'set_auto_reference_clock_frequency'=>'125.0',
        'enable_mcgb'=>'1',
        'enable_hfreq_clk'=>'1',
	'deviceSpeedGrade'=>'3'
 };	 

 $outname='alt_mgbaset_mac';
 $outname_mge='s10_design';
 $outname_xcvr_reset_ctrl='alt_mge_xcvr_reset_ctrl_channel';
 $outname_ATX_pll_10g='alt_mge_xcvr_atx_pll_10g';
 $outname_ATX_pll_2p5g='alt_mge_xcvr_atx_pll_2p5g';
 $outname_xcvr_fpll='alt_mge_xcvr_fpll_1g';


    $ip_deploy = +{
	'output-name' => $outname ,
	'component-name' => 'alt_em10g32',
	'component-param' => $components,
    };
    push(@ipdeploy_list,$ip_deploy);
    $ip_deploy_mge = +{
	'output-name' => $outname_mge ,
	'component-name' => 'alt_mge_phy',
	'component-param' => $components_mge,
    };
    push(@ipdeploy_list,$ip_deploy_mge);
    $ip_deploy_xcvr_reset_ctrl = +{
           'output-name' => $outname_xcvr_reset_ctrl ,
           'component-name' => 'altera_xcvr_reset_control_s10',
           'component-param' => $components_xcvr_reset_ctrl,
      };
    push(@ipdeploy_list,$ip_deploy_xcvr_reset_ctrl);
     $ip_deploy_xcvr_fpll = +{
            'output-name' => $outname_xcvr_fpll ,
            'component-name' => 'altera_xcvr_fpll_s10_htile',
            'component-param' => $components_xcvr_fpll,
       };
    push(@ipdeploy_list,$ip_deploy_xcvr_fpll);
     $ip_deploy_ATX_pll_10g = +{
            'output-name' => $outname_ATX_pll_10g ,
            'component-name' => 'altera_xcvr_atx_pll_s10_htile',
            'component-param' => $components_ATX_pll_10g,
       };
    push(@ipdeploy_list,$ip_deploy_ATX_pll_10g);
     $ip_deploy_ATX_pll_2p5g = +{
            'output-name' => $outname_ATX_pll_2p5g ,
            'component-name' => 'altera_xcvr_atx_pll_s10_htile',
            'component-param' => $components_ATX_pll_2p5g,
       };
    push(@ipdeploy_list,$ip_deploy_ATX_pll_2p5g);


    ITF::set_option('ip_deploy_list', 'ITF',\@ipdeploy_list);
    ITF::set_option('enable_ip_deploy', 'ITF', 1);
    print "drajasek enabled IP deploy\n";
    ITF::itf_run_system_command("cp ip_files_mgbaset_s10/* .");
    push(@qsys_ip_list, "${outname}.ip");
    push(@qsys_ip_list, "${outname_mge}.ip");
    push(@qsys_ip_list, "${outname_ATX_pll_10g}.ip");
    push(@qsys_ip_list, "${outname_ATX_pll_2p5g}.ip");
    push(@qsys_ip_list, "${outname_xcvr_reset_ctrl}.ip");
    push(@qsys_ip_list, "${outname_xcvr_fpll}.ip");



    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_channel_0_1_traffic_controller.ip");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_channel_0_mac.ip");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_channel_0_native_phy_rcfg.ip");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_channel_0_phy.ip");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_channel_1_mac.ip");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_channel_1_native_phy_rcfg.ip");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_channel_1_phy.ip");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_csr_clk.ip");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_jtag_if.ip");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_mac_clk.ip");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_master_channel.ip");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_mge_reconfig.ip");
    push(@qsys_ip_list, "alt_mge_rd_avmm_mux_xcvr_rcfg_csr_clk.ip");
    push(@qsys_ip_list, "alt_mge_rd_avmm_mux_xcvr_rcfg_mge_rcfg_master.ip");
    push(@qsys_ip_list, "alt_mge_rd_avmm_mux_xcvr_rcfg_user_rcfg_master.ip");
    push(@qsys_ip_list, "alt_mge_rd_avmm_mux_xcvr_rcfg_xcvr_rcfg_slave.ip");

    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch.qsys");
    push(@qsys_ip_list, "alt_mge_rd_avmm_mux_xcvr_rcfg.qsys");
    ITF::set_option('qsys_ip_list', 'ITF', \@qsys_ip_list);  
    print "drajasek added to qsys ip list\n";


 }


if ($llvar eq 'MGBASETA10') { 
    print "\n This is MGBASETA10 IP-Deploy \n";	

    ITF::itf_run_system_command("cp ip_files_mgbaset_a10/* .");
    

    push(@qsys_ip_list, "alt_mgbaset_mac.qsys");
    push(@qsys_ip_list, "alt_mgbaset_phy.qsys");
    push(@qsys_ip_list, "alt_mge_core_pll.qsys");
    push(@qsys_ip_list, "alt_mge_xcvr_atx_pll_10g.qsys");
    push(@qsys_ip_list, "alt_mge_xcvr_atx_pll_2p5g.qsys");
    push(@qsys_ip_list, "alt_mge_xcvr_fpll_1g.qsys");
    push(@qsys_ip_list, "alt_mge_xcvr_reset_ctrl_channel.qsys");
    push(@qsys_ip_list, "alt_mge_xcvr_reset_ctrl_txpll.qsys");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch.qsys");
    push(@qsys_ip_list, "alt_mge_rd_avmm_mux_xcvr_rcfg.qsys");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_channel_0_1_traffic_controller.ip");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_channel_0_mac.ip");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_channel_0_native_phy_rcfg.ip");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_channel_0_phy.ip");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_channel_1_mac.ip");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_channel_1_native_phy_rcfg.ip");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_channel_1_phy.ip");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_csr_clk.ip");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_jtag_if.ip");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_mac_clk.ip");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_master_channel.ip");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_mge_reconfig.ip");
    push(@qsys_ip_list, "alt_mge_rd_avmm_mux_xcvr_rcfg_csr_clk.ip");
    push(@qsys_ip_list, "alt_mge_rd_avmm_mux_xcvr_rcfg_mge_rcfg_master.ip");
    push(@qsys_ip_list, "alt_mge_rd_avmm_mux_xcvr_rcfg_user_rcfg_master.ip");
    push(@qsys_ip_list, "alt_mge_rd_avmm_mux_xcvr_rcfg_xcvr_rcfg_slave.ip");

    ITF::set_option('qsys_ip_list', 'ITF', \@qsys_ip_list);  

 }

if ($llvar eq 'BASERA10') { 
      print "\n entering BASERA10 IP-deploy\n";
    ITF::itf_run_system_command("cp -rf ip_files_BASER_S10_arria/* .");
    push(@qsys_ip_list, "address_decode_clk_csr.ip");
    push(@qsys_ip_list, "address_decode_merlin_master_translator_0.ip");
    push(@qsys_ip_list, "address_decode_merlin_slave_translator_0.ip");
    push(@qsys_ip_list, "address_decode_merlin_slave_translator_1.ip");
    push(@qsys_ip_list, "address_decode.qsys");
    push(@qsys_ip_list, "low_latency_mac.qsys");
    push(@qsys_ip_list, "low_latency_baser.qsys");
    push(@qsys_ip_list, "altera_xcvr_atx_pll_ip.qsys");
    push(@qsys_ip_list, "altera_fpll_ip.qsys");
    push(@qsys_ip_list, "reset_control.qsys");
    ITF::set_option('qsys_ip_list', 'ITF', \@qsys_ip_list);
  
}

if ($llvar eq 'MGE_A10') { 
      print "\n entering MGE_A10 IP-deploy\n";
    ITF::itf_run_system_command("cp -rf ip_files_MGE_A10/* .");
     push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_channel_0_1_traffic_controller.ip");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_channel_0_mac.ip");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_channel_0_native_phy_rcfg.ip");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_channel_0_phy.ip");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_channel_1_mac.ip");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_channel_1_native_phy_rcfg.ip");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_channel_1_phy.ip");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_csr_clk.ip");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_jtag_if.ip");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_mac_clk.ip");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_master_channel.ip");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch_mge_reconfig.ip");
    push(@qsys_ip_list, "alt_mge_rd_avmm_mux_xcvr_rcfg_csr_clk.ip");
    push(@qsys_ip_list, "alt_mge_rd_avmm_mux_xcvr_rcfg_mge_rcfg_master.ip");
    push(@qsys_ip_list, "alt_mge_rd_avmm_mux_xcvr_rcfg_user_rcfg_master.ip");
    push(@qsys_ip_list, "alt_mge_rd_avmm_mux_xcvr_rcfg_xcvr_rcfg_slave.ip");
    push(@qsys_ip_list, "alt_mge_1g_2p5g_phy.qsys");
    push(@qsys_ip_list, "alt_mge_mac.qsys");
    push(@qsys_ip_list, "alt_mge_core_pll.qsys");
    push(@qsys_ip_list, "alt_mge_xcvr_atx_pll_2p5g.qsys");
    push(@qsys_ip_list, "alt_mge_xcvr_fpll_1g.qsys");
    push(@qsys_ip_list, "alt_mge_xcvr_reset_ctrl_txpll.qsys");
    push(@qsys_ip_list, "alt_mge_xcvr_reset_ctrl_channel.qsys");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch.qsys");
    push(@qsys_ip_list, "alt_mge_rd_avmm_mux_xcvr_rcfg.qsys");
    ITF::set_option('qsys_ip_list', 'ITF', \@qsys_ip_list);
  
}

if ($llvar eq 'MGE_V') { 
      print "\n entering MGE_V IP-deploy\n";
    ITF::itf_run_system_command("cp -rf ip_files_MGE_V/* .");
    push(@qsys_ip_list, "alt_mge_1g_2p5g_phy.qsys");
    push(@qsys_ip_list, "alt_mge_mac.qsys");
    push(@qsys_ip_list, "alt_mge_core_pll.qsys");
    push(@qsys_ip_list, "alt_mge_xcvr_cmu_pll_2p5g.qsys");
    push(@qsys_ip_list, "alt_mge_xcvr_cmu_pll_1g.qsys");
    push(@qsys_ip_list, "alt_mge_xcvr_reset_ctrl_txpll.qsys");
    push(@qsys_ip_list, "alt_mge_xcvr_reset_ctrl_channel.qsys");
    push(@qsys_ip_list, "alt_mge_rd_addrdec_mch.qsys");
    push(@qsys_ip_list, "alt_mge_xcvr_rcfg.qsys");
    ITF::set_option('qsys_ip_list', 'ITF', \@qsys_ip_list);
  
}

if ($llvar eq 'NF10G') { 
      print "\n entering NF10G IP-deploy\n";
    ITF::itf_run_system_command("cp -rf ip_files_NF_10G/* .");
    push(@qsys_ip_list, "altera_eth_10g_mac_nf_phy_alt_em10g32_0.ip");
    push(@qsys_ip_list, "altera_eth_10g_mac_nf_phy_alt_em10g32_1.ip");
    push(@qsys_ip_list, "altera_eth_10g_mac_nf_phy_master_0.ip");
    push(@qsys_ip_list, "altera_eth_10g_mac_nf_phy_merlin_master_translator_0.ip");
    push(@qsys_ip_list, "altera_eth_10g_mac_nf_phy_mm_clk.ip");
    push(@qsys_ip_list, "altera_eth_10g_mac_nf_phy_pll_0.ip");
    push(@qsys_ip_list, "altera_eth_10g_mac_nf_phy_pll_80.ip");
    push(@qsys_ip_list, "altera_eth_10g_mac_nf_phy_ref_clk_10g.ip");
    push(@qsys_ip_list, "altera_eth_10g_mac_nf_phy_ref_clk_1g.ip");
    push(@qsys_ip_list, "altera_eth_10g_mac_nf_phy_reset_controller_0.ip");
    push(@qsys_ip_list, "altera_eth_10g_mac_nf_phy_reset_controller_1.ip");
    push(@qsys_ip_list, "altera_eth_10g_mac_nf_phy_reset_controller_mac_rx_0.ip");
    push(@qsys_ip_list, "altera_eth_10g_mac_nf_phy_reset_controller_mac_rx_1.ip");
    push(@qsys_ip_list, "altera_eth_10g_mac_nf_phy_reset_controller_mac_tx_0.ip");
    push(@qsys_ip_list, "altera_eth_10g_mac_nf_phy_reset_controller_mac_tx_1.ip");
    push(@qsys_ip_list, "altera_eth_10g_mac_nf_phy_xcvr_10gkr_a10_0.ip");
    push(@qsys_ip_list, "altera_eth_10g_mac_nf_phy_xcvr_10gkr_a10_1.ip");
    push(@qsys_ip_list, "altera_eth_10g_mac_nf_phy_xcvr_atx_pll_a10_0.ip");
    push(@qsys_ip_list, "altera_eth_10g_mac_nf_phy_xcvr_fpll_a10_0.ip");
    push(@qsys_ip_list, "altera_eth_10g_mac_nf_phy_xcvr_reset_control_0.ip");
    push(@qsys_ip_list, "altera_eth_10g_mac_nf_phy_xcvr_reset_control_1.ip");
    push(@qsys_ip_list, "altera_eth_10g_mac_nf_phy.qsys");
    ITF::set_option('qsys_ip_list', 'ITF', \@qsys_ip_list);
}

if ($llvar eq 'NF1G') { 
      print "\n entering NF1G IP-deploy\n";
    ITF::itf_run_system_command("cp -rf ip_files_NF_1G/* .");
    push(@qsys_ip_list, "altera_eth_10g_mac_1g_nf_phy_alt_em10g32_0.ip");
    push(@qsys_ip_list, "altera_eth_10g_mac_1g_nf_phy_alt_em10g32_1.ip");
    push(@qsys_ip_list, "altera_eth_10g_mac_1g_nf_phy_master_0.ip");
    push(@qsys_ip_list, "altera_eth_10g_mac_1g_nf_phy_merlin_master_translator_0.ip");
    push(@qsys_ip_list, "altera_eth_10g_mac_1g_nf_phy_mm_clk.ip");
    push(@qsys_ip_list, "altera_eth_10g_mac_1g_nf_phy_pll_0.ip");
    push(@qsys_ip_list, "altera_eth_10g_mac_1g_nf_phy_pll_80.ip");
    push(@qsys_ip_list, "altera_eth_10g_mac_1g_nf_phy_ref_clk_10g.ip");
    push(@qsys_ip_list, "altera_eth_10g_mac_1g_nf_phy_ref_clk_1g.ip");
    push(@qsys_ip_list, "altera_eth_10g_mac_1g_nf_phy_reset_controller_0.ip");
    push(@qsys_ip_list, "altera_eth_10g_mac_1g_nf_phy_reset_controller_1.ip");
    push(@qsys_ip_list, "altera_eth_10g_mac_1g_nf_phy_reset_controller_mac_rx_0.ip");
    push(@qsys_ip_list, "altera_eth_10g_mac_1g_nf_phy_reset_controller_mac_rx_1.ip");
    push(@qsys_ip_list, "altera_eth_10g_mac_1g_nf_phy_reset_controller_mac_tx_0.ip");
    push(@qsys_ip_list, "altera_eth_10g_mac_1g_nf_phy_reset_controller_mac_tx_1.ip");
    push(@qsys_ip_list, "altera_eth_10g_mac_1g_nf_phy_xcvr_10gkr_a10_0.ip");
    push(@qsys_ip_list, "altera_eth_10g_mac_1g_nf_phy_xcvr_10gkr_a10_1.ip");
    push(@qsys_ip_list, "altera_eth_10g_mac_1g_nf_phy_xcvr_atx_pll_a10_0.ip");
    push(@qsys_ip_list, "altera_eth_10g_mac_1g_nf_phy_xcvr_fpll_a10_0.ip");
    push(@qsys_ip_list, "altera_eth_10g_mac_1g_nf_phy_xcvr_reset_control_0.ip");
    push(@qsys_ip_list, "altera_eth_10g_mac_1g_nf_phy_xcvr_reset_control_1.ip");
    push(@qsys_ip_list, "altera_eth_10g_mac_1g_nf_phy.qsys");
    ITF::set_option('qsys_ip_list', 'ITF', \@qsys_ip_list);
}  
}   
    #FIXME after ANCHNA RANDOMIZE. featutr work 
    my $var=ITF::get_option("VARIANT_NAME","variant");    
    my $num_phylane  =			ITF::get_option("num_phylane",$var);
    $an_chan0 =  $num_phylane - 1;
    ITF::set_option("an_chan0",'update_qsys',$an_chan0);
    #my $mapport ;
    my $sequence=ITF::get_option('sequence','ITF');
    my $topology = ITF::get_option("topology", "ITF") || 17;
    my $status_clk_mhz  = 100;
    my $lf_time;
     print "sequence is cl/funv  $sequence";
     print "topology is  $topology";
    if( $topology == 1 || $topology == 4 || $topology == 7 || $topology == 8 || $topology == 12 || $topology == 13 || $topology == 16 || $topology == 17 || $topology == 19 || $topology == 20 || $topology == 21 || $topology == 22 || $topology == 23 || $topology == 24 || $topology == 27 || $topology == 28 ) {$lf_time = 505};
    if($topology == 10 || $topology == 15 || $topology == 25 || $topology == 26 || $topology == 14 || $topology == 29 || $topology == 30 || $topology == 31 || $topology == 5 || $topology == 32 || $topology == 33 || $topology == 34 || $topology == 18) {$lf_time = 3150};
    if( $topology == 2 || $topology == 11 || $topology == 3 ) {$lf_time = 12350};
    if( $topology == 35 ||  $topology == 36 ||  $topology == 37 ||  $topology == 38 ||  $topology == 39 ||  $topology == 40 ) {$lf_time = 10};

     print "LF timer  $lf_time";

    ITF::pass_files_to_children("param_tb.csv","familiy_setting.v", "define_fastsim.v","top.*", "./top/*" ,"itf_qsys_*");
    ITF::pass_files_to_children("top_level_attributes.json");
    ITF::pass_files_to_children("top_level_attributes_2.json");
    ITF::pass_files_to_children(".*hex");

    } #for end for ip_num 
   }   
 
 
ITF::register_function('qsys', 'update_variant', \&update_qsys);
    ITF::set_option('enable_ip_deploy', 'ITF', 1);    #mprash2x


# set timeout to a higher timeout, just in case
sub qsys_timeout {
	    
#       	print("TIMEOUT_ALPHA: $timeout");	    
    return "1h";
}
ITF::register_user_function('qsys','get_subtest_timeout',\&qsys_timeout);

sub check_subtest_pass_simulate {
	my $daily_sanity=ITF::get_option('DS','ITF');
	my $failed = ITF::get_subtest_option('subtest_failed');
   	my $vip_en_s = ITF::get_option("vip_en", "ITF")|| "yes";
	my $vip_en;
   	if($vip_en_s eq "no")
    	{
	    $vip_en=0;
    	}
    	else
    	{	    
	$vip_en=1;
	$vip_en_s="yes";
    	}

	if( defined $failed && $failed == 1 ) {
	print("\nSANITY FAILED SIMULATE\n");
	if($daily_sanity==1){
	ITF::itf_run_system_command("sh message.sh $vip_en_s");
		}
	}
	return undef;
}

ITF::register_user_function('rtl_sim_simulate_only_vcs', 'subtest_pass_check', \&check_subtest_pass_simulate); 

sub json_placement {
	  my $cr_mode=ITF::get_option("cr_mode",'update_qsys');
	  my $an_chan0=ITF::get_option("an_chan0",'update_qsys');
	  my $anlt_val=ITF::get_option("anlt_val",'update_qsys');
      my $single_var_multi_inst=ITF::get_option("single_var_multi_inst",'update_qsys');
      my $var=ITF::get_option("VARIANT_NAME","variant");
      my $enable_an=ITF::get_option("enable_an",$var)||0; 
      my $enable_lt=ITF::get_option("enable_lt",$var)||0;
      my($project_file) = "project.ini";
      print "REG_LOCAL_ROOT_DIR_PATH is set to : $ENV{REG_LOCAL_ROOT_DIR_PATH} \n";
      $current_path=cwd;
      print "Current path is $current_path";
      print "DBG: single_var_multi_inst :$single_var_multi_inst\n";
      my $ptp_debug_acc_en = ITF::get_option("ptp_debug_acc_en", 'update_qsys');
		print "\n DBG: ptp_debug_acc_en -- 3 : $ptp_debug_acc_en\n";
      ITF::itf_run_system_command("python gdr.py $current_path $cr_mode $an_chan0 $ENV{REG_LOCAL_ROOT_DIR_PATH} $single_var_multi_inst $ptp_debug_acc_en");
      ITF::pass_files_to_children("*.v","*.sv","*.txt");
      ITF::pass_files_to_children("top_level_attributes.json");
      ITF::pass_files_to_children("top_level_attributes.json_2");
      ITF::pass_files_to_children(".*hex");     
      ITF::itf_run_system_command("cp $current_path/gdr_gen_qhip_files/dut_top.v dut_top.v");
      my $topology = ITF::get_option("topology", "ITF") || 17;
      my $json_en = ITF::get_option("json_en", "ITF");
      my $qsf_en  = ITF::get_option("qsf_en", "ITF");
      my $ptp_en = ITF::get_option("ptp_en", "ITF") || 0;
      
      if(($enable_an==1) || ($enable_lt==1)){
        $snps = 'synopsys_vip_common/vip_R-2021.03H';
        $vcsv = 'vcs/Q-2020.03-SP2-2';
      } elsif($ptp_en == 1){
        $snps = 'synopsys_vip_common/vip_R-2021.03B';
        $vcsv = 'vcs';
      } else {
        $snps = 'synopsys_vip_common/vip_Q-2020.06D';
	$vcsv = 'vcs';
      }
      #if(!defined($json_en)){
      #  if($enable_an==1 ||$enable_lt==1){
      #    $json_en = 1;
      #  } else{
      #    $json_en = 0; 
      #  }
      #}

      if(!defined($qsf_en)){
        $qsf_en = 1;       
      }
      print "topology is $topology \n";
      print "qtlg: json_en is $json_en, qsf_en is $qsf_en \n";
      #if($topology==5)
      # {
      #   my $file_handle = 'top_ip0/systemclk_f_100/synth/top_ip0_systemclk_f_100_t2bfu3q.sv';
      #   `sed -i '230,247 s#^#//#' $file_handle`;         ##workaround for HSD 22011135897
      #   system("cat $file_handle > ${file_handle}.copy");
      # }
      my $remap_topology;
         if($json_en == 1) {
		   print "Using base (json) placement \n";
           ITF::set_option('placement_json', 'qtlg', "eth_${topology}_placement.json");
         } else {
           if($qsf_en == 0) {
             print "Using without QSF Flow\n";
           } else {
             print "Using QSF Flow\n";
             copy("dut_top_original_template.qsf","dut_top.qsf") or die "Copy failed : $!";                  
             system("cat eth_${topology}.qsf >> dut_top.qsf");   
           }
         }

      #system("cp ../../../../../../../testbench/tb/gdr_gen_qhip_files/dut_top.v dut_top.v");
      print "Here I am in QTLG\n";
      print `pwd`;
      ITF::pass_files_to_children("./gdr_gen_qhip_files/*");
      ITF::pass_files_to_children(".*hex");     
      
      #TODO SRC AUTO WORKAROUND
      #TODO SRC AUTO WORKAROUND
      if(($ptp_en!=1)){
	  ITF::itf_print_info("Modify SRC AUTO project ini");
      	  ITF::itf_run_system_command("chmod 775 $current_path/project.ini"); #open permission
	  ITF::itf_run_system_command("echo 'tileip_enable_reset_controller=on' >> $current_path/project.ini");
          if ($topology eq "2" || $topology eq "10" || $topology eq "25_4" || $topology eq "25_10" ) {
        	`sed -i '/tileip_enable_reset_controller/a tileip_extra_bcm_attributes_json_path=top_level_attributes.json ' $project_file`;
              }
          if ($topology eq "50_1"  || $topology eq "50_10" || $topology eq "11" || $topology eq "200_2" ) {
        	`sed -i '/tileip_enable_reset_controller/a tileip_extra_bcm_attributes_json_path=top_level_attributes_2.json ' $project_file`;
              }
       	  ITF::itf_run_system_command("chmod 775 $current_path/project.ini"); #open permission
      }
      #auto-SRC
}
ITF::register_user_function('qtlg', 'run_pre_process_post_parent_update', \&json_placement);  

#TODO_GDR: TO be removed once HSD fix
#ETH9 snap30 tile workaround:hsd:1508297158
sub eth9_snap30_tiles_hack {
    print "implement eth9 tiles hack, refer to hsd:1508297158 \n";
    my ($tilesv_file) = "dut_top__tiles.v";
   `cp $tilesv_file ${tilesv_file}.eth9.original`;
   `sed -i 's#cfg_rxeqadj_locovren_attr = "serdes_ip_lane_rxeq_l0_cfg_rxeqadj_locovren_attr_0";#cfg_rxeqadj_locovren_attr = "serdes_ip_lane_rxeq_l0_cfg_rxeqadj_locovren_attr_1";#'   $tilesv_file`;
   `sed -i 's#cfg_rxeqadj_locovren_attr = "serdes_ip_lane_rxeq_l1_cfg_rxeqadj_locovren_attr_0";#cfg_rxeqadj_locovren_attr = "serdes_ip_lane_rxeq_l1_cfg_rxeqadj_locovren_attr_1";#'   $tilesv_file`;
   `sed -i 's#cfg_rxeqadj_locovren_attr = "serdes_ip_lane_rxeq_l2_cfg_rxeqadj_locovren_attr_0";#cfg_rxeqadj_locovren_attr = "serdes_ip_lane_rxeq_l2_cfg_rxeqadj_locovren_attr_1";#'   $tilesv_file`;
   `sed -i 's#cfg_rxeqadj_locovren_attr = "serdes_ip_lane_rxeq_l3_cfg_rxeqadj_locovren_attr_0";#cfg_rxeqadj_locovren_attr = "serdes_ip_lane_rxeq_l3_cfg_rxeqadj_locovren_attr_1";#'   $tilesv_file`;
   `sed -i 's#cfg_rxeqadj_yadjust_d0_bot_locovr_attr = 0;#cfg_rxeqadj_yadjust_d0_bot_locovr_attr = 406;#'   $tilesv_file`;
   `sed -i 's#cfg_rxeqadj_yadjust_d0_top_locovr_attr = 0;#cfg_rxeqadj_yadjust_d0_top_locovr_attr = 150;#'   $tilesv_file`;
   `sed -i 's#cfg_rxeqadj_yadjust_d1_bot_locovr_attr = 0;#cfg_rxeqadj_yadjust_d1_bot_locovr_attr = 406;#'   $tilesv_file`;
   `sed -i 's#cfg_rxeqadj_yadjust_d1_top_locovr_attr = 0;#cfg_rxeqadj_yadjust_d1_top_locovr_attr = 150;#'   $tilesv_file`;

}

sub rtl_post_simulate {
   
my $var=ITF::get_option("VARIANT_NAME","variant"); 
my $rsfec_val = ITF::get_option("rsfec_val", $var) ;
my $seed = ITF::get_subtest_option("variant_name");
my $sequence = ITF::get_option("sequence", "ITF");
my $topology = ITF::get_option("topology", "ITF") || 17;

print "post sim sub";


      
}

ITF::register_function('rtl_sim_simulate_only_vcs', 'run_post_process', \&rtl_post_simulate);


sub modify_syspll {
       my $site = ITF::get_option("site", "ITF") || "sc";
       my $ptp_en = ITF::get_option("ptp_en", "ITF") || 0;
       my $var=ITF::get_option("VARIANT_NAME","variant");
       my $enable_an=ITF::get_option("enable_an",$var)||0; 
       my $enable_lt=ITF::get_option("enable_lt",$var)||0;
       my $topology = ITF::get_option("topology", "ITF") || 17;
       my $anlt_val=ITF::get_option("anlt_val",'update_qsys');
       my $transtype  = ITF::get_option("transceiver_type",$var); 
       my $json_en = ITF::get_option("json_en", "ITF");

    #   if(!defined($json_en)){
    #    if($enable_an==1 ||$enable_lt==1){
    #    $json_en = 1;
    #  }
    #  else{
    #      $json_en = 0; }
    #   }

       print("SITE : $site\n");
       
        if($json_en == 1) {
           `sed -i -e 's/\`ifndef\ USE_DV_PATTERN/\`ifndef\ USE_DV_PATTERN\ \`define\ FTILE_TOP_PATH dut_top__tiles\.dut_top__tile_0/g'  dut_top__tiles.v`;
        } else {
          `sed -i -e 's/\`ifndef\ USE_DV_PATTERN/\`ifndef\ USE_DV_PATTERN\ \`define\ FTILE_TOP_PATH dut_top__tiles\.z1577a_x0_y0_n0/g'  dut_top__tiles.v`;
        }
        `sed -i -e 's/pll_1_c1_bypass_enable/pll_1_c1_bypass_disable/'  dut_top__tiles.v`;
        `sed -i -e 's/pll_1_c2_bypass_enable/pll_1_c2_bypass_disable/'  dut_top__tiles.v`;
        `sed -i -e 's/pll_1_c3_bypass_enable/pll_1_c3_bypass_disable/'  dut_top__tiles.v`;
        `sed -i -e 's/pll_slice0_1_div_ctrl_1_f_slice_bypass_en_1_attr_1/pll_slice0_1_div_ctrl_1_f_slice_bypass_en_1_attr_0/'  dut_top__tiles.v`;
        `sed -i -e 's/pll_slice2_3_div_ctrl_1_f_slice_bypass_en_0_attr_1/pll_slice2_3_div_ctrl_1_f_slice_bypass_en_0_attr_0/'  dut_top__tiles.v`;
        `sed -i -e 's/pll_slice2_3_div_ctrl_1_f_slice_bypass_en_1_attr_1/pll_slice2_3_div_ctrl_1_f_slice_bypass_en_1_attr_0/'  dut_top__tiles.v`;

         ITF::pass_files_to_children("dut_top__tiles.v");
      ITF::pass_files_to_children(".*hex");     
         ITF::itf_run_system_command("cp dut_top__tiles.v $current_path/gdr_gen_qhip_files/dut_top__tiles.v");
			
   
   #TODO SRC Auto - modify MIF file
   if($json_en == 1 ) {
      ITF::pass_files_to_children("dut_top__tiles__dut_top__tile_0.mif");
   } else {
      ITF::pass_files_to_children("dut_top__tiles__z1577a_x0_y0_n0.mif");     
      ITF::pass_files_to_children(".*hex");     
   }
         ITF::pass_files_to_children("top_level_attributes.json");
         ITF::pass_files_to_children("top_level_attributes.json_2");
      ITF::pass_files_to_children(".*hex");     
         print "Here I am modify_syspll \n";
         print `pwd`;
}
ITF::register_user_function('qtlg', 'run_post_process', \&modify_syspll); ##Workaround for syspll issue  HSD:14011529180


1;
