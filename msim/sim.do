################################################
# ModelSim do file, simulates Counter Unit
# Date: 05.06.2026
# Author: Kos Stefan, Kilic Safak
################################################

# simulate tb_cntr
vsim -t ns -lib work work.tb_cntr

view *
do cntr_wave.do      ;# define signals to display in Wave window

run 10 sec