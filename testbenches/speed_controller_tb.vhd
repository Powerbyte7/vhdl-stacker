
library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	use ieee.math_real.all;

	-- The entity of your testbench. No ports declaration in this case.

entity speed_controller_tb is
end entity;

architecture testbench of speed_controller_tb is
	-- The component declaration should match your entity.
	-- It is very important that the name of the component and the 
	-- ports (remember direction of ports!) match your entity! 
	component speed_controller is
		generic (
			interval : natural                    := 4;
			speedup  : integer range 0 to 600_000 := 1
		);
		port (
			clk, reset     : in  std_ulogic;
			speed_increase : in  std_ulogic;
			clk_out        : out std_ulogic
		);
	end component;
	-- Signal declaration. These signals are used to drive your
	-- inputs and store results (if required).
	signal trigger_tb        : std_ulogic := '0';
	signal reset_tb          : std_ulogic := '0';
	signal speed_increase_tb : std_ulogic := '0';
	signal out_tb            : std_ulogic;
begin
	-- A port map is in this case nothing more than a construction to
	-- connect your entity ports with your signals.
	duv: speed_controller
		port map (
			reset          => reset_tb,
			clk            => trigger_tb,
			speed_increase => speed_increase_tb,
			clk_out        => out_tb
		);

	process
	begin
		report "Testing entity speed_controller.";
		-- Initialize signals.
		reset_tb <= '0';
		trigger_tb <= '0';
		wait for 10 ns;

		-- Check if controller outputs 0 by default
		assert out_tb = '0'
			report "test failed for out_tb = 0, result is " & to_string(out_tb)
			severity error;

		-- Initial interval is 4
		-- Check if pulse is received after 4 rising edges
		for i in 1 to 16 loop
			wait for 10 ns;
			trigger_tb <= '1';
			wait for 10 ns;
			trigger_tb <= '0';

			if i mod 4 = 0 then
				assert out_tb = '1'
					report "interval 4 failed for i = " & to_string(i) & ", result is " & to_string(out_tb)
					severity error;
			else
				assert out_tb = '0'
					report "interval 4 failed for i = " & to_string(i) & ", result is " & to_string(out_tb)
					severity error;
			end if;
		end loop;

		-- Increase speed, new interval is 3
		wait for 10 ns;
		trigger_tb <= '1';
		speed_increase_tb <= '1';
		wait for 10 ns;
		trigger_tb <= '0';
		wait for 10 ns;
		trigger_tb <= '1';
		wait for 10 ns;
		trigger_tb <= '0';
		speed_increase_tb <= '0';

		-- Same check, but with mod 3
		for i in 2 to 15 loop
			wait for 10 ns;
			trigger_tb <= '1';
			wait for 10 ns;
			trigger_tb <= '0';

			if i mod 3 = 0 then
				assert out_tb = '1'
					report "interval 3 failed for i = " & to_string(i) & ", result is " & to_string(out_tb)
					severity error;
			else
				assert out_tb = '0'
					report "interval 3 failed for i = " & to_string(i) & ", result is " & to_string(out_tb)
					severity error;
			end if;
		end loop;

		-- Increase speed, new interval is 2
		wait for 10 ns;
		trigger_tb <= '1';
		speed_increase_tb <= '1';
		wait for 10 ns;
		trigger_tb <= '0';
		wait for 10 ns;
		trigger_tb <= '1';
		wait for 10 ns;
		trigger_tb <= '0';
		speed_increase_tb <= '0';

		-- Same check, but with mod 2
		for i in 2 to 16 loop
			wait for 10 ns;
			trigger_tb <= '1';
			wait for 10 ns;
			trigger_tb <= '0';

			if i mod 2 = 0 then
				assert out_tb = '1'
					report "interval 2 failed for i = " & to_string(i) & ", result is " & to_string(out_tb)
					severity error;
			else
				assert out_tb = '0'
					report "interval 2 failed for i = " & to_string(i) & ", result is " & to_string(out_tb)
					severity error;
			end if;
		end loop;

		report "Test completed.";
		std.env.stop;
	end process;

end architecture;
