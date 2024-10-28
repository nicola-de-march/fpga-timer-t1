----------------------------------------------------------------------------------
-- Company: University of Luxemburg
-- Engineers: 
--     Nicola De March
--     Giorgio Bettonte   
-- Create Date: 27.10.2024 13:33:38
-- Design Name: 
-- Module Name: general_timer - Behavioral
-- Project Name: 
-- Target Devices: Basys 3
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity general_timer is
    Port (
        clk      : in std_logic;
        rst      : in std_logic;
        b1     : in std_logic;
        b2     : in std_logic;
        b3     : in std_logic;
        b4     : in std_logic;
        seg1      : out std_logic_vector(6 downto 0);
        seg2      : out std_logic_vector(6 downto 0);
        seg3      : out std_logic_vector(6 downto 0);
        seg4      : out std_logic_vector(6 downto 0);
        an       : out std_logic_vector(3 downto 0);
        output_bit : out std_logic
    );
end general_timer;

architecture Behavioral of general_timer is
signal alarm : std_logic;
signal digit1, digit2, digit3, digit4 : std_logic_vector(3 downto 0);

signal counter_10, counter_10k : integer := 0;  

signal clk_div_10 : std_logic := '0'; 
constant DIV_FACTOR_10 : integer := 45000000;

signal clk_div_10k : std_logic := '0'; 
constant DIV_FACTOR_10k : integer := 450000;

begin

-- Clock divider for 10 Hz
divider_10 : process(clk, rst)
begin
    if rst = '1' then
        counter_10 <= 0;
        clk_div_10 <= '0';
    elsif rising_edge(clk) then
        if counter_10 = DIV_FACTOR_10 / 2 - 1 then  
            clk_div_10 <= not clk_div_10; 
            counter_10 <= 0;
        else
            counter_10 <= counter_10 + 1;
        end if;
    end if;
end process;
-- Clock divider for 10 kHz
divider_10k : process(clk, rst)
begin
    if rst = '1' then
        counter_10k <= 0;
        clk_div_10k <= '0';
    elsif rising_edge(clk) then
        if counter_10k = DIV_FACTOR_10k / 2 - 1 then  
            clk_div_10k <= not clk_div_10k; 
            counter_10k <= 0;
        else
            counter_10k <= counter_10k + 1;
        end if;
    end if;
end process;

display_digit_1: process(digit1) begin
    case digit1 is
            when "0000" => seg1 <= "1111110";  -- 0
            when "0001" => seg1 <= "0110000";  -- 1
            when "0010" => seg1 <= "1101101";  -- 2
            when "0011" => seg1 <= "1111001";  -- 3
            when "0100" => seg1 <= "0110011";  -- 4
            when "0101" => seg1 <= "1011011";  -- 5
            when "0110" => seg1 <= "1011111";  -- 6
            when "0111" => seg1 <= "1110000";  -- 7
            when "1000" => seg1 <= "1111111";  -- 8
            when "1001" => seg1 <= "1111011";  -- 9
            when others => seg1 <= "0000000"; 
    end case;
end process;

display_digit_2: process(digit2) begin
    case digit2 is
            when "0000" => seg2 <= "1111110";  -- 0
            when "0001" => seg2 <= "0110000";  -- 1
            when "0010" => seg2 <= "1101101";  -- 2
            when "0011" => seg2 <= "1111001";  -- 3
            when "0100" => seg2 <= "0110011";  -- 4
            when "0101" => seg2 <= "1011011";  -- 5
            when "0110" => seg2 <= "1011111";  -- 6
            when "0111" => seg2 <= "1110000";  -- 7
            when "1000" => seg2 <= "1111111";  -- 8
            when "1001" => seg2 <= "1111011";  -- 9
            when others => seg2 <= "0000000"; 
    end case;
end process;

display_digit_3: process(digit3) begin
    case digit3 is
            when "0000" => seg3 <= "1111110";  -- 0
            when "0001" => seg3 <= "0110000";  -- 1
            when "0010" => seg3 <= "1101101";  -- 2
            when "0011" => seg3 <= "1111001";  -- 3
            when "0100" => seg3 <= "0110011";  -- 4
            when "0101" => seg3 <= "1011011";  -- 5
            when "0110" => seg3 <= "1011111";  -- 6
            when "0111" => seg3 <= "1110000";  -- 7
            when "1000" => seg3 <= "1111111";  -- 8
            when "1001" => seg3 <= "1111011";  -- 9
            when others => seg3 <= "0000000"; 
    end case;
end process;

display_digit_4: process(digit4) begin
    case digit4 is
            when "0000" => seg4 <= "1111110";  -- 0
            when "0001" => seg4 <= "0110000";  -- 1
            when "0010" => seg4 <= "1101101";  -- 2
            when "0011" => seg4 <= "1111001";  -- 3
            when "0100" => seg4 <= "0110011";  -- 4
            when "0101" => seg4 <= "1011011";  -- 5
            when "0110" => seg4 <= "1011111";  -- 6
            when "0111" => seg4 <= "1110000";  -- 7
            when "1000" => seg4 <= "1111111";  -- 8
            when "1001" => seg4 <= "1111011";  -- 9
            when others => seg4 <= "0000000"; 
    end case;
end process;
timer_inst : entity work.timer
    port map (
        clk     => clk,
        rst     => rst,
        b1      => b1,
        b2      => b2,
        b3      => b3,
        b4      => b4,
        digit1  => digit1,
        digit2  => digit2,
        digit3  => digit3,
        digit4  => digit4,
        alarm   => output_bit
    );
end Behavioral;

