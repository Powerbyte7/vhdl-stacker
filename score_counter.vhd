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

	signal score       : unsigned(15 downto 0)          := (others => '0');
	signal highscore   : unsigned(15 downto 0)          := (others => '0');
	signal score_bcd   : std_ulogic_vector(23 downto 0) := (others => '0');
	signal score_blank : std_ulogic_vector(5 downto 0)  := (others => '1');
begin
	--score_display <= score_bcd;
	decoder: ss_decoder
		port map (
			bcd      => score_bcd,
			blank    => score_blank,
			ss_codes => score_display
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
