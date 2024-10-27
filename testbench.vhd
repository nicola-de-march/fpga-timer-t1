----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.10.2024 10:56:38
-- Design Name: 
-- Module Name: timer_tb - Behavioral
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

entity timer_tb is
end timer_tb;

architecture Behavioral of timer_tb is

    -- Dichiarazione segnali di testbench
    signal clk_tb, rst_tb: std_logic := '0';
    signal b1_tb, b2_tb, b3_tb, b4_tb: std_logic;
    signal digit1_tb, digit2_tb, digit3_tb, digit4_tb: std_logic_vector(3 downto 0);
    signal alarm_tb: std_logic;
    
    -- Dichiarazione periodo del clock
    constant clk_period: time := 100 ms;
    constant press_time: time := 100 ms;
    constant long_press_time: time := 200 ms;
    constant pause: time := 500 ms;
    
    constant hour: integer := 23;
    constant minute: integer := 15;
    constant hour_alarm: integer := 23;
    constant minute_alarm: integer := 15;

-- Instance of component timer
component timer is
    port (
        clk, rst: in std_logic;
        b1, b2, b3, b4: in std_logic;
        digit1, digit2, digit3, digit4: out std_logic_vector(3 downto 0);
        alarm: out std_logic
    );
end component;

begin
-- Clock generation
clk_tb <= not clk_tb after 50 ms;

simulation : process begin
    -- SET ALARM
    b3_tb <= '1';
    wait for press_time;  
    b3_tb <= '0';
    
--    b1_tb <= '1';
--    wait for press_time;  
--    b1_tb <= '0';
    
--    b2_tb <= '1';
--    wait for press_time;  
--    b2_tb <= '0';
    
    wait for 10 ms;
    
    rst_tb <= '1';
    wait for press_time;
    rst_tb <= '0';
    wait for pause;

    
    -- SET TIME 15:35:32
    b1_tb <= '1';
    wait for press_time;  
    b1_tb <= '0';
    wait for pause;
    
    b1_tb <= '1';
    wait for press_time;  
    b1_tb <= '0';
    wait for pause;
    
    for i in 1 to hour loop
        b2_tb <= '1';
        wait for press_time;  
        b2_tb <= '0';
        wait for press_time;
    end loop;
    
    b1_tb <= '1';
    wait for press_time;  
    b1_tb <= '0';
    wait for pause;
    
    for i in 1 to minute loop
        b2_tb <= '1';
        wait for press_time;  
        b2_tb <= '0';
        wait for press_time;
    end loop;
    
    b1_tb <= '1';
    wait for press_time;  
    b1_tb <= '0';
    wait for pause;
    
    b1_tb <= '1';
    wait for press_time;  
    b1_tb <= '0';
    
--    for i in 1 to 11 loop
--        wait for 60 min;  
--    end loop;
    wait for 5 sec;
    
    b2_tb <= '1';
    wait for press_time;  
    b2_tb <= '0';
    
    wait for 20 sec;
    
    b2_tb <= '1';
    wait for press_time;  
    b2_tb <= '0';
    
    wait for 40 sec;
    
    -- SET ALARM
    b3_tb <= '1';
    wait for press_time;  
    b3_tb <= '0';
    
    for i in 1 to 22 loop
        b2_tb <= '1';
        wait for press_time;  
        b2_tb <= '0';
        wait for press_time;
    end loop;
    
    b1_tb <= '1';
    wait for press_time;  
    b1_tb <= '0';
    wait for pause;
    
    for i in 1 to 17 loop
        b2_tb <= '1';
        wait for press_time;  
        b2_tb <= '0';
        wait for press_time;
    end loop;
    
    b1_tb <= '1';
    wait for press_time;  
    b1_tb <= '0';
    
    wait for 2 min;  
    
    b1_tb <= '1';
    wait for press_time;  
    b1_tb <= '0';
    
    wait for 10 sec;
    
end process;

-- Port mapping 
t: timer port map (
    clk => clk_tb,
    rst => rst_tb,
    b1 => b1_tb,
    b2 => b2_tb,
    b3 => b3_tb,
    b4 => b4_tb,
    digit1 => digit1_tb,
    digit2 => digit2_tb,
    digit3 => digit3_tb,
    digit4 => digit4_tb,
    alarm => alarm_tb
);
end Behavioral;

