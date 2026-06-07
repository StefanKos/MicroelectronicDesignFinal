#####################################################################
# ModelSim do file, compiles design & testbench of Counter Project
# Date: 05.06.2026
# Author: Kos Stefan, Kilic Safak
#####################################################################

# clean work library
vdel -lib work -all
vlib work
vmap work work

# compile design files
vcom ../vhd/io_ctrl.vhd
vcom ../vhd/cntr.vhd
vcom ../vhd/cntr_top.vhd

# compile testbenches
vcom ../tb/tb_cntr.vhd
vcom ../tb/tb_io_ctrl.vhd