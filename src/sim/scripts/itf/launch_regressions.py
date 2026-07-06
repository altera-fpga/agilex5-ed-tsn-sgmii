import os
import re
from argparse import ArgumentParser
from datetime import date
from prettytable import PrettyTable
from glob import glob

from util_fn import get_current_datetime, debug_print, run_command, run_cmd_with_regex_trigger, recursive_find_file, gunzip, open_gz_safe, tree_dict, collapse_paragraph, join_lines, tree_insert, get_work_week, format_as_fraction_percent

TSN_SYS_SED_ROOT_DIR = "/nfs/site/disks/swuser_work_eloe/qshells/tsn_ghrd/p4/prototype/sm_tsn_sed"
# TSN_SYS_SED_ROOT_DIR = "/nfs/site/disks/swuser_work_eloe/qshells/22.1-174-b1ba08a5/p4/acds/prototype/ptp_sys_ed"
spetc_url = ""

class Email:

    def __init__(self, recipients, subject, body, attachment=None) -> None:
        self.recipients = recipients
        self.subject = subject
        self.body = body
        self.attachment = attachment
    
    def send(self):
        return os.system(f'mailx {"-a " + self.attachment if self.attachment else ""} -s "{self.subject}" {",".join(self.recipients)} <<< "{self.body}"')

def report_spetc_link(match):
    global spetc_url
    spetc_id = match.group("spetcid")
    spetc_link = f"https://spetc.intel.com/testsummary?testRunIds={spetc_id}"
    print(f"The spetc link is {spetc_link}")
    spetc_url = spetc_link
    Email(
        recipients=["evan.loe@intel.com"],
        subject=f"Regression started <{spetc_id}>",
        body=f"Check out the regression that started: {spetc_link}"
    ).send()

def launch_regression():
    debug_print("Launching regression now!")
    return run_cmd_with_regex_trigger(["reg_exe", "--farm", "--num_seeds=30", "--priority=80", "--monitor", "--uvm_verbosity=UVM_FULL", "--error_count=20000", "--dump_on=0", "--fsdb_on=0", "--xprop=1", "--return-file-mode=all", "--job-clean-mode=no_clean"], "The SPeTC test run ID is (?P<spetcid>[0-9]+)", report_spetc_link)

def get_itf_run_details_from_file(containing_dir):
    details = {}
    with open_gz_safe(os.path.join(containing_dir, "post_simulate_report.txt"), 'r') as details_file:
        if details_file is None:
            return details
        for line in details_file:
            key, value = line.rstrip().split(":")
            details[str(key).lower()] = value
    # check for pass or file file
    details["passed"] = os.path.isfile(f"{containing_dir}/pass")
    # TODO: parse sim log for UVM_ERROR

    return details

def get_regression_results(regr_scripts_dir):
    path_to_seq_dirs = f"{regr_scripts_dir}/device__SM7_PART1/qsys/rtl_sim_compile_only_vcs/sequence__*"
    sequences = [f for f in glob(path_to_seq_dirs)]
    summaries = {}

    for sequence in sequences:
        summaries[sequence] = {}
        with open(f'{sequence}/regression_cmd_report.txt', 'r') as f:
            summaries[sequence]["command"] = f.readline()
        
        simulations = [f for f in glob(f"{sequence}/rtl_sim_simulate_only*")]
        summaries[sequence]["seeds"] = []
        for simulation in simulations:
            itf_details = get_itf_run_details_from_file(os.path.abspath(simulation))
            summaries[sequence]["seeds"].append({
                **itf_details,
                "sim_log_path": os.path.abspath(f"{simulation}/synopsys/vcs/sim.log")
            })

    table = []
    failed_seed_logs = []
    total_passed = 0
    total_run = 0
    for sequence in summaries.values():
        testname = sequence["command"]

        seeds_passed = 0
        total_num_seeds = len(sequence["seeds"])
        passed = True

        for test in sequence["seeds"]:
            if test["passed"]:
                seeds_passed += 1
            else:
                passed = False
                failed_seed_logs.append(test["sim_log_path"])
        
        total_run += total_num_seeds
        total_passed += seeds_passed

        table.append([
            "PASS" if passed else "FAIL",
            format_as_fraction_percent(seeds_passed, total_num_seeds),
            testname
        ])

    totals = {
        "passed": total_passed,
        "failed": total_run - total_passed,
        "total": total_run
    }

    return table, failed_seed_logs, totals


def get_regression_results_new_old(regr_scripts_dir):
    failed = 0
    passed = 0
    test_details = []
    for containing_dir, filename in recursive_find_file(regr_scripts_dir, "fail"):
        if re.search("rtl_sim_simulate_only_vcs__[^\/]+$", containing_dir):
            failed += 1
            # read dump file
            itf_details = get_itf_run_details_from_file(os.path.abspath(containing_dir))
            test_details.append({
                **itf_details,
                "passed": False,
            })

    for containing_dir, filename in recursive_find_file(regr_scripts_dir, "pass"):
        if re.search("rtl_sim_simulate_only_vcs__[^\/]+$", containing_dir):
            passed += 1
            # read dump file
            itf_details = get_itf_run_details_from_file(os.path.abspath(containing_dir))
            test_details.append({
                **itf_details,
                "passed": True,
            })

    total_pass_fail = failed + passed
    if total_pass_fail < 1:
        return {"ERROR": "Failed to parse directories for regression results"}

    return {
        "failed": failed,
        "passed": passed,
        "total": total_pass_fail,
        "test_details": test_details,
    }

if __name__ == "__main__":
    parser = ArgumentParser(description="run regression script for ptp gbx")
    parser.add_argument("-c", "--cache_results", action='store_true', default=False, help="Enabling this option creates a dir specified by regr_root_dir, copied all src code there, and runs the test there")
    parser.add_argument("--regr_cache_dir", default="/nfs/site/disks/swuser_work_eloe/nightly_regr_tsn_cached", help="Specify the regr_cache_dir where cached regression runs are stored")
    parser.add_argument("-q", "--quiet", action='store_true', default=False, help="Enable email notifications")
    parser.add_argument("-s", "--skip_run", action='store_true', default=False, help="Enable email notifications")
    args = parser.parse_args()

    if not args.skip_run:
        os.environ["P4CLIENT"] = "_-nfs-site-disks-swuser_work_eloe-qshells-tsn_ghrd-p4"
        os.environ["REG_LOCAL_ROOT_DIR_PATH"] = TSN_SYS_SED_ROOT_DIR
        regr_scripts_dir = f"{TSN_SYS_SED_ROOT_DIR}/scripts/itf"
        deleted_files = run_command(f"reg_reset")
        updated_files = run_command(f"p4q sync {TSN_SYS_SED_ROOT_DIR}/...")

        # creates a copy of all src files
        if args.cache_results:
            cached_regr_dir = f"{args.regr_cache_dir}/{get_current_datetime()}"
            run_command(f"mkdir -p {cached_regr_dir}")
            debug_print("starting file copying ...")
            run_command(f"cp -r {TSN_SYS_SED_ROOT_DIR} {cached_regr_dir}")
            debug_print("done copying files!")
            os.environ["REG_LOCAL_ROOT_DIR_PATH"] = f"{cached_regr_dir}/sm_tsn_sed"
            regr_scripts_dir = f"{cached_regr_dir}/sm_tsn_sed/scripts/itf"
        
        os.chdir(regr_scripts_dir)
        debug_print(f"we are in {os.getcwd()}")
        launched_regr_output = launch_regression()

    debug_print("Regression done running")
    regr_scripts_dir = "."

    results, failed_seed_logs, totals = get_regression_results(regr_scripts_dir)
    table = PrettyTable()
    table.field_names = ["RESULT", "Seeds Passed", "Test Name"]
    table.add_rows(results)

    # align testname column to left
    table.align["Test Name"] = 'l'

    with open(f"regression_summary.txt", 'w') as f:
        f.write(str(table))
        f.write("\n\n== Failed Seed Logs ==\n")
        f.writelines(failed_seed_logs if len(failed_seed_logs) > 0 else "N/A")

    # results = get_regression_results(regr_scripts_dir)
    if totals["total"] < 1:
        Email(
            ["evan.loe@intel.com"],
            subject="error parsing results",
            body=f"Error parsing results for {spetc_url}"
        ).send()
        print("Error parsing results")
        exit()
    
    body = f"""

Overall Summary
 - PASSED {format_as_fraction_percent(totals["passed"], totals["total"])}
 - FAILED {format_as_fraction_percent(totals["failed"], totals["total"])}
 - see SPETC for details {spetc_url}

"""
    subject = f"TSN regression results for {get_work_week()}"

    email = Email(
        ["evan.loe@intel.com", "kalyani.marabathini@intel.com", "soe.myint@intel.com", "susan.tran@intel.com", "hemanth.amilineni@intel.com", "peter.dang@intel.com", "ajay.kumar.dubey@intel.com", "pradnya.joshi@intel.com", "vikas.bellamkonda@intel.com"],
        subject=subject,
        body=body,
        attachment="regression_summary.txt"
    )

    if not args.quiet:
        email.send()


