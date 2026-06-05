#####################################################################
# ModelSim do file, compiles design & testbench of FPGACounterProject
# Date: 05.06.2026
# Author: Kos Stefan, Kilic Safak
#####################################################################

# compile design files of Vectorgate
vcom ../vhdl/RailroadCrossingFSM.vhd

# compile testbench of Vectorgate
vcom ../tb/tb_RailroadCrossingFSM.vhd