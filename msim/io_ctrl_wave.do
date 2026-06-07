#################################################################
# ModelSim do file, defines signals to display in simulation
#                   of the IO Control Unit (tb_io_ctrl)
# Date: 05.06.2026
# Author: Kos Stefan, Kilic Safak
#################################################################

onerror {resume}

# CLOCK SIGNAL
add wave -noupdate -format Logic -group CLK /tb_io_ctrl/clk_i

# INPUT SIGNALS
add wave -noupdate -format Logic   -group INPUT /tb_io_ctrl/reset_i
add wave -noupdate -format Literal -group INPUT /tb_io_ctrl/cntr0_i
add wave -noupdate -format Literal -group INPUT /tb_io_ctrl/cntr1_i
add wave -noupdate -format Literal -group INPUT /tb_io_ctrl/cntr2_i
add wave -noupdate -format Literal -group INPUT /tb_io_ctrl/cntr3_i
add wave -noupdate -format Literal -group INPUT /tb_io_ctrl/sw_i
add wave -noupdate -format Literal -group INPUT /tb_io_ctrl/pb_i
add wave -noupdate -format Literal -group INPUT /tb_io_ctrl/led_i

# OUTPUT SIGNALS
add wave -noupdate -format Literal -group OUTPUT /tb_io_ctrl/ss_o
add wave -noupdate -format Literal -group OUTPUT /tb_io_ctrl/ss_sel_o
add wave -noupdate -format Literal -group OUTPUT /tb_io_ctrl/swsync_o
add wave -noupdate -format Literal -group OUTPUT /tb_io_ctrl/pbsync_o
add wave -noupdate -format Literal -group OUTPUT /tb_io_ctrl/led_o

# update Wave window
update