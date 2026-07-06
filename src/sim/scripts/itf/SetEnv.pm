#This is the SetENV file

package SetEnv;

use vars qw(@EXPORT);
use Cwd;
use RegTest;

@EXPORT = qw (setup_env);

sub setup_env () {
    my $cwd = cwd();

    $ENV{'TB_PATH'}                   = $ENV{'REG_BASE_EXE_DIR_PATH'}."../../testbench"; 
    $ENV{'RTL_PATH'}                   = $ENV{'REG_BASE_EXE_DIR_PATH'}."../../design";
    $ENV{'MUX_HOME'}                 = $ENV{'REG_BASE_EXE_DIR_PATH'}."../.."; 
    $ENV{'TSN_HOME'}                 = $ENV{'REG_BASE_EXE_DIR_PATH'}."../..";
    #$ENV{'QUARTUS_INSTALL_DIR'}       = "/p/psg/swip/releases/acds/20.3/current.linux/linux64/quartus";
    $ENV{'ALTUVM_COMMON_HOME'}        = "/p/psg/flows/common/altuvm/0.9p6/product/common";
    $ENV{'ALTUVM_BCL_HOME'}           = "/p/psg/flows/common/altuvm/0.9p6/product/bcl";
    $ENV{'ALTUVM_AVALON_ST_HOME'}     = "/p/psg/flows/common/altuvm/0.9p6/product/altuvm_avalon_st";
    $ENV{'ALTUVM_CRU_HOME'}           = "/p/psg/flows/common/altuvm/0.9p6/product/altuvm_cru";
    $ENV{'ALT_MGE_PHY_ROOT'}           = $ENV{'RTL_PATH'}."/dv_use/alt_mge_phy_0/";
    $ENV{'ALT_EM10G32_ROOT'}           = $ENV{'RTL_PATH'}."/dv_use/alt_em10g32_0/";
    $ENV{'QUARTUS_NUM_PARALLEL_PROCESSORS'} = 8;

} 

