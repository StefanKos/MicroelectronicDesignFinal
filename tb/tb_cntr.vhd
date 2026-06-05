/*
Author: Kos Stefan; Kilic Safak

Filename: tb_cntr.vhd

Date of Creation: 05.06.2026

Date of Latest Version: 05.06.2026

Design Unit: Testbench Counter Logic

Description: This testbench verifies the cntr unit of the counter project.
    It generates clock and reset signals and applies stimulus to the control
    inputs cntrclear_i, cntrhold_i, cntrup_i and cntrdown_i in order to test
    the four-digit octal counting behavior, the priority scheme of the control
    inputs, the 0.5 Hz enable-based counting operation, and the output digit
    values forwarded to the io_ctrl unit.
*/