import datetime
import sys
import subprocess
import re
import os
import gzip
import shutil

def get_current_datetime(format_str="%d%m%Y_%H_%M"):
    now = datetime.datetime.now()
    return now.strftime(format_str)

# extracts regex based on named groups
def extract_group_regex(regexpr, string):
    match = re.match(regexpr, string)
    if match:
        return match.groupdict()
    else:
        return {}

def debug_print(*args):
    print(*args)

def run_command(command):
    return os.popen(command).read()

def run_cmd_with_yield(cmd):
    popen = subprocess.Popen(cmd, stdout=subprocess.PIPE, universal_newlines=True)
    for stdout_line in iter(popen.stdout.readline, ""):
        yield stdout_line 
    return_code = popen.wait()
    debug_print(f"Return code is {return_code}")
    # if return_code:
    #     raise subprocess.CalledProcessError(return_code, cmd)

def run_cmd_with_regex_trigger(cmd, regexpr, callback_fn):
    cmd_output = []
    for line in run_cmd_with_yield(cmd):
        cmd_output.append(line)
        debug_print(line.rstrip())
        match = re.search(regexpr, line)
        if match:
            callback_fn(match)
    return join_lines(cmd_output)

def get_work_week():
    week_num = run_command("TZ=America/Los_Angeles date +%U").strip()
    if int(week_num) < 10:
        week_num = run_command("TZ=America/Los_Angeles date +%U | cut -c 2-").strip()
    day = run_command("TZ=America/Los_Angeles date +%u").strip()
    return "ww" + week_num + "." + day

def cd_up(path, n):
    for i in range(n):
        path = os.path.dirname(path)
    return path

def recursive_find_file(directory, target_filename, relative=True):
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file == target_filename:
                yield (os.path.relpath(root, start=os.getcwd()), file)

def gunzip(filepath):
    with gzip.open(filepath, 'rb') as f_in:
        with open(filepath.replace(".gz", ""), 'wb') as f_out:
            shutil.copyfileobj(f_in, f_out)

class open_gz_safe():
    def __init__(self, file_name, mode):
        if os.path.exists(f"{file_name}.gz"):
            gunzip(f"{file_name}.gz")
        self.file_name = file_name
        self.mode = mode
        self.file = None
     
    def __enter__(self):
        debug_print(f"Opening {self.file_name}")
        try:
            self.file = open(self.file_name, self.mode)
        except FileNotFoundError:
            return None
        return self.file
 
    def __exit__(self, *args):
        if self.file:
            self.file.close()

def tree_dict(key_list, final_val={}):
    tree_dict = final_val
    for key in reversed(key_list):
        tree_dict = { key: tree_dict }
    return tree_dict

def tree_insert(target_dict, key_list, final_val={}):
    dict_ptr = target_dict
    for i, key in enumerate(key_list[:-1]):
        if key in dict_ptr:
            dict_ptr = dict_ptr[key]
            continue
        else:
            dict_ptr[key] = tree_dict(key_list[i+1:], final_val)
            break
    else:
        dict_ptr[key_list[-1]] = final_val
    

def collapse_paragraph(lines, num_shown=10, indent=""):
    if len(lines) > num_shown:
        return join_lines(lines[:num_shown], indent) + f"\n{indent}and {len(lines)-num_shown} more ..........."
    else:
        return join_lines(lines, indent)

def join_lines(lines, joiner="\n", indent=""):
    return indent + f"{joiner}{indent}".join(lines)

def format_as_fraction_percent(numerator, denominator):
    return f"{numerator} / {denominator} [{round(numerator / denominator * 100, 2)} %]"