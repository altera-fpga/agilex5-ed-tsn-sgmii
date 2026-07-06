#!/bin/bash

cd $TSN_HOME/../hw

echo "I'm in here"
pwd
ls

make clean
make config
make TSN_CONCURRENT=1 generate_from_tcl

tree    

echo "Makefile successfully ran!"
