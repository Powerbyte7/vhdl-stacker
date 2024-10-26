
library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	use ieee.math_real.all;

	-- The entity of your testbench. No ports declaration in this case.

entity counter_tb is
end entity;

architecture testbench of counter_tb is
	-- The component declaration should match your entity.
	-- It is very important that the name of the component and the 
	-- ports (remember direction of ports!) match your entity! 
	component counter is
		generic (
			max_count : natural := 9
		);
		port (
			trigger, reset : in  std_ulogic;
			count          : out std_ulogic_vector(integer(ceil(log2(real(max_count)))) - 1 downto 0);
			count_done     : out std_ulogic
		);
	end component;
	-- Signal declaration. These signals are used to drive your
	-- inputs and store results (if required).
	signal trigger_tb    : std_ulogic;
	signal reset_tb      : std_ulogic;
	signal count_done_tb : std_ulogic;
	signal count_tb      : std_ulogic_vector(3 downto 0);
begin
	-- A port map is in this case nothing more than a construction to
	-- connect your entity ports with your signals.
	duv: counter
		port map (
			reset      => reset_tb,
			trigger    => trigger_tb,
			count      => count_tb,
			count_done => count_done_tb
		);

	process
		type int_array is array (0 to 15) of integer;
	begin
		report "Testing entity assignment2.";
		-- Initialize signals.
		trigger_tb <= '0';
		reset_tb <= '0';
		wait for 10 ns;

		-- Check if counter outputs 0 by default
		assert count_tb = "0000"
			report "test failed for count_tb = 0000, result is " & to_string(count_tb)
			severity error;
		assert count_done_tb = '0'
			report "test failed for counter completion, result is " & to_string(count_done_tb)
			severity error;

		-- Loop through all possible values of addition
		for number in 1 to 9 loop
			trigger_tb <= '1';
			wait for 10 ns;

			-- Check result of addition
			assert count_tb = std_ulogic_vector(to_unsigned(number, 4))
				report "test failed for " & to_string(to_unsigned(number, 4)) & " result is " & to_string(count_tb)
				severity error;

			trigger_tb <= '0';
			wait for 10 ns;
		end loop;

		-- Counter shouldn't be done yet
		assert count_done_tb = '0'
			report "test failed for counter completion, result is " & to_string(count_done_tb)
			severity error;

		for number in 0 to 5 loop
			trigger_tb <= '1';
			wait for 10 ns;

			-- Check result of addition
			assert count_tb = std_ulogic_vector(to_unsigned(number, 4))
				report "test failed for " & to_string(to_unsigned(number, 4)) & " result is " & to_string(count_tb)
				severity error;

			trigger_tb <= '0';
			wait for 10 ns;
		end loop;

		-- Check if counter is done
		assert count_done_tb = '1'
			report "test failed for counter completion, result is " & to_string(count_done_tb)
			severity error;

		report "Test completed.";
		std.env.stop;
	end process;

end architecture;
