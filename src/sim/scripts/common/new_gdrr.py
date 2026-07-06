# -*- coding: iso-8859-1 -*-
import shutil,os,sys
#path_to_template= '/p/psg/swip/sip_eth/users/kanishks/acds/main/regtest'#'/'.join(os.environ.get("LSB_OUTDIR").split('/')[:-7])
env_var = str(sys.argv[1])
tb_var = str(sys.argv[2])
ptp_debug_acc_en = int(sys.argv[3])
temp=[]
for i in open("param_tb.csv","r"):
                temp.append([j.strip() for j in i.split(',')])

#print(temp)
for i in range(len(temp)):
	vars()[temp[i][0]] = [j for j in [k for k in temp[i][1:]]]
def hex2bin(a,b):
  if(a==''):
	a='0'
  x='{0:0%sb}'%str(b)
  res=x.format(int(a,16))
  return res

print("Inside new_gdr ptp_debug_acc_en = ",ptp_debug_acc_en)

num_ones=[]
num_ports=[]
kr_enable=[]
ANLT=[]
for i in range(len(ENABLE_AN)):
	ANLT.append(int(ENABLE_AN[i][0]) | int(ENABLE_LT[i][0]))
for i in range(len(INSTANCE)):
	kr_enable.append(hex2bin(ANLTENNODE[i].strip('0'),INSTANCE[i])[::-1])
	num_ones.append(hex2bin(ANLTENNODE[i].strip('0'),INSTANCE[i]).count('1'))
        num_ports.append(hex2bin(ACTIVENODE[i].strip('0'),INSTANCE[i]).count('1'))
kr_enable = ''.join(kr_enable)
print("kr_enable = ",kr_enable)
print("ANLT enabled nodes = ",num_ones)
print("ACTIVE nodes = ",num_ports)
def writetofile(handle,a):
	handle.writelines(a)
widths_avst = {'10': '63' , '25': '63','40':'127', '50': '127', '100': '511'}
widths_empty_avst = {'10': '2' , '25': '2','40':'3', '50': '3', '100': '5'}
widths_macseg = {'10': '63' , '25': '63','40': '127', '50': '127', '100': '255','200':'511','400':'1023'}
widths_pcsonly = {'10': '63' , '25': '63','40': '127', '50': '127', '100': '255','200':'511','400':'1023'}
widths_otnflexe = {'10': '65' , '25': '65','40': '131', '50': '131', '100': '263','200':'527','400':'1055'}
widths_txmac_macseg={'10':'0','25':'0','40':'1','50':'1','100':'3','200':'7','400':'15'}

ptp_signals_input=['i_clk_tx_tod_ip0,','i_clk_rx_tod_ip0,','i_clk_ptp_sample_ip0,','i_ptp_ts_req_ip0,','i_ptp_fp_ip0,','i_ptp_ins_ets_ip0,','i_ptp_ins_cf_ip0,','i_ptp_zero_csum_ip0,','i_ptp_update_eb_ip0,','i_ptp_p2p_ip0,','i_ptp_asym_ip0,','i_ptp_asym_sign_ip0,','i_ptp_asym_p2p_idx_ip0,','i_ptp_ts_offset_ip0,','i_ptp_cf_offset_ip0,','i_ptp_csum_offset_ip0,','i_ptp_tx_its_ip0,','i_ptp_tx_tod_ip0,','i_ptp_rx_tod_ip0,','i_ptp_tx_tod_valid_ip0,','i_ptp_rx_tod_valid_ip0,']
ptp_signals_output=['o_tx_ptp_offset_data_valid_ip0,','o_rx_ptp_offset_data_valid_ip0,','o_tx_ptp_ready_ip0,','o_rx_ptp_ready_ip0,','o_ptp_ets_ip0,','o_ptp_ets_fp_ip0,','o_ptp_ets_valid_ip0,','o_ptp_ets_vl_ip0,','o_ptp_rx_its_ip0,','o_ptp_rx_its_valid_ip0,','o_ptp_rx_its_vl_ip0,']
ptp_aib67_signals_input=['i_reconfig_ptp_p2p_addr_ip0,','i_reconfig_ptp_p2p_byteenable_ip0,','i_reconfig_ptp_p2p_read_ip0,','i_reconfig_ptp_p2p_write_ip0,','i_reconfig_ptp_p2p_writedata_ip0,','i_reconfig_ptp_asym_addr_ip0,','i_reconfig_ptp_asym_byteenable_ip0,','i_reconfig_ptp_asym_read_ip0,','i_reconfig_ptp_asym_write_ip0,','i_reconfig_ptp_asym_writedata_ip0,']
ptp_aib67_signals_output=['o_reconfig_ptp_p2p_readdata_valid_ip0,','o_reconfig_ptp_p2p_readdata_ip0,','o_reconfig_ptp_p2p_waitrequest_ip0,','o_reconfig_ptp_asym_readdata_valid_ip0,','o_reconfig_ptp_asym_readdata_ip0,','o_reconfig_ptp_asym_waitrequest_ip0,']

dut_path_avst = "dut_top_avst_template.v"
dut_path_macseg = "dut_top_macseg_template.v"
dut_path_pcs_only="dut_top_pcs_only_template.v"
dut_path_otn = "dut_top_otn_flexe_template.v"
dut = env_var+"/gdr_gen_qhip_files/dut_top.v"
f_op = open(dut, 'w+')

writetofile(f_op,'`timescale 1ps/1ps'+'\n\n')
#
writetofile(f_op,'module dut_top #()\n ( \n\n input wire i_refclk2pll,\n')
writetofile(f_op,'input wire i_refclk2syspll,\n')
#writetofile(f_op,'module dut_top #()\n ( \n input wire i_clk_sys,\n input wire i_refclk2pll,\n')
if('1' in TRANSTYPE):
	writetofile(f_op,'input wire i_bk_refclk2pll,\n')
SPEED =[]
NUMTXLANE = []
for i in MODE:
	SPEED.append(i.split('_')[0][:-1])
	NUMTXLANE.append(i.split('_')[1])
print(SPEED)
print(NUMTXLANE)
INSTANCE = list(map(int, INSTANCE)) 
print(INSTANCE)
a,b,c=0,0,0
tempvar_avst,tempvar_macseg,tempvar_pcs,tempvar_otn=[],[],[],[]
avst_common,macseg_common,pcs_common,otn_common=[],[],[],[]
avst_krcommon,macseg_krcommon,pcs_krcommon,otn_krcommon=[],[],[],[]
if('1' in INTERFACE):
	for j in open(dut_path_avst,"r"):
		if(j=='    //inst0'+'\n'):
			a=1
			continue
		if(j =='    //inst1'+'\n'):
			a=0
			break
		if(a):
			tempvar_avst.append(j.split())
	for j in open(dut_path_avst,"r"):
		if(j=='//begincommon'+'\n'):
			b=1
			continue
		if(j=='//endcommon'+'\n'):
			b=0
			break
		if(b):
			avst_common.append(j.split())
	for j in open(dut_path_avst,"r"):
		if(j=='//beginkrcommon'+'\n'):
			c=1
			continue
		if(j=='//endkrcommon'+'\n'):
			c=0
			break
		if(c):
			avst_krcommon.append(j.split())
	avst_krcommon = list(filter(None, avst_krcommon))
	avst_common =  list(filter(None, avst_common))
	tempvar_avst = list(filter(None, tempvar_avst))
# Alekh: Below code saves all lines from template in specific arrays
a,b,c=0,0,0	
if('0' in INTERFACE):
	for j in open(dut_path_macseg,"r"):
		#print(j.split())
		if(j=='    //inst0'+'\n'):
			a=1
			continue
		if(j =='    //inst1'+'\n'):
			a=0
			break
		if(a):
			tempvar_macseg.append(j.split())
	for j in open(dut_path_macseg,"r"):    
		if(j=='//begincommon'+'\n'):
			b=1
			continue
		if(j=='//endcommon'+'\n'):
			b=0
			break
		if(b):
			macseg_common.append(j.split())
	for j in open(dut_path_macseg,"r"):
		if(j=='//beginkrcommon'+'\n'):
			c=1
			continue
		if(j=='//endkrcommon'+'\n'):
			c=0
			break
		if(c):
			macseg_krcommon.append(j.split())
	macseg_krcommon = list(filter(None, macseg_krcommon))
	macseg_common =  list(filter(None, macseg_common))
	tempvar_macseg = list(filter(None, tempvar_macseg))
a,b,c=0,0,0	
if('2' in INTERFACE):
	for j in open(dut_path_pcs_only,"r"):
		#print(j.split())
		if(j=='    //inst0'+'\n'):
			a=1
			continue
		if(j =='    //inst1'+'\n'):
			a=0
			break
		if(a):
			tempvar_pcs.append(j.split())
	for j in open(dut_path_pcs_only,"r"):
		if(j=='//begincommon'+'\n'):
			b=1
			continue
		if(j=='//endcommon'+'\n'):
			b=0
			break
		if(b):
			pcs_common.append(j.split())
	for j in open(dut_path_pcs_only,"r"):
		if(j=='//beginkrcommon'+'\n'):
			c=1
			continue
		if(j=='//endkrcommon'+'\n'):
			c=0
			break
		if(c):
			pcs_krcommon.append(j.split())
	pcs_krcommon = list(filter(None, pcs_krcommon))
	pcs_common =  list(filter(None, pcs_common))
	tempvar_pcs = list(filter(None, tempvar_pcs))
a,b,c=0,0,0	
if('3' in INTERFACE or '4' in INTERFACE):
	for j in open(dut_path_otn,"r"):
		#print(j.split())
		if(j=='    //inst0'+'\n'):
			a=1
			continue
		if(j =='    //inst1'+'\n'):
			a=0
			break
		if(a):
			tempvar_otn.append(j.split())
	for j in open(dut_path_otn,"r"):
		if(j=='//begincommon'+'\n'):
			b=1
			continue
		if(j=='//endcommon'+'\n'):
			b=0
			break
		if(b):
			otn_common.append(j.split())
	for j in open(dut_path_otn,"r"):
		if(j=='//beginkrcommon'+'\n'):
			c=1
			continue
		if(j=='//endkrcommon'+'\n'):
			c=0
			break
		if(c):
			otn_krcommon.append(j.split())
	otn_krcommon = list(filter(None, otn_krcommon))
	otn_common =  list(filter(None, otn_common))
	tempvar_otn = list(filter(None, tempvar_otn))
wire_avst_input,wire_avst_output=[],[]
wire_macseg_input,wire_macseg_output=[],[]
wire_pcs_input,wire_pcs_output=[],[]
wire_otn_input,wire_otn_output=[],[]
wire_avst_common,wire_macseg_common,wire_pcs_common,wire_otn_common=[],[],[],[]
wire_avst_krcommon,wire_macseg_krcommon,wire_pcs_krcommon,wire_otn_krcommon=[],[],[],[]
#print(avst_common,macseg_common,pcs_common,otn_common)
# Alekh: Below code filters out input  output
if('1' in INTERFACE):
	for i in tempvar_avst:
		#print(i[0])
		if(i[0]=='input'):
			#print(i[1][-4:])
			wire_avst_input.append(i[-1])
		elif(i[0]=='//input'):
			wire_avst_input.append(i[-4])
		elif(i[0]=='output'):
			wire_avst_output.append(i[-1])
		elif(i[0]=='//output'):
			wire_avst_output.append(i[-4])
	for i in avst_common:
		wire_avst_common.append(i[-1])
	for i in avst_krcommon:
		wire_avst_krcommon.append(i[-1])
		
if('2' in INTERFACE):
   for i in tempvar_pcs:
      if(i[0]=='input'):
         if(i[2][0]=='['):
            wire_pcs_input.append(i[3])
         elif(i[2][0]=='i' or i[2][0]=='o'):
            wire_pcs_input.append(i[2])
      elif(i[0]=='//input'):
         wire_pcs_input.append(i[-1])
      elif(i[0]=='output'):
         if(i[2][0]=='['):
            wire_pcs_output.append(i[3])
         elif(i[2][0]=='i' or i[2][0]=='o'):
            wire_pcs_output.append(i[2])
         elif(i[0]=='//output'):
            wire_pcs_output.append(i[-1])
   for i in pcs_common:
      wire_pcs_common.append(i[-1])
   for i in pcs_krcommon:
      wire_pcs_krcommon.append(i[-1])
if('3' in INTERFACE or '4' in INTERFACE):
	for i in tempvar_otn:
		#print(i[0])
		if(i[0]=='input'):
			#print(i[1][-4:])
			wire_otn_input.append(i[-1])
		elif(i[0]=='//input'):
			wire_otn_input.append(i[-4])
		elif(i[0]=='output'):
			wire_otn_output.append(i[-1])
		elif(i[0]=='//output'):
			wire_otn_output.append(i[-4])
	for i in otn_common:
		wire_otn_common.append(i[-1])
	for i in otn_krcommon:
		wire_otn_krcommon.append(i[-1])
if('0' in INTERFACE):
	for i in tempvar_macseg:
		#print(i[0])
		if(i[0]=='input'):
			if(i[2][0]=='['):
				wire_macseg_input.append(i[3])
			elif(i[2][0]=='i' or i[2][0]=='o'):
				wire_macseg_input.append(i[2])
		elif(i[0]=='//input'):
			wire_macseg_input.append(i[-1])
		elif(i[0]=='output'):
			if(i[2][0]=='['):
				wire_macseg_output.append(i[3])
			elif(i[2][0]=='i' or i[2][0]=='o'):
				wire_macseg_output.append(i[2])
		elif(i[0]=='//output'):
			wire_macseg_output.append(i[-1])
	for i in macseg_common:
		wire_macseg_common.append(i[-1])
	for i in macseg_krcommon:
		wire_macseg_krcommon.append(i[-1])

#print(wire_pcs_input)
kr_top,kr_top1,kr_top2 = [],[],[]
for i in wire_avst_input:
	if('kr' in i):
		kr_top1.append(i)
for i in wire_avst_output:
	if('kr' in i):
		kr_top2.append(i)
for i in wire_macseg_input:
	if('kr' in i):
		kr_top1.append(i)
for i in wire_macseg_output:
	if('kr' in i):
		kr_top2.append(i)
for i in wire_otn_input:
	if('kr' in i):
		kr_top1.append(i)
for i in wire_otn_output:
	if('kr' in i):
		kr_top2.append(i)
# Alekh: Below code filters out kR ports
#kr_top1.remove('i_kr_ctrl,')
#kr_top2.remove('o_kr_stat,')
wire_avst_input = [x for x in wire_avst_input if x not in kr_top1]
wire_avst_output = [x for x in wire_avst_output if x not in kr_top2]
wire_macseg_input = [x for x in wire_macseg_input if x not in kr_top1]
wire_macseg_output = [x for x in wire_macseg_output if x not in kr_top2]
wire_pcs_input = [x for x in wire_pcs_input if x not in kr_top1]
wire_pcs_output = [x for x in wire_pcs_output if x not in kr_top2]
wire_otn_input = [x for x in wire_otn_input if x not in kr_top1]
wire_otn_output = [x for x in wire_otn_output if x not in kr_top2]
kr_top=kr_top1+kr_top2
if('1' in INTERFACE):
	wire_avst_input.remove('i_refclk2pll,')
	wire_avst_input.remove('i_refclk2syspll,')
	wire_avst_input.remove('i_bk_refclk2pll,')
if('0' in INTERFACE):
	wire_macseg_input.remove('i_refclk2pll,')
	wire_macseg_input.remove('i_refclk2syspll,')
	wire_macseg_input.remove('i_bk_refclk2pll,')
if('2' in INTERFACE):
	wire_pcs_input.remove('i_refclk2pll,')
	wire_pcs_input.remove('i_refclk2syspll,')
if('3' in INTERFACE or '4' in INTERFACE):
	wire_otn_input.remove('i_refclk2pll,')
	wire_otn_input.remove('i_refclk2syspll,')
# Alekh: Below code process data type definaions
#print(tempvar_macseg)
for i in range(len(SPEED)):
	for k in kr_top:
		if(k=='i_clk_kr25g,' or k=='i_reset_kr25g,' or k=='i_kr_reconfig_read_kr25g,'or k=='i_kr_reconfig_write_kr25g,'):
			if(ANLT[i]==1):
				writetofile(f_op,'input wire '+k[:-4]+str(SPEED[i])+'g,\n')
		elif(k=='i_kr_reconfig_writedata_kr25g,'):
			if(ANLT[i]==1):
				writetofile(f_op,'input wire [31:0] '+k[:-4]+str(SPEED[i])+'g,\n')
		elif(k=='i_kr_reconfig_byte_en_kr25g,'):
			if(ANLT[i]==1):
				writetofile(f_op,'input wire [3:0] '+k[:-4]+str(SPEED[i])+'g,\n')
		elif(k=='i_kr_reconfig_addr_kr25g,'):
			if(ANLT[i]==1):
				writetofile(f_op,'input wire [11:0] '+k[:-4]+str(SPEED[i])+'g,\n')
		elif(k=='o_kr_reconfig_waitrequest_kr25g,' or k=='o_kr_reconfig_readdata_valid_kr25g,'):
			if(ANLT[i]==1):
				writetofile(f_op,'output wire '+k[:-4]+str(SPEED[i])+'g,\n')
		elif(k=='o_kr_reconfig_readdata_kr25g,'):
			if(ANLT[i]==1):
				writetofile(f_op,'output wire [31:0] '+k[:-4]+str(SPEED[i])+'g,\n')
	for num in range(INSTANCE[i]):
		if(PTP[i]=='1'):
			for k in ptp_signals_input:
				#print(k)
				if(k=='i_ptp_ts_req_ip0,'or k=='i_ptp_ins_ets_ip0,'or k=='i_ptp_ins_cf_ip0,'or k=='i_ptp_zero_csum_ip0,'or k=='i_ptp_update_eb_ip0,'or k=='i_ptp_p2p_ip0,'or k=='i_ptp_asym_ip0,'or k=='i_ptp_asym_sign_ip0,'):
					if(SPEED[i]=='400'):
						writetofile(f_op,'input wire [1:0] '+k[:-2]+str(a)+',\n')
					else:
						writetofile(f_op,'input wire [0:0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_ptp_fp_ip0,'):
					if(SPEED[i]=='400'):
						writetofile(f_op,'input wire [63:0] '+k[:-2]+str(a)+',\n')
					else:
						writetofile(f_op,'input wire [31:0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_ptp_ts_offset_ip0,'or k=='i_ptp_cf_offset_ip0,'or k=='i_ptp_csum_offset_ip0,'):
					if(SPEED[i]=='400'):
						writetofile(f_op,'input wire [31:0] '+k[:-2]+str(a)+',\n')
					else:
						writetofile(f_op,'input wire [15:0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_ptp_asym_p2p_idx_ip0,'):
					if(SPEED[i]=='400'):
						writetofile(f_op,'input wire [13:0] '+k[:-2]+str(a)+',\n')
					else:
						writetofile(f_op,'input wire [6:0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_ptp_tx_its_ip0,'):
					if(SPEED[i]=='400'):
						writetofile(f_op,'input wire [191:0] '+k[:-2]+str(a)+',\n')
					else:
						writetofile(f_op,'input wire [95:0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_ptp_tx_tod_ip0,'or k=='i_ptp_rx_tod_ip0,'):
					writetofile(f_op,'input wire [95:0] '+k[:-2]+str(a)+',\n')
				else:
					writetofile(f_op,'input wire '+k[:-2]+str(a)+',\n')
			for k in ptp_aib67_signals_input:
				if(k=='i_reconfig_ptp_p2p_addr_ip0,'or k=='i_reconfig_ptp_asym_addr_ip0,'):
					writetofile(f_op,'input wire [16:0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_reconfig_ptp_p2p_byteenable_ip0,'or k=='i_reconfig_ptp_asym_byteenable_ip0,'):
					writetofile(f_op,'input wire [3:0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_reconfig_ptp_p2p_writedata_ip0,'or k=='i_reconfig_ptp_asym_writedata_ip0,'):
					writetofile(f_op,'input wire [31:0] '+k[:-2]+str(a)+',\n')
				else:
					writetofile(f_op,'input wire '+k[:-2]+str(a)+',\n')
			for k in ptp_signals_output:
				if(k=='o_ptp_ets_ip0,'or k=='o_ptp_rx_its_ip0,'):
					if(SPEED[i]=='400'):
						writetofile(f_op,'output wire [191:0] '+k[:-2]+str(a)+',\n')
					else:
						writetofile(f_op,'output wire [95:0] '+k[:-2]+str(a)+',\n')
				elif(k=='o_ptp_ets_fp_ip0,'):
					if(SPEED[i]=='400'):
						writetofile(f_op,'output wire [63:0] '+k[:-2]+str(a)+',\n')
					else:
						writetofile(f_op,'output wire [31:0] '+k[:-2]+str(a)+',\n')
				elif(k=='o_ptp_ets_valid_ip0,'):
					if(SPEED[i]=='400'):
						writetofile(f_op,'output wire [1:0] '+k[:-2]+str(a)+',\n')
					else:
						writetofile(f_op,'output wire [0:0] '+k[:-2]+str(a)+',\n')
				elif(k=='o_ptp_rx_its_valid_ip0,'):
					if(ptp_debug_acc_en == 1):
						if(SPEED[i]=='400'):
							writetofile(f_op,'output wire [1:0] '+k[:-2]+str(a)+',\n')
						else:
							writetofile(f_op,'output wire [0:0] '+k[:-2]+str(a)+',\n')
				elif(k=='o_ptp_rx_its_vl_ip0,'or k=='o_ptp_ets_vl_ip0,'):
					if(ptp_debug_acc_en == 1):
						if(SPEED[i]=='400'):
							writetofile(f_op,'output wire [9:0] '+k[:-2]+str(a)+',\n')
						else:
							writetofile(f_op,'output wire [4:0] '+k[:-2]+str(a)+',\n')
				else:
					writetofile(f_op,'output wire '+k[:-2]+str(a)+',\n')
			for k in ptp_aib67_signals_output:
				if(k=='o_reconfig_ptp_p2p_readdata_ip0,'or k=='o_reconfig_ptp_asym_readdata_ip0,'):
					writetofile(f_op,'input wire [31:0] '+k[:-2]+str(a)+',\n')
				else:
					writetofile(f_op,'output wire '+k[:-2]+str(a)+',\n')
		if(INTERFACE[i]=='1'):
			writetofile(f_op,'//inst%s\n'%a)
			for k in wire_avst_input:
				if(k=='i_tx_data_ip0,'):
					writetofile(f_op,'input wire '+'['+str(widths_avst[SPEED[i]])+':0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_rx_serial_ip0,' or k=='i_rx_serial_n_ip0,'):
					writetofile(f_op,'input wire '+'['+str(int(NUMTXLANE[i])-1)+':0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_tx_empty_ip0,'):
					writetofile(f_op,'input wire '+'['+str(widths_empty_avst[SPEED[i]])+':0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_xcvr_mode_ip0,'):
					writetofile(f_op,'input wire '+'['+str(1)+':0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_tx_pfc_ip0,'):
					writetofile(f_op,'input wire '+'[7:0] '+k[:-2]+str(a)+',\n')
				#elif(k=='i_kr_ctrl,'):
					#if(ANLT[i]==1):
						#writetofile(f_op,'input wire '+'[7:0] '+k[:-1]+',\n')
				
				elif(k=='i_custom_cadence_ip0,'):
					if(SYSPLL[i]=='3' and CUSTOM_CADENCE_GUI[i]=='1'):
						writetofile(f_op,'input wire '+k[:-2]+str(a)+',\n')
				elif(k=='i_tx_preamble_ip0,'):
					if((SPEED[i]=='40' or SPEED[i]=='50') and PP[i]=='1'):
						writetofile(f_op,'input wire '+'[63:0] '+k[:-2]+str(a)+',\n')
					else:
						writetofile(f_op,'//input wire '+'[63:0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_reconfig_eth_addr_ip0,'):
					writetofile(f_op,'input wire '+'[19:0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_reconfig_eth_writedata_ip0,'):
					writetofile(f_op,'input wire '+'[31:0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_reconfig_eth_byteenable_ip0,'):
					writetofile(f_op,'input wire '+'[3:0] '+k[:-2]+str(a)+',\n')
				#elif(k=='i_reconfig_eth_mac_addr_ip0,'):
				#	writetofile(f_op,'input wire '+'[19:0] '+k[:-2]+str(a)+',\n')
				#elif(k=='i_reconfig_eth_mac_writedata_ip0,'):
				#	writetofile(f_op,'input wire '+'[31:0] '+k[:-2]+str(a)+',\n')
				#elif(k=='i_reconfig_eth_mac_byteenable_ip0,'):
				#	writetofile(f_op,'input wire '+'[3:0] '+k[:-2]+str(a)+',\n')
				#elif(k=='i_reconfig_eth_phy_addr_ip0,'):
				#	writetofile(f_op,'input wire '+'[19:0] '+k[:-2]+str(a)+',\n')
				#elif(k=='i_reconfig_eth_phy_writedata_ip0,'):
				#	writetofile(f_op,'input wire '+'[31:0] '+k[:-2]+str(a)+',\n')
				#elif(k=='i_reconfig_eth_phy_byteenable_ip0,'):
				#	writetofile(f_op,'input wire '+'[3:0] '+k[:-2]+str(a)+',\n')


				#elif(k=='i_clk_kr25g,' or k=='i_reset_kr25g,' or k=='i_kr_reconfig_read_kr25g,'or k=='i_kr_reconfig_write_kr25g,'):
					#if(ANLT[i]==1):
						#writetofile(f_op,'input wire '+k[:-4]+str(SPEED[i])+'g,\n')
				#elif(k=='i_kr_reconfig_writedata_kr25g,'):
					#if(ANLT[i]==1):
						#writetofile(f_op,'input wire [31:0] '+k[:-4]+str(SPEED[i])+'g,\n')
				#elif(k=='i_kr_reconfig_byte_en_kr25g,'):
					#if(ANLT[i]==1):
						#writetofile(f_op,'input wire [3:0] '+k[:-4]+str(SPEED[i])+'g,\n')
				#elif(k=='i_kr_reconfig_addr_kr25g,'):
					#if(ANLT[i]==1):
						#writetofile(f_op,'input wire [11:0] '+k[:-4]+str(SPEED[i])+'g,\n')
				elif(k=='i_reconfig_xcvr0_write_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'input wire '+k[:-12]+str(p)+'_write_ip'+str(a)+',\n')
				elif(k=='i_reconfig_xcvr0_read_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'input wire '+k[:-11]+str(p)+'_read_ip'+str(a)+',\n')
				elif(k=='i_reconfig_xcvr0_byteenable_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'input wire [3:0] '+k[:-17]+str(p)+'_byteenable_ip'+str(a)+',\n')
				elif(k=='i_reconfig_xcvr0_address_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'input wire [19:0] '+k[:-14]+str(p)+'_address_ip'+str(a)+',\n')
				elif(k=='i_reconfig_xcvr0_writedata_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'input wire [31:0] '+k[:-16]+str(p)+'_writedata_ip'+str(a)+',\n')
				elif(k=='i_reconfig_eth_mac_addr_ip0,'):
					writetofile(f_op,'input wire '+'[19:0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_reconfig_eth_mac_writedata_ip0,'):
					writetofile(f_op,'input wire '+'[31:0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_reconfig_eth_mac_byteenable_ip0,'):
					writetofile(f_op,'input wire '+'[3:0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_reconfig_eth_rcfg_addr_ip0,'):
					writetofile(f_op,'input wire '+'[19:0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_reconfig_eth_rcfg_writedata_ip0,'):
					writetofile(f_op,'input wire '+'[31:0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_reconfig_eth_rcfg_byteenable_ip0,'):
					writetofile(f_op,'input wire '+'[3:0] '+k[:-2]+str(a)+',\n')
                                else:

					writetofile(f_op,'input wire '+k[:-2]+str(a)+',\n')
			for k in wire_avst_output:
				if(k=='o_rx_data_ip0,'):
					writetofile(f_op,'output wire '+'['+str(widths_avst[SPEED[i]])+':0] '+k[:-2]+str(a)+',\n')
				elif(k=='o_tx_serial_ip0,' or k=='o_tx_serial_n_ip0,'):
					writetofile(f_op,'output wire '+'['+str(int(NUMTXLANE[i])-1)+':0] '+k[:-2]+str(a)+',\n')
				elif(k=='o_rx_empty_ip0,'):
					writetofile(f_op,'output wire '+'['+str(widths_empty_avst[SPEED[i]])+':0] '+k[:-2]+str(a)+',\n')
				elif(k=='o_rx_pfc_ip0,'):
					writetofile(f_op,'output wire '+'[7:0] '+k[:-2]+str(a)+',\n')
				#elif(k=='o_kr_stat,'):
				#	if(ANLT[i]==1):
				#		writetofile(f_op,'output wire '+'[7:0] '+k[:-1]+',\n')
				elif(k=='anlt_link,'):
					if(ANLT[i]==1):
						writetofile(f_op,'output wire '+'['+str(int(num_ports[i])-1)+':0] '+k[:-1]+',\n')
				#TODO: EFIFO not available yet. Temporary remove
				elif(k=='o_xcvrif_txfifo_pfull,' or k=='o_xcvrif_txfifo_pempty,' or k=='o_xcvrif_txfifo_empty,' or k=='o_xcvrif_hold_interrupt,'):
					if(SYSPLL[i]=='3'):
						#writetofile(f_op,'output wire '+'['+str(widths_txmac_macseg[SPEED[i]])+':0] '+k+"\n")
						writetofile(f_op,"//EFIFO not available yet. Temporary remove \n")
				elif(k=='o_rx_error_ip0,'):
					writetofile(f_op,'output wire '+'[5:0] '+k[:-2]+str(a)+',\n')
				elif(k=='o_rx_status_data_ip0,'):
					writetofile(f_op,'output wire '+'[39:0] '+k[:-2]+str(a)+',\n')
				elif(k=='o_rx_preamble_ip0,'):
					if((SPEED[i]=='40' or SPEED[i]=='50') and PP[i]=='1'):
						writetofile(f_op,'output wire '+'[63:0] '+k[:-2]+str(a)+',\n')
					else:
						writetofile(f_op,'//output wire '+'[63:0] '+k[:-2]+str(a)+',\n')
				elif(k=='o_reconfig_eth_readdata_ip0,'):
					writetofile(f_op,'output wire '+'[31:0] '+k[:-2]+str(a)+',\n')
				#elif(k=='o_reconfig_eth_mac_readdata_ip0,'):
				#	writetofile(f_op,'output wire '+'[31:0] '+k[:-2]+str(a)+',\n')
				#elif(k=='o_reconfig_eth_phy_readdata_ip0,'):
				#	writetofile(f_op,'output wire '+'[31:0] '+k[:-2]+str(a)+',\n')
				elif(k=='o_reconfig_xcvr0_waitrequest_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'output wire '+k[:-18]+str(p)+'_waitrequest_ip'+str(a)+',\n')
				elif(k=='o_reconfig_xcvr0_readdata_valid_ip0'):
					for p in range(int(NUMTXLANE[i])):
						if(p == (int(NUMTXLANE[i])-1) and a ==sum(INSTANCE)-1):
							writetofile(f_op,'output wire '+k[:-21]+str(p)+'_readdata_valid_ip'+str(a)+'\n);')
						else:
							writetofile(f_op,'output wire '+k[:-21]+str(p)+'_readdata_valid_ip'+str(a)+',\n\n')
				elif(k=='o_reconfig_xcvr0_readdata_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'output wire [31:0] '+k[:-15]+str(p)+'_readdata_ip'+str(a)+',\n')
				elif(k=='o_reconfig_eth_mac_readdata_ip0,'):
					writetofile(f_op,'output wire '+'[31:0] '+k[:-2]+str(a)+',\n')
				elif(k=='o_reconfig_eth_rcfg_readdata_ip0,'):
				     	writetofile(f_op,'output wire '+'[31:0] '+k[:-2]+str(a)+',\n')
                                else:
					writetofile(f_op,'output wire '+k[:-2]+str(a)+',\n')
		if(INTERFACE[i]=='2'):
			writetofile(f_op,'//inst%s\n'%i)
			for k in wire_pcs_input:
				if(k=='i_tx_mii_d_ip0,'):
					writetofile(f_op,'input wire '+'['+str(widths_pcsonly[SPEED[i]])+':0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_tx_mii_c_ip0,'):
					writetofile(f_op,'input wire '+'['+str(int((int(widths_pcsonly[SPEED[i]])+1)*8/64)-1)+':0] '+k[:-2]+str(a)+',\n')
				#elif(k=='i_kr_ctrl,'):
					#if(ANLT[i]==1):
						#writetofile(f_op,'input wire '+'[7:0] '+k[:-1]+',\n')
				#elif(k=='i_clk_kr25g,' or k=='i_reset_kr25g,' or k=='i_kr_reconfig_read_kr25g,'or k=='i_kr_reconfig_write_kr25g,'):
					#if(ANLT[i]==1):
						#writetofile(f_op,'input wire '+k[:-4]+str(SPEED[i])+'g,\n')
				#elif(k=='i_kr_reconfig_writedata_kr25g,'):
					#if(ANLT[i]==1):
						#writetofile(f_op,'input wire [31:0] '+k[:-4]+str(SPEED[i])+'g,\n')
				#elif(k=='i_kr_reconfig_byte_en_kr25g,'):
					#if(ANLT[i]==1):
						#writetofile(f_op,'input wire [3:0] '+k[:-4]+str(SPEED[i])+'g,\n')
				#elif(k=='i_kr_reconfig_addr_kr25g,'):
					#if(ANLT[i]==1):
						#writetofile(f_op,'input wire [11:0] '+k[:-4]+str(SPEED[i])+'g,\n')
				elif(k=='i_custom_cadence_ip0,'):
					if(SYSPLL[i]=='3' and CUSTOM_CADENCE_GUI[i]=='1'):
						writetofile(f_op,'input wire '+k[:-2]+str(a)+',\n')
				elif(k=='i_reconfig_eth_addr_ip0,'):
					writetofile(f_op,'input wire '+'[19:0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_reconfig_eth_writedata_ip0,'):
					writetofile(f_op,'input wire '+'[31:0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_reconfig_eth_mac_addr_ip0,'):
					writetofile(f_op,'input wire '+'[19:0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_reconfig_eth_mac_writedata_ip0,'):
					writetofile(f_op,'input wire '+'[31:0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_reconfig_eth_mac_byteenable_ip0,'):
					writetofile(f_op,'input wire '+'[3:0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_reconfig_eth_rcfg_addr_ip0,'):
					writetofile(f_op,'input wire '+'[19:0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_reconfig_eth_rcfg_writedata_ip0,'):
					writetofile(f_op,'input wire '+'[31:0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_reconfig_eth_rcfg_byteenable_ip0,'):
					writetofile(f_op,'input wire '+'[3:0] '+k[:-2]+str(a)+',\n')

				elif(k=='i_reconfig_xcvr0_write_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'input wire '+k[:-12]+str(p)+'_write_ip'+str(a)+',\n')
                                elif(k=='i_reconfig_eth_byteenable_ip0,'):
					writetofile(f_op,'input wire '+'[3:0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_reconfig_xcvr0_read_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'input wire '+k[:-11]+str(p)+'_read_ip'+str(a)+',\n')
				elif(k=='i_reconfig_xcvr0_byteenable_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'input wire [3:0] '+k[:-17]+str(p)+'_byteenable_ip'+str(a)+',\n')
				elif(k=='i_reconfig_xcvr0_address_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'input wire [19:0] '+k[:-14]+str(p)+'_address_ip'+str(a)+',\n')
				elif(k=='i_reconfig_xcvr0_writedata_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'input wire [31:0] '+k[:-16]+str(p)+'_writedata_ip'+str(a)+',\n')
				elif(k=='i_rx_serial_ip0,' or k=='i_rx_serial_n_ip0,'):
					writetofile(f_op,'input wire '+'['+str(int(NUMTXLANE[i])-1)+':0] '+k[:-2]+str(a)+',\n')
				else:
					writetofile(f_op,'input wire '+k[:-2]+str(a)+',\n')
			for k in wire_pcs_output:
				if(k=='o_rx_mii_d_ip0,'):
					writetofile(f_op,'output wire '+'['+str(widths_pcsonly[SPEED[i]])+':0] '+k[:-2]+str(a)+',\n')
				elif(k=='o_rx_mii_c_ip0,'):
					writetofile(f_op,'output wire '+'['+str(int((int(widths_pcsonly[SPEED[i]])+1)*8/64)-1)+':0] '+k[:-2]+str(a)+',\n')
				#elif(k=='o_kr_stat,'):
				#	if(ANLT[i]==1):
				#		writetofile(f_op,'output wire '+'[7:0] '+k[:-1]+',\n')
				elif(k=='anlt_link,'):
					if(ANLT[i]==1):
						writetofile(f_op,'output wire '+'['+str(int(num_ports[i])-1)+':0] '+k[:-1]+',\n')
				#elif(k=='o_kr_reconfig_waitrequest_kr25g,' or k=='o_kr_reconfig_readdata_valid_kr25g,'):
					#if(ANLT[i]==1):
						#writetofile(f_op,'output wire '+k[:-4]+str(SPEED[i])+'g,\n')
				#elif(k=='o_kr_reconfig_readdata_kr25g,'):
					#if(ANLT[i]==1):
						#writetofile(f_op,'output wire [31:0] '+k[:-4]+str(SPEED[i])+'g,\n')
				#if(k=='o_rx_block_lock_ip0,'):
				#	if(a==sum(INSTANCE)-1):
				#		writetofile(f_op,'output wire '+k[:-2]+str(a)+'\n);\n')
				#	else:
				#		writetofile(f_op,'output wire '+k[:-2]+str(a)+',\n')
				elif(k=='o_reconfig_eth_readdata_ip0,'):
					writetofile(f_op,'output wire '+'[31:0] '+k[:-2]+str(a)+',\n')
				elif(k=='o_reconfig_eth_mac_readdata_ip0,'):
					writetofile(f_op,'output wire '+'[31:0] '+k[:-2]+str(a)+',\n')
				elif(k=='o_reconfig_eth_rcfg_readdata_ip0,'):
				     	writetofile(f_op,'output wire '+'[31:0] '+k[:-2]+str(a)+',\n')

				elif(k=='o_reconfig_xcvr0_waitrequest_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'output wire '+k[:-18]+str(p)+'_waitrequest_ip'+str(a)+',\n')
				elif(k=='o_reconfig_xcvr0_readdata_valid_ip0'):
					for p in range(int(NUMTXLANE[i])):
						if(p == (int(NUMTXLANE[i])-1) and a ==sum(INSTANCE)-1):
							writetofile(f_op,'output wire '+k[:-21]+str(p)+'_readdata_valid_ip'+str(a)+'\n);')
						else:
						        writetofile(f_op,'output wire '+k[:-21]+str(p)+'_readdata_valid_ip'+str(a)+',\n\n')
				elif(k=='o_reconfig_xcvr0_readdata_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'output wire [31:0] '+k[:-15]+str(p)+'_readdata_ip'+str(a)+',\n')
				elif(k=='o_tx_serial_ip0,' or k=='o_tx_serial_n_ip0,'):
					writetofile(f_op,'output wire '+'['+str(int(NUMTXLANE[i])-1)+':0] '+k[:-2]+str(a)+',\n')
				else:
					writetofile(f_op,'output wire '+k[:-2]+str(a)+',\n')
		if(INTERFACE[i]=='3' or INTERFACE[i]=='4'):
			writetofile(f_op,'//inst%s\n'%i)
			for k in wire_otn_input:
				if(k=='i_tx_pcs66_d_ip0,'):
					writetofile(f_op,'input wire '+'['+str(widths_otnflexe[SPEED[i]])+':0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_rx_serial_ip0,' or k=='i_rx_serial_n_ip0,'):
					writetofile(f_op,'input wire '+'['+str(int(NUMTXLANE[i])-1)+':0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_custom_cadence_ip0,'):
					if(SYSPLL[i]=='3' and CUSTOM_CADENCE_GUI[i]=='1'):
						writetofile(f_op,'input wire '+k[:-2]+str(a)+',\n')
				elif(k=='i_reconfig_eth_addr_ip0,'):
					writetofile(f_op,'input wire '+'[19:0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_reconfig_eth_byteenable_ip0,'):
					writetofile(f_op,'input wire '+'[3:0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_reconfig_eth_mac_addr_ip0,'):
					writetofile(f_op,'input wire '+'[19:0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_reconfig_eth_mac_writedata_ip0,'):
					writetofile(f_op,'input wire '+'[31:0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_reconfig_eth_mac_byteenable_ip0,'):
					writetofile(f_op,'input wire '+'[3:0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_reconfig_eth_rcfg_addr_ip0,'):
					writetofile(f_op,'input wire '+'[19:0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_reconfig_eth_rcfg_writedata_ip0,'):
					writetofile(f_op,'input wire '+'[31:0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_reconfig_eth_rcfg_byteenable_ip0,'):
					writetofile(f_op,'input wire '+'[3:0] '+k[:-2]+str(a)+',\n')

				elif(k=='i_tx_pfc_ip0,'):
					writetofile(f_op,'input wire '+'[7:0] '+k[:-2]+str(a)+',\n')
				#elif(k=='i_kr_ctrl,'):
					#if(ANLT[i]==1):
						#writetofile(f_op,'input wire '+'[7:0] '+k[:-1]+',\n')
				#elif(k=='i_clk_kr25g,' or k=='i_reset_kr25g,' or k=='i_kr_reconfig_read_kr25g,'or k=='i_kr_reconfig_write_kr25g,'):
					#if(ANLT[i]==1):
						#writetofile(f_op,'input wire '+k[:-4]+str(SPEED[i])+'g,\n')
				#elif(k=='i_kr_reconfig_writedata_kr25g,'):
					#if(ANLT[i]==1):
						#writetofile(f_op,'input wire [31:0] '+k[:-4]+str(SPEED[i])+'g,\n')
				#elif(k=='i_kr_reconfig_byte_en_kr25g,'):
					#if(ANLT[i]==1):
						#writetofile(f_op,'input wire [3:0] '+k[:-4]+str(SPEED[i])+'g,\n')
				#elif(k=='i_kr_reconfig_addr_kr25g,'):
					#if(ANLT[i]==1):
						#writetofile(f_op,'input wire [11:0] '+k[:-4]+str(SPEED[i])+'g,\n')
				elif(k=='i_reconfig_eth_writedata_ip0,'):
					writetofile(f_op,'input wire '+'[31:0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_reconfig_xcvr0_write_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'input wire '+k[:-12]+str(p)+'_write_ip'+str(a)+',\n')
				elif(k=='i_reconfig_xcvr0_read_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'input wire '+k[:-11]+str(p)+'_read_ip'+str(a)+',\n')
				elif(k=='i_reconfig_xcvr0_byteenable_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'input wire [3:0] '+k[:-17]+str(p)+'_byteenable_ip'+str(a)+',\n')
				elif(k=='i_reconfig_xcvr0_address_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'input wire [19:0] '+k[:-14]+str(p)+'_address_ip'+str(a)+',\n')
				elif(k=='i_reconfig_xcvr0_writedata_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'input wire [31:0] '+k[:-16]+str(p)+'_writedata_ip'+str(a)+',\n')
				else:
					writetofile(f_op,'input wire '+k[:-2]+str(a)+',\n')
			for k in wire_otn_output:
				if(k=='o_rx_pcs66_d_ip0,'):
					writetofile(f_op,'output wire '+'['+str(widths_otnflexe[SPEED[i]])+':0] '+k[:-2]+str(a)+',\n')
				elif(k=='o_reconfig_eth_readdata_ip0,'):
					writetofile(f_op,'output wire '+'[31:0] '+k[:-2]+str(a)+',\n')
				elif(k=='o_reconfig_eth_mac_readdata_ip0,'):
					writetofile(f_op,'output wire '+'[31:0] '+k[:-2]+str(a)+',\n')
				elif(k=='o_reconfig_eth_rcfg_readdata_ip0,'):
				     	writetofile(f_op,'output wire '+'[31:0] '+k[:-2]+str(a)+',\n')

				elif(k=='o_rx_pfc_ip0,'):
					writetofile(f_op,'output wire '+'[7:0] '+k[:-2]+str(a)+',\n')
				#elif(k=='o_kr_stat,'):
				#	if(ANLT[i]==1):
				#		writetofile(f_op,'output wire '+'[7:0] '+k[:-1]+',\n')
				elif(k=='anlt_link,'):
					if(ANLT[i]==1):
						writetofile(f_op,'output wire '+'['+str(int(num_ports[i])-1)+':0] '+k[:-1]+',\n')
				#elif(k=='o_kr_reconfig_waitrequest_kr25g,' or k=='o_kr_reconfig_readdata_valid_kr25g,'):
					#if(ANLT[i]==1):
						#writetofile(f_op,'output wire '+k[:-4]+str(SPEED[i])+'g,\n')
				#elif(k=='o_kr_reconfig_readdata_kr25g,'):
					#if(ANLT[i]==1):
						#writetofile(f_op,'output wire [31:0] '+k[:-4]+str(SPEED[i])+'g,\n')
				elif(k=='o_reconfig_xcvr0_waitrequest_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'output wire '+k[:-18]+str(p)+'_waitrequest_ip'+str(a)+',\n')
				elif(k=='o_reconfig_xcvr0_readdata_valid_ip0'):
					for p in range(int(NUMTXLANE[i])):
						if(p == (int(NUMTXLANE[i])-1) and a ==sum(INSTANCE)-1):
							writetofile(f_op,'output wire '+k[:-21]+str(p)+'_readdata_valid_ip'+str(a)+'\n);')
						else:
							writetofile(f_op,'output wire '+k[:-21]+str(p)+'_readdata_valid_ip'+str(a)+',\n\n')
				elif(k=='o_reconfig_xcvr0_readdata_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'output wire [31:0] '+k[:-15]+str(p)+'_readdata_ip'+str(a)+',\n')
				elif(k=='o_tx_serial_ip0,' or k=='o_tx_serial_n_ip0,'):
					writetofile(f_op,'output wire '+'['+str(int(NUMTXLANE[i])-1)+':0] '+k[:-2]+str(a)+',\n')
				else:
					writetofile(f_op,'output wire '+k[:-2]+str(a)+',\n')
		if(INTERFACE[i]=='0'):
			writetofile(f_op,'//inst%s\n'%i)
			for k in wire_macseg_input:
				if(k=='i_tx_mac_data_ip0,'):
					writetofile(f_op,'input wire '+'['+str(widths_macseg[SPEED[i]])+':0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_tx_mac_inframe_ip0,'):
					writetofile(f_op,'input wire '+'['+str(widths_txmac_macseg[SPEED[i]])+':0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_tx_mac_eop_empty_ip0,'):
					writetofile(f_op,'input wire '+'['+str(int((int(widths_macseg[SPEED[i]])+1)*3/64)-1)+':0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_tx_pfc_ip0,'):
					writetofile(f_op,'input wire '+'[7:0] '+k[:-2]+str(a)+',\n')
				#elif(k=='i_kr_ctrl,'):
					#if(ANLT[i]==1):
						#writetofile(f_op,'input wire '+'[7:0] '+k[:-1]+',\n')
				#elif(k=='i_clk_kr25g,' or k=='i_reset_kr25g,' or k=='i_kr_reconfig_read_kr25g,'or k=='i_kr_reconfig_write_kr25g,'):
					#if(ANLT[i]==1):
						#writetofile(f_op,'input wire '+k[:-4]+str(SPEED[i])+'g,\n')
				#elif(k=='i_kr_reconfig_writedata_kr25g,'):
					#if(ANLT[i]==1):
						#writetofile(f_op,'input wire [31:0] '+k[:-4]+str(SPEED[i])+'g,\n')
				#elif(k=='i_kr_reconfig_byte_en_kr25g,'):
					#if(ANLT[i]==1):
						#writetofile(f_op,'input wire [3:0] '+k[:-4]+str(SPEED[i])+'g,\n')
				#elif(k=='i_kr_reconfig_addr_kr25g,'):
					#if(ANLT[i]==1):
						#writetofile(f_op,'input wire [11:0] '+k[:-4]+str(SPEED[i])+'g,\n')
				elif(k=='i_custom_cadence_ip0,'):
					if(SYSPLL[i]=='3' and CUSTOM_CADENCE_GUI[i]=='1'):
						writetofile(f_op,'input wire '+k[:-2]+str(a)+',\n')
				elif(k=='i_tx_mac_error_ip0,'):
					writetofile(f_op,'input wire '+'['+str(widths_txmac_macseg[SPEED[i]])+':0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_tx_mac_skip_crc_ip0,'):
					writetofile(f_op,'input wire '+'['+str(widths_txmac_macseg[SPEED[i]])+':0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_reconfig_eth_addr_ip0,'):
					writetofile(f_op,'input wire '+'[19:0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_reconfig_eth_writedata_ip0,'):
					writetofile(f_op,'input wire '+'[31:0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_reconfig_eth_byteenable_ip0,'):
					writetofile(f_op,'input wire '+'[3:0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_reconfig_eth_mac_addr_ip0,'):
					writetofile(f_op,'input wire '+'[19:0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_reconfig_eth_mac_writedata_ip0,'):
					writetofile(f_op,'input wire '+'[31:0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_reconfig_eth_mac_byteenable_ip0,'):
					writetofile(f_op,'input wire '+'[3:0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_reconfig_eth_rcfg_addr_ip0,'):
					writetofile(f_op,'input wire '+'[19:0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_reconfig_eth_rcfg_writedata_ip0,'):
					writetofile(f_op,'input wire '+'[31:0] '+k[:-2]+str(a)+',\n')
				elif(k=='i_reconfig_eth_rcfg_byteenable_ip0,'):
					writetofile(f_op,'input wire '+'[3:0] '+k[:-2]+str(a)+',\n')

				elif(k=='i_reconfig_xcvr0_write_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'input wire '+k[:-12]+str(p)+'_write_ip'+str(a)+',\n')
				elif(k=='i_reconfig_xcvr0_read_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'input wire '+k[:-11]+str(p)+'_read_ip'+str(a)+',\n')
				elif(k=='i_reconfig_xcvr0_byteenable_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'input wire [3:0] '+k[:-17]+str(p)+'_byteenable_ip'+str(a)+',\n')
				elif(k=='i_reconfig_xcvr0_address_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'input wire [19:0] '+k[:-14]+str(p)+'_address_ip'+str(a)+',\n')
				elif(k=='i_reconfig_xcvr0_writedata_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'input wire [31:0] '+k[:-16]+str(p)+'_writedata_ip'+str(a)+',\n')
				elif(k=='i_rx_serial_ip0,' or k=='i_rx_serial_n_ip0,'):
					writetofile(f_op,'input wire '+'['+str(int(NUMTXLANE[i])-1)+':0] '+k[:-2]+str(a)+',\n')
				else:
					writetofile(f_op,'input wire '+k[:-2]+str(a)+',\n')
			for k in wire_macseg_output:
				if(k=='o_rx_mac_data_ip0,'):
					writetofile(f_op,'output wire '+'['+str(widths_macseg[SPEED[i]])+':0] '+k[:-2]+str(a)+',\n')
				elif(k=='o_rx_mac_inframe_ip0,'):
					writetofile(f_op,'output wire '+'['+str(widths_txmac_macseg[SPEED[i]])+':0] '+k[:-2]+str(a)+',\n')
				elif(k=='o_rx_pfc_ip0,'):
					writetofile(f_op,'output wire '+'[7:0] '+k[:-2]+str(a)+',\n')
				elif(k=='o_rx_mac_eop_empty_ip0,'):
					writetofile(f_op,'output wire '+'['+str(int((int(widths_macseg[SPEED[i]])+1)*3/64)-1)+':0] '+k[:-2]+str(a)+',\n')
				#TODO: EFIFO not available yet. Temporary remove	
				elif(k=='o_xcvrif_txfifo_pfull,' or k=='o_xcvrif_txfifo_pempty,' or k=='o_xcvrif_txfifo_empty,' or k=='o_xcvrif_hold_interrupt,'):
					if(SYSPLL[i]=='3'):
						#writetofile(f_op,'output wire '+'['+str(widths_txmac_macseg[SPEED[i]])+':0] '+k+';'+"\n")
						writetofile(f_op,"//EFIFO not available yet. Temporary remove \n")
				elif(k=='o_rx_mac_error_ip0,'):
					writetofile(f_op,'output wire '+'['+str(int(int(widths_txmac_macseg[SPEED[i]])*2)+1)+':0] '+k[:-2]+str(a)+',\n')
				#elif(k=='o_kr_stat,'):
				#	if(ANLT[i]==1):
				#		writetofile(f_op,'output wire '+'[7:0] '+k[:-1]+',\n')
				elif(k=='anlt_link,'):
					if(ANLT[i]==1):
						writetofile(f_op,'output wire '+'['+str(int(num_ports[i])-1)+':0] '+k[:-1]+',\n')
				#elif(k=='o_kr_reconfig_waitrequest_kr25g,' or k=='o_kr_reconfig_readdata_valid_kr25g,'):
					#if(ANLT[i]==1):
						#writetofile(f_op,'output wire '+k[:-4]+str(SPEED[i])+'g,\n')
				#elif(k=='o_kr_reconfig_readdata_kr25g,'):
					#if(ANLT[i]==1):
						#writetofile(f_op,'output wire [31:0] '+k[:-4]+str(SPEED[i])+'g,\n')
				elif(k=='o_rx_mac_fcs_error_ip0,'):
					writetofile(f_op,'output wire '+'['+str(widths_txmac_macseg[SPEED[i]])+':0] '+k[:-2]+str(a)+',\n')
				elif(k=='o_rx_mac_status_ip0,'):
					writetofile(f_op,'output wire '+'['+str(int((int(widths_macseg[SPEED[i]])+1)*3/64)-1)+':0] '+k[:-2]+str(a)+',\n')
				elif(k=='o_rxstatus_data_ip0,'):
					writetofile(f_op,'output wire '+'[39:0] '+k[:-2]+str(a)+',\n')
				elif(k=='o_reconfig_eth_readdata_ip0,'):
					writetofile(f_op,'output wire '+'[31:0] '+k[:-2]+str(a)+',\n')
				elif(k=='o_reconfig_eth_mac_readdata_ip0,'):
					writetofile(f_op,'output wire '+'[31:0] '+k[:-2]+str(a)+',\n')
				elif(k=='o_reconfig_eth_rcfg_readdata_ip0,'):
				     	writetofile(f_op,'output wire '+'[31:0] '+k[:-2]+str(a)+',\n')

				elif(k=='o_reconfig_xcvr0_waitrequest_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'output wire '+k[:-18]+str(p)+'_waitrequest_ip'+str(a)+',\n')
				elif(k=='o_reconfig_xcvr0_readdata_valid_ip0'):
					for p in range(int(NUMTXLANE[i])):
						if(p == (int(NUMTXLANE[i])-1) and a ==sum(INSTANCE)-1):
							writetofile(f_op,'output wire '+k[:-21]+str(p)+'_readdata_valid_ip'+str(a)+'\n);')
						else:
							writetofile(f_op,'output wire '+k[:-21]+str(p)+'_readdata_valid_ip'+str(a)+',\n\n')
				elif(k=='o_reconfig_xcvr0_readdata_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'output wire [31:0] '+k[:-15]+str(p)+'_readdata_ip'+str(a)+',\n')
				elif(k=='o_tx_serial_ip0,' or k=='o_tx_serial_n_ip0,'):
					writetofile(f_op,'output wire '+'['+str(int(NUMTXLANE[i])-1)+':0] '+k[:-2]+str(a)+',\n')
				else:
					writetofile(f_op,'output wire '+k[:-2]+str(a)+',\n')
		a+=1
common,common_kr = [],[]
if('1' in INTERFACE):
	common += wire_avst_common
if('0' in INTERFACE):
	common += wire_macseg_common
if('2' in INTERFACE):
	common += wire_pcs_common
if('3' in INTERFACE or '4' in INTERFACE):
	common += wire_otn_common

# Kanishk:  I have not included for each template for kr so in future if need so please do it for individual
if(1 in ANLT):
  if('1' in INTERFACE):
    common_kr += wire_avst_krcommon
  if('0' in INTERFACE):
    common_kr += wire_macseg_krcommon
  if('2' in INTERFACE):
    common_kr += wire_pcs_common
  if('3' in INTERFACE or '4' in INTERFACE):
    common_kr += wire_otn_common

for i in range(len(SPEED)):
	if(ANLT[i]==1):
		for j in common_kr:
			#if(j=='kr_stat_kr25g[x-1];'or j=='kr_ctrl_kr25g[x-1];'):
			if(j=='anlt_link_kr25g[x-1];'):
				writetofile(f_op,'\nwire ['+str(int(num_ports[i])-1)+':0] '+j[:-9]+str(SPEED[i])+'g;'+'\n')
			elif(j=='xcvr_reconfig_writedata_kr25g;' or j=='xcvr_reconfig_readdata_kr25g;'):
				writetofile(f_op,'wire [31:0] '+j[:-4]+str(SPEED[i])+'g;'+'\n')
			elif(j=='xcvr_reconfig_byte_en_kr25g;'):
				writetofile(f_op,'wire [3:0] '+j[:-4]+str(SPEED[i])+'g;'+'\n')
			elif(j=='xcvr_reconfig_addr_kr25g;'):
				writetofile(f_op,'wire [19:0] '+j[:-4]+str(SPEED[i])+'g;'+'\n')
			else:
				writetofile(f_op,'wire '+j[:-4]+str(SPEED[i])+'g;'+'\n')
inter_common=[]
[inter_common.append(x) for x in common if x not in inter_common]
for i in inter_common:
	writetofile(f_op,'\n\nwire %s'%i+'\n\n')
for i in range(len(SPEED)):
	if(PTP[i]=='1'):
		writetofile(f_op,'\nwire ptp_link;\n')
wire_avst_input+=wire_avst_common
wire_pcs_input+=wire_pcs_common
wire_macseg_input+=wire_macseg_common
wire_otn_input+=wire_otn_common
#wire_avst_input= ['i_kr_ctrl,'] + wire_avst_input
#wire_avst_output = ['o_kr_stat,'] + wire_avst_output
#wire_macseg_input = ['i_kr_ctrl,'] + wire_macseg_input
#wire_macseg_output = ['o_kr_stat,'] +wire_macseg_output
#wire_pcs_input = ['i_kr_ctrl,'] + wire_pcs_input
#wire_pcs_output = ['o_kr_stat,'] +wire_pcs_output
#wire_otn_input = ['i_kr_ctrl,'] +wire_otn_input
#wire_otn_output = ['o_kr_stat,'] +wire_otn_output
wire_avst_output = ['anlt_link,'] + wire_avst_output
wire_macseg_output = ['anlt_link,'] +wire_macseg_output
wire_pcs_output = ['anlt_link,'] +wire_pcs_output
wire_otn_output = ['anlt_link,'] +wire_otn_output
a=0

for i in range(len(SPEED)):
	if(ANLT[i]==1):
		#writetofile(f_op,'\ntop_kr%sg #() u_top_kr_%sg (\n\n'%(SPEED[i],SPEED[i]))
         	writetofile(f_op,'\neth_anlt_f_ip0  kr_dut(\n')
		for j in kr_top:
			writetofile(f_op,'.'+j[:-7]+'('+j[:-4]+'%sg),\n'%str(SPEED[i]))
		for j in common_kr:
			if(j=='anlt_link_kr25g[x-1];'):
		                writetofile(f_op,'.anlt_link(anlt_link_kr%sg)\n'%str(SPEED[i]))
			#if(j=='kr_stat_kr25g[x-1];'):
			#        #FIXME RAM For MultiNode
			#	#writetofile(f_op,'.i_kr_stat('+j[:-9]+str(SPEED[i])+'g),\n')
		        #        writetofile(f_op,'.i_kr_stat(kr_stat_kr%sg),\n'%str(SPEED[i]))
			#elif(j=='kr_ctrl_kr25g[x-1];'):
			#	#writetofile(f_op,'.o_kr_ctrl('+j[:-9]+str(SPEED[i])+'g),\n')
		        #        writetofile(f_op,'.o_kr_ctrl(kr_ctrl_kr%sg)\n'%str(SPEED[i]))
			#elif(j=='xcvr_reconfig_addr_kr25g;' or j=='xcvr_reconfig_read_kr25g;' or j=='xcvr_reconfig_write_kr25g;' or j=='xcvr_reconfig_byte_en_kr25g;' or j=='xcvr_reconfig_writedata_kr25g;'):
				#writetofile(f_op,'.o_'+j[:-7]+'('+j[:-4]+str(SPEED[i])+'g),\n')
			#elif(j=='xcvr_reconfig_readdata_kr25g;' or j=='xcvr_reconfig_readdata_valid_kr25g;'):
				#writetofile(f_op,'.i_'+j[:-7]+'('+j[:-4]+str(SPEED[i])+'g),\n')
			elif(j=='xcvr_reconfig_waitrequest_kr25g;'):
				writetofile(f_op,'//.i_'+j[:-7]+'('+j[:-4]+str(SPEED[i])+'g)\n);')


#	if(ANLT[i]==1):
#         	writetofile(f_op,'\ngavmm_f_0 gavmm_inst(\n')
#		writetofile(f_op,'.g_avmm_clk(i_clk_kr%sg),\n'%str(SPEED[i]))
#		writetofile(f_op,'.g_avmm_reset(i_reset_kr%sg),\n'%str(SPEED[i]))
#		writetofile(f_op,'.g_avmm_write(xcvr_reconfig_write_kr%sg),\n'%str(SPEED[i]))
#		writetofile(f_op,'.g_avmm_read(xcvr_reconfig_read_kr%sg),\n'%str(SPEED[i]))
#		writetofile(f_op,'.g_avmm_address(xcvr_reconfig_addr_kr%sg[19:2]),\n'%str(SPEED[i]))
#		writetofile(f_op,'.g_avmm_byteenable(xcvr_reconfig_byte_en_kr%sg),\n'%str(SPEED[i]))
#		writetofile(f_op,'.g_avmm_writedata(xcvr_reconfig_writedata_kr%sg),\n'%str(SPEED[i]))
#		writetofile(f_op,'.g_avmm_readdata(xcvr_reconfig_readdata_kr%sg),\n'%str(SPEED[i]))
#		writetofile(f_op,'.g_avmm_waitrequest(xcvr_reconfig_waitrequest_kr%sg),\n'%str(SPEED[i]))
#		writetofile(f_op,'.g_avmm_readdatavalid(xcvr_reconfig_readdata_valid_kr%sg)\n );'%str(SPEED[i]))

for i in range(len(SPEED)):
	az=0;
	for j in range(INSTANCE[i]):
		writetofile(f_op,'\ntop_ip%s #() ip%s (\n\n'%(i,a))
		if(PTP[i]=='1'):
			for k in ptp_signals_input:
				writetofile(f_op,'.'+k[:-5]+'('+k[:-2]+str(a)+'),\n')
			for k in ptp_signals_output:
				if(k=='o_ptp_rx_its_valid_ip0,' or k=='o_ptp_rx_its_vl_ip0,'or k=='o_ptp_ets_vl_ip0,'):
					if(ptp_debug_acc_en == 1):
						writetofile(f_op,'.'+k[:-5]+'('+k[:-2]+str(a)+'),\n')
				else:
					writetofile(f_op,'.'+k[:-5]+'('+k[:-2]+str(a)+'),\n')
			writetofile(f_op,'.ptp_link(ptp_link),\n')
                        if(ENASYNCAD[i]=='1'):
                        	writetofile(f_op,'.i_clk_pll(o_clk_pll_ip0),\n')
		if(INTERFACE[i]=='1'):
			for x in wire_avst_input:
				if(x=='i_clk_tx_ip0,'):
					if(PTP[i]=='1' and ENASYNCAD[i]=='0'):
						writetofile(f_op,'.i_clk_tx(o_clk_pll_ip0),\n')
					else:
						writetofile(f_op,'.i_clk_tx(i_clk_tx_ip0),\n')
				elif(x=='i_clk_rx_ip0,'):
					if(PTP[i]=='1' and ENASYNCAD[i]=='0'):
						writetofile(f_op,'.i_clk_rx(o_clk_pll_ip0),\n')
                                        else:
                                                writetofile(f_op,'.i_clk_rx(i_clk_rx_ip0),\n')
                                #elif(x=='i_reconfig_eth_mac_addr_ip0'):
                                #    writetofile(f_op,'.i_reconfig_eth_mac_addr_ip0(reconfig_eth_mac_addr_ip0),\n')
                                #elif(x=='i_reconfig_eth_mac_read_ip0'):
                                #    writetofile(f_op,'.i_reconfig_eth_mac_read_ip0(reconfig_eth_mac_read_ip0),\n')
                                #elif(x=='i_reconfig_eth_mac_write_ip0'):
                                #    writetofile(f_op,'.i_reconfig_eth_mac_write_ip0(reconfig_eth_mac_write_ip0),\n')
                                #elif(x=='i_reconfig_eth_mac_writedata_ip0'):
                                #    writetofile(f_op,'.i_reconfig_eth_mac_writedata_ip0(reconfig_eth_mac_writedata_ip0),\n')
                                #elif(x=='i_reconfig_eth_mac_byteenable_ip0'):
                                #    writetofile(f_op,'.i_reconfig_eth_mac_byteenable_ip0(reconfig_eth_mac_byteenable_ip0),\n')
                                #elif(x=='o_reconfig_eth_mac_readdata_ip0'):
                                #    writetofile(f_op,'.o_reconfig_eth_mac_readdata_ip0(reconfig_eth_mac_readdata_ip0),\n')
                                #elif(x=='o_reconfig_eth_mac_readdata_valid_ip0'):
                                #    writetofile(f_op,'.o_reconfig_eth_mac_readdata_valid_ip0(reconfig_eth_mac_readdata_valid_ip0),\n')
                                #elif(x=='o_reconfig_eth_mac_waitrequest_ip0'):
                                #    writetofile(f_op,'.o_reconfig_eth_mac_waitrequest_ip0(reconfig_eth_mac_waitrequest_ip0),\n')
                                #elif(x=='i_reconfig_eth_rcfg_addr_ip0'):
                                #    writetofile(f_op,'.i_reconfig_eth_rcfg_addr_ip0(reconfig_eth_rcfg_addr_ip0),\n')
                                #elif(x=='i_reconfig_eth_rcfg_read_ip0'):
                                #    writetofile(f_op,'.i_reconfig_eth_rcfg_read_ip0(reconfig_eth_rcfg_read_ip0),\n')
                                #elif(x=='i_reconfig_eth_rcfg_write_ip0'):
                                #    writetofile(f_op,'.i_reconfig_eth_rcfg_write_ip0(reconfig_eth_rcfg_write_ip0),\n')
                                #elif(x=='i_reconfig_eth_rcfg_writedata_ip0'):
                                #    writetofile(f_op,'.i_reconfig_eth_rcfg_writedata_ip0(reconfig_eth_rcfg_writedata_ip0),\n')
                                #elif(x=='i_reconfig_eth_rcfg_byteenable_ip0'):
                                #    writetofile(f_op,'.i_reconfig_eth_rcfg_byteenable_ip0(reconfig_eth_rcfg_byteenable_ip0),\n')
                                #elif(x=='o_reconfig_eth_rcfg_readdata_ip0'):
                                #    writetofile(f_op,'.o_reconfig_eth_rcfg_readdata_ip0(reconfig_eth_rcfg_readdata_ip0),\n')
                                #elif(x=='o_reconfig_eth_rcfg_readdata_valid_ip0'):
                                #    writetofile(f_op,'.o_reconfig_eth_rcfg_readdata_valid_ip0(reconfig_eth_rcfg_readdata_valid_ip0),\n')
                                #elif(x=='o_reconfig_eth_rcfg_waitrequest_ip0'):
                                #    writetofile(f_op,'.o_reconfig_eth_rcfg_waitrequest_ip0(reconfig_eth_rcfg_waitrequest_ip0),\n')
				elif(x=='i_reconfig_xcvr0_write_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'.'+x[:-12]+str(p)+'_write('+x[:-12]+str(p)+'_write_ip'+str(a)+'),\n')
				elif(x=='i_reconfig_xcvr0_read_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'.'+x[:-11]+str(p)+'_read('+x[:-11]+str(p)+'_read_ip'+str(a)+'),\n')
				elif(x=='i_reconfig_xcvr0_address_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'.'+x[:-14]+str(p)+'_addr('+x[:-14]+str(p)+'_address_ip'+str(a)+'),\n')
				elif(x=='i_reconfig_xcvr0_writedata_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'.'+x[:-16]+str(p)+'_writedata('+x[:-16]+str(p)+'_writedata_ip'+str(a)+'),\n')
				elif(x=='i_reconfig_xcvr0_byteenable_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'.'+x[:-17]+str(p)+'_byteenable('+x[:-17]+str(p)+'_byteenable_ip'+str(a)+'),\n')
				#add common wire list ports here
				elif(x=='i_clk_sys;' or x=='i_clk_ref;'):
					writetofile(f_op,'.'+x[:-1]+'('+x[:-1]+'),\n')			
				elif(x=='i_tx_pfc_ip0,'):
					if(FC[i]!='2'):
						writetofile(f_op,'.'+x[:-5]+'('+x[:-2]+str(a)+'),\n')
                                elif(x=='i_tx_pause_ip0,'):
					if(FC[i]!='2'):
						writetofile(f_op,'.'+x[:-5]+'('+x[:-2]+str(a)+'),\n')
				elif(x=='i_custom_cadence_ip0,'):
					if(SYSPLL[i]=='3' and CUSTOM_CADENCE_GUI[i]=='1'):
						writetofile(f_op,'.'+x[:-5]+'('+x[:-2]+str(a)+'),\n')
				#elif(x=='i_kr_ctrl,'):
				#	if(ANLT[i]==1):
				#		if(kr_enable[a]=='1'):
				#			#writetofile(f_op,'.'+x[:-1]+'('+x[2:-1]+'_kr%sg[%s]),\n'%(str(SPEED[i]),az))
				#			writetofile(f_op,'.i_kr_ctrl(kr_ctrl_kr%sg),\n'%str(SPEED[i])) 
				#		else:
				#			writetofile(f_op,'.'+x[:-1]+"(1'b0),\n")
				elif(x=='i_tx_preamble_ip0,'):
					if((SPEED[i]=='40' or SPEED[i]=='50') and PP[i]=='1'):
						writetofile(f_op,'.'+x[:-5]+'('+x[:-2]+str(a)+'),\n')
					else:
						writetofile(f_op,'//.'+x[:-5]+'('+x[:-2]+str(a)+'),\n')
				#		
				elif(x=='i_clk_sys,'):
						writetofile(f_op,'      \n')		
				else:
					writetofile(f_op,'.'+x[:-5]+'('+x[:-2]+str(a)+'),\n')
			for y in wire_avst_output:
				if(y=='o_clk_pll_ip0,'):
					if(PTP[i]=='0'):
						writetofile(f_op,'.o_clk_pll(o_clk_pll_ip0),\n')
					elif(PTP[i]=='1' and ENABLE_PTP_AIB7CLK[i]=='0'): # PTP=1, ENABLE_PTP_AIB7CLK=1, o_clk_pll connection is left dangling
                                                writetofile(f_op,'.o_clk_pll(o_clk_pll_ip0),\n')
				elif(y=='o_reconfig_xcvr0_readdata_ip0,'):
#				if(y=='o_reconfig_xcvr0_readdata_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'.'+y[:-15]+str(p)+'_readdata('+y[:-15]+str(p)+'_readdata_ip'+str(a)+'),\n')
				elif(y=='o_reconfig_xcvr0_waitrequest_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'.'+y[:-18]+str(p)+'_waitrequest('+y[:-18]+str(p)+'_waitrequest_ip'+str(a)+'),\n')
				elif(y=='o_reconfig_xcvr0_readdata_valid_ip0'):
					writetofile(f_op,'.'+y[:-20]+str(p)+'_readdata_valid('+y[:-20]+str(p)+'_readdata_valid_ip'+str(a)+')\n);\n')
                                #elif(x=='o_reconfig_eth_rcfg_readdata_ip0'):
                                #    writetofile(f_op,'.o_reconfig_eth_rcfg_readdata_ip0(reconfig_eth_rcfg_readdata_ip0),\n')
                                #elif(x=='o_reconfig_eth_rcfg_readdata_valid_ip0'):
                                #    writetofile(f_op,'.o_reconfig_eth_rcfg_readdata_valid_ip0(reconfig_eth_rcfg_readdata_valid_ip0),\n')
                                #elif(x=='o_reconfig_eth_rcfg_waitrequest_ip0'):
                                #    writetofile(f_op,'.o_reconfig_eth_rcfg_waitrequest_ip0(reconfig_eth_rcfg_waitrequest_ip0),\n')
                                #elif(x=='o_reconfig_eth_mac_readdata_ip0'):
                                #    writetofile(f_op,'.o_reconfig_eth_mac_readdata_ip0(reconfig_eth_mac_readdata_ip0),\n')
                                #elif(x=='o_reconfig_eth_mac_readdata_valid_ip0'):
                                #    writetofile(f_op,'.o_reconfig_eth_mac_readdata_valid_ip0(reconfig_eth_mac_readdata_valid_ip0),\n')
                                #elif(x=='o_reconfig_eth_mac_waitrequest_ip0'):
                                #    writetofile(f_op,'.o_reconfig_eth_mac_waitrequest_ip0(reconfig_eth_mac_waitrequest_ip0),\n')

                                elif(y=='o_rx_pfc_ip0,'):
					if(FC[i]!='2'):
						writetofile(f_op,'.'+y[:-5]+'('+y[:-2]+str(a)+'),\n')
                                elif(y=='o_rx_pause_ip0,'):
					if(FC[i]!='2'):
						writetofile(f_op,'.'+y[:-5]+'('+y[:-2]+str(a)+'),\n')
				elif(y=='o_rx_status_data_ip0,'):
					writetofile(f_op,'.'+y[:-17]+'status_data'+'('+y[:-2]+str(a)+'),\n')
				#TODO: EFIFO not available yet. Temporary remove
				elif(y=='o_xcvrif_txfifo_pfull,' or y=='o_xcvrif_txfifo_pempty,' or y=='o_xcvrif_txfifo_empty,' or y=='o_xcvrif_hold_interrupt,'):
					if(SYSPLL[i]=='3'):
						#writetofile(f_op,'.'+y[:-1]+'('+y[:-1]+'),\n')
						writetofile(f_op,"//EFIFO not available yet. Temporary remove \n")
				#elif(y=='o_kr_stat,'):
				#	if(ANLT[i]==1):
				#		if(kr_enable[a]=='1'):
				#			#writetofile(f_op,'.'+y[:-1]+'('+y[2:-1]+'_kr%sg[%s]),\n'%(str(SPEED[i]),az))
				#			writetofile(f_op,'.o_kr_stat(kr_stat_kr%sg),\n'%str(SPEED[i]))
				#			az+=1
				#		else:
				#			writetofile(f_op,'.'+y[:-1]+"(),\n")
				elif(y=='anlt_link,'):
					if(ANLT[i]==1):
						if(kr_enable[a]=='1'):
							writetofile(f_op,'.anlt_link(anlt_link_kr%sg[%s]),\n'%(str(SPEED[i]),az))
							az+=1
						else:
							writetofile(f_op,'.'+y[:-1]+"(),\n")
				elif(y=='o_rx_status_valid_ip0,'):
					writetofile(f_op,'.'+y[:-18]+'status_valid'+'('+y[:-2]+str(a)+'),\n')
				elif(y=='o_rx_preamble_ip0,'):
					if((SPEED[i]=='40' or SPEED[i]=='50') and PP[i]=='1'):
						writetofile(f_op,'.'+y[:-5]+'('+y[:-2]+str(a)+'),\n')
					else:
						writetofile(f_op,'//.'+y[:-5]+'('+y[:-2]+str(a)+'),\n')
				else:
					 writetofile(f_op,'.'+y[:-5]+'('+y[:-2]+str(a)+'),\n')
		if(INTERFACE[i]=='2'):
			for x in wire_pcs_input:
				if(x=='i_reconfig_xcvr0_write_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'.'+x[:-12]+str(p)+'_write('+x[:-12]+str(p)+'_write_ip'+str(a)+'),\n')
				elif(x=='i_reconfig_xcvr0_read_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'.'+x[:-11]+str(p)+'_read('+x[:-11]+str(p)+'_read_ip'+str(a)+'),\n')
				elif(x=='i_reconfig_xcvr0_address_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'.'+x[:-14]+str(p)+'_addr('+x[:-14]+str(p)+'_address_ip'+str(a)+'),\n')
				elif(x=='i_reconfig_xcvr0_writedata_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'.'+x[:-16]+str(p)+'_writedata('+x[:-16]+str(p)+'_writedata_ip'+str(a)+'),\n')
				elif(x=='i_reconfig_xcvr0_byteenable_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'.'+x[:-17]+str(p)+'_byteenable('+x[:-17]+str(p)+'_byteenable_ip'+str(a)+'),\n')	
                                #elif(x=='i_reconfig_eth_mac_addr_ip0'):
                                #    writetofile(f_op,'.i_reconfig_eth_mac_addr_ip0(reconfig_eth_mac_addr_ip0),\n')
                                #elif(x=='i_reconfig_eth_mac_read_ip0'):
                                #    writetofile(f_op,'.i_reconfig_eth_mac_read_ip0(reconfig_eth_mac_read_ip0),\n')
                                #elif(x=='i_reconfig_eth_mac_write_ip0'):
                                #    writetofile(f_op,'.i_reconfig_eth_mac_write_ip0(reconfig_eth_mac_write_ip0),\n')
                                #elif(x=='i_reconfig_eth_mac_writedata_ip0'):
                                #    writetofile(f_op,'.i_reconfig_eth_mac_writedata_ip0(reconfig_eth_mac_writedata_ip0),\n')
                                #elif(x=='i_reconfig_eth_mac_byteenable_ip0'):
                                #    writetofile(f_op,'.i_reconfig_eth_mac_byteenable_ip0(reconfig_eth_mac_byteenable_ip0),\n')
                                #elif(x=='i_reconfig_eth_rcfg_addr_ip0'):
                                #    writetofile(f_op,'.i_reconfig_eth_rcfg_addr_ip0(reconfig_eth_rcfg_addr_ip0),\n')
                                #elif(x=='i_reconfig_eth_rcfg_read_ip0'):
                                #    writetofile(f_op,'.i_reconfig_eth_rcfg_read_ip0(reconfig_eth_rcfg_read_ip0),\n')
                                #elif(x=='i_reconfig_eth_rcfg_write_ip0'):
                                #    writetofile(f_op,'.i_reconfig_eth_rcfg_write_ip0(reconfig_eth_rcfg_write_ip0),\n')
                                #elif(x=='i_reconfig_eth_rcfg_writedata_ip0'):
                                #    writetofile(f_op,'.i_reconfig_eth_rcfg_writedata_ip0(reconfig_eth_rcfg_writedata_ip0),\n')
                                #elif(x=='i_reconfig_eth_rcfg_byteenable_ip0'):
                                #    writetofile(f_op,'.i_reconfig_eth_rcfg_byteenable_ip0(reconfig_eth_rcfg_byteenable_ip0),\n')


				#elif(x=='i_tx_mii_valid_ip0,' or x=='i_tx_mii_am_ip0,'):
				#	writetofile(f_op,'//.'+x[:-5]+'('+x[:-2]+str(a)+'),\n')
				elif(x=='i_clk_sys;' or x=='i_clk_ref;'):
					writetofile(f_op,'.'+x[:-1]+'('+x[:-1]+'),\n')
				#elif(x=='i_kr_ctrl,'):
				#	if(ANLT[i]==1):
				#		if(kr_enable[a]=='1'):
				#			writetofile(f_op,'.'+x[:-1]+'('+x[2:-1]+'_kr%sg[%s]),\n'%(str(SPEED[i]),az))
				#			
				#		else:
				#			writetofile(f_op,'.'+x[:-1]+"(1'b0),\n")
				elif(x=='i_custom_cadence_ip0,'):
					if(SYSPLL[i]=='3' and CUSTOM_CADENCE_GUI[i]=='1'):
						writetofile(f_op,'.'+x[:-5]+'('+x[:-2]+str(a)+'),\n')
				#elif(x=='dut_mii_tx_data_ip0,' or x=='dut_mii_tx_ctrl_ip0,'):
				#	writetofile(f_op,'//.i_tx_mii_'+x[11]+'('+x[:-2]+str(a)+'),\n')
				else:
					writetofile(f_op,'.'+x[:-5]+'('+x[:-2]+str(a)+'),\n')
			for y in wire_pcs_output:
				if(y=='o_reconfig_xcvr0_readdata_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'.'+y[:-15]+str(p)+'_readdata('+y[:-15]+str(p)+'_readdata_ip'+str(a)+'),\n')
				elif(y=='o_reconfig_xcvr0_waitrequest_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'.'+y[:-18]+str(p)+'_waitrequest('+y[:-18]+str(p)+'_waitrequest_ip'+str(a)+'),\n')
				elif(y=='o_reconfig_xcvr0_readdata_valid_ip0'):
					writetofile(f_op,'.'+y[:-21]+str(p)+'_readdata_valid('+y[:-21]+str(p)+'_readdata_valid_ip'+str(a)+')\n);\n')
                                #elif(x=='o_reconfig_eth_rcfg_readdata_ip0'):
                                #    writetofile(f_op,'.o_reconfig_eth_rcfg_readdata_ip0(reconfig_eth_rcfg_readdata_ip0),\n')
                                #elif(x=='o_reconfig_eth_rcfg_readdata_valid_ip0'):
                                #    writetofile(f_op,'.o_reconfig_eth_rcfg_readdata_valid_ip0(reconfig_eth_rcfg_readdata_valid_ip0),\n')
                                #elif(x=='o_reconfig_eth_rcfg_waitrequest_ip0'):
                                #    writetofile(f_op,'.o_reconfig_eth_rcfg_waitrequest_ip0(reconfig_eth_rcfg_waitrequest_ip0),\n')
                                #elif(x=='o_reconfig_eth_mac_readdata_ip0'):
                                #    writetofile(f_op,'.o_reconfig_eth_mac_readdata_ip0(reconfig_eth_mac_readdata_ip0),\n')
                                #elif(x=='o_reconfig_eth_mac_readdata_valid_ip0'):
                                #    writetofile(f_op,'.o_reconfig_eth_mac_readdata_valid_ip0(reconfig_eth_mac_readdata_valid_ip0),\n')
                                #elif(x=='o_reconfig_eth_mac_waitrequest_ip0'):
                                #    writetofile(f_op,'.o_reconfig_eth_mac_waitrequest_ip0(reconfig_eth_mac_waitrequest_ip0),\n')

				#elif(y=='o_kr_stat,'):
				#	if(ANLT[i]==1):
				#		if(kr_enable[a]=='1'):
				#			writetofile(f_op,'.'+y[:-1]+'('+y[2:-1]+'_kr%sg[%s]),\n'%(str(SPEED[i]),az))
				#			az+=1
				#		else:
				#			writetofile(f_op,'.'+y[:-1]+"(),\n")
				elif(y=='anlt_link,'):
					if(ANLT[i]==1):
						if(kr_enable[a]=='1'):
							writetofile(f_op,'.'+y[:-1]+'('+y[2:-1]+'_kr%sg[%s]),\n'%(str(SPEED[i]),az))
							az+=1
						else:
							writetofile(f_op,'.'+y[:-1]+"(),\n")
				#elif(y=='o_tx_mii_ready_ip0,' or y=='o_rx_mii_valid_ip0,' or y=='o_rx_mii_am_valid_ip0,'):
				#	writetofile(f_op,'//.'+y[:-5]+'('+y[:-2]+str(a)+'),\n')
				#elif(y=='dut_mii_rx_data_ip0,' or y=='dut_mii_rx_ctrl_ip0,'):
			        #		writetofile(f_op,'//.o_rx_mii_'+y[11]+'('+y[:-2]+str(a)+'),\n')
				else:
					 writetofile(f_op,'.'+y[:-5]+'('+y[:-2]+str(a)+'),\n')
		if(INTERFACE[i]=='3' or INTERFACE[i]=='4'):
			for x in wire_otn_input:
				if(x=='i_reconfig_xcvr0_write_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'.'+x[:-12]+str(p)+'_write('+x[:-12]+str(p)+'_write_ip'+str(a)+'),\n')
				elif(x=='i_reconfig_xcvr0_read_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'.'+x[:-11]+str(p)+'_read('+x[:-11]+str(p)+'_read_ip'+str(a)+'),\n')
				elif(x=='i_reconfig_xcvr0_address_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'.'+x[:-14]+str(p)+'_addr('+x[:-14]+str(p)+'_address_ip'+str(a)+'),\n')
				elif(x=='i_reconfig_xcvr0_writedata_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'.'+x[:-16]+str(p)+'_writedata('+x[:-16]+str(p)+'_writedata_ip'+str(a)+'),\n')
				elif(x=='i_reconfig_xcvr0_byteenable_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'.'+x[:-17]+str(p)+'_byteenable('+x[:-17]+str(p)+'_byteenable_ip'+str(a)+'),\n')	
                                #elif(x=='i_reconfig_eth_mac_addr_ip0'):
                                #    writetofile(f_op,'.i_reconfig_eth_mac_addr_ip0(reconfig_eth_mac_addr_ip0),\n')
                                #elif(x=='i_reconfig_eth_mac_read_ip0'):
                                #    writetofile(f_op,'.i_reconfig_eth_mac_read_ip0(reconfig_eth_mac_read_ip0),\n')
                                #elif(x=='i_reconfig_eth_mac_write_ip0'):
                                #    writetofile(f_op,'.i_reconfig_eth_mac_write_ip0(reconfig_eth_mac_write_ip0),\n')
                                #elif(x=='i_reconfig_eth_mac_writedata_ip0'):
                                #    writetofile(f_op,'.i_reconfig_eth_mac_writedata_ip0(reconfig_eth_mac_writedata_ip0),\n')
                                #elif(x=='i_reconfig_eth_mac_byteenable_ip0'):
                                #    writetofile(f_op,'.i_reconfig_eth_mac_byteenable_ip0(reconfig_eth_mac_byteenable_ip0),\n')
                                #elif(x=='i_reconfig_eth_rcfg_addr_ip0'):
                                #    writetofile(f_op,'.i_reconfig_eth_rcfg_addr_ip0(reconfig_eth_rcfg_addr_ip0),\n')
                                #elif(x=='i_reconfig_eth_rcfg_read_ip0'):
                                #    writetofile(f_op,'.i_reconfig_eth_rcfg_read_ip0(reconfig_eth_rcfg_read_ip0),\n')
                                #elif(x=='i_reconfig_eth_rcfg_write_ip0'):
                                #    writetofile(f_op,'.i_reconfig_eth_rcfg_write_ip0(reconfig_eth_rcfg_write_ip0),\n')
                                #elif(x=='i_reconfig_eth_rcfg_writedata_ip0'):
                                #    writetofile(f_op,'.i_reconfig_eth_rcfg_writedata_ip0(reconfig_eth_rcfg_writedata_ip0),\n')
                                #elif(x=='i_reconfig_eth_rcfg_byteenable_ip0'):
                                #    writetofile(f_op,'.i_reconfig_eth_rcfg_byteenable_ip0(reconfig_eth_rcfg_byteenable_ip0),\n')


				elif(x=='i_custom_cadence_ip0,'):
					if(SYSPLL[i]=='3' and CUSTOM_CADENCE_GUI[i]=='1'):
						writetofile(f_op,'.'+x[:-5]+'('+x[:-2]+str(a)+'),\n')
				elif(x=='i_clk_sys;' or x=='i_clk_ref;'):
					writetofile(f_op,'.'+x[:-1]+'('+x[:-1]+'),\n')
				#elif(x=='i_kr_ctrl,'):
				#	if(ANLT[i]==1):
				#		if(kr_enable[a]=='1'):
				#			writetofile(f_op,'.'+x[:-1]+'('+x[2:-1]+'_kr%sg[%s]),\n'%(str(SPEED[i]),az))
				#			
				#		else:
				#			writetofile(f_op,'.'+x[:-1]+"(1'b0),\n")
				#elif(x=='pcs66_tx_data_ip0,'):
				#	writetofile(f_op,'.i_tx_pcs66_d('+x[:-2]+str(a)+'),\n')
				#elif(x=='pcs66_tx_vld_ip0,'):
				#	writetofile(f_op,'.i_tx_pcs66_valid('+x[:-2]+str(a)+'),\n')
				#elif(x=='pcs66_avst_tx_am_insert_ip0,'):
				#	writetofile(f_op,'.i_tx_pcs66_am('+x[:-2]+str(a)+'),\n')
				else:
					writetofile(f_op,'.'+x[:-5]+'('+x[:-2]+str(a)+'),\n')
			for y in wire_otn_output:
				if(y=='o_reconfig_xcvr0_readdata_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'.'+y[:-15]+str(p)+'_readdata('+y[:-15]+str(p)+'_readdata_ip'+str(a)+'),\n')
				elif(y=='o_reconfig_xcvr0_waitrequest_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'.'+y[:-18]+str(p)+'_waitrequest('+y[:-18]+str(p)+'_waitrequest_ip'+str(a)+'),\n')
				elif(y=='o_reconfig_xcvr0_readdata_valid_ip0'):
					writetofile(f_op,'.'+y[:-21]+str(p)+'_readdata_valid('+y[:-21]+str(p)+'_readdata_valid_ip'+str(a)+')\n);\n')
                                #elif(x=='o_reconfig_eth_rcfg_readdata_ip0'):
                                #    writetofile(f_op,'.o_reconfig_eth_rcfg_readdata_ip0(reconfig_eth_rcfg_readdata_ip0),\n')
                                #elif(x=='o_reconfig_eth_rcfg_readdata_valid_ip0'):
                                #    writetofile(f_op,'.o_reconfig_eth_rcfg_readdata_valid_ip0(reconfig_eth_rcfg_readdata_valid_ip0),\n')
                                #elif(x=='o_reconfig_eth_rcfg_waitrequest_ip0'):
                                #    writetofile(f_op,'.o_reconfig_eth_rcfg_waitrequest_ip0(reconfig_eth_rcfg_waitrequest_ip0),\n')
                                #elif(x=='o_reconfig_eth_mac_readdata_ip0'):
                                #    writetofile(f_op,'.o_reconfig_eth_mac_readdata_ip0(reconfig_eth_mac_readdata_ip0),\n')
                                #elif(x=='o_reconfig_eth_mac_readdata_valid_ip0'):
                                #    writetofile(f_op,'.o_reconfig_eth_mac_readdata_valid_ip0(reconfig_eth_mac_readdata_valid_ip0),\n')
                                #elif(x=='o_reconfig_eth_mac_waitrequest_ip0'):
                                #    writetofile(f_op,'.o_reconfig_eth_mac_waitrequest_ip0(reconfig_eth_mac_waitrequest_ip0),\n')

				#elif(y=='pcs66_rx_data_ip0,'):
				#	writetofile(f_op,'.o_rx_pcs66_d('+y[:-2]+str(a)+'),\n')
				#elif(y=='pcs66_tx_rdy_ip0,'):
				#	writetofile(f_op,'.o_tx_pcs66_ready('+y[:-2]+str(a)+'),\n')
				#elif(y=='o_kr_stat,'):
				#	if(ANLT[i]==1):
				#		if(kr_enable[a]=='1'):
				#			writetofile(f_op,'.'+y[:-1]+'('+y[2:-1]+'_kr%sg[%s]),\n'%(str(SPEED[i]),az))
				#			az+=1
				#		else:
				#			writetofile(f_op,'.'+y[:-1]+"(),\n")
				elif(y=='anlt_link,'):
					if(ANLT[i]==1):
						if(kr_enable[a]=='1'):
							writetofile(f_op,'.'+y[:-1]+'('+y[2:-1]+'_kr%sg[%s]),\n'%(str(SPEED[i]),az))
							az+=1
						else:
							writetofile(f_op,'.'+y[:-1]+"(),\n")
				#elif(y=='pcs66_rx_am_ip0,'):
				#	writetofile(f_op,'.o_rx_pcs66_am_valid('+y[:-2]+str(a)+'),\n')
				#elif(y=='pcs66_rx_vld_ip0,'):
				#	writetofile(f_op,'.o_rx_pcs66_valid('+y[:-2]+str(a)+'),\n')
				else:
					 writetofile(f_op,'.'+y[:-5]+'('+y[:-2]+str(a)+'),\n')
		if(INTERFACE[i]=='0'):	
			for x in wire_macseg_input:
				#print(x)
                                if(x=='i_clk_tx_ip0,'):
                                        if(PTP[i]=='1' and ENASYNCAD[i]=='0'):
                                                writetofile(f_op,'.i_clk_tx(o_clk_pll_ip0),\n')
                                        else:
                                                writetofile(f_op,'.i_clk_tx(i_clk_tx_ip0),\n')
                                elif(x=='i_clk_rx_ip0,'):
                                        if(PTP[i]=='1' and ENASYNCAD[i]=='0'):
                                                writetofile(f_op,'.i_clk_rx(o_clk_pll_ip0),\n')
                                        else:
                                                writetofile(f_op,'.i_clk_rx(i_clk_rx_ip0),\n')
				elif(x=='i_reconfig_xcvr0_write_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'.'+x[:-12]+str(p)+'_write('+x[:-12]+str(p)+'_write_ip'+str(a)+'),\n')
				elif(x=='i_reconfig_xcvr0_read_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'.'+x[:-11]+str(p)+'_read('+x[:-11]+str(p)+'_read_ip'+str(a)+'),\n')
				elif(x=='i_reconfig_xcvr0_address_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'.'+x[:-14]+str(p)+'_addr('+x[:-14]+str(p)+'_address_ip'+str(a)+'),\n')
				elif(x=='i_reconfig_xcvr0_writedata_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'.'+x[:-16]+str(p)+'_writedata('+x[:-16]+str(p)+'_writedata_ip'+str(a)+'),\n')
				elif(x=='i_reconfig_xcvr0_byteenable_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'.'+x[:-17]+str(p)+'_byteenable('+x[:-17]+str(p)+'_byteenable_ip'+str(a)+'),\n')
                                #elif(x=='i_reconfig_eth_mac_addr_ip0'):
                                #    writetofile(f_op,'.i_reconfig_eth_mac_addr_ip0(reconfig_eth_mac_addr_ip0),\n')
                                #elif(x=='i_reconfig_eth_mac_read_ip0'):
                                #    writetofile(f_op,'.i_reconfig_eth_mac_read_ip0(reconfig_eth_mac_read_ip0),\n')
                                #elif(x=='i_reconfig_eth_mac_write_ip0'):
                                #    writetofile(f_op,'.i_reconfig_eth_mac_write_ip0(reconfig_eth_mac_write_ip0),\n')
                                #elif(x=='i_reconfig_eth_mac_writedata_ip0'):
                                #    writetofile(f_op,'.i_reconfig_eth_mac_writedata_ip0(reconfig_eth_mac_writedata_ip0),\n')
                                #elif(x=='i_reconfig_eth_mac_byteenable_ip0'):
                                #    writetofile(f_op,'.i_reconfig_eth_mac_byteenable_ip0(reconfig_eth_mac_byteenable_ip0),\n')
                                #elif(x=='i_reconfig_eth_rcfg_addr_ip0'):
                                #    writetofile(f_op,'.i_reconfig_eth_rcfg_addr_ip0(reconfig_eth_rcfg_addr_ip0),\n')
                                #elif(x=='i_reconfig_eth_rcfg_read_ip0'):
                                #    writetofile(f_op,'.i_reconfig_eth_rcfg_read_ip0(reconfig_eth_rcfg_read_ip0),\n')
                                #elif(x=='i_reconfig_eth_rcfg_write_ip0'):
                                #    writetofile(f_op,'.i_reconfig_eth_rcfg_write_ip0(reconfig_eth_rcfg_write_ip0),\n')
                                #elif(x=='i_reconfig_eth_rcfg_writedata_ip0'):
                                #    writetofile(f_op,'.i_reconfig_eth_rcfg_writedata_ip0(reconfig_eth_rcfg_writedata_ip0),\n')
                                #elif(x=='i_reconfig_eth_rcfg_byteenable_ip0'):
                                #    writetofile(f_op,'.i_reconfig_eth_rcfg_byteenable_ip0(reconfig_eth_rcfg_byteenable_ip0),\n')


				elif(x=='i_custom_cadence_ip0,'):
					if(SYSPLL[i]=='3' and CUSTOM_CADENCE_GUI[i]=='1'):
						writetofile(f_op,'.'+x[:-5]+'('+x[:-2]+str(a)+'),\n')
				elif(x=='i_clk_sys;'):
					writetofile(f_op,'.'+x[:-1]+'('+x[:-1]+'),\n')
				#for multi instance 
				elif(x=='i_clk_ref;'):
					if('0' in TRANSTYPE and '1' in TRANSTYPE):
						writetofile(f_op,'.'+x[:-1]+'('+x[:-1]+'_bk),\n')
					else: 
						writetofile(f_op,'.'+x[:-1]+'('+x[:-1]+'),\n')
				#elif(x=='i_kr_ctrl,'):
				#	if(ANLT[i]==1):
				#		if(kr_enable[a]=='1'):
				#			#writetofile(f_op,'.'+x[:-1]+'('+x[2:-1]+'_kr%sg[%s]),\n'%(str(SPEED[i]),az))
				#			writetofile(f_op,'.i_kr_ctrl(kr_ctrl_kr%sg),\n'%str(SPEED[i])) 
				#		else:
				#			writetofile(f_op,'.'+x[:-1]+"(1'b0),\n")
                                elif(x=='i_tx_pfc_ip0,'):
					if(FC[i]!='2'):
						writetofile(f_op,'.'+x[:-5]+'('+x[:-2]+str(a)+'),\n')
                                elif(x=='i_tx_pause_ip0,'):
					if(FC[i]!='2'):
						writetofile(f_op,'.'+x[:-5]+'('+x[:-2]+str(a)+'),\n')
                                #1013:1021 Need to change port names according to FS once HSD (16011325129) is fixed
				else:
					writetofile(f_op,'.'+x[:-5]+'('+x[:-2]+str(a)+'),\n')
			for y in wire_macseg_output:
                                if(y=='o_clk_pll_ip0,'):
                                        if(PTP[i]=='0'):
                                                writetofile(f_op,'.o_clk_pll(o_clk_pll_ip0),\n')
                                        elif(PTP[i]=='1' and ENABLE_PTP_AIB7CLK[i]=='0'): # PTP=1, ENABLE_PTP_AIB7CLK=1, o_clk_pll connection is left dangling
                                                writetofile(f_op,'.o_clk_pll(o_clk_pll_ip0),\n')
				elif(y=='o_reconfig_xcvr0_readdata_ip0,'):
				#if(y=='o_reconfig_xcvr0_readdata_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'.'+y[:-15]+str(p)+'_readdata('+y[:-15]+str(p)+'_readdata_ip'+str(a)+'),\n')
				elif(y=='o_reconfig_xcvr0_waitrequest_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(f_op,'.'+y[:-18]+str(p)+'_waitrequest('+y[:-18]+str(p)+'_waitrequest_ip'+str(a)+'),\n')
                                #elif(x=='o_reconfig_eth_rcfg_readdata_ip0'):
                                #    writetofile(f_op,'.o_reconfig_eth_rcfg_readdata_ip0(reconfig_eth_rcfg_readdata_ip0),\n')
                                #elif(x=='o_reconfig_eth_rcfg_readdata_valid_ip0'):
                                #    writetofile(f_op,'.o_reconfig_eth_rcfg_readdata_valid_ip0(reconfig_eth_rcfg_readdata_valid_ip0),\n')
                                #elif(x=='o_reconfig_eth_rcfg_waitrequest_ip0'):
                                #    writetofile(f_op,'.o_reconfig_eth_rcfg_waitrequest_ip0(reconfig_eth_rcfg_waitrequest_ip0),\n')
                                #elif(x=='o_reconfig_eth_mac_readdata_ip0'):
                                #    writetofile(f_op,'.o_reconfig_eth_mac_readdata_ip0(reconfig_eth_mac_readdata_ip0),\n')
                                #elif(x=='o_reconfig_eth_mac_readdata_valid_ip0'):
                                #    writetofile(f_op,'.o_reconfig_eth_mac_readdata_valid_ip0(reconfig_eth_mac_readdata_valid_ip0),\n')
                                #elif(x=='o_reconfig_eth_mac_waitrequest_ip0'):
                                #    writetofile(f_op,'.o_reconfig_eth_mac_waitrequest_ip0(reconfig_eth_mac_waitrequest_ip0),\n')


				#TODO: EFIFO not available yet. Temporary remove
				elif(y=='o_xcvrif_txfifo_pfull,' or y=='o_xcvrif_txfifo_pempty,' or y=='o_xcvrif_txfifo_empty,' or y=='o_xcvrif_hold_interrupt,'):
					if(SYSPLL[i]=='3'):
						#writetofile(f_op,'.'+y[:-1]+'('+y[:-1]+'),\n')
						writetofile(f_op,"// EFIFO not available yet. Temporary remove\n")
				#elif(y=='o_kr_stat,'):
				#	if(ANLT[i]==1):
				#		if(kr_enable[a]=='1'):
				#			#writetofile(f_op,'.'+y[:-1]+'('+y[2:-1]+'_kr%sg[%s]),\n'%(str(SPEED[i]),az))
				#			writetofile(f_op,'.o_kr_stat(kr_stat_kr%sg),\n'%str(SPEED[i]))
				#			az+=1
				#		else:
				#			writetofile(f_op,'.'+y[:-1]+"(),\n")
				elif(y=='anlt_link,'):
					if(ANLT[i]==1):
						if(kr_enable[a]=='1'):
							writetofile(f_op,'.anlt_link(anlt_link_kr%sg[%s]),\n'%(str(SPEED[i]),az))
							az+=1
						else:
							writetofile(f_op,'.'+y[:-1]+"(),\n")
                                elif(y=='o_rx_pfc_ip0,'):
					if(FC[i]!='2'):
						writetofile(f_op,'.'+y[:-5]+'('+y[:-2]+str(a)+'),\n')
                                elif(y=='o_rx_pause_ip0,'):
					if(FC[i]!='2'):
						writetofile(f_op,'.'+y[:-5]+'('+y[:-2]+str(a)+'),\n')
				elif(y=='o_reconfig_xcvr0_readdata_valid_ip0'):
					writetofile(f_op,'.'+y[:-21]+str(p)+'_readdata_valid('+y[:-21]+str(p)+'_readdata_valid_ip'+str(a)+')\n);\n')
				else:
					 writetofile(f_op,'.'+y[:-5]+'('+y[:-2]+str(a)+'),\n')
		a+=1
#for multi instance 
if('0' in TRANSTYPE and '1' in TRANSTYPE):
	writetofile(f_op,'\n systemclk_f_0 sys_pll(\n     .out_systempll_clk_0(i_clk_sys), // out_systempll_clk_0.clk\n     .out_refclk_fgt_0(i_clk_ref),    //    out_refclk_fgt_0.clk\n     .in_refclk_fgt_0(i_refclk2pll),               //          refclk_fgt.in_refclk_fgt_0\n     .out_fht_cmmpll_clk_0(i_clk_ref_bk),    //    .out_fht_cmmpll_clk_1(),\n     .in_refclk_fht_0(i_bk_refclk2pll)               //          .in_refclk_fht_1(i_refclk2pll)\n);\n')
elif('0' in TRANSTYPE):
	if('3' in SYSPLL):
		#print("cadence syspll")
		writetofile(f_op,'\n systemclk_f_0 sys_pll(\n     .out_systempll_clk_0(i_clk_sys), // out_systempll_clk_0.clk\n     .out_refclk_fgt_0(i_clk_ref),    //    out_refclk_fgt_0.clk\n     .in_refclk_fgt_0(i_refclk2pll),               //          refclk_fgt.in_refclk_fgt_0\n     .in_refclk_fgt_1(i_refclk2syspll)               //          refclk_fgt.in_refclk_fgt_1\n);\n')
	#custom cadence
	else:		
		#print("normal syspll")
		writetofile(f_op,'\n systemclk_f_0 sys_pll(\n     .out_systempll_clk_0(i_clk_sys), // out_systempll_clk_0.clk\n     .out_refclk_fgt_0(i_clk_ref),    //    out_refclk_fgt_0.clk\n     .in_refclk_fgt_0(i_refclk2pll)               //          refclk_fgt.in_refclk_fgt_0\n     //.in_refclk_fgt_1(i_refclk2pll)               //          refclk_fgt.in_refclk_fgt_1\n);\n')
#BARAK
elif('1' in TRANSTYPE):
	if('3' in SYSPLL):
	    writetofile(f_op,'\n systemclk_f_0 sys_pll(\n     .out_systempll_clk_0(i_clk_sys), // out_systempll_clk_0.clk\n     .in_refclk_fgt_0(i_refclk2pll),               //          refclk_fgt.in_refclk_fgt_0\n    .in_refclk_fgt_1(i_refclk2syspll),\n          .out_fht_cmmpll_clk_0(i_clk_ref),    //    .out_fht_cmmpll_clk_1(),\n     .in_refclk_fht_0(i_bk_refclk2pll)               //          .in_refclk_fht_1(i_refclk2pll)\n);\n')
	else:		
	    writetofile(f_op,'\n systemclk_f_0 sys_pll(\n     .out_systempll_clk_0(i_clk_sys), // out_systempll_clk_0.clk\n     .in_refclk_fgt_0(i_refclk2pll),               //          refclk_fgt.in_refclk_fgt_0\n     .out_fht_cmmpll_clk_0(i_clk_ref),    //    .out_fht_cmmpll_clk_1(),\n     .in_refclk_fht_0(i_bk_refclk2pll)               //          .in_refclk_fht_1(i_refclk2pll)\n);\n')
elif('2' in TRANSTYPE):
	writetofile(f_op,'\n systemclk_f_0 sys_pll(\n     .out_systempll_clk_0(i_clk_sys), // out_systempll_clk_0.clk\n     .in_refclk_fgt_0(i_refclk2pll),               //          refclk_fgt.in_refclk_fgt_0\n     .out_fht_cmmpll_clk_0(i_clk_ref),    //    .out_fht_cmmpll_clk_1(),\n     .in_refclk_fht_0(i_refclk2pll)               //          .in_refclk_fht_1(i_refclk2pll)\n);\n')


#PTP AIB6/7 new instance
#This block will be shared across multi instance of top_ip
p=0;
if(PTP[i]=='1'):
	writetofile(f_op,'\n eth_ptp_adpt_f ptp_adpt_f (\n')
	if('1' in INTERFACE[i]):
		for k in wire_avst_output:
			if(k=='o_clk_pll_ip0,'):
				writetofile(f_op,'.i_sys_clk'+'('+k[:-2]+str(p)+'),\n')
		for k in wire_avst_input:
			if(k=='i_rst_n_ip0,' or k=='i_reconfig_clk_ip0,' or k=='i_reconfig_reset_ip0,'):
				writetofile(f_op,'.'+k[:-5]+'('+k[:-2]+str(p)+'),\n')
	elif ('0' in INTERFACE[i]):
		for k in wire_macseg_output:
			if(k=='o_clk_pll_ip0,'):
				writetofile(f_op,'.i_sys_clk'+'('+k[:-2]+str(p)+'),\n')
		for k in wire_macseg_input:
			if(k=='i_rst_n_ip0,' or k=='i_reconfig_clk_ip0,' or k=='i_reconfig_reset_ip0,'):
				writetofile(f_op,'.'+k[:-5]+'('+k[:-2]+str(p)+'),\n')
	for k in ptp_aib67_signals_input:
		writetofile(f_op,'.'+k[:-5]+'('+k[:-2]+str(p)+'),\n')
	for k in ptp_aib67_signals_output:
		writetofile(f_op,'.'+k[:-5]+'('+k[:-2]+str(p)+'),\n')
	if(ENABLE_PTP_AIB7CLK[i]=='1'):
		writetofile(f_op,'.o_clk_pll(o_clk_pll_ip0),\n')
	writetofile(f_op,'.ptp_link(ptp_link)\n')
	writetofile(f_op,'\n);\n')

writetofile(f_op,'\n endmodule: dut_top')




if('1' in INTERFACE):
	wire_avst_input = [x for x in wire_avst_input if x not in wire_avst_common]
	wire_avst_input.insert(4,'i_refclk2pll,')
	wire_avst_input.insert(4,'i_refclk2syspll,')
	wire_avst_input.insert(4,'i_bk_refclk2pll,')
#
	wire_avst_input.insert(4,'i_clk_sys,')
	#wire_avst_output.remove('o_kr_stat,')
if('0' in INTERFACE):
	wire_macseg_input = [x for x in wire_macseg_input if x not in wire_macseg_common]
	wire_macseg_input.insert(4,'i_refclk2pll,')
	wire_macseg_input.insert(4,'i_refclk2syspll,')
	wire_macseg_input.insert(4,'i_bk_refclk2pll,')
	#wire_macseg_output.remove('o_kr_stat,')
if('2' in INTERFACE):
	wire_pcs_input = [x for x in wire_pcs_input if x not in wire_pcs_common]
	wire_pcs_input.insert(4,'i_refclk2pll,')
	wire_pcs_input.insert(4,'i_refclk2syspll,')
	wire_pcs_input.insert(4,'i_bk_refclk2pll,')
	#wire_pcs_output.remove('o_kr_stat,')
if('3' in INTERFACE or '4' in INTERFACE):
	wire_otn_input = [x for x in wire_otn_input if x not in wire_otn_common]
	wire_otn_input.insert(4,'i_refclk2pll,')
	wire_otn_input.insert(4,'i_refclk2syspll,')
	wire_otn_input.insert(4,'i_bk_refclk2pll,')
	#wire_otn_output.remove('o_kr_stat,')		

tail = open(env_var+'/gdr_gen_qhip_files/eth_ehip_gdr_top_tail.sv','w+')
writetofile(tail,'// Instance of generated top from CSV\n\n')
writetofile(tail,'dut_top #() dut ( \n')
a=0
for i in range(len(SPEED)):
	if(ANLT[i]==1):
		for k in kr_top:
			writetofile(tail,'.'+k[:-4]+'%sg('%str(SPEED[i])+k[:-4]+'%sg),\n'%str(SPEED[i]))
for i in range(len(SPEED)):
	for j in range(INSTANCE[i]):
		if(PTP[i]=='1'):
			for k in ptp_signals_input:
				writetofile(tail,'.'+k[:-2]+str(a)+'('+k[:-2]+str(a)+'),\n')
			for k in ptp_signals_output:
				if(k=='o_ptp_rx_its_valid_ip0,' or k=='o_ptp_rx_its_vl_ip0,'or k=='o_ptp_ets_vl_ip0,'):
					if(ptp_debug_acc_en == 1):
						writetofile(tail,'.'+k[:-2]+str(a)+'('+k[:-2]+str(a)+'),\n')
				else:
					writetofile(tail,'.'+k[:-2]+str(a)+'('+k[:-2]+str(a)+'),\n')
			for k in ptp_aib67_signals_input:
				writetofile(tail,'.'+k[:-2]+str(a)+'('+k[:-2]+str(a)+'),\n')
			for k in ptp_aib67_signals_output:
				writetofile(tail,'.'+k[:-2]+str(a)+'('+k[:-2]+str(a)+'),\n')			
		if(INTERFACE[i]=='1'):
			for x in wire_avst_input:
				if(x=='i_reconfig_xcvr0_write_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(tail,'.'+x[:-12]+str(p)+'_write_ip'+str(a)+'('+x[2:-12]+str(p)+'_write_ip'+str(a)+'),\n')
                                #elif(x=='i_reconfig_eth_mac_addr_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_mac_addr_ip0(reconfig_eth_mac_addr_ip0),\n')
                                #elif(x=='i_reconfig_eth_mac_read_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_mac_read_ip0(reconfig_eth_mac_read_ip0),\n')
                                #elif(x=='i_reconfig_eth_mac_write_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_mac_write_ip0(reconfig_eth_mac_write_ip0),\n')
                                #elif(x=='i_reconfig_eth_mac_writedata_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_mac_writedata_ip0(reconfig_eth_mac_writedata_ip0),\n')
                                #elif(x=='i_reconfig_eth_mac_byteenable_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_mac_byteenable_ip0(reconfig_eth_mac_byteenable_ip0),\n')
                                #elif(x=='i_reconfig_eth_rcfg_addr_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_rcfg_addr_ip0(reconfig_eth_rcfg_addr_ip0),\n')
                                #elif(x=='i_reconfig_eth_rcfg_read_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_rcfg_read_ip0(reconfig_eth_rcfg_read_ip0),\n')
                                #elif(x=='i_reconfig_eth_rcfg_write_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_rcfg_write_ip0(reconfig_eth_rcfg_write_ip0),\n')
                                #elif(x=='i_reconfig_eth_rcfg_writedata_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_rcfg_writedata_ip0(reconfig_eth_rcfg_writedata_ip0),\n')
                                #elif(x=='i_reconfig_eth_rcfg_byteenable_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_rcfg_byteenable_ip0(reconfig_eth_rcfg_byteenable_ip0),\n')

				elif(x=='i_custom_cadence_ip0,'):
					if(SYSPLL[i]=='3' and CUSTOM_CADENCE_GUI[i]=='1'):
						writetofile(tail,'.'+x[:-1]+'('+x[2:-2]+str(a)+'),\n')
				#elif(x=='i_kr_ctrl,'):
				#	if(ANLT[i]==1):
				#		if(kr_enable[a]=='1'):
				#			writetofile(tail,'//.'+x[:-1]+'('+x[:-1]+'),\n')
				#		else:
				#			writetofile(tail,'//.'+x[:-1]+"(1'b0),\n")
				elif(x=='i_refclk2pll,'):
					writetofile(tail,'.'+x[:-1]+'('+x[:-1]+'),\n')
				elif(x=='i_refclk2syspll,'):
					writetofile(tail,'.'+x[:-1]+'('+x[:-1]+'),\n')
				elif((x=='i_bk_refclk2pll,') and ('1' in TRANSTYPE)):
					writetofile(tail,'.'+x[:-1]+'('+'i_refclk2pll'+'),\n')
				elif((x=='i_bk_refclk2pll,') and ('0' in TRANSTYPE)):
					writetofile(tail,'// \n')
#
#				elif(x=='i_clk_sys,'):
#					writetofile(tail,'.'+x[:-1]+'('+x[:-1]+'),\n')	
                                #elif(x=='i_reconfig_eth_mac_addr_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_mac_addr_ip0(reconfig_eth_mac_addr_ip0),\n')
                                #elif(x=='i_reconfig_eth_mac_read_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_mac_read_ip0(reconfig_eth_mac_read_ip0),\n')
                                #elif(x=='i_reconfig_eth_mac_write_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_mac_write_ip0(reconfig_eth_mac_write_ip0),\n')
                                #elif(x=='i_reconfig_eth_mac_writedata_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_mac_writedata_ip0(reconfig_eth_mac_writedata_ip0),\n')
                                #elif(x=='i_reconfig_eth_mac_byteenable_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_mac_byteenable_ip0(reconfig_eth_mac_byteenable_ip0),\n')
                                #elif(x=='i_reconfig_eth_rcfg_addr_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_rcfg_addr_ip0(reconfig_eth_rcfg_addr_ip0),\n')
                                #elif(x=='i_reconfig_eth_rcfg_read_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_rcfg_read_ip0(reconfig_eth_rcfg_read_ip0),\n')
                                #elif(x=='i_reconfig_eth_rcfg_write_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_rcfg_write_ip0(reconfig_eth_rcfg_write_ip0),\n')
                                #elif(x=='i_reconfig_eth_rcfg_writedata_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_rcfg_writedata_ip0(reconfig_eth_rcfg_writedata_ip0),\n')
                                #elif(x=='i_reconfig_eth_rcfg_byteenable_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_rcfg_byteenable_ip0(reconfig_eth_rcfg_byteenable_ip0),\n')


				elif(x=='i_reconfig_xcvr0_read_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(tail,'.'+x[:-11]+str(p)+'_read_ip'+str(a)+'('+x[2:-11]+str(p)+'_read_ip'+str(a)+'),\n')
				elif(x=='i_reconfig_xcvr0_byteenable_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(tail,'.'+x[:-17]+str(p)+'_byteenable_ip'+str(a)+'('+x[2:-17]+str(p)+'_byteenable_ip'+str(a)+'),\n')
				elif(x=='i_reconfig_xcvr0_address_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(tail,'.'+x[:-14]+str(p)+'_address_ip'+str(a)+'('+x[2:-14]+str(p)+'_address_ip'+str(a)+'),\n')
				elif(x=='i_reconfig_xcvr0_writedata_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(tail,'.'+x[:-16]+str(p)+'_writedata_ip'+str(a)+'('+x[2:-16]+str(p)+'_writedata_ip'+str(a)+'),\n')
				elif(x=='i_tx_preamble_ip0,'):
					if((SPEED[i]=='40' or SPEED[i]=='50') and PP[i]=='1'):
						writetofile(tail,'.'+x[:-2]+str(a)+'('+x[2:-2]+str(a)+'),\n')
					else:
						writetofile(tail,'//.'+x[:-2]+str(a)+'('+x[2:-2]+str(a)+'),\n')
				else:
					if(x!='i_clk_sys,'):
						writetofile(tail,'.'+x[:-2]+str(a)+'('+x[2:-2]+str(a)+'),\n')
			for y in wire_avst_output:
				if(y=='o_reconfig_xcvr0_readdata_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(tail,'.'+y[:-15]+str(p)+'_readdata_ip'+str(a)+'('+y[2:-15]+str(p)+'_readdata_ip'+str(a)+'),\n')
				elif(y=='o_reconfig_xcvr0_waitrequest_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(tail,'.'+y[:-18]+str(p)+'_waitrequest_ip'+str(a)+'('+y[2:-18]+str(p)+'_waitrequest_ip'+str(a)+'),\n')
                                #elif(x=='o_reconfig_eth_rcfg_readdata_ip0'):
                                #    writetofile(tail,'.o_reconfig_eth_rcfg_readdata_ip0(reconfig_eth_rcfg_readdata_ip0),\n')
                                #elif(x=='o_reconfig_eth_rcfg_readdata_valid_ip0'):
                                #    writetofile(tail,'.o_reconfig_eth_rcfg_readdata_valid_ip0(reconfig_eth_rcfg_readdata_valid_ip0),\n')
                                #elif(x=='o_reconfig_eth_rcfg_waitrequest_ip0'):
                                #    writetofile(tail,'.o_reconfig_eth_rcfg_waitrequest_ip0(reconfig_eth_rcfg_waitrequest_ip0),\n')
                                #elif(x=='o_reconfig_eth_mac_readdata_ip0'):
                                #    writetofile(tail,'.o_reconfig_eth_mac_readdata_ip0(reconfig_eth_mac_readdata_ip0),\n')
                                #elif(x=='o_reconfig_eth_mac_readdata_valid_ip0'):
                                #    writetofile(tail,'.o_reconfig_eth_mac_readdata_valid_ip0(reconfig_eth_mac_readdata_valid_ip0),\n')
                                #elif(x=='o_reconfig_eth_mac_waitrequest_ip0'):
                                #    writetofile(tail,'.o_reconfig_eth_mac_waitrequest_ip0(reconfig_eth_mac_waitrequest_ip0),\n')


				#TODO: EFIFO not available yet. Temporary remove		
				elif(y=='o_xcvrif_txfifo_pfull,' or y=='o_xcvrif_txfifo_pempty,' or y=='o_xcvrif_txfifo_empty,' or y=='o_xcvrif_hold_interrupt,'):
					if(SYSPLL[i]=='3'):
						#writetofile(tail,'.'+y[:-1]+'('+y[:-1]+'),\n')
						writetofile(tail,"//EFIFO not available yet. Temporary remove	\n")
				#elif(y=='o_kr_stat,'):
				#	if(ANLT[i]==1):
				#		if(kr_enable[a]=='1'):
				#			writetofile(tail,'//.'+y[:-1]+'('+y[:-1]+'),\n')
				#		else:
				#			writetofile(tail,'//.'+y[:-1]+"(1'b0),\n")
				elif(y=='anlt_link,'):
					if(ANLT[i]==1):
						if(kr_enable[a]=='1'):
							writetofile(tail,'//.'+y[:-1]+'('+y[:-1]+'),\n')
						else:
							writetofile(tail,'//.'+y[:-1]+"(1'b0),\n")
				elif(y=='o_reconfig_xcvr0_readdata_valid_ip0,'):
					for p in range(int(NUMTXLANE[i])):
					         writetofile(tail,'.'+y[:-21]+str(p)+'_readdata_valid_ip'+str(a)+'('+y[2:-21]+str(p)+'_readdata_valid_ip'+str(a)+')\n')
				elif(y=='o_rx_preamble_ip0,'):
					if((SPEED[i]=='40' or SPEED[i]=='50') and PP[i]=='1'):
						writetofile(tail,'.'+y[:-2]+str(a)+'('+y[2:-2]+str(a)+'),\n')
					else:
						writetofile(tail,'//.'+y[:-2]+str(a)+'('+y[2:-2]+str(a)+'),\n')
                                elif(y=='tx_digitalreset,'):
					writetofile(tail,'// \n')
                                elif(y=='rx_digitalreset'):
                                        #endof dut top instance
					writetofile(tail,'); \n')
				else:
					 writetofile(tail,'.'+y[:-2]+str(a)+'('+y[2:-2]+str(a)+'),\n')
		if(INTERFACE[i]=='2'):
			for x in wire_pcs_input:
				if(x=='i_reconfig_xcvr0_write_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(tail,'.'+x[:-12]+str(p)+'_write_ip'+str(a)+'('+x[2:-12]+str(p)+'_write_ip'+str(a)+'),\n')
				elif(x=='i_reconfig_xcvr0_read_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(tail,'.'+x[:-11]+str(p)+'_read_ip'+str(a)+'('+x[2:-11]+str(p)+'_read_ip'+str(a)+'),\n')
				elif(x=='i_reconfig_xcvr0_byteenable_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(tail,'.'+x[:-17]+str(p)+'_byteenable_ip'+str(a)+'('+x[2:-17]+str(p)+'_byteenable_ip'+str(a)+'),\n')
				elif(x=='i_reconfig_xcvr0_address_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(tail,'.'+x[:-14]+str(p)+'_address_ip'+str(a)+'('+x[2:-14]+str(p)+'_address_ip'+str(a)+'),\n')
				elif(x=='i_reconfig_xcvr0_writedata_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(tail,'.'+x[:-16]+str(p)+'_writedata_ip'+str(a)+'('+x[2:-16]+str(p)+'_writedata_ip'+str(a)+'),\n')
                                #elif(x=='i_reconfig_eth_mac_addr_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_mac_addr_ip0(reconfig_eth_mac_addr_ip0),\n')
                                #elif(x=='i_reconfig_eth_mac_read_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_mac_read_ip0(reconfig_eth_mac_read_ip0),\n')
                                #elif(x=='i_reconfig_eth_mac_write_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_mac_write_ip0(reconfig_eth_mac_write_ip0),\n')
                                #elif(x=='i_reconfig_eth_mac_writedata_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_mac_writedata_ip0(reconfig_eth_mac_writedata_ip0),\n')
                                #elif(x=='i_reconfig_eth_mac_byteenable_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_mac_byteenable_ip0(reconfig_eth_mac_byteenable_ip0),\n')
                                #elif(x=='i_reconfig_eth_rcfg_addr_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_rcfg_addr_ip0(reconfig_eth_rcfg_addr_ip0),\n')
                                #elif(x=='i_reconfig_eth_rcfg_read_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_rcfg_read_ip0(reconfig_eth_rcfg_read_ip0),\n')
                                #elif(x=='i_reconfig_eth_rcfg_write_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_rcfg_write_ip0(reconfig_eth_rcfg_write_ip0),\n')
                                #elif(x=='i_reconfig_eth_rcfg_writedata_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_rcfg_writedata_ip0(reconfig_eth_rcfg_writedata_ip0),\n')
                                #elif(x=='i_reconfig_eth_rcfg_byteenable_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_rcfg_byteenable_ip0(reconfig_eth_rcfg_byteenable_ip0),\n')


				#elif(x=='i_tx_mii_valid_ip0,' or x=='i_tx_mii_am_ip0,'):
				#	writetofile(tail,'//.'+x[:-5]+'('+x[:-2]+str(a)+'),\n')
				elif(x=='i_custom_cadence_ip0,'):
					if(SYSPLL[i]=='3' and CUSTOM_CADENCE_GUI[i]=='1'):
						writetofile(tail,'.'+x[:-5]+'('+x[:-2]+str(a)+'),\n')
				#elif(x=='i_kr_ctrl,'):
				#	if(ANLT[i]=='1'):
				#		if(kr_enable[a]=='1'):
				#			writetofile(tail,'.'+x[:-1]+'('+x[:-1]+'),\n')
				#		else:
				#			writetofile(tail,'.'+x[:-1]+"(1'b0),\n")
				elif(x=='i_refclk2pll,'):
					writetofile(tail,'.'+x[:-1]+'('+x[:-1]+'),\n')
				elif(x=='i_refclk2syspll,'):
					writetofile(tail,'.'+x[:-1]+'('+x[:-1]+'),\n')
				elif((x=='i_bk_refclk2pll,') and ('1' in TRANSTYPE)):
					writetofile(tail,'.'+x[:-1]+'('+'i_refclk2pll'+'),\n')
				elif((x=='i_bk_refclk2pll,') and ('0' in TRANSTYPE)):
					writetofile(tail,'// \n')
				#elif(x=='dut_mii_tx_data_ip0,' or x=='dut_mii_tx_ctrl_ip0,'):
					#writetofile(tail,'//.i_tx_mii_'+x[11]+'('+x[:-2]+str(a)+'),\n')
				else:
					writetofile(tail,'.'+x[:-2]+str(a)+'('+x[2:-2]+str(a)+'),\n')
			for y in wire_pcs_output:
				if(y=='o_reconfig_xcvr0_readdata_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(tail,'.'+y[:-15]+str(p)+'_readdata_ip'+str(a)+'('+y[2:-15]+str(p)+'_readdata_ip'+str(a)+'),\n')
				elif(y=='o_reconfig_xcvr0_waitrequest_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(tail,'.'+y[:-18]+str(p)+'_waitrequest_ip'+str(a)+'('+y[2:-18]+str(p)+'_waitrequest_ip'+str(a)+'),\n')
				elif(y=='o_reconfig_xcvr0_readdata_valid_ip0'):
					for p in range(int(NUMTXLANE[i])):
					        writetofile(tail,'.'+y[:-21]+str(p)+'_readdata_valid_ip'+str(a)+'('+y[2:-21]+str(p)+'_readdata_valid_ip'+str(a)+')\n);\n')
                                #elif(x=='o_reconfig_eth_rcfg_readdata_ip0'):
                                #    writetofile(tail,'.o_reconfig_eth_rcfg_readdata_ip0(reconfig_eth_rcfg_readdata_ip0),\n')
                                #elif(x=='o_reconfig_eth_rcfg_readdata_valid_ip0'):
                                #    writetofile(tail,'.o_reconfig_eth_rcfg_readdata_valid_ip0(reconfig_eth_rcfg_readdata_valid_ip0),\n')
                                #elif(x=='o_reconfig_eth_rcfg_waitrequest_ip0'):
                                #    writetofile(tail,'.o_reconfig_eth_rcfg_waitrequest_ip0(reconfig_eth_rcfg_waitrequest_ip0),\n')
                                #elif(x=='o_reconfig_eth_mac_readdata_ip0'):
                                #    writetofile(tail,'.o_reconfig_eth_mac_readdata_ip0(reconfig_eth_mac_readdata_ip0),\n')
                                #elif(x=='o_reconfig_eth_mac_readdata_valid_ip0'):
                                #    writetofile(tail,'.o_reconfig_eth_mac_readdata_valid_ip0(reconfig_eth_mac_readdata_valid_ip0),\n')
                                #elif(x=='o_reconfig_eth_mac_waitrequest_ip0'):
                                #    writetofile(tail,'.o_reconfig_eth_mac_waitrequest_ip0(reconfig_eth_mac_waitrequest_ip0),\n')

				#elif(y=='o_kr_stat,'):
				#	if(ANLT[i]=='1'):
				#		if(kr_enable[a]=='1'):
				#			writetofile(tail,'.'+y[:-1]+'('+y[:-1]+'),\n')
				#		else:
				#			writetofile(tail,'.'+y[:-1]+"(1'b0),\n")
				elif(y=='anlt_link,'):
					if(ANLT[i]=='1'):
						if(kr_enable[a]=='1'):
							writetofile(tail,'.'+y[:-1]+'('+y[:-1]+'),\n')
						else:
							writetofile(tail,'.'+y[:-1]+"(1'b0),\n")
			     #	elif(y=='o_rx_block_lock_ip0,'):
			     #		writetofile(tail,'.'+y[:-1]+'('+y[2:-2]+str(a)+')\n);\n')
			#	elif(y=='o_tx_mii_ready_ip0,' or y=='o_rx_mii_valid_ip0,' or y=='o_rx_mii_am_valid_ip0,'):
			#		writetofile(tail,'//.'+y[:-5]+'('+y[:-2]+str(a)+'),\n')
			#	elif(y=='dut_mii_rx_data_ip0,' or y=='dut_mii_rx_ctrl_ip0,'):
			#		writetofile(tail,'//.o_rx_mii_'+y[11]+'('+y[:-2]+str(a)+'),\n')
				else:
					 writetofile(tail,'.'+y[:-2]+str(a)+'('+y[2:-2]+str(a)+'),\n')
		if(INTERFACE[i]=='3' or INTERFACE[i]=='4'):
			for x in wire_otn_input:
				if(x=='i_reconfig_xcvr0_write_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(tail,'.'+x[:-12]+str(p)+'_write_ip'+str(a)+'('+x[2:-12]+str(p)+'_write_ip'+str(a)+'),\n')
				elif(x=='i_reconfig_xcvr0_read_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(tail,'.'+x[:-11]+str(p)+'_read_ip'+str(a)+'('+x[2:-11]+str(p)+'_read_ip'+str(a)+'),\n')
				elif(x=='i_reconfig_xcvr0_byteenable_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(tail,'.'+x[:-17]+str(p)+'_byteenable_ip'+str(a)+'('+x[2:-17]+str(p)+'_byteenable_ip'+str(a)+'),\n')
				elif(x=='i_reconfig_xcvr0_address_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(tail,'.'+x[:-14]+str(p)+'_address_ip'+str(a)+'('+x[2:-14]+str(p)+'_address_ip'+str(a)+'),\n')
				elif(x=='i_reconfig_xcvr0_writedata_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(tail,'.'+x[:-16]+str(p)+'_writedata_ip'+str(a)+'('+x[2:-16]+str(p)+'_writedata_ip'+str(a)+'),\n')
                                #elif(x=='i_reconfig_eth_mac_addr_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_mac_addr_ip0(reconfig_eth_mac_addr_ip0),\n')
                                #elif(x=='i_reconfig_eth_mac_read_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_mac_read_ip0(reconfig_eth_mac_read_ip0),\n')
                                #elif(x=='i_reconfig_eth_mac_write_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_mac_write_ip0(reconfig_eth_mac_write_ip0),\n')
                                #elif(x=='i_reconfig_eth_mac_writedata_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_mac_writedata_ip0(reconfig_eth_mac_writedata_ip0),\n')
                                #elif(x=='i_reconfig_eth_mac_byteenable_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_mac_byteenable_ip0(reconfig_eth_mac_byteenable_ip0),\n')
                                #elif(x=='i_reconfig_eth_rcfg_addr_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_rcfg_addr_ip0(reconfig_eth_rcfg_addr_ip0),\n')
                                #elif(x=='i_reconfig_eth_rcfg_read_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_rcfg_read_ip0(reconfig_eth_rcfg_read_ip0),\n')
                                #elif(x=='i_reconfig_eth_rcfg_write_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_rcfg_write_ip0(reconfig_eth_rcfg_write_ip0),\n')
                                #elif(x=='i_reconfig_eth_rcfg_writedata_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_rcfg_writedata_ip0(reconfig_eth_rcfg_writedata_ip0),\n')
                                #elif(x=='i_reconfig_eth_rcfg_byteenable_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_rcfg_byteenable_ip0(reconfig_eth_rcfg_byteenable_ip0),\n')


				elif(x=='i_custom_cadence_ip0,'):
					if(SYSPLL[i]=='3' and CUSTOM_CADENCE_GUI[i]=='1'):
						writetofile(tail,'.'+x[:-1]+'('+x[2:-2]+str(a)+'),\n')
				#elif(x=='i_kr_ctrl,'):
				#	if(ANLT[i]==1):
				#		if(kr_enable[a]=='1'):
				#			writetofile(tail,'.'+x[:-1]+'('+x[:-1]+'),\n')
				#		else:
				#			writetofile(tail,'.'+x[:-1]+"(1'b0),\n")
				elif(x=='i_refclk2pll,'):
					writetofile(tail,'.'+x[:-1]+'('+x[:-1]+'),\n')
				elif(x=='i_refclk2syspll,'):
					writetofile(tail,'.'+x[:-1]+'('+x[:-1]+'),\n')
				elif((x=='i_bk_refclk2pll,') and ('1' in TRANSTYPE)):
					writetofile(tail,'.'+x[:-1]+'('+'i_refclk2pll'+'),\n')
				elif((x=='i_bk_refclk2pll,') and ('0' in TRANSTYPE)):
					writetofile(tail,'// \n')
				elif(x=='i_tx_pcs66_d_ip0,'):
					writetofile(tail,'.'+x[:-2]+str(a)+'(pcs66_tx_data_ip'+str(a)+'),\n')
				elif(x=='i_tx_pcs66_valid_ip0,'):
					writetofile(tail,'.'+x[:-2]+str(a)+'(pcs66_tx_vld_ip'+str(a)+'),\n')
				elif(x=='i_tx_pcs66_am_ip0,'):
					writetofile(tail,'.'+x[:-2]+str(a)+'(pcs66_avst_tx_am_insert_ip'+str(a)+'),\n')
				else:
					writetofile(tail,'.'+x[:-2]+str(a)+'('+x[2:-2]+str(a)+'),\n')
			for y in wire_otn_output:
				if(y=='o_reconfig_xcvr0_readdata_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(tail,'.'+y[:-15]+str(p)+'_readdata_ip'+str(a)+'('+y[2:-15]+str(p)+'_readdata_ip'+str(a)+'),\n')
				elif(y=='o_reconfig_xcvr0_waitrequest_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(tail,'.'+y[:-18]+str(p)+'_waitrequest_ip'+str(a)+'('+y[2:-18]+str(p)+'_waitrequest_ip'+str(a)+'),\n')
				elif(y=='o_reconfig_xcvr0_readdata_valid_ip0'):
					writetofile(tail,'.'+y[:-21]+str(p)+'_readdata_valid_ip'+str(a)+'('+y[2:-21]+str(p)+'_readdata_valid_ip'+str(a)+')\n);\n')
                                #elif(x=='o_reconfig_eth_rcfg_readdata_ip0'):
                                #    writetofile(tail,'.o_reconfig_eth_rcfg_readdata_ip0(reconfig_eth_rcfg_readdata_ip0),\n')
                                #elif(x=='o_reconfig_eth_rcfg_readdata_valid_ip0'):
                                #    writetofile(tail,'.o_reconfig_eth_rcfg_readdata_valid_ip0(reconfig_eth_rcfg_readdata_valid_ip0),\n')
                                #elif(x=='o_reconfig_eth_rcfg_waitrequest_ip0'):
                                #    writetofile(tail,'.o_reconfig_eth_rcfg_waitrequest_ip0(reconfig_eth_rcfg_waitrequest_ip0),\n')
                                #elif(x=='o_reconfig_eth_mac_readdata_ip0'):
                                #    writetofile(tail,'.o_reconfig_eth_mac_readdata_ip0(reconfig_eth_mac_readdata_ip0),\n')
                                #elif(x=='o_reconfig_eth_mac_readdata_valid_ip0'):
                                #    writetofile(tail,'.o_reconfig_eth_mac_readdata_valid_ip0(reconfig_eth_mac_readdata_valid_ip0),\n')
                                #elif(x=='o_reconfig_eth_mac_waitrequest_ip0'):
                                #    writetofile(tail,'.o_reconfig_eth_mac_waitrequest_ip0(reconfig_eth_mac_waitrequest_ip0),\n')


				elif(y=='o_rx_pcs66_d_ip0,'):
					writetofile(tail,'.'+y[:-2]+str(a)+'(pcs66_rx_data_ip'+str(a)+'),\n')
				elif(y=='o_tx_pcs66_ready_ip0,'):
					writetofile(tail,'.'+y[:-2]+str(a)+'(pcs66_tx_rdy_ip'+str(a)+'),\n')
				#elif(y=='o_kr_stat,'):
				#	if(ANLT[i]==1):
				#		if(kr_enable[a]=='1'):
				#			writetofile(tail,'.'+y[:-1]+'('+y[:-1]+'),\n')
				#		else:
				#			writetofile(tail,'.'+y[:-1]+"(1'b0),\n")
				elif(y=='anlt_link,'):
					if(ANLT[i]==1):
						if(kr_enable[a]=='1'):
							writetofile(tail,'.'+y[:-1]+'('+y[:-1]+'),\n')
						else:
							writetofile(tail,'.'+y[:-1]+"(1'b0),\n")
				elif(y=='o_rx_pcs66_am_valid_ip0,'):
					writetofile(tail,'.'+y[:-2]+str(a)+'(pcs66_rx_am_ip'+str(a)+'),\n')
				elif(y=='o_rx_pcs66_valid_ip0,'):
					writetofile(tail,'.'+y[:-2]+str(a)+'(pcs66_rx_vld_ip'+str(a)+'),\n')
				else:
					writetofile(tail,'.'+y[:-2]+str(a)+'('+y[2:-2]+str(a)+'),\n')
		if(INTERFACE[i]=='0'):	
			for x in wire_macseg_input:
				if(x=='i_reconfig_xcvr0_write_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(tail,'.'+x[:-12]+str(p)+'_write_ip'+str(a)+'('+x[2:-12]+str(p)+'_write_ip'+str(a)+'),\n')
				elif(x=='i_reconfig_xcvr0_read_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(tail,'.'+x[:-11]+str(p)+'_read_ip'+str(a)+'('+x[2:-11]+str(p)+'_read_ip'+str(a)+'),\n')
				elif(x=='i_reconfig_xcvr0_byteenable_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(tail,'.'+x[:-17]+str(p)+'_byteenable_ip'+str(a)+'('+x[2:-17]+str(p)+'_byteenable_ip'+str(a)+'),\n')
                                #elif(x=='i_reconfig_eth_mac_addr_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_mac_addr_ip0(reconfig_eth_mac_addr_ip0),\n')
                                #elif(x=='i_reconfig_eth_mac_read_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_mac_read_ip0(reconfig_eth_mac_read_ip0),\n')
                                #elif(x=='i_reconfig_eth_mac_write_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_mac_write_ip0(reconfig_eth_mac_write_ip0),\n')
                                #elif(x=='i_reconfig_eth_mac_writedata_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_mac_writedata_ip0(reconfig_eth_mac_writedata_ip0),\n')
                                #elif(x=='i_reconfig_eth_mac_byteenable_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_mac_byteenable_ip0(reconfig_eth_mac_byteenable_ip0),\n')
                                #elif(x=='i_reconfig_eth_rcfg_addr_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_rcfg_addr_ip0(reconfig_eth_rcfg_addr_ip0),\n')
                                #elif(x=='i_reconfig_eth_rcfg_read_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_rcfg_read_ip0(reconfig_eth_rcfg_read_ip0),\n')
                                #elif(x=='i_reconfig_eth_rcfg_write_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_rcfg_write_ip0(reconfig_eth_rcfg_write_ip0),\n')
                                #elif(x=='i_reconfig_eth_rcfg_writedata_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_rcfg_writedata_ip0(reconfig_eth_rcfg_writedata_ip0),\n')
                                #elif(x=='i_reconfig_eth_rcfg_byteenable_ip0'):
                                #    writetofile(tail,'.i_reconfig_eth_rcfg_byteenable_ip0(reconfig_eth_rcfg_byteenable_ip0),\n')


				elif(x=='i_custom_cadence_ip0,'):
					if(SYSPLL[i]=='3' and CUSTOM_CADENCE_GUI[i]=='1'):
						writetofile(tail,'.'+x[:-1]+'('+x[2:-2]+str(a)+'),\n')
				elif(x=='i_refclk2pll,'):
					writetofile(tail,'.'+x[:-1]+'('+x[:-1]+'),\n')
				elif(x=='i_refclk2syspll,'):
					writetofile(tail,'.'+x[:-1]+'('+x[:-1]+'),\n')
				elif((x=='i_bk_refclk2pll,') and ('1' in TRANSTYPE)):
					writetofile(tail,'.'+x[:-1]+'('+'i_refclk2pll'+'),\n')
				elif((x=='i_bk_refclk2pll,') and ('0' in TRANSTYPE)):
					writetofile(tail,'// \n')
				#elif(x=='i_kr_ctrl,'):
				#	if(ANLT[i]==1):
				#		if(kr_enable[a]=='1'):
				#			writetofile(tail,'//.'+x[:-1]+'('+x[:-1]+'),\n')
				#		else:
				#			writetofile(tail,'//.'+x[:-1]+"(1'b0),\n")
				elif(x=='i_reconfig_xcvr0_address_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(tail,'.'+x[:-14]+str(p)+'_address_ip'+str(a)+'('+x[2:-14]+str(p)+'_address_ip'+str(a)+'),\n')
				elif(x=='i_reconfig_xcvr0_writedata_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(tail,'.'+x[:-16]+str(p)+'_writedata_ip'+str(a)+'('+x[2:-16]+str(p)+'_writedata_ip'+str(a)+'),\n')
				else:
					writetofile(tail,'.'+x[:-2]+str(a)+'('+x[2:-2]+str(a)+'),\n')
			for y in wire_macseg_output:
				if(y=='o_reconfig_xcvr0_readdata_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(tail,'.'+y[:-15]+str(p)+'_readdata_ip'+str(a)+'('+y[2:-15]+str(p)+'_readdata_ip'+str(a)+'),\n')
				elif(y=='o_reconfig_xcvr0_waitrequest_ip0,'):
					for p in range(int(NUMTXLANE[i])):
						writetofile(tail,'.'+y[:-18]+str(p)+'_waitrequest_ip'+str(a)+'('+y[2:-18]+str(p)+'_waitrequest_ip'+str(a)+'),\n')

                                #elif(x=='o_reconfig_eth_rcfg_readdata_ip0'):
                                #    writetofile(tail,'.o_reconfig_eth_rcfg_readdata_ip0(reconfig_eth_rcfg_readdata_ip0),\n')
                                #elif(x=='o_reconfig_eth_rcfg_readdata_valid_ip0'):
                                #    writetofile(tail,'.o_reconfig_eth_rcfg_readdata_valid_ip0(reconfig_eth_rcfg_readdata_valid_ip0),\n')
                                #elif(x=='o_reconfig_eth_rcfg_waitrequest_ip0'):
                                #    writetofile(tail,'.o_reconfig_eth_rcfg_waitrequest_ip0(reconfig_eth_rcfg_waitrequest_ip0),\n')
                                #elif(x=='o_reconfig_eth_mac_readdata_ip0'):
                                #    writetofile(tail,'.o_reconfig_eth_mac_readdata_ip0(reconfig_eth_mac_readdata_ip0),\n')
                                #elif(x=='o_reconfig_eth_mac_readdata_valid_ip0'):
                                #    writetofile(tail,'.o_reconfig_eth_mac_readdata_valid_ip0(reconfig_eth_mac_readdata_valid_ip0),\n')
                                #elif(x=='o_reconfig_eth_mac_waitrequest_ip0'):
                                #    writetofile(tail,'.o_reconfig_eth_mac_waitrequest_ip0(reconfig_eth_mac_waitrequest_ip0),\n')

				#TODO: EFIFO not available yet. Temporary remove		
				elif(y=='o_xcvrif_txfifo_pfull,' or y=='o_xcvrif_txfifo_pempty,' or y=='o_xcvrif_txfifo_empty,' or y=='o_xcvrif_hold_interrupt,'):
					if(SYSPLL[i]=='3'):
						#writetofile(tail,'.'+y[:-1]+'('+y[:-1]+'),\n')
						writetofile(tail,"//EFIFO not available yet. Temporary remove \n")
				#elif(y=='o_kr_stat,'):
				#	if(ANLT[i]==1):
				#		if(kr_enable[a]=='1'):
				#			writetofile(tail,'//.'+y[:-1]+'('+y[:-1]+'),\n')
				#		else:
				#			writetofile(tail,'//.'+y[:-1]+"(1'b0),\n")
				elif(y=='anlt_link,'):
					if(ANLT[i]==1):
						if(kr_enable[a]=='1'):
							writetofile(tail,'//.'+y[:-1]+'('+y[:-1]+'),\n')
						else:
							writetofile(tail,'//.'+y[:-1]+"(1'b0),\n")
				elif(y=='o_reconfig_xcvr0_readdata_valid_ip0'):
					writetofile(tail,'.'+y[:-21]+str(p)+'_readdata_valid_ip'+str(a)+'('+y[2:-21]+str(p)+'_readdata_valid_ip'+str(a)+')\n);\n')
				else:
					 writetofile(tail,'.'+y[:-2]+str(a)+'('+y[2:-2]+str(a)+'),\n')
		a+=1

writetofile(tail,'\n\n // end DUT top instance')
writetofile(tail,'\ninitial\nbegin\n//Shabbir: Start dumping after pcs_rx_ready\nif($test$plusargs("en_dump_later")) begin\n$display($time,"en_dump_later");\n`ifdef CR3TOP_SIMPLE_SERDES\n#108000ns;\n`else\n#453000ns;\n`endif\n$display($time,"en_dump_later:enabling dump");\nend\nif ($test$plusargs("wait_pcs_dump"))\nwait (spy_if_ip0.rx_pcs_ready==1);\n`ifdef DUMP_ON\n`ifdef ANLT\nif ($test$plusargs("FULL_DUMP"))\nbegin\n$display($time,"ANLT full dump enabled");\n$vcdpluson();\nend\nelse\nbegin\n$display($time,"ANLT selected dump enabled");\n$vcdpluson(1,eth_env_top);\n$vcdpluson(1,spy_if_ip0);\n$vcdpluson(0,dut);\n$vcdpluson(1,`TOP_PATH.z1577a.z1577a_inst.u_e400g_top);\n$vcdpluson(1,`TOP_PATH.z1577a.z1577a_inst.u_e200g_top);\nif(spy_if_ip0.trans_type==1) //tranceiver type - BARAK\nbegin\n$vcdpluson(1,`TOP_PATH.z1577a.z1577a_inst.u_barak_quad);\nend\nelse //tranceiver type - UX\nbegin\n$vcdpluson(1,`TOP_PATH.z1577a.z1577a_inst.u_ux_quad_0);\n$vcdpluson(1,`TOP_PATH.z1577a.z1577a_inst.u_ux_quad_1);\n$vcdpluson(1,`TOP_PATH.z1577a.z1577a_inst.u_ux_quad_2);\n$vcdpluson(0,`TOP_PATH.z1577a.z1577a_inst.u_ux_quad_3);\nend\n`ifdef ENABLE_ETH_VIP\n$vcdpluson(1,svt_ethernet_drv_0);\n$vcdpluson(1,svt_ethernet_drv_0.Bfm);\n$vcdpluson(0,svt_ethernet_drv_0.Bfm.ad_sm0);\n$vcdpluson(0,svt_ethernet_drv_0.Bfm.ad_sm1);\n$vcdpluson(0,svt_ethernet_drv_0.Bfm.ad_sm2);\n$vcdpluson(0,svt_ethernet_drv_0.Bfm.ad_sm3);\n$vcdpluson(0,svt_ethernet_drv_0.Bfm.ad_sm4);\n$vcdpluson(0,svt_ethernet_drv_0.Bfm.ad_sm5);\n$vcdpluson(0,svt_ethernet_drv_0.Bfm.ad_sm6);\n$vcdpluson(0,svt_ethernet_drv_0.Bfm.ad_sm7);\n$vcdpluson(0,svt_ethernet_drv_0.Bfm.ad_sm8);\n$vcdpluson(0,svt_ethernet_drv_0.Bfm.ad_sm9);\n$vcdpluson(0,svt_ethernet_drv_0.Bfm.autoneg_bfm);\n$vcdpluson(0,svt_ethernet_drv_0.Bfm.autoneg_baset1_bfm);\n$vcdpluson(1,svt_ethernet_txrx_if[0]);\n$vcdpluson(0,svt_ethernet_txrx_if[0].debug_bus.debug_bus_an.debug_bus_an73_bfm);\n$vcdpluson(0,svt_ethernet_txrx_if[0].debug_bus.debug_bus_an.debug_bus_an73_chk);\n$vcdpluson(0,svt_ethernet_txrx_if[0].debug_bus.debug_bus_backplane);\n$vcdpluson(1,svt_ethernet_mon_chk_0);\n$vcdpluson(1,svt_ethernet_mon_chk_0.Chk);\n$vcdpluson(0,svt_ethernet_mon_chk_0.Chk.ad_chk0);\n$vcdpluson(0,svt_ethernet_mon_chk_0.Chk.ad_chk1);\n$vcdpluson(0,svt_ethernet_mon_chk_0.Chk.ad_chk2);\n$vcdpluson(0,svt_ethernet_mon_chk_0.Chk.ad_chk3);\n$vcdpluson(0,svt_ethernet_mon_chk_0.Chk.ad_chk4);\n$vcdpluson(0,svt_ethernet_mon_chk_0.Chk.ad_chk5);\n$vcdpluson(0,svt_ethernet_mon_chk_0.Chk.ad_chk6);\n$vcdpluson(0,svt_ethernet_mon_chk_0.Chk.ad_chk7);\n$vcdpluson(0,svt_ethernet_mon_chk_0.Chk.ad_chk8);\n$vcdpluson(0,svt_ethernet_mon_chk_0.Chk.ad_chk9);\n$vcdpluson(0,svt_ethernet_mon_chk_0.Chk.autoneg_chk);\n$vcdpluson(0,svt_ethernet_mon_chk_0.Chk.autoneg_baset1_chk);\n`endif\nend\n`else\n$vcdpluson();\n`endif\n`endif\n`ifdef FSDB_ON\n//fsdb dumping options\n`ifdef ANLT\n$fsdbAutoSwitchDumpfile(20480, "novas.fsdb",100);\nif ($test$plusargs("FULL_DUMP"))\nbegin\n$display($time,"ANLT full dump enabled");\n$fsdbDumpvars("+all");\nend\nelse\nbegin\n$display($time,"ANLT selected dump enabled");\n$fsdbDumpvars(1,eth_env_top);\n$fsdbDumpvars(1,spy_if_ip0);\n$fsdbDumpvars(0,dut);\n$fsdbDumpvars(1,`TOP_PATH.z1577a.z1577a_inst.u_e400g_top);\n$fsdbDumpvars(1,`TOP_PATH.z1577a.z1577a_inst.u_e200g_top);\nif(spy_if_ip0.trans_type==1) //tranceiver type - BARAK\nbegin\n$fsdbDumpvars(1,`TOP_PATH.z1577a.z1577a_inst.u_barak_quad);\nend\nelse //tranceiver type - UX\nbegin\n$fsdbDumpvars(1,`TOP_PATH.z1577a.z1577a_inst.u_ux_quad_0);\n$fsdbDumpvars(1,`TOP_PATH.z1577a.z1577a_inst.u_ux_quad_1);\n$fsdbDumpvars(1,`TOP_PATH.z1577a.z1577a_inst.u_ux_quad_2);\n$fsdbDumpvars(0,`TOP_PATH.z1577a.z1577a_inst.u_ux_quad_3);\nend\n`ifdef ENABLE_ETH_VIP\n$fsdbDumpvars(1,svt_ethernet_drv_0);\n$fsdbDumpvars(1,svt_ethernet_drv_0.Bfm);\n$fsdbDumpvars(0,svt_ethernet_drv_0.Bfm.ad_sm0);\n$fsdbDumpvars(0,svt_ethernet_drv_0.Bfm.ad_sm1);\n$fsdbDumpvars(0,svt_ethernet_drv_0.Bfm.ad_sm2);\n$fsdbDumpvars(0,svt_ethernet_drv_0.Bfm.ad_sm3);\n$fsdbDumpvars(0,svt_ethernet_drv_0.Bfm.ad_sm4);\n$fsdbDumpvars(0,svt_ethernet_drv_0.Bfm.ad_sm5);\n$fsdbDumpvars(0,svt_ethernet_drv_0.Bfm.ad_sm6);\n$fsdbDumpvars(0,svt_ethernet_drv_0.Bfm.ad_sm7);\n$fsdbDumpvars(0,svt_ethernet_drv_0.Bfm.ad_sm8);\n$fsdbDumpvars(0,svt_ethernet_drv_0.Bfm.ad_sm9);\n$fsdbDumpvars(0,svt_ethernet_drv_0.Bfm.autoneg_bfm);\n$fsdbDumpvars(0,svt_ethernet_drv_0.Bfm.autoneg_baset1_bfm);\n$fsdbDumpvars(1,svt_ethernet_txrx_if[0]);\n$fsdbDumpvars(0,svt_ethernet_txrx_if[0].debug_bus.debug_bus_an.debug_bus_an73_bfm);\n$fsdbDumpvars(0,svt_ethernet_txrx_if[0].debug_bus.debug_bus_an.debug_bus_an73_chk);\n$fsdbDumpvars(0,svt_ethernet_txrx_if[0].debug_bus.debug_bus_backplane);\n$fsdbDumpvars(1,svt_ethernet_mon_chk_0);\n$fsdbDumpvars(1,svt_ethernet_mon_chk_0.Chk);\n$fsdbDumpvars(0,svt_ethernet_mon_chk_0.Chk.ad_chk0);\n$fsdbDumpvars(0,svt_ethernet_mon_chk_0.Chk.ad_chk1);\n$fsdbDumpvars(0,svt_ethernet_mon_chk_0.Chk.ad_chk2);\n$fsdbDumpvars(0,svt_ethernet_mon_chk_0.Chk.ad_chk3);\n$fsdbDumpvars(0,svt_ethernet_mon_chk_0.Chk.ad_chk4);\n$fsdbDumpvars(0,svt_ethernet_mon_chk_0.Chk.ad_chk5);\n$fsdbDumpvars(0,svt_ethernet_mon_chk_0.Chk.ad_chk6);\n$fsdbDumpvars(0,svt_ethernet_mon_chk_0.Chk.ad_chk7);\n$fsdbDumpvars(0,svt_ethernet_mon_chk_0.Chk.ad_chk8);\n$fsdbDumpvars(0,svt_ethernet_mon_chk_0.Chk.ad_chk9);\n$fsdbDumpvars(0,svt_ethernet_mon_chk_0.Chk.autoneg_chk);\n$fsdbDumpvars(0,svt_ethernet_mon_chk_0.Chk.autoneg_baset1_chk);\n`endif\nend\n`else\n`ifdef DUMP_MAC_PCS_ONLY\n$fsdbDumpvars(0,eth_env_top);\n$fsdbDumpvars(0,dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top);\n$fsdbDumpvars(0,dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e200g_top.u_e2hip_top);\n`else\n$fsdbDumpvars("+all");\n`endif\n$fsdbDumpvars("+parameter");\n`ifdef RESET_DUMP_OFF\nwait(eth_env_top.reset_if_ip0.csr_rst_n==0)\n$fsdbDumpoff;\nwait(eth_env_top.reset_if_ip0.csr_rst_n==1)\n$fsdbDumpon;\n`endif\n`endif\n`endif\nend // initial begin\ninitial begin\nrun_test();\nend\nendmodule: eth_env_top\n\n`endif // ETH_ENV_TOP__SV\n')

#Check for the interface type and select the appropriate file
if('1' in INTERFACE):
	stub_path= tb_var+'/ip/ethernet/alt_ethernet_crete_gdr/qhip/scripts/funct_deterministic/common/stub_templates/gdr_avst_top_stub.v' 
elif('0'in INTERFACE):
	stub_path= tb_var+'/ip/ethernet/alt_ethernet_crete_gdr/qhip/scripts/funct_deterministic/common/stub_templates/gdr_seg_top_stub.v'
elif('2'in INTERFACE):
	stub_path= tb_var+'/ip/ethernet/alt_ethernet_crete_gdr/qhip/scripts/funct_deterministic/common/stub_templates/gdr_pcs_only_top_stub.v'
#elif('3'in INTERFACE or '4' in INTERFACE):
#	stub_path= tb_var+'/ip/ethernet/alt_ethernet_crete_gdr/qhip/scripts/funct_deterministic/common/stub_templates/gdr_otn_flexe_top_stub.v'
#Declaration of lists for storing lines read from the stub file. 
tempvar_stub = []
wire_input = []
wire_output = []

#Copy files from source directory to destination. 
#Look up code.

#Handles for top_ip0.v file path and opening top_ip0.v:
top_ip_f = env_var+"/gdr_gen_qhip_files/top_ip0.v"
top_op = open(top_ip_f, 'w+')

#Starting to write to top_ip9.v file:
writetofile(top_op,'`timescale 1ps/1ps'+'\n\n')
writetofile(top_op,'module top_ip0 ( \n')
#Opening path and passing lines to the list:
for j in open(stub_path,"r"):
	tempvar_stub.append(j.split())

tempvar_stub = list(filter(None, tempvar_stub))
#Storing input and output ports in separate lists:
for i in tempvar_stub:
	#print(i[0])
	if(i[0]=='input'):
		wire_input.append(i[-1])
	elif(i[0]=='output'):
		wire_output.append(i[-1])
	
for i in range(len(SPEED)):
	#Check for AVST interface and declare ports:	
	#Check for PCS_ONLY interface and declare ports:	
	if((INTERFACE[i]=='1') or (INTERFACE[i]=='2')):
		writetofile(top_op,'//port declarations: \n')
		for k in wire_input:
			#if(k=='i_kr_ctrl,'):
			#	writetofile(top_op,'input wire '+'[7:0] '+k+'\n')
		        if(k=='i_reconfig_xcvr0_byteenable,' or k=='i_reconfig_xcvr1_byteenable,' or k=='i_reconfig_xcvr2_byteenable,' or k=='i_reconfig_xcvr3_byteenable,' or k=='i_reconfig_eth_byteenable,'):
		        	writetofile(top_op,'input wire [3:0] '+k+'\n')
		        elif(k=='i_reconfig_xcvr0_addr,' or k=='i_reconfig_xcvr1_addr,' or k=='i_reconfig_xcvr2_addr,' or k=='i_reconfig_xcvr3_addr,' or k=='i_reconfig_eth_addr,'):
		        	writetofile(top_op,'input wire [19:0] '+k+'\n')
		        elif(k=='i_reconfig_xcvr0_writedata,' or k=='i_reconfig_xcvr1_writedata,' or k=='i_reconfig_xcvr2_writedata,' or k=='i_reconfig_xcvr3_writedata,' or k=='i_reconfig_eth_writedata,'):
				writetofile(top_op,'input wire [31:0] '+k+'\n')
			elif(k=='i_tx_data,'):
				writetofile(top_op,'input wire '+'['+str(widths_avst[SPEED[i]])+':0] '+k+'\n')
			elif(k=='i_rx_serial,' or k=='i_rx_serial_n,'):
				writetofile(top_op,'input wire '+'['+str(int(NUMTXLANE[i])-1)+':0] '+k+'\n')
			elif(k=='i_tx_empty,'):
				writetofile(top_op,'input wire '+'['+str(widths_empty_avst[SPEED[i]])+':0] '+k+'\n')
			elif(k=='i_tx_pfc,'):
				writetofile(top_op,'input wire '+'[7:0] '+k+'\n')
			elif(k=='i_custom_cadence,'):
				if(SYSPLL[i]=='3' and CUSTOM_CADENCE_GUI[i]=='1'):
					writetofile(top_op,'input wire '+k+'\n')
			elif(k=='i_tx_preamble,'):
				if((SPEED[i]=='40' or SPEED[i]=='50') and PP[i]=='1'):
					writetofile(top_op,'input wire '+'[63:0] '+k+'\n')
				else:
					writetofile(top_op,'//input wire '+'[63:0] '+k+'\n')
			else:
				writetofile(top_op,'input wire '+k+'\n')
		for k in wire_output:
			#if(k=='o_kr_stat,'):
			#	writetofile(top_op,'output wire '+'[7:0] '+k+'\n')
			if(k=='anlt_link,'):
				writetofile(top_op,'output wire '+'['+str(int(num_ports[i])-1)+':0] '+k+'\n')
			elif(k=='o_reconfig_xcvr0_readdata,' or k=='o_reconfig_xcvr1_readdata,' or k=='o_reconfig_xcvr2_readdata,' or k=='o_reconfig_xcvr3_readdata,' or k=='o_reconfig_eth_readdata,'):
                                writetofile(top_op,'output wire [31:0] '+k+'\n')
			elif(k=='o_rx_data,'):
				writetofile(top_op,'output wire '+'['+str(widths_avst[SPEED[i]])+':0] '+k+'\n')
			elif(k=='o_tx_serial,' or k=='o_tx_serial_n,'):
				writetofile(top_op,'output wire '+'['+str(int(NUMTXLANE[i])-1)+':0] '+k+'\n')
			elif(k=='o_rx_empty,'):
				writetofile(top_op,'output wire '+'['+str(widths_empty_avst[SPEED[i]])+':0] '+k+'\n')
			elif(k=='o_rx_pfc,'):
				writetofile(top_op,'output wire '+'[7:0] '+k+'\n')
			#TODO: EFIFO not available yet. Temporary remove	
			elif(k=='o_xcvrif_txfifo_pfull,' or k=='o_xcvrif_txfifo_pempty,' or k=='o_xcvrif_txfifo_empty,' or k=='o_xcvrif_hold_interrupt,'):
				if(SYSPLL[i]=='3'):
					#writetofile(top_op,'output wire '+'['+str(widths_txmac_macseg[SPEED[i]])+':0] '+k+"\n")
					writetofile(top_op,"//EFIFO not available yet. Temporary remove \n")
			elif(k=='o_rx_error,'):
				writetofile(top_op,'output wire '+'[5:0] '+k+'\n')
			elif(k=='o_rx_status_data,'):
				writetofile(top_op,'output wire '+'[39:0] '+k+'\n')
			elif(k=='o_rx_preamble,'):
				if((SPEED[i]=='40' or SPEED[i]=='50') and PP[i]=='1'):
					writetofile(top_op,'output wire '+'[63:0] '+k+'\n);')
				else:
					writetofile(top_op,'//output wire '+'[63:0] '+k+'\n);')
			else:
				writetofile(top_op,'output wire '+k+'\n')
	#Check for MACSeg interface and declare ports:
	if(INTERFACE[i]=='0'):
		writetofile(top_op,'//inst%s\n'%i)
		for k in wire_input:
			#if(k=='i_kr_ctrl,'):
			#	writetofile(top_op,'input wire '+'[7:0] '+k+'\n')
		        if(k=='i_reconfig_xcvr0_byteenable,' or k=='i_reconfig_xcvr1_byteenable,' or k=='i_reconfig_xcvr2_byteenable,' or k=='i_reconfig_xcvr3_byteenable,' or k=='i_reconfig_xcvr4_byteenable,' or k=='i_reconfig_xcvr5_byteenable,' or k=='i_reconfig_xcvr6_byteenable,' or k=='i_reconfig_xcvr7_byteenable,' or k=='i_reconfig_eth_byteenable,'or k=='i_reconfig_eth_mac_byteenable,'or k=='i_reconfig_eth_rcfg_byteenable,'):
		        	writetofile(top_op,'input wire [3:0] '+k+'\n')
		        elif(k=='i_reconfig_xcvr0_addr,' or k=='i_reconfig_xcvr1_addr,' or k=='i_reconfig_xcvr2_addr,' or k=='i_reconfig_xcvr3_addr,' or k=='i_reconfig_xcvr4_addr,' or k=='i_reconfig_xcvr5_addr,' or k=='i_reconfig_xcvr6_addr,' or k=='i_reconfig_xcvr7_addr,' or k=='i_reconfig_eth_addr,'or k=='i_reconfig_eth_mac_addr,'or k=='i_reconfig_eth_rcfg_addr,'):
		        	writetofile(top_op,'input wire [19:0] '+k+'\n')
		        elif(k=='i_reconfig_xcvr0_writedata,' or k=='i_reconfig_xcvr1_writedata,' or k=='i_reconfig_xcvr2_writedata,' or k=='i_reconfig_xcvr3_writedata,' or k=='i_reconfig_xcvr4_writedata,' or k=='i_reconfig_xcvr5_writedata,' or k=='i_reconfig_xcvr6_writedata,' or k=='i_reconfig_xcvr7_writedata,' or k=='i_reconfig_eth_writedata,'or k=='i_reconfig_eth_mac_writedata,'or k=='i_reconfig_eth_rcfg_writedata,'):
				writetofile(top_op,'input wire [31:0] '+k+'\n')
			elif(k=='i_tx_mac_data,'):
				writetofile(top_op,'input wire '+'['+str(widths_macseg[SPEED[i]])+':0] '+k+'\n')
			elif(k=='i_tx_mac_inframe,'):
				writetofile(top_op,'input wire '+'['+str(widths_txmac_macseg[SPEED[i]])+':0] '+k+'\n')
			elif(k=='i_tx_mac_eop_empty,'):
				writetofile(top_op,'input wire '+'['+str(int((int(widths_macseg[SPEED[i]])+1)*3/64)-1)+':0] '+k+'\n')
			elif(k=='i_tx_pfc,'):
				writetofile(top_op,'input wire '+'[7:0] '+k+'\n')
			elif(k=='i_custom_cadence,'):
				if(SYSPLL[i]=='3' and CUSTOM_CADENCE_GUI[i]=='1'):
					writetofile(top_op,'input wire '+k+'\n')
			elif(k=='i_tx_mac_error,'):
				writetofile(top_op,'input wire '+'['+str(widths_txmac_macseg[SPEED[i]])+':0] '+k+'\n')
			elif(k=='i_tx_mac_skip_crc,'):
				writetofile(top_op,'input wire '+'['+str(widths_txmac_macseg[SPEED[i]])+':0] '+k+'\n')
			elif(k=='i_rx_serial,' or k=='i_rx_serial_n,'):
				writetofile(top_op,'input wire '+'['+str(int(NUMTXLANE[i])-1)+':0] '+k+'\n')
			else:
				writetofile(top_op,'input wire '+k+'\n')
		for k in wire_output:
			#if(k=='o_kr_stat,'):
			#	writetofile(top_op,'output wire '+'[7:0] '+k+'\n')
			if(k=='anlt_link,'):
				writetofile(top_op,'output wire '+'['+str(int(num_ports[i])-1)+':0] '+k+'\n')
			elif(k=='o_reconfig_xcvr0_readdata,' or k=='o_reconfig_xcvr1_readdata,' or k=='o_reconfig_xcvr2_readdata,' or k=='o_reconfig_xcvr3_readdata,' or k=='o_reconfig_xcvr4_readdata,' or k=='o_reconfig_xcvr5_readdata,' or k=='o_reconfig_xcvr6_readdata,' or k=='o_reconfig_xcvr7_readdata,' or k=='o_reconfig_eth_readdata,'):
                                writetofile(top_op,'output wire [31:0] '+k+'\n')
			elif(k=='o_rx_mac_data,'):
				writetofile(top_op,'output wire '+'['+str(widths_macseg[SPEED[i]])+':0] '+k+'\n')
			elif(k=='o_rx_mac_inframe,'):
				writetofile(top_op,'output wire '+'['+str(widths_txmac_macseg[SPEED[i]])+':0] '+k+'\n')
			elif(k=='o_rx_pfc,'):
				writetofile(top_op,'output wire '+'[7:0] '+k+'\n')
			elif(k=='o_rx_mac_eop_empty,'):
				writetofile(top_op,'output wire '+'['+str(int((int(widths_macseg[SPEED[i]])+1)*3/64)-1)+':0] '+k+'\n')
			#TODO: EFIFO not available yet. Temporary remove
			elif(k=='o_xcvrif_txfifo_pfull,' or k=='o_xcvrif_txfifo_pempty,' or k=='o_xcvrif_txfifo_empty,' or k=='o_xcvrif_hold_interrupt,'):
				if(SYSPLL[i]=='3'):
					#writetofile(top_op,'output wire '+'['+str(widths_txmac_macseg[SPEED[i]])+':0] '+k+';'+"\n")
					writetofile(top_op,"//EFIFO not available yet. Temporary remove\n")
			elif(k=='o_rx_mac_error,'):
				writetofile(top_op,'output wire '+'['+str(int(int(widths_txmac_macseg[SPEED[i]])*2)+1)+':0] '+k+'\n')
			elif(k=='o_rx_mac_fcs_error,'):
				writetofile(top_op,'output wire '+'['+str(widths_txmac_macseg[SPEED[i]])+':0] '+k+'\n')
			elif(k=='o_rx_mac_status,'):
				writetofile(top_op,'output wire '+'['+str(int((int(widths_macseg[SPEED[i]])+1)*3/64)-1)+':0] '+k+'\n')
			elif(k=='o_rxstatus_data,'):
				writetofile(top_op,'output wire '+'[39:0] '+k+'\n);')
			elif(k=='o_tx_serial,' or k=='o_tx_serial_n,'):
				writetofile(top_op,'output wire '+'['+str(int(NUMTXLANE[i])-1)+':0] '+k+'\n')
			else:
				writetofile(top_op,'output wire '+k+'\n')
				
#Instantiation of top_ip module:
writetofile(top_op,');\n')
writetofile(top_op,'\n top_ip #() top_ip0 ( \n')
writetofile(top_op,'    .i_src_ip_clk(i_src_ip_clk)\n')
writetofile(top_op,');\n')
#endmodule
writetofile(top_op,'\n endmodule')

shutil.copy(tb_var+'/ip/ethernet/alt_ethernet_crete_gdr/qhip/scripts/funct_deterministic/common/stub_templates/eth_f_hw__tiles.sv',env_var+'/gdr_gen_qhip_files/')
shutil.copy(tb_var+'/ip/ethernet/alt_ethernet_crete_gdr/qhip/scripts/funct_deterministic/common/stub_templates/eth_anlt_f_0.v',env_var+'/gdr_gen_qhip_files/')
shutil.copy(tb_var+'/ip/ethernet/alt_ethernet_crete_gdr/qhip/scripts/funct_deterministic/common/stub_templates/gavmm_f_0.v',env_var+'/gdr_gen_qhip_files/')
shutil.copy(tb_var+'/ip/ethernet/alt_ethernet_crete_gdr/qhip/scripts/funct_deterministic/common/stub_templates/systemclk_f_0.v',env_var+'/gdr_gen_qhip_files/')
shutil.copy(tb_var+'/ip/ethernet/alt_ethernet_crete_gdr/qhip/scripts/funct_deterministic/common/stub_templates/top_ip.v',env_var+'/gdr_gen_qhip_files/')
