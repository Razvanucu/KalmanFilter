
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_UART_RX_FSM is
--  Port ( );
end tb_UART_RX_FSM;

architecture Behavioral of tb_UART_RX_FSM is

component UART_RX_FSM is
  Port ( 
    baud_clk:in std_logic;
    reset : in std_logic;
    rx_data_in : in std_logic;
    rx_data_valid : out std_logic;
    rx_data_out : out std_logic_vector(7 downto 0)
  );
end component UART_RX_FSM;

signal baud_clk: std_logic:='0';
signal reset :  std_logic:='0';
signal rx_data_in :  std_logic:='0';
signal rx_data_valid :  std_logic:='0';
signal rx_data_out :  std_logic_vector(7 downto 0):=(others => '0');


begin

baud_clk <= not baud_clk after 2ns;


UART_RX_FSMtb:UART_RX_FSM port map
(
    baud_clk => baud_clk,
    reset => reset,
    rx_data_in => rx_data_in,
    rx_data_valid => rx_data_valid,
    rx_data_out => rx_data_out
);

process
begin
    reset <='1';
    wait for 20ns;
    reset <='0';
    
    --Start
    rx_data_in <='0';
    wait for 64ns;
     
    --Data
    --1
    rx_data_in <='1';
    wait for 64ns;
    
    --2
    rx_data_in <='0';
    wait for 64ns;
    
    --3
    rx_data_in <='1';
    wait for 64ns;
    
    --4
    rx_data_in <='0';
    wait for 64ns;
    
    --5
    rx_data_in <='1';
    wait for 64ns;
    
    --6
    rx_data_in <='1';
    wait for 64ns;
    
    --7
    rx_data_in <='0';
    wait for 64ns;
    
    --8
    rx_data_in <='0';
    wait for 64ns;
    
    --Stop
    rx_data_in <='1';
    wait for 64ns;
    
    wait;
end process;

end Behavioral;
