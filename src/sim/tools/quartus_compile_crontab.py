# quartus compile seed sweep from .qsf and .qpf files

import getopt
import os
import sys
import shutil
import subprocess
from datetime import datetime as dt
import time as tt

proj_name = ''
file_path = ''
top_module = ''
environ_file = ''
date = dt.now().strftime('_%Y_%m_%d')
time = dt.now().strftime('_%H_%M')
SEED_LOW=1
SEED_HIGH=10
device='A5ED065BB32AE5SR0'
lsf_name_base = ''
lsf_name_base_ip = ''
lsf_dep = ''
lsf_name=''
lsf_name_ip = ''
lsf_dep_ip = ''
acds_version = ''
system_memory=64000

try:
	opts, args = getopt.getopt(sys.argv[1:],"p:f:e:w:v:C:",["project=", "file_path=", "environ=","waiver_file=","acds_version=","crontab="])
except getopt.GetoptError:
	print('quartus_compile_crontab.py -p <project_name> -f <files_path> -t <top_module> -e <environ_setup_file> -w <waiver_file> -v <acds_version>')
	sys.exit(2)
	
for opt, arg in opts:
	if opt in ("-p", "--project_name"):
		proj_name = arg
	elif opt in ("-f", "--files_path"):
		file_path = arg
	elif opt in ("-w", "--waiver_file"):
		waiver_file = arg
	elif opt in ("-e", "--environ"):
		environ_file = arg
	elif opt in ("-v", "--acds_version"):
		acds_version = arg
	elif opt in ("-C", "--crontab"):
		lsf_name_base = " lsf_name=TSN3_QRTS"+ date
		lsf_name_base_ip = " lsf_name=TSN3_IP"+ date
		lsf_dep_ip = " lfs_w=\"done(\'TSN3_SYNC"+ date+ "\')\""
		lsf_dep = " lfs_w=\"done(\'TSN3_IP"+ date+ "\')\""
		SEED_HIGH = SEED_LOW + 9
		
if (proj_name.strip()==''):
	print('-p <project_name> required')
	sys.exit(2)

if environ_file:
	with open(environ_file, 'r') as ef:
		for setting in ef:
			(var,val)=tuple(setting.split('='))
			os.environ[var.strip()]=os.path.expandvars(val.strip())

if (acds_version.strip()==''): 
	acds_version = "23.4.1/162" 	
	print('acds version is ', acds_version)
str_acds_ver = '/' + acds_version

if (file_path.strip()==''):
	print('-f <files_path> required')
	sys.exit(2)

#get current directory
directory = os.getcwd()

# go to project directory
project_path = os.path.abspath(os.path.expandvars(file_path))

try:
	os.chdir(project_path)
except:
	print('can not change working directory')
	sys.exit(1)

abs_file_path = project_path + '/'
print('project path is ', abs_file_path)

qsf_file = abs_file_path + proj_name + '.qsf'
if os.path.isfile(qsf_file) : 
	with open(qsf_file, 'r+') as f_qsf:
		qsf_lines = f_qsf.readlines()
		f_qsf.write('\nset_global_assignment -name PROJECT_IP_REGENERATION_POLICY ALWAYS_REGENERATE_IP')
else : 
	print('project file does not exist', qsf_file)
	sys.exit(2)
	
qpf_file = abs_file_path + proj_name + '.qpf'
if os.path.isfile(qpf_file) : 
	with open(qpf_file, 'r') as f_qpf:
		qpf_lines = f_qpf.readlines()
else : 
	print('project file does not exist', qpf_file)
	sys.exit(2)

arc_path = '/p/psg/ctools/arc/2019.1/bin/arc' #shutil.which('arc')
ip_gen_command = (arc_path+ " submit"
	" acdskit" + str_acds_ver +
	" mem=" + str(system_memory) +
	lsf_name_base_ip + lsf_dep_ip +
	" -- quartus_sh"
	" --flow compile"
	" " + proj_name +
	" -start ipgenerate -end synthesis")
	
print(ip_gen_command)
p = subprocess.Popen(ip_gen_command.split())
p.wait()

tt.sleep(4000)



#move back to original dir
try:
	os.chdir(directory)
except:
	print('can not change working directory')
	sys.exit(1)
	
sub_dir = directory+'/synth' + date + time #device+'_seed'+str(seed)

#create seed specific sub dir and
try:
	os.makedirs(sub_dir)
except:
	print('can not create sub-directory synth.')
	sys.exit(1)
	
	
#change to sub directory
try:
	os.chdir(sub_dir)
except:
	print('can not change working directory')
	sys.exit(1)


for seed in range(SEED_LOW, SEED_HIGH+1):

	#current directory is sub_dir
	sub_dir_seed = sub_dir +'/' + device +'_seed'+ str(seed)
	
	#create seed specific sub dir and
	try:
		os.makedirs(sub_dir_seed)
	except:
		print('can not create sub-directory ' + sub_dir_seed)
		sys.exit(1)
		
		
	#change to sub directory
	try:
		os.chdir(sub_dir_seed)
	except:
		print('can not change working directory to ' + sub_dir_seed)
		sys.exit(1)
	
	
	qsf_file_seed = sub_dir_seed + '/' + proj_name + '.qsf'
	qpf_file_seed = sub_dir_seed + '/' + proj_name + '.qpf'
	# copy qpf & qsf filesand modify seed 
	try:
		# shutil.copyfile(qsf_file, qsf_file_seed) #, *, follow_symlinks=True)
		shutil.copyfile(qpf_file, qpf_file_seed)
	except:
		print('can not copy project files')
		
	with open(qsf_file_seed, 'w') as f_qsf_s:
		for line in qsf_lines:
			line_w = ''			
			line_words = line.split()
			if line.startswith('set_global_assignment -name'):
				if line_words[2].find('_FILE')!=-1:
					line_w = line_words[0]  +' ' + line_words[1] + ' '+ line_words[2] + ' ' + abs_file_path +  line_words[3] + '\n'
				elif line_words[2].find('_SEARCH_PATHS')!=-1:
					search_paths = line_words[3].replace('"','').split(';')
					for sp in search_paths:
						line_w = line_w + line_words[0]  +' ' + line_words[1] + ' '+ line_words[2] + ' "' + abs_file_path + sp + '"\n'
				elif line_words[2].find('IP_REGENERATION')!=-1:
					line_w =''
				else:
					line_w = line
			f_qsf_s.write(line_w)
			# idx_file = line.find('_FILE')
			# idx_path = line.find('_PATH')
			# if line.find('_FILE')!= -1:
				# mod_line = line.split('_FILE')
				# f_qsf_s.write(abs_file_path + "line.split('_FILE')[-1].strip()"
		f_qsf_s.write("set_global_assignment -name SEED " + str(seed) + "\n")
		f_qsf_s.write("set_global_assignment -name PROJECT_IP_REGENERATION_POLICY NEVER_REGENERATE_IP\n")
	
	if not (lsf_name_base ==''):
		lsf_name = lsf_name_base + top_module.upper() + device + str(seed)
		#if (seed != SEED_LOW):
		#	lsf_dep = " lfs_w=\"done(\'PTPGB_SYNC"+ date+ top_module.upper() + device + str(SEED_LOW) + "\')\""

	arc_path = '/p/psg/ctools/arc/2019.1/bin/arc' #shutil.which('arc')
 
	compile_command = (arc_path+ " submit"
	" acdskit" + str_acds_ver +
	" mem=" + str(system_memory) +
	lsf_name + lsf_dep +
	" -- quartus_sh"
	" --flow compile"
	" " + proj_name +
	" -end sta_signoff")
	
	print(compile_command)
	p = subprocess.Popen(compile_command.split())
	p.wait()
	
	#move back to original dir
	try:
		os.chdir(sub_dir)
	except:
		print('can not change working directory')
		sys.exit(1)
	




	