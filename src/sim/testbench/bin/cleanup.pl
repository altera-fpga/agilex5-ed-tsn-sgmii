#!/usr/bin/env perl

## To post sim clean up
use strict;
use Getopt::Long;

my $testrundir;

GetOptions("dir=s"  => \$testrundir);

##system("rm -rf $testrundir/xprop_config.report");
##system("rm -rf $testrundir/cm.log");
##system("rm -rf $testrundir/altuvm_sva.out");
##system("rm -rf $testrundir/altuvm_hier.out");
##system("rm -rf $testrundir/altuvm_parg.out");
##system("rm -rf $testrundir/ucli.*");

#------------------------------------------------------------------------------
# Zip the waveform file after finished running simulation.
#------------------------------------------------------------------------------
my $fsdb_file = `find $testrundir -name \*fsdb | wc -l`;
if ($fsdb_file != 0) {
   system("find $testrundir -name \*.fsdb.gz | xargs -n1 -i rm -rf {}");
   system("find $testrundir -name \*.fsdb    | xargs -n1 -i gzip   {}");
}
else {
   my $vpd_file  = `find $testrundir -name \*vpd | wc -l`;
   if ($vpd_file != 0) {
      system("find $testrundir -name \*.vpd.gz | xargs -n1 -i rm -rf {}");
      system("find $testrundir -name \*.vpd    | xargs -n1 -i gzip   {}");
   }
}

exit;
