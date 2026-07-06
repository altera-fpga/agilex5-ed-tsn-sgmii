import re
import os
import threading
import sys
import time
import signal

cmd_pwd = 'echo $PWD'
str_pwd = os.popen(cmd_pwd).read()
str_pwd = str_pwd.strip()
str_pwd_pwd = str_pwd

classes_list_test = []
lst_threads = []
lst_list_of_missing_logs = []

if len(sys.argv) == 1:
    sys.exit("\nError :- Results dir or Testlist name missing" + "\n" + "Usage :- python regression_results.py <test_list_name> <results_dir>" + "\n" + "Ex :- python regression_results.py no_storage_sanity_regr_list tg__no_storage \n")
elif len(sys.argv) == 2:
    sys.exit("\nError :- Results dir or Testlist name missing" + "\n" + "Usage :- python regression_results.py <test_list_name> <results_dir>" + "\n" + "Ex :- python regression_results.py no_storage_sanity_regr_list tg__no_storage \n")
elif len(sys.argv) == 3:
    testlist_name = sys.argv[1]
    results_dir = sys.argv[2]

print '\n'

#Fetching the list of tests from testlist
fh_testlist = open(testlist_name, "r")
lst_list_of_tests_from_testlist = fh_testlist.readlines()
lst_list_of_tests_from_testlist = map(lambda s: s.strip(), lst_list_of_tests_from_testlist)

class total_tests_report:
    total_no_of_tests = 0
    no_of_tests_pass = 0
    no_of_tests_fail = 0
    list_of_tests = []
    list_of_tests_from_ls = []

class test_seed_report:
    test_name_with_args = ''
    test_name = ''
    total_no_of_seeds = 0
    no_of_seeds_pass = 0
    no_of_seeds_fail = 0
    test_result = ''
    list_of_seeds_pass = []
    list_of_seeds_fail = []
    list_of_fail_test_info = []
    list_of_fail_seed_numbers = []
    list_of_fail_test_errors = []
    list_of_bkt_error_signature = []
    list_of_len_of_bkt_error_signature = []
    list_of_fail_seq_names = []

output_file = results_dir[4:] + "_results.txt"
fh_results_summary = open(output_file, "w")

str_pwd = str_pwd + "/" + results_dir + "/device__SM7_PART1/qsys"

check_device_dir = os.path.exists(str_pwd)
if check_device_dir == 0:
    fh_results_summary.write("directory not found :- " + str_pwd + "\n")
    sys.exit("\ndirectory not found :- " + str_pwd + "\n")

#To get the list of tests
cmd_list_of_all_tests = 'ls -vd ' + str_pwd + '/rtl_sim_compile_only_vcs/sequence__*'
str_list_of_all_tests = os.popen(cmd_list_of_all_tests).read()
lst_list_of_all_tests = str_list_of_all_tests.split()
lst_list_of_all_tests = [string.split('/')[-1] for string in lst_list_of_all_tests]
total_tests_report_handle = total_tests_report() #Creating handle for class
total_tests_report_handle.total_no_of_tests = len(lst_list_of_all_tests)
total_tests_report_handle.list_of_tests_from_ls = lst_list_of_all_tests
total_tests_report_handle.list_of_tests = lst_list_of_tests_from_testlist

def index_containing_substring(the_list, substring):
    for i, s in enumerate(the_list):
        if substring in s:
              return i
    return -1

def get_cmd_status(each_seed, index_seed, index_test, cmd_type):
    if cmd_type == "test_info":
        cmd_test_info = 'grep -irhs "+UVM_VERBOSITY.*sim.log" ' + classes_list_test[index_test].list_of_seeds_fail[index_seed]  + 'synopsys/vcs/sim.log'
        str_test_info_temp = os.popen(cmd_test_info).read()
        str_test_info = str_test_info_temp.split()
        str_test_info = [string[1:] for string in str_test_info]
        classes_list_test[index_test].list_of_fail_test_info[index_seed] = str_test_info
        seed_index    = index_containing_substring(str_test_info,"ntb_random_seed")
        str_seed      = str_test_info[seed_index][11:]
        classes_list_test[index_test].list_of_fail_seed_numbers[index_seed] = str_seed
        temp_str_fail_seed_path = classes_list_test[index_test].list_of_seeds_fail[index_seed]
        temp_str_fail_seed_path = temp_str_fail_seed_path.split("/")
        temp_str_seq_name = temp_str_fail_seed_path[-2]
        classes_list_test[index_test].list_of_fail_seq_names[index_seed] = temp_str_seq_name

    elif cmd_type == "errors_list":
        cmd_errors_list = 'grep --max-count=3 -h \'UVM_ERROR /\|UVM_FATAL /\|UVM_FATAL @\|Error-\|UVM_ERROR: \|EV_ERROR: \' ' + classes_list_test[index_test].list_of_seeds_fail[index_seed]  + 'synopsys/vcs/sim.log'
        str_errors_list = os.popen(cmd_errors_list).read()
        list_of_errors = str_errors_list.split('\n')
        str_first_error_signature = list_of_errors[0]
        len_org_error_msg = len(str_first_error_signature)
        str_bkt_error_signature = ''.join([i for i in str_first_error_signature if not i.isdigit()]) #removing digits from error signature
        if len(str_bkt_error_signature) == 0:
            classes_list_test[index_test].list_of_bkt_error_signature[index_seed] = "UNKNOWN_ERROR - Please look into log file"
            classes_list_test[index_test].list_of_fail_test_errors[index_seed] = "UNKNOWN_ERROR - Please look into log file"
        else:
            classes_list_test[index_test].list_of_bkt_error_signature[index_seed] = str_bkt_error_signature
            classes_list_test[index_test].list_of_fail_test_errors[index_seed] = list_of_errors
        classes_list_test[index_test].list_of_len_of_bkt_error_signature[index_seed] = len(str_bkt_error_signature)


def each_test_status(each_test, index_test):
    if (classes_list_test[index_test].no_of_seeds_fail > 0):
        for index_seed, each_seed in enumerate(classes_list_test[index_test].list_of_seeds_fail, start=0):
            str_sim_log_gz = classes_list_test[index_test].list_of_seeds_fail[index_seed] + 'synopsys/vcs/sim.log.gz'
            check_sim_log_gz = os.path.exists(str_sim_log_gz)
            if (check_sim_log_gz == 1):
                cmd_gunzip_sim_log = 'gunzip -r ' + str_sim_log_gz
                gunzip_sim_log_gz = os.popen(cmd_gunzip_sim_log).read()
            else:
                str_sim_log = classes_list_test[index_test].list_of_seeds_fail[index_seed] + 'synopsys/vcs/sim.log'
                check_sim_log = os.path.exists(str_sim_log)
                if(check_sim_log == 0):
                    lst_list_of_missing_logs.append(str_sim_log + "\n")
            if (check_sim_log_gz == 1) or (check_sim_log == 1):
                t_test_info = threading.Thread(target=get_cmd_status, args=(each_seed, index_seed, index_test, "test_info"))
                t_errors_list = threading.Thread(target=get_cmd_status, args=(each_seed, index_seed, index_test, "errors_list"))
                t_test_info.start()
                t_errors_list.start()
                t_test_info.join()
                t_errors_list.join()

                
for index_test, each_test in enumerate(lst_list_of_all_tests, start=0):
    cmd_list_of_seeds = 'ls -vd ' + str_pwd + '/rtl_sim_compile_only_vcs/' + each_test + '/rtl_sim_simulate_only_vcs*'
    str_list_of_seeds = os.popen(cmd_list_of_seeds).read()
    lst_list_of_seeds_per_test = str_list_of_seeds.split()
    lst_list_of_seeds_per_test = [string.split('/')[-1] for string in lst_list_of_seeds_per_test]
    each_test_handle = each_test
    each_test_handle = test_seed_report() #Creating handle for class
    test_name_sort = each_test
    #test_name_sort = test_name_sort[test_name_sort.find('ovs'):]
    #test_name_sort = test_name_sort[:-2]  #Removing unnecessary strings from testname
    each_test_handle.test_name = test_name_sort
    each_test_handle.test_name_with_args = total_tests_report_handle.list_of_tests[index_test]
    each_test_handle.total_no_of_seeds = len(lst_list_of_seeds_per_test)
    cmd_list_of_seeds_pass = 'find ' + str_pwd + '/rtl_sim_compile_only_vcs/' + each_test + '/rtl_sim_simulate_only_vcs*/* -name pass'
    str_list_of_seeds_pass = os.popen(cmd_list_of_seeds_pass).read()
    lst_list_of_seeds_pass = str_list_of_seeds_pass.split()
    lst_list_of_seeds_pass = [sub[ : -4] for sub in lst_list_of_seeds_pass]
    cmd_list_of_seeds_fail = 'find ' + str_pwd + '/rtl_sim_compile_only_vcs/' + each_test + '/rtl_sim_simulate_only_vcs*/* -name fail'
    str_list_of_seeds_fail = os.popen(cmd_list_of_seeds_fail).read()
    lst_list_of_seeds_fail = str_list_of_seeds_fail.split()
    lst_list_of_seeds_fail = [sub[ : -4] for sub in lst_list_of_seeds_fail]
    each_test_handle.no_of_seeds_pass = len(lst_list_of_seeds_pass)
    each_test_handle.no_of_seeds_fail = len(lst_list_of_seeds_fail)
    each_test_handle.list_of_seeds_pass = lst_list_of_seeds_pass
    each_test_handle.list_of_seeds_fail = lst_list_of_seeds_fail
    classes_list_test.append(each_test_handle)

fail_count = 0
pass_count = 0
for index_test, each_test in enumerate(lst_list_of_all_tests, start=0):
    if (classes_list_test[index_test].no_of_seeds_fail > 0):
        fail_count = fail_count + 1
    elif (classes_list_test[index_test].no_of_seeds_pass > 0):
        pass_count = pass_count + 1

fail_seed_count = 0
pass_seed_count = 0
total_seed_count = 0
missing_logs_count = 0
for index_test, each_test in enumerate(lst_list_of_all_tests, start=0):
    fail_seed_count = fail_seed_count + classes_list_test[index_test].no_of_seeds_fail 
    pass_seed_count = pass_seed_count + classes_list_test[index_test].no_of_seeds_pass
total_seed_count = pass_seed_count + fail_seed_count

total_tests_report_handle.no_of_tests_pass = pass_count
total_tests_report_handle.no_of_tests_fail = fail_count
missing_logs_count = len(lst_list_of_missing_logs)

for index_test, each_test in enumerate(lst_list_of_all_tests, start=0):
    if (classes_list_test[index_test].no_of_seeds_fail > 0):
        no_of_seeds_failed = len(classes_list_test[index_test].list_of_seeds_fail)
        classes_list_test[index_test].list_of_fail_test_info = [-1] *  no_of_seeds_failed
        classes_list_test[index_test].list_of_fail_seed_numbers = [-1] * no_of_seeds_failed
        classes_list_test[index_test].list_of_fail_test_errors = [-1] * no_of_seeds_failed
        classes_list_test[index_test].list_of_bkt_error_signature = [-1] * no_of_seeds_failed
        classes_list_test[index_test].list_of_fail_seq_names = [-1] * no_of_seeds_failed
        classes_list_test[index_test].list_of_len_of_bkt_error_signature = [-1] * no_of_seeds_failed

for index_test, each_test in enumerate(lst_list_of_all_tests, start=0):
    t=threading.Thread(target=each_test_status, args=(each_test, index_test,))
    lst_threads.append(t)

for begin in lst_threads:
    begin.start()

for wait in lst_threads:
    wait.join()

#For Debug purpose
for index_test, each_test in enumerate(lst_list_of_all_tests, start=0):
    if (classes_list_test[index_test].no_of_seeds_fail > 0):
        for index_seed, each_seed in enumerate(classes_list_test[index_test].list_of_seeds_fail, start=0):
            pass
            #print classes_list_test[index_test].list_of_fail_test_info[index_seed]
            #print classes_list_test[index_test].list_of_bkt_error_signature[index_seed]
            #print classes_list_test[index_test].list_of_fail_seed_numbers[index_seed]
            #print classes_list_test[index_test].test_name
            #print classes_list_test[index_test].list_of_fail_seq_names[index_seed]
            #print classes_list_test[index_test].list_of_len_of_bkt_error_signature[index_seed]
            #print classes_list_test[index_test].list_of_fail_test_errors[index_seed]
            #print str(classes_list_test[index_test].list_of_len_of_bkt_error_signature[index_seed]) + "---" + str(classes_list_test[index_test].list_of_bkt_error_signature[index_seed])

passing_seeds_l = "(Passing seeds:-" + str(pass_seed_count) + "/" + str(total_seed_count + missing_logs_count) + ")"
failing_seeds_l = "(Failing seeds:-" + str(fail_seed_count) + "/" + str(total_seed_count + missing_logs_count) + ")"
missing_logs_count_l    = "(logs missing:-" + str(missing_logs_count) + "/" + str(total_seed_count + missing_logs_count) + ")" + "\n"

print ("\nResults Directory :- " + str_pwd)
print("\n\n------TEST RUN STATUS-----------------\n")
print("Total Tests   : " + str(total_tests_report_handle.total_no_of_tests))
print("No: of passed : " + str(total_tests_report_handle.no_of_tests_pass))
print("No: of failed : " + str(total_tests_report_handle.no_of_tests_fail))
print ("\n")
sys.stdout.write('{:<23s}{:<23s}{:<19s}'.format(passing_seeds_l,failing_seeds_l,missing_logs_count_l))
print("---------------------------------------\n")

#fh_results_summary.write ("\nResults Directory :- " + str_pwd)
fh_results_summary.write("\n\n------TEST RUN STATUS-----------------\n")
fh_results_summary.write("Total Tests   : " + str(total_tests_report_handle.total_no_of_tests) + "\n")
fh_results_summary.write("No: of passed : " + str(total_tests_report_handle.no_of_tests_pass) + "\n")
fh_results_summary.write("No: of failed : " + str(total_tests_report_handle.no_of_tests_fail) + "\n")
fh_results_summary.write("\n")
fh_results_summary.write('{:<23s}{:<23s}{:<19s}'.format(passing_seeds_l,failing_seeds_l,missing_logs_count_l))
fh_results_summary.write("---------------------------------------\n")

for index_test, each_test in enumerate(lst_list_of_all_tests, start=0):
    if (classes_list_test[index_test].no_of_seeds_fail > 0):
        classes_list_test[index_test].test_result = "FAIL"
    elif (classes_list_test[index_test].no_of_seeds_pass > 0):
        classes_list_test[index_test].test_result = "PASS"

sys.stdout.write("\n\n")
sys.stdout.write('{:<10s}{:<20s}{:<25s}{:<25s}{:<60s}'.format("Result", "Total Seeds:", "No: of seeds Passed:", "No: of seeds Failed:", "                  Test Name",))
sys.stdout.write("\n")
sys.stdout.write('{:<10s}{:<20s}{:<25s}{:<25s}{:<60s}'.format("------", "-------------", "--------------------", "---------------------","----------------------------------------------"))
sys.stdout.write("\n")

fh_results_summary.write("\n\n")
fh_results_summary.write('{:<10s}{:<20s}{:<25s}{:<25s}{:<60s}'.format("Result", "Total Seeds:", "No: of seeds Passed:", "No: of seeds Failed:", "                  Test Name",))
fh_results_summary.write("\n")
fh_results_summary.write('{:<10s}{:<20s}{:<25s}{:<25s}{:<60s}'.format("------", "-------------", "--------------------", "---------------------","----------------------------------------------"))
fh_results_summary.write("\n")

for index_test, each_test in enumerate(lst_list_of_all_tests, start=0):
    sys.stdout.write('{:<10s}{:<20s}{:<25s}{:<25s}{:<60s}'.format(str(classes_list_test[index_test].test_result), "     "+str(classes_list_test[index_test].no_of_seeds_fail + classes_list_test[index_test].no_of_seeds_pass), "        "+str(classes_list_test[index_test].no_of_seeds_pass), "        "+str(classes_list_test[index_test].no_of_seeds_fail), str(classes_list_test[index_test].test_name_with_args),))
    sys.stdout.write("\n")
    fh_results_summary.write('{:<10s}{:<20s}{:<25s}{:<25s}{:<60s}'.format(str(classes_list_test[index_test].test_result), "     "+str(classes_list_test[index_test].no_of_seeds_fail + classes_list_test[index_test].no_of_seeds_pass), "        "+str(classes_list_test[index_test].no_of_seeds_pass), "        "+str(classes_list_test[index_test].no_of_seeds_fail), str(classes_list_test[index_test].test_name_with_args),))
    fh_results_summary.write("\n")

#Bucketizing the failures
lst_list_of_unique_bkt_lengths = []

for index_test, each_test in enumerate(lst_list_of_all_tests, start=0):
    if (classes_list_test[index_test].no_of_seeds_fail > 0):
        for index_seed, each_seed in enumerate(classes_list_test[index_test].list_of_seeds_fail, start=0):
            bkt_len_temp = classes_list_test[index_test].list_of_len_of_bkt_error_signature[index_seed]
            if bkt_len_temp in lst_list_of_unique_bkt_lengths:
                pass
            else:
                lst_list_of_unique_bkt_lengths.append(bkt_len_temp)

fh_results_summary.write("\n\n")
lst_bkt_flag = []
no_of_tests_for_each_bkt = []
for index,each_test in enumerate(lst_list_of_unique_bkt_lengths, start=0):
    lst_bkt_flag.append(0)
    no_of_tests_for_each_bkt.append(0)

for index_test, each_test in enumerate(lst_list_of_all_tests, start=0):
    if (classes_list_test[index_test].no_of_seeds_fail > 0):
        for index_seed, each_seed in enumerate(classes_list_test[index_test].list_of_seeds_fail, start=0):
            for index_seed1, each_seed_1 in enumerate(lst_list_of_unique_bkt_lengths, start=0):
                if classes_list_test[index_test].list_of_len_of_bkt_error_signature[index_seed] == lst_list_of_unique_bkt_lengths[index_seed1]:
                    no_of_tests_for_each_bkt[index_seed1] = no_of_tests_for_each_bkt[index_seed1] + 1               

fh_results_summary.write("Logs Path:-\n")
fh_results_summary.write(str_pwd + "\n\n\n")

if total_tests_report_handle.no_of_tests_fail > 0:
    fh_results_summary.write("**********************************************************************************************************************\n")
    fh_results_summary.write("                                           Failing Buckets:-                                                          \n")
    fh_results_summary.write("**********************************************************************************************************************\n")
for index_unique, each_test_unique in enumerate(lst_list_of_unique_bkt_lengths, start=0):
    for index_test, each_test in enumerate(lst_list_of_all_tests, start=0):
        if (classes_list_test[index_test].no_of_seeds_fail > 0):
            for index_seed, each_seed in enumerate(classes_list_test[index_test].list_of_seeds_fail, start=0):
                if classes_list_test[index_test].list_of_len_of_bkt_error_signature[index_seed] == lst_list_of_unique_bkt_lengths[index_unique]:
                    if lst_bkt_flag[index_unique] == 0:
                        fh_results_summary.write("\n[bkt_count = " + str(no_of_tests_for_each_bkt[index_unique]) + "] :- ")
                        fh_results_summary.write(str(classes_list_test[index_test].list_of_bkt_error_signature[index_seed]) + "\n")
                        fh_results_summary.write("-------------------------------------------------------------------------------------------------\n")
                        fh_results_summary.write('{:<10s}{:<3s}{:<5s}{:<1s}{:<15s}{:<1s}'.format(classes_list_test[index_test].test_name_with_args, " --", classes_list_test[index_test].list_of_fail_seed_numbers[index_seed], "  (" , classes_list_test[index_test].test_name, ")"))
                        fh_results_summary.write("\n")
                        lst_bkt_flag[index_unique] = 1
                    
                    else:
                        fh_results_summary.write('{:<10s}{:<3s}{:<5s}{:<1s}{:<15s}{:<1s}'.format(classes_list_test[index_test].test_name_with_args, " --", classes_list_test[index_test].list_of_fail_seed_numbers[index_seed], "  (" , classes_list_test[index_test].test_name, ")"))
                        fh_results_summary.write("\n")
    fh_results_summary.write("\n")


fh_results_summary.write("\n\n\n")
if total_tests_report_handle.no_of_tests_fail > 0:
    fh_results_summary.write("**********************************************************************************************************************\n")
    fh_results_summary.write("                                       Logs path of all failing Seeds:-                                               \n")
    fh_results_summary.write("**********************************************************************************************************************\n")
    for index_test, each_test in enumerate(lst_list_of_all_tests, start=0):
        if (classes_list_test[index_test].no_of_seeds_fail > 0):
            fh_results_summary.write("\n" + "---------------------" +classes_list_test[index_test].test_name_with_args + "---------------------" + "\n")
            fh_results_summary.write(classes_list_test[index_test].test_name + "\n")
            for index_seed, each_seed in enumerate(classes_list_test[index_test].list_of_seeds_fail, start=0):
                #fh_results_summary.write(classes_list_test[index_test].list_of_fail_seed_numbers[index_seed] + ",  ")
                #fh_results_summary.write(classes_list_test[index_test].list_of_fail_seq_names[index_seed] + "\n")
                fh_results_summary.write(classes_list_test[index_test].list_of_seeds_fail[index_seed] + "synopsys/vcs/sim.log" + "\n")
