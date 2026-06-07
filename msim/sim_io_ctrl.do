################################################
# ModelSim do file, simulates IO Control Unit
# Date: 05.06.2026
# Author: Kos Stefan, Kilic Safak
################################################

# simulate tb_io_ctrl
vsim -t ns -lib work work.tb_io_ctrl

view *
do io_ctrl_wave.do      ;# define signals to display in Wave window

run 120 sec