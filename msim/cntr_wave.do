#################################################################
# ModelSim do file, defines signals to display in simulation
#                   of the Counter Logic (tb_cntr)
# Date: 05.06.2026
# Author: Kos Stefan, Kilic Safak
#################################################################

onerror {resume}

# CLOCK SIGNAL
add wave -noupdate -format Logic -group CLK /tb_cntr/clk_i

# INPUT SIGNALS
add wave -noupdate -format Logic -group INPUT /tb_cntr/reset_i
add wave -noupdate -format Logic -group INPUT /tb_cntr/cntrup_i
add wave -noupdate -format Logic -group INPUT /tb_cntr/cntrdown_i
add wave -noupdate -format Logic -group INPUT /tb_cntr/cntrclear_i
add wave -noupdate -format Logic -group INPUT /tb_cntr/cntrhold_i

# OUTPUT SIGNALS
add wave -noupdate -format Literal -group OUTPUT /tb_cntr/cntr0_o
add wave -noupdate -format Literal -group OUTPUT /tb_cntr/cntr1_o
add wave -noupdate -format Literal -group OUTPUT /tb_cntr/cntr2_o
add wave -noupdate -format Literal -group OUTPUT /tb_cntr/cntr3_o

# update Wave window
update