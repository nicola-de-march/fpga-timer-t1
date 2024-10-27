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
        clk      : in std_logic;
        rst      : in std_logic;
        b1     : in std_logic;
        b2     : in std_logic;
        b3     : in std_logic;
        b4     : in std_logic;
        seg      : out std_logic_vector(6 downto 0);
        an       : out std_logic_vector(3 downto 0);
        output_bit : out std_logic
    );
end general_timer;

architecture Behavioral of general_timer is
signal alarm : std_logic;
signal digit1, digit2, digit3, digit4 : std_logic_vector(3 downto 0);

signal counter : integer := 0;  

signal clk_div : std_logic := '0'; 
constant DIV_FACTOR : integer := 10000000;

begin

    process(clk, rst)
    begin
        if rst = '1' then
            counter <= 0;
            clk_div <= '0';
        elsif rising_edge(clk) then
            if counter = DIV_FACTOR / 2 - 1 then  
                clk_div <= not clk_div; 
                counter <= 0;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    -- Istanziazione del componente timer
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
            alarm   => alarm
        );
end Behavioral;
