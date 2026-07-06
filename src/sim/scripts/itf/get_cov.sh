SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )


ls -d device*/qsys*/rtl_sim_compile*/sequence*/rtl_sim_simulate*/synopsys/vcs/simv.vdb > vdb.list

for dir in `ls -d device*/qsys*/rtl_sim_compile*/sequence*/rtl_sim_simulate*/synopsys/vcs/simv.vdb`
do
    cd $SCRIPT_DIR/$dir
    echo "unzipping $SCRIPT_DIR/$dir"
    gunzip -r .
done

cd $SCRIPT_DIR
urg -f vdb.list -dbname tsn_cov_merged -report tsn_cov/urgReport/ -format both
