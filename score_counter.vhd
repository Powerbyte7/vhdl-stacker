library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

entity score_counter is
	port (
		reset           : in  std_ulogic;
		score_increase  : in  std_ulogic;
		score_reset     : in  std_ulogic;
		score_highscore : out std_ulogic;
		-- 6 seven segment codes
		score_display   : out std_ulogic_vector(41 downto 0)
	);
end entity;

architecture implementation of score_counter is
	component seven_segment_decoder is
		port (
			hex_nibble         : in  std_ulogic_vector(3 downto 0);
			blank              : in  std_ulogic; -- blank control
			seven_segment_code : out std_ulogic_vector(6 downto 0)
		);
	end component;

	signal score       : unsigned(15 downto 0)          := (others => '0');
	signal highscore   : unsigned(15 downto 0)          := (others => '0');
	signal score_bcd   : std_ulogic_vector(23 downto 0) := (others => '0');
	signal score_blank : std_ulogic_vector(5 downto 0)  := (others => '1');
begin
	--score_display <= score_bcd;
	hex0: seven_segment_decoder
		port map (
			hex_nibble         => score_bcd(3 downto 0),
			blank              => score_blank(0),
			seven_segment_code => score_display(6 downto 0)
		);
	hex1: seven_segment_decoder
		port map (
			hex_nibble         => score_bcd(7 downto 4),
			blank              => score_blank(1),
			seven_segment_code => score_display(13 downto 7)
		);
	hex2: seven_segment_decoder
		port map (
			hex_nibble         => score_bcd(11 downto 8),
			blank              => score_blank(2),
			seven_segment_code => score_display(20 downto 14)
		);
	hex3: seven_segment_decoder
		port map (
			hex_nibble         => score_bcd(15 downto 12),
			blank              => score_blank(3),
			seven_segment_code => score_display(27 downto 21)
		);
	hex4: seven_segment_decoder
		port map (
			hex_nibble         => score_bcd(19 downto 16),
			blank              => score_blank(4),
			seven_segment_code => score_display(34 downto 28)
		);
	hex5: seven_segment_decoder
		port map (
			hex_nibble         => score_bcd(23 downto 20),
			blank              => score_blank(5),
			seven_segment_code => score_display(41 downto 35)
		);

	process (score_reset, reset, score_increase)
	begin
		if reset = '1' then
			score_blank <= "111111";
			highscore <= (others => '0');
			score <= (others => '0');
			score_bcd <= (others => '0');
			-- score_display <= (others => '0');
			score_highscore <= '0';
		elsif score_reset = '1' then
			score_blank <= "111111";
			score <= (others => '0');
			score_bcd <= (others => '0');
			-- score_display <= (others => '0');
			score_highscore <= '0';
		elsif rising_edge(score_increase) then
			if score >= highscore then
				highscore <= highscore + 1;
				score_highscore <= '1';
			end if;
			score <= score + 1;

			-- Instead of converting binary score to BCD score, do BCD counting directly
			-- This loop iterates over 6 nibbles
			for i in 0 to 5 loop
				-- If nibble reaches 1001 (decimal 9), set bits to zero
				-- Loop will apply the carry onto the next nibble
				if score_bcd(i * 4 + 3 downto i * 4) = "1001" then
					score_bcd(i * 4 + 3 downto i * 4) <= (others => '0');
				else
					-- Nibble is bellow 9 so no overflow occurs, add 1
					score_bcd(i * 4 + 3 downto i * 4) <= std_ulogic_vector(unsigned(score_bcd(i * 4 + 3 downto i * 4)) + 1);
					-- This nibble is now active on the display
					score_blank(i) <= '0';
					exit;
				end if;
			end loop;
		end if;
	end process;
end architecture;
