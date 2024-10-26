
library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	use ieee.math_real.all;

	-- The entity of your testbench. No ports declaration in this case.

entity ss_grid_display_tb is
end entity;

architecture testbench of ss_grid_display_tb is
	-- The component declaration should match your entity.
	-- It is very important that the name of the component and the 
	-- ports (remember direction of ports!) match your entity! 
	component ss_grid_display is
		generic (
			digits_horizontal : integer := 6
		);
		port (
			enable     : in  std_ulogic;
			-- Each digit can hold show two squares
			top_row    : in  std_ulogic_vector(digits_horizontal - 1 downto 0);
			bottom_row : in  std_ulogic_vector(digits_horizontal - 1 downto 0);
			output     : out std_ulogic_vector((digits_horizontal * 7) - 1 downto 0)
		);
	end component;
	-- Signal declaration. These signals are used to drive your
	-- inputs and store results (if required).
	signal enable_tb  : std_ulogic;
	signal top_row    : std_ulogic_vector(5 downto 0);
	signal bottom_row : std_ulogic_vector(5 downto 0);
	signal display_tb : std_ulogic_vector(41 downto 0);
begin
	-- A port map is in this case nothing more than a construction to
	-- connect your entity ports with your signals.
	duv: ss_grid_display
		port map (
			top_row    => top_row,
			bottom_row => bottom_row,
			enable     => enable_tb,
			output     => display_tb
		);

	process
		type int_array is array (0 to 15) of integer;
	begin
		report "Testing entity assignment2.";
		-- Initialize signals.
		enable_tb <= '1';
		top_row <= (others => '0');
		bottom_row <= (others => '0');
		wait for 10 ns;

		-- Check if display outputs all 1 by default (Note that 1 means OFF)
		assert display_tb = (display_tb'range => '1')
			report "test failed for display_tb = 1, result is " & to_string(display_tb)
			severity error;
            
		wait for 10 ns;

		-- Two squares on digit 0
		top_row(0) <= '1';
		bottom_row(0) <= '1';
		-- Top square on digit 1
		top_row(1) <= '1';
		-- Bottom square on digit 2
		bottom_row(2) <= '1';

		wait for 10 ns;

		-- Check if display outputs match for digits 0-2 (Note that 0 means ON)
		assert display_tb(6 downto 0) = "0000000"
			report "test failed for two squares on digit 0, result is " & to_string(display_tb(6 downto 0))
			severity error;
		assert display_tb(13 downto 7) = "0011100"
			report "test failed for top square on digit 1, result is " & to_string(display_tb(13 downto 7))
			severity error;
		assert display_tb(20 downto 14) = "0100011"
			report "test failed for bottom square on digit 2, result is " & to_string(display_tb(20 downto 14))
			severity error;

		report "Test completed.";
		std.env.stop;
	end process;

end architecture;
