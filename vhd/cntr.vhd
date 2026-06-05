
--Author: Kos Stefan, Kilic Safak

--Filename: cntr.vhd

--Date of Creation: 04.06.026

--Date of Latest Version: 04.06.2026

--Design Unit: Counter Logic

--Description: The cntr sub-unit contains implementation of the octal counter. By using the cntrclear_i signal,
--	the counter can be synchronously set to "0000". The signal cntrhold_i makes it possible to hold the current
--	counting value. The signals cntrup_i and cntrdown_i control whether the counter counts up or down. In order
--	to define the behavior when multiple controls inputs are logic high, a priority scheme shall be impelemented.
--	The signals cntr0_i, cntr1_i, cntr2_i and cntr3_i are connected to the io_ctrl sub-unit which controls the
--	7-segment display.


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cntr is
	port(
		clk_i : in std_logic;						-- System Clock (100MHz)
		reset_i : in std_logic;						-- Asynchronous high active reset
		
		cntrup_i : in std_logic;					-- Counts up if signal is '1'
		cntrdown_i : in std_logic;					-- Counts down if signal is '1'
		cntrclear_i : in std_logic;					-- Sets counter to 0x0 is signal is '1'
		cntrhold_i : in std_logic;					-- Holds count value if signal is '1'
		
		cntr0_o : out std_logic_vector(3 downto 0);	-- Digit 0 (from FPGA internal logic) LS
		cntr1_o : out std_logic_vector(3 downto 0);	-- Digit 1 (from FPGA internal logic)
		cntr2_o : out std_logic_vector(3 downto 0);	-- Digit 2 (from FPGA internal logic)
		cntr3_o : out std_logic_vector(3 downto 0)	-- Digit 3 (from FPGA internal logic) MS
	);
end entity cntr;

architecture rtl of cntr is
	
	constant CLK_DIV_MAX : unsigned(27 downto 0) := to_unsigned(199_999_999, 28);
	
	signal div_cnt : unsigned(27 downto 0);
	signal en_0_5hz : std_logic;
	
	signal d0, d1, d2, d3 : unsigned(2 downto 0);
	
begin
	
	---------------------------------------------------------------------------
	-- Generate 0.5 Hz enable pulse from 100 MHz clock
	-- One enable pulse every 2 seconds
	---------------------------------------------------------------------------
	p_freq_div : process(clk_i, reset_i) is
	begin
		if reset_i = '1' then
			div_cnt <= (others => '0');
			en_0_5hz <= '0';
		elsif rising_edge(clk_i) then
			if div_cnt = CLK_DIV_MAX then
				div_cnt <= (others => '0');
				en_0_5hz <= '1';
			else
				div_cnt <= div_cnt + 1;
				en_0_5hz <= '0';
			end if;
		end if;
	end process p_freq_div;
	
	---------------------------------------------------------------------------
	-- Octal counter
	-- Priority: clear > hold > up > down > hold
	---------------------------------------------------------------------------	
	p_count : process(clk_i, reset_i)	
		variable v_d0, v_d1, v_d2, v_d3 : unsigned(2 downto 0);
	begin
		if reset_i = '1' then
			d0 <= (others => '0');
			d1 <= (others => '0');
			d2 <= (others => '0');
			d3 <= (others => '0');
			
		elsif rising_edge(clk_i) then
			if en_0_5hz = '1' then
				-- aktuelle Werte in Variablen kopieren
				v_d0 := d0;
				v_d1 := d1;
				v_d2 := d2;
				v_d3 := d3;
				
				if cntrclear_i = '1' then
					v_d0 := (others => '0');
					v_d1 := (others => '0');
					v_d2 := (others => '0');
					v_d3 := (others => '0');
					
				elsif cntrhold_i = '1' then
					NULL;
					
				elsif (cntrup_i = '1') and (cntrdown_i = '0') then
					
					if v_d0 = "111" then
						v_d0 := "000";
						if v_d1 = "111" then
							v_d1 := "000";
							if v_d2 = "111" then
								v_d2 := "000";
								if v_d3 = "111" then
									v_d3 := "000"; -- 7777->0000
								else
									v_d3 := v_d3 + 1;
								end if;
							else
								v_d2 := v_d2 + 1;
							end if;
						else
							v_d1 := v_d1 + 1;
						end if;
					else
						v_d0 := v_d0 +1;
					end if;
							
							
				elsif (cntrup_i = '0') and (cntrdown_i = '1') then
				
					if v_d0 = "000" then
						v_d0 := "111";
						if v_d1 = "000" then
							v_d1 := "111";
							if v_d2 = "000" then
								v_d2 := "111";
								if v_d3 = "000" then
									v_d3 := "111"; -- 0000->7777
								else
									v_d3 := v_d3 - 1;
								end if;
							else
								v_d2 := v_d2 - 1;
							end if;
						else
							v_d1 := v_d1 - 1;
						end if;
					else
						v_d0 := v_d0 - 1;
					end if;
				else
				NULL;	
				end if;
					
			d0 <= v_d0;
			d1 <= v_d1;
			d2 <= v_d2;
			d3 <= v_d3;
				
				
			end if;
		end if;
	end process p_count;
	
	---------------------------------------------------------------------------
	-- 3-bit octal digits mapped to 4-bit outputs for io_ctrl
	---------------------------------------------------------------------------
	cntr0_o <= '0' & std_logic_vector(d0);
	cntr1_o <= '0' & std_logic_vector(d1);
	cntr2_o <= '0' & std_logic_vector(d2);
	cntr3_o <= '0' & std_logic_vector(d3);	
end architecture rtl;
