library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	use ieee.math_real.all;

entity speed_controller is
	generic (
		interval : natural                    := 15_000_000;
		speedup  : integer range 0 to 600_000 := 500_000
	);
	port (
		clk, reset     : in  std_ulogic;
		speed_increase : in  std_ulogic;
		clk_out        : out std_ulogic
	);
end entity;

architecture implementation of speed_controller is
	signal tick_counter     : unsigned(28 downto 0) := to_unsigned(interval - 1, 29);
	signal current_interval : unsigned(28 downto 0) := to_unsigned(interval - 1, 29);
	signal done             : std_ulogic            := '0';
	-- To avoid increasing speed on every clock cycle
	signal speed_increased : std_ulogic := '0';
begin
	clk_out <= done;

	process (clk, reset)
	begin
		if reset = '1' then
			tick_counter <= to_unsigned(interval - 1, 29);
			done <= '0';
			speed_increased <= '0';
			current_interval <= to_unsigned(interval - 1, 29);
		elsif rising_edge(clk) then
			if speed_increased = '0' and speed_increase = '1' then
				speed_increased <= '1';
				tick_counter <= current_interval - to_unsigned(speedup, 20);
			elsif speed_increased = '1' and speed_increase = '1' then
				current_interval <= tick_counter;
			elsif speed_increase = '0' then
				speed_increased <= '0';
			end if;

			if tick_counter = 0 and speed_increase = '0' then
				tick_counter <= current_interval; -- Reset count if 0 is reached
				done <= '1';
			else
				done <= '0';
				tick_counter <= tick_counter - 1;
			end if;
		end if;
	end process;
end architecture;
