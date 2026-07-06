#!/usr/bin/env perl

###########################################################################
# This is the main entry point to the regtest. Here we will 
# spawn the first regtest stage to perform QII compile for
# a set of families (or the specified family).
#
###########################################################################

#!/usr/bin/env perl

#These give you extra warnings/errors your perl code.  Don't remove them!
use strict;
use warnings; 

#Package for SWIP RegTest functions 
use RegTest;

require "$ENV{ITF_ROOT}/itf.pl";

#run ITF
ITF::run_itf();

# Keep the line below
1;

