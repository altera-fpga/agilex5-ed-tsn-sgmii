# This directory contains sim testbench and tests

**Note** This directory is not shipping externally since simulations use engineering internal infra

Steps to run a test

1. Set up ARC resources
   ```bash
   source ../../.github/env.sh
    ```
   
2. Set up PATH for regtest
   ```bash
   source ../../.github/setup.sh
    ```
   
3. Run a test, for example
    ```bash
    test - reg_exe --testname=eth_gdr_base_test --sequence=tsn_sanity_sequence  --uvm_verbosity=UVM_FULL --error_count=200 --dump_on=1 --xprop=1 | tee run.txt
    ```
