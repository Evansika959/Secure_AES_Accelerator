#!/bin/csh -f

cd /home/xinting/eecs627/Secure_AES_Accelerator/verilog

#This ENV is used to avoid overriding current script in next vcselab run 
setenv SNPS_VCSELAB_SCRIPT_NO_OVERRIDE  1

/usr/caen/vcs-2022.06/linux64/bin/vcselab $* \
    -o \
    verdi \
    -nobanner \
    +vcs+lic+wait \

cd -

