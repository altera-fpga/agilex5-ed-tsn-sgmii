https://wiki.ith.intel.com/display/PSGGeneralToolFlow/PSG+CSRGEN#PSGCSRGEN-ArcResources
https://wiki.ith.intel.com/display/PSGPipeTools/IP-XACT
https://wiki.ith.intel.com/display/PSGPipeTools/ODS+to+RDL+Tool

Resources: arc shell vcs/Q-2020.03-SP2 vcs vcs-vcsmx-lic itf python rdl_utils phv_tools/2020WW38.5 magillem/5.11.2.1 magillem-lic

ODS-> RDL:
python $ITF_ROOT/python/ods2ipxact_wrapper.py --input <BLOCK_NAME>.ods --oformat 'ipxact'
mv <BLOCK_NAME>_v1.rdl <BLOCK_NAME>.rdl

Multiple ODS -> RDL:
python $ITF_ROOT/python/ods2ipxact_wrapper.py --input <directory where ODS are> --oformat 'ipxact' --dirformat 'ods'

RDL->RTL & IPXACT:
csrgen -top_rdl <BLOCK_NAME>.rdl -generation_types ipxact,rtl -host_interface AVALON -mre csr_synchronous_reset -output_directory <OUTPUT_DIR_NAME>

IPXACT->RAL:
ralgen -ipxact2ralf Vendor_Library_<BLOCK_NAME>_csr_*.xml
ralgen -uvm -t <BLOCK_NAME>_csr Vendor_Library_<BLOCK_NAME>_csr_*.ralf -ca -cF

DV RAL directory:
//acds/main/regtest/ip/intel_osc/dv/ovs/ovs_ss/testbench/uvc/register
