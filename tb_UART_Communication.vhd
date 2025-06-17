library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_UART_Communication is
--  Port ( );
end tb_UART_Communication;

architecture Behavioral of tb_UART_Communication is

component UART is
  Port ( 
    clk:in std_logic;
    reset:in std_logic;
    tx_start:in std_logic;
    data_in: in  std_logic_vector (7 downto 0);
    data_out: out std_logic_vector (7 downto 0);
    rx_data_valid: out std_logic;
    rx: in  std_logic;
    tx: out std_logic
  );
end component UART;

    signal clk: std_logic := '0';
    signal reset: std_logic := '0';
    
    
    signal tx_start1: std_logic := '0';
    signal data_in1: std_logic_vector(7 downto 0) := (others => '0');
    signal data_out1: std_logic_vector(7 downto 0);

    
    signal tx_start0: std_logic := '0';
    signal data_in0: std_logic_vector(7 downto 0) := (others => '0');
    signal data_out0: std_logic_vector(7 downto 0);
    signal rxtx0: std_logic := '1'; 
    signal rxtx1: std_logic := '1';
    
    signal rx_data_valid0: std_logic := '0'; 
    signal rx_data_valid1: std_logic := '0';
    
    constant BIT_PERIOD   : time := 54*4*16 ns; 
    
begin


    clk <= not clk after 2ns;
    uarttb0: UART
        Port map (
            clk => clk,
            reset => reset,
            tx_start => tx_start0,
            data_in => data_in0,
            data_out => data_out0,
            rx_data_valid => rx_data_valid0,
            rx => rxtx0,
            tx => rxtx1
        );
        
    clk <= not clk after 2ns;
    uarttb1: UART
        Port map (
            clk => clk,
            reset => reset,
            tx_start => tx_start1,
            data_in => data_in1,
            data_out => data_out1,
            rx_data_valid => rx_data_valid1,
            rx => rxtx1,
            tx => rxtx0
        );
    
    process
    begin
        
        reset <= '1';
        wait for 50 ns;
        reset <= '0';

        wait for 1 us;
        data_in0<= x"3B";
        tx_start0 <= '1'; 
        
        wait for BIT_PERIOD*9;
        tx_start0 <='0';
        
        wait for 1us;
        data_in1<= x"F4";
        tx_start1 <= '1';
        
        wait for BIT_PERIOD*9;
        tx_start1 <='0';
  
        wait for BIT_PERIOD*19;
        reset <= '1';
        wait for 20ns;
        reset <= '0';
        wait;
    end process;
             

end Behavioral;
