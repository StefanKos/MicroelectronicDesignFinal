
--Author: Kos Stefan; Kilic Safak

--Filename: tb_cntr.vhd

--Date of Creation: 04.06.2026

--Date of Latest Version: 04.06.2026

--Design Unit: Testbench Counter Logic

--Description: This testbench verifies the cntr unit of the counter project.
--	It generates clock and reset signals and applies stimulus to the control
--	inputs cntrclear_i, cntrhold_i, cntrup_i and cntrdown_i in order to test
-- 	the four-digit octal counting behavior, the priority scheme of the control
--	inputs, the 0.5 Hz enable-based counting operation, and the output digit
--	values forwarded to the io_ctrl unit.


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_cntr is
end entity tb_cntr;

architecture sim of tb_cntr is

    ---------------------------------------------------------------------------
    -- Component declaration
    ---------------------------------------------------------------------------
    component cntr
        port(
            clk_i       : in  std_logic;
            reset_i     : in  std_logic;

            cntrup_i    : in  std_logic;
            cntrdown_i  : in  std_logic;
            cntrclear_i : in  std_logic;
            cntrhold_i  : in  std_logic;

            cntr0_o     : out std_logic_vector(3 downto 0);
            cntr1_o     : out std_logic_vector(3 downto 0);
            cntr2_o     : out std_logic_vector(3 downto 0);
            cntr3_o     : out std_logic_vector(3 downto 0)
        );
    end component;

    ---------------------------------------------------------------------------
    -- Testbench signals
    ---------------------------------------------------------------------------
    signal clk_i       : std_logic := '0';
    signal reset_i     : std_logic := '0';

    signal cntrup_i    : std_logic := '0';
    signal cntrdown_i  : std_logic := '0';
    signal cntrclear_i : std_logic := '0';
    signal cntrhold_i  : std_logic := '0';

    signal cntr0_o     : std_logic_vector(3 downto 0);
    signal cntr1_o     : std_logic_vector(3 downto 0);
    signal cntr2_o     : std_logic_vector(3 downto 0);
    signal cntr3_o     : std_logic_vector(3 downto 0);

    constant CLK_PERIOD : time := 10 ns; -- 100 MHz

begin

    ---------------------------------------------------------------------------
    -- DUT
    ---------------------------------------------------------------------------
    uut : cntr
        port map(
            clk_i       => clk_i,
            reset_i     => reset_i,
            cntrup_i    => cntrup_i,
            cntrdown_i  => cntrdown_i,
            cntrclear_i => cntrclear_i,
            cntrhold_i  => cntrhold_i,
            cntr0_o     => cntr0_o,
            cntr1_o     => cntr1_o,
            cntr2_o     => cntr2_o,
            cntr3_o     => cntr3_o
        );

    ---------------------------------------------------------------------------
    -- Clock generation
    ---------------------------------------------------------------------------
    p_clk : process
    begin
        while true loop
            clk_i <= '0';
            wait for CLK_PERIOD / 2;
            clk_i <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process p_clk;

    ---------------------------------------------------------------------------
    -- Stimulus process
    ---------------------------------------------------------------------------
    p_stim : process
    begin
        -----------------------------------------------------------------------
        -- Initial reset
        -----------------------------------------------------------------------
        reset_i <= '1';
        cntrup_i <= '0';
        cntrdown_i <= '0';
        cntrclear_i <= '0';
        cntrhold_i <= '0';
        wait for 50 ns;

        reset_i <= '0';
        wait for 50 ns;

        -----------------------------------------------------------------------
        -- Test case 1: Hold mode
        -----------------------------------------------------------------------
        cntrhold_i <= '1';
        wait for 5 ms;  -- placeholder, increase if full-speed divider is used
        cntrhold_i <= '0';

	 -----------------------------------------------------------------------
        -- Test case 2: Count up
        -----------------------------------------------------------------------
        cntrup_i <= '1';
        cntrdown_i <= '0';
        wait for 50 ns; -- placeholder, increase for real 0.5 Hz operation
        cntrup_i <= '0';
		

        -----------------------------------------------------------------------
        -- Test case 3: Hold after count up
        -----------------------------------------------------------------------
        cntrhold_i <= '1';
        wait for 5 ms;
        cntrhold_i <= '0';

        -----------------------------------------------------------------------
        -- Test case 4: Count down
        -----------------------------------------------------------------------
        cntrup_i <= '0';
        cntrdown_i <= '1';
        wait for 20 ms; -- placeholder, increase for real 0.5 Hz operation
        cntrdown_i <= '0';

        -----------------------------------------------------------------------
        -- Test case 5: Synchronous clear
        -----------------------------------------------------------------------
        cntrclear_i <= '1';
        wait for 20 ns;
        cntrclear_i <= '0';
        wait for 1 ms;

        -----------------------------------------------------------------------
        -- Test case 6: Illegal input combination Up=1, Down=1
        -----------------------------------------------------------------------
        cntrup_i <= '1';
        cntrdown_i <= '1';
        wait for 5 ms;
        cntrup_i <= '0';
        cntrdown_i <= '0';

        -----------------------------------------------------------------------
        -- End of simulation
        -----------------------------------------------------------------------
        wait;
    end process p_stim;

end architecture sim;