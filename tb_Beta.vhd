library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_Beta is
--  Port ( );
end tb_Beta;

architecture Behavioral of tb_Beta is

component Beta is
 Port (
    aclk: in std_logic;
    aresetn: in std_logic;
    s_axis_predicted_covariance_matrix_tdata: in std_logic_vector(255 downto 0);
    s_axis_H_matrix_tdata: in std_logic_vector(127 downto 0);
    s_axis_R_matrix_tdata: in std_logic_vector(63 downto 0);
    s_axis_predicted_covariance_matrix_tready: out std_logic;
    s_axis_H_matrix_tready: out std_logic;
    s_axis_R_matrix_tready: out std_logic;
    s_axis_predicted_covariance_matrix_tvalid: in std_logic;
    s_axis_H_matrix_tvalid: in std_logic;
    s_axis_R_matrix_tvalid: in std_logic;
    m_axis_Beta_tdata: out std_logic_vector(63 downto 0);
    m_axis_Beta_tready: in std_logic;
    m_axis_Beta_tvalid: out std_logic
  );
end component Beta;

  signal aclk : std_logic:='0';
  signal aresetn : std_logic:='0';
  signal s_axis_predicted_covariance_matrix_tdata : std_logic_vector(255 downto 0):=(others =>'0');
  signal s_axis_H_matrix_tdata : std_logic_vector(127 downto 0):=(others =>'0');
  signal s_axis_R_matrix_tdata: std_logic_vector(63 downto 0):=(others =>'0');
  signal s_axis_predicted_covariance_matrix_tready : std_logic:='0';
  signal s_axis_H_matrix_tready : std_logic:='0';
  signal s_axis_R_matrix_tready : std_logic:='0';
  signal s_axis_predicted_covariance_matrix_tvalid : std_logic:='0';
  signal s_axis_H_matrix_tvalid : std_logic:='0';
  signal s_axis_R_matrix_tvalid : std_logic:='0';
  signal m_axis_Beta_tdata : std_logic_vector(63 downto 0):=(others =>'0');
  signal m_axis_Beta_tready : std_logic:='0';
  signal m_axis_Beta_tvalid : std_logic:='0';

begin

aclk <= not aclk after 5ns;
aresetn <= '0','1' after 25ns;

s_axis_H_matrix_tvalid <= '0','1' when  aresetn='1';
s_axis_R_matrix_tvalid <= '0','1' when  aresetn='1';
s_axis_predicted_covariance_matrix_tvalid <= '0','1' when  aresetn='1';
m_axis_Beta_tready <= '0','1' when  aresetn='1';


Kalman_Filter: Beta
  port map (
    aclk => aclk,
    aresetn => aresetn,
    s_axis_predicted_covariance_matrix_tdata => s_axis_predicted_covariance_matrix_tdata,
    s_axis_H_matrix_tdata => s_axis_H_matrix_tdata,
    s_axis_R_matrix_tdata => s_axis_R_matrix_tdata,
    s_axis_predicted_covariance_matrix_tready => s_axis_predicted_covariance_matrix_tready,
    s_axis_H_matrix_tready => s_axis_H_matrix_tready,
    s_axis_R_matrix_tready => s_axis_R_matrix_tready,
    s_axis_predicted_covariance_matrix_tvalid => s_axis_predicted_covariance_matrix_tvalid,
    s_axis_H_matrix_tvalid => s_axis_H_matrix_tvalid,
    s_axis_R_matrix_tvalid => s_axis_R_matrix_tvalid,
    m_axis_Beta_tdata => m_axis_Beta_tdata,
    m_axis_Beta_tready => m_axis_Beta_tready,
    m_axis_Beta_tvalid => m_axis_Beta_tvalid
  );
  
process
begin

wait for 25ns;

s_axis_H_matrix_tdata <= x"0000000000000002_FFFFFFFFFFFFFFFE";
s_axis_R_matrix_tdata <= x"FFFFFFFFFFFFFF95";
s_axis_predicted_covariance_matrix_tdata <= x"0000000000000002_0000000000000000_0000000000000000_0000000000000026";

end process;


end Behavioral;
