#!/bin/bash

#-----------------------------------------
#Setup environment variable
#-----------------------------------------
export DATE=`date "+%d%b%Y"`
export YEAR=`date "+%Y"`
export MONTH=`date "+%b"`
export DAY=`date "+%d"`
export covdate=`date "+%Y-%m-%d"`
export workweek=`date +%V -d "$(date) + 7 days"`


#-----------------------------------------
#Collcting command line arguments
#-----------------------------------------
declare -i count=0
while [ $# -gt 0 ]; do
   if [[ $1 == *"--"* ]]; then
      if [[ $count -lt 6 ]]; then
        v="${1/--/}"
        declare $v
	count=$count+1;
      else
        addl_cmd+="${1} "
      fi
   fi
  shift
done
echo "USER DIR PATH: $user_work_dir";
echo "Topology: $topology";
echo "llvariant:$llvar";

if [ -z "$PS" ]
then
      echo "PS empty"
      PS=0
       
else
      echo "PS NOT empty"
      if [ -z "$num_of_configs" ]
      then
	echo "NO.OF configs are empty"
	num_of_configs=10
      else
        echo  "NO.OF configs are NOT empty"
      fi
fi

if [ -z "$MM" ]
then
      echo "MM empty"
      MM=0
else
      echo "MM NOT empty"
    
fi



if [[ $PS -eq 0 && $MM -eq 0 ]]
then
	if [ -z "$type" ]
	then
      		echo "type empty"
       		type=DM_ALL
		echo "type:$type"
	else
      		echo "type NOT empty"
		echo "type:$type"
    	fi
fi

echo "param_sweep :$PS"
echo "Multi-instance:$MM"
echo "Additional commands: $addl_cmd";
export WORK_AREA="$user_work_dir"
echo "work area $WORK_AREA"
##-----------coverage------
#
#if [ -z "$cov" ]
#then
#      	echo "cov empty"
#       	cov=1
#	echo "cov:$cov"
#else
#      	echo "cov NOT empty"
#	echo "cov:$cov"
#fi
##----------QSF------
#
#if [ -z "$qsf_en" ]
#then
#      	echo "QSF empty"
#       	qsf_en=1
#	echo "QSF:$qsf_en"
#else
#      	echo "QSF NOT empty"
#	echo "QSF:$qsf_en"
#fi

#if [[ $PS -eq 1 &&  $MM -eq 1 ]]
#then
#   echo "BOTH PS AND MM CANNOT BE ONE AT A TIME"
#   exit 1
#else
#	if [ $PS -eq 1 ]
#	then
#		export mode="Eth_PS"
#		export ntitle="ETH_PS_${topology}"
#		cov=1
#		exclusion=0
#                echo "cov:$cov"
#	elif [ $MM -eq 1 ] 
#	then
#		export mode="Eth"
#		export ntitle="ETH_${topology}"
#		cov=0
#		exclusion=0
#		echo "cov:$cov"
#	else
#		export mode="Eth"
#		export ntitle="ETH_${topology}"
#		cov=1
#		exclusion=1
#		echo "cov:$cov"
#	fi
#fi

if [ "${topology}" = 100g ] 
then 
cov=1;
else 
cov=0; 
fi
echo "topology : ${topology}, cov : ${cov} \n"
export mode="Eth"
export ntitle="${llvar}_${topology}"

export P4_ROOT="$WORK_AREA/ll10g_${llvar}_REGRESSION_${mode}_${topology}/depot"
echo "p4 root $P4_ROOT"
export MODEL_ROOT="$WORK_AREA/ll10g_${llvar}_REGRESSION_${mode}_${topology}/depot/acds"
echo "model root $MODEL_ROOT"
export MODEL_P4_ROOT="$MODEL_ROOT/main/regtest/ip/ethernet/intel_mge_phy_scripts"
echo "model p4 root $MODEL_P4_ROOT"

#add '/' after $RESULT_PATH
export EXC_PATH="$MODEL_P4_ROOT/qhip/scripts/funct_deterministic/common/coverage_excl/"
echo "exc path $EXC_PATH"
export RESULT_PATH="$WORK_AREA/ll10g_${llvar}_REGRESSION_${mode}_${topology}/REGRESSION_RESULT/RESULT/"
echo "result path $RESULT_PATH"

if [ "$llvar" == "BASER_A10" ]
then
export ETH_ROOT="$MODEL_ROOT/main/regtest/ip/ethernet/intel_mge_phy_scripts/qhip/scripts/funct_deterministic/LL10g_BASER_A10"
elif [ "$llvar" == "BASERS10" ]
then
export ETH_ROOT="$MODEL_ROOT/main/regtest/ip/ethernet/intel_mge_phy_scripts/qhip/scripts/funct_deterministic/LL10g_BASERS10_RUN"
elif [ "$llvar" == "BASERS10_HTILE" ]
then
export ETH_ROOT="$MODEL_ROOT/main/regtest/ip/ethernet/intel_mge_phy_scripts/qhip/scripts/funct_deterministic/LL10g_BASERS10_HTILE"
elif [ "$llvar" == "FTILE_RUN" ]
then
export ETH_ROOT="$MODEL_ROOT/main/regtest/ip/ethernet/intel_mge_phy_scripts/qhip/scripts/funct_deterministic/LL10g_FTILE_RUN"
elif [ "$llvar" == "MGBASET_S10_HTILE" ]
then
export ETH_ROOT="$MODEL_ROOT/main/regtest/ip/ethernet/intel_mge_phy_scripts/qhip/scripts/funct_deterministic/LL10g_MGBASET_S10_HTILE"
elif [ "$llvar" == "RUN_A10" ]
then
export ETH_ROOT="$MODEL_ROOT/main/regtest/ip/ethernet/intel_mge_phy_scripts/qhip/scripts/funct_deterministic/LL10g_RUN_A10"
elif [ "$llvar" == "RUN_C10gx" ]
then
export ETH_ROOT="$MODEL_ROOT/main/regtest/ip/ethernet/intel_mge_phy_scripts/qhip/scripts/funct_deterministic/LL10g_RUN_C10gx"
elif [ "$llvar" == "s10MGE_HTILE" ]
then
export ETH_ROOT="$MODEL_ROOT/main/regtest/ip/ethernet/intel_mge_phy_scripts/qhip/scripts/funct_deterministic/LL10g_s10MGE_HTILE"
elif [ "$llvar" == "MGE" ]
then
export ETH_ROOT="$MODEL_ROOT/main/regtest/ip/ethernet/intel_mge_phy_scripts/qhip/scripts/funct_deterministic/LL10g_s10MGE"
elif [ "$llvar" == "MGBASET_S10" ]
then
export ETH_ROOT="$MODEL_ROOT/main/regtest/ip/ethernet/intel_mge_phy_scripts/qhip/scripts/funct_deterministic/LL10g_MGBASET_S10"
else
export ETH_ROOT="$MODEL_ROOT/main/regtest/ip/ethernet/intel_mge_phy_scripts/qhip/scripts/funct_deterministic/LL10g_RUN"
fi

echo "eth root $ETH_ROOT"
export usr=`whoami`
echo "User name $usr"
export COV_PATH="/nfs/site/disks/ship_eth_coe_1/users/pipe_pg_3/LL10G_IP/COV_DIR"
echo "cov path $COV_PATH"
export CSV_PATH="/nfs/site/disks/ship_eth_coe_1/users/pipe_pg_3/LL10G_IP/ll10g_REPORT"

#if [ $PS -eq 1 ]
#then
#  export NEWGDR_COV="/nfs/site/disks/gdr_regression_3/users/GDR_COV_VDBS/PS_VDBS/${mode}_${topology}"
#  echo "INSIDE PS COVERAGE"
#elif [ $MM -eq 1 ] 
#then
#  export NEWGDR_COV="/nfs/site/disks/gdr_regression_3/users/GDR_COV_VDBS/MM_VDBS/${mode}_${topology}"
#  echo "INSIDE MM COVERAGE"
#elif [ "$type" == "GDR_PCS" ]
#then
#  export NEWGDR_COV="/nfs/site/disks/gdr_regression_3/users/GDR_COV_VDBS/PCS_VDBS/${mode}_${topology}"
#  echo "INSIDE PCS COVERAGE"
#elif [ "$type" == "GDR_FLEXE" ]
#then
#  export NEWGDR_COV="/nfs/site/disks/gdr_regression_3/users/GDR_COV_VDBS/FLEXE_VDBS/${mode}_${topology}" 
#  echo "INSIDE FLEXE COVERAGE"
#elif [ "$type" == "GDR_OTN" ]
#then
#  export NEWGDR_COV="/nfs/site/disks/gdr_regression_3/users/GDR_COV_VDBS/OTN_VDBS/${mode}_${topology}"  
#  echo "INSIDE OTN COVERAGE"
#else
  export NEWll10g_COV="/nfs/site/disks/ship_eth_coe_1/users/pipe_pg_3/LL10G_IP/ll10g_COV_VDBS/${mode}_${topology}"
#  echo "inside mac VDBS"
#fi

#$VAR values 'sip' 'hip' or rates

export VAR="QHIP" 

export IPATH="$WORK_AREA/ll10g_${llvar}_REGRESSION_${mode}_${topology}/REGRESSION_RESULT/COVERAGE/ACC_COV"
export OPATH="$WORK_AREA/ll10g_${llvar}_REGRESSION_${mode}_${topology}/REGRESSION_RESULT/COVERAGE/MERGED_COV"
echo "i path $IPATH"
echo "o path $OPATH"
export PROJ="LL10G"


#proj = project name i.e. MSFT, GDR etc.
export res_file="$WORK_AREA/ll10g_${llvar}_REGRESSION_${mode}_${topology}/REGRESSION_RESULT/files/ll10g_${ntitle}.csv"
export reg_file="$WORK_AREA/ll10g_${llvar}_REGRESSION_${mode}_${topology}/REGRESSION_RESULT/files/ll10g_${ntitle}_SIGNS.csv"
export errorlist="$WORK_AREA/ll10g_${llvar}_REGRESSION_${mode}_${topology}/REGRESSION_RESULT/files/error_list.txt"
export mailfile="$WORK_AREA/ll10g_${llvar}_REGRESSION_${mode}_${topology}/REGRESSION_RESULT/files/mailfile.txt"
export ignorelist="$WORK_AREA/ll10g_${llvar}_REGRESSION_${mode}_${topology}/REGRESSION_RESULT/files/ignorelist.txt"
export new_file="/nfs/site/disks/ship_eth_coe_1/users/pipe_pg_3/LL10G_IP/ll10g_REPORT/ALL_CSV/ll10g_${ntitle}.csv "


echo "title $ntitle"

if [ -d "$WORK_AREA/ll10g_${llvar}_REGRESSION_${mode}_${topology}" ]
then 
	echo "Directory exists"
        rm -rf $WORK_AREA/ll10g_${llvar}_REGRESSION_${mode}_${topology}
        mkdir $WORK_AREA/ll10g_${llvar}_REGRESSION_${mode}_${topology}
else
	echo "Directory not present"
	echo "creating.."
	mkdir $WORK_AREA/ll10g_${llvar}_REGRESSION_${mode}_${topology}
fi

if [ -d "$WORK_AREA/ll10g_${llvar}_REGRESSION_${mode}_${topology}/REGRESSION_RESULT" ]
then 
	echo "Directory exists"
else
	echo "Directory not present"
	echo "creating.."
	mkdir $WORK_AREA/ll10g_${llvar}_REGRESSION_${mode}_${topology}/REGRESSION_RESULT
fi
if [ -d "$P4_ROOT" ]
then 
	echo "Directory exists"
else
	echo "Directory not present"
	echo "creating.. $P4_ROOT"
	mkdir $P4_ROOT
fi

if [ -d "$RESULT_PATH" ]
then 
	echo "Directory exists"
else
	echo "Directory not present"
	echo "creating.. $RESULT_PATH"
	mkdir $RESULT_PATH
fi

if [ -d "$WORK_AREA/ll10g_${llvar}_REGRESSION_${mode}_${topology}/REGRESSION_RESULT/files" ]
then 
	echo "Directory exists"
else
	echo "Directory not present"
	echo "creating.. "
	mkdir $WORK_AREA/ll10g_${llvar}_REGRESSION_${mode}_${topology}/REGRESSION_RESULT/files
	touch $res_file
	touch $reg_file
	touch $errorlist
	touch $mailfile
	touch $ignorelist
fi

if [ -f "$res_file" ]
then 
	echo "file exists"
else
	echo "file not present"
	echo "creating.. "
	touch $res_file
fi

if [ -d "$WORK_AREA/ll10g_${llvar}_REGRESSION_${mode}_${topology}/REGRESSION_RESULT/COVERAGE" ]
then 
	echo "Directory exists"
else
	echo "Directory not present"
	echo "creating.. "
	mkdir $WORK_AREA/ll10g_${llvar}_REGRESSION_${mode}_${topology}/REGRESSION_RESULT/COVERAGE
	mkdir $IPATH
	mkdir $OPATH
fi
if [ -d "/nfs/site/disks/ship_eth_coe_1/users/pipe_pg_3/LL10G_IP/ll10g_REPORT" ]
then 
	echo "Directory exists"
else
 echo "Directory not present"
	echo "creating.."
	mkdir /nfs/site/disks/ship_eth_coe_1/users/pipe_pg_3/LL10G_IP/ll10g_REPORT
fi


if [ -d "/nfs/site/disks/ship_eth_coe_1/users/pipe_pg_3/LL10G_IP/ll10g_REPORT/ALL_CSV" ]
then 
	
	echo "Directory exists"
else
	echo "Directory not present"
	echo "creating.."
	mkdir /nfs/site/disks/ship_eth_coe_1/users/pipe_pg_3/LL10G_IP/ll10g_REPORT/ALL_CSV
fi

if [ -f "$new_file" ]
then 
	echo "file exists"
	chmod 777 $new_file

else
	echo "file not present"
	echo "creating.. "
	touch $new_file
	chmod 777 $new_file
fi
if [ -d "$NEWll10g_COV" ]
then 
	echo "Directory exists"
       chmod 777 $NEWll10g_COV
 
else
	echo "Directory not present"
	echo "creating.. $NEWll10g_COV"
	mkdir $NEWll10g_COV
       chmod 777 $NEWll10g_COV
fi

#export SCRIPT_PATH=`pwd`
export SCRIPT_PATH="$WORK_AREA/cron_scripts"
if [ -f "$SCRIPT_PATH/result.pl" ]
then
  echo "script path has result.pl $SCRIPT_PATH"
else
  echo "script path doesn't have result.pl $SCRIPT_PATH"
  exit 1
fi 
#...........Check Disk Space ........................................................

#df -h $WORK_AREA| grep -vE 'muralasx' | awk 'FNR==2{ print $4}' | while read output;
df -h $WORK_AREA| awk 'FNR==2{ print $4}' | while read output;
do
echo "diskspace = $output"
var2=$(expr $output : "[^0-9]*\([0-9]*\)")
if [ $var2 > 300 ]; then
	echo "sufficient disk space"

else
	echo "diskspace full"
	
fi
done


export P4_client_var="Root:	${P4_ROOT}"

export sync_dir="	//acds/main/regtest/ip/ethernet/intel_mge_phy_scripts/... //${usr}_ll10g_${llvar}_REGRESSION_${mode}_${topology}/acds/main/regtest/ip/ethernet/intel_mge_phy_scripts/..."

#------------------------------------------
#GOTO to MODEL_ROOT and sync from perforce
#------------------------------------------
cd $P4_ROOT
#if [ -f "source.me" ]
#then 
#	echo "source file exists"
#	source source.me
#else
#	echo "file not present"
#	echo "creating.. "
	touch source.me 
	echo "export P4CLIENT=${usr}_ll10g_${llvar}_REGRESSION_${mode}_${topology}" > source.me
	echo "export P4ROOT=`pwd`" >> source.me
        echo "export P4PORT=ssl:p4proxy06.devtools.intel.com:6110" >> source.me
        echo "export CRETE=`pwd`/acds/main/regtest/ip/ethernet/intel_mge_phy_scripts" >> source.me
	source $P4_ROOT/source.me
#fi
p4 client -o > p4_ori
cp p4_ori p4_mod
sed -i 's/Host\:.*//g' p4_mod
#sed -i 's/Client\:.*/Client: ll10g_SJ_REGRESSION_Eth_${topology}/g' p4_mod
sed -i 's/\/\/.*//g' p4_mod
#sed -i 's/Owner\:.*/Owner:    muralasx/g' p4_mod
#sed -i 's/Created by.*/Created by muralasx/g' p4_mod
echo "$sync_dir" >> p4_mod
#sed -e "s|Root\:.*|$P4_client_var|g" p4_mod > p4_mod_final
grep -v '	$' p4_mod > p4_mod_final
grep -v '^$' p4_mod_final > p4_mod
p4 client -i < p4_mod
p4 sync -f ...

#add rm -rf command to remove content from $DAY and LATEST_COVERAGE previous runs data

echo "Coverage path: $COV_PATH"
#rm -rf $COV_PATH/*
echo "Run directory: $ETH_ROOT"
cd $ETH_ROOT

#.....................Getting Start Time ...................................................

export start=`date "+%H:%M "`
export t=`date +"%r"`
echo $start
am_pm=$(echo $t | cut -d ' ' -f 2-)
echo $am_pm
name_of_day=`date "+%a"`
echo $name_of_day

#.............................................................................................
#REG_EXE Command
#.............................................................................................

#25.6.20
#reg_exe --farm --svt=1 --cov=1 --DUT_CFG=pp1_crc1_rl1_stats1_sfd1_lf1_rsfec0_fc1_fcq1_anlt0_ltkr504_crmode0_cl72prbs0_anpause3 --sequence=sanity_sequence --verbosity=UVM_NONE --return_file-mode=all --priority=100 --results-directory=$RESULT_PATH --monitor >$RESULT_PATH/reg_exe_${VAR}.log


#9.7.20

if [[ $PS -eq 1 ]]
then

echo "reg_exe --farm --topology=$topology --ehip_mode=PARAMETER_SWEEP --num_of_configs=10 --num_seeds=1 --cov=$cov $addl_cmd --return_file-mode=all --results-directory=$RESULT_PATH --monitor >$RESULT_PATH/reg_exe_${VAR}.log"
#reg_exe --farm --topology=$topology --ehip_mode=PARAMETER_SWEEP --num_of_configs=10 --num_seeds=1 --cov=$cov $addl_cmd --return_file-mode=all --results-directory=$RESULT_PATH --monitor >$RESULT_PATH/reg_exe_${VAR}.log
reg_exe --farm --topology=$topology --title=GDR_PS --ehip_mode=PARAMETER_SWEEP --num_of_configs=$num_of_configs --qsf_en=0 --num_seeds=2 --cov=$cov --return_file-mode=all --results-directory=$RESULT_PATH --monitor >$RESULT_PATH/reg_exe_${VAR}.log
elif  [[ $MM -eq 1 ]]
then
    if [  "$topology" = mm1 -o "$topology" = mm3 -o "$topology" = mm4 ]  
    then
    	echo "reg_exe --farm --topology=$topology --type=GDR_MI --num_seeds=10 --multi_inst=1 $addl_cmd --return_file-mode=all --results-directory=$RESULT_PATH --monitor >$RESULT_PATH/reg_exe_${VAR}.log"
    	reg_exe --farm --topology=$topology --type=GDR_MI --num_seeds=10 --multi_inst=1 $addl_cmd --return_file-mode=all --results-directory=$RESULT_PATH --monitor >$RESULT_PATH/reg_exe_${VAR}.log
    	else 
    	echo "reg_exe --farm --topology=$topology --type=GDR_MI --num_seeds=10 --qsf_en=0 --multi_inst=1 $addl_cmd --return_file-mode=all --results-directory=$RESULT_PATH --monitor >$RESULT_PATH/reg_exe_${VAR}.log"
    	reg_exe --farm --topology=$topology --type=GDR_MI --num_seeds=10 --qsf_en=0 --multi_inst=1 $addl_cmd --return_file-mode=all --results-directory=$RESULT_PATH --monitor >$RESULT_PATH/reg_exe_${VAR}.log
	fi        
else
echo "reg_exe --farm --topology=$topology --type=$type --num_seeds=1 --title="LL10g_${llvar}_${topology}_WW${workweek}" --cov=$cov $addl_cmd --cov_dir=$COV_PATH --return_file-mode=all --results-directory=$RESULT_PATH --monitor --priority=150 >$RESULT_PATH/reg_exe_${topology}.log"

reg_exe --farm --topology=$topology --type=$type --num_seeds=1 --title="LL10g_${llvar}_${topology}_WW${workweek}" --cov=$cov $addl_cmd --cov_dir=$COV_PATH --return_file-mode=all --results-directory=$RESULT_PATH --monitor --priority=150 >$RESULT_PATH/reg_exe_${topology}.log

#reg_exe --farm --topology=$topology --sequence=sanity_sequence --seed=1 --verbosity=UVM_MEDIUM --dump_from0time=0 --error_count=2000 --cov=$cov $addl_cmd --return_file-mode=all --results-directory=$RESULT_PATH --monitor --priority=150 >$RESULT_PATH/reg_exe_${topology}.log

fi

#................................................................................................
#if [[ $MM -eq 1 ]]
#then
#echo "$topology"
#echo "inside "
#topology=$(echo "$topology" | sed 's/[^0-9]*//g')
#topology="$topology""_""$topology"
#echo $topology
#fi

mkdir $IPATH/$name_of_day
rm -rf $IPATH/$name_of_day/*
cp -rf $COV_PATH/* $IPATH/$name_of_day/
echo "Copied coverage data to IPATh"
#...........................Executing Perl Script......................................................................................................
echo "perl $SCRIPT_PATH/result.pl --title=$ntitle --topology=$topology -ipath=$IPATH -opath=$OPATH --regPath=$RESULT_PATH --mode=${VAR} -time=$DATE --cov_enable=$cov --proj=$PROJ --covPath=$COV_PATH --Year=$YEAR --month=$MONTH --Day=$DAY --start=$start --timevar=$am_pm --title=$ntitle --name_of_day=$name_of_day --res_file=$res_file --new_file=$new_file --reg_file=$reg_file --errorlist=$errorlist --mailfile=$mailfile --ignorelist=$ignorelist --num_of_configs=$num_of_configs --local_run=0"
perl $SCRIPT_PATH/result.pl --title=$ntitle --llvar=$llvar --topology=$topology -ipath=$IPATH -opath=$OPATH --regPath=$RESULT_PATH --mode=${VAR} -time=$DATE --cov_enable=$cov --proj=$PROJ --covPath=$COV_PATH --Year=$YEAR --month=$MONTH --Day=$DAY --start=$start --timevar=$am_pm --title=$ntitle --name_of_day=$name_of_day --res_file=$res_file --new_file=$new_file --reg_file=$reg_file --errorlist=$errorlist --mailfile=$mailfile --ignorelist=$ignorelist --num_of_configs=$num_of_configs --local_run=0
 #perl /nfs/site/disks/swip_sipeth_1/users/avaran1x/SJ_CRON_LL10g/result.pl --title=Eth_10g --topology=10g -ipath=/nfs/site/disks/swip_sipeth_1/users/avaran1x/ll10g_SJ_REGRESSION_Eth_10g/REGRESSION_RESULT/COVERAGE/ACC_COV -opath=/nfs/site/disks/swip_sipeth_1/users/avaran1x/ll10g_SJ_REGRESSION_Eth_10g/REGRESSION_RESULT/COVERAGE/MERGED_COV --regPath=/nfs/site/disks/swip_sipeth_1/users/avaran1x/ll10g_SJ_REGRESSION_Eth_10g/REGRESSION_RESULT/RESULT/ --mode=QHIP -time=28Nov2021 --cov_enable=1 --proj=LL10g_Ftile --covPath=/nfs/site/disks/fm7_cryptosip_1/users/avaran1x/COV_DIR --NEWll10g_COV=$NEWll10g_COV --Year=2021 --month=Nov --Day=28 --start=18:52 --timevar=PM --title=Eth_10g --exc_path=$EXC_PATH --exc=$exclusion --name_of_day=Sun --res_file=/nfs/site/disks/swip_sipeth_1/users/avaran1x/ll10g_SJ_REGRESSION_Eth_10g/REGRESSION_RESULT/files/ll10g_ETH_10g.csv  --reg_file=/nfs/site/disks/swip_sipeth_1/users/avaran1x/ll10g_SJ_REGRESSION_Eth_10g/REGRESSION_RESULT/files/ETH_10g_SIGNS.csv --errorlist=/nfs/site/disks/swip_sipeth_1/users/avaran1x/ll10g_SJ_REGRESSION_Eth_10g/REGRESSION_RESULT/files/error_list.txt --mailfile=/nfs/site/disks/swip_sipeth_1/users/avaran1x/ll10g_SJ_REGRESSION_Eth_10g/REGRESSION_RESULT/files/mailfile.txt --ignorelist=/nfs/site/disks/swip_sipeth_1/users/avaran1x/ll10g_SJ_REGRESSION_Eth_10g/REGRESSION_RESULT/files/ignorelist.txt --num_of_configs=$num_of_configs --local_run=0
