/*
Author: Kos Stefan; Kilic Safak

Filename: io_ctrl.vhd

Date of Creation: 04.06.026

Date of Latest Version: 04.06.2026

Design Unit: I/O Control

Description: The io_ctrl unit implements an generic interface for the I/O hardware contained on the Basys3 board.
	This means, that not all I/Os are used for the counter project. The unit debounces the singals coming from the
	the switches and push buttons of the board and makes them available for FPGA internal logic on the signals
	swsync_o and pbsync_o. It also decodes the values cntr0_i, cntr1_i, cntr2_i and cntr3_i coing from the counter sub-unit
	and maintains the 7-segment digits via signals ss_o and ss_sel

*/

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity io_ctrl is
	generic(
	n : integer := 8;
	);
	port(
	clk_i : in std_logic;							-- System Clock (100MHz)
	reset_i : in std_logic;							-- Asynchronous high active reset
	cntr0_i : in std_logic_vector(n downto 0);		-- Digit 0 (from FPGA internal logic)
	cntr1_i : in std_logic_vector(n downto 0);		-- Digit 1 (from FPGA internal logic)
	cntr2_i : in std_logic_vector(n downto 0);		-- Digit 2 (from FPGA internal logic)
	cntr3_i : in std_logic_vector(n downto 0);		-- Digit 3 (from FPGA internal logic)
	led_i : in std_logic_vector(15 downto 0);		-- State of 16 LEDs (from FPGA internal logic)
	sw_i : in std_logic_vector(15 downto 0);		-- 16 switches (from FPGA board)
	pb_i : in std_logic_vector(4 downto 0);			-- 4 push buttons (from FPGA board)
	ss_o : out std_logic_vector(7 downto 0);		-- to 7-segment digits of the FPGA board
	ss_sel_o : out std_logic_vector(3 downto 0);	-- Selection of a 7 segment digit
	swsync_o : out std_logic_vector(15 downto 0);	-- 16 switches (to FPGA interal logic)
	pbsync_o : out std_logic_vector(3 downto 0);	-- 4 push buttons (to FPGA internal logic)
	led_o : out std_logic_vector(15 downto 0)		-- to 16 LEDs of the FPGA board
	);
end entity io_ctrl;

architecture rtl of io_ctrl is

begin




end architecture rtl;