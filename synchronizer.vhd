library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

entity synchronizer is
	port (
		clk    : in  std_ulogic;
		input  : in  std_ulogic;
		output : out std_ulogic
	);
end entity;

architecture implementation of synchronizer is
	signal ff1 : std_ulogic;
	signal ff2 : std_ulogic;
begin
	process (clk) is
	begin
		if rising_edge(clk) then
			ff1 <= input;
			ff2 <= ff1;
		end if;
	end process;

	output <= ff2;
end architecture;
