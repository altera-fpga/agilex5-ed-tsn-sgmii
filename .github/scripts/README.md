# 📊 `extract_warnings.py` README

This script, `extract_warnings.py`, is a Python utility designed to parse and filter large electronic design automation (EDA) report files, specifically Design Rule Check (DRC) reports and Synthesis reports. It extracts only the most critical information—High/Critical DRC violations and Critical Synthesis Warnings—into separate, concise output files for easier review.

-----

## 🚀 Getting Started

### Prerequisites

  * Python 3.x
      * The script uses standard Python libraries and requires no external packages.

### Usage

The script is executed from the command line and uses command-line arguments to specify the input and output files. You must provide at least one input file (`--drc` or `--synth`).

```bash
python3 extract_warnings.py [OPTIONS]
```

### Options

| Argument | Description | Default Output |
| :--- | :--- | :--- |
| `--drc <file>` | Input DRC report file to be processed. | N/A |
| `--synth <file>` | Input Synthesis report file to be processed. | N/A |

### Examples

1. Filter a DRC report only:

```bash
python3 extract_warnings.py --drc  a5ed065bb32ae6sr0.tq.drc.signoff.rpt
```

*(The output will be written to `drc_output.txt`)*

2. Filter a Synthesis report only:

```bash
python3 extract_warnings.py --synth a5ed065bb32ae6sr0.syn.rpt
```

*(The output will be written to `synth_output.txt`)*

3. Filter both reports simultaneously:

```bash
python3 extract_warnings.py --drc a5ed065bb32ae6sr0.tq.drc.signoff.rpt --synth a5ed065bb32ae6sr0.syn.rpt
```

-----

## 🔍 Script Functionality

### 1\. DRC Violation Extraction (`extract_high_critical_drc_violations`)

This function processes the input DRC report to find sections with the following characteristics:

  * A section boundary (lines starting with `+` and containing `-`).
  * A rule header (lines starting with `;` and containing `-`).
  * A Severity tag preceding the section that is explicitly "High" or "Critical" (case-insensitive and prefix-matched).

For each high or critical rule found, the script extracts the rule name, severity, and all subsequent violation path lines (lines starting with `;` within the table) until the next border is hit.

The output file format will be:

```
Rule: <RULE NAME>
Severity: <SEVERITY LEVEL>
Violated Paths:
<Violation Line 1>
<Violation Line 2>
...
--------------------------------------------------------------------------------
```

### 2\. Critical Synthesis Warning Extraction (`extract_critical_synthesis_warnings`)

This function performs a line-by-line scan of the input Synthesis report. It extracts and writes every line that contains the word "Critical" to the synthesis output file.

Note: It includes logic to skip specific summary or statistical lines that contain "Critical" but are not actual, actionable warnings (e.g., specific "Design Assistant Results" summary lines).

## ✅ Exit Status & Summary

After processing is complete, the newly included "DRC Done" field in the HW build script should update it as follows 

| Output Condition | Status Message | Meaning |
| :--- | :--- | :--- |
| **`drc_output.txt` is empty** | **DRC Test: PASS** | No high or critical DRC violations were found. |
| **`drc_output.txt` is NOT empty** | **DRC Test: FAIL** | One or more high or critical DRC violations were found. |
| **`synth_output.txt` is empty** | **Synth Critical Warnings: PASS** | No critical synthesis warnings were found. |
| **`synth_output.txt` is NOT empty** | **Synth Critical Warnings: FAIL** | One or more critical synthesis warnings were found. |


