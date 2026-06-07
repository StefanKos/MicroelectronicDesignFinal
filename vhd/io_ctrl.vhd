
--Author: Kos Stefan; Kilic Safak

--Filename: io_ctrl.vhd

--Date of Creation: 04.06.026

--Date of Latest Version: 04.06.2026

--Design Unit: I/O Control

--Description: The io_ctrl unit implements an generic interface for the I/O hardware contained on the Basys3 board.
--	This means, that not all I/Os are used for the counter project. The unit debounces the singals coming from the
--	the switches and push buttons of the board and makes them available for FPGA internal logic on the signals
--	swsync_o and pbsync_o. It also decodes the values cntr0_i, cntr1_i, cntr2_i and cntr3_i coing from the counter sub-unit
--	and maintains the 7-segment digits via signals ss_o and ss_sel

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity io_ctrl is
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
end entity io_ctrl;

architecture rtl of io_ctrl is

	-- Frequenz Teiler 1kHz auf 100MHz -> 100_000
	constant CLK_REFRESH_MAX : unsigned(16 downto 0) := to_unsigned(99_999, 17);

	signal swsync_0, swsync_1 : std_logic_vector(15 downto 0);
	signal pbsync_0, pbsync_1 : std_logic_vector(3 downto 0);
	
	signal refresh_cnt : unsigned(16 downto 0);
	signal refresh_en : std_logic;
	
	signal digit_sel : unsigned (1 downto 0);
	signal cur_digit : std_logic_vector(3 downto 0);
	signal ss_data : std_logic_vector(7 downto 0);
	
begin
	
	-- Synchronisation der Switches und Buttons of clk_i
	p_sync : process(clk_i, reset_i)
	begin
		if reset_i = '1' then
			swsync_0 <= (others => '0');
			swsync_1 <= (others => '0');
			pbsync_0 <= (others => '0');
			pbsync_1 <= (others => '0');
		elsif rising_edge(clk_i) then
			swsync_0 <= sw_i;
			swsync_1 <= swsync_0;
			
			pbsync_0 <= pb_i;
			pbsync_1 <= pbsync_0;
		end if;
	end process p_sync;
	
	swsync_o <= swsync_1;
	pbsync_o <= pbsync_1;
	
	led_o <= led_i;
	
	-- 1kHz-Refresh Enable
	p_refresh_div : process(clk_i, reset_i)
	begin
		if reset_i = '1' then
			refresh_cnt <= (others => '0');
			refresh_en <= '0';
			digit_sel <= (others => '0');
		
		elsif rising_edge(clk_i) then
			if refresh_cnt = CLK_REFRESH_MAX then
				refresh_cnt <= (others => '0');
				refresh_en <= '1';
			
			else
				refresh_cnt <= refresh_cnt + 1;
				refresh_en <= '0';
				
			end if;
			
			if refresh_en = '1' then
				digit_sel <= digit_sel + 1;
			end if;
		end if;
	end process p_refresh_div;

	-- Digit-Multiplexer und Digit-Select (active low)
	p_digit_mux : process(digit_sel, cntr0_i, cntr1_i, cntr2_i, cntr3_i)
	begin
		case digit_sel is
			when "00" =>
				cur_digit <= cntr0_i;
				ss_sel_o <= "1110"; -- Digit 0 activ
			when "01" =>
				cur_digit <= cntr1_i;
				ss_sel_o <= "1101"; -- Digit 1 activ
			when "10" =>
				cur_digit <= cntr2_i;
				ss_sel_o <= "1011"; -- Digit 2 activ
			when "11" =>
				cur_digit <= cntr3_i;
				ss_sel_o <= "0111"; -- Digit 3 activ
			when others => 
				cur_digit <= "XXXX";
				ss_sel_o <= "XXXX";
		end case;
	end process p_digit_mux;
	
	p_7seg : process(cur_digit) 
	
	variable digit_val : unsigned(3 downto 0);
	
	begin
	digit_val := unsigned(cur_digit);
		case digit_val is
			-- 0
			when "0000" => ss_data <= "11000000";
			-- 1
			when "0001" => ss_data <= "11111001";
			-- 2
			when "0010" => ss_data <= "10100100";
			-- 3
			when "0011" => ss_data <= "10110000";
			-- 4
			when "0100" => ss_data <= "10011001";
			-- 5
			when "0101" => ss_data <= "10010010";
			-- 6
			when "0110" => ss_data <= "10000010";
			-- 7
			when "0111" => ss_data <= "11111000";
			--Others
			when others => ss_data <= (others => '1');
		end case;
	end process p_7seg;
	
	ss_o <= ss_data;
	
end architecture rtl;