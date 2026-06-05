/*
Author: Kos Stefan; Kilic Safak

Filename: cntr_top.vhd

Date of Creation: 04.06.026

Date of Latest Version: 04.06.2026

Design Unit: Counter Top

Description: The top-level entity cntr_top contains of two sub-units: io_ctrl and cntr.
	Sub-unit "IO Control" io_ctrl handles the I/O ports (with exception of the clock signal and the reset),
	and the second sub-unit cntr contains the implementation of the octal counter. The 7-segment decoder/multiplexer
	(used to control and multiplex the four 7-segment digits) is located in the io_ctrl.
*/

library ieee;
use ieee.std_logic_1164.all;

entity cntr_top is
	port(
	clk_i : in std_logic;								-- System Clock (100MHz)
	reset_i : in std_logic;							-- Asynchronous high active reset
	
	sw_i : in std_logic_vector(15 downto 0);			-- 16 switches
	pb_i : in std_logic_vector(3 downto 0);			-- 4 push buttons
	
	ss_o : out std_logic_vector(7 downto 0); 			-- Contains the value for all four 7 segment digits
	ss_sel_o : out std_logic_vector(3 downto 0); 		-- Selects one out of the four 7-segment digits
	led_o : out std_logic_vector(15 downto 0) 			-- 16 leds
	);
end entity cntr_top;

architecture rtl of cntr_top is
	
	component io_ctrl
	port(
	clk_i : in std_logic;							-- System Clock (100MHz)
	reset_i : in std_logic;						-- Asynchronous high active reset
	
	cntr0_i : in std_logic_vector(3 downto 0);	-- Digit 0 (from FPGA internal logic)
	cntr1_i : in std_logic_vector(3 downto 0);	-- Digit 1 (from FPGA internal logic)
	cntr2_i : in std_logic_vector(3 downto 0);	-- Digit 2 (from FPGA internal logic)
	cntr3_i : in std_logic_vector(3 downto 0);	-- Digit 3 (from FPGA internal logic)
	
	led_i : in std_logic_vector(15 downto 0);		-- State of 16 LEDs (from FPGA internal logic)
	sw_i : in std_logic_vector(15 downto 0);		-- 16 switches (from FPGA board)
	pb_i : in std_logic_vector(3 downto 0);		-- 4 push buttons (from FPGA board)
	
	ss_o : out std_logic_vector(7 downto 0);		-- to 7-segment digits of the FPGA board
	ss_sel_o : out std_logic_vector(3 downto 0);	-- Selection of a 7 segment digit
	swsync_o : out std_logic_vector(15 downto 0);	-- 16 switches (to FPGA interal logic)
	pbsync_o : out std_logic_vector(3 downto 0);	-- 4 push buttons (to FPGA internal logic)
	led_o : out std_logic_vector(15 downto 0)		-- to 16 LEDs of the FPGA board
	);
	end component io_ctrl;
	
	component cntr
	port(
		clk_i : in std_logic;						-- System Clock (100MHz)
		reset_i : in std_logic;					-- Asynchronous high active reset
		
		cntrup_i : in std_logic;					-- Counts up if signal is '1'
		cntrdown_i : in std_logic;					-- Counts down if signal is '1'
		cntrclear_i : in std_logic;					-- Sets counter to 0x0 is signal is '1'
		cntrhold_i : in std_logic;					-- Holds count value if signal is '1'
		
		cntr0_o : out std_logic_vector(3 downto 0);	-- Digit 0 (from FPGA internal logic) LS
		cntr1_o : out std_logic_vector(3 downto 0);	-- Digit 1 (from FPGA internal logic)
		cntr2_o : out std_logic_vector(3 downto 0);	-- Digit 2 (from FPGA internal logic)
		cntr3_o : out std_logic_vector(3 downto 0);	-- Digit 3 (from FPGA internal logic) MS
	);
	end component cntr;
	
	signal swsync : std_logic_vector(15 downto 0);
	signal pbsync : std_logic_vector(3 downto 0);
	
	signal cntr0_s : std_logic_vector(3 downto 0);
	signal cntr1_s : std_logic_vector(3 downto 0);
	signal cntr2_s : std_logic_vector(3 downto 0);
	signal cntr3_s : std_logic_vector(3 downto 0);
	
	signal cntr_up_s : std_logic;
	signal cntr_down_s : std_logic;
	signal cntr_clear_s : std_logic;
	signal cntr_hold_s : std_logic;
begin

	-- IO Control block
	u_io_ctrl : io_ctrl
		port map(
		clk_i => clk_i,
		reset_i => reset_i,
		cntr0_i => cntr0_s,
		cntr1_i => cntr1_s,
		cntr2_i => cntr2_s,
		cntr3_i => cntr3_s,
		led_i => (others =>'0'),
		sw_i => sw_i,
		pb_i => pb_i,
		ss_o => ss_o,
		ss_sel_o => ss_sel_o,
		swsync_o => swsync,
		pbsync_o => pbsync,
		led_o => led_o
		);
	
	-- Switch decoding
	cntr_clear_s <= swsync(3);
	cntr_hold_s <= not swsync(0);
	cntr_up_s <= swsync(0) and swsync(1) and not swsync(2) and not swsync(3);
	cntr_down_s <= swsync(0) and swsync(2) and not swsync(1) and not swsync(3);	

	-- Counter Block
	u_cntr : cntr
		port map(
		clk_i => clk_i,
		reset_i => reset_i,
		cntrup_i => cntr_up_s,
		cntrdown_i => cntr_down_s,
		cntrclear_i => cntr_clear_s,
		cntrhold_i => cntr_hold_s,
		cntr0_o => cntr0_s,
		cntr1_o => cntr1_s,
		cntr2_o => cntr2_s,
		cntr3_o => cntr3_s
		);
		
end architecture rtl;