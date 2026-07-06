#!/usr/bin/env perl

#These give you extra warnings/errors your perl code.  Don't remove them!
use strict;
use warnings;

#Package for SWIP RegTest functions 
use RegTest;

require "$ENV{ITF_ROOT}/itf.pl";

#run ITF
ITF::run_itf();
##################

1;
