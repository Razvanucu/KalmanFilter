
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity ShiftRegister64Bit is
  Port (
    clk : in std_logic;
    rx_data_valid:in std_logic;
    reset : in std_logic;
    rx_data_out : in std_logic_vector(7 downto 0);
    measurement: out std_logic_vector(63 downto 0);
    measurement_valid: out std_logic;
    measurement_ready: in std_logic
  );
end ShiftRegister64Bit;

architecture Behavioral of ShiftRegister64Bit is

type state_type is (READ,WRITE);
signal state :state_type := READ;

signal buff : std_logic_vector(63 downto 0) := (others =>'0');
signal cnt: integer range 0 to 7 :=0;

signal rx_data_valid_sync,rx_data_valid_prev: std_logic :='0';

begin

measurement_valid <= '1' when state = WRITE else '0';
measurement <= buff;

process(clk,reset)
begin
    if reset='1' then
        cnt <= 0;
        buff <= (others =>'0');
        state <= READ;
    elsif rising_edge(clk) then
        
        rx_data_valid_prev <= rx_data_valid_sync;
        rx_data_valid_sync <= rx_data_valid;
        
        if state = READ and rx_data_valid_sync='1' and rx_data_valid_prev='0' then
                case cnt is
                    when 0 =>
                        buff(7 downto 0) <= rx_data_out;
                        cnt <= 1;
                    when 1 =>
                        buff(15 downto 8) <= rx_data_out;
                        cnt <= 2;
                    when 2 =>
                        buff(23 downto 16) <= rx_data_out;
                        cnt <= 3;
                    when 3 =>
                        buff(31 downto 24) <= rx_data_out;
                        cnt <= 4;
                    when 4 =>
                        buff(39 downto 32) <= rx_data_out;
                        cnt <= 5;
                    when 5 =>
                        buff(47 downto 40) <= rx_data_out;
                        cnt <= 6;
                    when 6 =>
                        buff(55 downto 48) <= rx_data_out;
                        cnt <= 7;
                    when 7 =>
                        buff(63 downto 56) <= rx_data_out;
                        state <= WRITE;
                    when others =>
                        cnt <= 0;
                        buff <= (others =>'0');
                        state <= READ;    
                end case;
        elsif state = WRITE and measurement_ready='1' then
                state <= READ;
                cnt <= 0; 
        end if;
    end if;
end process;


end Behavioral;
