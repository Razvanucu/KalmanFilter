library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity UART_RX_FSM is
  Port ( 
    baud_clk:in std_logic;
    reset : in std_logic;
    rx_data_in : in std_logic;
    rx_data_valid : out std_logic;
    rx_data_out : out std_logic_vector(7 downto 0)
  );
end UART_RX_FSM;

architecture Behavioral of UART_RX_FSM is

type state_type is (IDLE,START,DATA,STOP);
signal state:state_type:=IDLE;


signal rx_stored_data:std_logic_vector(7 downto 0):=(others =>'0');
signal bit_duration:integer range 0 to 15 :=0;
signal bit_count:integer range 0 to 7:=0;

begin

process(reset,baud_clk)

begin
   if reset='1' then
            state<=IDLE;
            rx_stored_data <= (others =>'0');
            rx_data_out <= (others =>'0');
            rx_data_valid <= '0';
            bit_duration<=0;
            bit_count<=0;       
    elsif rising_edge(baud_clk) then
            case state is
                when IDLE=>
                
                    rx_stored_data <= (others =>'0');
                    bit_duration<=0;
                    bit_count<=0;
                    rx_data_valid <= '0';
                    
                    if rx_data_in='0' then
                        state<=START;
                    end if;
                    
                when START=>
                
                    if bit_duration = 7 then
                        if rx_data_in='0' then
                            state<=DATA;
                            bit_duration<=0;
                        else
                             state<=IDLE;      
                        end if;
                    else
                        bit_duration<=bit_duration+1;
                    end if;
                           
                when DATA=>
                    
                    if bit_duration=15 then
                        rx_stored_data(bit_count)<=rx_data_in;
                        bit_duration<=0;
                        
                        if bit_count = 7 then
                           state<=STOP;
                        else
                           bit_count<=bit_count+1;    
                        end if;
                    else
                       bit_duration<=bit_duration+1;           
                    end if;
                    
                when STOP=>
                    
                    if bit_duration=15 then
                        if rx_data_in = '1' then
                            rx_data_out <= rx_stored_data;
                            rx_data_valid <= '1';
                        end if;
                        state<=IDLE; 
                    else
                        bit_duration<=bit_duration+1;   
                    end if;
            
                when others=>
                    state<= IDLE;
            end case;
        end if;
end process;

end Behavioral;
