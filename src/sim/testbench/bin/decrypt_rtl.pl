#!/usr/bin/env perl
#===============================================================================
# Copyright (c) Programmable Solutions Group (PSG),
# Intel Corporation 2016 - present.
# All rights reserved.
#
# Description: Script that decrypt the encrypted RTL files
#
#-------------------------------------------------------------------------------
# TB/UVC Skeleton is created by: utbgen
#===============================================================================

#===============================================================================
# Perl libs to be used in this script.
#===============================================================================
use Cwd;
use Getopt::Long;
#-- Calling RUNSIM module to get access to its local variables
use PhvUtils::Common qw(%opt %var);

PhvUtils::Common::info_line("PHV_TOOLS_HOME=$ENV{PHV_TOOLS_HOME}\n");

#===============================================================================
#  Begin Program
#===============================================================================
my $orgpwd = $PWD;
my $resources = `arc job resources`; chomp($resources);
my $phv_tools = "phv_tools" if !($resources =~ m/phv_tools/);
GetOptions("variant=s"  => \$variant,
           "results=s"  => \$results);

if ($results eq "") {
   $results = "results";
}

$dir = "./$results/$variant/ipgen/submodules";
@encrypt_files = (
##//////////////////////////////////////////////////////##
## TODO: put the RTL files that need to be de-crypted.  ##
## <<example>>:                                         ##
## "macsec.sv",                                    ##
##//////////////////////////////////////////////////////##
);

foreach $efile (@encrypt_files) {
   PhvUtils::Common::cmd("/tools/cpt/linux32/cpt_altera_decrypt $dir/$efile".
                         "> /dev/null");
}
