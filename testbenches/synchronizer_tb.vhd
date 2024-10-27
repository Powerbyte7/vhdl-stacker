
library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	use ieee.math_real.all;

	-- The entity of your testbench. No ports declaration in this case.

entity synchronizer_tb is
end entity;

architecture testbench of synchronizer_tb is
	-- The component declaration should match your entity.
	-- It is very important that the name of the component and the 
	-- ports (remember direction of ports!) match your entity! 
	component synchronizer is
		port (
			clk    : in  std_ulogic;
			input  : in  std_ulogic;
			output : out std_ulogic
		);
	end component;
	-- Signal declaration. These signals are used to drive your
	-- inputs and store results (if required).
	signal clk_tb    : std_ulogic;
	signal input_tb  : std_ulogic;
	signal output_tb : std_ulogic;
begin
	-- A port map is in this case nothing more than a construction to
	-- connect your entity ports with your signals.
	duv: synchronizer
		port map (
			clk    => clk_tb,
			input  => input_tb,
			output => output_tb
		);

	process
		type int_array is array (0 to 15) of integer;
	begin
		report "Testing entity synchronizer.";
		-- Initialize signals.
		clk_tb <= '0';
		input_tb <= '0';

        assert not (output_tb = '1') report "Output should be 0, got " & to_string(output_tb) severity error;
        
        wait for 10 ns;
        input_tb <= '1';
        clk_tb <= '1';
        wait for 10 ns;
        clk_tb <= '0';

        assert not (output_tb = '1')  report "Output should be 0, got " & to_string(output_tb) severity error;

        wait for 10 ns;
        clk_tb <= '1';
        wait for 10 ns;
        clk_tb <= '0';

        assert not (output_tb = '0')  report "Output should be 1, got " & to_string(output_tb) severity error;

        wait for 10 ns;
        input_tb <= '0';
        clk_tb <= '1';
        wait for 10 ns;
        clk_tb <= '0';

        assert not (output_tb = '0')  report "Output should be 1, got " & to_string(output_tb) severity error;

        wait for 10 ns;
        clk_tb <= '1';
        wait for 10 ns;
        clk_tb <= '0';

        assert not (output_tb = '1')  report "Output should be 0, got " & to_string(output_tb) severity error;


		report "Test completed.";
		std.env.stop;
	end process;

end architecture;
