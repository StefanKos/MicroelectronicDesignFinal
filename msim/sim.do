################################################
# ModelSim do file, simulates FPGA Counter Project
# Date: 05.06.2026
# Author: Kos Stefan, Kilic Safak
################################################

vsim -t ns -lib work work.tb_cntr  
view *
do cntr_wave.do # define signals to display in Wave window  
run 40 sec