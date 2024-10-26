library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	use ieee.math_real.all;

	-- The entity of your testbench. No ports declaration in this case.

entity clock_divider_tb is
end entity;

architecture testbench of clock_divider_tb is
	-- The component declaration should match your entity.
	-- It is very important that the name of the component and the 
	-- ports (remember direction of ports!) match your entity! 
	component clock_divider is
		generic (
			divisor : natural := 2
		);
		port (
			clk, reset : in  std_logic;
			clock_out  : out std_logic
		);
	end component;
	-- Signal declaration. These signals are used to drive your
	-- inputs and store results (if required).
	signal trigger_tb : std_logic := '0';
	signal reset_tb   : std_logic := '0';
	signal out2_tb    : std_logic;
	signal out4_tb    : std_logic;
	signal out8_tb    : std_logic;
begin
	-- A port map is in this case nothing more than a construction to
	-- connect your entity ports with your signals.
	div2: clock_divider
		generic map (divisor => 2)
		port map (
			reset => reset_tb, clk => trigger_tb, clock_out => out2_tb
		);
	div8: clock_divider
		generic map (divisor => 8)
		port map (
			reset => reset_tb, clk => trigger_tb, clock_out => out8_tb
		);
	div4: clock_divider
		generic map (divisor => 4)
		port map (
			reset => reset_tb, clk => trigger_tb, clock_out => out4_tb
		);

	process
		type int_array is array (0 to 15) of integer;
	begin
		report "Testing entity assignment2.";
		wait for 10 ns;

		-- Check if counters output 0 by default
		assert out8_tb = '0'
			report "test failed for out8_tb = 0, result is " & to_string(out8_tb)
			severity error;
		assert out4_tb = '0'
			report "test failed for out4_tb = 0, result is " & to_string(out4_tb)
			severity error;

		-- Loop through all possible values of addition
		for number in 0 to 10 loop
			-- report "number is " & to_string(number) severity note;
			if (number mod 8) < 4 then
				assert out8_tb = '0'
					report "out8 should be 0"
					severity error;
			else
				assert out8_tb = '1'
					report "out8 should be 1"
					severity error;
			end if;

			if (number mod 4) < 2 then
				assert out4_tb = '0'
					report "out4 should be 0"
					severity error;
			else
				assert out4_tb = '1'
					report "out4 should be 1"
					severity error;
			end if;

			if number mod 2 = 0 then
				assert out2_tb = '0'
					report "out2 should be 0"
					severity error;
			else
				assert out2_tb = '1'
					report "out2 should be 1"
					severity error;
			end if;

			wait for 10 ns;
			trigger_tb <= '1';
			wait for 10 ns;
			trigger_tb <= '0';
		end loop;

		report "Test completed.";
		std.env.stop;
	end process;

end architecture;
