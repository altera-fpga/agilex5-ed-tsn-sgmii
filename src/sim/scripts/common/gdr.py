# -*- coding: iso-8859-1 -*-
import os,glob,sys,operator
env_var = sys.argv[1]
cr_mode = sys.argv[2]
an_chan0= sys.argv[3]
tb_var= sys.argv[4]
single_var_multi_inst = sys.argv[5]
ptp_debug_acc_en = sys.argv[6]

widths_ptp_num_words={'10':'0','25':'0','40':'1','50':'1','100':'3','200':'7','400':'15'}

try:
    os.stat(env_var+"/gdr_gen_qhip_files")
except:
    os.mkdir(env_var+"/gdr_gen_qhip_files")

pam4=[]
nrz=['10G_1','25G_1','40G_4','50G_2','100G_4','200G_8','400G_16']
for f in os.listdir(env_var+"/gdr_gen_qhip_files"):
	print("Removing file %s"%f)
	os.remove(env_var+"/gdr_gen_qhip_files/"+f)

os.system("python new_gdrr.py %s %s %s"%(env_var,tb_var,ptp_debug_acc_en))
temp,vari=[],[]
for i in open("param_tb.csv","r"):
	temp.append([j.strip() for j in i.split(',')])
#print(temp[0][1])

for i in range(len(temp)):
	vari.append(temp[i][0])
vari.remove('INSTANCE')

#For PTP only
FP_WIDTH=[None]

#variables are assigned started from here
for i in range(len(temp)):
	vars()[temp[i][0]] = [j for j in [k for k in temp[i][1:]]]

INSTANCE = list(map(int, INSTANCE)) 
mode = open(env_var+"/gdr_gen_qhip_files/gdr_modes.txt","w+")
modes = {'0': 'MACSEG' , '1': 'PCSMAC', '2': 'PCSONLY', '3': 'OTN', '4': 'FLEXE'}
vari = list(filter(None, vari))
#print(vari)
def hex2bin(a,b):
  if(a==''):
	a='0'
  x='{0:0%sb}'%str(b)
  res=x.format(int(a,16))
  return res
def writetofile(handle,a):
	#print(handle)
	#print(a)
	handle.writelines(a)

top = open(env_var+"/gdr_gen_qhip_files/eth_ehip_gdr_top.sv","w+")
define = open(env_var+"/gdr_gen_qhip_files/gdr_tb_defines.v","w+")

for i in range(len(INSTANCE)):
	for j in range(INSTANCE[i]):
		a = hex2bin(ANLTENNODE[i].strip('0'),INSTANCE[i])[::-1]
		new_str = [str(int(str(2**j),16)) if x!='0' else '0' for x in list(ACTIVENODE[i])]
		#print(int(str(2**j),16)*int(a[j]))
		new_str2 = [str(int(str(2**j),16)*int(a[j])) if x!='0' else '0' for x in list(ANLTENNODE[i])]
#		writetofile(mode,MODE[i]+'_'+TRANSTYPE[i]+'_'+PTP[i]+'_'+ANLT[i]+'_'+RXPAUSEFWD[i]+'_'+SA[i]+'_'+TXVLAN[i]+'_'+RXVLAN[i]+'_'+ENMXFRSIZE[i]+'_'+ENASYNCAD[i]+'_'+PP[i]+'_'+SFD[i]+'_'+LF[i]+'_'+RXBYTEREM[i]+'_'+READYDROP[i]+'_'+RDYLAT[i]+'_'+PHYREFCLK[i]+'_'+SYSPLL[i]+'_'+SYSPLLCST[i]+'_'+CAD_NUM[i]+'_'+CAD_DEN[i]+'_'+IPG[i]+'_'+FEC[i]+'_'+TXMXFRSIZE[i]+'_'+RXMXFRSIZE[i]+'_'+IPGREM[i]+'_'+str(''.join(new_str))+'_'+str(''.join(new_str2))+'_'+modes[INTERFACE[i]]+"\n")

		if(PTP[i] == '1'):
			if(FP_WIDTH[i]==None):
				print("FP_WIDTH undefined, default to 32 bit")
				writetofile(mode,MODE[i]+'_'+TRANSTYPE[i]+'_'+PTP[i]+'_'+ENABLE_AN[i]+'_'+ENABLE_LT[i]+'_'+an_chan0+'_'+cr_mode+'_'+RXPAUSEFWD[i]+'_'+SA[i]+'_'+TXVLAN[i]+'_'+RXVLAN[i]+'_'+ENMXFRSIZE[i]+'_'+ENASYNCAD[i]+'_'+PP[i]+'_'+S_PREAMBLE[i]+'_'+SFD[i]+'_'+LF[i]+'_'+FC[i]+'_'+RXBYTEREM[i]+'_'+READYDROP[i]+'_'+RDYLAT[i]+'_'+PHYREFCLK[i]+'_'+SYSPLL[i]+'_'+SYSPLLCST[i]+'_'+CAD_NUM[i]+'_'+CAD_DEN[i]+'_'+IPG[i]+'_'+FEC[i]+'_'+TXMXFRSIZE[i]+'_'+RXMXFRSIZE[i]+'_'+IPGREM[i]+'_'+ACTIVENODE[i]+'_'+ANLTENNODE[i]+'_'+'32'+'_'+modes[INTERFACE[i]]+"\n")
			else:
				print("FP_WIDTH defined as",FP_WIDTH[i])
				writetofile(mode,MODE[i]+'_'+TRANSTYPE[i]+'_'+PTP[i]+'_'+ENABLE_AN[i]+'_'+ENABLE_LT[i]+'_'+an_chan0+'_'+cr_mode+'_'+RXPAUSEFWD[i]+'_'+SA[i]+'_'+TXVLAN[i]+'_'+RXVLAN[i]+'_'+ENMXFRSIZE[i]+'_'+ENASYNCAD[i]+'_'+PP[i]+'_'+S_PREAMBLE[i]+'_'+SFD[i]+'_'+LF[i]+'_'+FC[i]+'_'+RXBYTEREM[i]+'_'+READYDROP[i]+'_'+RDYLAT[i]+'_'+PHYREFCLK[i]+'_'+SYSPLL[i]+'_'+SYSPLLCST[i]+'_'+CAD_NUM[i]+'_'+CAD_DEN[i]+'_'+IPG[i]+'_'+FEC[i]+'_'+TXMXFRSIZE[i]+'_'+RXMXFRSIZE[i]+'_'+IPGREM[i]+'_'+ACTIVENODE[i]+'_'+ANLTENNODE[i]+'_'+FP_WIDTH[i]+'_'+modes[INTERFACE[i]]+"\n")
		else:
			writetofile(mode,MODE[i]+'_'+TRANSTYPE[i]+'_'+PTP[i]+'_'+ENABLE_AN[i]+'_'+ENABLE_LT[i]+'_'+an_chan0+'_'+cr_mode+'_'+RXPAUSEFWD[i]+'_'+SA[i]+'_'+TXVLAN[i]+'_'+RXVLAN[i]+'_'+ENMXFRSIZE[i]+'_'+ENASYNCAD[i]+'_'+PP[i]+'_'+S_PREAMBLE[i]+'_'+SFD[i]+'_'+LF[i]+'_'+FC[i]+'_'+RXBYTEREM[i]+'_'+READYDROP[i]+'_'+RDYLAT[i]+'_'+PHYREFCLK[i]+'_'+SYSPLL[i]+'_'+SYSPLLCST[i]+'_'+CAD_NUM[i]+'_'+CAD_DEN[i]+'_'+IPG[i]+'_'+FEC[i]+'_'+TXMXFRSIZE[i]+'_'+RXMXFRSIZE[i]+'_'+IPGREM[i]+'_'+ACTIVENODE[i]+'_'+ANLTENNODE[i]+'_'+LL10G_SPEED[i]+'_'+LL10G_VAR[i]+'_'+modes[INTERFACE[i]]+'_'+DEVICE_MODE[i]+"\n")
        if(LL10G_VAR[i] == 'MGE'):
                print("LL10G_VAR is :",LL10G_VAR[i])
                writetofile(define,'\n`define ETH_MGE\n')
        else:
                print("MGE is not defined.LL10G_VAR is :",LL10G_VAR[i])
	if(LL10G_VAR[i] == 'MGE' or LL10G_VAR[i] == 'MGE_A10' ):
                print("LL10G_VAR is :",LL10G_VAR[i])
                #writetofile(define,'\n`define ETH_MGE\n')
		if(LL10G_SPEED[i] == '_1G'):
                	print("LL10G speed is :",LL10G_SPEED[i])
                	writetofile(define,'\n`define ETH_MGE_1G\n')
        	elif(LL10G_SPEED[i] == '_2p5G'):
                	print("LL10G speed is :",LL10G_SPEED[i])
                	writetofile(define,'\n`define ETH_MGE_2p5G\n')
		else:
                	print("LL10G speed is :",LL10G_SPEED[i])
        else:
                print("MGE is not defined.LL10G_VAR is :",LL10G_VAR[i])
        if(LL10G_VAR[i] == 'MGBASET' or LL10G_VAR[i] == 'MGBASET_A10' ):
                print("LL10G_VAR is :",LL10G_VAR[i])
                #writetofile(define,'\n`define ETH_MGE\n')
		if(LL10G_SPEED[i] == '_1G'):
                	print("LL10G speed is :",LL10G_SPEED[i])
                	writetofile(define,'\n`define ETH_MGBASET_1G\n')
		else:
                	print("LL10G speed is :",LL10G_SPEED[i])
        else:
                print("MGBASET is not defined.LL10G_VAR is :",LL10G_VAR[i])


for i in range(len(temp)):
	vars()[temp[i][0]] = vars()[temp[i][0]][:len(INSTANCE)]

for i in range(len(vari)):
	vars()[vari[i]] = [[item]*int(x) for item,x in zip(vars()[vari[i]],INSTANCE)]
print(MODE)
SPEED,NUMTXLANE=[],[]
ANLT=[]
print("script_debug_gdr ANLT is",ANLT)
print("script_debug_gdr ENABLE_AN is size is ",ENABLE_AN,len(ENABLE_AN))
for i in range(len(ENABLE_AN)):
	ANLT.append(int(ENABLE_AN[i][0]) | int(ENABLE_LT[i][0]))
print("script_debug_gdr ANLT is",ANLT)
for i in range(len(vari)):
	vars()[vari[i]] = reduce(operator.concat,vars()[vari[i]])
for i in MODE:
	SPEED.append(i.split('_')[0][:-1])
	NUMTXLANE.append(i.split('_')[1])
print("script_debug_gdr.py: speed is",SPEED)
#for i in range(len(temp)):
	#print(vars()[temp[i][0]])
print("script_debug_gdr.py: MODE is",MODE)
print(SYSPLLCST)
chk_speed = sum([int(x) for x in SPEED])

if(chk_speed in [50,100,200,400]):
	print("Valid speed Combination")
else:
	print("Invalid combination")





mode.close()
  
for i in open("eth_ehip_gdr_top_head.sv","r"):
	if(i[0:16]==' `define NUM_10G'):
		#print(i[0:16])
		i =' `define NUM_10G '+str(SPEED.count('10'))+"\n"
		#writetofile(define,i)
	elif(i[0:16]==' `define NUM_25G'):
		i =' `define NUM_25G '+str(SPEED.count('25'))+"\n"
		#writetofile(define,i)
	elif(i[0:16]==' `define NUM_40G'):
		i =' `define NUM_40G '+str(SPEED.count('40'))+"\n"
		#writetofile(define,i)
	elif(i[0:16]==' `define NUM_50G'):
		i =' `define NUM_50G '+str(SPEED.count('50'))+"\n"
		#writetofile(define,i)
	elif(i[0:17]==' `define NUM_100G'):
		i =' `define NUM_100G '+str(SPEED.count('100'))+"\n"
		#writetofile(define,i)
	elif(i[0:17]==' `define NUM_200G'):
		i =' `define NUM_200G '+str(SPEED.count('200'))+"\n"
		#writetofile(define,i)
	elif(i[0:17]==' `define NUM_400G'):
		i =' `define NUM_400G '+str(SPEED.count('400'))+"\n"
		#writetofile(define,i)
	elif(i[0:17]==' `define NUM_INST'):
		i =' `define NUM_INST '+str(SPEED.count('400')+SPEED.count('200')+SPEED.count('100')+SPEED.count('50')+SPEED.count('40')+SPEED.count('25')+SPEED.count('10'))+"\n"
	elif(i=='            `SVT_ETHERNET_TEST_SUITE_TOP_COMPILE(0,eth_env_top, eth_env_top.svt_ethernet_drv_0.Bfm, eth_env_top.svt_ethernet_mon_chk_0.Chk,"")'+'\n'):
		for j in range(len(SPEED)):
			f=i
			f=f.replace('0','%s'%str(j))
			#print(f)
			writetofile(top,f+'\n')
		i=''
	elif(i=='   defparam dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e400g_lphy.LOG2_MRK = X;'+'\n'):
		for j in range(len(SPEED)):
			if(SPEED[j]=='25' or SPEED[j]=='100'):
				i='	defparam dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e400g_lphy.LOG2_MRK = 5; \n'
				print("Inside PTP LOG MRK 5")
			else:
				i='	defparam dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e400g_lphy.LOG2_MRK = 6; \n'
				print("Inside PTP LOG MRK 6")
	elif(i=='   defparam dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e400g_lphy.LOG2_MRK = X;'+'\n'):
		for j in range(len(SPEED)):
			if(SPEED[j]=='25' or SPEED[j]=='100'):
				i='	defparam dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e400g_lphy.LOG2_MRK = 5; \n'
				print("Inside PTP LOG MRK 5")
			else:
				i='	defparam dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e400g_lphy.LOG2_MRK = 6; \n'
				print("Inside PTP LOG MRK 6")
	#TODO_GDR: TODO SRC AUTO WORKAROUND - HSD#https://hsdes.intel.com/appstore/article/#/22011517187
	#elif(i=='     //force eth_env_top.dut.ip0.top_ip0.sip_inst.PTP_SOFT_GEN.soft_ptp.ptp_ref_ts_capture_u.i_rxpll_lock = x;\n'):
	#	if((SPEED[j]=='10' or SPEED[j]=='25' or SPEED[j]=='50') and (SYSPLL[j]!='3')):
	#		#UX
	#		if(TRANSTYPE[j]== '0'):
	#			i='     force eth_env_top.dut.ip0.top_ip0.sip_inst.PTP_SOFT_GEN.soft_ptp.ptp_ref_ts_capture_u.i_rxpll_lock = dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_ux_quad_3.o_xcvrrc_clkrst_ux_ds_3__oct_pcs_rxcdrlockstatus_lx_a; \n'
	#		#BK
	#		else:
	#			i='	  force eth_env_top.dut.ip0.top_ip0.sip_inst.PTP_SOFT_GEN.soft_ptp.ptp_ref_ts_capture_u.i_rxpll_lock = dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_barak_quad.o_xcvrrc_clkrst_barak_ds_3__oct_pcs_rxcdrlockstatus_lx_a; \n'
	#	elif(SPEED[j]=='400'):
	#		i='     force eth_env_top.dut.ip0.top_ip0.sip_inst.PTP_SOFT_GEN.soft_ptp.ptp_ref_ts_capture_u.i_rxpll_lock = {dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_ux_quad_2.o_xcvrrc_clkrst_ux_ds_0__oct_pcs_rxcdrlockstatus_lx_a, dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_ux_quad_2.o_xcvrrc_clkrst_ux_ds_1__oct_pcs_rxcdrlockstatus_lx_a, dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_ux_quad_2.o_xcvrrc_clkrst_ux_ds_2__oct_pcs_rxcdrlockstatus_lx_a, dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_ux_quad_2.o_xcvrrc_clkrst_ux_ds_3__oct_pcs_rxcdrlockstatus_lx_a, dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_ux_quad_3.o_xcvrrc_clkrst_ux_ds_0__oct_pcs_rxcdrlockstatus_lx_a, dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_ux_quad_3.o_xcvrrc_clkrst_ux_ds_1__oct_pcs_rxcdrlockstatus_lx_a, dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_ux_quad_3.o_xcvrrc_clkrst_ux_ds_2__oct_pcs_rxcdrlockstatus_lx_a, dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_ux_quad_3.o_xcvrrc_clkrst_ux_ds_3__oct_pcs_rxcdrlockstatus_lx_a}; \n'
	#TODO: Workaround for BARAK div68 clk HSD# https://hsdes.intel.com/appstore/article/#/1508331929
	#elif(i=='     //force `QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_barak_quad.u_ip758brktop.serdes_wrap_ins.serdes_lane_wrap_ins.ip758brktop_serdes_lane_top_lane3_ins.brk_lane_ana_top_ins.brk_lane_ana_wrap_ins.ip758brktop_lane_top.brk_simple_ana_ins.div33_34_sel[1:0] = 2\'b11;\n'):
	#	#Barak variants only
	#	if(TRANSTYPE[j] == '1' and (SPEED[j]=='50' or (SPEED[j]=='100' and NUMTXLANE[j]== '2') or SPEED[j]=='200')):
	#		i='     force `QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_barak_quad.u_ip758brktop.serdes_wrap_ins.serdes_lane_wrap_ins.ip758brktop_serdes_lane_top_lane3_ins.brk_lane_ana_top_ins.brk_lane_ana_wrap_ins.ip758brktop_lane_top.brk_simple_ana_ins.div33_34_sel[1:0] = 2\'b11; \n'
	#TODO_GDR: TODO SRC AUTO WORKAROUND -  https://hsdes.intel.com/resource/1508480333
	elif(i=='	  //force eth_env_top.eth_fc_if_ip0.assertion_off = 1;\n'):
		if(SPEED[j]=='10'):
			i='	  force eth_env_top.eth_fc_if_ip0.assertion_off = 1;\n'
	#ETH17a		
	#elif(i=='     //DL workaround start\n'):
	#	if(SPEED[j]=='25') and (SYSPLL[j]=='3'):
	#		i='    force eth_env_top.dut.ip0.top_ip0.x_eth_f_ptp_quad_mapping.xmr_ptp_async_cal_pulse[7:0]    = {4\'h0,eth_env_top.dut.ip0.top_ip0.x_eth_f_ptp_quad_mapping.i_ptp_async_cal_pulse [0],3\'h0}; \n    force eth_env_top.dut.ip0.top_ip0.x_eth_f_ptp_quad_mapping.xmr_tx_ptp_async_cal_sel[7:0]    = {4\'h0,eth_env_top.dut.ip0.top_ip0.x_eth_f_ptp_quad_mapping.i_tx_ptp_async_cal_sel[0],3\'h0}; \n     force eth_env_top.dut.ip0.top_ip0.x_eth_f_ptp_quad_mapping.xmr_rx_ptp_async_cal_sel[7:0]    = {4\'h0,eth_env_top.dut.ip0.top_ip0.x_eth_f_ptp_quad_mapping.i_rx_ptp_async_cal_sel[0],3\'h0}; \n    force eth_env_top.dut.ip0.top_ip0.x_eth_f_ptp_quad_mapping.o_tx_ptp_async_pulse[0]      = eth_env_top.dut.ip0.top_ip0.x_eth_f_ptp_quad_mapping.xmr_tx_ptp_async_pulse[3]; \n    force eth_env_top.dut.ip0.top_ip0.x_eth_f_ptp_quad_mapping.o_rx_ptp_async_pulse[0]      = eth_env_top.dut.ip0.top_ip0.x_eth_f_ptp_quad_mapping.xmr_rx_ptp_async_pulse[3]; \n'
	writetofile(top,i)
writetofile(define,'\n`define NUM_INST %s'%str(len(SPEED))+'\n')
writetofile(define,'\n`define NUM_OF_PORTS 8\n')
for i in range(len(SPEED)):
	   writetofile(define,'\n`define INST_%s'%i+'\n')
	   if(INTERFACE[i]=='3'):
	   	writetofile(define,'`define INST_OTN_%s'%i+'\n')
	   if(INTERFACE[i]=='4'):
	   	writetofile(define,'`define INST_FLEXE_%s'%i+'\n')
	   writetofile(define,'`define NUM_LANES_IP%s '%i+str(NUMTXLANE[i])+'\n')
	   writetofile(define,'`define NUM_LANES_IP%s_'%i+str(NUMTXLANE[i]))
	   #TODO: Temp for PTP fake reset usage only
	   writetofile(define,'\n`define PTP_NUM_WORDS_IP '+str(int(widths_ptp_num_words[SPEED[j]])+1)+'\n')
if('1' in INTERFACE or '0' in INTERFACE):
	writetofile(define,'\n`define MAC_MODE\n')
writetofile(define,'\n`define CLK_FREQ(F) ((1000000)/(2*(F/1000.0)))\n')
tempvar_avst,tempvar_macseg,tempvar_pcsonly,tempvar_otnflexe=[],[],[],[]
tempvar_macseg_ptp=[]
if('1' in INTERFACE):
	for j in open("gdr_avst_template.sv","r"):
		#print(j[0:20])
		tempvar_avst.append(j.split())
		#if(j[0:21] =='// end DUT port wires'):
		if('SM' in DEVICE_MODE):
                    print("Entered flag SM= ",DEVICE_MODE)
                    if(j[0:24] =='// end SM DUT port wires'):
                        break
                #else:
                #    if(j[0:21] =='// end DUT port wires'):
		#	break
	tempvar_avst = list(filter(None, tempvar_avst))
if('2' in INTERFACE):
	for j in open("gdr_pcs_only_template.sv","r"):
		#print(j[0:20])
		tempvar_pcsonly.append(j.split())
		if(j[0:21] =='// end DUT port wires'):
			break
	tempvar_pcsonly = list(filter(None, tempvar_pcsonly))
if('3' in INTERFACE or '4' in INTERFACE):
	for j in open("gdr_otn_flexe_template.sv","r"):
		#print(j[0:20])
		tempvar_otnflexe.append(j.split())
		if(j[0:21] =='// end DUT port wires'):
			break
	tempvar_otnflexe = list(filter(None, tempvar_otnflexe))
if('0' in INTERFACE):
	for j in open("gdr_seg_template.sv","r"):
	      #print(j[0:20])
	      tempvar_macseg.append(j.split())
	      if(j[0:21] =='// end DUT port wires'):
		      break
	tempvar_macseg = list(filter(None, tempvar_macseg))
	#print(tempvar_macseg)
	#PTP
	for k in open("gdr_macseg_ptp_template.sv","r"):
	      #print(k[0:20])
	      tempvar_macseg_ptp.append(k.split())
	      if(k[0:21] =='// end DUT port wires'):
		      break
	tempvar_macseg_ptp = list(filter(None, tempvar_macseg_ptp))	

	
logic_avst,wire_avst,reg_avst,wire_avst_width,reg_avst_width=[],[],[],[],[]
logic_pcsonly,logic_pcsonly_width,wire_pcsonly,reg_pcsonly,wire_pcsonly_width,reg_pcsonly_width=[],[],[],[],[],[]
logic_macseg,logic_macseg_width,wire_macseg,reg_macseg,wire_macseg_width,reg_macseg_width,typedef_macseg=[],[],[],[],[],[],[]
logic_otnflexe,logic_otnflexe_width,wire_otnflexe,reg_otnflexe,wire_otnflexe_width,reg_otnflexe_width,typedef_otnflexe=[],[],[],[],[],[],[]
logic_macseg_ptp,logic_macseg_ptp_width,wire_macseg_ptp,reg_macseg_ptp,wire_macseg_ptp_width,reg_macseg_ptp_width,typedef_macseg_ptp=[],[],[],[],[],[],[]
if('1' in INTERFACE):
	for i in tempvar_avst:
		#print(i[0])
		if(i[0]=='logic'):
			#print(i[1][-4:])
			if(i[1][-4:]=='0=0;'):
				#print("in")	
				logic_avst.append(i[1][:-3]) #Intialize them to 0
			else:
				logic_avst.append(i[1][:-1])
		if(i[0]=='wire'):
			if(i[1][0]=='[' and i[1][-1]==']'):
				wire_avst_width.append(i[2][:-1])
			else:
				wire_avst.append(i[1][:-1])
		if(i[0]=='reg' or i[0]=='//reg' ):
			if(i[1]=='tx_serial_ip0;' or i[1]=='rx_serial_ip0;' or i[1]=='rx_serial_n_ip0;' or i[1]=='tx_serial_n_ip0;'):
				reg_avst_width.append(i[1][:-1])
			if(i[1][0]=='[' and i[1][-1]==']'):
				reg_avst_width.append(i[2][:-1])
			else:
				reg_avst.append(i[1][:-1])
if('2' in INTERFACE):
	for i in tempvar_pcsonly:
		#print(i[0])
		if(i[0]=='logic'):
			#print(i[1][-4:])
			if(i[1][-4:]=='0=0;'):
				#print("in")	
				logic_pcsonly.append(i[1][:-3]) #Intialize them to 0
			elif(i[1][0]=='[' and i[1][-1]==']'):
				logic_pcsonly_width.append(i[2][:-1])
			else:
				logic_pcsonly.append(i[1][:-1])
		if(i[0]=='wire'):
			if(i[1][0]=='[' and i[1][-1]==']'):
				wire_pcsonly_width.append(i[2][:-1])
			else:
				wire_pcsonly.append(i[1][:-1])
		if(i[0]=='reg' or i[0]=='//reg' ):
			if(i[1]=='tx_serial_ip0;' or i[1]=='rx_serial_ip0;' or i[1]=='rx_serial_n_ip0;' or i[1]=='tx_serial_n_ip0;'):
				reg_pcsonly_width.append(i[1][:-1])
			if(i[1][0]=='[' and i[1][-1]==']'):
				reg_pcsonly_width.append(i[2][:-1])
			else:
				reg_pcsonly.append(i[1][:-1])
if('3' in INTERFACE or '4' in INTERFACE):
	for i in tempvar_otnflexe:
		#print(i[0])	
		if(i[0]=='logic'):
			#print(i[1][-4:])
			if(i[1][-4:]=='0=0;'):
				logic_otnflexe.append(i[1][:-3]) #Intialize them to 0
			elif(i[1][0]=='[' and i[1][-1]==']'):
				logic_otnflexe_width.append(i[2][:-1])
			else:
				logic_otnflexe.append(i[1][:-1])
		if(i[0]=='wire'):
			if(i[1][0]=='[' and i[1][-1]==']'):
				wire_otnflexe_width.append(i[2][:-1])
			else:
				wire_otnflexe.append(i[1][:-1])
		if(i[0]=='reg' or i[0]=='//reg' ):
			if(i[1]=='tx_serial_ip0;' or i[1]=='rx_serial_ip0;' or i[1]=='rx_serial_n_ip0;' or i[1]=='tx_serial_n_ip0;'):
				reg_otnflexe_width.append(i[1][:-1])
			if(i[1][0]=='[' and i[1][-1]==']'):
				reg_otnflexe_width.append(i[2][:-1])
			else:
				reg_otnflexe.append(i[1][:-1])
if('0' in INTERFACE):
	for i in tempvar_macseg:
		#print(i[0])
		if(i[0]=='typedef'):
			typedef_macseg.append(i[3][:-1])
		if(i[0]=='logic'):
			#print(i[1][-4:])
			if(i[1][-4:]=='0=0;'):
				#print("in")	
				logic_macseg.append(i[1][:-3]) #Intialize them to 0
			elif(i[1][0]=='[' and i[1][-1]==']'):
				logic_macseg_width.append(i[2][:-1])
			else:
				logic_macseg.append(i[1][:-1])
		if(i[0]=='wire'):
			if(i[1][0]=='[' and i[1][-1]==']'):
				wire_macseg_width.append(i[2][:-1])
			else:
				wire_macseg.append(i[1][:-1])
		if(i[0]=='reg' or i[0]=='//reg' ):
			if(i[1]=='tx_serial_ip0;' or i[1]=='rx_serial_ip0;'or i[1]=='rx_serial_n_ip0;' or i[1]=='tx_serial_n_ip0;'):
				reg_macseg_width.append(i[1][:-1])
			if(i[1][0]=='[' and i[1][-1]==']'):
				reg_macseg_width.append(i[2][:-1])
			else:
				reg_macseg.append(i[1][:-1])
	for i in tempvar_macseg_ptp:
		#print(i[0])
		if(i[0]=='typedef'):
			typedef_macseg_ptp.append(i[3][:-1])
		if(i[0]=='logic'):
			#print(i[1][-4:])
			if(i[1][-4:]=='0=0;'):
				#print("in")	
				logic_macseg_ptp.append(i[1][:-3]) #Intialize them to 0
			elif(i[1][0]=='[' and i[1][-1]==']'):
				logic_macseg_ptp_width.append(i[2][:-1])
			else:
				logic_macseg_ptp.append(i[1][:-1])
		if(i[0]=='wire'):
			if(i[1][0]=='[' and i[1][-1]==']'):
				#print("script_debug_gdr macseg_ptp wire width",i[2][:-1])
				wire_macseg_ptp_width.append(i[2][:-1])
			else:
				#print("script_debug_gdr macseg_ptp wire",i[1][:-1])
				wire_macseg_ptp.append(i[1][:-1])
		if(i[0]=='reg' or i[0]=='//reg' ):
			if(i[1]=='tx_serial_ip0;' or i[1]=='rx_serial_ip0;'or i[1]=='rx_serial_n_ip0;' or i[1]=='tx_serial_n_ip0;'):
				reg_macseg_ptp_width.append(i[1][:-1])
			if(i[1][0]=='[' and i[1][-1]==']'):
				#print("script_debug_gdr macseg_ptp reg width",i[2][:-1])
				reg_macseg_ptp_width.append(i[2][:-1])
			else:
				#print("script_debug_gdr macseg_ptp reg",i[1][:-1])
				reg_macseg_ptp.append(i[1][:-1])				
if('tx_serial_ip0' in reg_avst or 'rx_serial_ip0' in reg_avst):
	reg_avst.remove('tx_serial_ip0')
	reg_avst.remove('rx_serial_ip0')
#print(wire_macseg)	
a = 0	
print("script_debug_gdr macseg",reg_macseg_width)
widths_avst = {'10': '63' , '25': '63', '40':'127','50': '127', '100': '511'}
widths_avst_empty = {'10': '2' , '25': '2', '40':'3','50': '3', '100': '5'}
widths_macseg = {'10': '63' , '25': '63','40': '127', '50': '127', '100': '255','200':'511','400':'1023'}
widths_txmac_macseg={'10':'0','25':'0','40':'1','50':'1','100':'3','200':'7','400':'15'}
#widths_pcsonly = {'10': '63' , '25': '63','40': '127', '50': '127', '100': '255','200':'511','400':'1023'}
widths_txmac_pcsonly={'10':'0','25':'0','40':'1','50':'1','100':'3','200':'7','400':'15'}
widths_otnflexe = {'10': '65' , '25': '65','40': '131', '50': '131', '100': '263','200':'527','400':'1055'}
value_freq_otn_flexe    = {'10':'156.25','25':'390.625','40':'625','50':'781.25','100':'1562.5','200':'3125','400':'6250'}
value_rx_freq_otn_flexe = {'10':'156.25','25':'390.625','40':'625','50':'781.25','100':'1562.5','200':'3125','400':'6250'}
#value_rx_freq_otn_flexe = {'10':'156.25','25':'390.625','40':'312.5','50':'390.625','100':'390.625','200':'390.625','400':'390.625'}
value_otn_flexe = {'10':'4','25':'4','40':'2','50':'2','100':'5','200':'5','400':'5'}
value_otn_flexe_inst_cnt = {'10':'5119','25':'5119','40':'315','50':'315','100':'315','200':'315','400':'315'}
inst=str(len(SPEED))
for i in range(len(SPEED)):
	if(INTERFACE[i]=='1'):
                if(SPEED[i]=='25' and PTP[i] == '1' and inst=='16'):
                        NUMTXLANE[i]=4
		vars()['avst%s' %i] = open(env_var+"/gdr_gen_qhip_files/gdr_avst_ip%s.sv"%i,"w+")
		for q in logic_avst:
			if(q=='clk_ref_ip0' or q=='clk_sys_ip0' or q=='clk_status_ip0'):
				writetofile(vars()['avst%s'%i],'logic '+q[:-1]+str(i)+'=0'+';'+"\n")		
			else:
				writetofile(vars()['avst%s'%i],'logic '+q[:-1]+str(i)+';'+"\n")
		for w in reg_avst:
			if(w=='reconfig_xcvr0_read_ip0'):
				for f in range(int(NUMTXLANE[i])):
					writetofile(vars()['avst%s'%i],'reg '+w[:-10]+str(f)+'_read_ip'+str(i)+';'+"\n")
			elif(w=='reconfig_xcvr0_write_ip0'):
				for f in range(int(NUMTXLANE[i])):
					writetofile(vars()['avst%s'%i],'reg '+w[:-11]+str(f)+'_write_ip'+str(i)+';'+"\n")
			else:
				writetofile(vars()['avst%s'%i],'reg '+w[:-1]+str(i)+';'+"\n")
		for t in wire_avst:
			if(t=='reconfig_xcvr0_waitrequest_ip0'):
				for f in range(int(NUMTXLANE[i])):
					writetofile(vars()['avst%s'%i],'wire '+t[:-17]+str(f)+'_waitrequest_ip'+str(i)+';'+"\n")
			elif(t=='reconfig_xcvr0_readdata_valid_ip0'):
				for f in range(int(NUMTXLANE[i])):
					writetofile(vars()['avst%s'%i],'wire '+t[:-20]+str(f)+'_readdata_valid_ip'+str(i)+';'+"\n")

		        elif(t=='i_clk_sys'):
				for f in range(int(NUMTXLANE[i])):
					writetofile(vars()['avst%s'%i],'wire '+t[:-1]+str(f)+';'+"\n")		
			else:
				writetofile(vars()['avst%s'%i],'wire '+t[:-1]+str(i)+';'+"\n")
		for e in reg_avst_width:
			if(e=='tx_data_ip0' or e=='rx_data_ip0'):
				writetofile(vars()['avst%s'%i],'reg '+'['+str(widths_avst[SPEED[i]])+':0] '+e[:-1]+str(i)+';'+"\n")
			elif(e=='tx_empty_ip0' or e=='rx_empty_ip0'):
				writetofile(vars()['avst%s'%i],'reg '+'['+str(widths_avst_empty[SPEED[i]])+':0] '+e[:-1]+str(i)+';'+"\n")
			elif(e=='xcvr_mode_ip0'):
				writetofile(vars()['avst%s'%i],'reg '+'['+str(1)+':0] '+e[:-1]+str(i)+';'+"\n")
			elif(e=='rx_error_ip0'):
				writetofile(vars()['avst%s'%i],'reg '+'['+str(5)+':0] '+e[:-1]+str(i)+';'+"\n")
			elif(e=='rx_status_data_ip0'):
				writetofile(vars()['avst%s'%i],'reg '+'['+str(39)+':0] '+e[:-1]+str(i)+';'+"\n")
			elif(e=='tx_serial_ip0' or e=='rx_serial_ip0' or e=='rx_serial_n_ip0'):
				writetofile(vars()['avst%s'%i],'reg '+'['+str(int(NUMTXLANE[i])-1)+':0] '+e[:-1]+str(i)+';'+"\n")
			elif(e=='tx_serial_n_ip0'or e=='tx_serial_pam4_ip0' or e=='tx_serial_pam4_n_ip0' or e=='rx_serial_pam4_ip0' or e=='rx_serial_pam4_n_ip0'):
				if(MODE[i] not in nrz):
					writetofile(vars()['avst%s'%i],'reg '+'['+str(int(NUMTXLANE[i])-1)+':0] '+e[:-1]+str(i)+';'+"\n")
			elif(e=='reconfig_eth_addr_ip0'):
				writetofile(vars()['avst%s'%i],'reg '+'['+str(19)+':0] '+e[:-1]+str(i)+';'+"\n")
			elif(e=='reconfig_eth_byteenable_ip0'):
				writetofile(vars()['avst%s'%i],'reg '+'['+str(3)+':0] '+e[:-1]+str(i)+';'+"\n")
			elif(e=='reconfig_eth_writedata_ip0'):
				writetofile(vars()['avst%s'%i],'reg '+'['+str(31)+':0] '+e[:-1]+str(i)+';'+"\n")
			elif(e=='rx_preamble_ip0' or e=='tx_preamble_ip0'):
				if((SPEED[i]=='40' or SPEED[i]=='50') and PP[i]=='1'):
					writetofile(vars()['avst%s'%i],'reg '+'['+str(63)+':0] '+e[:-1]+str(i)+';'+"\n")
			elif(e=='reconfig_xcvr0_address_ip0'):
				for f in range(int(NUMTXLANE[i])):
					writetofile(vars()['avst%s'%i],'reg '+'['+str(18)+':0] '+e[:-13]+str(f)+'_address_ip'+str(i)+';'+"\n")
			elif(e=='reconfig_xcvr0_byteenable_ip0'):
				for f in range(int(NUMTXLANE[i])):
					writetofile(vars()['avst%s'%i],'reg '+'['+str(3)+':0] '+e[:-16]+str(f)+'_byteenable_ip'+str(i)+';'+"\n")
			elif(e=='reconfig_xcvr0_writedata_ip0'):
				for f in range(int(NUMTXLANE[i])):
					writetofile(vars()['avst%s'%i],'reg '+'['+str(31)+':0] '+e[:-15]+str(f)+'_writedata_ip'+str(i)+';'+"\n")
			elif(e=='reconfig_eth_mac_addr_ip0'):
				writetofile(vars()['avst%s'%i],'reg '+'['+str(19)+':0] '+e[:-1]+str(i)+';'+"\n")
			elif(e=='reconfig_eth_mac_byteenable_ip0'):
				writetofile(vars()['avst%s'%i],'reg '+'['+str(3)+':0] '+e[:-1]+str(i)+';'+"\n")
			elif(e=='reconfig_eth_mac_writedata_ip0'):
				writetofile(vars()['avst%s'%i],'reg '+'['+str(31)+':0] '+e[:-1]+str(i)+';'+"\n")
			elif(e=='reconfig_eth_rcfg_addr_ip0'):
				writetofile(vars()['avst%s'%i],'reg '+'['+str(19)+':0] '+e[:-1]+str(i)+';'+"\n")
			elif(e=='reconfig_eth_rcfg_byteenable_ip0'):
				writetofile(vars()['avst%s'%i],'reg '+'['+str(3)+':0] '+e[:-1]+str(i)+';'+"\n")
			elif(e=='reconfig_eth_rcfg_writedata_ip0'):
				writetofile(vars()['avst%s'%i],'reg '+'['+str(31)+':0] '+e[:-1]+str(i)+';'+"\n")
		for z in wire_avst_width:
			if(z=='reconfig_eth_readdata_ip0'):
				writetofile(vars()['avst%s'%i],'wire '+'['+str(31)+':0] '+z[:-1]+str(i)+';'+"\n")
			elif(z=='xcvrif_txfifo_pfull' or z=='xcvrif_txfifo_pempty' or z=='xcvrif_txfifo_empty' or z=='xcvrif_hold_interrupt'):
				if(SYSPLL[i]=='3'):
					writetofile(vars()['avst%s'%i],'wire '+'['+str(widths_txmac_macseg[SPEED[i]])+':0] '+z+';'+"\n")
			elif(z=='reconfig_xcvr0_readdata_ip0'):
				for f in range(int(NUMTXLANE[i])):
					writetofile(vars()['avst%s'%i],'wire '+'['+str(31)+':0] '+z[:-14]+str(f)+'_readdata_ip'+str(i)+';'+"\n")
			elif(z=='reconfig_eth_mac_readdata_ip0'):
				writetofile(vars()['avst%s'%i],'wire '+'['+str(31)+':0] '+z[:-1]+str(i)+';'+"\n")
			elif(z=='reconfig_eth_rcfg_readdata_ip0'):
				writetofile(vars()['avst%s'%i],'wire '+'['+str(31)+':0] '+z[:-1]+str(i)+';'+"\n")
	elif(INTERFACE[i]=='0'):
		vars()['macseg%s' %i] = open(env_var+"/gdr_gen_qhip_files/gdr_macseg_ip%s.sv"%i,"w+")
		for x in typedef_macseg:
			#NOTE: This part is unused. No typedef for seg
			if(x=='seg_tx'):
				if(PTP[i] == '0'):
					writetofile(vars()['macseg%s'%i],'typedef '+'virtual client_tx_if#(.NUM_WORDS('+str(int(widths_txmac_macseg[SPEED[i]])+1) +')) %s'%x+';'+"\n")
				else:
					if(FP_WIDTH[i]==None):
						writetofile(vars()['macseg%s'%i],'typedef '+'virtual client_tx_if#(.NUM_WORDS('+str(int(widths_txmac_macseg[SPEED[i]])+1)+ ',.FP_WIDTH(32)' + ')) %s'%x+';'+"\n")
					else:
						writetofile(vars()['macseg%s'%i],'typedef '+'virtual client_tx_if#(.NUM_WORDS('+str(int(widths_txmac_macseg[SPEED[i]])+1)+ ',' + str(int(FP_WIDTH[i])) + ')) %s'%x+';'+"\n")
			elif(x=='seg_rx'):
				if(PTP[i] == '0'):
					writetofile(vars()['macseg%s'%i],'typedef '+'virtual client_rx_if#(.NUM_WORDS('+str(int(widths_txmac_macseg[SPEED[i]])+1) +')) %s'%x+';'+"\n")
				else:
					if(FP_WIDTH[i]==None):
						writetofile(vars()['macseg%s'%i],'typedef '+'virtual client_rx_if#(.NUM_WORDS('+str(int(widths_txmac_macseg[SPEED[i]])+1)+ ',.FP_WIDTH(32)' + ')) %s'%x+';'+"\n")
					else:
						writetofile(vars()['macseg%s'%i],'typedef '+'virtual client_rx_if#(.NUM_WORDS('+str(int(widths_txmac_macseg[SPEED[i]])+1)+ ',' + str(int(FP_WIDTH[i])) + ')) %s'%x+';'+"\n")
		for q in logic_macseg:
			if(q=='reset_ip0'or q=='reconfig_reset_ip0'):
				writetofile(vars()['macseg%s'%i],'logic '+q[:-1]+str(i)+';'+"\n")
			elif(q=='clk_ref_ip0' or q=='clk_sys_ip0' or  q=='clk_status_ip0' ):
				writetofile(vars()['macseg%s'%i],'logic '+q[:-1]+str(i)+'=0'+';'+"\n")
		for y in reg_macseg:
			if(y=='reconfig_xcvr0_read_ip0'):
				for f in range(int(NUMTXLANE[i])):
					writetofile(vars()['macseg%s'%i],'reg '+y[:-10]+str(f)+'_read_ip'+str(i)+';'+"\n")
			elif(y=='reconfig_xcvr0_write_ip0'):
				for f in range(int(NUMTXLANE[i])):
					writetofile(vars()['macseg%s'%i],'reg '+y[:-11]+str(f)+'_write_ip'+str(i)+';'+"\n")
			else:
				writetofile(vars()['macseg%s'%i],'reg '+y[:-1]+str(i)+';'+"\n")
		for z in wire_macseg:
			if(z=='reconfig_xcvr0_waitrequest_ip0'):
				for f in range(int(NUMTXLANE[i])):
					writetofile(vars()['macseg%s'%i],'wire '+z[:-17]+str(f)+'_waitrequest_ip'+str(i)+';'+"\n")
			elif(z=='reconfig_xcvr0_readdata_valid_ip0'):
				for f in range(int(NUMTXLANE[i])):
					writetofile(vars()['macseg%s'%i],'wire '+z[:-20]+str(f)+'_readdata_valid_ip'+str(i)+';'+"\n")
		        elif(z=='i_clk_sys'):
				for f in range(int(NUMTXLANE[i])):
					writetofile(vars()['macseg%s'%i],'wire '+z[:-1]+str(f)+';'+"\n")		
			else:
				writetofile(vars()['macseg%s'%i],'wire '+z[:-1]+str(i)+';'+"\n")
		for u in wire_macseg_width:
			if(u=='reconfig_eth_readdata_ip0'):
				writetofile(vars()['macseg%s'%i],'wire '+'['+str(31)+':0] '+u[:-1]+str(i)+';'+"\n")
			elif(z=='reconfig_eth_mac_readdata_ip0'):
				writetofile(vars()['macseg%s'%i],'wire '+'['+str(31)+':0] '+z[:-1]+str(i)+';'+"\n")
			elif(z=='reconfig_eth_rcfg_readdata_ip0'):
				writetofile(vars()['macseg%s'%i],'wire '+'['+str(31)+':0] '+z[:-1]+str(i)+';'+"\n")

			elif(u=='xcvrif_txfifo_pfull' or u=='xcvrif_txfifo_pempty' or u=='xcvrif_txfifo_empty' or u=='xcvrif_hold_interrupt'):
				if(SYSPLL[i]=='3'):
					writetofile(vars()['macseg%s'%i],'wire '+'['+str(widths_txmac_macseg[SPEED[i]])+':0] '+u+';'+"\n")
			elif(u=='reconfig_xcvr0_readdata_ip0'):
				for f in range(int(NUMTXLANE[i])):
					writetofile(vars()['macseg%s'%i],'wire '+'['+str(31)+':0] '+u[:-14]+str(f)+'_readdata_ip'+str(i)+';'+"\n")
		for e in reg_macseg_width:
			if(e=='rx_status_data_ip0'):
				writetofile(vars()['macseg%s'%i],'reg '+'['+str(39)+':0] '+e[:-1]+str(i)+';'+"\n")
			elif(e=='tx_serial_ip0' or e=='rx_serial_ip0'or e=='rx_serial_n_ip0'):
				writetofile(vars()['macseg%s'%i],'reg '+'['+str(int(NUMTXLANE[i])-1)+':0] '+e[:-1]+str(i)+';'+"\n")
			elif(e=='tx_serial_n_ip0'or e=='tx_serial_pam4_ip0' or e=='tx_serial_pam4_n_ip0' or e=='rx_serial_pam4_ip0' or e=='rx_serial_pam4_n_ip0'):
				if(MODE[i] not in nrz):
					writetofile(vars()['macseg%s'%i],'reg '+'['+str(int(NUMTXLANE[i])-1)+':0] '+e[:-1]+str(i)+';'+"\n")
			elif(e=='reconfig_eth_addr_ip0'):
				writetofile(vars()['macseg%s'%i],'reg '+'['+str(19)+':0] '+e[:-1]+str(i)+';'+"\n")
			elif(e=='reconfig_eth_byteenable_ip0'):
				writetofile(vars()['macseg%s'%i],'reg '+'['+str(3)+':0] '+e[:-1]+str(i)+';'+"\n")
			elif(e=='reconfig_eth_writedata_ip0'):
				writetofile(vars()['macseg%s'%i],'reg '+'['+str(31)+':0] '+e[:-1]+str(i)+';'+"\n")
			elif(e=='reconfig_xcvr0_address_ip0'):
				for f in range(int(NUMTXLANE[i])):
					writetofile(vars()['macseg%s'%i],'reg '+'['+str(19)+':0] '+e[:-13]+str(f)+'_address_ip'+str(i)+';'+"\n")
			elif(e=='reconfig_xcvr0_byteenable_ip0'):
				for f in range(int(NUMTXLANE[i])):
					writetofile(vars()['macseg%s'%i],'reg '+'['+str(3)+':0] '+e[:-16]+str(f)+'_byteenable_ip'+str(i)+';'+"\n")
			elif(e=='reconfig_xcvr0_writedata_ip0'):
				for f in range(int(NUMTXLANE[i])):
					writetofile(vars()['macseg%s'%i],'reg '+'['+str(31)+':0] '+e[:-15]+str(f)+'_writedata_ip'+str(i)+';'+"\n")			
                        elif(e=='reconfig_eth_mac_addr_ip0'):
				writetofile(vars()['macseg%s'%i],'reg '+'['+str(19)+':0] '+e[:-1]+str(i)+';'+"\n")
			elif(e=='reconfig_eth_mac_byteenable_ip0'):
				writetofile(vars()['macseg%s'%i],'reg '+'['+str(3)+':0] '+e[:-1]+str(i)+';'+"\n")
			elif(e=='reconfig_eth_mac_writedata_ip0'):
				writetofile(vars()['macseg%s'%i],'reg '+'['+str(31)+':0] '+e[:-1]+str(i)+';'+"\n")
			elif(e=='reconfig_eth_rcfg_addr_ip0'):
				writetofile(vars()['macseg%s'%i],'reg '+'['+str(19)+':0] '+e[:-1]+str(i)+';'+"\n")
			elif(e=='reconfig_eth_rcfg_byteenable_ip0'):
				writetofile(vars()['macseg%s'%i],'reg '+'['+str(3)+':0] '+e[:-1]+str(i)+';'+"\n")
			elif(e=='reconfig_eth_rcfg_writedata_ip0'):
				writetofile(vars()['avst%s'%i],'reg '+'['+str(31)+':0] '+e[:-1]+str(i)+';'+"\n")

		for w in logic_macseg_width:
			if(w=='tx_mac_data_ip0' or w=='rx_mac_data_ip0'):
				writetofile(vars()['macseg%s'%i],'logic '+'['+str(widths_macseg[SPEED[i]])+':0] '+w[:-1]+str(i)+';'+"\n")
			elif(w=='tx_mac_inframe_ip0' or w =='rx_mac_inframe_ip0' or w=='tx_mac_error_ip0' or w=='rx_mac_fcs_error_ip0'):
				writetofile(vars()['macseg%s'%i],'logic '+'['+str(widths_txmac_macseg[SPEED[i]])+':0] '+w[:-1]+str(i)+';'+"\n")
			elif(w=='tx_mac_eop_empty_ip0' or w=='rx_mac_eop_empty_ip0' or w=='rx_mac_status_ip0'):
				writetofile(vars()['macseg%s'%i],'logic '+'['+str(int((int(widths_macseg[SPEED[i]])+1)*3/64)-1)+':0] '+w[:-1]+str(i)+';'+"\n")
			elif(w=='rx_mac_error_ip0'):
				writetofile(vars()['macseg%s'%i],'logic '+'['+str(int((int(widths_macseg[SPEED[i]])+1)/32)-1)+':0] '+w[:-1]+str(i)+';'+"\n")
			elif(w=='tx_mac_skip_crc_ip0'):
				writetofile(vars()['macseg%s'%i],'logic '+'[15:0] '+w[:-1]+str(i)+';'+"\n")
	elif(INTERFACE[i]=='2'):
		vars()['pcs_only_%s' %i] = open(env_var+"/gdr_gen_qhip_files/gdr_pcs_only_ip%s.sv"%i,"w+")
                for q in logic_pcsonly:
			#if(q=='reset_ip0'or q=='reconfig_reset_ip0'):
				#writetofile(vars()['pcs_only_%s'%i],'logic '+q[:-1]+str(i)+';'+"\n")
			if(q=='clk_ref_ip0' or q=='clk_sys_ip0' or  q=='clk_status_ip0' ):
				writetofile(vars()['pcs_only_%s'%i],'logic '+q[:-1]+str(i)+'=0'+';'+"\n")
			#elif(q=='tx_mii_valid_ip0' or q=='tx_mii_am_ip0' or  q=='tx_mii_ready_ip0' ):
				#writetofile(vars()['pcs_only_%s'%i],'logic '+q[:-1]+str(i)+'=0'+';'+"\n")
			#elif(q=='rx_mii_valid_ip0' or q=='rx_mii_am_valid_ip0' or  q=='rx_am_lock_ip0' or 'rx_block_lock_ip0' ):
				#writetofile(vars()['pcs_only_%s'%i],'logic '+q[:-1]+str(i)+'=0'+';'+"\n")
			else:
				writetofile(vars()['pcs_only_%s'%i],'logic '+q[:-1]+str(i)+';'+"\n")
		for y in reg_pcsonly:
			if(y=='reconfig_xcvr0_read_ip0'):
				for f in range(int(NUMTXLANE[i])):
					writetofile(vars()['pcs_only_%s'%i],'reg '+y[:-10]+str(f)+'_read_ip'+str(i)+';'+"\n")
			elif(y=='reconfig_xcvr0_write_ip0'):
				for f in range(int(NUMTXLANE[i])):
					writetofile(vars()['pcs_only_%s'%i],'reg '+y[:-11]+str(f)+'_write_ip'+str(i)+';'+"\n")
			else:
				writetofile(vars()['pcs_only_%s'%i],'reg '+y[:-1]+str(i)+';'+"\n")
		for z in wire_pcsonly:
			if(z=='reconfig_xcvr0_waitrequest_ip0'):
				for f in range(int(NUMTXLANE[i])):
					writetofile(vars()['pcs_only_%s'%i],'wire '+z[:-17]+str(f)+'_waitrequest_ip'+str(i)+';'+"\n")
			elif(z=='reconfig_xcvr0_readdata_valid_ip0'):
				for f in range(int(NUMTXLANE[i])):
					writetofile(vars()['pcs_only_%s'%i],'wire '+z[:-20]+str(f)+'_readdata_valid_ip'+str(i)+';'+"\n")
		        elif(z=='i_clk_sys'):
				for f in range(int(NUMTXLANE[i])):
					writetofile(vars()['pcs_only_%s'%i],'wire '+z[:-1]+str(f)+';'+"\n")		
			else:
				writetofile(vars()['pcs_only_%s'%i],'wire '+z[:-1]+str(i)+';'+"\n")
		for u in wire_pcsonly_width:
			if(u=='reconfig_eth_readdata_ip0'):
				writetofile(vars()['pcs_only_%s'%i],'wire '+'['+str(31)+':0] '+u[:-1]+str(i)+';'+"\n")
			elif(z=='reconfig_eth_mac_readdata_ip0'):
				writetofile(vars()['pcs_only_%s'%i],'wire '+'['+str(31)+':0] '+z[:-1]+str(i)+';'+"\n")
			elif(z=='reconfig_eth_rcfg_readdata_ip0'):
				writetofile(vars()['pcs_only_%s'%i],'wire '+'['+str(31)+':0] '+z[:-1]+str(i)+';'+"\n")

			elif(u=='reconfig_xcvr0_readdata_ip0'):
				for f in range(int(NUMTXLANE[i])):
					writetofile(vars()['pcs_only_%s'%i],'wire '+'['+str(31)+':0] '+u[:-14]+str(f)+'_readdata_ip'+str(i)+';'+"\n")
		for e in reg_pcsonly_width:
			if(e=='reconfig_eth_addr_ip0'):
				writetofile(vars()['pcs_only_%s'%i],'reg '+'['+str(19)+':0] '+e[:-1]+str(i)+';'+"\n")
			elif(e=='reconfig_eth_byteenable_ip0'):
				writetofile(vars()['pcs_only_%s'%i],'reg '+'['+str(3)+':0] '+e[:-1]+str(i)+';'+"\n")
			elif(e=='reconfig_eth_writedata_ip0'):
				writetofile(vars()['pcs_only_%s'%i],'reg '+'['+str(31)+':0] '+e[:-1]+str(i)+';'+"\n")
			elif(e=='reconfig_xcvr0_address_ip0'):
				for f in range(int(NUMTXLANE[i])):
					writetofile(vars()['pcs_only_%s'%i],'reg '+'['+str(19)+':0] '+e[:-13]+str(f)+'_address_ip'+str(i)+';'+"\n")
			elif(e=='reconfig_xcvr0_byteenable_ip0'):
				for f in range(int(NUMTXLANE[i])):
					writetofile(vars()['pcs_only_%s'%i],'reg '+'['+str(3)+':0] '+e[:-16]+str(f)+'_byteenable_ip'+str(i)+';'+"\n")
			elif(e=='reconfig_xcvr0_writedata_ip0'):
				for f in range(int(NUMTXLANE[i])):
					writetofile(vars()['pcs_only_%s'%i],'reg '+'['+str(31)+':0] '+e[:-15]+str(f)+'_writedata_ip'+str(i)+';'+"\n")
                        elif(e=='reconfig_eth_mac_addr_ip0'):
				writetofile(vars()['pcs_only_%s'%i],'reg '+'['+str(19)+':0] '+e[:-1]+str(i)+';'+"\n")
			elif(e=='reconfig_eth_mac_byteenable_ip0'):
				writetofile(vars()['pcs_only_%s'%i],'reg '+'['+str(3)+':0] '+e[:-1]+str(i)+';'+"\n")
			elif(e=='reconfig_eth_mac_writedata_ip0'):
				writetofile(vars()['pcs_only_%s'%i],'reg '+'['+str(31)+':0] '+e[:-1]+str(i)+';'+"\n")
			elif(e=='reconfig_eth_rcfg_addr_ip0'):
				writetofile(vars()['pcs_only_%s'%i],'reg '+'['+str(19)+':0] '+e[:-1]+str(i)+';'+"\n")
			elif(e=='reconfig_eth_rcfg_byteenable_ip0'):
				writetofile(vars()['pcs_only_%s'%i],'reg '+'['+str(3)+':0] '+e[:-1]+str(i)+';'+"\n")
			elif(e=='reconfig_eth_rcfg_writedata_ip0'):
				writetofile(vars()['avst%s'%i],'reg '+'['+str(31)+':0] '+e[:-1]+str(i)+';'+"\n")



		for w in logic_pcsonly_width:
			if(w=='tx_mii_d_ip0' or w=='rx_mii_d_ip0' or w=='dut_mii_tx_data_ip0' or w=='dut_mii_rx_data_ip0'):
				writetofile(vars()['pcs_only_%s'%i],'logic '+'['+str(1023)+':0] '+w[:-1]+str(i)+';'+"\n")
			if(w=='tx_mii_c_ip0' or w=='rx_mii_c_ip0' or w=='dut_mii_tx_ctrl_ip0' or w=='dut_mii_rx_ctrl_ip0'):
				writetofile(vars()['pcs_only_%s'%i],'logic '+'['+str(127)+':0] '+w[:-1]+str(i)+';'+"\n")
	elif(INTERFACE[i]=='3' or INTERFACE[i]=='4'):
		vars()['otn_flexe_%s' %i] = open(env_var+"/gdr_gen_qhip_files/gdr_otn_flexe_ip%s.sv"%i,"w+")
		for q in logic_otnflexe:
			if(q=='clk_ref_ip0' or q=='clk_sys_ip0' or q=='clk_status_ip0' or q=='buffer_rx_valid_ip0' or q=='i_pop_ip0' ):
				writetofile(vars()['otn_flexe_%s'%i],'logic '+q[:-1]+str(i)+'=0'+';'+"\n")		
			elif(q=='gearbox_rx_valid_ip0'):
				writetofile(vars()['otn_flexe_%s'%i],'logic '+q[:-1]+str(i)+';'+"\n")	
			elif(q=='gearbox_tx_reset_a_ip0'):
				writetofile(vars()['otn_flexe_%s'%i],'logic '+q[:-1]+str(i)+';'+"\n")	
			elif(q=='cfg_half_width_ip0'):
				writetofile(vars()['otn_flexe_%s'%i],'logic '+q[:-1]+str(i)+';'+"\n")	
			else:
				writetofile(vars()['otn_flexe_%s'%i],'logic '+q[:-1]+str(i)+';'+"\n")
		for w in reg_otnflexe:
			if(w=='reconfig_xcvr0_read_ip0'):
				for f in range(int(NUMTXLANE[i])):
					writetofile(vars()['otn_flexe_%s'%i],'reg '+w[:-10]+str(f)+'_read_ip'+str(i)+';'+"\n")
			elif(w=='reconfig_xcvr0_write_ip0'):
				for f in range(int(NUMTXLANE[i])):
					writetofile(vars()['otn_flexe_%s'%i],'reg '+w[:-11]+str(f)+'_write_ip'+str(i)+';'+"\n")
			else:
				writetofile(vars()['otn_flexe_%s'%i],'reg '+w[:-1]+str(i)+';'+"\n")
		for t in wire_otnflexe:
			if(t=='reconfig_xcvr0_waitrequest_ip0'):
				for f in range(int(NUMTXLANE[i])):
					writetofile(vars()['otn_flexe_%s'%i],'wire '+t[:-17]+str(f)+'_waitrequest_ip'+str(i)+';'+"\n")
			elif(t=='reconfig_xcvr0_readdata_valid_ip0'):
				for f in range(int(NUMTXLANE[i])):
					writetofile(vars()['otn_flexe_%s'%i],'wire '+t[:-20]+str(f)+'_readdata_valid_ip'+str(i)+';'+"\n")
		        elif(t=='i_clk_sys'):
				for f in range(int(NUMTXLANE[i])):
					writetofile(vars()['otn_flexe_%s'%i],'wire '+t[:-1]+str(f)+';'+"\n")		
			else:
				writetofile(vars()['otn_flexe_%s'%i],'wire '+t[:-1]+str(i)+';'+"\n")
		for e in reg_otnflexe_width:
			if(e=='reconfig_eth_addr_ip0'):
				writetofile(vars()['otn_flexe_%s'%i],'reg '+'['+str(19)+':0] '+e[:-1]+str(i)+';'+"\n")
			elif(e=='reconfig_eth_byteenable_ip0'):
				writetofile(vars()['otn_flexe_%s'%i],'reg '+'['+str(3)+':0] '+e[:-1]+str(i)+';'+"\n")
			elif(e=='reconfig_eth_writedata_ip0'):
				writetofile(vars()['otn_flexe_%s'%i],'reg '+'['+str(31)+':0] '+e[:-1]+str(i)+';'+"\n")
			elif(e=='reconfig_xcvr0_address_ip0'):
				for f in range(int(NUMTXLANE[i])):
					writetofile(vars()['otn_flexe_%s'%i],'reg '+'['+str(18)+':0] '+e[:-13]+str(f)+'_address_ip'+str(i)+';'+"\n")
			elif(e=='reconfig_xcvr0_byteenable_ip0'):
				for f in range(int(NUMTXLANE[i])):
					writetofile(vars()['otn_flexe_%s'%i],'reg '+'['+str(3)+':0] '+e[:-16]+str(f)+'_byteenable_ip'+str(i)+';'+"\n")
			elif(e=='reconfig_xcvr0_writedata_ip0'):
				for f in range(int(NUMTXLANE[i])):
					writetofile(vars()['otn_flexe_%s'%i],'reg '+'['+str(31)+':0] '+e[:-15]+str(f)+'_writedata_ip'+str(i)+';'+"\n")
			elif(e=='tx_serial_ip0' or e=='rx_serial_ip0' or e=='rx_serial_n_ip0'):
				writetofile(vars()['otn_flexe_%s'%i],'reg '+'['+str(int(NUMTXLANE[i])-1)+':0] '+e[:-1]+str(i)+';'+"\n")
			elif(e=='tx_serial_n_ip0'or e=='tx_serial_pam4_ip0' or e=='tx_serial_pam4_n_ip0' or e=='rx_serial_pam4_ip0' or e=='rx_serial_pam4_n_ip0'):
				if(MODE[i] not in nrz):
					writetofile(vars()['otn_flexe_%s'%i],'reg '+'['+str(int(NUMTXLANE[i])-1)+':0] '+e[:-1]+str(i)+';'+"\n")
		for z in wire_otnflexe_width:
			if(z=='reconfig_eth_readdata_ip0'):
				writetofile(vars()['otn_flexe_%s'%i],'wire '+'['+str(31)+':0] '+z[:-1]+str(i)+';'+"\n")
			elif(z=='reconfig_eth_mac_readdata_ip0'):
				writetofile(vars()['otn_flexe_%s'%i],'wire '+'['+str(31)+':0] '+z[:-1]+str(i)+';'+"\n")
			elif(z=='reconfig_eth_rcfg_readdata_ip0'):
				writetofile(vars()['otn_flexe_%s'%i],'wire '+'['+str(31)+':0] '+z[:-1]+str(i)+';'+"\n")

			elif(z=='reconfig_xcvr0_readdata_ip0'):
				for f in range(int(NUMTXLANE[i])):
					writetofile(vars()['otn_flexe_%s'%i],'wire '+'['+str(31)+':0] '+z[:-14]+str(f)+'_readdata_ip'+str(i)+';'+"\n")
		for w in logic_otnflexe_width:
			if(w=='pcs66_tx_data_ip0' or w=='pcs66_rx_data_ip0' or w=='o_avst_data_tagger_in_ip0' or w=='gearbox_rx_data_ip0' or w=='buffer_rx_data_ip0'):
				writetofile(vars()['otn_flexe_%s'%i],'logic '+'['+str(widths_otnflexe[SPEED[i]])+':0] '+w[:-1]+str(i)+';'+"\n")
			elif(w=='rxdata_queue_ip0[$]'):
				writetofile(vars()['otn_flexe_%s'%i],'logic '+'['+str(widths_otnflexe[SPEED[i]])+':0] rxdata_queue_ip'+str(i)+'[$];'+"\n")
			elif(w=='pcs66_data_x4_ip0' or w=='o_avst_data_ip0' or w=='otn_am_insert_dout_ip0'):
				writetofile(vars()['otn_flexe_%s'%i],'logic [1055:0] '+w[:-1]+str(i)+';'+"\n")
			elif(w=='avst_latency_ip0'):
				writetofile(vars()['otn_flexe_%s'%i],'logic [5:0] '+w[:-1]+str(i)+';'+"\n")
			else:
				writetofile(vars()['otn_flexe_%s'%i],'logic '+w[:-1]+str(i)+';'+"\n")
	
flag =0
inst=str(len(SPEED))
print("inst= ", inst)
print("script_debug_gdr NUMTXLANE= ",NUMTXLANE)
for j in open("gdr_avst_template.sv","r"):
    #if(j[0:21] =='// end DUT port wires'):
    if('SM'in DEVICE_MODE):
        print("Entered flag SM= ",flag)
        if(j[0:24] =='// end SM DUT port wires'):
            flag=1
    #else:
    #    if(j[0:21] =='// end DUT port wires'):
    #    flag=1
    #    print("Entered flag= ",flag)
    if(flag):
        print("Entered flag")
        for i in range(len(SPEED)):
			if(INTERFACE[i]=='1'):
			        if(SPEED[i]=='25' and PTP[i] == '1' and inst=='16'):
                			NUMTXLANE[i]=4
				if(j=='   altera_avalon_mm_if #(`AVMM_XCVR_CFG_SHARED_INF_INST) avmm_xcvr_if_ip0_0 ('+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['avst%s'%i],'\n'+j[:-6]+str(i)+'_'+str(z+1)+' ('+'\n'+'	 		            .clk                       (clk_status_ip'+str(i)+'),'+'\n'+'	 		            .reset                     (reconfig_reset_ip'+str(i)+')'+'\n'+'               );'+'\n')
				if(j=='   altuvm_avalon_mm_rtb #(`AVMM_XCVR_CFG_SHARED_INF_INST,'+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						writetofile(vars()['avst%s'%i],'\n'+j+'           .IS_ACTIVE                 (UVM_ACTIVE),'+'\n'+'           .BFM_TYPE                  (altuvm_avalon_mm_pkg::AVALON_MM_MASTER)'+'\n'+'               ) avmm_xcvr_rtb_ip'+str(i)+'_'+str(z+1)+' (.uif(avmm_xcvr_if_ip'+str(i)+'_'+str(z+1)+'));'+'\n')
				if(j=='      uvm_config_db#(string)::set(uvm_root::get(),"*env_ip0","avmm_xcvr_rtb_path_0","avmm_xcvr_rtb_ip0_0");'+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
                                                writetofile(vars()['avst%s'%i],'\n'+'      uvm_config_db#(string)::set(uvm_root::get(),"*env_ip'+str(i)+'","avmm_xcvr_rtb_path_'+str(z+1)+'","avmm_xcvr_rtb_ip'+str(i)+'_'+str(z+1)+'");'+'\n')
#				if(j=="    assign reconfig_eth_addr_ip0         = {3'b0,avmm_if_ip0.address[17:2]};"+'\n'):
#                                          for z in range(int(NUMTXLANE[i])-1):
#                                                  writetofile(vars()['avst%s'%i],'\n'+"     assign reconfig_eth_addr_ip"+str(i)+"         = {3'b0,(avmm_if_ip"+str(i)+".address[17:2]-(("+str(i)+"%4)*2))};"+'\n')
                                if(j[0:15]=='// AVMM default'):
                                    if(DEVICE_MODE[i] == 'SM'):
                                        writetofile(vars()['avst%s'%i],'\n'+'altera_avalon_mm_if #(`AVMM_CFG_SHARED_INF_INST) avmm_if_mac_ip0 ('+'\n'+'	 		            .clk                       (reconfig_clk_ip'+str(i)+'),'+'\n'+'	 		            .reset                     (reconfig_reset_ip'+str(i)+')'+'\n'+'               );'+'\n')
                                        writetofile(vars()['avst%s'%i],'\n'+'altuvm_avalon_mm_rtb #(`AVMM_CFG_SHARED_INF_INST,'+'\n'+'          .IS_ACTIVE                 (UVM_ACTIVE),'+'\n'+'           .BFM_TYPE                  (altuvm_avalon_mm_pkg::AVALON_MM_MASTER)'+'\n'+'               ) avmm_mac_rtb_ip0'' (.uif(avmm_if_mac_ip0));'+'\n')
                                        writetofile(vars()['avst%s'%i],'\n'+'  initial begin'+'\n'+'     uvm_config_db#(string)::set(uvm_root::get(),"*env_ip0","avmm_mac_rtb_path","avmm_mac_rtb_ip0");'+'\n'+' end'+'\n')
				        writetofile(vars()['avst%s'%i],'\n'+'altera_avalon_mm_if #(`AVMM_CFG_SHARED_INF_INST) avmm_if_rcfg_ip0 ('+'\n'+'	 		            .clk                       (reconfig_clk_ip'+str(i)+'),'+'\n'+'	 		            .reset                     (reconfig_reset_ip'+str(i)+')'+'\n'+'               );'+'\n')
                                        writetofile(vars()['avst%s'%i],'\n'+'altuvm_avalon_mm_rtb #(`AVMM_CFG_SHARED_INF_INST,'+'\n'+'          .IS_ACTIVE                 (UVM_ACTIVE),'+'\n'+'           .BFM_TYPE                  (altuvm_avalon_mm_pkg::AVALON_MM_MASTER)'+'\n'+'               ) avmm_rcfg_rtb_ip0'' (.uif(avmm_if_rcfg_ip0));'+'\n')
                                        writetofile(vars()['avst%s'%i],'\n'+' initial begin'+'\n'+'      uvm_config_db#(string)::set(uvm_root::get(),"*env_ip0","avmm_rcfg_rtb_path","avmm_rcfg_rtb_ip0");'+'\n'+' end'+'\n')

                                if(j[0:11]=='// AVMM CSR'):
                                    if(DEVICE_MODE[i] == 'SM'):			
                                        writetofile(vars()['avst%s'%i],'\n'+'    assign reconfig_eth_mac_write_ip0           = avmm_if_mac_ip0.write;'+'\n')
			                writetofile(vars()['avst%s'%i],'\n'+'    assign reconfig_eth_mac_read_ip0           = avmm_if_mac_ip0.read;'+'\n')
			                writetofile(vars()['avst%s'%i],"\n"+"    assign reconfig_eth_mac_addr_ip0  "+"         = {3'b0,avmm_if_mac_ip0.address[17:2]};"+"\n")
			                writetofile(vars()['avst%s'%i],'\n'+'    assign reconfig_eth_mac_byteenable_ip0           = avmm_if_mac_ip0.byteenable;'+'\n')
			                writetofile(vars()['avst%s'%i],'\n'+'    assign reconfig_eth_mac_writedata_ip0           = avmm_if_mac_ip0.writedata;'+'\n')
			                writetofile(vars()['avst%s'%i],'\n'+'    assign  avmm_if_mac_ip0.readdata            = reconfig_eth_mac_readdata_ip0;'+'\n')
			                writetofile(vars()['avst%s'%i],'\n'+'    assign  avmm_if_mac_ip0.waitrequest             = reconfig_eth_mac_waitrequest_ip0;'+'\n')
			                writetofile(vars()['avst%s'%i],'\n'+'    assign  avmm_if_mac_ip0.readdatavalid            = ~reconfig_eth_mac_waitrequest_ip0;'+'\n')
			                writetofile(vars()['avst%s'%i],'\n'+'    assign reconfig_eth_rcfg_write_ip0           = avmm_if_rcfg_ip0.write;'+'\n')
			                writetofile(vars()['avst%s'%i],'\n'+'    assign reconfig_eth_rcfg_read_ip0           = avmm_if_rcfg_ip0.read;'+'\n')
			                writetofile(vars()['avst%s'%i],"\n"+"    assign reconfig_eth_rcfg_addr_ip0  "+"         = {3'b0,avmm_if_rcfg_ip0.address[17:2]};"+"\n")
			                writetofile(vars()['avst%s'%i],'\n'+'    assign reconfig_eth_rcfg_byteenable_ip0           = avmm_if_rcfg_ip0.byteenable;'+'\n')
			                writetofile(vars()['avst%s'%i],'\n'+'    assign reconfig_eth_rcfg_writedata_ip0           = avmm_if_rcfg_ip0.writedata;'+'\n')
			                writetofile(vars()['avst%s'%i],'\n'+'    assign  avmm_if_rcfg_ip0.readdata            = reconfig_eth_rcfg_readdata_ip0;'+'\n')
			                writetofile(vars()['avst%s'%i],'\n'+'    assign  avmm_if_rcfg_ip0.waitrequest             = reconfig_eth_rcfg_waitrequest_ip0;'+'\n')
			                writetofile(vars()['avst%s'%i],'\n'+'    assign  avmm_if_rcfg_ip0.readdatavalid            = ~reconfig_eth_rcfg_waitrequest_ip0;'+'\n')

                                if(j[0:10]=='// AVMM IF'):
                                    if(DEVICE_MODE[i] == 'SM'):
                                        writetofile(vars()['avst%s'%i],'\n'+'initial begin'+'\n'+' uvm_config_db #(virtual altera_avalon_mm_if#(`AVMM_CFG_SHARED_INF_INST))::set(null,"*env_ip0*","status_mac_if",avmm_if_mac_ip0);'+'\n'+'uvm_config_db #(virtual altera_avalon_mm_if#(`AVMM_CFG_SHARED_INF_INST))::set(null,"*env_ip0*","status_rcfg_if",avmm_if_rcfg_ip0);'+'\n'+' end '+'\n')

				if(j=='    assign reconfig_xcvr0_write_ip0           = avmm_xcvr_if_ip0_0.write;'+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						if(SPEED[i]=='25' and PTP[i] == '1' and inst=='16'):
							if i in range(12,16): 
								writetofile(vars()['avst%s'%i],'\n'+'    assign reconfig_xcvr0_write_ip'+str(i)+'           = avmm_xcvr_if_ip'+str(i)+'_3.write;'+'\n')
								break
							elif i in range(8,12):
								writetofile(vars()['avst%s'%i],'\n'+'    assign reconfig_xcvr0_write_ip'+str(i)+'           = avmm_xcvr_if_ip'+str(i)+'_2.write;'+'\n')
								break
							elif i in range(4,8):
								writetofile(vars()['avst%s'%i],'\n'+'    assign reconfig_xcvr0_write_ip'+str(i)+'           = avmm_xcvr_if_ip'+str(i)+'_1.write;'+'\n')
								break
							elif i in range(0,4):
								writetofile(vars()['avst%s'%i],'\n'+'    assign reconfig_xcvr0_write_ip'+str(i)+'           = avmm_xcvr_if_ip'+str(i)+'_0.write;'+'\n')
								break
						else:
							writetofile(vars()['avst%s'%i],'\n'+'    assign reconfig_xcvr'+str(z+1)+'_write_ip'+str(i)+'           = avmm_xcvr_if_ip'+str(i)+'_'+str(z+1)+'.write;'+'\n')
				if(j=='    assign reconfig_xcvr0_read_ip0            = avmm_xcvr_if_ip0_0.read;'+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						if(SPEED[i]=='25' and PTP[i] == '1' and inst=='16'):
							if i in range(12,16):
								writetofile(vars()['avst%s'%i],'\n'+'    assign reconfig_xcvr0_read_ip'+str(i)+'           = avmm_xcvr_if_ip'+str(i)+'_3.read;'+'\n')
								break
							elif i in range(8,12):
								writetofile(vars()['avst%s'%i],'\n'+'    assign reconfig_xcvr0_read_ip'+str(i)+'           = avmm_xcvr_if_ip'+str(i)+'_2.read;'+'\n')
								break
							elif i in range(4,8):
								writetofile(vars()['avst%s'%i],'\n'+'    assign reconfig_xcvr0_read_ip'+str(i)+'           = avmm_xcvr_if_ip'+str(i)+'_1.read;'+'\n')
								break
							elif i in range(0,4):
								writetofile(vars()['avst%s'%i],'\n'+'    assign reconfig_xcvr0_read_ip'+str(i)+'           = avmm_xcvr_if_ip'+str(i)+'_0.read;'+'\n')
								break
						else:
							writetofile(vars()['avst%s'%i],'\n'+'    assign reconfig_xcvr'+str(z+1)+'_read_ip'+str(i)+'           = avmm_xcvr_if_ip'+str(i)+'_'+str(z+1)+'.read;'+'\n')
				if(j=="    assign reconfig_xcvr0_address_ip0         = {2'b00,(avmm_xcvr_if_ip0_0.address[19:2])};"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
                                                  if(SPEED[i]=='25' and PTP[i] == '1' and inst=='16'):
                                                        if i in range(12,16):
							  	writetofile(vars()['avst%s'%i],'\n'+"     assign reconfig_xcvr"+str(0)+"_address_ip"+str(i)+"         = {2'b00,avmm_xcvr_if_ip"+str(i)+'_'+str(3)+".address[19:2]};"+'\n')
								break
                                                        elif i in range(8,12):
							  	writetofile(vars()['avst%s'%i],'\n'+"     assign reconfig_xcvr"+str(0)+"_address_ip"+str(i)+"         = {2'b00,avmm_xcvr_if_ip"+str(i)+'_'+str(2)+".address[19:2]};"+'\n')
								break
                                                        elif i in range(4,8):
							  	writetofile(vars()['avst%s'%i],'\n'+"     assign reconfig_xcvr"+str(0)+"_address_ip"+str(i)+"         = {2'b00,avmm_xcvr_if_ip"+str(i)+'_'+str(1)+".address[19:2]};"+'\n')
								break
							elif i in range(0,4):
							  	writetofile(vars()['avst%s'%i],'\n'+"     assign reconfig_xcvr"+str(0)+"_address_ip"+str(i)+"         = {2'b00,avmm_xcvr_if_ip"+str(i)+'_'+str(0)+".address[19:2]};"+'\n')
								break
                                                  else:
							  writetofile(vars()['avst%s'%i],'\n'+"     assign reconfig_xcvr"+str(z+1)+"_address_ip"+str(i)+"         = {2'b00,avmm_xcvr_if_ip"+str(i)+'_'+str(z+1)+".address[19:2]};"+'\n')
						  #writetofile(vars()['avst%s'%i],'\n'+"     assign reconfig_xcvr"+str(z+1)+"_address_ip"+str(i)+"         = {2'b00,(avmm_xcvr_if_ip"+str(i)+'_'+str(z+1)+".address[19:2]-(("+str(i)+"%4)*2))};"+'\n')
				if(j=="    assign reconfig_xcvr0_byteenable_ip0      = avmm_xcvr_if_ip0_0.byteenable;"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
                                                  if(SPEED[i]=='25' and PTP[i] == '1' and inst=='16'):
                                                        if i in range(12,16):
						  		writetofile(vars()['avst%s'%i],'\n'+"     assign reconfig_xcvr"+str(0)+"_byteenable_ip"+str(i)+"         = avmm_xcvr_if_ip"+str(i)+'_'+str(3)+".byteenable;"+'\n')
								break
                                                        elif i in range(8,16):
						  		writetofile(vars()['avst%s'%i],'\n'+"     assign reconfig_xcvr"+str(0)+"_byteenable_ip"+str(i)+"         = avmm_xcvr_if_ip"+str(i)+'_'+str(2)+".byteenable;"+'\n')
								break
                                                        elif i in range(4,8):
						  		writetofile(vars()['avst%s'%i],'\n'+"     assign reconfig_xcvr"+str(0)+"_byteenable_ip"+str(i)+"         = avmm_xcvr_if_ip"+str(i)+'_'+str(1)+".byteenable;"+'\n')
								break
							elif i in range(0,4):
						  		writetofile(vars()['avst%s'%i],'\n'+"     assign reconfig_xcvr"+str(0)+"_byteenable_ip"+str(i)+"         = avmm_xcvr_if_ip"+str(i)+'_'+str(0)+".byteenable;"+'\n')
								break
                                                  else:
						  	writetofile(vars()['avst%s'%i],'\n'+"     assign reconfig_xcvr"+str(z+1)+"_byteenable_ip"+str(i)+"         = avmm_xcvr_if_ip"+str(i)+'_'+str(z+1)+".byteenable;"+'\n')
				if(j=='    assign reconfig_xcvr0_writedata_ip0       = avmm_xcvr_if_ip0_0.writedata;'+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
                                                  if(SPEED[i]=='25' and PTP[i] == '1' and inst=='16'):
                                                        if i in range(12,16):
								writetofile(vars()['avst%s'%i],'\n'+'    assign reconfig_xcvr0_writedata_ip'+str(i)+'           = avmm_xcvr_if_ip'+str(i)+'_3.writedata;'+'\n')
								break
                                                        elif i in range(8,12):
								writetofile(vars()['avst%s'%i],'\n'+'    assign reconfig_xcvr0_writedata_ip'+str(i)+'           = avmm_xcvr_if_ip'+str(i)+'_2.writedata;'+'\n')
								break
                                                        elif i in range(4,8):
								writetofile(vars()['avst%s'%i],'\n'+'    assign reconfig_xcvr0_writedata_ip'+str(i)+'           = avmm_xcvr_if_ip'+str(i)+'_1.writedata;'+'\n')
								break
                                                        elif i in range(0,4):
								writetofile(vars()['avst%s'%i],'\n'+'    assign reconfig_xcvr0_writedata_ip'+str(i)+'           = avmm_xcvr_if_ip'+str(i)+'_0.writedata;'+'\n')
								break
                                                  else:
							writetofile(vars()['avst%s'%i],'\n'+'    assign reconfig_xcvr'+str(z+1)+'_writedata_ip'+str(i)+'           = avmm_xcvr_if_ip'+str(i)+'_'+str(z+1)+'.writedata;'+'\n')
				if(j=="    assign avmm_xcvr_if_ip0_0.readdata         = reconfig_xcvr0_readdata_ip0;"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  if(SPEED[i]=='25' and PTP[i] == '1' and inst=='16'):
							if i in range(12,16):
						  		writetofile(vars()['avst%s'%i],'\n'+"    assign avmm_xcvr_if_ip"+str(i)+"_"+str(3)+".readdata         = reconfig_xcvr0_readdata_ip"+str(i)+";"+'\n')
								break
							elif i in range(8,12):
						  		writetofile(vars()['avst%s'%i],'\n'+"    assign avmm_xcvr_if_ip"+str(i)+"_"+str(2)+".readdata         = reconfig_xcvr0_readdata_ip"+str(i)+";"+'\n')
								break
							elif i in range(4,8):
						  		writetofile(vars()['avst%s'%i],'\n'+"    assign avmm_xcvr_if_ip"+str(i)+"_"+str(1)+".readdata         = reconfig_xcvr0_readdata_ip"+str(i)+";"+'\n')
								break
							elif i in range(0,4):
						  		writetofile(vars()['avst%s'%i],'\n'+"    assign avmm_xcvr_if_ip"+str(i)+"_"+str(0)+".readdata         = reconfig_xcvr0_readdata_ip"+str(i)+";"+'\n')
								break
						  else:
						  	writetofile(vars()['avst%s'%i],'\n'+"    assign avmm_xcvr_if_ip"+str(i)+"_"+str(z+1)+".readdata         = reconfig_xcvr"+str(z+1)+"_readdata_ip"+str(i)+";"+'\n')
				if(j=="    assign avmm_xcvr_if_ip0_0.waitrequest      = reconfig_xcvr0_waitrequest_ip0;    "+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
                                                  if(SPEED[i]=='25' and PTP[i] == '1' and inst=='16'):
							if i in range(12,16):
					  			writetofile(vars()['avst%s'%i],'\n'+"    assign avmm_xcvr_if_ip"+str(i)+"_"+str(3)+".waitrequest         = reconfig_xcvr0_waitrequest_ip"+str(i)+";"+'\n')
                                                                break
                                                        elif i in range(8,12):
					  			writetofile(vars()['avst%s'%i],'\n'+"    assign avmm_xcvr_if_ip"+str(i)+"_"+str(2)+".waitrequest         = reconfig_xcvr0_waitrequest_ip"+str(i)+";"+'\n')
								break
							elif i in range(4,8):
					  			writetofile(vars()['avst%s'%i],'\n'+"    assign avmm_xcvr_if_ip"+str(i)+"_"+str(1)+".waitrequest         = reconfig_xcvr0_waitrequest_ip"+str(i)+";"+'\n')
								break
							elif i in range(0,4):
					  			writetofile(vars()['avst%s'%i],'\n'+"    assign avmm_xcvr_if_ip"+str(i)+"_"+str(0)+".waitrequest         = reconfig_xcvr0_waitrequest_ip"+str(i)+";"+'\n')
								break
						  else:
					  		writetofile(vars()['avst%s'%i],'\n'+"    assign avmm_xcvr_if_ip"+str(i)+"_"+str(z+1)+".waitrequest         = reconfig_xcvr"+str(z+1)+"_waitrequest_ip"+str(i)+";"+'\n')
				if(j=="    assign avmm_xcvr_if_ip0_0.readdatavalid    = reconfig_xcvr0_readdata_valid_ip0;"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
                                                  if(SPEED[i]=='25' and PTP[i] == '1' and inst=='16'):
                                                        if i in range(12,16):
						  		writetofile(vars()['avst%s'%i],'\n'+"    assign avmm_xcvr_if_ip"+str(i)+"_"+str(3)+".readdatavalid         = reconfig_xcvr0_readdata_valid_ip"+str(i)+";"+'\n')
								break
                                                        elif i in range(8,12):
						  		writetofile(vars()['avst%s'%i],'\n'+"    assign avmm_xcvr_if_ip"+str(i)+"_"+str(2)+".readdatavalid         = reconfig_xcvr0_readdata_valid_ip"+str(i)+";"+'\n')
								break
                                                        elif i in range(4,8):
						  		writetofile(vars()['avst%s'%i],'\n'+"    assign avmm_xcvr_if_ip"+str(i)+"_"+str(1)+".readdatavalid         = reconfig_xcvr0_readdata_valid_ip"+str(i)+";"+'\n')
								break
                                                        elif i in range(0,4):
						  		writetofile(vars()['avst%s'%i],'\n'+"    assign avmm_xcvr_if_ip"+str(i)+"_"+str(0)+".readdatavalid         = reconfig_xcvr0_readdata_valid_ip"+str(i)+";"+'\n')
								break
						  else:
						  	writetofile(vars()['avst%s'%i],'\n'+"    assign avmm_xcvr_if_ip"+str(i)+"_"+str(z+1)+".readdatavalid         = reconfig_xcvr"+str(z+1)+"_readdata_valid_ip"+str(i)+";"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_assertion.enable_a_no_readdatavalid_during_reset = 0;"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['avst%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_assertion.enable_a_no_readdatavalid_during_reset = 0;"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_assertion.enable_a_no_readdatavalid_during_reset = 1;"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['avst%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_assertion.enable_a_no_readdatavalid_during_reset = 1;"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_assertion.enable_a_waitrequest_during_reset = 0;"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['avst%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_assertion.enable_a_waitrequest_during_reset = 0;"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_read_byteenable(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['avst%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_read_byteenable(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_b2b_read_read(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['avst%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_b2b_read_read(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_b2b_read_write(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['avst%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_b2b_read_write(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_b2b_write_read(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['avst%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_b2b_write_read(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_b2b_write_write(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['avst%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_b2b_write_write(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_continuous_read(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['avst%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_continuous_read(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_continuous_readdatavalid(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['avst%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_continuous_readdatavalid(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_continuous_waitrequest(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['avst%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_continuous_waitrequest(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_continuous_waitrequest_from_idle_to_read(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['avst%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_continuous_waitrequest_from_idle_to_read(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_continuous_waitrequest_from_idle_to_write(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['avst%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_continuous_waitrequest_from_idle_to_write(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_continuous_write(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['avst%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_continuous_write(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_idle_before_transaction(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['avst%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_idle_before_transaction(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_read(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['avst%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_read(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_read_after_reset(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['avst%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_read_after_reset(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_read_latency(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['avst%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_read_latency(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_waitrequest_without_command(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['avst%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_waitrequest_without_command(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_waitrequested_read(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['avst%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_waitrequested_read(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_waitrequested_write(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['avst%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_waitrequested_write(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_write(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['avst%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_write(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_write_after_reset(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['avst%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_write_after_reset(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_write_byteenable(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['avst%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_write_byteenable(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_assertion.enable_a_half_cycle_reset_legal = 0;"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['avst%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_assertion.enable_a_half_cycle_reset_legal = 0;"+'\n')
				
				if(j==' assign clk_rx_ip0 = clk_pll_ip0;'+'\n'):
                                        print("ENASYNCAD value is",ENASYNCAD[i])
                                        if(ENASYNCAD[i]=='1'):
                                                  print("ENASYNCAD=1")
						  writetofile(vars()['avst%s'%i],'\n'+" assign clk_rx_ip"+str(i)+" = async_mac_clk_rx;"+'\n')
                                                  continue
				if(j==' assign clk_tx_ip0 = clk_pll_ip0;'+'\n'):
                                        print("ENASYNCAD value is",ENASYNCAD[i])
                                        if(ENASYNCAD[i]=='1'):
                                                  print("ENASYNCAD=1")
						  writetofile(vars()['avst%s'%i],'\n'+" assign clk_tx_ip"+str(i)+" = async_mac_clk_tx;"+'\n')
                                                  continue
				if(j=='    assign custom_cadence_ip0         = eth_sideband_if_ip0.custom_cadence;'+'\n'):
					if(SYSPLL[i]=='3' and CUSTOM_CADENCE_GUI[i]=='1'):
						writetofile(vars()['avst%s'%i],'\n'+'    assign custom_cadence_ip'+str(i)+'         = eth_sideband_if_ip'+str(i)+'.custom_cadence;')
						continue
					else:
						continue
				new_string = j.replace('ip2','ip%s'%i)
				new_string = new_string.replace('IP2','IP%s'%i)
				new_string = new_string.replace('ip1','ip%s'%i)
				new_string = new_string.replace('IP1','IP%s'%i)
				new_string = new_string.replace('ip0','ip%s'%i)
				if(single_var_multi_inst=='1'):
					new_string = new_string.replace('top_ip%s'%i,'top_ip0')
				new_string = new_string.replace('IP0','IP%s'%i)
				new_string = new_string.replace('ts_tasks_if[0]','ts_tasks_if[%s]'%i)
				new_string = new_string.replace('svt_ethernet_mon_chk_0','svt_ethernet_mon_chk_%s'%i)
				new_string = new_string.replace('svt_ethernet_txrx_if[0]','svt_ethernet_txrx_if[%s]'%i)
				new_string = new_string.replace('svt_ethernet_drv_0','svt_ethernet_drv_%s'%i)
				new_string = new_string.replace('assertion_on_off_reset[0]','assertion_on_off_reset[%s]'%i)
				new_string = new_string.replace('.ST_SYMBOL_W(ST_SYMBOL_W_25G)','.ST_SYMBOL_W(ST_SYMBOL_W_'+str(SPEED[i])+'G)')
				new_string = new_string.replace('`ALTUVM_AVALON_ST_INF_TB_PARAM_INST_25G','`ALTUVM_AVALON_ST_INF_TB_PARAM_INST_'+str(SPEED[i])+'G')
				new_string = new_string.replace('`ALTUVM_AVALON_ST_RTB_TB_PARAM_INST_25G','`ALTUVM_AVALON_ST_RTB_TB_PARAM_INST_'+str(SPEED[i])+'G')
				#new_string = new_string.replace('svt_ethernet_txrx_if['+str(i)+'].rx_lane[0:0]','svt_ethernet_txrx_if['+str(i)+'].rx_lane['+str(int(NUMTXLANE[i])-1)+':0]')
				#new_string = new_string.replace('svt_ethernet_txrx_if['+str(i)+'].tx_lane[0:0]','svt_ethernet_txrx_if['+str(i)+'].tx_lane['+str(int(NUMTXLANE[i])-1)+':0]')
				new_string = new_string.replace('*dut_25g_ip%s'%i,'*dut_'+str(SPEED[i])+'g_ip%s'%i)
				if((SPEED[i]=='40' or SPEED[i]=='50') and PP[i]=='1'):
					new_string = new_string.replace('//rx_preamble_stored_ip%s'%i,'rx_preamble_stored_ip%s'%i)
					new_string = new_string.replace(' //assign tx_preamble_ip%s'%i,'assign tx_preamble_ip%s'%i)
					new_string = new_string.replace('//assign eth_sideband_if_ip%s.mon_tx_preamble'%i,'assign eth_sideband_if_ip%s.mon_tx_preamble'%i)
					new_string = new_string.replace('//assign eth_sideband_if_ip%s.l2_rx_preamble'%i,'assign eth_sideband_if_ip%s.l2_rx_preamble'%i)
				if(SPEED[i]=='25' and PTP[i] == '1' and inst=='16'):
                                        new_string = new_string.replace('    assign reconfig_xcvr0_write_ip%s'%i,'//    assign reconfig_xcvr0_write_ip%s'%i)
                                        new_string = new_string.replace('    assign reconfig_xcvr0_read_ip%s'%i,'//    assign reconfig_xcvr0_read_ip%s'%i)
                                        new_string = new_string.replace('    assign reconfig_xcvr0_byteenable_ip%s'%i,'//    assign reconfig_xcvr0_byteenable_ip%s'%i)
                                        new_string = new_string.replace('    assign reconfig_xcvr0_address_ip%s'%i,'//    assign reconfig_xcvr0_address_ip%s'%i)
                                        new_string = new_string.replace('    assign reconfig_xcvr0_writedata_ip%s'%i,'//    assign reconfig_xcvr0_writedata_ip%s'%i)
                                        new_string = new_string.replace('    assign avmm_xcvr_if_ip%s_0.'%i,'//    assign avmm_xcvr_if_ip%s_0.'%i)
				writetofile(vars()['avst%s'%i],new_string)

speed_iter={'10':'1','25':'1','40':'2','50':'2','100':'4','200':'8','400':'16'}
flag_1 =0
print("script_debug_gdr NUMTXLANE 2 is",NUMTXLANE)
for j in open("gdr_seg_template.sv","r"):
	if(j[0:21] =='// end DUT port wires'):
		flag_1=1
	if(flag_1):
		for i in range(len(SPEED)):
			if(INTERFACE[i]=='0'):
				if(j=='   altera_avalon_mm_if #(`AVMM_XCVR_CFG_SHARED_INF_INST) avmm_xcvr_if_ip0_0 ('+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['macseg%s'%i],'\n'+j[:-6]+str(i)+'_'+str(z+1)+' ('+'\n'+'	 		            .clk                       (clk_status_ip'+str(i)+'),'+'\n'+'	 		            .reset                     (reconfig_reset_ip'+str(i)+')'+'\n'+'               );'+'\n')
				if(j=='   altuvm_avalon_mm_rtb #(`AVMM_XCVR_CFG_SHARED_INF_INST,'+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						writetofile(vars()['macseg%s'%i],'\n'+j+'           .IS_ACTIVE                 (UVM_ACTIVE),'+'\n'+'           .BFM_TYPE                  (altuvm_avalon_mm_pkg::AVALON_MM_MASTER)'+'\n'+'               ) avmm_xcvr_rtb_ip'+str(i)+'_'+str(z+1)+' (.uif(avmm_xcvr_if_ip'+str(i)+'_'+str(z+1)+'));'+'\n')
				if(j=='      uvm_config_db#(string)::set(uvm_root::get(),"*env_ip0","avmm_xcvr_rtb_path_0","avmm_xcvr_rtb_ip0_0");'+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['macseg%s'%i],'\n'+'      uvm_config_db#(string)::set(uvm_root::get(),"*env_ip'+str(i)+'","avmm_xcvr_rtb_path_'+str(z+1)+'","avmm_xcvr_rtb_ip'+str(i)+'_'+str(z+1)+'");'+'\n')
				if(j=='    assign reconfig_xcvr0_write_ip0           = avmm_xcvr_if_ip0_0.write;'+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['macseg%s'%i],'\n'+'    assign reconfig_xcvr'+str(z+1)+'_write_ip'+str(i)+'           = avmm_xcvr_if_ip'+str(i)+'_'+str(z+1)+'.write;'+'\n')
				if(j=='    assign reconfig_xcvr0_read_ip0            = avmm_xcvr_if_ip0_0.read;'+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						writetofile(vars()['macseg%s'%i],'\n'+'    assign reconfig_xcvr'+str(z+1)+'_read_ip'+str(i)+'           = avmm_xcvr_if_ip'+str(i)+'_'+str(z+1)+'.read;'+'\n')
				if(j=="    assign reconfig_xcvr0_address_ip0         =  {2'b00,avmm_xcvr_if_ip0_0.address[19:2]};"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['macseg%s'%i],'\n'+"     assign reconfig_xcvr"+str(z+1)+"_address_ip"+str(i)+"         = {2'b00,avmm_xcvr_if_ip"+str(i)+'_'+str(z+1)+".address[19:2]};"+'\n')
				if(j=="    assign reconfig_xcvr0_byteenable_ip0      = avmm_xcvr_if_ip0_0.byteenable;"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['macseg%s'%i],'\n'+"     assign reconfig_xcvr"+str(z+1)+"_byteenable_ip"+str(i)+"         = avmm_xcvr_if_ip"+str(i)+'_'+str(z+1)+".byteenable;"+'\n')
				if(j=='    assign reconfig_xcvr0_writedata_ip0       = avmm_xcvr_if_ip0_0.writedata;'+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						writetofile(vars()['macseg%s'%i],'\n'+'    assign reconfig_xcvr'+str(z+1)+'_writedata_ip'+str(i)+'           = avmm_xcvr_if_ip'+str(i)+'_'+str(z+1)+'.writedata;'+'\n')
				if(j=="    assign avmm_xcvr_if_ip0_0.readdata         = reconfig_xcvr0_readdata_ip0;"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['macseg%s'%i],'\n'+"    assign avmm_xcvr_if_ip"+str(i)+"_"+str(z+1)+".readdata         = reconfig_xcvr"+str(z+1)+"_readdata_ip"+str(i)+";"+'\n')
				if(j=="    assign avmm_xcvr_if_ip0_0.waitrequest      = reconfig_xcvr0_waitrequest_ip0;    "+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['macseg%s'%i],'\n'+"    assign avmm_xcvr_if_ip"+str(i)+"_"+str(z+1)+".waitrequest         = reconfig_xcvr"+str(z+1)+"_waitrequest_ip"+str(i)+";"+'\n')
				if(j=="    assign avmm_xcvr_if_ip0_0.readdatavalid     = reconfig_xcvr0_readdata_valid_ip0;"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['macseg%s'%i],'\n'+"    assign avmm_xcvr_if_ip"+str(i)+"_"+str(z+1)+".readdatavalid         = reconfig_xcvr"+str(z+1)+"_readdata_valid_ip"+str(i)+";"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_assertion.enable_a_no_readdatavalid_during_reset = 0;"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['macseg%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_assertion.enable_a_no_readdatavalid_during_reset = 0;"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_assertion.enable_a_waitrequest_during_reset = 0;"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['macseg%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_assertion.enable_a_waitrequest_during_reset = 0;"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_read_byteenable(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['macseg%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_read_byteenable(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_b2b_read_read(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['macseg%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_b2b_read_read(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_b2b_read_write(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['macseg%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_b2b_read_write(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_b2b_write_read(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['macseg%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_b2b_write_read(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_b2b_write_write(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['macseg%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_b2b_write_write(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_continuous_read(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['macseg%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_continuous_read(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_continuous_readdatavalid(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['macseg%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_continuous_readdatavalid(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_continuous_waitrequest(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['macseg%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_continuous_waitrequest(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_continuous_waitrequest_from_idle_to_read(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['macseg%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_continuous_waitrequest_from_idle_to_read(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_continuous_waitrequest_from_idle_to_write(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['macseg%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_continuous_waitrequest_from_idle_to_write(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_continuous_write(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['macseg%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_continuous_write(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_idle_before_transaction(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['macseg%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_idle_before_transaction(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_read(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['macseg%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_read(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_read_after_reset(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['macseg%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_read_after_reset(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_read_latency(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['macseg%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_read_latency(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_waitrequest_without_command(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['macseg%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_waitrequest_without_command(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_waitrequested_read(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['macseg%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_waitrequested_read(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_waitrequested_write(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['macseg%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_waitrequested_write(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_write(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['macseg%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_write(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_write_after_reset(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['macseg%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_write_after_reset(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_write_byteenable(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['macseg%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_write_byteenable(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_assertion.enable_a_half_cycle_reset_legal = 0;"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['macseg%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_assertion.enable_a_half_cycle_reset_legal = 0;"+'\n')
				
				if(j=='    assign custom_cadence_ip0         = eth_sideband_if_ip0.custom_cadence;'+'\n'):
					if(SYSPLL[i]=='3' and CUSTOM_CADENCE_GUI[i]=='1'):
						writetofile(vars()['macseg%s'%i],'\n'+'    assign custom_cadence_ip'+str(i)+'         = eth_sideband_if_ip'+str(i)+'.custom_cadence;')
					else:
						continue
				new_string_1 = j.replace('ip0','ip%s'%i)
				new_string_1 = new_string_1.replace('IP0','IP%s'%i)
				new_string_1 = new_string_1.replace('ip1','ip%s'%i)
				new_string_1 = new_string_1.replace('IP1','IP%s'%i)
				new_string_1 = new_string_1.replace('ip2','ip%s'%i)
				new_string_1 = new_string_1.replace('IP2','IP%s'%i)
				if(PTP[i] == '0'):
					new_string_1 = new_string_1.replace('client_tx_if#(.NUM_WORDS(16))','client_tx_if#(.NUM_WORDS(%s))'%str(int(widths_txmac_macseg[SPEED[i]])+1))
					new_string_1 = new_string_1.replace('client_rx_if#(.NUM_WORDS(16))','client_rx_if#(.NUM_WORDS(%s))'%str(int(widths_txmac_macseg[SPEED[i]])+1))
				else:
					if(FP_WIDTH[i]==None):
						new_string_1 = new_string_1.replace('client_tx_if#(.NUM_WORDS(16))','client_tx_if#(.NUM_WORDS(%s),'%str(int(widths_txmac_macseg[SPEED[i]])+1)+'.FP_WIDTH(32))')
						new_string_1 = new_string_1.replace('client_rx_if#(.NUM_WORDS(16))','client_rx_if#(.NUM_WORDS(%s),'%str(int(widths_txmac_macseg[SPEED[i]])+1)+'.FP_WIDTH(32))')
					else:
						new_string_1 = new_string_1.replace('client_tx_if#(.NUM_WORDS(16))','client_tx_if#(.NUM_WORDS(%s),'%str(int(widths_txmac_macseg[SPEED[i]])+1)+'.FP_WIDTH(%s))'%str(int(FP_WIDTH[i])))				
						new_string_1 = new_string_1.replace('client_rx_if#(.NUM_WORDS(16))','client_rx_if#(.NUM_WORDS(%s),'%str(int(widths_txmac_macseg[SPEED[i]])+1)+'.FP_WIDTH(%s))'%str(int(FP_WIDTH[i])))				
				new_string_1 = new_string_1.replace('i<1','i<%s'%speed_iter[SPEED[i]])
				new_string_1 = new_string_1.replace('ts_tasks_if[0].ip = 0','ts_tasks_if[0].ip = %s'%i)
				new_string_1 = new_string_1.replace('ts_tasks_if[0]','ts_tasks_if[%s]'%i)
				new_string_1 = new_string_1.replace('svt_ethernet_mon_chk_0','svt_ethernet_mon_chk_%s'%i)
				new_string_1 = new_string_1.replace('svt_ethernet_txrx_if[0]','svt_ethernet_txrx_if[%s]'%i)
				new_string_1 = new_string_1.replace('svt_ethernet_drv_0','svt_ethernet_drv_%s'%i)
				new_string_1 = new_string_1.replace('assertion_on_off_reset[0]','assertion_on_off_reset[%s]'%i)
				new_string_1 = new_string_1.replace('.ST_SYMBOL_W(ST_SYMBOL_W_25G)','.ST_SYMBOL_W(ST_SYMBOL_W_'+str(SPEED[i])+'G)')
				new_string_1 = new_string_1.replace('`ALTUVM_AVALON_ST_INF_TB_PARAM_INST_25G','`ALTUVM_AVALON_ST_INF_TB_PARAM_INST_'+str(SPEED[i])+'G')
				new_string_1 = new_string_1.replace('`ALTUVM_AVALON_ST_RTB_TB_PARAM_INST_25G','`ALTUVM_AVALON_ST_RTB_TB_PARAM_INST_'+str(SPEED[i])+'G')
				new_string_1 = new_string_1.replace('svt_ethernet_txrx_if['+str(i)+'].rx_lane[0:0]','svt_ethernet_txrx_if['+str(i)+'].rx_lane['+str(int(NUMTXLANE[i])-1)+':0]')
				new_string_1 = new_string_1.replace('svt_ethernet_txrx_if['+str(i)+'].tx_lane[0:0]','svt_ethernet_txrx_if['+str(i)+'].tx_lane['+str(int(NUMTXLANE[i])-1)+':0]')
				new_string_1 = new_string_1.replace('*dut_25g_ip%s'%i,'*dut_'+str(SPEED[i])+'g_ip%s'%i)
				#if((SPEED[i]=='40' or SPEED[i]=='50') and PP[i]=='1'):
				#	new_string_1 = new_string_1.replace(' //assign tx_preamble_ip%s'%i,'assign tx_preamble_ip%s'%i)
				#	new_string_1 = new_string_1.replace('//assign eth_sideband_if_ip%s.l2_rx_preamble'%i,'assign eth_sideband_if_ip%s.l2_rx_preamble'%i)
				writetofile(vars()['macseg%s'%i],new_string_1)
for i in range(len(SPEED)):
	if(MODE[i] not in nrz):
		print("script_debug_gdr.py: TRANSTYPE is",TRANSTYPE)
		#UX
		if(TRANSTYPE[i]=='0'):
			#print("I am HERE BARAK -- 0")
			vars()['pam4_%s' %i] = open(env_var+"/gdr_gen_qhip_files/gdr_serial_pam4_ip%s.sv"%i,"w+")
			for j in open("gdr_serial_connection_pam4.sv",'r'):
				j=j.replace('ip0','ip%s'%i)
				j=j.replace('IP0','IP%s'%i)
				j=j.replace('svt_ethernet_txrx_if[0]','svt_ethernet_txrx_if[%s]'%i)
				writetofile(vars()['pam4_%s'%i],j)
		#BARAK
		if(TRANSTYPE[i]== '1'):
			#print("I am HERE BARAK -- 1")
			vars()['pam4_%s' %i] = open(env_var+"/gdr_gen_qhip_files/gdr_serial_pam4_ip%s.sv"%i,"w+")
			for j in open("gdr_serial_connection_pam4_barak.sv",'r'):
				j=j.replace('ip0','ip%s'%i)
				j=j.replace('IP0','IP%s'%i)
				j=j.replace('svt_ethernet_txrx_if[0]','svt_ethernet_txrx_if[%s]'%i)
				writetofile(vars()['pam4_%s'%i],j)				
	else:
		vars()['nrz_%s' %i] = open(env_var+"/gdr_gen_qhip_files/gdr_serial_nrz_ip%s.sv"%i,"w+")
		for j in open("gdr_serial_connection_nrz.sv",'r'):
		    j=j.replace('ip0','ip%s'%i)
		    j=j.replace('IP0','IP%s'%i)
		    j=j.replace('svt_ethernet_txrx_if[0]','svt_ethernet_txrx_if[%s]'%i)
		    writetofile(vars()['nrz_%s'%i],j)

old_speed=[]
anlt_old=[]
for z in SPEED:
	if z not in old_speed:
		old_speed.append(z)
		anlt_old.append(ANLT[old_speed.index(z)])
print("unique",old_speed,anlt_old)
for i in range(len(old_speed)):
	if(anlt_old[i]==1):
		vars()['kr_%s' %i] = open(env_var+"/gdr_gen_qhip_files/gdr_kr_%sg.sv"%str(old_speed[i]),"w+")
		for j in open("gdr_kr_template.sv",'r'):
		    j=j.replace('kr25g','kr'+str(old_speed[i])+'g')
		    writetofile(vars()['kr_%s'%i],j)

speed_iter={'10':'1','25':'1','40':'2','50':'2','100':'4','200':'8','400':'16'}
flag_1 =0
print("script_debug_gdr NUMTXLANE 2 is",NUMTXLANE)
for j in open("gdr_pcs_only_template.sv","r"):
	if(j[0:21] =='// end DUT port wires'):
		flag_1=1
	if(flag_1):
		for i in range(len(SPEED)):
			if(INTERFACE[i]=='2'):
				if(j=='   altera_avalon_mm_if #(`AVMM_XCVR_CFG_SHARED_INF_INST) avmm_xcvr_if_ip0_0 ('+'\n'):
					for z in range(int(NUMTXLANE[i])-1):
						writetofile(vars()['pcs_only_%s'%i],'\n'+j[:-6]+str(i)+'_'+str(z+1)+' ('+'\n'+'	 		            .clk                       (clk_status_ip'+str(i)+'),'+'\n'+'	 		            .reset                     (reset_ip'+str(i)+')'+'\n'+'               );'+'\n')
				if(j=='   altuvm_avalon_mm_rtb #(`AVMM_XCVR_CFG_SHARED_INF_INST,'+'\n'):
					for z in range(int(NUMTXLANE[i])-1):
						writetofile(vars()['pcs_only_%s'%i],'\n'+j+'           .IS_ACTIVE                 (UVM_ACTIVE),'+'\n'+'           .BFM_TYPE                  (altuvm_avalon_mm_pkg::AVALON_MM_MASTER)'+'\n'+'               ) avmm_xcvr_rtb_ip'+str(i)+'_'+str(z+1)+' (.uif(avmm_xcvr_if_ip'+str(i)+'_'+str(z+1)+'));'+'\n')
				if(j=='      uvm_config_db#(string)::set(uvm_root::get(),"*env_ip0","avmm_xcvr_rtb_path_0","avmm_xcvr_rtb_ip0_0");'+'\n'):
					for z in range(int(NUMTXLANE[i])-1):
						writetofile(vars()['pcs_only_%s'%i],'\n'+'      uvm_config_db#(string)::set(uvm_root::get(),"*env_ip'+str(i)+'","avmm_xcvr_rtb_path_'+str(z+1)+'","avmm_xcvr_rtb_ip'+str(i)+'_'+str(z+1)+'");'+'\n')
				if(j=='    assign reconfig_xcvr0_write_ip0           = avmm_xcvr_if_ip0_0.write;'+'\n'):
					for z in range(int(NUMTXLANE[i])-1):
						writetofile(vars()['pcs_only_%s'%i],'\n'+'    assign reconfig_xcvr'+str(z+1)+'_write_ip'+str(i)+'           = avmm_xcvr_if_ip'+str(i)+'_'+str(z+1)+'.write;'+'\n')
				if(j=='    assign reconfig_xcvr0_read_ip0            = avmm_xcvr_if_ip0_0.read;'+'\n'):
					for z in range(int(NUMTXLANE[i])-1):
						writetofile(vars()['pcs_only_%s'%i],'\n'+'    assign reconfig_xcvr'+str(z+1)+'_read_ip'+str(i)+'           = avmm_xcvr_if_ip'+str(i)+'_'+str(z+1)+'.read;'+'\n')
				if(j=="    assign reconfig_xcvr0_byteenable_ip0      = avmm_xcvr_if_ip0_0.byteenable;"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['pcs_only_%s'%i],'\n'+"     assign reconfig_xcvr"+str(z+1)+"_byteenable_ip"+str(i)+"         = avmm_xcvr_if_ip"+str(i)+'_'+str(z+1)+".byteenable;"+'\n')
				if(j=="    assign reconfig_xcvr0_address_ip0         = {3'b0,avmm_xcvr_if_ip0_0.address[17:2]};"+'\n'):
					for z in range(int(NUMTXLANE[i])-1):
						writetofile(vars()['pcs_only_%s'%i],'\n'+"     assign reconfig_xcvr"+str(z+1)+"_address_ip"+str(i)+"         = {3'b0,avmm_xcvr_if_ip"+str(i)+'_'+str(z+1)+".address[17:2]};"+'\n')
				if(j=='    assign reconfig_xcvr0_writedata_ip0       = avmm_xcvr_if_ip0_0.writedata;'+'\n'):
					for z in range(int(NUMTXLANE[i])-1):
						writetofile(vars()['pcs_only_%s'%i],'\n'+'    assign reconfig_xcvr'+str(z+1)+'_writedata_ip'+str(i)+'           = avmm_xcvr_if_ip'+str(i)+'_'+str(z+1)+'.writedata;'+'\n')
				if(j=="    assign avmm_xcvr_if_ip0_0.readdata         = reconfig_xcvr0_readdata_ip0;"+'\n'):
					for z in range(int(NUMTXLANE[i])-1):
						writetofile(vars()['pcs_only_%s'%i],'\n'+"    assign avmm_xcvr_if_ip"+str(i)+"_"+str(z+1)+".readdata         = reconfig_xcvr"+str(z+1)+"_readdata_ip"+str(i)+";"+'\n')
				if(j=="    assign avmm_xcvr_if_ip0_0.waitrequest      = reconfig_xcvr0_waitrequest_ip0;    "+'\n'):
					for z in range(int(NUMTXLANE[i])-1):
						writetofile(vars()['pcs_only_%s'%i],'\n'+"    assign avmm_xcvr_if_ip"+str(i)+"_"+str(z+1)+".waitrequest         = reconfig_xcvr"+str(z+1)+"_waitrequest_ip"+str(i)+";"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_assertion.enable_a_waitrequest_during_reset = 0;"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['pcs_only_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_assertion.enable_a_waitrequest_during_reset = 0;"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_assertion.enable_a_no_readdatavalid_during_reset = 0;"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['pcs_only_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_assertion.enable_a_no_readdatavalid_during_reset = 0;"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_read_byteenable(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['pcs_only_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_read_byteenable(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_b2b_read_read(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['pcs_only_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_b2b_read_read(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_b2b_read_write(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['pcs_only_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_b2b_read_write(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_b2b_write_read(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['pcs_only_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_b2b_write_read(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_b2b_write_write(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['pcs_only_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_b2b_write_write(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_continuous_read(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['pcs_only_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_continuous_read(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_continuous_readdatavalid(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['pcs_only_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_continuous_readdatavalid(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_continuous_waitrequest(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['pcs_only_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_continuous_waitrequest(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_continuous_waitrequest_from_idle_to_read(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['pcs_only_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_continuous_waitrequest_from_idle_to_read(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_continuous_waitrequest_from_idle_to_write(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['pcs_only_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_continuous_waitrequest_from_idle_to_write(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_continuous_write(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['pcs_only_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_continuous_write(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_idle_before_transaction(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['pcs_only_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_idle_before_transaction(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_read(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['pcs_only_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_read(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_read_after_reset(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['pcs_only_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_read_after_reset(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_read_latency(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['pcs_only_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_read_latency(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_waitrequest_without_command(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['pcs_only_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_waitrequest_without_command(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_waitrequested_read(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['pcs_only_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_waitrequested_read(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_waitrequested_write(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['pcs_only_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_waitrequested_write(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_write(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['pcs_only_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_write(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_write_after_reset(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['pcs_only_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_write_after_reset(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_write_byteenable(0);"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['pcs_only_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_write_byteenable(0);"+'\n')
				if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_assertion.enable_a_half_cycle_reset_legal = 0;"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['pcs_only_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_assertion.enable_a_half_cycle_reset_legal = 0;"+'\n')
				if(j=="    assign avmm_xcvr_if_ip0_0.readdatavalid    = reconfig_xcvr0_readdata_valid_ip0;"+'\n'):
					for z in range(int(NUMTXLANE[i])-1):
						writetofile(vars()['pcs_only_%s'%i],'\n'+"    assign avmm_xcvr_if_ip"+str(i)+"_"+str(z+1)+".readdatavalid         = reconfig_xcvr"+str(z+1)+"_readdata_valid_ip"+str(i)+";"+'\n')

				string_pcs = j.replace('ip0','ip%s'%i)
				string_pcs = string_pcs.replace('INST_IP0 1','INST_IP0 %s'%str(int(widths_txmac_pcsonly[SPEED[i]])+1))
				string_pcs = string_pcs.replace('IP0','IP%s'%i)
				string_pcs = string_pcs.replace('ts_tasks_if[0].ip = 0','ts_tasks_if[0].ip = %s'%i)
				string_pcs = string_pcs.replace('ts_tasks_if[0]','ts_tasks_if[%s]'%i)
				string_pcs = string_pcs.replace('svt_ethernet_mon_chk_0','svt_ethernet_mon_chk_%s'%i)
				string_pcs = string_pcs.replace('svt_ethernet_txrx_if[0]','svt_ethernet_txrx_if[%s]'%i)
				string_pcs = string_pcs.replace('svt_ethernet_drv_0','svt_ethernet_drv_%s'%i)
				string_pcs = string_pcs.replace('assertion_on_off_reset[0]','assertion_on_off_reset[%s]'%i)
				writetofile(vars()['pcs_only_%s'%i],string_pcs)

speed_iter={'10':'1','25':'1','40':'2','50':'2','100':'4','200':'8','400':'16'}
flag_1 =0
print("script_debug_gdr NUMTXLANE 3 is",NUMTXLANE)
for j in open("gdr_otn_flexe_template.sv","r"):
	if(j[0:21] =='// end DUT port wires'):
	        flag_1=1
        if(flag_1):
               for i in range(len(SPEED)):
		     if(INTERFACE[i]=='3' or INTERFACE[i]=='4'):
			if(j=='   altera_avalon_mm_if #(`AVMM_XCVR_CFG_SHARED_INF_INST) avmm_xcvr_if_ip0_0 ('+'\n'):
				for z in range(int(NUMTXLANE[i])-1):
					writetofile(vars()['otn_flexe_%s'%i],'\n'+j[:-6]+str(i)+'_'+str(z+1)+' ('+'\n'+'	 		            .clk                       (clk_status_ip'+str(i)+'),'+'\n'+'	 		            .reset                     (reset_ip'+str(i)+')'+'\n'+'               );'+'\n')
			if(j=='   altuvm_avalon_mm_rtb #(`AVMM_XCVR_CFG_SHARED_INF_INST,'+'\n'):
				for z in range(int(NUMTXLANE[i])-1):
					writetofile(vars()['otn_flexe_%s'%i],'\n'+j+'           .IS_ACTIVE                 (UVM_ACTIVE),'+'\n'+'           .BFM_TYPE                  (altuvm_avalon_mm_pkg::AVALON_MM_MASTER)'+'\n'+'               ) avmm_xcvr_rtb_ip'+str(i)+'_'+str(z+1)+' (.uif(avmm_xcvr_if_ip'+str(i)+'_'+str(z+1)+'));'+'\n')
			if(j=='      uvm_config_db#(string)::set(uvm_root::get(),"*env_ip0","avmm_xcvr_rtb_path_0","avmm_xcvr_rtb_ip0_0");'+'\n'):
				for z in range(int(NUMTXLANE[i])-1):
					writetofile(vars()['otn_flexe_%s'%i],'\n'+'      uvm_config_db#(string)::set(uvm_root::get(),"*env_ip'+str(i)+'","avmm_xcvr_rtb_path_'+str(z+1)+'","avmm_xcvr_rtb_ip'+str(i)+'_'+str(z+1)+'");'+'\n')
			if(j=='      uvm_config_db#(virtual svt_ethernet_test_suite_if)::set(uvm_root::get(),"*ts_component0*", "if_directed", directed_if[0]);'+'\n'):
				for z in range(int(NUMTXLANE[i])-1):
					writetofile(vars()['otn_flexe_%s'%i],'\n'+'      uvm_config_db#(virtual svt_ethernet_test_suite_if)::set(uvm_root::get(),"*ts_component'+str(i)+'*", "if_directed", directed_if[0]);'+'\n')
			if(j=='    assign reconfig_xcvr0_write_ip0           = avmm_xcvr_if_ip0_0.write;'+'\n'):
				for z in range(int(NUMTXLANE[i])-1):
					writetofile(vars()['otn_flexe_%s'%i],'\n'+'	assign reconfig_xcvr'+str(z+1)+'_write_ip'+str(i)+'           = avmm_xcvr_if_ip'+str(i)+'_'+str(z+1)+'.write;'+'\n')
			if(j=='    assign reconfig_xcvr0_read_ip0            = avmm_xcvr_if_ip0_0.read;'+'\n'):
				for z in range(int(NUMTXLANE[i])-1):
					writetofile(vars()['otn_flexe_%s'%i],'\n'+'	assign reconfig_xcvr'+str(z+1)+'_read_ip'+str(i)+'           = avmm_xcvr_if_ip'+str(i)+'_'+str(z+1)+'.read;'+'\n')
	                if(j=="    assign reconfig_xcvr0_byteenable_ip0      = avmm_xcvr_if_ip0_0.byteenable;"+'\n'):
					  for z in range(int(NUMTXLANE[i])-1):
						  writetofile(vars()['otn_flexe_%s'%i],'\n'+"     assign reconfig_xcvr"+str(z+1)+"_byteenable_ip"+str(i)+"         = avmm_xcvr_if_ip"+str(i)+'_'+str(z+1)+".byteenable;"+'\n')
			if(j=="    assign reconfig_xcvr0_address_ip0         = {3'b0,avmm_xcvr_if_ip0_0.address[17:2]};"+'\n'):
				for z in range(int(NUMTXLANE[i])-1):
					writetofile(vars()['otn_flexe_%s'%i],'\n'+"	assign reconfig_xcvr"+str(z+1)+"_address_ip"+str(i)+"         = {3'b0,avmm_xcvr_if_ip"+str(i)+'_'+str(z+1)+".address[17:2]};"+'\n')
			if(j=='    assign reconfig_xcvr0_writedata_ip0       = avmm_xcvr_if_ip0_0.writedata;'+'\n'):
				for z in range(int(NUMTXLANE[i])-1):
					writetofile(vars()['otn_flexe_%s'%i],'\n'+'	assign reconfig_xcvr'+str(z+1)+'_writedata_ip'+str(i)+'           = avmm_xcvr_if_ip'+str(i)+'_'+str(z+1)+'.writedata;'+'\n')
			if(j=="    assign avmm_xcvr_if_ip0_0.readdata         = reconfig_xcvr0_readdata_ip0;"+'\n'):
				for z in range(int(NUMTXLANE[i])-1):
					writetofile(vars()['otn_flexe_%s'%i],'\n'+"	assign avmm_xcvr_if_ip"+str(i)+"_"+str(z+1)+".readdata	= reconfig_xcvr"+str(z+1)+"_readdata_ip"+str(i)+";"+'\n')
			if(j=="    assign avmm_xcvr_if_ip0_0.waitrequest      = reconfig_xcvr0_waitrequest_ip0;    "+'\n'):
				for z in range(int(NUMTXLANE[i])-1):
					writetofile(vars()['otn_flexe_%s'%i],'\n'+"	assign avmm_xcvr_if_ip"+str(i)+"_"+str(z+1)+".waitrequest = reconfig_xcvr"+str(z+1)+"_waitrequest_ip"+str(i)+";"+'\n')
			if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_assertion.enable_a_waitrequest_during_reset = 0;"+'\n'):
				for z in range(int(NUMTXLANE[i])-1):
					 writetofile(vars()['otn_flexe_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_assertion.enable_a_waitrequest_during_reset = 0;"+'\n')
			if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_assertion.enable_a_no_readdatavalid_during_reset = 0;"+'\n'):
				for z in range(int(NUMTXLANE[i])-1):
					writetofile(vars()['otn_flexe_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_assertion.enable_a_no_readdatavalid_during_reset = 0;"+'\n')
			if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_assertion.enable_a_half_cycle_reset_legal = 0;"+'\n'):
				for z in range(int(NUMTXLANE[i])-1):
					writetofile(vars()['otn_flexe_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_assertion.enable_a_half_cycle_reset_legal = 0;"+'\n')
			if(j=="    assign avmm_xcvr_if_ip0_0.readdata_valid    = reconfig_xcvr0_readdata_valid_ip0;"+'\n'):
				for z in range(int(NUMTXLANE[i])-1):
					writetofile(vars()['otn_flexe_%s'%i],'\n'+"	assign avmm_xcvr_if_ip"+str(i)+"_"+str(z+1)+".readdata_valid = reconfig_xcvr"+str(z+1)+"_readdata_valid_ip"+str(i)+";"+'\n')
			if(j=='reg  	             reconfig_xcvr0_write_ip0;'+'\n'):
				for f in range(int(NUMTXLANE[i])-1):
					writetofile(vars()['otn_flexe_%s'%i],j[:-12]+str(f+1)+'_write_ip%s;'%i+'\n')
			if(j=='reg  	             reconfig_xcvr0_read_ip0;'+'\n'):
				for f in range(int(NUMTXLANE[i])-1):
					writetofile(vars()['otn_flexe_%s'%i],j[:-11]+str(f+1)+'_read_ip%s;'%i+'\n')
			if(j=='reg [19:0]           reconfig_xcvr0_address_ip0;'+'\n'):
				for f in range(int(NUMTXLANE[i])-1):
					writetofile(vars()['otn_flexe_%s'%i],j[:-14]+str(f+1)+'_address_ip%s;'%i+'\n')
			if(j=='reg [31:0]           reconfig_xcvr0_writedata_ip0;'+'\n'):
				for f in range(int(NUMTXLANE[i])-1):
					writetofile(vars()['otn_flexe_%s'%i],j[:-16]+str(f+1)+'_writedata_ip%s;'%i+'\n')
			if(j=='wire [31:0]           reconfig_xcvr0_readdata_ip0;'+'\n'):
				for f in range(int(NUMTXLANE[i])-1):
					writetofile(vars()['otn_flexe_%s'%i],j[:-15]+str(f+1)+'_readdata_ip%s;'%i+'\n')
			if(j=='wire 	             reconfig_xcvr0_waitrequest_ip0;'+'\n'):
				for f in range(int(NUMTXLANE[i])-1):
					writetofile(vars()['otn_flexe_%s'%i],j[:-18]+str(f+1)+'_waitrequest_ip%s;'%i+'\n')
			if(j=='wire 	             reconfig_xcvr0_readdatavalid_ip0;'+'\n'):
				for f in range(int(NUMTXLANE[i])-1):
					writetofile(vars()['otn_flexe_%s'%i],j[:-20]+str(f+1)+'_readdatavalid_ip%s;'%i+'\n')
                        if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_read_byteenable(0);"+'\n'):
				for z in range(int(NUMTXLANE[i])-1):
					writetofile(vars()['otn_flexe_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_read_byteenable(0);"+'\n')
			if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_b2b_read_read(0);"+'\n'):
				for z in range(int(NUMTXLANE[i])-1):
					writetofile(vars()['otn_flexe_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_b2b_read_read(0);"+'\n')
			if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_b2b_read_write(0);"+'\n'):
				for z in range(int(NUMTXLANE[i])-1):
					writetofile(vars()['otn_flexe_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_b2b_read_write(0);"+'\n')
			if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_b2b_write_read(0);"+'\n'):
				for z in range(int(NUMTXLANE[i])-1):
					writetofile(vars()['otn_flexe_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_b2b_write_read(0);"+'\n')
			if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_b2b_write_write(0);"+'\n'):
				for z in range(int(NUMTXLANE[i])-1):
					writetofile(vars()['otn_flexe_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_b2b_write_write(0);"+'\n')
			if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_continuous_read(0);"+'\n'):
				for z in range(int(NUMTXLANE[i])-1):
					writetofile(vars()['otn_flexe_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_continuous_read(0);"+'\n')
			if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_continuous_readdatavalid(0);"+'\n'):
				for z in range(int(NUMTXLANE[i])-1):
					writetofile(vars()['otn_flexe_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_continuous_readdatavalid(0);"+'\n')
			if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_continuous_waitrequest(0);"+'\n'):
				for z in range(int(NUMTXLANE[i])-1):
					writetofile(vars()['otn_flexe_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_continuous_waitrequest(0);"+'\n')
			if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_continuous_waitrequest_from_idle_to_read(0);"+'\n'):
				for z in range(int(NUMTXLANE[i])-1):
					writetofile(vars()['otn_flexe_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_continuous_waitrequest_from_idle_to_read(0);"+'\n')
			if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_continuous_waitrequest_from_idle_to_write(0);"+'\n'):
				for z in range(int(NUMTXLANE[i])-1):
					writetofile(vars()['otn_flexe_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_continuous_waitrequest_from_idle_to_write(0);"+'\n')
			if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_continuous_write(0);"+'\n'):
				for z in range(int(NUMTXLANE[i])-1):
					writetofile(vars()['otn_flexe_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_continuous_write(0);"+'\n')
			if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_idle_before_transaction(0);"+'\n'):
				for z in range(int(NUMTXLANE[i])-1):
					writetofile(vars()['otn_flexe_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_idle_before_transaction(0);"+'\n')
			if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_read(0);"+'\n'):
				for z in range(int(NUMTXLANE[i])-1):
					writetofile(vars()['otn_flexe_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_read(0);"+'\n')
			if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_read_after_reset(0);"+'\n'):
				for z in range(int(NUMTXLANE[i])-1):
					writetofile(vars()['otn_flexe_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_read_after_reset(0);"+'\n')
			if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_read_latency(0);"+'\n'):
				for z in range(int(NUMTXLANE[i])-1):
					writetofile(vars()['otn_flexe_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_read_latency(0);"+'\n')
			if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_waitrequest_without_command(0);"+'\n'):
				for z in range(int(NUMTXLANE[i])-1):
					writetofile(vars()['otn_flexe_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_waitrequest_without_command(0);"+'\n')
			if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_waitrequested_read(0);"+'\n'):
				for z in range(int(NUMTXLANE[i])-1):
					writetofile(vars()['otn_flexe_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_waitrequested_read(0);"+'\n')
			if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_waitrequested_write(0);"+'\n'):
				for z in range(int(NUMTXLANE[i])-1):
					writetofile(vars()['otn_flexe_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_waitrequested_write(0);"+'\n')
			if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_write(0);"+'\n'):
				for z in range(int(NUMTXLANE[i])-1):
					writetofile(vars()['otn_flexe_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_write(0);"+'\n')
			if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_write_after_reset(0);"+'\n'):
				for z in range(int(NUMTXLANE[i])-1):
					writetofile(vars()['otn_flexe_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_write_after_reset(0);"+'\n')
			if(j=="              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_write_byteenable(0);"+'\n'):
				for z in range(int(NUMTXLANE[i])-1):
					writetofile(vars()['otn_flexe_%s'%i],'\n'+"              avmm_xcvr_rtb_ip"+str(i)+"_"+str(z+1)+".monitor.u_bfm.master_coverage.set_enable_c_write_byteenable(0);"+'\n')




			string_otn_flexe = j.replace('ip0','ip%s'%i)
			string_otn_flexe = string_otn_flexe.replace('IP0','IP%s'%i)
			string_otn_flexe = string_otn_flexe.replace('ts_tasks_if[0].ip = 0','ts_tasks_if[0].ip = %s'%i)
			string_otn_flexe = string_otn_flexe.replace('ts_tasks_if[0]','ts_tasks_if[%s]'%i)
			string_otn_flexe = string_otn_flexe.replace('directed_if[0]','directed_if[%s]'%i)
			string_otn_flexe = string_otn_flexe.replace('xgmii66_clk[0]','xgmii66_clk[%s]'%i)
			string_otn_flexe = string_otn_flexe.replace('uif_pcs66[0]','uif_pcs66[%s]'%i)
			string_otn_flexe = string_otn_flexe.replace('svt_ethernet_mon_chk_0','svt_ethernet_mon_chk_%s'%i)
			string_otn_flexe = string_otn_flexe.replace('svt_ethernet_mon_chk_otn_flexe_0','svt_ethernet_mon_chk_otn_flexe_%s'%i)
			string_otn_flexe = string_otn_flexe.replace('svt_ethernet_txrx_if[0]','svt_ethernet_txrx_if[%s]'%i)
			string_otn_flexe = string_otn_flexe.replace('svt_ethernet_drv_0','svt_ethernet_drv_%s'%i)
			string_otn_flexe = string_otn_flexe.replace('ts_component0','ts_component%s'%i)
			string_otn_flexe = string_otn_flexe.replace('svt_ethernet_drv_otn_flexe_0','svt_ethernet_drv_otn_flexe_%s'%i)
			string_otn_flexe = string_otn_flexe.replace('spy_if_ip'+str(i)+'.gear       = 1','spy_if_ip'+str(i)+'.gear       = %s'%str(int(widths_txmac_macseg[SPEED[i]])+1))
			string_otn_flexe = string_otn_flexe.replace('spy_if_ip'+str(i)+'.tx_freq    = 390.625','spy_if_ip'+str(i)+'.tx_freq    = %s'%str(value_freq_otn_flexe[SPEED[i]]))
			string_otn_flexe = string_otn_flexe.replace('spy_if_ip'+str(i)+'.rx_freq    = 390.625','spy_if_ip'+str(i)+'.rx_freq    = %s'%str(value_rx_freq_otn_flexe[SPEED[i]]))
			string_otn_flexe = string_otn_flexe.replace('assertion_on_off_reset[0]','assertion_on_off_reset[%s]'%i)
			#j = j.replace('spy_if_ip'+str(i)+'.am_ins_cyc = 4','spy_if_ip'+str(i)+'.am_ins_cyc = %s'%str(value_otn_flexe[SPEED[i]]))
			#j=  j.replace('spy_if_ip'+str(i)+'.am_ins_cnt = 5119','spy_if_ip0.am_ins_cnt = %s'%str(value_otn_flexe_inst_cnt[SPEED[i]]))
			writetofile(vars()['otn_flexe_%s'%i],string_otn_flexe)

ptp_ports=[]
reg_port,wire_port=[],[]
flag=0
for j in range(len(SPEED)):
        if(PTP[j]=='1'):
                vars()['WB_debug%s' %j] = open(env_var+"/WB_debug_signal_ip%s.sv"%j,"w+")
                for i in open("WB_debug_signal.sv","r"):
                        new_string = i.replace('spy_if_ip0','spy_if_ip%s'%j)
                        new_string = new_string.replace('dut.ip0','dut.ip%s'%j)
                        new_string = new_string.replace('top_ip0','top_ip%s'%j)
                        writetofile(vars()['WB_debug%s'%j],new_string)
                vars()['acc_mon%s' %j] = open(env_var+"/acc_mon_sig_assigns_ip%s.sv"%j,"w+")
                for i in open("acc_mon_sig_assigns.sv","r"):
                        new_string = i.replace('spy_if_ip0','spy_if_ip%s'%j)
                        new_string = new_string.replace('dut.ip0','dut.ip%s'%j)
                        new_string = new_string.replace('top_ip0','top_ip%s'%j)
                        writetofile(vars()['acc_mon%s'%j],new_string)
                vars()['serial_mon%s' %j] = open(env_var+"/serial_monitor_conn_ip%s.sv"%j,"w+")
                for i in open("serial_monitor_conn.sv","r"):
                        new_string = i.replace('spy_if_ip0','spy_if_ip%s'%j)
                        new_string = new_string.replace('dut.ip0','dut.ip%s'%j)
                        new_string = new_string.replace('svt_ethernet_drv_0','svt_ethernet_drv_%s'%j)
                        new_string = new_string.replace('svt_ethernet_mon_chk_0','svt_ethernet_mon_chk_%s'%j)
                        new_string = new_string.replace('ip0','ip%s'%j)
                        new_string = new_string.replace('svt_ethernet_txrx_if[0]','svt_ethernet_txrx_if[%s]'%j)
                        writetofile(vars()['serial_mon%s'%j],new_string)
for j in range(len(SPEED)):
	if(PTP[j]=='1' and INTERFACE[j]=='1' ):
		vars()['avst_ptp%s' %j] = open(env_var+"/gdr_gen_qhip_files/gdr_avst_ptp_ip%s.sv"%j,"w+")
		for i in open("gdr_avst_ptp_template.sv","r"):
			##print(i)
			#ptp_ports.append(i.split())
			#if(i[0:7] =='typedef'):
				#break
		#ptp_ports = list(filter(None, ptp_ports))
		#print(ptp_ports)
		#for i in open("../../../../../common/tb_templates/gdr_avst_ptp_template.sv","r"):
			#if(i[0:7]=='typedef'):
				#flag=1
			#if(flag):
			new_string = i.replace('ip0','ip%s'%j)
			new_string = new_string.replace('IP0','IP%s'%j)
			new_string = new_string.replace('inst_num(0)','inst_num(%s)'%j)
			if(FP_WIDTH[j]==None):
				new_string = new_string.replace('ptp_tx_interface#(.NUM_WORDS(x),.FP_WIDTH(y))','ptp_tx_interface#(.NUM_WORDS(%s),'%str(int(widths_txmac_macseg[SPEED[j]])+1)+'.FP_WIDTH(32))')
			else:
				new_string = new_string.replace('ptp_tx_interface#(.NUM_WORDS(x),.FP_WIDTH(y))','ptp_tx_interface#(.NUM_WORDS(%s),'%str(int(widths_txmac_macseg[SPEED[j]])+1)+'.FP_WIDTH(%s))'%str(int(FP_WIDTH[j])))
			writetofile(vars()['avst_ptp%s'%j],new_string)
	elif(PTP[j]=='1' and INTERFACE[j]=='0' ):	
		vars()['macseg_ptp%s' %j] = open(env_var+"/gdr_gen_qhip_files/gdr_macseg_ptp_ip%s.sv"%j,"w+")			
		for z in wire_macseg_ptp:
			writetofile(vars()['macseg_ptp%s'%j],'wire '+z[:-1]+str(j)+';'+"\n")
		for u in wire_macseg_ptp_width:
			if(u=='i_ptp_ts_req_ip0' or u=='i_ptp_ins_ets_ip0' or u=='i_ptp_ins_cf_ip0' or u=='i_ptp_zero_csum_ip0' or u=='i_ptp_update_eb_ip0' or u=='i_ptp_p2p_ip0' or u=='i_ptp_asym_ip0' or u=='i_ptp_asym_sign_ip0' or u=='i_ptp_ts_format_ip0' or u=='o_ptp_ets_valid_ip0' or u=='o_ptp_rx_its_valid_ip0'):
				#print("inside wire_macseg_ptp_width",u)
				if(SPEED[j]=='400'):
					writetofile(vars()['macseg_ptp%s'%j],'wire [1:0] '+u[:-1]+str(j)+';\n')
				else:
					writetofile(vars()['macseg_ptp%s'%j],'wire [0:0] '+u[:-1]+str(j)+';\n')	
			elif(u=='o_ptp_ets_vl_ip0' or u=='o_ptp_rx_its_vl_ip0'):
				if(SPEED[j]=='400'):
					writetofile(vars()['macseg_ptp%s'%j],'wire [9:0] '+u[:-1]+str(j)+';\n')
				else:
					writetofile(vars()['macseg_ptp%s'%j],'wire [4:0] '+u[:-1]+str(j)+';\n')
			elif(u=='i_ptp_asym_p2p_idx_ip0'):
				writetofile(vars()['macseg_ptp%s'%j],'wire [13:0] '+u[:-1]+str(j)+';\n')
			elif(u=='i_ptp_fp_ip0' or u=='o_ptp_ets_fp_ip0'):
				if(SPEED[j]=='400'):
					if(FP_WIDTH[j]==None):
						#Default to max width if not specified x2
						writetofile(vars()['macseg_ptp%s'%j],'wire [63:0] '+u[:-1]+str(j)+';\n')
					else:
						writetofile(vars()['macseg_ptp%s'%j],'wire ' + '[' + str(int(FP_WIDTH[j])*2-1)+':0] ' +u[:-1]+str(j) + ';\n')
				else:
					if(FP_WIDTH[j]==None):
						#Default to max width if not specified
						writetofile(vars()['macseg_ptp%s'%j],'wire [31:0] '+u[:-1]+str(j)+';\n')
					else:
						writetofile(vars()['macseg_ptp%s'%j],'wire ' + '[' + str(int(FP_WIDTH[j])-1)+':0] ' +u[:-1]+str(j) + ';\n')
			elif(u=='o_ptp_eb_offset_ip0'):
				writetofile(vars()['macseg_ptp%s'%j],'wire [15:0] '+u[:-1]+str(j)+';\n')
			elif(u=='i_ptp_ts_offset_ip0' or u=='i_ptp_cf_offset_ip0' or u=='i_ptp_csum_offset_ip0'):
				if(SPEED[j]=='400'):
					writetofile(vars()['macseg_ptp%s'%j],'wire [31:0] '+u[:-1]+str(j)+';\n')
				else:
					writetofile(vars()['macseg_ptp%s'%j],'wire [15:0] '+u[:-1]+str(j)+';\n')
			elif(u=='i_ptp_ts_offset_ip0' or u=='i_ptp_cf_offset_ip0' or u=='i_ptp_csum_offset_ip0'):
				if(SPEED[j]=='400'):
					writetofile(vars()['macseg_ptp%s'%j],'wire [31:0] '+u[:-1]+str(j)+';\n')
				else:
					writetofile(vars()['macseg_ptp%s'%j],'wire [15:0] '+u[:-1]+str(j)+';\n')	
			elif(u=='i_ptp_tx_its_ip0' or u=='o_ptp_ets_ip0' or u=='o_ptp_rx_its_ip0'):
				if(SPEED[j]=='400'):
					writetofile(vars()['macseg_ptp%s'%j],'wire [191:0] '+u[:-1]+str(j)+';\n')
				else:
					writetofile(vars()['macseg_ptp%s'%j],'wire [95:0] '+u[:-1]+str(j)+';\n')
		for k in reg_macseg_ptp_width:
			if(k=='i_ptp_tx_tod_ip0' or k=='i_ptp_rx_tod_ip0'):
				writetofile(vars()['macseg_ptp%s'%j],'wire [95:0] '+k[:-1]+str(j)+';\n')
		flag=0
		#append and substitute the remaining ptp macseg template file
		for i in open("gdr_macseg_ptp_template.sv","r"):
			if(i[0:18] == '//QHIP_ACC_TESTING'):
				flag=1;
			if(flag):
				#writetofile(vars()['macseg_ptp%s'%j],i)
				new_string = i.replace('ip0','ip%s'%j)
				new_string = new_string.replace('IP0','IP%s'%j)
			        new_string = new_string.replace('inst_num(0)','inst_num(%s)'%j)
#				new_string = new_string.replace('ptp_tx_interface#(.NUM_WORDS(x))','ptp_tx_interface#(.NUM_WORDS(%s))'%str(int(widths_txmac_macseg[SPEED[j]])+1))
				if(FP_WIDTH[j]==None):
					new_string = new_string.replace('ptp_tx_interface#(.NUM_WORDS(x),.FP_WIDTH(y))','ptp_tx_interface#(.NUM_WORDS(%s),'%str(int(widths_txmac_macseg[SPEED[j]])+1)+'.FP_WIDTH(32))')
				else:
					new_string = new_string.replace('ptp_tx_interface#(.NUM_WORDS(x),.FP_WIDTH(y))','ptp_tx_interface#(.NUM_WORDS(%s),'%str(int(widths_txmac_macseg[SPEED[j]])+1)+'.FP_WIDTH(%s))'%str(int(FP_WIDTH[j])))
				writetofile(vars()['macseg_ptp%s'%j],new_string)
for j in range(len(SPEED)):
	if(INTERFACE[j]=='1'):
		vars()['avst_fc%s' %j] = open(env_var+"/gdr_gen_qhip_files/gdr_avst_fc_ip%s.sv"%j,"w+")
		for i in open("gdr_fc_avst_template.sv","r"):
			#print(i)
			new_string = i.replace('ip0','ip%s'%j)
			new_string = new_string.replace('IP0','IP%s'%j)
			writetofile(vars()['avst_fc%s'%j],new_string)
	elif(INTERFACE[j]=='0'):
		vars()['macseg_fc%s' %j] = open(env_var+"/gdr_gen_qhip_files/gdr_macseg_fc_ip%s.sv"%j,"w+")
		for i in open("gdr_fc_macseg_template.sv","r"):
			#print(i)
			new_string = i.replace('ip0','ip%s'%j)
			new_string = new_string.replace('IP0','IP%s'%j)
			writetofile(vars()['macseg_fc%s'%j],new_string)

for j in range(len(SPEED)):
	if(INTERFACE[j]=='1'):
		vars()['avst_assertion%s' %j] = open(env_var+"/gdr_gen_qhip_files/gdr_avst_assertion_ip%s.sv"%j,"w+")
		for i in open("eth_ehip_assertion_%sg_template.sv"%SPEED[j],"r"):
			#print(i)
			new_string = i.replace('ip0','ip%s'%j)
			new_string = new_string.replace('IP0','IP%s'%j)
			writetofile(vars()['avst_assertion%s'%j],new_string)

for j in range(len(SPEED)):
	vars()['clock_assertion%s' %j] = open(env_var+"/gdr_gen_qhip_files/gdr_clock_assertions_ip%s.sv"%j,"w+")
	for i in open("clock_assertions_template.sv","r"):
		#print(i)
		new_string = i.replace('ip0','ip%s'%j)
		new_string = new_string.replace('IP0','IP%s'%j)
		writetofile(vars()['clock_assertion%s'%j],new_string)
#gdr_serial = open(env_var+"/ip/ethernet/alt_ethernet_crete_gdr/testbench/tb/gdr_gen_qhip_files/pam4_encoder_decoder.sv",'w+')
#for k in open("pam4_encoder_decoder.sv",'r'):
	#writetofile(gdr_serial,k)
#flag2=0

for i in range(len(SPEED)):
	#if(MODE[i] not in nrz and flag2==0):
		#writetofile(top,'\n'+'`include "pam4_encoder_decoder.sv"'+'\n')
		#flag2=flag2+1;
	if(INTERFACE[i]=='1'):
		writetofile(top,'\n'+'`include "gdr_avst_ip%s.sv"'%i+'\n')
	#common for both ptp and non ptp
	elif(INTERFACE[i]=='0' and PTP[i]=='0'):
		writetofile(top,'\n'+'`include "gdr_macseg_ip%s.sv"'%i+'\n')
	elif(INTERFACE[i]=='0' and PTP[i]=='1'):
		writetofile(top,'\n'+'`include "gdr_macseg_ip%s.sv"'%i+'\n')
		writetofile(top,'\n'+'`include "gdr_macseg_ptp_ip%s.sv"'%i+'\n')
	elif(INTERFACE[i]=='2'):
		writetofile(top,'\n'+'`include "gdr_pcs_only_ip%s.sv"'%i+'\n')
	elif(INTERFACE[i]=='3' or INTERFACE[i]=='4'):
		writetofile(top,'\n'+'`include "gdr_otn_flexe_ip%s.sv"'%i+'\n')
	if(PTP[i]=='1' and INTERFACE[i]=='1'):
		writetofile(top,'\n'+'`include "gdr_avst_ptp_ip%s.sv"'%i+'\n')
	if(INTERFACE[i]=='1'):
		writetofile(top,'\n'+'`include "gdr_avst_assertion_ip%s.sv"'%i+'\n')
	if(INTERFACE[i]=='1'):
		writetofile(top,'\n'+'`include "gdr_avst_fc_ip%s.sv"'%i+'\n')
	elif(INTERFACE[i]=='0'):
		writetofile(top,'\n'+'`include "gdr_macseg_fc_ip%s.sv"'%i+'\n')
	if(MODE[i] not in nrz):
		writetofile(top,'\n'+'`include "gdr_serial_pam4_ip%s.sv"'%i+'\n')
	else:
		writetofile(top,'\n'+'`include "gdr_serial_nrz_ip%s.sv"'%i+'\n')
        if(PTP[i]=='1'):
                writetofile(top,'\n'+'`include "serial_monitor_conn_ip%s.sv"'%i+'\n')
	#TODO: temporary disable for custom cadence
        if(PTP[i]!='1'):
		writetofile(top,'\n'+'`include "gdr_clock_assertions_ip%s.sv"'%i+'\n\n')
        else:
	        if(SYSPLL[i]!='3'):
		      writetofile(top,'\n'+'`include "gdr_clock_assertions_ip%s.sv"'%i+'\n\n')
for i in range(len(old_speed)):
	if(anlt_old[i]==1):
		writetofile(top,'\n'+'`include "gdr_kr_%sg.sv"'%old_speed[i]+'\n')
for i in open(env_var+"/gdr_gen_qhip_files/eth_ehip_gdr_top_tail.sv"):
	writetofile(top,i)
