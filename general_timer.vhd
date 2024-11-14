----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.10.2024 13:33:38
-- Design Name: 
-- Module Name: general_timer - Behavioral
-- Project Name: 
-- Target Devices: 
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
        clk    : in std_logic;
        rst    : in std_logic;
        b1     : in std_logic;
        b2     : in std_logic;
        b3     : in std_logic;
        b4     : in std_logic;
        seg   : out std_logic_vector(6 downto 0);
        --seg2   : out std_logic_vector(6 downto 0);
        --seg3   : out std_logic_vector(6 downto 0);
        --seg4   : out std_logic_vector(6 downto 0);
        an     : out std_logic_vector(3 downto 0);
        output_bit : out std_logic
    );
end general_timer;

architecture Behavioral of general_timer is
signal alarm : std_logic;
signal digit1, digit2, digit3, digit4, digit : std_logic_vector(3 downto 0);

signal counter_10, counter_10k : integer := 0;  

signal clk_div_10 : std_logic := '0'; 
constant DIV_FACTOR_10 : integer := 10000000;

signal clk_div_10k : std_logic_vector(3 downto 0); -- := '0'; 
constant DIV_FACTOR_10k : integer := 10000;

begin
an <= clk_div_10k;
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
        clk_div_10k <= "0111";
    elsif rising_edge(clk) then
        if counter_10k = DIV_FACTOR_10k / 2 - 1 then  
            --clk_div_10k <= not clk_div_10k; 
            case clk_div_10k is
            when "0111" => clk_div_10k <="1011"; 
            when "1011" => clk_div_10k <="1101";
            when "1101" => clk_div_10k <="1110";
            when "1110" => clk_div_10k <="0111";
            when others => null;
            end case;
            counter_10k <= 0;
        else
            counter_10k <= counter_10k + 1;
        end if;
    end if;
end process;

display_digit: process(clk_div_10k, digit1, digit2, digit3, digit4) begin
    case clk_div_10k is
        when "0111" => 
            case digit1 is
                when "0000" => seg <= "0000001";  -- 0
                when "0001" => seg <= "1001111";  -- 1
                when "0010" => seg <= "0010010";  -- 2
                when "0011" => seg <= "0000110";  -- 3
                when "0100" => seg <= "1001100";  -- 4
                when "0101" => seg <= "0100100";  -- 5
                when "0110" => seg <= "0100000";  -- 6
                when "0111" => seg <= "0001111";  -- 7
                when "1000" => seg <= "0000000";  -- 8
                when "1001" => seg <= "0000100";  -- 9
                when others => seg <= "1111111"; 
            end case;
        when "1011" => 
            case digit2 is
                when "0000" => seg <= "0000001";  -- 0
                when "0001" => seg <= "1001111";  -- 1
                when "0010" => seg <= "0010010";  -- 2
                when "0011" => seg <= "0000110";  -- 3
                when "0100" => seg <= "1001100";  -- 4
                when "0101" => seg <= "0100100";  -- 5
                when "0110" => seg <= "0100000";  -- 6
                when "0111" => seg <= "0001111";  -- 7
                when "1000" => seg <= "0000000";  -- 8
                when "1001" => seg <= "0000100";  -- 9
                when others => seg <= "1111111"; 
            end case;
        when "1101" =>
            case digit3 is
                when "0000" => seg <= "0000001";  -- 0
                when "0001" => seg <= "1001111";  -- 1
                when "0010" => seg <= "0010010";  -- 2
                when "0011" => seg <= "0000110";  -- 3
                when "0100" => seg <= "1001100";  -- 4
                when "0101" => seg <= "0100100";  -- 5
                when "0110" => seg <= "0100000";  -- 6
                when "0111" => seg <= "0001111";  -- 7
                when "1000" => seg <= "0000000";  -- 8
                when "1001" => seg <= "0000100";  -- 9
                when others => seg <= "1111111"; 
            end case; 
        when "1110" => 
            case digit4 is
                when "0000" => seg <= "0000001";  -- 0
                when "0001" => seg <= "1001111";  -- 1
                when "0010" => seg <= "0010010";  -- 2
                when "0011" => seg <= "0000110";  -- 3
                when "0100" => seg <= "1001100";  -- 4
                when "0101" => seg <= "0100100";  -- 5
                when "0110" => seg <= "0100000";  -- 6
                when "0111" => seg <= "0001111";  -- 7
                when "1000" => seg <= "0000000";  -- 8
                when "1001" => seg <= "0000100";  -- 9
                when others => seg <= "1111111"; 
            end case;
        when others => seg <= "1111111"; 
    end case;
end process;

timer_inst : entity work.timer
    port map (
        clk     => clk_div_10,
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
