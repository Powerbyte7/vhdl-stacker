
library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	use ieee.math_real.all;

	-- The entity of your testbench. No ports declaration in this case.

entity stacker_state_tb is
end entity;

architecture testbench of stacker_state_tb is
	-- The component declaration should match your entity.
	-- It is very important that the name of the component and the 
	-- ports (remember direction of ports!) match your entity! 
	component stacker_state is
		generic (
			begin_state          : std_ulogic_vector(5 downto 0) := "001110";
			blink_cycle_duration : natural                       := 2000
		);
		port (
			-- Input
			clk              : in  std_ulogic;
			action_key       : in  std_ulogic;
			reset            : in  std_ulogic;
			-- Passed to grid_display
			top_row          : in  std_ulogic_vector(5 downto 0);
			bottom_row       : out std_ulogic_vector(5 downto 0);
			-- Passed to vector_ping_pong
			ping_pong_blocks : out std_ulogic_vector(5 downto 0);
			ping_pong_enable : out std_ulogic;
			-- Passed to score_counter
			score_increase   : out std_ulogic;
			score_show       : out std_ulogic;
			score_reset      : out std_ulogic;
			-- Passed to vector_ping_pong and speed_controller
			place_row        : out std_ulogic
		);
	end component;
	-- Signal declaration. These signals are used to drive your
	-- inputs and store results (if required).
	-- Inputs
	signal clk_tb        : std_ulogic                    := '0';
	signal action_key_tb : std_ulogic                    := '0';
	signal reset_tb      : std_ulogic                    := '0';
	signal top_row_tb    : std_ulogic_vector(5 downto 0) := "001110";

	-- Outputs
	signal bottom_row_tb       : std_ulogic_vector(5 downto 0);
	signal ping_pong_blocks_tb : std_ulogic_vector(5 downto 0);
	signal ping_pong_enable_tb : std_ulogic;
	signal score_increase_tb   : std_ulogic;
	signal score_show_tb       : std_ulogic;
	signal score_reset_tb      : std_ulogic;
	signal place_row_tb        : std_ulogic;
begin
	-- A port map is in this case nothing more than a construction to
	-- connect your entity ports with your signals.
	state: stacker_state
		port map (
			clk              => clk_tb,
			action_key       => action_key_tb,
			reset            => reset_tb,
			top_row          => top_row_tb,
			bottom_row       => bottom_row_tb,
			ping_pong_enable => ping_pong_enable_tb,
			score_increase   => score_increase_tb,
			score_show       => score_show_tb,
			score_reset      => score_reset_tb,
			place_row        => place_row_tb
		);

	clk_tb <= '1' after 2 ns when clk_tb = '0' else '0' after 2 ns when clk_tb = '1';

	process
	begin
		report "Testing entity stacker_state.";

		-- This is the moving row
		top_row_tb <= "001110";

		-- Check initial state
		report "BEGIN";
		assert score_show_tb = '0' report "begin: score_show_tb is " & to_string(score_show_tb) severity error;
		assert score_increase_tb = '0' report "begin: score_increase_tb is " & to_string(score_increase_tb) severity error;
		assert ping_pong_enable_tb = '0' report "begin: ping_pong_enable_tb is " & to_string(ping_pong_enable_tb) severity error;
		assert place_row_tb = '0' report "begin: place_row_tb is " & to_string(place_row_tb) severity error;
		assert score_reset_tb = '1' report "begin: score_reset_tb is " & to_string(score_reset_tb) severity error;
		assert bottom_row_tb = "001110" report "begin: bottom_row_tb is " & to_string(bottom_row_tb) severity error;

		-- Press button once to start game
		wait for 100 ns;
		action_key_tb <= '1';
		wait for 100 ns;
		action_key_tb <= '0';
		wait for 100 ns;

		-- Check moving/playing state
		assert score_show_tb = '0' report "playing: score_show_tb is " & to_string(score_show_tb) severity error;
		assert score_increase_tb = '0' report "playing: score_increase_tb is " & to_string(score_increase_tb) severity error;
		assert ping_pong_enable_tb = '1' report "playing: ping_pong_enable_tb is " & to_string(ping_pong_enable_tb) severity error;
		assert place_row_tb = '0' report "playing: place_row_tb is " & to_string(place_row_tb) severity error;
		assert score_reset_tb = '0' report "playing: score_reset_tb is " & to_string(score_reset_tb) severity error;
		assert bottom_row_tb = "001110" report "begin: bottom_row_tb is " & to_string(bottom_row_tb) severity error;

		-- Press button once to place row
		wait for 100 ns;
		action_key_tb <= '1';
		wait for 100 ns;
		action_key_tb <= '0';

		-- Check placed state
		assert score_show_tb = '0' report "placed: score_show_tb is " & to_string(score_show_tb) severity error;
		assert score_increase_tb = '0' report "placed: score_increase_tb is " & to_string(score_increase_tb) severity error;
		assert ping_pong_enable_tb = '1' report "placed: ping_pong_enable_tb is " & to_string(ping_pong_enable_tb) severity error;
		assert place_row_tb = '1' report "placed: place_row_tb is " & to_string(place_row_tb) severity error;
		assert score_reset_tb = '0' report "placed: score_reset_tb is " & to_string(score_reset_tb) severity error;
		assert bottom_row_tb = "001110" report "placed: bottom_row_tb is " & to_string(bottom_row_tb) severity error;

		wait until place_row_tb = '0';

		-- Press button once to place row
		wait for 100 ns;
		top_row_tb <= "011100";
		action_key_tb <= '1';
		wait for 100 ns;
		action_key_tb <= '0';

		-- Wait until blinking is complete
		wait until place_row_tb = '0';

		-- Check placed state with lost block
		assert score_show_tb = '0' report "placed2: score_show_tb is " & to_string(score_show_tb) severity error;
		assert score_increase_tb = '1' report "placed2: score_increase_tb is " & to_string(score_increase_tb) severity error;
		assert ping_pong_enable_tb = '1' report "placed2: ping_pong_enable_tb is " & to_string(ping_pong_enable_tb) severity error;
		assert score_reset_tb = '0' report "placed2: score_reset_tb is " & to_string(score_reset_tb) severity error;
		assert bottom_row_tb = "001100" report "placed2: bottom_row_tb is " & to_string(bottom_row_tb) severity error;

		-- Press button once to place row
		wait for 100 ns;
		top_row_tb <= "000000";
		action_key_tb <= '1';
		wait for 100 ns;
		action_key_tb <= '0';

		-- Wait until blinking is complete
		wait until ping_pong_enable_tb = '0';

		-- Check state when all blocks are lost
		assert score_increase_tb = '0' report "over: score_increase_tb is " & to_string(score_increase_tb) severity error;
		assert score_show_tb = '1' report "over: score_show_tb is " & to_string(score_show_tb) severity error;
		assert score_reset_tb = '0' report "over: score_reset_tb is " & to_string(score_reset_tb) severity error;

		report "Test completed.";
		std.env.stop;
	end process;
end architecture;
