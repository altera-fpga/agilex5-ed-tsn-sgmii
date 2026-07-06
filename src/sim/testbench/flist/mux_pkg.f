//==============================================================================
// Copyright (c) Programmable Solutions Group (PSG),
// Intel Corporation 2016 - present.
// All rights reserved.
//
// Description: Generic compile file file list definition for library
//              mux_pkg
//
//==============================================================================

// Compile options

// Include Directories
+incdir+$UVM_HOME/src
+incdir+$ALTUVM_BCL_HOME/src
+incdir+$MUX_HOME/results
+incdir+$MUX_HOME/testbench/define
+incdir+$MUX_HOME/testbench/uvc/env
+incdir+$MUX_HOME/testbench/uvc/interface
+incdir+$MUX_HOME/testbench/uvc/register
+incdir+$MUX_HOME/testbench/uvc/sequences
+incdir+$MUX_HOME/testbench/uvc
+incdir+$MUX_HOME/testbench/spy
+incdir+$MUX_HOME/testbench/tb
+incdir+$MUX_HOME/testbench/tb/rtb

// File lists
$MUX_HOME/testbench/uvc/mux_pkg.sv
$MUX_HOME/testbench/tb/rtb/mux_rtb.sv
