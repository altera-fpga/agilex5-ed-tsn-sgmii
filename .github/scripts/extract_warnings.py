import sys
import os
import argparse

def is_border(line):
    return line.strip().startswith('+') and '-' in line

def is_rule_header(line):
    s = line.strip()
    return s.startswith(';') and ' - ' in s and s.endswith(';')

def is_table_header(line):
    s = line.strip()
    return s.startswith(';') and ';' in s

def extract_high_critical_drc_violations(input_file, drc_outfile):
    with open(input_file, 'r') as infile:
        lines = infile.readlines()

    n = len(lines)
    idx = 0
    found_any = False

    while idx < n:
        # Find start of section: border + rule header
        if is_border(lines[idx]) and idx+1 < n and is_rule_header(lines[idx+1]):
            rule_header = lines[idx+1].strip('; \n')

            # Look for Severity above the border
            severity = None
            search_idx = idx - 1
            while search_idx >= 0:
                line = lines[search_idx]
                if 'Severity:' in line:
                    severity = line.split(':', 1)[-1].strip()
                    break
                if is_border(line):
                    break
                search_idx -= 1

            print(f"Section: {rule_header}")
            print(f"  Severity: {severity}")

            # Find the violation table: look for first border after rule header
            table_border_idx = idx+2
            while table_border_idx < n and not is_border(lines[table_border_idx]):
                table_border_idx += 1
            table_idx = table_border_idx + 1

            # Find table header line to locate "Waived" column index
            while table_idx < n and not is_table_header(lines[table_idx]):
                table_idx += 1
            if table_idx >= n:
                idx = table_idx
                continue
            table_header_line = lines[table_idx]
            table_idx += 1  # Move to the next line after header

            # Parse table header to find 'Waived' column index
            # (strip all leading/trailing semicolons, then split)
            header_fields = [f.strip() for f in table_header_line.strip().strip(';').split(';')]
            try:
                waived_col_idx = header_fields.index('Waived')
            except ValueError:
                waived_col_idx = None

            # Move past the border line after header
            while table_idx < n and is_border(lines[table_idx]):
                table_idx += 1

            violation_lines = []
            while table_idx < n and not is_border(lines[table_idx]):
                s = lines[table_idx].strip()
                if s.startswith(';') and len(s) > 1:
                    # Split fields robustly (strip all leading/trailing semicolons, then split)
                    fields = [f.strip() for f in lines[table_idx].strip().strip(';').split(';')]
                    if waived_col_idx is not None and len(fields) > waived_col_idx:
                        waived_val = fields[waived_col_idx]
                        if waived_val.upper() == 'Y':
                            table_idx += 1
                            continue  # Skip waived violations
                    violation_lines.append(lines[table_idx])
                table_idx += 1

            print(f"  Violations found (not waived): {len(violation_lines)}")

            if severity and (severity.lower().startswith('high') or severity.lower().startswith('critical')):
                if violation_lines:
                    found_any = True
                    print(f"  --> Written to DRC output file.")
                    drc_outfile.write(f'Rule: {rule_header}\n')
                    drc_outfile.write(f'Severity: {severity}\n')
                    drc_outfile.write('Violated Paths:\n')
                    for l in violation_lines:
                        drc_outfile.write(l)
                    drc_outfile.write('\n' + '-'*80 + '\n')
            next_section_idx = table_idx
            while next_section_idx < n:
                if is_border(lines[next_section_idx]) and next_section_idx+1 < n and is_rule_header(lines[next_section_idx+1]):
                    break
                next_section_idx += 1
            idx = next_section_idx
        else:
            idx += 1

    if not found_any:
        print("\nNo high/critical rules with unwaived violation lines found.")
    else:
        print("\nDone! Filtered rules and unwaived violated paths written to DRC output.")
        
def extract_critical_synthesis_warnings(synth_file, synth_outfile):
    print(f"\nProcessing synthesis report: {synth_file}")
    critical_count = 0
    total_lines = 0
    with open(synth_file, 'r') as infile:
        lines = infile.readlines()
    for line in lines:
        total_lines += 1
        if 'Critical' in line:
            # Skip summary/statistics lines like the one specified
            if 'Design Assistant Results' in line and 'Critical severity rules issued violations' in line:
                continue
            if critical_count == 0:
                synth_outfile.write('Critical Synthesis Warnings:\n')
            synth_outfile.write(line)
            critical_count += 1
    print(f"Synthesis lines read: {total_lines}")
    print(f"Critical synthesis warnings found: {critical_count}")
    if critical_count == 0:
        print("No critical synthesis warnings found.")
    else:
        print("Critical synthesis warnings written to synthesis output.")

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Extract high/critical DRC and critical synthesis warnings from reports.")
    parser.add_argument('--drc', help='Input DRC report file')
    parser.add_argument('--synth', help='Input synthesis report file')
    parser.add_argument('--drc-output', help='Output file for DRC violations (default: drc_output.txt)')
    parser.add_argument('--synth-output', help='Output file for synthesis warnings (default: synth_output.txt)')

    args = parser.parse_args()

    # Check at least one input
    if not args.drc and not args.synth:
        print("ERROR: You must provide at least one input file with --drc and/or --synth.")
        parser.print_help()
        sys.exit(1)

    # Set default output names if not specified
    drc_output = args.drc_output if args.drc_output else "drc_output.txt"
    synth_output = args.synth_output if args.synth_output else "synth_output.txt"

    if args.drc:
        if not os.path.isfile(args.drc):
            print(f"ERROR: DRC input file '{args.drc}' not found.")
            sys.exit(1)
        print(f"Writing filtered DRC results to: {drc_output}")
        with open(drc_output, 'w') as drc_outfile:
            extract_high_critical_drc_violations(args.drc, drc_outfile)

    if args.synth:
        if not os.path.isfile(args.synth):
            print(f"ERROR: Synthesis input file '{args.synth}' not found.")
            sys.exit(1)
        print(f"Writing filtered synthesis results to: {synth_output}")
        with open(synth_output, 'w') as synth_outfile:
            extract_critical_synthesis_warnings(args.synth, synth_outfile)

    print("\nAll processing complete.")
