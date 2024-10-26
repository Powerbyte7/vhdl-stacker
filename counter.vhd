library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	use ieee.math_real.all;

entity counter is
	generic (
		max_count : natural := 9
	);
	port (
		trigger, reset : in  std_ulogic;
		count          : out std_ulogic_vector(integer(ceil(log2(real(max_count)))) - 1 downto 0);
		count_done   : out std_ulogic
	);
end entity;

architecture implementation of counter is
	signal tick_counter : unsigned(integer(ceil(log2(real(max_count)))) - 1 downto 0) := (others => '0');
	signal done         : std_ulogic                                                  := '0';
begin
	count_done <= done;

	process (trigger, reset)
	begin
		if reset = '1' then
			tick_counter <= (others => '0');
			done <= '0';
		elsif rising_edge(trigger) then
			if tick_counter = MAX_COUNT then
				tick_counter <= (others => '0'); -- Reset count if max value is reached
				done <= '1';
			else
				tick_counter <= tick_counter + 1;
			end if;
		end if;
	end process;

	-- Assign the count to the output, converting integer to STD_LOGIC_VECTOR
	count <= std_ulogic_vector(unsigned(tick_counter));
end architecture;
