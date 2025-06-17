library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_ShiftReg is
--  Port ( );
end tb_ShiftReg;

architecture Behavioral of tb_ShiftReg is

component ShiftRegister64Bit is
  Port (
    clk : in std_logic;
    rx_data_valid:in std_logic;
    reset : in std_logic;
    rx_data_out : in std_logic_vector(7 downto 0);
    measurement: out std_logic_vector(63 downto 0);
    measurement_valid: out std_logic;
    measurement_ready: in std_logic
  );
end component ShiftRegister64Bit;

signal clk,rx_data_valid,reset,measurement_valid,measurement_ready :std_logic:='0';
signal rx_data_out: std_logic_vector(7 downto 0):= (others =>'0');
signal measurement: std_logic_vector(63 downto 0):= (others =>'0');

begin

clk <= not clk after 2ns;
reset <='1','0' after 20ns;

sgtr:ShiftRegister64Bit port map
(
    clk => clk,
    rx_data_valid => rx_data_valid,
    reset => reset,
    rx_data_out => rx_data_out,
    measurement => measurement,
    measurement_valid => measurement_valid,
    measurement_ready => measurement_ready
);

measurement_ready<='1';

process
begin
    wait until falling_edge(reset);
    
    rx_data_out<=x"03";
    rx_data_valid <='1';
    wait for 20ns;
    rx_data_valid <='0';
    wait for 20ns;
    
    rx_data_out<=x"00";
    rx_data_valid <='1';
    wait for 20ns;
    rx_data_valid <='0';
    wait for 20ns;
    
    rx_data_out<=x"00";
    rx_data_valid <='1';
    wait for 20ns;
    rx_data_valid <='0';
    wait for 20ns;
    
    rx_data_out<=x"00";
    rx_data_valid <='1';
    wait for 20ns;
    rx_data_valid <='0';
    wait for 20ns;

    rx_data_out<=x"00";
    rx_data_valid <='1';
    wait for 20ns;
    rx_data_valid <='0';
    wait for 20ns;
    
    rx_data_out<=x"00";
    rx_data_valid <='1';
    wait for 20ns;
    rx_data_valid <='0';
    wait for 20ns;
    
    rx_data_out<=x"00";
    rx_data_valid <='1';
    wait for 20ns;
    rx_data_valid <='0';
    wait for 20ns;
    
    rx_data_out<=x"00";
    rx_data_valid <='1';
    wait for 20ns;
    rx_data_valid <='0';
    wait for 20ns;
    
    wait;
end process;

end Behavioral;
