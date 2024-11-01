library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

entity ss_decoder is
	generic (
		digits : natural := 6
	);
	port (
		bcd      : in  std_ulogic_vector((digits * 4) - 1 downto 0);
		blank    : in  std_ulogic_vector((digits) - 1 downto 0);
		ss_codes : out std_ulogic_vector((digits * 7) - 1 downto 0)
	);
end entity;

architecture implementation of ss_decoder is
	-- Define a constant array representing the lookup table
	type lut_array is array (0 to 31) of std_ulogic_vector(6 downto 0);

	-- Initialize the lookup table with values
	constant LUT : lut_array := (
		"1000000", -- LUT entry for input 00000 (0)
		"1111001", -- LUT entry for input 00001 (1)
		"0100100", -- LUT entry for input 00010 (2)
		"0110000", -- LUT entry for input 00011 (3)
		"0011001", -- LUT entry for input 00100 (4)
		"0010010", -- LUT entry for input 00101 (5)
		"0000010", -- LUT entry for input 00110 (6)
		"1111000", -- LUT entry for input 00111 (7)
		"0000000", -- LUT entry for input 01000 (8)
		"0010000", -- LUT entry for input 01001 (9)
		"0001000", -- LUT entry for input 01010 (A)
		"0000011", -- LUT entry for input 01011 (B)
		"1000110", -- LUT entry for input 01100 (C)
		"0100001", -- LUT entry for input 01101 (D)
		"0000110", -- LUT entry for input 01110 (E)
		"0001110", -- LUT entry for input 01111 (F)
		-- Blank
		"1111111",
		"1111111",
		"1111111",
		"1111111",
		"1111111",
		"1111111",
		"1111111",
		"1111111",
		"1111111",
		"1111111",
		"1111111",
		"1111111",
		"1111111",
		"1111111",
		"1111111",
		"1111111"
	);

begin
	process (bcd, blank) is
	begin
		for i in 0 to integer(digits-1) loop
			ss_codes(i * 7 + 6 downto i * 7) <= LUT(to_integer(unsigned(blank(i) & bcd(i * 4 + 3 downto i * 4))));
		end loop;
	end process;
end architecture;
