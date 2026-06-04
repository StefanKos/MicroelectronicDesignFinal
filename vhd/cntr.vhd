/*
Author: Kos Stefan, Kilic Safak

Filename: cntr.vhd

Date of Creation: 04.06.026

Date of Latest Version: 04.06.2026

Design Unit: Counter Logic

Description: The cntr sub-unit contains implementation of the octal counter. By using the cntrclear_i signal,
	the counter can be synchronously set to "0000". The signal cntrhold_i makes it possible to hold the current
	counting value. The signals cntrup_i and cntrdown_i control whether the counter counts up or down. In order
	to define the behavior when multiple controls inputs are logic high, a priority scheme shall be impelemented.
	The signals cntr0_i, cntr1_i, cntr2_i and cntr3_i are connected to the io_ctrl sub-unit which controls the
	7-segment display.
*/

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cntr is
	generic(
	n : integer := 8;
	)
	port(
	clk_i : in std_logic;						-- System Clock (100MHz)
	reset_i : in std_logic;						-- Asynchronous high active reset
	cntrup_i : in std_logic;					-- Counts up if signal is '1'
	cntrdown_i : in std_logic;					-- Counts down if signal is '1'
	cntrclear_i : in std_logic;					-- Sets counter to 0x0 is signal is '1'
	cntrhold_i : in std_logic;					-- Holds count value if signal is '1'
	cntr0_i : out std_logic_vector(n downto 0);	-- Digit 0 (from FPGA internal logic)
	cntr1_i : out std_logic_vector(n downto 0);	-- Digit 1 (from FPGA internal logic)
	cntr2_i : out std_logic_vector(n downto 0);	-- Digit 2 (from FPGA internal logic)
	cntr3_i : out std_logic_vector(n downto 0);	-- Digit 3 (from FPGA internal logic)
	);

architecture rtl of cntr is

begin




end architecture rtl;
