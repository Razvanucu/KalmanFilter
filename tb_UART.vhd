library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_UART is
--  Port ( );
end tb_UART;

architecture Behavioral of tb_UART is

component UART is
  Port ( 
    clk:in std_logic;
    reset:in std_logic;
    tx_start:in std_logic;
    data_in: in  std_logic_vector (7 downto 0);
    data_out: out std_logic_vector (7 downto 0);
    rx: in  std_logic;
    tx: out std_logic
  );
end component UART;

    signal clk: std_logic := '0';
    signal reset: std_logic := '0';
    signal tx_start: std_logic := '0';
    signal data_in: std_logic_vector(7 downto 0) := (others => '0');
    signal data_out: std_logic_vector(7 downto 0);
    signal rx: std_logic := '1'; 
    signal tx: std_logic := '1';
    
    
    constant BIT_PERIOD   : time := 54*4*16 ns;    
     
begin
    
    clk <= not clk after 2ns;
    uarttb: UART
        Port map (
            clk => clk,
            reset => reset,
            tx_start => tx_start,
            data_in => data_in,
            data_out => data_out,
            rx => rx,
            tx => tx
        );


    process
    begin
        
        reset <= '1';
        wait for 50 ns;
        reset <= '0';

        
        tx_start <= '1'; 
        data_in <= "10101010"; 

        wait for 1 us;

        rx <= '0'; -- Start bit
        wait for BIT_PERIOD; 
        rx <= '1'; -- Data bit 0
        wait for BIT_PERIOD;
        rx <= '0'; -- Data bit 1
        wait for BIT_PERIOD;
        rx <= '1'; -- Data bit 2
        wait for BIT_PERIOD;
        rx <= '0'; -- Data bit 3
        wait for BIT_PERIOD;
        rx <= '1'; -- Data bit 4
        wait for BIT_PERIOD;
        rx <= '0'; -- Data bit 5
        wait for BIT_PERIOD;
        rx <= '1'; -- Data bit 6
        wait for BIT_PERIOD;
        rx <= '0'; -- Data bit 7
        wait for BIT_PERIOD;
        rx <= '1'; -- Stop bit
        wait for BIT_PERIOD;

        wait for 1 us;
        tx_start <= '0'; 
        
        wait;
    end process;
end Behavioral;
