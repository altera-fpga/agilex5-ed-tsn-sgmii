#!/usr/bin/env perl

use strict;
use Getopt::Long;

my $testrundir;
my $regress;

GetOptions("dir=s"     => \$testrundir,
           "regress=i" => \$regress);

chdir($testrundir);

#-----------------------------------------------------------------------------------------
#First task: To further check the error keyword from files besides the logs/simulation.log
#-----------------------------------------------------------------------------------------
#example command to grep the error keyword from all the files generated in test run.
#system("grep -H \"ERROR\\\|WARN\\\|FATAL\\\|FAIL\" `find . -maxdepth 1 -type f`");


#-----------------------------------------------------------------------------------------
#Second task: when $regress = 1, further remove or gzip the files to save disk space
#-----------------------------------------------------------------------------------------
if($regress == 1) {
   my @filelist_withfolder = `ls logs`;
   my @filelist = `ls -p | grep -v /`;
   my $passflag = 0;
   my @tokeep   = undef;
   my @toremove = undef;
   
   my $pwd = `pwd`;
   print "$pwd\n";

   while (@filelist_withfolder) {
      my $file2=shift(@filelist_withfolder);
      chomp($file2);
      if($file2 =~ /simulation.PASS/) {
         print "SEE $file2\n";
      	$passflag = 1;
      }
   }   
   while (@filelist) {
      my $file=shift(@filelist);
      chomp($file);
      print "SEE $file\n";
      if    ($file =~ /vdb/)          { push(@tokeep,$file); }
      elsif ($file =~ /avatar.cmd/)   { push(@tokeep,$file); }
      elsif ($file =~ /dumpwsf.info/) { push(@tokeep,$file); }
      elsif ($file =~ /.PASS/)        { push(@tokeep,$file); }
      elsif ($file =~ /.builder/)     { push(@tokeep,$file); }      
      elsif ($file =~ /log/)          { push(@tokeep,$file); }
      else                            { push(@toremove,$file); }
   }
   
   if ($passflag == 1) {
      while (@toremove) {
      	my $fileremove=shift(@toremove);
      	chomp($fileremove);
      	`rm -fr $fileremove`;
      	print "[INFO] Removing $fileremove\n";	
      }
   }
}
exit;
