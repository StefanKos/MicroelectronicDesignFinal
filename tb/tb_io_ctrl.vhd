
--Author: Kos Stefan; Kilic Safak

--Filename: tb_io_ctrl.vhd

--Date of Creation: 04.06.2026

--Date of Latest Version: 04.06.2026

--Design Unit: Testbench IO Control Unit

--Description: This testbench verifies the io_ctrl unit of the counter project.
--	It generates clock and reset signals, applies stimulus to the counter digit,
--	switch and push-button inputs, and checks the behavior of the synchronized
--	switch/button outputs, the 1 kHz display multiplexing, the 7-segment data
--	output, and the digit select signals of the Basys3 board interface.


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_io_ctrl is
end entity tb_io_ctrl;

architecture sim of tb_io_ctrl is

    ---------------------------------------------------------------------------
    -- Component declaration
    ---------------------------------------------------------------------------
    component io_ctrl
        port(
            clk_i     : in  std_logic;
            reset_i   : in  std_logic;

            cntr0_i   : in  std_logic_vector(3 downto 0);
            cntr1_i   : in  std_logic_vector(3 downto 0);
            cntr2_i   : in  std_logic_vector(3 downto 0);
            cntr3_i   : in  std_logic_vector(3 downto 0);

            led_i     : in  std_logic_vector(15 downto 0);
            sw_i      : in  std_logic_vector(15 downto 0);
            pb_i      : in  std_logic_vector(3 downto 0);

            ss_o      : out std_logic_vector(7 downto 0);
            ss_sel_o  : out std_logic_vector(3 downto 0);

            swsync_o  : out std_logic_vector(15 downto 0);
            pbsync_o  : out std_logic_vector(3 downto 0);

            led_o     : out std_logic_vector(15 downto 0)
        );
    end component;

    ---------------------------------------------------------------------------
    -- Testbench signals
    ---------------------------------------------------------------------------
    signal clk_i     : std_logic := '0';
    signal reset_i   : std_logic := '0';

    signal cntr0_i   : std_logic_vector(3 downto 0) := (others => '0');
    signal cntr1_i   : std_logic_vector(3 downto 0) := (others => '0');
    signal cntr2_i   : std_logic_vector(3 downto 0) := (others => '0');
    signal cntr3_i   : std_logic_vector(3 downto 0) := (others => '0');

    signal led_i     : std_logic_vector(15 downto 0) := (others => '0');
    signal sw_i      : std_logic_vector(15 downto 0) := (others => '0');
    signal pb_i      : std_logic_vector(3 downto 0) := (others => '0');

    signal ss_o      : std_logic_vector(7 downto 0);
    signal ss_sel_o  : std_logic_vector(3 downto 0);

    signal swsync_o  : std_logic_vector(15 downto 0);
    signal pbsync_o  : std_logic_vector(3 downto 0);

    signal led_o     : std_logic_vector(15 downto 0);

    constant CLK_PERIOD : time := 10 ns; -- 100 MHz

begin

    ---------------------------------------------------------------------------
    -- DUT
    ---------------------------------------------------------------------------
    uut : io_ctrl
        port map(
            clk_i     => clk_i,
            reset_i   => reset_i,
            cntr0_i   => cntr0_i,
            cntr1_i   => cntr1_i,
            cntr2_i   => cntr2_i,
            cntr3_i   => cntr3_i,
            led_i     => led_i,
            sw_i      => sw_i,
            pb_i      => pb_i,
            ss_o      => ss_o,
            ss_sel_o  => ss_sel_o,
            swsync_o  => swsync_o,
            pbsync_o  => pbsync_o,
            led_o     => led_o
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
        wait for 50 ns;
        reset_i <= '0';
        wait for 50 ns;

        -----------------------------------------------------------------------
        -- Test case 1: Static digit values for 7-segment display
        -----------------------------------------------------------------------
        cntr0_i <= "0001"; -- 1
        cntr1_i <= "0010"; -- 2
        cntr2_i <= "0011"; -- 3
        cntr3_i <= "0100"; -- 4
        wait for 5 ms;     -- observe multiplexing

        -----------------------------------------------------------------------
        -- Test case 2: Change digit values
        -----------------------------------------------------------------------
        cntr0_i <= "0101"; -- 5
        cntr1_i <= "0110"; -- 6
        cntr2_i <= "0111"; -- 7
        cntr3_i <= "0000"; -- 0
        wait for 5 ms;

        -----------------------------------------------------------------------
        -- Test case 3: Switch synchronization
        -----------------------------------------------------------------------
        sw_i(3 downto 0) <= "1010";
        wait for 100 ns;
        sw_i(3 downto 0) <= "0101";
        wait for 100 ns;
        sw_i(3 downto 0) <= "1111";
        wait for 2 ms;

        -----------------------------------------------------------------------
        -- Test case 4: Push-button synchronization
        -----------------------------------------------------------------------
        pb_i <= "0001";
        wait for 100 ns;
        pb_i <= "0010";
        wait for 100 ns;
        pb_i <= "0100";
        wait for 100 ns;
        pb_i <= "1000";
        wait for 2 ms;

        -----------------------------------------------------------------------
        -- Test case 5: LED forwarding
        -----------------------------------------------------------------------
        led_i <= x"AAAA";
        wait for 1 ms;
        led_i <= x"5555";
        wait for 1 ms;

        -----------------------------------------------------------------------
        -- End of simulation
        -----------------------------------------------------------------------
        wait;
    end process p_stim;

end architecture sim;