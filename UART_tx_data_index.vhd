library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity UART_TX_data_index is
    Port (
        baud_clk : in std_logic;
        reset : in std_logic;
        data_index_reset : in std_logic;
        data_index : out std_logic_vector(2 downto 0)
     );
end UART_TX_data_index;

architecture Behavioral of UART_tx_data_index is

begin

process(baud_clk)
variable var_data_indx:unsigned(2 downto 0):="000";
begin
     if rising_edge(baud_clk) then 
        if reset='1' or data_index_reset='1' then
            var_data_indx:="000";
        else
            var_data_indx:= var_data_indx + 1;
        end if;
        data_index<=std_logic_vector(var_data_indx);
     end if;      
end process;

end Behavioral;
