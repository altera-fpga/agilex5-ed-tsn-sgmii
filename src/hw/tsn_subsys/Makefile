########################################################################
# copyright
#
#
########################################################################


################## USER TOPLEVEL CONFIGURATION ##########################
#
# <-
#   TSN_EN :
#       - 0: disable
#       - 1: enable [default]
#   TSN_CONCURRENT :
#       - 0: disable[default]
#       - 1: enable 
# ->
#
#########################################################################


MAKE      := make
PWD       := $(shell pwd)
EMPTY     :=
ENABLE    := 1
DISABLE   := 0
SLASH     := /
SPACE     := 
#TSN_EN    := 1
#TSN_CONCURRENT := 1

CURRENT_FOLDER     :=  $(lastword $(subst $(SLASH), $(SPACE),$(PWD)))
PROJECT_ROOT       :=  $(PWD)/../
GHRD_CONFIG_FILE   :=  $(PROJECT_ROOT)/build/config.$(CURRENT_FOLDER)
GHRD_HELP_FILE     :=  $(PROJECT_ROOT)/build/help.$(CURRENT_FOLDER)
GHRD_SCRIPT_FILE   :=  $(PROJECT_ROOT)/scripts/config_parzer.awk


#SUB_QSYS_TCL_ARG  += set current_folder $(CURRENT_FOLDER);
#QSYS_TCL_ARGS += set current_folder $(CURRENT_FOLDER);
#$(info ammended qsys_tcl_arg is $(QSYS_TCL_ARGS))

.PHONY: generate_from_tcl
generate_from_tcl:
ifeq ($(and $(TSN_EN),$(TSN_CONCURRENT)), $(ENABLE))
	    @qsys-script $(shell echo $(QSYS_ARGS) | sed 's/quartus-project=/quartus-project=..\//g') --script=./construct_concurrent_subsys_tsn.tcl --cmd="$(QSYS_TCL_ARGS)"
	    @echo "TSN Concurrent subsystem generated!"
else ifeq ($(TSN_EN),$(ENABLE))
	    @qsys-script $(shell echo $(QSYS_ARGS) | sed 's/quartus-project=/quartus-project=..\//g') --script=./construct_subsys_tsn.tcl --cmd="$(QSYS_TCL_ARGS)"
	    @echo "TSN subsystem generated!"
else
	    @echo "$(CURRENT_FOLDER) does not be enabled, skip."
        endif

	@echo "generate_from_tcl for $(CURRENT_FOLDER)!"

.PHONY: config
config:
	@awk -v config_file=$(GHRD_CONFIG_FILE) -v help_file=$(GHRD_HELP_FILE) -f $(GHRD_SCRIPT_FILE) Makefile

