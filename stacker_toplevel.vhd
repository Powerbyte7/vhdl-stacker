library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

entity stacker_toplevel is
	port (
		CLOCK_50 : in  std_ulogic;
		KEY      : in  std_ulogic_vector(3 downto 0);
		SW       : in  std_ulogic_vector(9 downto 0);
		LEDR     : out std_ulogic_vector(9 downto 0);
		HEX0     : out std_ulogic_vector(6 downto 0);
		HEX1     : out std_ulogic_vector(6 downto 0);
		HEX2     : out std_ulogic_vector(6 downto 0);
		HEX3     : out std_ulogic_vector(6 downto 0);
		HEX4     : out std_ulogic_vector(6 downto 0);
		HEX5     : out std_ulogic_vector(6 downto 0)
	);
end entity;

architecture implementation of stacker_toplevel is
	component stacker is
		port (
			clk, reset, action_key : in  std_ulogic;
			led_row                : out std_ulogic_vector(9 downto 0);
			hex_display            : out std_ulogic_vector(41 downto 0)
		);
	end component;
begin
	game: stacker
		port map (
			clk                       => CLOCK_50,
			reset                     => not KEY(3),
			action_key                => not KEY(0),
			led_row                   => LEDR,
			hex_display(6 downto 0)   => HEX0,
			hex_display(13 downto 7)  => HEX1,
			hex_display(20 downto 14) => HEX2,
			hex_display(27 downto 21) => HEX3,
			hex_display(34 downto 28) => HEX4,
			hex_display(41 downto 35) => HEX5
		);
end architecture;
