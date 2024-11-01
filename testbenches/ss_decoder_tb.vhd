
library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	use ieee.math_real.all;
	-- The entity of your testbench. No ports declaration in this case.

entity ss_decoder_tb is
end entity;

architecture testbench of ss_decoder_tb is
	-- The component declaration should match your entity.
	-- It is very important that the name of the component and the 
	-- ports (remember direction of ports!) match your entity! 
	component ss_decoder is
		generic (
			digits : natural := 6
		);
		port (
			bcd      : in  std_ulogic_vector((digits * 4) - 1 downto 0);
			blank    : in  std_ulogic_vector((digits) - 1 downto 0);
			ss_codes : out std_ulogic_vector((digits * 7) - 1 downto 0)
		);
	end component;
	-- Signal declaration. These signals are used to drive your
	-- inputs and store results (if required).
	signal bcd_tb        : unsigned(23 downto 0)         := (others => '0');
	signal blank_tb      : std_ulogic_vector(5 downto 0) := (others => '1');
	signal ss_codes_tb   : std_ulogic_vector(41 downto 0);
	signal ss_compare_tb : std_ulogic_vector(41 downto 0);
begin
	-- A port map is in this case nothing more than a construction to
	-- connect your entity ports with your signals.
	duv: ss_decoder
		port map (
			bcd      => std_ulogic_vector(bcd_tb),
			blank    => blank_tb,
			ss_codes => ss_codes_tb
		);

	process
	begin
		report "Testing entity ss_decoder_tb.";
		bcd_tb <= (others => '0');
		blank_tb <= (others => '1');
		ss_compare_tb <= (others => '1');
		wait for 10 ns;

		assert ss_codes_tb = ss_compare_tb report "expected blank display, got " & to_string(ss_codes_tb(6 downto 0)) severity error;
		wait for 10 ns;
		blank_tb <= (others => '0');
		wait for 10 ns;

		-- 0
		assert ss_codes_tb(6 downto 0) = "1000000" report "expected 1000000, got " & to_string(ss_codes_tb(6 downto 0)) severity error;
		wait for 10 ns;
		bcd_tb <= bcd_tb + 1;
		wait for 10 ns;
		-- 1
		assert ss_codes_tb(6 downto 0) = "1111001" report "expected 1111001, got " & to_string(ss_codes_tb(6 downto 0)) severity error;
		wait for 10 ns;
		bcd_tb <= bcd_tb + 1;
		wait for 10 ns;
		-- 2
		assert ss_codes_tb(6 downto 0) = "0100100" report "expected 0100100, got " & to_string(ss_codes_tb(6 downto 0)) severity error;
		wait for 10 ns;
		bcd_tb <= bcd_tb + 1;
		wait for 10 ns;
		-- 3
		assert ss_codes_tb(6 downto 0) = "0110000" report "expected 0110000, got " & to_string(ss_codes_tb(6 downto 0)) severity error;
		wait for 10 ns;
		bcd_tb <= bcd_tb + 1;
		wait for 10 ns;
		-- 4
		assert ss_codes_tb(6 downto 0) = "0011001" report "expected 0011001, got " & to_string(ss_codes_tb(6 downto 0)) severity error;
		wait for 10 ns;
		bcd_tb <= bcd_tb + 1;
		wait for 10 ns;
		-- 5
		assert ss_codes_tb(6 downto 0) = "0010010" report "expected 0010010, got " & to_string(ss_codes_tb(6 downto 0)) severity error;
		wait for 10 ns;
		bcd_tb <= bcd_tb + 1;
		wait for 10 ns;
		-- 6
		assert ss_codes_tb(6 downto 0) = "0000010" report "expected 0000010, got " & to_string(ss_codes_tb(6 downto 0)) severity error;
		wait for 10 ns;
		bcd_tb <= bcd_tb + 1;
		wait for 10 ns;
		-- 7
		assert ss_codes_tb(6 downto 0) = "1111000" report "expected 1111000, got " & to_string(ss_codes_tb(6 downto 0)) severity error;
		wait for 10 ns;
		bcd_tb <= bcd_tb + 1;
		wait for 10 ns;
		-- 8
		assert ss_codes_tb(6 downto 0) = "0000000" report "expected 0000000, got " & to_string(ss_codes_tb(6 downto 0)) severity error;
		wait for 10 ns;
		bcd_tb <= bcd_tb + 1;
		wait for 10 ns;
		-- 9
		assert ss_codes_tb(6 downto 0) = "0010000" report "expected 0010000, got " & to_string(ss_codes_tb(6 downto 0)) severity error;
		wait for 10 ns;
		bcd_tb <= bcd_tb + 1;
		wait for 10 ns;
		-- 10/A
		assert ss_codes_tb(6 downto 0) = "0001000" report "expected 0001000, got " & to_string(ss_codes_tb(6 downto 0)) severity error;
		wait for 10 ns;
		bcd_tb <= bcd_tb + 1;
		wait for 10 ns;
		-- 11/B
		assert ss_codes_tb(6 downto 0) = "0000011" report "expected 0000011, got " & to_string(ss_codes_tb(6 downto 0)) severity error;
		wait for 10 ns;
		bcd_tb <= bcd_tb + 1;
		wait for 10 ns;
		-- 12/C
		assert ss_codes_tb(6 downto 0) = "1000110" report "expected 1000110, got " & to_string(ss_codes_tb(6 downto 0)) severity error;
		wait for 10 ns;
		bcd_tb <= bcd_tb + 1;
		wait for 10 ns;
		-- 13/D
		assert ss_codes_tb(6 downto 0) = "0100001" report "expected 0100001, got " & to_string(ss_codes_tb(6 downto 0)) severity error;
		wait for 10 ns;
		bcd_tb <= bcd_tb + 1;
		wait for 10 ns;
		-- 14/E
		assert ss_codes_tb(6 downto 0) = "0000110" report "expected 0000110, got " & to_string(ss_codes_tb(6 downto 0)) severity error;
		wait for 10 ns;
		bcd_tb <= bcd_tb + 1;
		wait for 10 ns;
		-- 15/F
		assert ss_codes_tb(6 downto 0) = "0001110" report "expected 0001110, got " & to_string(ss_codes_tb(6 downto 0)) severity error;
		wait for 10 ns;
		bcd_tb <= bcd_tb + 1;
		wait for 10 ns;

		report "Test completed.";
		std.env.stop;
	end process;

end architecture;
