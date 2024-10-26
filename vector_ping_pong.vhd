library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

entity vector_ping_pong is
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
end entity;

architecture implementation of vector_ping_pong is
	signal bits : std_ulogic_vector(bit_count - 1 downto 0);
	type state_direction is (left, right);
	signal direction : state_direction := left;
begin
	bits_out <= bits;

	process (clk, reset)
	begin
		if reset = '1' then
			bits <= bits_in;
		elsif rising_edge(clk) then
			if enable_movement = '1' then
				if bits(0) = bit_value and bits(bit_count - 1) = bit_value then
					-- Bits touching on both sides, do nothing
				elsif bits(0) = bit_value and direction = right then
					-- Bit touching right edge, move left by 1
					bits <= bits(bit_count - 2 downto 0) & (not bit_value);
					-- Go left next time
					direction <= left;
				elsif bits(bit_count - 1) = bit_value and direction = left then
					-- Bit touching left edge, move right by 1
					bits <= (not bit_value) & bits(bit_count - 1 downto 1);
					-- Bits touching left edge, go right next time
					direction <= right;
				else
					if direction = left then
						-- Move left by 1
						bits <= bits(bit_count - 2 downto 0) & (not bit_value);
					else
						-- Move right by 1
						bits <= (not bit_value) & bits(bit_count - 1 downto 1);
					end if;
				end if;
			end if;
		end if;
	end process;
end architecture;
