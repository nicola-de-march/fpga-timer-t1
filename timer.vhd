library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity timer is
port (
    clk, rst: in std_logic;
    b1, b2, b3, b4: in std_logic;
    digit1, digit2, digit3, digit4: out std_logic_vector(3 downto 0);
    alarm: out std_logic
    );
end timer;

architecture Behavioral of timer is

signal state: std_logic_vector(3 downto 0); -- in total there are 14 states

signal b1_prev : std_logic := '0'; 
signal b1_edge : std_logic := '0'; 
signal b2_prev : std_logic := '0';  
signal b2_edge : std_logic := '0';  
signal b3_prev : std_logic := '0';  
signal b3_edge : std_logic := '0';  

signal count_general : std_logic_vector(3 downto 0);
signal count_1, count_2, count_3, count_4, count_5, count_6 : std_logic_vector(3 downto 0);

signal carry1, carry2, carry3, carry4, carry5, carry6 : std_logic;
signal init_counter_hour, init_counter_minutes : std_logic := '0';        
       
signal clock_counting : std_logic;
signal print_time, print_seconds : std_logic;
signal set_alarm, check_alarm : std_logic;
signal alarm_ringing : std_logic;
-- For setting hours 
signal hour : integer range 0 to 23 := 0; 
signal minute : integer range 0 to 59 := 0;
signal seconds : integer range 0 to 600 := 0;

signal hour_alarm : integer range 0 to 23 := 0; 
signal minute_alarm : integer range 0 to 59 := 0;

begin

-- SEQUENTIAL
finite_state_machine: process(clk, rst) begin
    if rst = '1' then
        print_time <= '0';
        state <= x"0";
        hour <= 0;
        minute <= 0;
        hour_alarm <= 0;
        minute_alarm <= 0;
        init_counter_hour <= '0';
        init_counter_minutes <= '0';
        print_seconds <= '0';
        set_alarm <= '0';
        check_alarm <= '0';
        clock_counting <= '0';
        -- Reset all variables
    elsif rising_edge(clk) then
        case state is
            when x"0" =>
                print_time <= '0';
                clock_counting <= '0';
                set_alarm <= '0';
                init_counter_hour <= '0';
                init_counter_minutes <= '0';
                print_seconds <= '0';
                check_alarm <= '0';
                if b1_edge = '1' then --setting time
                    state <= x"1";
                end if;
            when x"1" =>
                print_time <= '0';
                clock_counting <= '0';
                set_alarm <= '0';
                init_counter_hour <= '0';
                init_counter_minutes <= '0';
                print_seconds <= '0';
                check_alarm <= '0';
                if b1_edge = '1' then
                    state <= x"2";  
                    init_counter_hour <= '1';
                elsif b2_edge = '1' then
                    if hour = 23 then
                        hour <= 0;
                    else
                        hour <= hour + 1;
                    end if;
                end if;         
            when x"2" =>
                print_time <= '0';
                clock_counting <= '0';
                set_alarm <= '0';
                init_counter_hour <= '0';
                init_counter_minutes <= '0';
                print_seconds <= '0';
                check_alarm <= '0';
                if b1_edge = '1' then
                    state <= x"3";
                    init_counter_minutes <= '1';
                elsif b2_edge = '1' then
                    if minute = 59 then
                        minute <= 0;
                    else
                        minute <= minute + 1;
                    end if;
                end if;  
            when x"3" =>                
                print_time <= '0';
                clock_counting <= '0';
                set_alarm <= '0';
                init_counter_hour <= '0';
                init_counter_minutes <= '0';
                print_seconds <= '0';
                check_alarm <= '0';
                if b1_edge = '1' then
                    state <= x"4";
                    clock_counting <= '1';
                end if;
               
            when x"4" =>
                print_time <= '1';
                set_alarm <= '0';
                clock_counting <= '1';
                init_counter_hour <= '0';
                init_counter_minutes <= '0';
                print_seconds <= '0';
                check_alarm <= '0';
                if b1_edge = '1' then
                    state <= x"1";
                    clock_counting <= '0';
                elsif b2_edge = '1' then
                    state <= x"5";
                    print_seconds <= '1';
                elsif b3_edge = '1' then
                    state <= x"6";
                    set_alarm <= '1';
                    print_time <= '0';
                    hour_alarm <= 0;
                    minute_alarm <= 0;
                end if;
            when x"5" =>
                print_time <= '1';
                set_alarm <= '0';
                init_counter_hour <= '0';
                init_counter_minutes <= '0';
                print_seconds <= '1';
                check_alarm <= '0';
                if b1_edge = '1' then
                    state <= x"1";
                    clock_counting <= '0';
                    print_seconds <= '0';
                elsif b2_edge = '1' then 
                    state <= x"4";
                    print_seconds <= '0';
                elsif b3_edge = '1' then
                    state <= x"6";
                    set_alarm <= '1';
                    print_time <= '0';
                    hour_alarm <= 0;
                    minute_alarm <= 0;
                end if;
            when x"6" =>
                print_time <= '0';
                set_alarm <= '1';
                init_counter_hour <= '0';
                init_counter_minutes <= '0';
                print_seconds <= '0';
                check_alarm <= '0';
                if b1_edge = '1' then
                    state <= x"7";
                elsif b2_edge = '1' then
                    if hour_alarm = 23 then
                        hour_alarm <= 0;
                    else
                        hour_alarm <= hour_alarm + 1;
                    end if;
                end if;
             when x"7" =>
                print_time <= '0';
                set_alarm <= '1';
                init_counter_hour <= '0';
                init_counter_minutes <= '0';
                print_seconds <= '0';
                check_alarm <= '0';
                if b1_edge = '1' then
                    state <= x"8";
                    set_alarm <= '0';
                    check_alarm <= '1';
                elsif b2_edge = '1' then
                    if minute_alarm = 59 then
                        minute_alarm <= 0;
                    else
                        minute_alarm <= minute_alarm + 1;
                    end if;
                end if;       
             when x"8" =>
                print_time <= '1';
                set_alarm <= '0';
                init_counter_hour <= '0';
                init_counter_minutes <= '0';
                print_seconds <= '0';
                check_alarm <= '1';    
                if alarm_ringing = '1' then
                    state <= x"9";
                end if;
            when x"9" =>     
                print_time <= '1';
                set_alarm <= '0';
                init_counter_hour <= '0';
                init_counter_minutes <= '0';
                print_seconds <= '0';
                check_alarm <= '1';    
                if b1_edge = '1' then
                    state <= x"4";
                    check_alarm <= '0';
                end if;
            when others => null;        
            end case;
    end if;
end process;

-- SEQUENTIAL
principal_counter: process(clk, rst) begin
    if rst = '1' then
        carry6 <= '0';
        count_general <= x"0";
    end if;
    if rising_edge(clk) and clock_counting = '1' then
        if unsigned(count_general) = 9 then
            count_general <= x"0";
            carry6 <= '1';
        else    
            count_general <= std_logic_vector(unsigned(count_general) + 1);
            carry6 <= '0';
        end if;
    end if;
end process;

-- SEQUENTIAL
counter_digit_6: process(clk, rst) begin
    if rst = '1' then
        count_6 <= x"0";
        carry5 <= '0';
    end if;
    if init_counter_minutes = '1' then 
        count_6 <= x"0";
    end if;
    if rising_edge(clk) then
        if carry6 = '1' and clock_counting = '1' then
            if unsigned(count_6) = 9 then
                count_6 <= x"0";
                carry5 <= '1';
            else    
                count_6 <= std_logic_vector(unsigned(count_6) + 1);
                carry5 <= '0';
            end if;
        else
            carry5 <= '0';
        end if;
    end if;
end process;

-- SEQUENTIAL
counter_digit_5: process(clk, rst) begin
    if rst = '1' then
        count_5 <= x"0";
        carry4 <= '0';
    end if;
    if init_counter_minutes = '1' then 
        count_5 <= x"0";
    end if;
    if rising_edge(clk) then
        if carry5 = '1' and clock_counting = '1' then
            if unsigned(count_5) = 5 then
                count_5 <= x"0";
                carry4 <= '1';
            else    
                count_5 <= std_logic_vector(unsigned(count_5) + 1);
                carry4 <= '0';
            end if;
        else carry4 <= '0';
        end if;
    end if;
end process;

-- SEQUENTIAL
counter_digit_4: process(clk, rst) begin
    if rst = '1' then
        count_4 <= x"0";
        carry3 <= '0';
    end if;
    if init_counter_minutes = '1' then 
        count_4 <= std_logic_vector(to_unsigned(minute mod 10, 4)); 
    end if;
    if rising_edge(clk) then
        if carry4 = '1' and clock_counting = '1' then
            if unsigned(count_4) = 9 then
                count_4 <= x"0";
                carry3 <= '1';
            else    
                count_4 <= std_logic_vector(unsigned(count_4) + 1);
                carry3 <= '0';
            end if;
        else carry3 <= '0';
        end if;
    end if;
end process;

-- SEQUENTIAL
counter_digit_3: process(clk, rst) begin
    if rst = '1' then
        count_3 <= x"0";
        carry2 <= '0';
    end if;
    if init_counter_minutes = '1' then 
        count_3 <= std_logic_vector(to_unsigned(minute / 10, 4)); 
    end if;
    if rising_edge(clk) then
        if carry3 = '1' and clock_counting = '1' then
            if unsigned(count_3) = 5 then
                count_3 <= x"0";
                carry2 <= '1';
            else    
                count_3 <= std_logic_vector(unsigned(count_3) + 1);
                carry2 <= '0';
            end if;
        else carry2 <= '0';
        end if;
    end if;
end process;

-- SEQUENTIAL
counter_digit_2: process(clk, rst) begin
    if rst = '1' then
        count_2 <= x"0";
        carry1 <= '0';
    end if;
    if init_counter_hour = '1' then 
        count_2 <= std_logic_vector(to_unsigned(hour mod 10, 4)); 
    end if;
    if rising_edge(clk) then
        if carry2 = '1' and clock_counting = '1' then
            if unsigned(count_1) = 2 then
                if unsigned(count_2) = 3 then
                    count_2 <= x"0";
                    carry1 <= '1';
                else 
                    count_2 <= std_logic_vector(unsigned(count_2) + 1);
                    carry1 <= '0';
                end if;
            elsif unsigned(count_2) = 9 then
                count_2 <= x"0";
                carry1 <= '1';
            else    
                count_2 <= std_logic_vector(unsigned(count_2) + 1);
                carry1 <= '0';
            end if;
        else carry1 <= '0';
        end if;
    end if;
end process;

-- SEQUENTIAL
counter_digit_1: process(clk, rst) begin
    if rst = '1' then
        count_1 <= x"0";
    end if;
    if init_counter_hour = '1' then 
        count_1 <= std_logic_vector(to_unsigned(hour / 10, 4)); 
    end if;
    if rising_edge(clk) then
        if carry1 = '1' and clock_counting = '1' then
            if unsigned(count_1) = 2 then
                count_1 <= x"0";
            else    
                count_1 <= std_logic_vector(unsigned(count_1) + 1);
            end if;
        end if;
    end if;
end process;

check_alarm_process : process(  hour_alarm, minute_alarm, 
                                clock_counting, check_alarm, alarm_ringing,
                                count_1, count_2, count_3, count_4) 

    variable current_hour   : integer;
    variable current_minute : integer;
begin
    if check_alarm = '1' and clock_counting = '1' then
        current_hour := to_integer(unsigned(count_1)) * 10 + to_integer(unsigned(count_2));
        current_minute := to_integer(unsigned(count_3)) * 10 + to_integer(unsigned(count_4));

        if (current_hour = hour_alarm) and (current_minute = minute_alarm) then
            alarm_ringing <= '1';
        else
            alarm_ringing <= '0';
        end if;
    else
        alarm_ringing <= '0';
    end if;
end process;

-- COMBINATORIAL
start_alarm : process(state) begin
    if state = x"9" then alarm <= '1';
    else alarm <= '0';
    end if;
end process;

-- COMBINATORIAL
print_digits: process(  print_time, print_seconds, set_alarm,
                        hour, minute, hour_alarm, minute_alarm, 
                        count_1, count_2, count_3, 
                        count_4, count_5, count_6) begin
    if print_time = '0' then
        if set_alarm = '1' then
            digit1 <= std_logic_vector(to_unsigned(hour_alarm / 10, 4)); 
            digit2 <= std_logic_vector(to_unsigned(hour_alarm mod 10, 4)); 
            digit3 <= std_logic_vector(to_unsigned(minute_alarm / 10, 4)); 
            digit4 <= std_logic_vector(to_unsigned(minute_alarm mod 10, 4));
        else
       -- hours
        digit1 <= std_logic_vector(to_unsigned(hour / 10, 4)); 
        digit2 <= std_logic_vector(to_unsigned(hour mod 10, 4)); 
        digit3 <= std_logic_vector(to_unsigned(minute / 10, 4)); 
        digit4 <= std_logic_vector(to_unsigned(minute mod 10, 4));
        end if;
   elsif print_seconds = '0' then
        digit1 <= count_1; 
        digit2 <= count_2; 
        digit3 <= count_3; 
        digit4 <= count_4; 
   else 
        digit1 <= x"0"; 
        digit2 <= x"0"; 
        digit3 <= count_5; 
        digit4 <= count_6; 
   end if;
end process;

-- SEQUENTIAL
-- Button debouncing for b1
button_edge_detection_b1: process(clk, rst) begin
    if rst = '1' then
        b1_prev <= '0';
        b1_edge <= '0';
    elsif rising_edge(clk) then
        if (b1 = '1' and b1_prev = '0') then
            b1_edge <= '1';  
        else
            b1_edge <= '0';
        end if;
        b1_prev <= b1;  
    end if;
end process;
-- SEQUENTIAL
-- Button debouncing for b2
button_edge_detection_b2: process(clk, rst) begin
    if rst = '1' then
        b2_prev <= '0';
        b2_edge <= '0';
    elsif rising_edge(clk) then
        if (b2 = '1' and b2_prev = '0') then
            b2_edge <= '1';  
        else
            b2_edge <= '0';
        end if;
        b2_prev <= b2;  
    end if;
end process;
-- SEQUENTIAL
-- Button debouncing for b3
button_edge_detection_b3: process(clk, rst) begin
    if rst = '1' then
        b3_prev <= '0';
        b3_edge <= '0';
    elsif rising_edge(clk) then
        if (b3 = '1' and b3_prev = '0') then
            b3_edge <= '1';  
        else
            b3_edge <= '0';
        end if;
        b3_prev <= b3;  
    end if;
end process;
end Behavioral;
