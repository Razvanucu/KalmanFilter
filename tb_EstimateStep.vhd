library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_EstimateStep is
--  Port ( );
end tb_EstimateStep;

architecture Behavioral of tb_EstimateStep is

component Estimate is
 Port ( 
    aclk: in std_logic;
    aresetn: in std_logic;
    s_axis_measurement_tdata: in std_logic_vector(63 downto 0);
    s_axis_predicted_estimate_tdata: in std_logic_vector(127 downto 0);
    s_axis_predicted_covariance_matrix_tdata: in std_logic_vector(255 downto 0);
    s_axis_measurement_tready: out std_logic;
    s_axis_predicted_estimate_tready: out std_logic;
    s_axis_predicted_covariance_matrix_tready: out std_logic;
    s_axis_measurement_tvalid: in std_logic;
    s_axis_predicted_estimate_tvalid: in std_logic;
    s_axis_predicted_covariance_matrix_tvalid: in std_logic;
    m_axis_kalman_gain_tdata: out std_logic_vector(127 downto 0);
    m_axis_estimate_tdata: out std_logic_vector(127 downto 0);
    m_axis_predicted_covariance_matrix_tdata: out std_logic_vector(255 downto 0);
    m_axis_kalman_gain_tready: in std_logic; 
    m_axis_estimate_tready: in std_logic; 
    m_axis_predicted_covariance_matrix_tready: in std_logic;
    m_axis_kalman_gain_tvalid: out std_logic;
    m_axis_estimate_tvalid: out std_logic;
    m_axis_predicted_covariance_matrix_tvalid: out std_logic
 );
end component Estimate;

signal aclk:std_logic:='0';
signal aresetn: std_logic:='0';
signal s_axis_measurement_tdata: std_logic_vector(63 downto 0):=(others =>'0');
signal s_axis_predicted_estimate_tdata: std_logic_vector(127 downto 0):=(others =>'0');
signal s_axis_predicted_covariance_matrix_tdata: std_logic_vector(255 downto 0):=(others =>'0');
signal s_axis_measurement_tready: std_logic:='0';
signal s_axis_predicted_estimate_tready: std_logic:='0';
signal s_axis_predicted_covariance_matrix_tready: std_logic:='0';
signal s_axis_measurement_tvalid: std_logic:='0';
signal s_axis_predicted_estimate_tvalid: std_logic:='0';
signal s_axis_predicted_covariance_matrix_tvalid: std_logic:='0';
signal m_axis_kalman_gain_tdata: std_logic_vector(127 downto 0):=(others =>'0');
signal m_axis_estimate_tdata: std_logic_vector(127 downto 0):=(others =>'0');
signal m_axis_predicted_covariance_matrix_tdata: std_logic_vector(255 downto 0):=(others =>'0');
signal m_axis_kalman_gain_tready: std_logic:='0';
signal m_axis_estimate_tready: std_logic:='0';
signal m_axis_predicted_covariance_matrix_tready: std_logic:='0';
signal m_axis_kalman_gain_tvalid: std_logic:='0';
signal m_axis_estimate_tvalid: std_logic:='0';
signal m_axis_predicted_covariance_matrix_tvalid: std_logic:='0';
    
    
signal x0,x1: std_logic_vector(63 downto 0):=(others =>'0');
signal k0,k1: std_logic_vector(63 downto 0):=(others =>'0');
signal p0,p1,p2,p3: std_logic_vector(63 downto 0):=(others =>'0'); 

begin

aclk <= not aclk after 5ns;
aresetn <= '0','1' after 25ns;

s_axis_measurement_tvalid <= '0','1' when  aresetn='1';
s_axis_predicted_estimate_tvalid <= '0','1' when  aresetn='1';
s_axis_predicted_covariance_matrix_tvalid <= '0','1' when  aresetn='1';
m_axis_kalman_gain_tready <= '0','1' when  aresetn='1';
m_axis_estimate_tready <= '0','1' when  aresetn='1';
m_axis_predicted_covariance_matrix_tready <= '0','1' when  aresetn='1';

EstimateStep: Estimate port map(
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_measurement_tdata =>s_axis_measurement_tdata,
    s_axis_predicted_estimate_tdata =>s_axis_predicted_estimate_tdata,
    s_axis_predicted_covariance_matrix_tdata =>s_axis_predicted_covariance_matrix_tdata,
    s_axis_measurement_tready =>s_axis_measurement_tready,
    s_axis_predicted_estimate_tready =>s_axis_predicted_estimate_tready,
    s_axis_predicted_covariance_matrix_tready =>s_axis_predicted_covariance_matrix_tready,
    s_axis_measurement_tvalid =>s_axis_measurement_tvalid,
    s_axis_predicted_estimate_tvalid =>s_axis_predicted_estimate_tvalid,
    s_axis_predicted_covariance_matrix_tvalid =>s_axis_predicted_covariance_matrix_tvalid,
    m_axis_kalman_gain_tdata =>m_axis_kalman_gain_tdata,
    m_axis_estimate_tdata =>m_axis_estimate_tdata,
    m_axis_predicted_covariance_matrix_tdata =>m_axis_predicted_covariance_matrix_tdata,
    m_axis_kalman_gain_tready =>m_axis_kalman_gain_tready, 
    m_axis_estimate_tready =>m_axis_estimate_tready, 
    m_axis_predicted_covariance_matrix_tready =>m_axis_predicted_covariance_matrix_tready,
    m_axis_kalman_gain_tvalid =>m_axis_kalman_gain_tvalid,
    m_axis_estimate_tvalid =>m_axis_estimate_tvalid,
    m_axis_predicted_covariance_matrix_tvalid =>m_axis_predicted_covariance_matrix_tvalid
);

k0 <= m_axis_kalman_gain_tdata(63 downto 0);
k1 <= m_axis_kalman_gain_tdata(127 downto 64);

x0 <= m_axis_estimate_tdata(63 downto 0);
x1 <= m_axis_estimate_tdata(127 downto 64);

p0 <= m_axis_predicted_covariance_matrix_tdata(63 downto 0);
p1 <= m_axis_predicted_covariance_matrix_tdata(127 downto 64);
p2 <= m_axis_predicted_covariance_matrix_tdata(191 downto 128);
p3 <= m_axis_predicted_covariance_matrix_tdata(255 downto 192);

process
begin

wait for 25ns;

s_axis_measurement_tdata <= x"0000000000000024";
s_axis_predicted_estimate_tdata <= x"FFFFFFFFFFFFFFF9_FFFFFFFFFFFFFFF7";
s_axis_predicted_covariance_matrix_tdata <= x"0000000000000002_0000000000000000_0000000000000000_0000000000000026";

end process;


end Behavioral;
