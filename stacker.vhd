library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	use ieee.math_real.all;

entity stacker is
	port (
		clk         : in  std_ulogic;
		reset       : in  std_ulogic;
		action_key  : in  std_ulogic;
		led_row     : out std_ulogic_vector(9 downto 0);
		hex_display : out std_ulogic_vector(41 downto 0)
	);
end entity;

architecture implementation of stacker is
	component synchronizer is
		port (
			clk    : in  std_ulogic;
			input  : in  std_ulogic;
			output : out std_ulogic
		);
	end component;
	component ss_grid_display is
		generic (
			digits_horizontal : integer := 6
		);
		port (
			enable     : in  std_ulogic;
			-- Each digit can hold show two blocks
			top_row    : in  std_ulogic_vector(digits_horizontal - 1 downto 0);
			bottom_row : in  std_ulogic_vector(digits_horizontal - 1 downto 0);
			output     : out std_ulogic_vector((digits_horizontal * 7) - 1 downto 0)
		);
	end component;
	component clock_divider is
		generic (
			divisor : natural := 10000000
		);
		port (
			clk, reset : in  std_logic;
			clock_out  : out std_logic
		);
	end component;
	component vector_ping_pong is
		generic (
			-- Switches direction when edge bit holds this value
			bit_value : std_ulogic := '1';
			bit_count : natural    := 6
		);
		port (
			clk             : in  std_ulogic;
			enable_movement : in  std_ulogic;
			reset           : in  std_ulogic;
			bits_in         : in  std_ulogic_vector(bit_count - 1 downto 0);
			bits_out        : out std_ulogic_vector(bit_count - 1 downto 0)
		);
	end component;
	component stacker_state is
		port (
			-- Input
			clk              : in  std_ulogic;
			action_key       : in  std_ulogic;
			reset            : in  std_ulogic;
			-- Passed to grid_display
			top_row          : in  std_ulogic_vector(5 downto 0) := (others => '0');
			bottom_row       : out std_ulogic_vector(5 downto 0) := "001110";
			-- Passed to vector_ping_pong
			ping_pong_blocks : out std_ulogic_vector(5 downto 0) := "001110";
			ping_pong_reset  : out std_ulogic;
			ping_pong_enable : out std_ulogic;
			-- Passed to score_counter
			score_increase   : out std_ulogic;
			score_show       : out std_ulogic;
			score_reset      : out std_ulogic
		);
	end component;
	component score_counter is
		port (
			reset           : in  std_ulogic;
			score_increase  : in  std_ulogic;
			score_reset     : in  std_ulogic;
			score_highscore : out std_ulogic;
			-- 6 nibbles
			score_display   : out std_ulogic_vector(41 downto 0)
		);
	end component;

	-- Logic
	signal clk_ping_pong    : std_ulogic;
	signal ping_pong_enable : std_ulogic;
	signal ping_pong_reset  : std_ulogic;
	signal score_highscore  : std_ulogic;
	signal score_increase   : std_ulogic;
	signal score_show       : std_ulogic;
	signal score_reset      : std_ulogic;

	-- State
	signal ping_pong_blocks : std_ulogic_vector(5 downto 0) := "001110";

	-- Display
	signal top_row       : std_ulogic_vector(5 downto 0);
	signal bottom_row    : std_ulogic_vector(5 downto 0) := "001110";
	signal grid_display  : std_ulogic_vector(41 downto 0);
	signal score_display : std_ulogic_vector(41 downto 0);

	signal action_key_synchronized : std_ulogic;
begin
	display: ss_grid_display
		port map (
			enable     => '1',
			top_row    => top_row,
			bottom_row => bottom_row,
			output     => grid_display
		);

	ping_pong_clock: clock_divider
		port map (
			clk       => clk,
			reset     => reset,
			clock_out => clk_ping_pong
		);

	row_top: vector_ping_pong
		port map (
			reset           => ping_pong_reset,
			clk             => clk_ping_pong,
			enable_movement => ping_pong_enable,
			bits_in         => ping_pong_blocks,
			bits_out        => top_row
		);

	action_synchronizer: synchronizer
		port map (
			clk    => clk,
			input  => action_key,
			output => action_key_synchronized
		);

	scorecount: score_counter
		port map (
			reset           => reset,
			score_increase  => score_increase,
			score_reset     => score_reset,
			score_highscore => score_highscore,
			score_display   => score_display
		);

	state: stacker_state
		port map (
			clk              => clk,
			action_key       => action_key_synchronized,
			reset            => reset,
			ping_pong_reset  => ping_pong_reset,
			ping_pong_enable => ping_pong_enable,
			top_row          => top_row,
			bottom_row       => bottom_row,
			ping_pong_blocks => ping_pong_blocks,
			score_increase   => score_increase,
			score_reset      => score_reset,
			score_show       => score_show
		);

	-- DEBUG
	-- led_row(0) <= clk_ping_pong;
	-- led_row(1) <= score_show;
	-- led_row(2) <= score_highscore;

	-- led_row(3) <= score_increase;
	process (clk)
	begin
		if rising_edge(clk) then
			if score_show = '1' then
				hex_display <= score_display;
				if score_highscore = '1' then
					led_row <= (others => clk_ping_pong);
				end if;
			else
				hex_display <= grid_display;
				led_row <= (others => '0');
			end if;
		end if;
	end process;
end architecture;
