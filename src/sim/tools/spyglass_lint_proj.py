import getopt
import os
import sys
import shutil
import subprocess
from datetime import datetime as dt


sources_files_list = []
top_module = ''
waiver_file = ''
environ_file = ''
bbox = []
bbox_file = []
acds_version = ''
date = dt.now().strftime('_%Y_%m_%d')
time = dt.now().strftime('_%H_%M')
lsf_name_base = ''
lsf_name = ''
lsf_dep = ''
report_path =''
flist_path = './flist.f'
str_wvr_file = ''
ignore_file = []


try:
	opts, args = getopt.getopt(sys.argv[1:],"p:f:e:b:x:i:w:v:C:",["project=", "file_path=","environ=","bbox=","bbox_file=","ignore_file","waiver_file=",["acds_version="],"crontab="])
except getopt.GetoptError:
	print('quartus_lint_proj.py -p <project_name> -f <files_path> -e <environ_setup_file> -b <stop_module> -w <waiver_file> -v <acds_version>')
	sys.exit(2)
	
for opt, arg in opts:
	if opt in ("-p", "--project_name"):
		proj_name = arg
	elif opt in ("-f", "--files_path"):
		file_path = arg
	elif opt in ("-b", "--bbox"):
		bbox.append(arg)
	elif opt in ("-x", "--bbox_file"):
		bbox_file.append(arg)
	elif opt in ("-i", "--ignore_file"):
		ignore_file.append(arg)
	elif opt in ("-w", "--waiver_file"):
		waiver_file = arg
	elif opt in ("-e", "--environ"):
		environ_file = arg
	elif opt in ("-v", "--acds_version"):
		acds_version = arg
	elif opt in ("-C", "--crontab"):
		lsf_name_base = " lsf_name=PTPGB_LINT"+ date
		lsf_dep = " lfs_w=\"done(\'PTPGB_SYNC"+ date+ "\')\""

if not proj_name.strip():
	print('-p <project_name> required')
	sys.exit(2)
	
if not file_path.strip():
	print('-f <files_path> required')
	sys.exit(2)

if environ_file:
	with open(environ_file, 'r') as ef:
		for setting in ef:
			(var,val)=tuple(setting.split('='))
			os.environ[var.strip()]=os.path.expandvars(val.strip())
			
abs_file_path = os.path.abspath(os.path.expandvars(file_path)) + '/'
print('project path is ', abs_file_path)

qsf_file = abs_file_path + proj_name + '.qsf'
if os.path.isfile(qsf_file) : 
	with open(qsf_file, 'r') as f_qsf:
		qsf_lines = f_qsf.readlines()
		for qsf_ln in qsf_lines:
			if qsf_ln.startswith('set_global_assignment -name TOP_LEVEL_ENTITY'):
				top_module = qsf_ln.split()[3].strip()
			elif qsf_ln.startswith('set_global_assignment -name PROJECT_OUTPUT_DIRECTORY'):
				report_path = os.path.join(abs_file_path,qsf_ln.split()[3].strip())
			elif (qsf_ln.startswith('set_global_assignment -name IP_FILE')):
				bbox.append(qsf_ln.split()[3].split('/')[-1].split('.')[0])
			# elif (qsf_ln.startswith('set_global_assignment -name QSYS_FILE')):
				# bbox.append(qsf_ln.split()[3].split('/')[-1].split('.')[0])
else : 
	print('project file does not exist', qsf_file)
	sys.exit(2)
	
qpf_file = abs_file_path + proj_name + '.qpf'
if os.path.isfile(qpf_file) : 
	with open(qpf_file, 'r') as f_qpf:
		qpf_lines = f_qpf.readlines()
		for qpl in qpf_lines:
			if qpl.strip().startswith('PROJECT_REVISION'):
				qpl.split('=')[1].strip()
else : 
	print('project file does not exist', qpf_file)
	sys.exit(2)

if not acds_version: 
	# acds_version = "22.1" 	
	# print('acds version is ', acds_version)
	str_acds_ver = "/23.4.1/162" 
else:
	str_acds_ver = '/' + acds_version

if waiver_file: 
	print('waiver file is ', waiver_file)
	if not os.path.isfile(waiver_file.strip()):
		print(waiver_file + 'does not exist')
		sys.exit(2)
	abs_wvr_file = os.path.abspath(waiver_file)
	str_wvr_file = " -waiverfile " + abs_wvr_file
else:
	str_wvr_file = ''

print('getting file list from synth report')
report_file = os.path.join(report_path, proj_name + '.syn.rpt')
print('report file is ',report_file)
with open(report_file, 'r') as rpf:
	for rp_line in rpf:
		if rp_line.startswith('; Synthesis Source Files Read'):
			#print('table found')
			rpf.readline()
			rpf.readline()
			rpf.readline()
			fl_line = rpf.readline()
			while not fl_line.startswith('+-----'):
				fl = fl_line.split(';')
				fl_type = fl[2].strip();
				fl_path = fl[3].strip();
				fl_inc = fl[6:-2];
				#print(fl_line.split(';')[0].strip())
				if fl_type.startswith('User-Specified Verilog HDL File') or fl_type.startswith('User-Specified SystemVerilog HDL File'):
					for x in fl_inc:
						if x.strip():
							sources_files_list.append(os.path.join(abs_file_path, x.strip()))
					sources_files_list.append(fl_path)
				#if fl_type.startswith('User-Specified SystemVerilog HDL File'):
					#sources_files_list.append(fl_path)
				fl_line = rpf.readline()
			break


if bbox:
	print('blackbox modules ', bbox)
if bbox_file:
	abs_bbox_file = [os.path.abspath(bbxf) for bbxf in bbox_file]
if ignore_file:
	abs_ignore_file = [os.path.abspath(igxf) for igxf in ignore_file]


#get current directory
directory = os.getcwd()
sub_dir = directory+'/lint'+date+time
	

#create seed specific sub dir and
try:
	os.makedirs(sub_dir)
except:
	print('can not create sub-directory lint')
	sys.exit(1)
	
#change to sub directory
try:
	os.chdir(sub_dir)
except:
	print('can not change working directory')
	sys.exit(1)

altera_file = '$QUARTUS_ROOTDIR/eda/sim_lib/altera_mf.v'
altera_file1 = '$QUARTUS_ROOTDIR/eda/sim_lib/altera_lnsim.sv'

if len(sources_files_list)==0:
	print('No source files found in the project')
	sys.exit(2)
else:
	with open(flist_path, 'w') as flp:
		for src in sources_files_list:
			flp.write(src + '\n')
	print('sources list file at:', flist_path)

	
combined_sources_list = os.path.join(sub_dir,'rtl.f')
with open(combined_sources_list, 'w') as rtlf:
	for source in sources_files_list:
		rtlf.write(source)
		rtlf.write('\n')
	rtlf.write(altera_file)		#altera_file_cp)
	# rtlf.write('\n')
	# rtlf.write(altera_file1)

	
with open('stop_file.tcl','w') as stop_file:
	if bbox:
		bbox_string = "set_option stop {"
		for bm in bbox:
			bbox_string = bbox_string + bm + " " 
		stop_file.write(bbox_string +"}\n")
	if len(bbox_file)!=0:
		for bf in abs_bbox_file:
			with open(bf,'r') as bbf:
				bbx_lines = bbf.readlines()
				for bl in bbx_lines:
					if not (bl.strip()==''): 
						stop_file.write("set_option stop {"+bl.strip()+"}\n")
	if len(ignore_file)!=0:
		for ig in abs_ignore_file:
			with open(ig,'r') as igf:
				igf_lines = igf.readlines()
				for il in igf_lines:
					if not (il.strip()==''): 
						stop_file.write("set_option ignorefile {"+il.strip()+"}\n")
	stop_file.write("set_option stopfile {altera_mf.v}\n")
	stop_file.write("set_option stopfile {altera_lnsim.sv}\n")
	
with open('spyglass_option.tcl','w') as options_file:
	options_file.write('set_option allow_module_override yes\n')
	options_file.write('set_option enable_fpga yes\n')
	options_file.write('set_option define QUARTUS_CDC=1\n')
	options_file.write('set_option non_lrm_options allow_assert_final\n')

if not (lsf_name_base ==''):
	lsf_name = lsf_name_base + top_module.upper()

arc_path = '/p/psg/ctools/arc/bin/arc' # shutil.which('arc')

lint_command = (arc_path + " submit"
" acdskit" + str_acds_ver +
" perl"
" atrenta_spyglass-lic/advancedCDC"
" atrenta_spyglass/O-2018.09-SP2"
" atrenta_sgmaster/2.1_cr3_1.0_ipd_2"
+lsf_name + lsf_dep +
" -- lint_check"
" -mem=64GB"
" -top " + top_module +
" -f " + combined_sources_list + 
" -bbox ./stop_file.tcl"
" -asic" 
" -lintoutdir spyglass_synth" 
" -option spyglass_option.tcl"
+ str_wvr_file +
" -local")

print(lint_command)
p = subprocess.Popen(lint_command.split())

p.wait()


 
