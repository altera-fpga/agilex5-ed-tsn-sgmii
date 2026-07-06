# $File: //acds/prototype/sm_tsn_sed/scripts/common/SetEnv.pm $
# Date Modified On : $Date: 2023/10/06 $
# Last Modified By : $Author: smyint $
# Revision : $Revision: #1 $
# Package: SetEnv
package SetEnv;

use vars qw(@EXPORT);
use POSIX qw(strftime);

@EXPORT = qw (setup_env);

sub setup_env () {
    my $date = strftime "%F", localtime;
    print "\n ******************* THE DATE is $date ******************** \n";
    #chethan1 $ENV{'MRPHY_COVERAGE_PATH'} = "/p/psg/swip/sip_eth2/coverage/ethernet/SIP_DV/eth_c3/DR/$ENV{'ACDS_VERSION'}/$ENV{'USER'}/$date";
    $ENV{'MRPHY_COVERAGE_PATH'} = "/nfs/site/disks/sm7_rgr_cise_eth_1/users/$ENV{'USER'}/COV_DIR_SM_MRPHY";
    
} # &setup_env()
sub setup_sm_env () {
    my $date = strftime "%F", localtime;
    print "\n ******************* THE DATE is $date ******************** \n";
    #chethan1 $ENV{'ETH_EHIP_100GE_COVERAGE_PATH'} = "/p/psg/swip/sip_eth2/coverage/ethernet/SIP_DV/eth_c3/DR/$ENV{'ACDS_VERSION'}/$ENV{'USER'}/$date";
    $ENV{'ETH_EHIP_100GE_COVERAGE_PATH'} = "/nfs/site/disks/sm7_rgr_cise_eth_1/users/$ENV{'USER'}/COV_DIR_SM_MRPHY";
    
} # &setup_sm_env()
1;
