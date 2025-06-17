library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity UART_TX_FSM is
  Port (
    baud_clk:in std_logic;
    reset:in std_logic;
    start_detected:in std_logic;
    data_index:in std_logic_vector(2 downto 0);
    stored_data:in std_logic_vector(7 downto 0);
    start_reset:out std_logic;
    data_index_reset:out std_logic;
    tx_data_out:out std_logic
   );
end UART_TX_FSM;

architecture Behavioral of UART_TX_FSM is
type state_type is (IDLE,START,DATA,STOP);
signal state:state_type :=IDLE;

begin

process(baud_clk,reset)
begin
    if reset='1' then
            state <= IDLE;
            data_index_reset<='1';
            start_reset<='1';
            tx_data_out<='1';
    elsif rising_edge(baud_clk) then   
            case state is
               when IDLE=>
                    data_index_reset<='1';
                    start_reset<='0';
                    tx_data_out<='1';
                    
                    if start_detected='1' then
                        state<= START;
                    end if;
                    
               when START=>
                    data_index_reset<='0';
                    tx_data_out<='0';
                    
                    state<= DATA;
               
               when DATA=>
                    tx_data_out<= stored_data(to_integer(unsigned(data_index)));
                    
                    if data_index = "111" then
                        data_index_reset<='1';
                        state<= STOP;
                    end if;
               when STOP=>
                    tx_data_out<='1';
                    start_reset<='1';
                    
                    state<= IDLE;
               when others=>
                    state<= IDLE;
            end case; 
    end if;
end process;

end Behavioral;
