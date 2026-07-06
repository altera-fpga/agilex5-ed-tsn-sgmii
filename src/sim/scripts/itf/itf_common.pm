package itf_common;

# packages
############################################################
use RegTest;
use Readonly;
use Carp;
use warnings;
use strict;
use Cwd;

use File::Basename;
use Data::Dumper;

use TestUtils::XML;
use TestUtils::XML qw(:XML_Types);
use TestUtils::Quartus;
use TestUtils::IPGeneration;
use TestUtils::IPStandardTest::Devices;
use TestUtils::QuartusDevices;
use TestUtils::VG;
use TestUtilsContrib::DSPIP; # custom functions for DSP IP
use TestUtilsSystem::IO::Redirection;
use TestUtilsSystem::Utils::BootstrapLoad;
use TestUtilsSystem::Messages::Standard;
############################################################

# Common file locations
Readonly::Scalar our $COMMON_DIRECTORY => "$ENV{REG_LOCAL_ROOT_DIR_PATH}scripts";
Readonly::Scalar our $COMMON_FLOW_DIRECTORY => "$COMMON_DIRECTORY/common_flow";
Readonly::Scalar our $PARAMS_FILE => "params.xml";
Readonly::Scalar our $EXPANDED_PARAMS_FILE => "expanded_params.xml";
Readonly::Scalar our $qis_warning_check_specific => "acceptable_warnings.txt";
Readonly::Scalar our $qis_warning_check_total => "totalacceptable_warnings.txt";
Readonly::Scalar our $qis_found_warnings => "found_warnings.rpt";
Readonly::Scalar our $qis_warning_check_common => "$COMMON_DIRECTORY/common_acceptable_warnings.txt";
Readonly::Scalar our $IP_DIR => "ip";
Readonly::Scalar our $INSTANCE_NAME => "core";
Readonly::Scalar our $PROJECT_DIR => "prj";
Readonly::Scalar our $PROJECT => "project";
Readonly::Scalar our $DA_FILE => "acceptable_da_warnings.txt";
Readonly::Scalar our $family_param_name => "family";
Readonly::Scalar our $device_param_name => "part";
Readonly::Scalar our $family_expand_type => "family_selection";
Readonly::Scalar our $edition_filter_name => "quartus_selection";



#REG_ROUT Strings
Readonly::Scalar our $REG_ROUT_STATUS_NAME => "RESOLVE_VARIATION";
Readonly::Scalar our $GENERATOR_REG_ROUT_STATUS_NAME => "IP_GENERATION";
Readonly::Scalar our $COMPILE_REG_ROUT_STATUS_NAME => "QUARTUS_COMPILE";
Readonly::Scalar our $MAP_REG_ROUT_STATUS_NAME => "MAP_WARNINGS_CLEAN";
Readonly::Scalar our $OCP_REG_ROUT_STATUS_NAME => "OCP_FILE_EXISTENCE";

################## Helper functions ########################

sub pro() {
    my $edition = "pro"; # This could be queried back when std and pro were on the same branch 
    if(defined($edition)) {
      if($edition ne "pro") {
        return 0;
      }
    }
    return 1;
}


# Returns path to the directory containing the file, without a trailing slash or backslash.
sub path_containing_file {
   my $file_path = shift(@_);
   my $volume;
   my $directories;
   my $file; 
   ($volume, $directories, $file) = File::Spec->splitpath($file_path);
   my @dirs = File::Spec->splitdir($directories);
   my $containing_dir = pop(@dirs);
   $directories = File::Spec->catdir(@dirs); 
   return File::Spec->catpath($volume, $directories, $containing_dir);
}

# Returns a relative path starting with the last instance of the specified subdirectory.
sub relative_path_based_on {
   my $base_of_relative_path = shift(@_);
   my $input_path = shift(@_);
   my $volume;
   my $directories;
   my $file;
   ($volume, $directories, $file) = File::Spec->splitpath($input_path);
   my @dirs = File::Spec->splitdir($directories);
   my @relative_dirs;
   if (scalar(@dirs) > 0) {
      my $dir;
      do {
         $dir = pop(@dirs);
         unshift(@relative_dirs, $dir);
      } while ((scalar(@dirs) > 0) && ($dir ne $base_of_relative_path));
   }
   if (scalar(@dirs) == 0) {
      return $input_path;
   } else {
      return File::Spec->catfile(@relative_dirs, $file);
   }
}


sub get_supported_families() 
{
  my @ip_supported_families = (
    'Stratix IV',
    'Stratix V',
    'MAX 10',
    'Cyclone IV GX',
    'Cyclone IV E',
    'Cyclone V',
    'Arria II GX',
    'Arria II GZ',
    'Arria V',
    'Arria V GZ',
    'Arria 10'
  );
  if (pro()) {
      @ip_supported_families = ( 'Arria 10', 'Stratix 10', 'Cyclone 10 GX');
  }
  return @ip_supported_families;
} 

sub get_hls_supported_families() 
{
    my @ip_supported_families = (
            'Stratix IV',
            'Stratix V',
            'Arria II GZ',
            'Arria V',
            'Arria V GZ',
            'Arria 10',
    );
    if (pro()) {
        @ip_supported_families = ( 'Arria 10', 'Stratix 10', 'Cyclone 10 GX' );
    }
    return @ip_supported_families;
}

#
# Returns:
# A reference to an array of families for whom we should extract QOR numbers
#
sub get_qor_families()
{
    my @ip_supported_families = (
      'Stratix V',
      'Arria V',
      'Cyclone V',
      'Arria 10',
    );
    if (pro()) {
       @ip_supported_families = ( 'Arria 10','Stratix 10','Cyclone 10 GX' );
    }
    return @ip_supported_families;
}

sub get_default_family {
    return ("Arria 10");
}

# get_hls_qor_families
# Returns:
# An array of HLS families for whom we should extract QOR numbers
# The list is hard-coded here as HLS QoR is ONLY obtained for the set of devices for
# which HLS QoR has been published. 
#
sub get_hls_qor_families()
{
    my @ip_supported_families = (
      'Stratix V',
      'Arria 10',
    );
    if (pro()) {
       @ip_supported_families = ( 'Arria 10', 'Stratix 10', 'Cyclone 10 GX');
    }
    return @ip_supported_families;
}

#Get the ram required to compile for this device

sub get_ram_required {
    my ($family) = @_;
    $family =~ s/\s+//g;
    $family = lc $family;
    $family =~ s/fpga//; #convert max10fpga to max10
    my %family_part_hash = (
      'stratix10'    => '64000',
      'arria10'    => '48000',
      'arriav'     => '16000',
      'arriavgz'   => '16000',
      'arriaiigx'  => '6000',
      'arriaiigz'  => '8000',
      'cyclonev'   => '8000',
      'cycloneivgx'=> '2000',
      'cycloneive' => '2000',
      'max10'      => '2000',
      'stratixv'   => '28000',
      'stratixiv'  => '12000'
    );
    if ( exists $family_part_hash{$family} ) {
        return $family_part_hash{$family};
    } else {
        return '64000';
    }
}

# Returns true if the device DSP block provides hardened floating point
# in the specified precision
sub has_hardened_fp {
   my $family    = shift(@_);
   my $fp_format = shift(@_);
   return ((lc($family) eq "stratix 10" || lc($family) eq "cyclone 10 gx" || lc($family) eq "arria 10") && lc($fp_format) eq 'single');
}


# Function: get_default_part
#
#  Returns the default part for certain device families. 
#  The default part is identical to the one used in the 
#  development kit for that family where one exists.
#   
#
# Parameters:
#
#   family -  the family whose default part will be returned
#             the function will accept most ways of formatting the family name
#
# Returns:
#
#  The default part, may return AUTO
sub get_default_part {
    my ($family) = @_;
    $family =~ s/\s+//g;
    $family = lc $family;
    $family =~ s/fpga//; #convert max10fpga to max10
    my %family_part_hash = (
      'stratix10'    => '1SX280HH1F55E1VG',
      'arria10'    => '10AX066H2F34I2LP',
      'arriav'     => '5AGXFB3H4F40C5',
      'arriavgz'   => '5AGZME7K2F40C3',
      'arriaiigx'  => 'EP2AGX125EF35C4',
      'arriaiigz'  => 'EP2AGZ350HF40C3',
      'cyclonev'   => '5CGXFC7D6F31C7',
      'cycloneivgx' => 'EP4CGX150DF31C7',
      'cycloneive' => 'EP4CE115F23C7',
      'cyclone10gx' => '10CX220YF780I5G',
      'max10'      => '10M50DAF484C6GES',
      'stratixv'   => '5SGXEA7K2F40C2',
      'stratixiv'  => 'EP4SGX230KF40C2'
    );
    if ( exists $family_part_hash{$family} ) {
        return $family_part_hash{$family};
    } else {
        return 'AUTO';
    }
}


# get_subtest_info
# Given the name of a subtest script (with or without the .pl suffix), if there is an accompanying
# .info file, uses it to populate and return a map of reg_info style options.
# Presently the only keywords supported are Requirements and Timeout.
sub get_subtest_info {
        my $subtest_script_name = shift(@_);
        my %result;
        my @lines;
        my $subtest_info_file_name = $subtest_script_name;
        $subtest_info_file_name =~ s/\.pl//;
        $subtest_info_file_name = "$subtest_info_file_name.info";
        if (open(my $fh, "<", $subtest_info_file_name)) {
                chomp(@lines = <$fh>);
        }
        foreach my $keyword ('Requirements', 'Timeout') {
                my @keyword_lines = grep(/^$keyword\s?:\s?/i, @lines);
                foreach my $line (@keyword_lines) {
                        $line =~ s/$keyword\s?:\s?//i;
                }
                if (@keyword_lines > 0) {
                        $result{$keyword} = join(',',@keyword_lines);
                }
        }
        return %result;
}

# add_subtest
# Wrapper for reg_add_subtest, taking parameters in the same way as reg_add_subtest but also
# supplementing them with Requirements and Timeout values read from the accompanying
# .info file (if one is present). If these values are present in the .info file, they
# override values received through the parameter list. 
# If reg-subtest-rel-name is not specified in the parameter list, it is determined from the
# name of the command script (reg-cmd) by removing the leading stageN_ and trailing .pl.
sub add_subtest {
        my %subtest_args = @_;
        print "Adding subtest: $subtest_args{'reg-cmd'})\n";
        my %subtest_info = get_subtest_info($subtest_args{'reg-cmd'});
        if (defined($subtest_info{Requirements})) {
                $subtest_args{'reg-add-resources'} = $subtest_info{Requirements};
        }
        if (defined($subtest_info{Timeout})) {
                $subtest_args{'reg-timeout'} = $subtest_info{Timeout};
        }
        if (!defined($subtest_args{'reg-subtest-rel-name'})) {
                my $subtest_name = $subtest_args{'reg-cmd'};
                $subtest_name =~ s/^stage[0-9]_//;
                $subtest_name =~ s/\.pl//;
                $subtest_args{'reg-subtest-rel-name'} = $subtest_name;
        }
        foreach my $k (keys %subtest_args) {
                print "$k => $subtest_args{$k}\n";
        }

	$subtest_args{'reg-subtest-random'} = '1';

        reg_add_subtest(%subtest_args);
}


##################### ITF functions ########################

sub itf_setup {
    # itf_setup executes at the start of every subtest
    # using if statements this function checks the environment of the subtest
    # ie the subtest running, files available, options set etc.
    # and sets options that control execution flow (like like a state machine)
    # or the event loop of a game
    
    my $subtest_name = ITF::get_subtest_option('subtest_name');
    ITF::itf_print_info("***** Entered function itf_setup in subtest \"$subtest_name\" *****");

    # Define common files to pass from parent tests to children tests
    ITF::pass_files_to_children($itf_common::EXPANDED_PARAMS_FILE);
    ITF::pass_files_to_children("*.xml");
    ITF::pass_files_to_children("$itf_common::INSTANCE_NAME.*");
    ITF::pass_files_to_children("*.sdc");

    # subroutine qsys_spawn_variant called before running qsys subtest, the line below passes qsys subtest the list of all qsys variants extracted from params.xml file
    ITF::register_function('qsys', 'get_variant_list', \&qsys_spawn_variant);
    # subroutine qsys_update_variant called at the start of qsys subtest, the line below updates the list of variants passed to qsys
    ITF::register_function('qsys', 'update_variant', \&qsys_update_variant);

    # before running qsyn modify the qsf file produced from qsys-script as it does not correctly set device and part number
    ITF::register_function('qsyn', 'run_pre_process_post_parent_update', \&delete_qsys_generated_qsf);

    # delete ocp tests if the device is stratix 10 or ocp resource not loaded
    #ITF::itf_print_info("**** Current subtest is:  $subtest_name ****");
    #my $itf_device = ITF::get_option('device', 'ITF');
    #ITF::itf_print_info("**** Current device is:  $itf_device ****");
    # In the line of code below, system returns 1 on fail
    # TODO: instead of system use itf_run_command
    # TODO: if itf_device == "" then defaults to deleting ocp, test which is wrong behaviour
    #if (($itf_device eq get_default_part("Stratix 10")) || system("arc job | grep -q 'qlicense/ocp'")) {
    #    ITF::itf_print_info("***** In device subtest, device is Stratix 10, delete ocp tests *****");
    #    ITF::delete_subtest("qasm","ocp");
    #}

    my $root_dir = cwd();
    my $qsys_script_list = [ "$itf_common::INSTANCE_NAME.tcl" ];
    # add the parameterized IP's qsys file to list of qsys script files that should be run
    ITF::set_option("qsys_script_list", "ITF", $qsys_script_list);

    # declare core.ip (which shall be created later) to be an ip to compile later.
    my $qsys_ip_list = [ "$itf_common::INSTANCE_NAME.ip" ];
    # add the ip parameter qsys file to list of files 
    ITF::set_option('qsys_ip_list', 'ITF', $qsys_ip_list);

    # TODO: setting below option disables synthesis and simulation filesets so
    # only enable if there is an example design!!!
    # ITF::set_option('enable_example_design_generation', 'ITF', $qsys_ip_list);

    # TODO: Talk to david sheldon, the current subtest spawn limit is not high enough
    # need to add a 10000 spawn test limit to ITF qsys subtest variants!
}

sub delete_qsys_generated_qsf {
    ITF::itf_print_info("***** Qsys run_pre_process_post_parent_update *****");
    ITF::itf_print_info("***** Delete qsf generated by qsys-script *****");
    my $qsf_filename = "$itf_common::INSTANCE_NAME.qsf";
    unlink($qsf_filename);

    if (-e $qsf_filename) {
      die "Could not delete $qsf_filename.";
    }
}

# This subroutine return reference to array of variant names
# to be run in qsys subtest
sub qsys_spawn_variant {
    # TODO: I should filter subtest by device and XML matches here

    # get options from reg_exe
    # the test_variant option is used when user wants to run a specific variant
    my $cmdline_variant = ITF::get_option('test_variant', 'ITF');
    # the params-file-name option is used when user wants to use a specific
    # variant XML template file instead of params.xml
    #
    # The template XML file defined the variants of DUT to test
    # The XML file can contain variations that are either generic or 
    # family-specific. We also use a user specified XML file if given.
    my $params_file_name = ITF::get_option('params-file-name', 'ITF');
    if (!$params_file_name) {
        $params_file_name = $itf_common::PARAMS_FILE;
    }

    ITF::itf_print_info("***** PARAMS_FILE_NAME is $params_file_name *****");

    # get all variations defined in the template XML file
    my @variation_names = keys(%{TestUtils::XML::get_parameterization_names(
                                                        $params_file_name
                                                    )});
    ITF::itf_print_info("***** Extracted ".scalar(@variation_names)." variations from XML file $params_file_name *****");
    if (scalar(@variation_names) == 0) {
        print "\n\n";
        print "ERROR: The XML file $params_file_name contains no variations\n";
        print "       that match the criteria specified by the command-line arguments.\n";
        print "       For example, if you specify --family=stratixv, you must ensure that\n";
        print "       the XML file contains at least one variation that either targets\n";
        print "       stratix or is non-family-specific. You must also ensure that the\n";
        print "       IP core supports stratixv.";
        print "\n\n";
        croak "No variation to test!";
    }   

    # Resolve all variations in XML file
    my $resolved_variations = {};
    $resolved_variations = itf_common::build_ip_variation_space(\@variation_names, "$params_file_name");

    # Write all expanded / resolved variations to an xml file for debug or passing to
    # qsys' child subtests.
    if (!TestUtils::XML::write_xml($itf_common::EXPANDED_PARAMS_FILE, $resolved_variations)) {
            croak "Internal Error: Could not write XML file $itf_common::EXPANDED_PARAMS_FILE\n";
    }

    # Yes, the code below works
    my @final_variation_names = keys(%{$resolved_variations});
    if (defined($cmdline_variant)) {
        ITF::itf_print_info("***** Running only reg_exe command line specified variant: $cmdline_variant *****");
        @final_variation_names = ($cmdline_variant);
    }

    if (scalar(@final_variation_names) == 0) {
      ITF::itf_print_info("***** VARIANT LIST BEFORE UPDATE_QSYS BLOCK IS EMPTY *****");
    } else {
      my $total = scalar(@final_variation_names);
      ITF::itf_print_info("***** The total number of varitions is $total *****");
      ITF::itf_print_info("***** VARIANT LIST BEFORE UPDATE_QSYS BLOCK IS: *****");
      ITF::itf_print_info("*****  @final_variation_names *****");
    }

    return \@final_variation_names;
    # TODO: for this function I should scrape the family name and multiplication out
    # as that is done by device

    # TODO: check if qpf file created has TOP_LEVEL_NAME => core.qsys(.ip)
    # DEVICE and opn
    # FAMILY and family name
}

# qsys_update_variant is run during the qsys subtest
# for every subtest. It creates a .ip qsys system using qsys-script
# and runs qsys-generate with synthesis and simulation options on the ip
# system.
sub qsys_update_variant {
    # this is the name of the variant being run
    my $variant_name = ITF::get_subtest_option('variant_name');
    # this is set in the local itf_regtest_local.pl file
    my $dut_name = ITF::get_option('dut_name');
    # TODO: add to VG based on top level module name
    ITF::set_option('vg_dut_list', 'VG', "$dut_name:$variant_name");

    # strip the appended subtest name
    ITF::itf_print_info("***** Running qsys on variant $variant_name *****"); # TODO: remove
    if (defined $variant_name) {
        ITF::itf_print_info("***** Running qsys-script and qsys-generate on variant $variant_name *****");
    } else {
        croak("Error: variant_name was not specified in qsys_update.\n");
    }

    my $ip_dir = $itf_common::IP_DIR;            # ip
    my $project_dir = $itf_common::PROJECT_DIR;         # proj
    my $instance_name = $itf_common::INSTANCE_NAME;      # core


    # get the variant's parameterization values
    my $parameters = TestUtils::XML::get_all_parameterization_values($itf_common::EXPANDED_PARAMS_FILE, $variant_name);
    my $flow_params = $parameters->{$XML_PARAM_TYPE_FLOW};
    my $ip_params = $parameters->{$XML_PARAM_TYPE_IP};
    my $family = $ip_params->{$itf_common::family_param_name}[0]{value};
    ITF::set_option('family', 'ITF', $family);

    # set the language for the qsys subtest
    my $lang = $flow_params->{'lang'}[0]{value};
    ITF::itf_print_info("***** languge in XML file for $variant_name is $lang *****");

    if (!defined($lang)) {
      ITF::itf_print_info("***** Current settings do not define language for IP generation, using VHDL. *****");
      ITF::itf_print_info("***** To set language, add a \"lang\" parameter into for test variant $variant_name. *****");
        # keep the default flow param language at vhdl
        $lang = "vhdl";
    }
    if ($lang eq "vhdl") {
        ITF::itf_print_info("***** Current language is set to \"vhdl\", disable all Verilog simulation subtests. *****");
        ITF::set_option('disable_verilog', 'ITF', 1);
        ITF::delete_subtest("qsys", "rtl_sim_vcs_vlg");
        ITF::delete_subtest("qsys", "rtl_sim_vcsmx_vlg");
        ITF::delete_subtest("qsys", "rtl_sim_msim_vlg");
        ITF::delete_subtest("qsys", "rtl_sim_msimae_vlg");
        ITF::delete_subtest("qsys", "rtl_sim_ncsim_vlg");
        ITF::delete_subtest("qsys", "rtl_sim_xcelium_vlg");
        ITF::delete_subtest("qsys", "rtl_sim_riviera_vlg");

        ITF::delete_subtest("qsyn", "rtl_sim_vcs_vlg");
        ITF::delete_subtest("qsyn", "rtl_sim_vcsmx_vlg");
        ITF::delete_subtest("qsyn", "rtl_sim_msim_vlg");
        ITF::delete_subtest("qsyn", "rtl_sim_msimae_vlg");
        ITF::delete_subtest("qsyn", "rtl_sim_ncsim_vlg");
        ITF::delete_subtest("qsyn", "rtl_sim_xcelium_vlg");
        ITF::delete_subtest("qsyn", "rtl_sim_riviera_vlg");

        ITF::delete_subtest("qsyn", "prefit_sim_vcs_vlg");
        ITF::delete_subtest("qsyn", "prefit_sim_vcsmx_vlg");
        ITF::delete_subtest("qsyn", "prefit_sim_msim_vlg");
        ITF::delete_subtest("qsyn", "prefit_sim_msimae_vlg");
        ITF::delete_subtest("qsyn", "prefit_sim_ncsim_vlg");
        ITF::delete_subtest("qsyn", "prefit_sim_xcelium_vlg");
        ITF::delete_subtest("qsyn", "prefit_sim_riviera_vlg");

        ITF::delete_subtest("qfit", "postfit_sim_vcs_vlg");
        ITF::delete_subtest("qfit", "postfit_sim_vcsmx_vlg");
        ITF::delete_subtest("qfit", "postfit_sim_msim_vlg");
        ITF::delete_subtest("qfit", "postfit_sim_msimae_vlg");
        ITF::delete_subtest("qfit", "postfit_sim_ncsim_vlg");
        ITF::delete_subtest("qfit", "postfit_sim_xcelium_vlg");
        ITF::delete_subtest("qfit", "postfit_sim_riviera_vlg");

    } elsif ($lang eq "verilog" ) { # $lang eq "verilog"
        ITF::itf_print_info("***** Current language is set to \"verilog\", disable all VHDL simulation subtests. *****");
        ITF::set_option('disable_vhdl', 'ITF', 1);

        ITF::delete_subtest("qsys", "rtl_sim_vcs_vhdl");
        ITF::delete_subtest("qsys", "rtl_sim_vcsmx_vhdl");
        ITF::delete_subtest("qsys", "rtl_sim_msim_vhdl");
        ITF::delete_subtest("qsys", "rtl_sim_msimae_vhdl");
        ITF::delete_subtest("qsys", "rtl_sim_ncsim_vhdl");
        ITF::delete_subtest("qsys", "rtl_sim_xcelium_vhdl");
        ITF::delete_subtest("qsys", "rtl_sim_riviera_vhdl");

        ITF::delete_subtest("qsyn", "rtl_sim_vcs_vhdl");
        ITF::delete_subtest("qsyn", "rtl_sim_vcsmx_vhdl");
        ITF::delete_subtest("qsyn", "rtl_sim_msim_vhdl");
        ITF::delete_subtest("qsyn", "rtl_sim_msimae_vhdl");
        ITF::delete_subtest("qsyn", "rtl_sim_ncsim_vhdl");
        ITF::delete_subtest("qsyn", "rtl_sim_xcelium_vhdl");
        ITF::delete_subtest("qsyn", "rtl_sim_riviera_vhdl");

        ITF::delete_subtest("qsyn", "prefit_sim_vcs_vhdl");
        ITF::delete_subtest("qsyn", "prefit_sim_vcsmx_vhdl");
        ITF::delete_subtest("qsyn", "prefit_sim_msim_vhdl");
        ITF::delete_subtest("qsyn", "prefit_sim_msimae_vhdl");
        ITF::delete_subtest("qsyn", "prefit_sim_ncsim_vhdl");
        ITF::delete_subtest("qsyn", "prefit_sim_xcelium_vhdl");
        ITF::delete_subtest("qsyn", "prefit_sim_riviera_vhdl");

        ITF::delete_subtest("qfit", "postfit_sim_vcs_vhdl");
        ITF::delete_subtest("qfit", "postfit_sim_vcsmx_vhdl");
        ITF::delete_subtest("qfit", "postfit_sim_msim_vhdl");
        ITF::delete_subtest("qfit", "postfit_sim_msimae_vhdl");
        ITF::delete_subtest("qfit", "postfit_sim_ncsim_vhdl");
        ITF::delete_subtest("qfit", "postfit_sim_xcelium_vhdl");
        ITF::delete_subtest("qfit", "postfit_sim_riviera_vhdl");
    } else {
        croak "Error: \"lang\" parameter for variant $variant_name has invalid value \"$lang\", use one of \"verilog\" or \"vhdl\""
    }

    ITF::set_option('language', 'ITF', $lang);

    itf_common::create_qsys_system($variant_name,"NATIVE","system_creation.rpt",$project_dir,$ip_dir);

    ITF::register_user_function('qfit', 'get_mem_resources', \&get_mem_resources_qfit);
    ITF::register_user_function('qsyn', 'get_mem_resources', \&get_mem_resources_qsyn);
}

# if there are no test-specific subtest scripts, do a default Quartus compile. 
# and if there is a test-specific Quartus compile, that needs to be done prior to
# running the other test-specific subtest scripts. 
#  my @subtests = grep(/stage3_.*\.pl$/,@files_in_current_dir);
#  my @quartus_compile_subtests = grep(/stage3_quartus_compile\.pl$/,@subtests);
#  my @other_subtests = grep(!/stage3_quartus_compile\.pl$/,@subtests);
#
#  $ENV{REG_NO_CLOBBER_REG_ROUT} = 1;
#  foreach my $subtest (@other_subtests) {
#    itf_common::add_subtest(
#      'reg-cmd' => $subtest,
#      'variation-name' => $variation_name
#      );
#
#}

sub get_mem_resources_qfit {
    my $family = ITF::get_option('family', 'ITF');
    return itf_common::get_ram_required($family);
}

sub get_mem_resources_qsyn {
    return '4000';
}


######################## XML functions #####################
# For a given XML parameter template file, build_ip_variation_space
# resolves all parameters with a list of values delimited by semi-colons i.e
# "value_1;value_2;value_3", creating its own XML element containing
# each distinct value
#
# $@variation_names - a reference to list of parameterization names in XML file
# $xml_file_name - a scalar to the xml file to be read
# $always_expand - always expand regardless if ";" in parameter value

sub build_ip_variation_space {
    my $variation_names = shift;
    my $XML_FILE_NAME = shift;
    my $always_expand = shift; #optional argument, undef will evaluate to false in conditionals

    _iprint ("XML: $XML_FILE_NAME\n");

    my $all_variations = {};
    
    foreach my $variation_name (@$variation_names) {
        my $variations = {};

        $variations->{$variation_name} = TestUtils::XML::get_all_parameterization_values ($XML_FILE_NAME, $variation_name);
        my $params = $variations->{$variation_name};
	    _iprint("Variation: $variation_name : \n");
        # Expand for type="ip"
        my $ip_params = $params -> {$itf_common::XML_PARAM_TYPE_IP};
        if(scalar keys %$ip_params > 0) {
	        foreach my $param (sort keys %$ip_params) {
	            _iprint("\tParam: $param : $ip_params->{$param}[0]{value}\n");
	            my $values = "";
	            $values = $ip_params->{$param}[0]{value};
            	if ($always_expand || $values =~ /;/) {
                my @vals = split(/;/, $values);
		            my $vals_ref = \@vals;
				        foreach my $sub_variation_name (keys(%$variations)) {
	            		_iprint("\t\tsubvar: $sub_variation_name\n");
				        my $sub_variation = $variations->{$sub_variation_name};
				        my $new_variations = TestUtils::XML::multiply_ip_params ( {
				                base_parameterization => $sub_variation,
				                base_parameterization_name => $sub_variation_name,
				                new_parameter_name => $param,
				                new_parameter_values => $vals_ref,
				#                new_parameterization_name_suffix => "$param",
				                replace_existing => 'TRUE' });
				        delete $variations->{$sub_variation_name};
					    foreach my $new_subvar (keys(%$new_variations)) {
				        	my $safe_subvar_name = $new_subvar;
                                                $safe_subvar_name =~ tr/,/_/;
				        	$new_variations->{$safe_subvar_name} = delete $new_variations->{$new_subvar};
					    	_iprint "\t\t\tExpanded Variation: $safe_subvar_name\n";
					    }
    					# print Dumper($variations);

						$variations = TestUtils::XML::append_parameterizations ($variations, $new_variations);
				    }
				}
	        }
			$all_variations = TestUtils::XML::append_parameterizations ($all_variations, $variations);
	    } else {
			$all_variations = TestUtils::XML::append_parameterizations ($all_variations, $variations);
	    }
    }
    $all_variations = filter_variations_by_edition($all_variations);
    #$all_variations = multiply_variations_by_families($all_variations);
    #$all_variations = set_variation_devices($all_variations);
    return $all_variations;
}


sub filter_variations_by_edition ($) {
    my ($variations) = @_;
    my $retval = {};

    foreach my $variation_name (keys(%$variations)) {
        my $variation = $variations->{$variation_name};
        my $flow_params = $variation->{$itf_common::XML_PARAM_TYPE_FLOW};		
        my $keep_variation = 0;

        if (!defined($flow_params->{$edition_filter_name})) {
            $keep_variation = 1;
        } else {
            foreach my $edition_filter (split(/;/, $flow_params->{$edition_filter_name}[0]{value})) {
                if(lc($edition_filter) eq "standard") {
                    $keep_variation = !(pro());
                } elsif(lc($edition_filter) eq "pro") {
                    $keep_variation = pro();
                } else {
                    die "Could not find any definition of Quartus edition filter: $edition_filter";
                }
            }
        }
        if ($keep_variation) {
            my $new_variation = TestUtilsSystem::Utils::BootstrapLoad::clone_object($variation);
            $retval->{$variation_name} = $new_variation;
        }
    }
    return $retval;
}

sub multiply_variations_by_families ($) {
    # TODO: I do not think this can handle format family = Stratix V; Arria 10 etc.
  	my ($variations) = @_;
  	my $retval = {};

  	foreach my $variation_name (keys(%$variations)) {
    		my $variation = $variations->{$variation_name};
    		my $ip_params = $variation->{$itf_common::XML_PARAM_TYPE_IP};
    		my $flow_params = $variation->{$itf_common::XML_PARAM_TYPE_FLOW};

        my $itf_device = ITF::get_option('device', 'ITF');

    		if (defined($ip_params->{$family_param_name})) {
            my $family = $ip_params->{$family_param_name}[0]{value};
            my $forced_device = get_default_part($family);
            ITF::itf_print_info("***** forced device in multiply_variations_by_families is $forced_device *****");
            my @families = get_supported_families();
      			if ( grep(/$family/, @families)) {
                if ($forced_device eq $itf_device) {
            				my $new_variation = TestUtilsSystem::Utils::BootstrapLoad::clone_object($variation);
            				$retval->{$variation_name} = $new_variation;
                } else {
                    ITF::itf_print_info("***** The variation $variation_name is removed in device variant $itf_device *****");
                }
      			} else {
        				print "Variation: $variation_name removed due to unsupported family ($family)\n";
      			}
    		} else {
            my @families_to_multiply = ();
      			if (defined($flow_params->{$family_expand_type})) { 
        				if (lc($flow_params->{$family_expand_type}[0]{value}) eq "qor") {
          					@families_to_multiply = get_qor_families();
        				} elsif(lc($flow_params->{$family_expand_type}[0]{value}) eq "hls") {
          					@families_to_multiply = get_hls_supported_families();
        				} elsif(lc($flow_params->{$family_expand_type}[0]{value}) eq "hls_qor") {
          					@families_to_multiply = get_hls_qor_families();
        				} elsif(lc($flow_params->{$family_expand_type}[0]{value}) eq "default") {
          					@families_to_multiply = get_default_family();
        				} elsif(lc($flow_params->{$family_expand_type}[0]{value}) eq "all") {
          					@families_to_multiply = get_supported_families();
        				} else {
          					die "Error: Could not find any definition of family expansion method: $flow_params->{$family_expand_type}[0]{value}";
        				}
      			} else {
        				reg_put_to_reg_rout ("Parameterization $variation_name does not specify a family or a method to calculate families");
      			}

            # filter the @families_to_multiply by the current subtest running
            my @itf_family = ();
            for my $family (@families_to_multiply) {
                my $device_opn = get_default_part($family);
                if ($itf_device eq $device_opn) {
                  push(@itf_family, $family);
                }
            }

            if (scalar(@itf_family) == 1) {
                ITF::itf_print_info("***** The subtest $variation_name will run on device $itf_device *****");
                my $family_specific_variations = TestUtils::XML::multiply_ip_params({
                    base_parameterization => $variation,
                    base_parameterization_name => $variation_name,
                    new_parameter_name => $family_param_name,
                    new_parameter_values => \@itf_family,
                    ignore_suffix_name => 1,
                    #new_parameterization_name_suffix => \@itf_family
                }); 
                $retval = TestUtils::XML::append_parameterizations($retval, $family_specific_variations);
            } elsif (scalar(@itf_family) > 1) {
                ITF::itf_print_error("***** Multiple families. *****");
            } else {
                ITF::itf_print_info("***** The variation $variation_name is removed in device variant $itf_device *****");
            }
    		}
  	}

  	return $retval;
}


sub set_variation_devices ($) {
  my ($variations) = @_;
  my $retval = {};

  foreach my $variation_name (keys(%$variations)) {
    my $variation = $variations->{$variation_name};
    my $ip_params = $variation->{$itf_common::XML_PARAM_TYPE_IP};
    my $flow_params = $variation->{$itf_common::XML_PARAM_TYPE_FLOW};
    if (!defined($ip_params->{$family_param_name})) {
      exit("Can't find device family - so can't set device automagically\n");
    }
    if (!defined($ip_params->{$device_param_name})) {
      $variations->{$variation_name}->{$itf_common::XML_PARAM_TYPE_IP}->{$device_param_name}[0]{value} = get_default_part($ip_params->{$family_param_name}[0]{value});
    } 
  }
  return $variations;
}

######################## Qsys ##############################

# TODO: switch errors to carp or itf_print_error
# create_qsys_system
sub create_qsys_system {
    my $variant_name = shift;
    my $environment_setting = shift;
    my $report_file = shift;      # file in which qsys-script report goes 
    my $quartus_project = shift;  # name of the quartus project
    my $ip_dir = shift;   # the ip dir which stores output tcl files

    # make the ip directory in which all files shall be output
    my $root_dir = cwd(); 
    #mkdir $ip_dir;
    #chdir $ip_dir;

    my $environment = "QSYS";
    if (defined($environment_setting)) {
      if (lc($environment_setting) eq "native") {
        $environment = "NATIVE";
      }
    }


    my $variation = TestUtils::XML::get_all_parameterization_values($itf_common::EXPANDED_PARAMS_FILE, $variant_name);
    my $flow_params = $variation->{$itf_common::XML_PARAM_TYPE_FLOW};
    my $ip_params = $variation->{$itf_common::XML_PARAM_TYPE_IP};

    ITF::itf_print_info("***** Writing Qsys Script *****");
    my $script_name = "$itf_common::INSTANCE_NAME.tcl";
    open(my $file_handle, '>', $script_name) or die "Error: Could not open $script_name to create our script";

    print $file_handle "package require -exact qsys 16.0 \n";
    #my $device_family = $ip_params->{$family_param_name}[0]{value};
    #print $file_handle qq(set_project_property DEVICE_FAMILY "$device_family" \n);
    #my $device_opn = $ip_params->{$device_param_name}[0]{value};
    my $itf_device = ITF::get_option('device', 'ITF');
    print $file_handle qq(set_project_property DEVICE "$itf_device" \n);
    print $file_handle "add_instance core $flow_params->{ip_core}[0]{value} \n";
    print $file_handle "set_instance_property core auto_export true \n";
    # We just auto-export all the interfaces like an independent IP
    for my $ip_key (keys %$ip_params) {
        my $ip_value = $ip_params->{$ip_key}[0]{value};

        if (!(($ip_key eq $family_param_name) || ($ip_key eq $device_param_name))) {
            ITF::itf_print_info("***** IP parameter $ip_key = $ip_value *****");
            print $file_handle qq(set_instance_parameter_value core $ip_key "$ip_value" \n);
        }
    }

    # TODO: to optionally run subtests, put them in flow.txt and conditionally delete them

    # TODO: this line below throws qsys-script error, but it should not... check with 17.1
    # print $file_handle "set_instance_parameter_value core design_env $environment\n";
    print $file_handle "save_system $INSTANCE_NAME.ip\n"; # TODO: why is this saving .qsys and not .ip, unlike eth?
    close $file_handle or die "Could not close $script_name.";

    # TODO: no ITF option given to specify project when calling qsys-script, should I care about that?
}



# When generating files, Qsys decorates their name with the core instance name, IP name, an instance
# number, and a 7-character hash. 
# e.g. the decorated version of the cic's test_program.sv is (in the common flow) something like
#      core_altera_cic_ii_171_cpqwxsa_test_program.sv
# Given the original file name and a path containing the decorated form of the name, returns the 
# decoration, which in this case would be core_altera_cic_ii_cpqwxsa.
sub qsys_decoration_of_file {
   my $original_file_name = shift(@_);
   my $decorated_file_path = shift(@_);
   my $volume;
   my $directories;
   my $file; 
   ($volume, $directories, $file) = File::Spec->splitpath($decorated_file_path);
   $file =~ /^(.*)_${original_file_name}$/;
   my $decoration = $1;
   return $decoration
}

# In Pro, Qsys places the RTL files in a subdirectory the name of which is based on the name of the core
# and the Quartus version. Rather than hard-coding this, the Qsys-generated core.xml file is grepped
# find the location of the defines.h file. 
# NB core.xml does not reflect files in the simulation fileset. 

sub find_qsys_generated_file {
   my $file_name = shift(@_);
   my $ip_dir = $itf_common::IP_DIR;             
   my $project_dir = $itf_common::PROJECT_DIR;             
   my $instance_name = $itf_common::INSTANCE_NAME;  
   my $core_xml = "$ip_dir/$instance_name/$instance_name.xml";

   my $grep_for_file_cmd = "grep $file_name $core_xml | sort -u | cut -d '\"' -f 2";

   my $file_path = `$grep_for_file_cmd 2>&1`;
   if ($file_path eq "") {
       _iprint("Error : $file_name is not listed in $core_xml or $core_xml does not exist");
   }
   return $file_path;
}

# A different approach to find the file via a directory scan of the generated simulation file
sub find_qsys_generated_simulation_file {
   my $file_name = shift(@_);
   my $ip_dir = $itf_common::IP_DIR;             
   my $project_dir = $itf_common::PROJECT_DIR;             
   my $instance_name = $itf_common::INSTANCE_NAME;  
   my $search_pattern = "${ip_dir}/${instance_name}/altera*/sim/*${file_name}";

   my $file_path = `ls ${search_pattern}`;
   if ($file_path eq "") {
       _iprint("Error : could not find a file patching the pattern ${search_pattern}");
   }
   return $file_path;
}

1;

