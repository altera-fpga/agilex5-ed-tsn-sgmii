-------------------
DIRECTORY STRUCTURE:
-------------------

There needs to be a dirctory structure similar to this:
/REGRESSION_RESULTS/ folder which has the following directories:
RESULT SCRIPT COVERAGE MERGED_COVERAGE
In each of these 4 directories (except in script, create if needed):
subdirectories for different modes or rates eg. ANLT or NON_ANLT or 25G, 10G etc. directories.
In the coverage directories COVERAGE, say eg. REGRESSION_RESULT/COVERAGE/ANLT/
Create 2 directories: ACC_COVERAGE (which will have the sim.vdbs under each day say Mon, Tue etc) and LATEST (which will have the current sim.vdb, and will be copied to ACC_COV once the regression is completed)

...............................................................................................................................................................................................................................
Changes to be made in scripts:

---------------
Regression.sh
---------------
Paths:

1. $WORK_AREA: To check if sufficient diskspace is available. Your work area path can be provided
eg. WORK_AREA="/nfs/sc/disks/swip_sipeth_1/users/muralasx/"

2. $MODEL_ROOT:The path where your local qshell (p4 directory) resides or in case of sourcing a qshell, the acds directory
eg. MODEL_ROOT="/nfs/sc/disks/swip_sipeth_1/users/muralasx/GDR/depot/acds"

3. $P4_ROOT: The directories in this path will be synced from perforce while running the script 
eg. P4_ROOT="$WORK_AREA/GDR_7_30/depot"

4.$SCRIPT_PATH: The path where these scripts are copied
eg SCRIPT_PATH="/nfs/sc/disks/swip_sipeth_1/users/muralasx/GDR/REGRESSION_RESULT/SCRIPT"

5.$COV_PATH: If coverage is enabled, the sim.vdb will initially reside in this path.
Note: Please create "LATEST" directory in the desired coverage path
Please do not add '/' after "LATEST"
eg. COV_PATH="/nfs/sc/disks/swip_sipeth_1/users/muralasx/GDR/REGRESSION_RESULT/RESULT/regtest/ip/ethernet/alt_ethernet_crete_gdr/qhip/scripts/funct_deterministic/GDR_RUN"

6. $RESULT_PATH: The path where the result of the regression is available
Please add '/' after $RESULT_PATH
eg. RESULT_PATH="/nfs/sc/disks/swip_sipeth_1/users/muralasx/GDR/REGRESSION_RESULT/RESULT/"

7. $ETH_ROOT: The path to the reg_exe run directory
Note: it is such that $ETH_ROOT/device*/qsys* 
eg. ETH_ROOT="$MODEL_ROOT/main/regtest/ip/ethernet/alt_ethernet_crete_gdr/qhip/scripts/funct_deterministic/GDR_RUN"

8.$IPATH: the path where the vdbs to be merged are accumulated.
Note: Here the directory is named "ACC_COV".After each new run, the vdb present in LATEST is moved to IPATH under the folder named that day of the week when it was run.
eg. IPATH="/nfs/sc/disks/swip_sipeth_1/users/muralasx/GDR/REGRESSION_RESULT/COVERAGE/ACC_COV"

9.$OPATH: the path where the merged vdbs can be found with the run date
eg. OPATH="/nfs/sc/disks/swip_sipeth_1/users/muralasx/GDR/REGRESSION_RESULT/MERGED_COV"

10.$EXC_PATH: If merging vdbs with exclusion, the exclusion file path is provided here
eg. EXC_PATH="$MODEL_P4_ROOT/testbench/coverage_excl/common/"

11.Edit the path for the location of perl script in the last line of Regression.sh

Variables:

1. cov =1 or 0 will enable or disable coverage
2. VAR = the variant name for which regression is run
3. PROJ = name of the project
4. exc= 1 or 0 to enable or disable run with exclusion
5. ntitle= title for the type of run

Regression Command:

This command can be updated for specific runs

------------------------
result.pl
------------------------
I. In this file: 5 file paths need to be provided.
They are:
1. A .csv file which has all the coverage information,previous as well as current one. It is under the variable name :res_file
eg. $res_file= '/nfs/sc/disks/swip_sipeth_1/users/muralasx/GDR/REGRESSION_RESULT/files/gdr_*{variant_name}*.csv';
2. A .csv file that has all the failed sequences and the path to the failed sequences along with the first error 
eg. $reg_file= '/nfs/sc/disks/swip_sipeth_1/users/muralasx/GDR/REGRESSION_RESULT/files/regression_run_status.csv';
3. This is a text file which has all the errors for a particular run
eg. $errorlist='/nfs/sc/disks/swip_sipeth_1/users/muralasx/GDR/REGRESSION_RESULT/files/error_list.txt';
4. This file is the body of the email that will be received at the end of the run
eg. $mailfile='/nfs/sc/disks/swip_sipeth_1/users/muralasx/GDR/REGRESSION_RESULT/files/mailfile.txt';
5. This is common file for a particular project and needs to be copieed in a suitable location.
eg. $ignorelist='/nfs/sc/disks/swip_sipeth_1/users/muralasx/GDR/NEWIP/REGRESSION_RESULT/files/ignorelist.txt';

II. In the script, search for the sub routine "find_txt". In the "if" statement, replace "test_itf" with the regression run directory name.

eg.sub find_txt {
    my ($string) = @_;
    my $F = $File::Find::name;

    #Push into sip sequence if exist, add the test_itf path here
    if ($F =~ /GDR_RUN\/.*\/rtl_sim_compile_only_vcs\/.*sequence__(.*_seq.*)\/rtl_sim_simulate_only_vcs__(.*)\/$string/g ) { 
            
III. In the end of the script, add the required mail ids 
==============================================================================


#####################################################
 Capture signature & coverage for local runs:
#####################################################
1) cd GDR_RUN (it should be your regression directory)
2) perl ../common/regression_scripts/result.pl -regPath=<Run directory full path> -local_run=1 -cov_enable=1
   ex : perl ../common/regression_scripts/result.pl -regPath=/nfs/sc/disks/swuser_work_ssushmit/4feb/acds/main/regtest/ip/ethernet/alt_ethernet_crete_gdr/qhip/scripts/funct_deterministic/GDR_RUN -local_run=1 -cov_enable=1


#####################################################
Consolidated XLS for all the GDR VARIANTS
#####################################################
1) Consolidated XLS is created using the .csv files of all the variants .
2) The .csv files are stored in ALL_CSV folder under GDR_REPORT.
    PATH: /nfs/sc/disks/gdr_regression_3/users/GDR_REPORT/ALL_CSV
3) cd GDR_RUN (it should be your regression directory)
4) perl ../common/regression_scripts/gdr_consolidated.pl
5) To view Consolidated XLS 
   gnumeric /nfs/sc/disks/gdr_regression_3/users/GDR_REPORT/gdr_consolidatedreport.xls



#####################################################################################################################
##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      CRONTAB commands            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%##
#####################################################################################################################
step 1 : login to sjcron machine
         % ssh sjcron02.sc.intel.com
step 2 : open crontab
         % crontab -e
step 3 : update crontab commands

########################################################################################################
########################################     MAC Variants  #############################################
########################################################################################################

##%%%%%%%%%%%%%%%%%%%%%%%%#
#-------- MAC LV  --------#
##%%%%%%%%%%%%%%%%%%%%%%%%#
##ETH_7
30 04 * * 5 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,vcs/Q-2020.03-SP2-2,synopsys_verdi/Q-2020.03,python_altera/2.7.3b/1.0,flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression.sh "--topology=7" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/MAC_ETH_7.log 2>&1

##ETH_16
30 09 * * 5 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,vcs/Q-2020.03-SP2-2,synopsys_verdi/Q-2020.03,python_altera/2.7.3b/1.0,flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression.sh "--topology=16" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/MAC_ETH_16.log 2>&1

##ETH_4
30 14 * * 5 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,vcs/Q-2020.03-SP2-2,synopsys_verdi/Q-2020.03,python_altera/2.7.3b/1.0,flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression.sh "--topology=4" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/MAC_ETH_4.log 2>&1

##ETH_13
30 19 * * 5 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,vcs/Q-2020.03-SP2-2,synopsys_verdi/Q-2020.03,python_altera/2.7.3b/1.0,flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression.sh "--topology=13" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/MAC_ETH_13.log 2>&1

##ETH_5 
30 23 * * 5 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,vcs/Q-2020.03-SP2-2,synopsys_verdi/Q-2020.03,python_altera/2.7.3b/1.0,flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression.sh "--topology=5" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/MAC_ETH_5.log 2>&1

##ETH_9
30 04 * * 6 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,vcs/Q-2020.03-SP2-2,synopsys_verdi/Q-2020.03,python_altera/2.7.3b/1.0,flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression.sh "--topology=9" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/MAC_ETH_9.log 2>&1

##%%%%%%%%%%%%%%%%%%%%%%%%#
#----- MAC NON LV  -------#
##%%%%%%%%%%%%%%%%%%%%%%%%#
##10_2
30 06 * * 5 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3,regutils/21.3,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,vcs/Q-2020.03-SP2-2,synopsys_verdi/Q-2020.03,python_altera/2.7.3b/1.0,flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=10_2" "--type=GDR_P0" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" > /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/MAC_ETH_10_2.log 2>&1

##10_3
30 08 * * 5 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3,regutils/21.3,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,vcs/Q-2020.03-SP2-2,synopsys_verdi/Q-2020.03,python_altera/2.7.3b/1.0,flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=10_3" "--type=GDR_P0" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" > /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/MAC_ETH_10_3.log 2>&1

##ETH_12
30 10 * * 5 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3,regutils/21.3,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,vcs/Q-2020.03-SP2-2,synopsys_verdi/Q-2020.03,python_altera/2.7.3b/1.0,flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=12" "--type=GDR_P0" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" > /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/MAC_ETH_12.log 2>&1

##25_4
30 12 * * 5 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license, acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3,cygwin/2.9.0,altuvm/0.9p8,synopsys_verdi/Q-2020.03-SP2,vcs/Q-2020.03-SP2-2,python_altera/2.7.3b/1.0,flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=25_4" "--type=GDR_P0" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/MAC_25_4.log 2>&1

##25_10
30 14 * * 5 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license, acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3,cygwin/2.9.0,altuvm/0.9p8,synopsys_verdi/Q-2020.03-SP2,vcs/Q-2020.03-SP2-2,python_altera/2.7.3b/1.0,flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=25_10" "--type=GDR_P0" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/MAC_25_10.log 2>&1

##ETH_1
30 16 * * 5 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3,regutils/21.3,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,vcs/Q-2020.03-SP2-2,synopsys_verdi/Q-2020.03,python_altera/2.7.3b/1.0,flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=1" "--type=GDR_P0" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" > /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/MAC_ETH_1.log 2>&1

##25_5
30 18 * * 5 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3,regutils/21.3,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,vcs/Q-2020.03-SP2-2,synopsys_verdi/Q-2020.03,python_altera/2.7.3b/1.0,flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=25_5" "--type=GDR_P0" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" > /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/MAC_25_5.log 2>&1

##ETH_17
30 20 * * 5 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3,regutils/21.3,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,vcs/Q-2020.03-SP2-2,synopsys_verdi/Q-2020.03,python_altera/2.7.3b/1.0,flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=17" "--type=GDR_P0" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" > /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/MAC_ETH_17.log 2>&1

##40_2
30 22 * * 5 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3,regutils/21.3,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,vcs/Q-2020.03-SP2-2,synopsys_verdi/Q-2020.03,python_altera/2.7.3b/1.0,flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=40_2" "--type=GDR_P0" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" > /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/MAC_40_2.log 2>&1

##40_3
00 01 * * 6 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3,regutils/21.3,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,vcs/Q-2020.03-SP2-2,synopsys_verdi/Q-2020.03,python_altera/2.7.3b/1.0,flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=40_3" "--type=GDR_P0" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" > /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/MAC_40_3.log 2>&1

##50_1
00 03 * * 6 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license, acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3,cygwin/2.9.0,altuvm/0.9p8,synopsys_verdi/Q-2020.03-SP2,vcs/Q-2020.03-SP2-2,python_altera/2.7.3b/1.0,flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=50_1" "--type=GDR_P0" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/MAC_50_1.log 2>&1

##50_10
00 05 * * 6 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license, acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3,cygwin/2.9.0,altuvm/0.9p8,synopsys_verdi/Q-2020.03-SP2,vcs/Q-2020.03-SP2-2,python_altera/2.7.3b/1.0,flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=50_10" "--type=GDR_P0" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/MAC_50_10.log 2>&1

##ETH_10
00 07 * * 6 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license, acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3,cygwin/2.9.0,altuvm/0.9p8,synopsys_verdi/Q-2020.03-SP2,vcs/Q-2020.03-SP2-2,python_altera/2.7.3b/1.0,flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=10" "--type=GDR_P0" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/MAC_10.log 2>&1

##50_11
00 09 * * 6 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license, acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3,cygwin/2.9.0,altuvm/0.9p8,synopsys_verdi/Q-2020.03-SP2,vcs/Q-2020.03-SP2-2,python_altera/2.7.3b/1.0,flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=50_11" "--type=GDR_P0" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/MAC_50_11.log 2>&1

##ETH_15
00 11 * * 6 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_vip_common/vip_R-2020.09B,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2,python_altera/2.7.3b/1.0 -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=15" "--type=GDR_P0" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu/" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/MAC_15.log 2>&2 

##50_3
00 13 * * 6 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_vip_common/vip_R-2020.09B,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2,python_altera/2.7.3b/1.0 -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=50_3" "--type=GDR_P0" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu/" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/MAC_50_3.log 2>&2

##ETH_8
00 15 * * 6 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_vip_common/vip_R-2020.09B,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2,python_altera/2.7.3b/1.0 -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=8" "--type=GDR_P0" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu/" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/MAC_8.log 2>&2

##100_4
00 17 * * 6 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_vip_common/vip_R-2020.09B,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2,python_altera/2.7.3b/1.0 -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=100_4" "--type=GDR_P0" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu/" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/MAC_100_4.log 2>&2

##ETH_2
00 19 * * 6 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_vip_common/vip_R-2020.09B,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2,python_altera/2.7.3b/1.0 -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=2" "--type=GDR_P0" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu/" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/MAC_2.log 2>&2

##100_12
00 21 * * 6 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_vip_common/vip_R-2020.09B,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2,python_altera/2.7.3b/1.0 -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=100_12" "--type=GDR_P0" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu/" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/MAC_100_12.log 2>&2

##ETH_14
00 23 * * 6 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_vip_common/vip_R-2020.09B,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2,python_altera/2.7.3b/1.0 -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=14" "--type=GDR_P0" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu/" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/MAC_14.log 2>&2

##100_3
00 01 * * 7 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_vip_common/vip_R-2020.09B,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2,python_altera/2.7.3b/1.0 -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=100_3" "--type=GDR_P0" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu/" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/MAC_100_3.log 2>&2 

##100_8
00 03 * * 7 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_vip_common/vip_R-2020.09B,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2,python_altera/2.7.3b/1.0 -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=100_8" "--type=GDR_P0" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu/" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/MAC_100_8.log 2>&2 

##200_2
00 05 * * 7 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_vip_common/vip_R-2020.09B,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2,python_altera/2.7.3b/1.0 -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=200_2" "--type=GDR_P0" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu/" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/MAC_200_2.log 2>&2

##ETH_11
00 07 * * 7 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_vip_common/vip_R-2020.09B,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2,python_altera/2.7.3b/1.0 -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=11" "--type=GDR_P0" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu/" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/MAC_11.log 2>&2

##200_1
00 09 * * 7 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_vip_common/vip_R-2020.09B,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2,python_altera/2.7.3b/1.0 -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=200_1" "--type=GDR_P0" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu/" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/MAC_200_1.log 2>&2 

##ETH_3
00 11 * * 7 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_vip_common/vip_R-2020.09B,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2,python_altera/2.7.3b/1.0 -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=3" "--type=GDR_P0" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu/" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/MAC_3.log 2>&2

##ETH_18
00 13 * * 7 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_vip_common/vip_R-2020.09B,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2,python_altera/2.7.3b/1.0 -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=18" "--type=GDR_P0" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu/" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/MAC_18.log 2>&2



########################################################################################################
########################################     PCS Variants  #############################################
########################################################################################################

##%%%%%%%%%%%%%%%%%%%%%%%%#
#-------- PCS LV  --------#
##%%%%%%%%%%%%%%%%%%%%%%%%#
##ETH_6
00 14 * * 7 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125, p4/psgeng,perl/5.8.8, testutils/21.3/, regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2, python_altera/2.7.3b/1.0, flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression.sh "--topology=6" "--type=GDR_PCS" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/PCS_6.log 2>&1

##25_6
00 16 * * 7 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125, p4/psgeng,perl/5.8.8, testutils/21.3/, regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2, python_altera/2.7.3b/1.0, flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression.sh "--topology=25_6" "--type=GDR_PCS" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/PCS_25_6.log 2>&1

##50_11
00 18 * * 7 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125, p4/psgeng,perl/5.8.8, testutils/21.3/, regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2, python_altera/2.7.3b/1.0, flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression.sh "--topology=50_11" "--type=GDR_PCS" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/PCS_50_11.log 2>&1

##100_9
00 20 * * 7 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125, p4/psgeng,perl/5.8.8, testutils/21.3/, regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2, python_altera/2.7.3b/1.0, flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression.sh "--topology=100_9" "--type=GDR_PCS" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/PCS_100_9.log 2>&1

##200_8
00 22 * * 7 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125, p4/psgeng,perl/5.8.8, testutils/21.3/, regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2, python_altera/2.7.3b/1.0, flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression.sh "--topology=200_8" "--type=GDR_PCS"  "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" > /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/PCS_200_8.log 2>&1

##400_4
00 23 * * 7 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125, p4/psgeng,perl/5.8.8, testutils/21.3/, regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2, python_altera/2.7.3b/1.0, flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression.sh "--topology=400_4" "--type=GDR_PCS" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/PCS_400_4.log 2>&1


##%%%%%%%%%%%%%%%%%%%%%%%%#
#------ PCS Non LV  ------#
##%%%%%%%%%%%%%%%%%%%%%%%%#
##10_4
00 02 * * 1 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125, p4/psgeng,perl/5.8.8, testutils/21.3/, regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2, python_altera/2.7.3b/1.0, flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=10_4" "--type=GDR_PCS" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/PCS_10_4.log 2>&1

##25_5
00 04 * * 1 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125, p4/psgeng,perl/5.8.8, testutils/21.3/, regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2, python_altera/2.7.3b/1.0, flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=25_5" "--type=GDR_PCS" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/PCS_25_5.log 2>&1

##25_8
00 06 * * 1 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125, p4/psgeng,perl/5.8.8, testutils/21.3/, regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2, python_altera/2.7.3b/1.0, flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=25_8" "--type=GDR_PCS" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/PCS_25_8.log 2>&1

##50_6
00 08 * * 1 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125, p4/psgeng,perl/5.8.8, testutils/21.3/, regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2, python_altera/2.7.3b/1.0, flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=50_6" "--type=GDR_PCS" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/PCS_50_6.log 2>&1

##50_7
00 10 * * 1 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125, p4/psgeng,perl/5.8.8, testutils/21.3/, regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2, python_altera/2.7.3b/1.0, flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=50_7" "--type=GDR_PCS" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/PCS_50_7.log 2>&1

##50_8
00 12 * * 1 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125, p4/psgeng,perl/5.8.8, testutils/21.3/, regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2, python_altera/2.7.3b/1.0, flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=50_8" "--type=GDR_PCS" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/PCS_50_8.log 2>&1

##100_7
00 14 * * 1 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125, p4/psgeng,perl/5.8.8, testutils/21.3/, regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2, python_altera/2.7.3b/1.0, flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=100_7" "--type=GDR_PCS" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/PCS_100_7.log 2>&1

##100_10
00 16 * * 1 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125, p4/psgeng,perl/5.8.8, testutils/21.3/, regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2, python_altera/2.7.3b/1.0, flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=100_10" "--type=GDR_PCS" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/PCS_100_10.log 2>&1

##200_5
00 18 * * 1 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125, p4/psgeng,perl/5.8.8, testutils/21.3/, regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2, python_altera/2.7.3b/1.0, flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=200_5" "--type=GDR_PCS" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/PCS_200_5.log 2>&1

##200_9
00 20 * * 1 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125, p4/psgeng,perl/5.8.8, testutils/21.3/, regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2, python_altera/2.7.3b/1.0, flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=200_9" "--type=GDR_PCS" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/PCS_200_9.log 2>&1


########################################################################################################
########################################     FLEXE Variants  ###########################################
########################################################################################################

##%%%%%%%%%%%%%%%%%%%%%%%%#
#-------- FLEXE LV -------#
##%%%%%%%%%%%%%%%%%%%%%%%%#
##10_9
00 22 * * 1 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,vcs/Q-2020.03-SP2-2,synopsys_verdi/Q-2020.03,python_altera/2.7.3b/1.0,flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression.sh "--topology=10_9" "--type=GDR_FLEXE" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/FLEXE_10_9.log 2>&1
##25_16
00 01 * * 2 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,vcs/Q-2020.03-SP2-2,synopsys_verdi/Q-2020.03,python_altera/2.7.3b/1.0,flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression.sh "--topology=25_16" "--type=GDR_FLEXE" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/FLEXE_25_16.log 2>&1
##50_15
00 03 * * 2 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,vcs/Q-2020.03-SP2-2,synopsys_verdi/Q-2020.03,python_altera/2.7.3b/1.0,flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression.sh "--topology=50_15" "--type=GDR_FLEXE" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/FLEXE_50_15.log 2>&1
##100_16
00 05 * * 2 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,vcs/Q-2020.03-SP2-2,synopsys_verdi/Q-2020.03,python_altera/2.7.3b/1.0,flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression.sh "--topology=100_16" "--type=GDR_FLEXE" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/FLEXE_100_16.log 2>&1
##200_11
00 07 * * 2 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,vcs/Q-2020.03-SP2-2,synopsys_verdi/Q-2020.03,python_altera/2.7.3b/1.0,flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression.sh "--topology=200_11" "--type=GDR_FLEXE" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/FLEXE_200_11.log 2>&1
##400_6
00 09 * * 2 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,vcs/Q-2020.03-SP2-2,synopsys_verdi/Q-2020.03,python_altera/2.7.3b/1.0,flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression.sh "--topology=400_6" "--type=GDR_FLEXE" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/FLEXE_400_6.log 2>&1


##%%%%%%%%%%%%%%%%%%%%%%%%#
#----- FLEXE Non LV ------#
##%%%%%%%%%%%%%%%%%%%%%%%%#
##10_7
00 10 * * 2 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125, p4/psgeng,perl/5.8.8, testutils/21.3/, regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2, python_altera/2.7.3b/1.0, flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=10_7" "--type=GDR_FLEXE" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/FLEXE_10_7.log 2>&1

##25_12
00 12 * * 2 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125, p4/psgeng,perl/5.8.8, testutils/21.3/, regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2, python_altera/2.7.3b/1.0, flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=25_12" "--type=GDR_FLEXE" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/FLEXE_25_12.log 2>&1

##25_14
00 14 * * 2 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125, p4/psgeng,perl/5.8.8, testutils/21.3/, regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2, python_altera/2.7.3b/1.0, flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=25_14" "--type=GDR_FLEXE" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/FLEXE_25_14.log 2>&1

##50_13
00 16 * * 2 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125, p4/psgeng,perl/5.8.8, testutils/21.3/, regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2, python_altera/2.7.3b/1.0, flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=50_13" "--type=GDR_FLEXE" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/FLEXE_50_13.log 2>&1

##50_17
00 18 * * 2 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125, p4/psgeng,perl/5.8.8, testutils/21.3/, regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2, python_altera/2.7.3b/1.0, flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=50_13" "--type=GDR_FLEXE" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/FLEXE_50_13.log 2>&1

##50_19
00 20 * * 2 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125, p4/psgeng,perl/5.8.8, testutils/21.3/, regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2, python_altera/2.7.3b/1.0, flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=50_13" "--type=GDR_FLEXE" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/FLEXE_50_13.log 2>&1

##100_14
00 22 * * 2 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125, p4/psgeng,perl/5.8.8, testutils/21.3/, regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2, python_altera/2.7.3b/1.0, flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=100_14" "--type=GDR_FLEXE" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/FLEXE_100_14.log 2>&1

##100_18
00 01 * * 3 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125, p4/psgeng,perl/5.8.8, testutils/21.3/, regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2, python_altera/2.7.3b/1.0, flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=100_18" "--type=GDR_FLEXE" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/FLEXE_100_18.log 2>&1

##200_13
00 03 * * 3 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125, p4/psgeng,perl/5.8.8, testutils/21.3/, regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2, python_altera/2.7.3b/1.0, flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=200_13" "--type=GDR_FLEXE" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/FLEXE_200_13.log 2>&1

##200_15
00 05 * * 3 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125, p4/psgeng,perl/5.8.8, testutils/21.3/, regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2, python_altera/2.7.3b/1.0, flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=200_15" "--type=GDR_FLEXE" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/FLEXE_200_15.log 2>&1


########################################################################################################
########################################     OTN Variants  #############################################
########################################################################################################

##%%%%%%%%%%%%%%%%%%%%%%%%#
#-------- OTN LV ---------#
##%%%%%%%%%%%%%%%%%%%%%%%%#
##10_6
00 06 * * 3 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license, acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3,cygwin/2.9.0,altuvm/0.9p8,synopsys_verdi/Q-2020.03-SP2,vcs/Q-2020.03-SP2-2,python_altera/2.7.3b/1.0,flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression.sh "--topology=10_6" "--type=GDR_OTN" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/OTN_10_6.log 2>&1

##25_11
00 08 * * 3 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license, acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3,cygwin/2.9.0,altuvm/0.9p8,synopsys_verdi/Q-2020.03-SP2,vcs/Q-2020.03-SP2-2,python_altera/2.7.3b/1.0,flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/Regression.sh "--topology=25_11" "--type=GDR_OTN" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/OTN_25_11.log 2>&1

##40_6
30 10 * * 3 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license, acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3,cygwin/2.9.0,altuvm/0.9p8,synopsys_verdi/Q-2020.03-SP2,vcs/Q-2020.03-SP2-2,python_altera/2.7.3b/1.0,flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression.sh "--topology=40_6" "--type=GDR_OTN" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/OTN_40_6.log 2>&1

##50_14
30 12 * * 3 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license, acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3,cygwin/2.9.0,altuvm/0.9p8,synopsys_verdi/Q-2020.03-SP2,vcs/Q-2020.03-SP2-2,python_altera/2.7.3b/1.0,flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression.sh "--topology=50_14" "--type=GDR_OTN" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/OTN_50_14.log 2>&1

##100_15
00 14 * * 3 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license, acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3,cygwin/2.9.0,altuvm/0.9p8,synopsys_verdi/Q-2020.03-SP2,vcs/Q-2020.03-SP2-2,python_altera/2.7.3b/1.0,flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression.sh "--topology=100_15" "--type=GDR_OTN" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/OTN_100_15.log 2>&1

##%%%%%%%%%%%%%%%%%%%%%%%%#
#----- OTN Non LV --------#
##%%%%%%%%%%%%%%%%%%%%%%%%#
##25_17
00 16 * * 3 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license, acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3,cygwin/2.9.0,altuvm/0.9p8,synopsys_verdi/Q-2020.03-SP2,vcs/Q-2020.03-SP2-2,python_altera/2.7.3b/1.0,flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=25_17" "--type=GDR_OTN" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/OTN_25_17.log 2>&1

##50_12
30 18 * * 3 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license, acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3,cygwin/2.9.0,altuvm/0.9p8,synopsys_verdi/Q-2020.03-SP2,vcs/Q-2020.03-SP2-2,python_altera/2.7.3b/1.0,flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=50_12" "--type=GDR_OTN" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/OTN_50_12.log 2>&1

##50_18
30 20 * * 3 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license, acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3,cygwin/2.9.0,altuvm/0.9p8,synopsys_verdi/Q-2020.03-SP2,vcs/Q-2020.03-SP2-2,python_altera/2.7.3b/1.0,flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=50_18" "--type=GDR_OTN" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/OTN_50_18.log 2>&1

##100_13
00 22 * * 3 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license, acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3,cygwin/2.9.0,altuvm/0.9p8,synopsys_verdi/Q-2020.03-SP2,vcs/Q-2020.03-SP2-2,python_altera/2.7.3b/1.0,flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=100_13" "--type=GDR_OTN" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/OTN_100_13.log 2>&1

##100_19
00 01 * * 4 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license, acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3,cygwin/2.9.0,altuvm/0.9p8,synopsys_verdi/Q-2020.03-SP2,vcs/Q-2020.03-SP2-2,python_altera/2.7.3b/1.0,flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression_wo_cov.sh "--topology=100_19" "--type=GDR_OTN" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/OTN_100_19.log 2>&1

########################################################################################################
########################################     MI Variants  ##############################################
########################################################################################################
##MM1
00 05 * * 1 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_vip_common/vip_R-2020.09B,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2,flow/nb/norm-acds-pipe-dv-rgr,python_altera/2.7.3b/1.0 -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression.sh "--topology=mm1" "--MM=1" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu/" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/MI_1.log 2>&2 

##MM2
00 13 * * 1 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_vip_common/vip_R-2020.09B,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2,flow/nb/norm-acds-pipe-dv-rgr,python_altera/2.7.3b/1.0 -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression.sh "--topology=mm2" "--MM=1" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu/" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/MI_2.log 2>&2 

##MM3 
00 16 * * 1 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_vip_common/vip_R-2020.09B,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2,flow/nb/norm-acds-pipe-dv-rgr,python_altera/2.7.3b/1.0 -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression.sh "--topology=mm3" "--MM=1" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu/" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/MI_3.log 2>&2

##MM4
00 20 * * 1 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_vip_common/vip_R-2020.09B,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2,flow/nb/norm-acds-pipe-dv-rgr,python_altera/2.7.3b/1.0 -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression.sh "--topology=mm4" "--MM=1" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu/" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/MI_4.log 2>&2

##MM5
#00 10 * * 4 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/97,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_vip_common/vip_R-2020.09B,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2,flow/nb/norm-acds-pipe-dv-rgr,python_altera/2.7.3b/1.0 -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression.sh "--topology=mm5" "--MM=1" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu/" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/MI_5.log 2>&2

##MM6
00 02 * * 2 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_vip_common/vip_R-2020.09B,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2,flow/nb/norm-acds-pipe-dv-rgr,python_altera/2.7.3b/1.0 -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression.sh "--topology=mm6" "--MM=1" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu/" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/MI_6.log 2>&2

##MM7
00 08 * * 1 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_vip_common/vip_R-2020.09B,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2,flow/nb/norm-acds-pipe-dv-rgr,python_altera/2.7.3b/1.0 -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression.sh "--topology=mm7" "--MM=1" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu/" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/MI_7.log 2>&2

#MM8
00 02 * * 4 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,synopsys_vip_common/vip_R-2020.09B,synopsys_verdi/Q-2020.03,vcs/Q-2020.03-SP2-2,flow/nb/norm-acds-pipe-dv-rgr,python_altera/2.7.3b/1.0 -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression.sh "--topology=mm8" "--MM=1" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu/" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/MI_8.log 2>&2


########################################################################################################
########################################     PARAMETER SWEEP  ##########################################
########################################################################################################
#ETH_7
30 12 * * 3 /p/psg/ctools/arc/bin/arc shell synopsys_vip_ethernet-lic/license,vcs-vcsmx-lic/vrtn-dev,synopsys-vip-lic/config,synopsys_verdi-lic/license,acdskit/21.3/125,p4/psgeng,perl/5.8.8,testutils/21.3/,regutils/21.3/,itf/21.3/,cygwin/2.9.0,altuvm/0.9p8,vcs/Q-2020.03-SP2-2,synopsys_verdi/Q-2020.03,python_altera/2.7.3b/1.0,flow/nb/norm-acds-pipe-dv-rgr -- sh /nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/Regression.sh "--topology=7" "--PS=1" "--num_of_configs=30" "--user_work_dir=/nfs/sc/disks/gdr_regression_2/users/marrisu" >/nfs/sc/disks/gdr_regression_2/users/marrisu/GDR_SCRIPT/PS_ETH_7.log 2>&1
