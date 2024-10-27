
library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	use ieee.math_real.all;

	-- The entity of your testbench. No ports declaration in this case.

entity score_counter_tb is
end entity;

architecture testbench of score_counter_tb is
	-- The component declaration should match your entity.
	-- It is very important that the name of the component and the 
	-- ports (remember direction of ports!) match your entity! 
	component score_counter is
		port (
			reset          : in  std_ulogic;
			score_increase : in  std_ulogic;
			score_reset    : in  std_ulogic;
			score_highscore  : out std_ulogic;
			-- 6 nibbles
			score_display   : out std_ulogic_vector(41 downto 0)
		);
	end component;
	-- Signal declaration. These signals are used to drive your
	-- inputs and store results (if required).
	signal trigger_tb   : std_ulogic;
	signal reset_tb     : std_ulogic;
	signal highscore_tb : std_ulogic;
	signal display_tb   : std_ulogic_vector(41 downto 0);
begin
	-- A port map is in this case nothing more than a construction to
	-- connect your entity ports with your signals.
	scorecount: score_counter
		port map (
			reset          => '0',
			score_reset    => reset_tb,
			score_increase => trigger_tb,
			score_highscore  => highscore_tb,
			score_display  => display_tb
		);

	process
		type int_array is array (0 to 15) of integer;
	begin
		report "Testing entity score_counter.";
		-- Initialize signals.
		trigger_tb <= '0';
		reset_tb <= '1';
		wait for 10 ns;
		reset_tb <= '0';
		wait for 10 ns;

		report "Testing default state";

		assert display_tb = (display_tb'reverse_range => '1')
			report "test failed for display_tb = 1, result is " & to_string(display_tb)
			severity error;
		assert highscore_tb = '0'
			report "test failed for highscore_tb = 0, result is " & to_string(highscore_tb)
			severity error;

		for i in 1 to 14 loop
			trigger_tb <= '1';
			wait for 10 ns;
			trigger_tb <= '0';
			wait for 10 ns;
		end loop;

		report "Testing with new highscore of 14";

		assert display_tb(13 downto 0) = "11110010011001"
			report "test failed for display_tb = 11110010011001, result is " & to_string(display_tb)
			severity error;
		assert highscore_tb = '1'
			report "test failed for highscore_tb = 1, result is " & to_string(highscore_tb)
			severity error;

		wait for 10 ns;
		reset_tb <= '1';
		wait for 10 ns;
		reset_tb <= '0';
		wait for 10 ns;

		for i in 1 to 3 loop
			trigger_tb <= '1';
			wait for 10 ns;
			trigger_tb <= '0';
			wait for 10 ns;
		end loop;

		report "Testing with score of 3, no highscore";

		assert display_tb(6 downto 0) = "0110000"
			report "test failed for display_tb = 0110000, result is " & to_string(display_tb)
			severity error;
		assert highscore_tb = '0'
			report "test failed for highscore_tb = 1, result is " & to_string(highscore_tb)
			severity error;

		report "Test completed.";
		std.env.stop;
	end process;

end architecture;
