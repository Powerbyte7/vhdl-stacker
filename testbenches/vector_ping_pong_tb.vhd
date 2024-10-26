
library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	use ieee.math_real.all;

	-- The entity of your testbench. No ports declaration in this case.

entity vector_ping_pong_tb is
end entity;

architecture testbench of vector_ping_pong_tb is
	-- The component declaration should match your entity.
	-- It is very important that the name of the component and the 
	-- ports (remember direction of ports!) match your entity! 
	component vector_ping_pong is
		generic (
			-- Switches direction when edge bit holds this value
			bit_value : std_ulogic := '1';
			bit_count : natural    := 6
		);
		port (
			clk, enable_movement, reset : in  std_ulogic;
			bits_in                     : in  std_ulogic_vector(bit_count - 1 downto 0);
			bits_out                    : out std_ulogic_vector(bit_count - 1 downto 0)
		);
	end component;
	-- Signal declaration. These signals are used to drive your
	-- inputs and store results (if required).
	signal clk_tb    : std_ulogic;
	signal reset_tb  : std_ulogic;
	signal out_tb    : std_ulogic_vector(5 downto 0);
	signal enable_tb : std_ulogic;
	signal input_tb  : std_ulogic_vector(5 downto 0);
begin
	-- A port map is in this case nothing more than a construction to
	-- connect your entity ports with your signals.
	duv: vector_ping_pong
		port map (
			reset           => reset_tb,
			clk             => clk_tb,
			enable_movement => enable_tb,
			bits_in         => input_tb,
			bits_out        => out_tb
		);

	process
	begin
		report "Testing entity assignment2.";
		-- Initialize signals.
		input_tb <= "110000";
		enable_tb <= '1';
		clk_tb <= '0';
		reset_tb <= '0';
		wait for 10 ns;
		reset_tb <= '1';
		wait for 10 ns;
		reset_tb <= '0';
		wait for 10 ns;

		-- Changing input after reset shouldn't affect component
		input_tb <= "100001";

		-- Check if inital output is correct 
		assert out_tb = "110000"
			report "test failed for out_tb = 110000, result is " & to_string(out_tb)
			severity error;

		wait for 10 ns;

		-- Check right shift
		for i in 3 downto 0 loop
			clk_tb <= '1';
			wait for 10 ns;

			assert out_tb(i) = '1'
				report "RS+0 Iteration " & to_string(i) & ", got " & to_string(out_tb)
				severity error;
			assert out_tb(i + 1) = '1'
				report "RS+1 Iteration " & to_string(i) & ", got " & to_string(out_tb)
				severity error;

			clk_tb <= '0';
			wait for 10 ns;
		end loop;

		-- Check left shift
		for i in 1 to 4 loop
			clk_tb <= '1';
			wait for 10 ns;
			assert out_tb(i) = '1'
				report "LS+0 Iteration " & to_string(i) & ", got " & to_string(out_tb)
				severity error;
			assert out_tb(i + 1) = '1'
				report "LS+1 Iteration " & to_string(i) & ", got " & to_string(out_tb)
				severity error;
			clk_tb <= '0';
			wait for 10 ns;
		end loop;

		-- Check enable functionality
		enable_tb <= '0';
		wait for 10 ns;
		clk_tb <= '1';
		wait for 10 ns;
		clk_tb <= '0';
		wait for 10 ns;

		-- output should be unchanged 
		assert out_tb = "110000"
			report "test failed for enable functionality, result is " & to_string(out_tb)
			severity error;

		-- output should match input_tb when reset is 1
		wait for 10 ns;
		reset_tb <= '1';
		wait for 10 ns;

		assert out_tb = "100001"
			report "test failed reset functionality, result is " & to_string(out_tb)
			severity error;

		report "Test completed.";
		std.env.stop;
	end process;

end architecture;
