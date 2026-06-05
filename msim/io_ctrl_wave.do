#################################################################
# ModelSim do file, defines signals to display in simulation
#                   of the I/O Control Panel
# Date: 05.06.2026
# Author: Kos Stefan, Kilic Safak
#################################################################

onerror {resume}

# CLOCK SIGNAL
add wave -noupdate -format Logic -group CLK /tb_io_ctrl/clk_i

# INPUT SIGNALS
add wave -noupdate -format Logic -group INPUT /tb_io_ctrl/reset_i
add wave -noupdate -format Logic -group INPUT /tb_io_ctrl/train_approches_i
add wave -noupdate -format Logic -group INPUT /tb_io_ctrl/train_leaves_i

# OUTPUT SIGNALS
add wave -noupdate -format Logic -group OUTPUT /tb_io_ctrl/light_o
add wave -noupdate -format Logic -group OUTPUT /tb_io_ctrl/gate_close_o
add wave -noupdate -format Logic -group OUTPUT /tb_io_ctrl/gate_open_o
