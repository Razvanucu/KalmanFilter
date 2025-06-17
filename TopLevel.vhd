library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TopLevel is
   Port (
        clk: in std_logic;
        sw : in std_logic_vector(15 downto 0);
        btn : in std_logic_vector(4 downto 0);
        an: out std_logic_vector(3 downto 0);
        cat: out std_logic_vector(6 downto 0);
        JA1: in std_logic;
        JA2: out std_logic
    );
end TopLevel;

architecture Behavioral of TopLevel is

component KalmanFilter is
 Port (
  aclk: in std_logic;
  aresetn: in std_logic;
  s_axis_measurement_tdata:in std_logic_vector(63 downto 0);
  s_axis_measurement_tready:out std_logic;
  s_axis_measurement_tvalid:in std_logic;
  m_axis_estimate_tdata:out std_logic_vector(127 downto 0);
  m_axis_estimate_tready:in std_logic;
  m_axis_estimate_tvalid:out std_logic
  );
end component KalmanFilter;

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

component debouncer is
  Port ( clk : in std_logic;
        btn : in std_logic;
        en : out std_logic );
end component debouncer;

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

signal estimate_tready : std_logic :='1';
signal reset_sig, estimate_tvalid : std_logic:='0';
signal rx_data_valid,measurement_valid,measurement_ready : std_logic:='0';
signal areset_sig : std_logic:='1';

signal data_out :std_logic_vector(7 downto 0) := (others => '0');

signal measurement : std_logic_vector(63 downto 0) := (others => '0');
signal estimate : std_logic_vector(127 downto 0) := (others => '0');
signal estimateSSD : std_logic_vector(127 downto 0) := (others => '0');

signal digit: std_logic_vector(15 downto 0):= (others => '0');

begin

debouncer_reset:debouncer port map
(
    clk => clk,
    btn => btn(0),
    en =>reset_sig
);

areset_sig <= not reset_sig;
 
UART_module:UART port map(
    clk => clk,
    reset => reset_sig,
    tx_start => '0',
    data_in => x"00",
    data_out =>data_out,
    rx_data_valid => rx_data_valid,
    rx => JA1,
    tx => JA2
);

ShiftReg: ShiftRegister64Bit port map(
    clk => clk,
    rx_data_valid => rx_data_valid,
    reset => reset_sig,
    rx_data_out => data_out,
    measurement => measurement,
    measurement_valid => measurement_valid,
    measurement_ready => measurement_ready
);

KalmanFilterUnit:KalmanFilter port map(
  aclk => clk,
  aresetn =>areset_sig,
  s_axis_measurement_tdata => measurement,
  s_axis_measurement_tready => measurement_ready,
  s_axis_measurement_tvalid => measurement_valid,
  m_axis_estimate_tdata =>  estimate,
  m_axis_estimate_tready => estimate_tready,
  m_axis_estimate_tvalid => estimate_tvalid
);

with sw(0) select digit <= estimateSSD(15 downto 0) when '0',
                           estimateSSD(79 downto 64) when '1',
                           (others =>'0') when others;


SSD:SevenSegDisplay port map(
        clk => clk,
        digit0 =>digit(3 downto 0),
        digit1 =>digit(7 downto 4),
        digit2 =>digit(11 downto 8),
        digit3 =>digit(15 downto 12),
        anodes => an,
        cathodes => cat
);

end Behavioral;
