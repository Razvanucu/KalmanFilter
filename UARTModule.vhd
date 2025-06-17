
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity UARTModule is
   Port (
        clk: in std_logic;
        sw : in std_logic_vector(15 downto 0);
        btn : in std_logic_vector(4 downto 0);
        an: out std_logic_vector(3 downto 0);
        cat: out std_logic_vector(6 downto 0);
        led: out std_logic_vector(15 downto 0);
        JA1: in std_logic;
        JA2: out std_logic
    );

end UARTModule;

architecture Behavioral of UARTModule is

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

component SevenSegDisplay is
    Port ( 
        clk:in std_logic;
        digit0: in std_logic_vector(3 downto 0);
        digit1: in std_logic_vector(3 downto 0);
        digit2: in std_logic_vector(3 downto 0);
        digit3: in std_logic_vector(3 downto 0);
        anodes: out std_logic_vector(3 downto 0);
        cathodes: out std_logic_vector(6 downto 0)
    );
end  component SevenSegDisplay;

signal digits:std_logic_vector(7 downto 0):=(others => '0');

begin

UART_module:UART port map(
    clk => clk,
    reset => btn(0),
    tx_start => '0',
    data_in => x"00",
    data_out =>digits,
    rx_data_valid => led(0),
    rx => JA1,
    tx => JA2
);

SSD:SevenSegDisplay port map(
        clk => clk,
        digit0 =>digits(3 downto 0),
        digit1 =>digits(7 downto 4),
        digit2 =>x"0",
        digit3 =>x"0",
        anodes => an,
        cathodes => cat
);

end Behavioral;
