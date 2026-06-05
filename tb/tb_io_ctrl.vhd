/*
Author: Kos Stefan; Kilic Safak

Filename: tb_io_ctrl.vhd

Date of Creation: 05.06.2026

Date of Latest Version: 05.06.2026

Design Unit: Testbench IO Control Unit

Description: This testbench verifies the io_ctrl unit of the counter project.
	It generates clock and reset signals, applies stimulus to the counter digit,
    switch and push-button inputs, and checks the behavior of the synchronized
    switch/button outputs, the 1 kHz display multiplexing, the 7-segment data
    output, and the digit select signals of the Basys3 board interface.
*/