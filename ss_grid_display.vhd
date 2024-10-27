library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

entity ss_grid_display is
	generic (
		digits_horizontal : integer := 6
	);
	port (
		enable     : in  std_ulogic;
		-- Each digit can show two squares
		top_row    : in  std_ulogic_vector(digits_horizontal - 1 downto 0);
		bottom_row : in  std_ulogic_vector(digits_horizontal - 1 downto 0);
		output     : out std_ulogic_vector((digits_horizontal * 7) - 1 downto 0)
	);
end entity;

architecture implementation of ss_grid_display is
begin
	process (enable, top_row, bottom_row)
	begin
		for i in 0 to integer(digits_horizontal - 1) loop
			if enable = '0' then
				output(i * 7 + 6 downto i * 7) <= "1111111";
			elsif top_row(i) = '1' and bottom_row(i) = '1' then
				-- Square in both
				output(i * 7 + 6 downto i * 7) <= "0000000";
			elsif top_row(i) = '1' then
				-- Square in top
				output(i * 7 + 6 downto i * 7) <= "0011100";
			elsif bottom_row(i) = '1' then
				-- Square in bottom
				output(i * 7 + 6 downto i * 7) <= "0100011";
			else
				-- Empty
				output(i * 7 + 6 downto i * 7) <= "1111111";
			end if;
		end loop;
	end process;
end architecture;
