library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	use ieee.math_real.all;

entity clock_divider is
	generic (
		divisor : natural := 2
	);
	port (
		clk, reset : in  std_logic;
		clock_out  : out std_logic
	);
end entity;

architecture implementation of clock_divider is
	signal tick_count : unsigned(integer(ceil(log2(real(divisor / 2)))) - 1 downto 0) := (others => '0');
	signal output     : std_logic                                                     := '0';

begin
	assert (divisor mod 2 = 0) report "Generic value divisor must be divisible by 2!" severity failure;

	divide_by_two: if divisor = 2 generate
		clock_out <= output;

		process (clk, reset)
		begin
			if reset = '1' then
				output <= '0';
			elsif rising_edge(clk) then
				output <= not output;
			end if;
		end process;
	else generate
		clock_out <= output;

		process (clk, reset)
		begin
			if reset = '1' then
				tick_count <= (others => '0');
				output <= '0';
			elsif rising_edge(clk) then
				if tick_count = divisor / 2 - 1 then
					tick_count <= (others => '0'); -- Reset count if max value is reached
					output <= not output;
				else
					tick_count <= tick_count + 1;
				end if;
			end if;
		end process;
	end generate;

end architecture;
