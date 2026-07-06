#!/usr/bin/env perl

###########################################################
# These give you extra warnings/errors. Do not remove them
###########################################################
use strict;
use warnings;

use RegTest;
use Data::Dumper;
use TestUtils::XML;
use TestUtilsSystem::Messages::Standard;
use Carp;
use SetEnv;
use Readonly;
use Switch;
use Cwd;

use Data::Dumper;

use itf_common;

###########################################
##----- Setup Environment Variables -----##
###########################################
&SetEnv::setup_env();



##################################
##-----Variable Declaration-----##
##################################

# TOP Module
my $top_module               = "-top top_tb";

# VCS Compile command
#my $compile_cmd              = "+v2k -full64 -ntb_opts uvm -timescale=1ns/1ps -debug_pp -debug_access+all";

my $compile_cmd              = " -ntb_opts uvm -full64 -override_timescale=1ps/1fs ";

# Compile Log
my $compile_log              = "-l compile.log";

# Simulation Log
my $simulation_log           = "-l sim.log";

# Seed range
my $seed_range               = 100000;

# Max UVM Error
my $max_error                = ITF::get_option("max_error", 10);

# Maximum transaction count  
my $trans_count              = ITF::get_option("trans_count") || 10;

# Pass patterns
# my @pass_patterns            = ("UVM_FATAL :    0", "UVM_ERROR :    0", "UVM_WARNING :    0", "../simv up to date");
# my @error_patterns            = ("UVM_FATAL :    [^0]", "UVM_ERROR :    [^0]");
my @my_pass_patterns = ( "UVM_FATAL :    0", "UVM_ERROR :    0" );
ITF::set_option('sim_log_passing_patterns_arr_ref', 'simulation', \@my_pass_patterns);
ITF::set_option("use_all_passing_patterns", "simulation", 1);

# Enable Coverage
my $cov_en                   = ITF::get_option("cov_en"       , "ITF") || "0";

# Enable DUMP
my $dump_on                  = ITF::get_option("dump_on"      , "ITF") || "0";
my $fsdb_on                  = ITF::get_option("fsdb_on"      , "ITF") || "0";

# UVM Verbosity
my $uvm_verbosity            = ITF::get_option("uvm_verbosity", "ITF") || "UVM_LOW";

# Makefile Generation Config
my $makefile_configs         = ITF::get_option("makefile_cfgs", "ITF") || "config-3";

# # Testname
# my $testname                 = ITF::get_option("testname"     , "ITF") || "mux_traffic_test";

# # DUT option
# my $dut                      = ITF::get_option('dut'          , "ITF") || "no_dut";

# User Defined Options
my $user_defined_options     = " ";

my $user_def_comp_opt        = "";
# UVM options
my $uvm_options              = " ";

# Compile options
my $compile_opts             = " ";

# Simulation options
my $sim_opts                 = " ";

# Simulation command
my $simulation_cmd           = " ";

# TB Files
my $tb_flists                = " ";

# RTL Files
my $rtl_flists                = " ";

# Defines
my $defines                  = " ";
my $debug_def                  = " ";


my $snps;
my $vcsv;

####################################################################
##------------------------- SUB ROUTINES -------------------------##
####################################################################

## remove synthesis if not specified in cmdline

sub modify_spd{
    my $topology = "sm_1g2p5g_8bit_d2p5g"; #ITF::get_option("topology", "ITF") || 1;
    my $ptp_en = ITF::get_option("ptp_en", "ITF") || 0;
    my $plaintext = 1;

	 $snps = 'synopsys_vip_common/vip_Q-2020.06D';
	 $vcsv = 'vcs';

    my ($orig_spd_script) = @_;
	 print "Inside modify_spd, ptp_en is $ptp_en $orig_spd_script ";
    ITF::itf_run_system_command("cat $orig_spd_script > ${orig_spd_script}.new");
    if($topology =~ m/sm/){
	 print "Inside SM topology using sed command  ";
     if($plaintext == 1){
	   print "Inside SM plaintext   ";
      ITF::itf_run_system_command("sed -i 's#$ENV{'ACDS_DEST_ROOT'}/devices/sim_lib/tennm_agilex5_hssi_a_ncrypt.sv#$ENV{'ACDS_DEST_ROOT'}/not_shipped/devices/sim_lib/tennm_agilex5_hssi_a_plaintext.sv#'  ${orig_spd_script}.new");
      }
      ITF::itf_run_system_command("sed -i 's#$ENV{'ACDS_DEST_ROOT'}/devices/sim_lib/tennm_sm7_io96_ncrypt.sv# #'  ${orig_spd_script}.new");
      ITF::itf_run_system_command("sed -i 's#$ENV{'ACDS_DEST_ROOT'}/devices/sim_lib/tennm_agilex5_io96_ncrypt.sv# #'  ${orig_spd_script}.new");  
    }
    ITF::itf_run_system_command("sed -i 's#vcs \-lca \-timescale\=1ps/1ps \-sverilog \+verilog2001ext\+\.v#vcs \-lca  \-sverilog #'  ${orig_spd_script}.new");

    return "${orig_spd_script}.new";
}

ITF::set_option('custom_gen_spd_sim_script_fn', 'simulation.vcs', \&modify_spd);

##===================== Compilation stage ========================##

sub generate_custom_vcsmx_setup_script {
   my $elab_options = $_[1];
   my $vlogan_compile_cmd = $_[0];
   $elab_options =~ s/ /\\ /g;
   my $escaped_top_module = $top_module;
   $escaped_top_module =~ s/ /\\ /g;
   ITF::itf_print_info("Escaped elap options are: $elab_options");
   my $script_dir = getcwd()."/itf_qsys_verilog";

   my $compile_script = <<multiline_string_ending_delimiter;
#!/bin/bash
set -x

# fix compile error by removing duplicate quartus_dpi.o includes
sed -i '/append ELAB_OPTIONS \\[intel_mge_phy_/d' $script_dir/tsn_subsys/tsn_subsys/sim/common/vcsmx_files.tcl

# add vlogan command to vcsmx_setup.sh
sed -i 's#elaborate top level design#elaborate top level design\\n$vlogan_compile_cmd\\n\\n#' $script_dir/qsys_top/sim/synopsys/vcsmx/vcsmx_setup.sh

sh ./vcsmx_setup.sh USER_DEFINED_ELAB_OPTIONS="$elab_options" TOP_LEVEL_NAME="$escaped_top_module" SKIP_SIM=1
exit $?
multiline_string_ending_delimiter

   open(CUSTOM_VCS_COMPILE_SCRIPT_FH, '>', './custom_fix_compile_swap_subsys.sh');
   print CUSTOM_VCS_COMPILE_SCRIPT_FH $compile_script;
   close(CUSTOM_VCS_COMPILE_SCRIPT_FH);
   system("chmod u+x ./custom_fix_compile_swap_subsys.sh");

}

sub extract_module_contents {
  my $source = $_[0];
  open(SRC_FH, '<', $source);

  my $module_contents = "";
  my $found_module = 0;
  my $inside_module = 0;
  my $left_module = 0;
  while (<SRC_FH>) {
    # print $_;
    if ($_ =~ /module hps_subsys \(/) {
      $found_module = 1;
    }
    
    if ($found_module) {
      if ($_ =~ /\);/ && !$inside_module) {
        $inside_module = 1;
        next;
      }
      
      if ($inside_module) {
        if ($_ =~ /endmodule/) {
          $left_module = 1;
        } else {
          $module_contents = $module_contents.$_;
        }
      }
    }
  }
  close(SRC_FH);

  # print($module_contents);
  return $module_contents;
}

sub replace_module_contents {
  my ($dest, $module_contents) = @_;
  print("dest is $dest");
  open(DST_FH, '<', $dest) or die "could not open $dest";
  open(TMP_DST_FH, '>', "${dest}.tmp") or die "could not create ${dest}.tmp";

  my $found_module = 0;
  my $inside_module = 0;
  my $left_module = 0;
  while (<DST_FH>) {
    print TMP_DST_FH $_;
    if ($_ =~ /module hps_subsys \(/) {
      $found_module = 1;
    }
    
    if ($found_module) {
      if ($_ =~ /\);/ && !$inside_module) {
        $inside_module = 1;
        next;
      }
      
      if ($inside_module) {
        print TMP_DST_FH $module_contents."\n";
        print TMP_DST_FH "endmodule\n";
        last;
      }
    }
  }
  close(DST_FH);
  close(TMP_DST_FH);

  print("Replacing custom_hps now!");
  system("pwd") == 0 or die $!;
  system("ls") == 0 or die $!;
  system("cat $dest") == 0 or die $!;
  # system("cp ${dest}.tmp .") == 0 or die $!;
  system("rm -f ${dest}") == 0 or die $!;
  system("cat ${dest}.tmp > $dest") == 0 or die $!;
  system("pwd") == 0 or die $!;
  system("ls") == 0 or die $!;
  system("cat $dest") == 0 or die $!;
}

sub compile {
  my $xprop                  = ITF::get_option("xprop", "ITF");
  my $mux_debug              = ITF::get_option("mux_debug"   , "ITF") || "1";
  my $fsdb_en                = ITF::get_option("fsdb_en", "ITF") || 0;
  my $perf_en                = ITF::get_option("perf_en", "ITF") || 0;

  my $testname               = ITF::get_option("testname", "ITF");
  my $seed                   = ITF::get_option("seed", "ITF");

  my $vcs_user_def_opts      = "";
  my $vlogan_compile_cmd     = "vlogan +define+UVM_PACKER_MAX_BYTES=1500000 -ntb_opts uvm -sverilog; vlogan +define+UVM_PACKER_MAX_BYTES=1500000 +v2k -sverilog +verilog2001ext+.v -full64";

   if($dump_on == 1) {
     $vcs_user_def_opts .= " -debug_access+nomemcbk+dmptf -debug_region+cell -debug_pp +vcs+vcdpluson +memcbk +vcdplusmemon"; 
   }

   if($perf_en == 1) {
    $user_defined_options .= " +define+BANDWIDTH_ON";
   }

   if($mux_debug == 1) {
     $debug_def = " +define+MUX_DEBUG";
   }
 
   if ($cov_en == 1) {
     $user_defined_options .= " -ntb_opts dtm -cm assert+line+cond+tgl+branch+fsm -cm_libs yv+celldefine -cm_tgl mda";
   }
   
   $user_def_comp_opt .= "+define+ENABLE_ETH_VIP +define+IP7521SERDES_UXS2T1R1PGD_PIPE_SPEC_FORCE +define+IP7521SERDES_UXS2T1R1PGD_PIPE_SIMULATION +define+SIMULATION +define+IP7521SERDES_UXS2T1R1PGD_PIPE_FAST_SIM +define+IP7521SERDES_UXS2T1R1PGD_PIPE_APMA_FAST_SIM +define+IP7581SERDES_UXS2T1R1PGD_PIPE_SPEC_FORCE +define+IP7581SERDES_UXS2T1R1PGD_PIPE_SIMULATION +define+IP7581SERDES_UXS2T1R1PGD_PIPE_FAST_SIM +define+IP7581SERDES_UX_SIMSPEED +define+INTEL_NO_PWR_PINS +define+NO_PWR_PINS +define+INTCNOPWR +define+INTC_FUNCTIONAL +define+INTEL_SIMONLY +define+INTC_SVA_OFF +define+QUARTUS +define+PFEDV_ONLY_MODEL_MACRO_DIS +define+PMADIR_4A -timescale=1ns/1ps +define+ETH_SM_MGBASET +define+ETH_MGBASET +define+SKIP_SIMPLE_MODEL +define+PLL_CAL_BYPASS +define+AVST_MODE";
   
   #metastability
   $user_def_comp_opt .= " +define+__ALTERA_STD__METASTABLE_SIM";
   $user_def_comp_opt .= " +define+RDY_LAT=0";
   $user_def_comp_opt .= " +define+UNHIDE_cr3v0";
   $user_def_comp_opt .= " +define+EHIP  -diskopt -noIncrComp";
   $user_def_comp_opt .= " +define+G10 +define+G10_25 +define+VIP_ETHERNET_40G100G_OPT_SVT +define+NUM_CHANNELS=1 +define+DR";
   $user_def_comp_opt .= " +define+FAST_CLK";
   $user_def_comp_opt .= " +define+NON_ANLT_PTP";
   $user_def_comp_opt .= " +define+DEVICE_SM";
   $user_def_comp_opt .= " +define+CRETE3";
   if($fsdb_en==1) {
      $user_def_comp_opt .= " +define+FSDB_ON"; 
   }
   $user_def_comp_opt .= " +define+ACDS_19_1";
   $user_def_comp_opt .= " +define+2_5G_SPEED";
   $user_def_comp_opt .= " +define+SM_8BIT_2_5_G_SPEED";
   if(ITF::get_option("config_name", "ITF") =~ /config-3/) {
       #$user_def_comp_opt .= " +define+TSN_CFG3";
   }
   if($xprop==1) {
      $user_def_comp_opt .= ' -xprop=$REG_LOCAL_ROOT_DIR_PATH/testbench/bin/xprop_config_file  +define+XPROP';
   }
   if($fsdb_on == 1) {
     $vcs_user_def_opts .= " -kdb +define+FSDB +fsdb+all=on +fsdb+mda=on +fsdb+struct=on +fsdb+sc_struct"; 
   }

   $tb_flists              .= " -f $ENV{TB_PATH}/flist/svt_axi_vip.flist ";
   $tb_flists              .= " -f $ENV{TB_PATH}/flist/vip_files.f ";
   $tb_flists              .= " -f $ENV{TB_PATH}/flist/tsn_tb_files.f ";

  #  $rtl_flists             .= " -f $ENV{TSN_HOME}/../hw/a5e065bb32aes1_mdk_3x2.5G/custom_ip/rtl.f"; # ghrd_agilex5_top is in this filelist (custom_ip/rtl.f)
   
   $rtl_flists             .= " -f $ENV{TSN_HOME}/design/dv_use/alt_em10g32_0_flist.f"; # static tb ip

   $rtl_flists             .= " -f $ENV{TSN_HOME}/../hw/a5e065bb32aes1_mdk_3x2.5G/custom_ip/rtl.f"; # ghrd_agilex5_top is in this filelist (custom_ip/rtl.f)
   $compile_opts           .= " +lint=TFIPC-L +lint=PCWM $defines $debug_def $rtl_flists $tb_flists $user_defined_options $user_def_comp_opt";
 
   $compile_cmd            .= " $vcs_user_def_opts $compile_log";

   $vlogan_compile_cmd     .= " $compile_opts -l vlog.log";
 
   ITF::itf_print_info("REG_BASE_EXE_DIR_PATH=$ENV{REG_BASE_EXE_DIR_PATH}");
   ITF::set_option('USER_DEFINED_ELAB_OPTIONS', 'simulation.vcsmx', "$compile_cmd");

   generate_custom_vcsmx_setup_script($vlogan_compile_cmd, $compile_cmd);
}

###################################################################
sub run_makefile {
  my $config_options = ITF::get_option("config_options", "ITF");
  ITF::itf_print_info("Config $config_options selected!");

  system("cd $ENV{'TSN_HOME'}/../hw/a5e065bb32aes1_mdk_3x2.5G && make clean");
  system("cd $ENV{'TSN_HOME'}/../hw/a5e065bb32aes1_mdk_3x2.5G && make config");
  my $makefile_ret_val = system("cd $ENV{'TSN_HOME'}/../hw/a5e065bb32aes1_mdk_3x2.5G && make $config_options generate_from_tcl");
  if ($makefile_ret_val == 0) {
    ITF::itf_print_info("Makefile successfully ran!");
  } else {
    die "Makefile run unsuccessful";
  }
}

sub chmod_qfiles_and_copy_subsys_to_run_dir {

  if (!defined(ITF::get_option("synthesize", "ITF"))) {
    ITF::itf_print_info("--synthesize option undefined - now deleting synthesize subtest!");
    ITF::delete_subtest("qsys", "qsyn");
  }

  #run_makefile();

  my $project_name = ITF::get_option('project_name', 'ITF');
  ITF::itf_print_info("Project is $project_name");

#   system("chmod +x $ENV{'TSN_HOME'}/../hw/a5e065bb32aes1_mdk_3x2.5G/$project_name.q*f");
  system("cp $ENV{'TSN_HOME'}/../hw/a5e065bb32aes1_mdk_3x2.5G/$project_name.q*f .");

  system("cp -rf $ENV{'TSN_HOME'}/../hw/a5e065bb32aes1_mdk_3x2.5G/custom_ip itf_qsys_verilog");
  system("cp -rf $ENV{'TSN_HOME'}/../hw/a5e065bb32aes1_mdk_3x2.5G/hps_subsys itf_qsys_verilog");
  system("cp -rf $ENV{'TSN_HOME'}/../hw/a5e065bb32aes1_mdk_3x2.5G/jtag_subsys itf_qsys_verilog");
  system("cp -rf $ENV{'TSN_HOME'}/../hw/a5e065bb32aes1_mdk_3x2.5G/peripheral_subsys itf_qsys_verilog");
  system("cp -rf $ENV{'TSN_HOME'}/../hw/a5e065bb32aes1_mdk_3x2.5G/tsn_subsys itf_qsys_verilog");
  system("cp -rf $ENV{'TSN_HOME'}/../hw/a5e065bb32aes1_mdk_3x2.5G/phymgmt_subsys itf_qsys_verilog");
  system("cp -f $ENV{'TSN_HOME'}/../hw/a5e065bb32aes1_mdk_3x2.5G/qsys_top.qsys itf_qsys_verilog");
  system("cp -rf $ENV{'TSN_HOME'}/scripts/itf/custom_hps itf_qsys_verilog");

  # maybe try passing files to children
  system("cp -rf $ENV{'TSN_HOME'}/../hw/a5e065bb32aes1_mdk_3x2.5G/custom_ip .");
  system("cp -rf $ENV{'TSN_HOME'}/../hw/a5e065bb32aes1_mdk_3x2.5G/hps_subsys .");
  system("cp -rf $ENV{'TSN_HOME'}/../hw/a5e065bb32aes1_mdk_3x2.5G/jtag_subsys .");
  system("cp -rf $ENV{'TSN_HOME'}/../hw/a5e065bb32aes1_mdk_3x2.5G/peripheral_subsys .");
  system("cp -rf $ENV{'TSN_HOME'}/../hw/a5e065bb32aes1_mdk_3x2.5G/tsn_subsys .");
  system("cp -rf $ENV{'TSN_HOME'}/../hw/a5e065bb32aes1_mdk_3x2.5G/phymgmt_subsys .");
  system("cp -f $ENV{'TSN_HOME'}/../hw/a5e065bb32aes1_mdk_3x2.5G/qsys_top.qsys .");

  system("cp -rf $ENV{'TSN_HOME'}/../hw/a5e065bb32aes1_mdk_3x2.5G/ip itf_qsys_verilog");
  
  system("cp -rf $ENV{'TSN_HOME'}/../hw/a5e065bb32aes1_mdk_3x2.5G/ghrd_agilex5_top.v itf_qsys_verilog");
}


# Reading regression files
sub read_list {
   my $list_file = $_[0];
   my @list;

   if (defined(ITF::get_option("testname", "ITF"))) {
    return \@list;
   }

   if (!defined($list_file)) {
    ITF::itf_die("--testname or --regr_list not specified!");
    return \@list;
   }

   open (REGR_FILE,"$list_file") or die ("Could not open $list_file");
   while (<REGR_FILE>) {
     if (!($_ =~ m/^\s*([#]+([\s]*[_a-zA-Z0-9]*)*)*\s*$/g)) {
       chomp ();
       my ($testname, $options_as_str) = ($_ =~ /testname=([a-zA-Z0-9_-]+)(?: (.*))?$/);

       my @options_as_array = defined($options_as_str) ? split(/\s+/, $options_as_str) : [];
       my @sequence_specified = grep { $_ =~ /sequence=/ } @options_as_array;
      
       my $sequence = "";

       if (@sequence_specified) {
         ($sequence) = @sequence_specified[0] =~ /sequence=(.*)/;
       }

       push (@list, {
        'testname' => $testname,
        'sequence' => $sequence,
        'options' => \@options_as_array
        });
     }
   }

   ITF::itf_print_info("List read: " . Dumper(@list));

   return @list;
}

my $regression_list_file = ITF::get_option("regr_list", "ITF");
my @regression_list = &read_list($regression_list_file);

sub sequence_variants {
  my @tests_to_run;
  my $testname = ITF::get_option("testname" , 'ITF') || undef;
  
  # Build list of testnames
  if(defined ($testname)) {
    push(@tests_to_run, {
      'testname' => $testname,
      'options' => []
    });
  } else {
    @tests_to_run = @regression_list;
  }

  # Create sequence based on testnames and iterations/test specified
  my @variants_to_spawn;
  for my $test_num (0 .. $#tests_to_run) {
    my $test_to_run = $tests_to_run[$test_num]{"testname"};
    my $seq_to_run = $tests_to_run[$test_num]{"sequence"};
    push(@variants_to_spawn, "${test_num}_${test_to_run}-$seq_to_run");
  }

  ITF::itf_print_info("Test variants to be run: " . join(", ", @variants_to_spawn));
  return \@variants_to_spawn;
}


sub sequence_update {
  ITF::itf_print_info("Updating sequence variant \n");

  my $variant_name = ITF::get_subtest_option("variant_name");
  my ($line_n) = ($variant_name =~ /([0-9]+)_.*/);


  my $options = $regression_list[$line_n]->{"options"} || undef;
  my $testname = $regression_list[$line_n]->{"testname"} || "";
  ITF::set_option("testname", "ITF", $testname);
  ITF::itf_print_info($testname);
  ITF::itf_print_info(Dumper($options));
  for my $option (@$options) {
    my ($key, $value) = ($option =~ /--(.*)=(.*)/);
    ITF::itf_print_info("$option -> $key $value");
    if (!defined(ITF::get_option($key, "ITF"))) {
      ITF::itf_print_info("Setting option $key to $value");
      ITF::set_option($key, "ITF", $value);
    } else {
      ITF::itf_print_info("$key is defined! Not setting...");
    }
  }
   
}

if (!defined(ITF::get_option("testname", "ITF"))) {
  ITF::register_function("sequence", "get_variant_list", \&sequence_variants);
  ITF::register_function("sequence", "update_variant", \&sequence_update);

  # provide default value for the regression
  if (!defined(ITF::get_option("num_seeds", "ITF"))) {
    ITF::set_option("num_seeds", "ITF", 20);
  }
}
ITF::register_function("sequence", "run_post_process", \&sequence_post_process);

sub config_variants {
  ITF::itf_print_info("Getting config variants now!");
  my @config_variants = split(",", $makefile_configs);
  
  my $variants_to_run = "";
  foreach my $variant_to_be_run (@config_variants) {
    $variants_to_run .= $variant_to_be_run;
  }
  ITF::itf_print_info("Config Variants to be run: $variants_to_run");
  return \@config_variants;
}

sub config_update {
  ITF::itf_print_info("Updating config variants now!");
  my $config_name = ITF::get_subtest_option("variant_name");
  ITF::itf_print_info("$config_name");
  my $config_options = "";
  if ($config_name =~ /config-3/) {
    $config_options = "TSN_CONCURRENT=0 F2SDRAM_DATA_WIDTH=0 H2F_WIDTH=0 HPS_EMIF_MEM_CLK_FREQ_MHZ=800 HPS_EMIF_REF_CLK_FREQ_MHZ=100";
  } elsif ($config_name =~ /tsn-concurrent/) {
    $config_options = "TSN_CONCURRENT=1 F2SDRAM_DATA_WIDTH=0 H2F_WIDTH=0 HPS_EMIF_MEM_CLK_FREQ_MHZ=800 HPS_EMIF_REF_CLK_FREQ_MHZ=100 ";
  }



  ITF::set_option("config_options", "ITF", $config_options);
  ITF::set_option("config_name", "ITF", $config_name);
}

ITF::register_function("qsys", "get_variant_list", \&config_variants);
ITF::register_function("qsys", "update_variant", \&config_update);


sub sequence_post_process {
  my $seed = ITF::get_option("seed", "ITF");
  my $num_seeds = ITF::get_option("num_seeds", "ITF") || 1;
  my $use_fixed_seed = ITF::get_option("fixed_seed", "ITF") || undef;

  if ( defined($seed)) {
	  my @seeds = ($seed);
	  ITF::set_option('run_seed_sweep__rtl_sim_simulate_only_vcsmx', 'ITF', \@seeds);
	  ITF::enable_seed_sweep({'seed_type'=> 'user', 'stage' => 'rtl_sim_simulate_only_vcsmx'});
  } else {
    if (defined($use_fixed_seed)) {
	    ITF::enable_seed_sweep({'seed' => $num_seeds, 'stage' => 'rtl_sim_simulate_only_vcsmx', 'seed_type' => 'fixed'});
    } else {
      my @seeds;
      for (1 .. $num_seeds) {
        my $new_seed = int(rand($seed_range));
        while (grep( /^$new_seed$/, @seeds )) {
          $new_seed = int(rand($seed_range));
        }
        push(@seeds, $new_seed);
      }
	    ITF::set_option('run_seed_sweep__rtl_sim_simulate_only_vcsmx', 'ITF', \@seeds);
	    ITF::enable_seed_sweep({'seed_type'=> 'user', 'stage' => 'rtl_sim_simulate_only_vcsmx'});
    }
  }

  # dump the command that was run
  my $variant_name = ITF::get_subtest_option("variant_name");
  if (!defined($variant_name)) {
    return;
  }

  my ($line_n) = ($variant_name =~ /([0-9]+)_.*/);

  my $options = $regression_list[$line_n]->{"options"} || undef;
  my $testname = $regression_list[$line_n]->{"testname"} || undef;
  my $options_as_str = join(' ', @$options);
  if ($options_as_str ne "") {
    $options_as_str = "--".$options_as_str;
  }

  open(SEQ_CMD_RUN_FH, '>', 'regression_cmd_report.txt');
  print SEQ_CMD_RUN_FH "--testname=$testname $options_as_str";
  close(SEQ_CMD_RUN_FH);

}

##====================== Simulation stage ========================##
sub simulate {
#   ITF::set_option('enable_qsf_ip_gen', 'ITF', 0);
#   ITF::set_option('qsys_testbench_flow', 'simulation', 0);
#   ITF::set_option('custom_top_sim_script_run_directory', 'simulation.vcs', "./qsys_top/sim/synopsys/vcs");
#   our $qsys_testbench_flow = '';

  my $sequence               = ITF::get_option('sequence','ITF');
  my $plusargs               = ITF::get_option("plusargs", "ITF");
  my $testname               = ITF::get_option("testname", "ITF");

  $plusargs = "+".$plusargs;
  $plusargs = join(" +", split(',',$plusargs));
  

  my $variant_name = ITF::get_subtest_option("variant_name");
  
  my $seed = ITF::get_option("seed", "ITF");
  if (!defined($seed)) {
    if ($variant_name =~ /s[0-9]+/) {
      $variant_name =~ s/s//g;
      $seed = $variant_name;
    } else {
      $seed = int(rand($seed_range));
    }
    ITF::set_option("seed", "ITF", $seed);
  }

  ITF::itf_print_info("Seed is: $seed");

  my $coverage_dir = "";
  if (defined(ITF::get_option("use_network_cm_dir", "ITF"))) {
    system("mkdir -p $ENV{'REG_INITIAL_EXE_DIR_PATH'}/../../COVERAGE_DIR");
    $coverage_dir = "$ENV{'REG_INITIAL_EXE_DIR_PATH'}/../../COVERAGE_DIR/simv.vdb";
  } else {
    $coverage_dir = "./simv.vdb";
  }  

   $uvm_options            .= " +UVM_VERBOSITY=$uvm_verbosity +ntb_random_seed=$seed +UVM_TESTNAME=$testname +UVM_MAX_QUIT_COUNT=$max_error +UVM_LOG_RECORD   +UVM_TR_RECORD +m_sequence=$sequence $plusargs +disable_pause=0 +disable_ptp=1";

   if ($cov_en == 1) {
    $sim_opts .= " -cm assert+line+cond+tgl+branch+fsm -cm_name ${sequence}_${seed} -cm_dir $coverage_dir";
   }

   $sim_opts               .= " +trans_count=$trans_count +ETH_INTERFACE_SELECT=136 +ETH_FIRST_CASE=1 +ETH_LAST_CASE=1 +ETH_BASIC_TEST";

   $user_defined_options   .= " +licq $uvm_options $sim_opts";

   $simulation_cmd         .= " $user_defined_options $simulation_log";
 
   ITF::itf_print_info("Testname=$testname");

   ITF::set_option('USER_DEFINED_SIM_OPTIONS', 'simulation.vcsmx', "$simulation_cmd");
}


####################################################################
##------------------------- ITF Options --------------------------##
####################################################################

ITF::set_option('enable_qsf_ip_gen', 'ITF', 1);

ITF::set_option('custom_top_sim_script', 'simulation.vcsmx', './custom_fix_compile_swap_subsys.sh');
ITF::set_option('disable_vhdl', 'ITF', 1);

ITF::register_user_function('qsys', 'run_pre_process', \&chmod_qfiles_and_copy_subsys_to_run_dir);

ITF::set_option('run_spd_flow' , 'simulation', 1);

ITF::set_option('enable_qsys_reg_exe_flags','ITF',0);
# ITF::set_option('use_ip_setup_simulation_flow', 'simulation', 1);
ITF::set_option('disable_vhdl', 'ITF', 1);

ITF::set_option('no_testbench_source_files' , 'simulation.vcsmx' , 1);

# Since there are no IP files generated
ITF::set_option('no_generated_ip_files', 'simulation', 1);

# Top Level module
ITF::set_option('testbench_name' , 'simulation' , "qsys_top");

sub device_resources {
	$snps = 'synopsys_vip_common/vip_Q-2020.06D';
   $vcsv = 'vcs';
	return "$vcsv,vcs-vcsmx-lic,$snps,synopsys_vip_ethernet-lic,synopsys_verdi/Q-2020.03,synopsys-vip-lic,altuvm/0.9p8,vnc_display";
}
ITF::register_user_function("device", "get_arc_resources", \&device_resources);
ITF::register_user_function("rtl_sim_compile_only_vcsmx_vlg", "get_arc_resources", \&device_resources);
ITF::register_user_function("rtl_sim_simulate_only_vcsmx", "get_arc_resources", \&device_resources);

####################################################################
##------------------------- ITF Function Calls -------------------##
####################################################################

ITF::register_user_function("rtl_sim_compile_only_vcsmx_vlg", "run_pre_process", \&compile);

sub replace_simv {
   # rtl_sim_compile_only generated a custom vcs_setup file based on testbench name
   # if no_generated_ip_files=0 it would have searched through the current directory to try to find .spd files
   # However, we want to use the vcs_setup.sh file generated by qsys in the previous subtest so we copy the file in this function
   # Note, this function is called with the directory set to the subtest dir

   system("cp -rf itf_qsys_verilog/qsys_top/sim/* .");
}

ITF::set_option("custom_startup_fn", "simulation.vcsmx", \&replace_simv);

ITF::register_user_function("rtl_sim_simulate_only_vcsmx", 'run_pre_process', \&simulate);

ITF::set_option('custom_top_sim_script_run_directory', 'simulation.vcsmx', "itf_qsys_verilog/qsys_top/sim/synopsys/vcsmx");

## post process

sub post_simulate_info_dump {
  open(POST_SIM_RESULTS_FH, '>', 'post_simulate_report.txt');

  my @all_possible_itf_options = ("testname", "sequence", "plusargs", "verbosity", "error_count", "testname", "seed", "num_seeds", "fixed_seed", "config_options", "config_name");

  # my $testname = ITF::get_option("testname", "ITF");
  # my $sequence = ITF::get_option("sequence", "ITF");
  # my $seed = ITF::get_option("seed", "ITF");

  # print POST_SIM_RESULTS_FH "TESTNAME: $testname\n";
  # print POST_SIM_RESULTS_FH "SEQUENCE: $sequence\n";
  # print POST_SIM_RESULTS_FH "SEED: $seed\n";

  my $command_to_rerun_options = "";
  for my $option (@all_possible_itf_options) {
    my $option_val = ITF::get_option($option, "ITF");
    if (defined($option_val)) {
      $command_to_rerun_options .= "--$option=$option_val ";
      print POST_SIM_RESULTS_FH "$option:$option_val\n"
    }
  }
  print POST_SIM_RESULTS_FH "rerun_cmd:reg_exe --localr $command_to_rerun_options\n";

  close(POST_SIM_RESULTS_FH);
  
}
ITF::register_user_function("rtl_sim_simulate_only_vcsmx", "run_post_process", \&post_simulate_info_dump);

sub replace_hps {
  ITF::itf_print_info("Replacing hps function is here!");
   my $module_contents = extract_module_contents("$ENV{'TSN_HOME'}/custom_hps/custom_hps.v");
   replace_module_contents("./itf_qsys_verilog/hps_subsys/hps_subsys/sim/hps_subsys.v", $module_contents);
  #  replace_module_contents("./hps_subsys/hps_subsys/sim/hps_subsys.v", $module_contents);
}
ITF::register_user_function("qsys", "run_post_process", \&replace_hps);

# do not remove the line below!
1;
