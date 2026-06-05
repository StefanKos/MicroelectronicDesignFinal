#################################################################
# ModelSim do file, defines signals to display in simulation
#                   of the Counter Logic
# Date: 05.06.2026
# Author: Kos Stefan, Kilic Safak
#################################################################


onerror {resume}

# CLOCK SIGNAL
add wave -noupdate -format Logic -group CLK /tb_cntr/clk_i

# INPUT SIGNALS
add wave -noupdate -format Logic -group INPUT /tb_cntr/reset_i
add wave -noupdate -format Logic -group INPUT /tb_cntr/train_approches_i
add wave -noupdate -format Logic -group INPUT /tb_cntr/train_leaves_i

# OUTPUT SIGNALS
add wave -noupdate -format Logic -group OUTPUT /tb_cntr/light_o
add wave -noupdate -format Logic -group OUTPUT /tb_cntr/gate_close_o
add wave -noupdate -format Logic -group OUTPUT /tb_cntr/gate_open_o
