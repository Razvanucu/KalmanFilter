library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_UART_RX is
--  Port ( );
end tb_UART_RX;

architecture Behavioral of tb_UART_RX is

component UART_RX is
  Port ( 
    clk:in std_logic;
    reset:in std_logic;
    rx_data_in:in std_logic;
    rx_data_valid : out std_logic;
    rx_data_out:out std_logic_vector(7 downto 0)
  );
end component UART_RX;

signal clk:std_logic:='0';
signal reset,rx_data_in,rx_data_valid:std_logic;
signal rx_data_out:std_logic_vector(7 downto 0):=(others =>'0');

constant BIT_PERIOD   : time := 54*4*16 ns;

begin

clk <= not clk after 2ns;

rx:UART_RX port map(
 clk => clk,
 reset => reset,
 rx_data_in => rx_data_in,
 rx_data_valid => rx_data_valid,
 rx_data_out => rx_data_out
);

process
  begin
    --Reset
    reset <= '1';
    wait for 20 ns;
    reset <= '0';
    
    --Start
    rx_data_in <= '0';
    wait for BIT_PERIOD;
    
    --Data
    rx_data_in <= '0';
    wait for BIT_PERIOD;
    rx_data_in <= '0';
    wait for BIT_PERIOD;
    rx_data_in <= '1';
    wait for BIT_PERIOD;
    rx_data_in <= '1';
    wait for BIT_PERIOD;
    rx_data_in <= '0';
    wait for BIT_PERIOD;
    rx_data_in <= '1';
    wait for BIT_PERIOD;
    rx_data_in <= '1';
    wait for BIT_PERIOD;
    rx_data_in <= '0'; -- MSB
    wait for BIT_PERIOD;

    --Stop
    rx_data_in <= '1';
    wait for BIT_PERIOD;

    wait for 500 ns;
    
    wait;
  end process;
  
end Behavioral;
