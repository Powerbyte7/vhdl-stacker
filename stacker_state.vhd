
library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
	use ieee.math_real.all;

entity stacker_state is
	generic (
		begin_state : std_ulogic_vector(5 downto 0);
		blink_cycle_duration : natural
	);
	port (
		-- Input
		clk              : in  std_ulogic                    := '0';
		action_key       : in  std_ulogic                    := '0';
		reset            : in  std_ulogic                    := '0';
		-- Passed to grid_display
		top_row          : in  std_ulogic_vector(5 downto 0) := (others => '0');
		bottom_row       : out std_ulogic_vector(5 downto 0) := begin_state;
		-- Passed to vector_ping_pong
		ping_pong_blocks : out std_ulogic_vector(5 downto 0) := begin_state;
		ping_pong_enable : out std_ulogic                    := '0';
		-- Passed to score_counter
		score_increase   : out std_ulogic                    := '0';
		score_show       : out std_ulogic                    := '0';
		score_reset      : out std_ulogic                    := '1';
		-- Passed to vector_ping_pong and speed_controller
		place_row        : out std_ulogic                    := '0'
	);
end entity;

architecture implementation of stacker_state is
	component counter is
		generic (
			max_count : natural := blink_cycle_duration
		);
		port (
			trigger, reset : in  std_ulogic;
			count          : out std_ulogic_vector(integer(ceil(log2(real(max_count)))) - 1 downto 0);
			count_done     : out std_ulogic
		);
	end component;

	-- State
	type state_type is (game_ready, game_start, moving_row, placed_row, game_over);
	signal state : state_type := game_ready;

	-- Used to blink lost blocks
	signal blocks_placed : std_ulogic_vector(5 downto 0) := begin_state;
	signal blocks_left   : std_ulogic_vector(5 downto 0) := begin_state;

	signal blink_counter_reset : std_ulogic := '1';
	signal blink_counter_done  : std_ulogic := '0';
	signal blink_counter_blink : std_ulogic := '0';
	signal blink_count         : std_ulogic_vector(integer(ceil(log2(real(blink_cycle_duration)))) - 1 downto 0);
begin
	blink_counter: counter
		port map (
			trigger    => clk,
			reset      => blink_counter_reset,
			count_done => blink_counter_done,
			count      => blink_count
		);

	-- Blink 4 times using single bit in count.
	blink_counter_blink <= blink_count(integer(ceil(log2(real(blink_cycle_duration)))) / 4);

	process (clk, reset)
	begin
		if reset = '1' then
			state <= game_ready;
		elsif rising_edge(clk) then
			case state is
				when game_ready =>
					score_reset <= '1';
					place_row <= '1';
					if action_key = '1' then
						state <= game_start;
						report "STATE: START";
						ping_pong_blocks <= "001110";
						bottom_row <= "001110";
					end if;
				when game_start =>
					place_row <= '0';
					score_reset <= '0';
					if action_key = '0' then
						state <= moving_row;
						report "STATE: MOVING";
					else
						state <= game_start;
					end if;
				when moving_row =>
					-- Check whether rows match after button press
					if action_key = '1' then
						blink_counter_reset <= '0';
						blocks_placed <= top_row;
						blocks_left <= bottom_row and top_row;
						state <= placed_row;
						report "STATE: PLACED";
						place_row <= '1';
						score_increase <= '0';
					else
						place_row <= '0';
						blink_counter_reset <= '1';
					end if;
				when placed_row =>
					-- Wait temporarily before continuing
					-- Any lost blocks will blink
					if blink_counter_done = '1' and action_key = '0' then
						if blocks_left = "000000" then
							-- No blocks are left, game over
							state <= game_over;
							report "STATE: OVER";
						else
							-- Some blocks are left
							state <= moving_row;
							report "STATE: MOVING";
							ping_pong_blocks <= blocks_left;
							bottom_row <= blocks_left;
							score_increase <= '1';
						end if;
					elsif blink_counter_blink = '0' then
						ping_pong_blocks <= blocks_left;
					elsif blink_counter_blink = '1' then
						ping_pong_blocks <= blocks_placed;
					end if;
				when game_over =>
					-- Show score until user presses button
					if action_key = '1' then
						state <= game_ready;
					end if;
			end case;
		end if;
	end process;

	process (state) -- , input)
	begin
		case state is
			when game_ready =>
				-- Display starting info
				ping_pong_enable <= '0';
				score_show <= '0';
			when game_start =>
				-- Display starting info
				ping_pong_enable <= '0';
				score_show <= '0';
			when moving_row =>
				-- Move top blocks from left to right
				ping_pong_enable <= '1';
				score_show <= '0';
			when placed_row =>
				ping_pong_enable <= '1';
				score_show <= '0';
			when game_over =>
				ping_pong_enable <= '0';
				score_show <= '1';
		end case;
	end process;
end architecture;
