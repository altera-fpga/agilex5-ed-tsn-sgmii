Loads tsn rbfs and boots into linux. Also has additional functionality of being able to copy any additional files to the sdcard

Required files: respective tsn core.rbf, hps.rbf, and kernel itb files. You also need to have ghrd.hps.rbf 

Sample execution of script:

net_boot_linux_interact.py --power-cycle --ghrd-rbf  ghrd.hps.rbf --hps-rbf mdk_25.1.1_allfixes.hps.rbf --core-rbf mdk_25.1.1_allfixes.core.rbf --kernel-itb kernel_25.1.1_allfixes.itb --mmc-root --copy-extra-files log_843 log_848 --kernel-itb-conf board-2

Notice: If you want to copy extra files, you can do so by adding the optional argument '--copy-extra-files'. If you choose to add this argument, write in the list of files you want to copy separated by a space in between each file path

Notice: You don't have to keep all the files stored locally in the same directory that oscar_test.py and net_boot_linux_interact.py are. You can write in a relative path as well: ex. --hps-rbf ./../mdk_25.1.1_allfixes.hps.rbf 

Common error: If you get this following error when running this script: "Wrong Image Type for bootm command ERROR -91: can't get kernel image!" this means that the file has either not been copied over to sdcard properly, or if it has then the kernel image is not up-to-date with the rbf files
