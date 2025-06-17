library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_KalmanFilter is
--  Port ( );
end tb_KalmanFilter;

architecture Behavioral of tb_KalmanFilter is

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

signal aclk:  std_logic := '0';
signal aresetn:  std_logic := '0';
signal s_axis_measurement_tdata,x0,x1: std_logic_vector(63 downto 0) := (others => '0');
signal s_axis_measurement_tready: std_logic := '0';
signal  s_axis_measurement_tvalid: std_logic := '0';
signal m_axis_estimate_tdata: std_logic_vector(127 downto 0) := (others => '0');
signal m_axis_estimate_tready: std_logic := '0';
signal  m_axis_estimate_tvalid: std_logic := '0';

begin

aclk <= not aclk after 2ns;
aresetn <= '0','1' after 25ns;


KalmanFiltertb:KalmanFilter port map(
aclk => aclk,
aresetn => aresetn,
s_axis_measurement_tdata => s_axis_measurement_tdata,
s_axis_measurement_tready => s_axis_measurement_tready,
s_axis_measurement_tvalid => s_axis_measurement_tvalid,
m_axis_estimate_tdata => m_axis_estimate_tdata,
m_axis_estimate_tready => m_axis_estimate_tready,
m_axis_estimate_tvalid => m_axis_estimate_tvalid
);

x0 <= m_axis_estimate_tdata(63 downto 0);
x1 <= m_axis_estimate_tdata(127 downto 64);

s_axis_measurement_tvalid<='0' when s_axis_measurement_tready='0' else '1';
m_axis_estimate_tready <= '1';
process
begin

wait until rising_edge(aresetn);

s_axis_measurement_tdata <= x"0000000000000003";
wait;

end process;

end Behavioral;
