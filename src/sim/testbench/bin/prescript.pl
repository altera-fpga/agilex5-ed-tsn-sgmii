#!/usr/bin/env perl
#===============================================================================
# Copyright (c) Programmable Solutions Group (PSG),
# Intel Corporation 2016 - present.
# All rights reserved.
#
# Description: Prescript to generate the register files (RTL and UVM)
#
#-------------------------------------------------------------------------------
# TB/UVC Skeleton is created by: utbgen
#===============================================================================

#===============================================================================
# Perl libs to be used in this script.
#===============================================================================
use Cwd;
#-- Calling RUNSIM module to get access to its local variables
use PhvUtils::Common qw(%opt %var);

PhvUtils::Common::info_line("PHV_TOOLS_HOME=$ENV{PHV_TOOLS_HOME}\n");

#===============================================================================
#  Begin Program
#===============================================================================
my $orgpwd = $PWD;
my $resources = `arc job resources`; chomp($resources);
my $phv_tools = "phv_tools" if !($resources =~ m/phv_tools/);

#-------------------------------------------------------------------------------
# First Task
#-------------------------------------------------------------------------------
##////////////////////////////////////////////////////////////////////##
## TODO: Add the first task here.                                     ##
## <<example>>:                                                       ##
##PhvUtils::Common::cmd(                                              ##
##   "arc shell --watch $phv_tools -- ".                              ##
##   "csrgen -r $rdl_path/macsec_reg.rdl -mre csr_synchronous_reset ".  ##
##   "-o $var{result_dir} -no_cleanup -c ab");                        ##
##////////////////////////////////////////////////////////////////////##

sleep 2;

#-------------------------------------------------------------------------------
# Second Task
#-------------------------------------------------------------------------------
chdir "$ENV{RUNSIM_PROJDIR}/bin";
##////////////////////////////////////////////////////////////////////##
## TODO: Add the second task here.                                    ##
## <<example>>:                                                       ##
##PhvUtils::Common::cmd("perl ./decrypt_rtl.pl -r XXX");              ##
##////////////////////////////////////////////////////////////////////##
chdir $orgpwd;

1;
