library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Estimate is
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
end Estimate;

architecture Behavioral of Estimate is

component Estimate_value is
 Port ( 
    aclk: in std_logic;
    aresetn: in std_logic;
    s_axis_measurement_tdata: in std_logic_vector(63 downto 0);
    s_axis_H_matrix_tdata: in std_logic_vector(127 downto 0);
    s_axis_predicted_estimate_tdata: in std_logic_vector(127 downto 0);
    s_axis_Kalman_Gain_tdata: in std_logic_vector(127 downto 0);
    s_axis_measurement_tready: out std_logic;
    s_axis_H_matrix_tready: out std_logic;
    s_axis_predicted_estimate_tready: out std_logic;
    s_axis_Kalman_Gain_tready: out std_logic;
    s_axis_measurement_tvalid: in std_logic;
    s_axis_H_matrix_tvalid: in std_logic;
    s_axis_predicted_estimate_tvalid: in std_logic;
    s_axis_Kalman_Gain_tvalid: in std_logic;
    m_axis_estimate_tdata: out std_logic_vector(127 downto 0);
    m_axis_estimate_tready: in std_logic;
    m_axis_estimate_tvalid: out std_logic
 );
end component Estimate_value;

component KalmanGain is
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
    m_axis_Kalman_Gain_tdata: out std_logic_vector(127 downto 0);
    m_axis_Kalman_Gain_tready: in std_logic;
    m_axis_Kalman_Gain_tvalid: out std_logic
  );
end component KalmanGain;

COMPONENT AXI4_Vect_FIFO
  PORT (
    s_axis_aresetn : IN STD_LOGIC;
    s_axis_aclk : IN STD_LOGIC;
    s_axis_tvalid : IN STD_LOGIC;
    s_axis_tready : OUT STD_LOGIC;
    s_axis_tdata : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
    m_axis_tvalid : OUT STD_LOGIC;
    m_axis_tready : IN STD_LOGIC;
    m_axis_tdata : OUT STD_LOGIC_VECTOR(127 DOWNTO 0)
  );
END COMPONENT;

COMPONENT AXI4_Vector_Broadcaster
  PORT (
    aclk : IN STD_LOGIC;
    aresetn : IN STD_LOGIC;
    s_axis_tvalid : IN STD_LOGIC;
    s_axis_tready : OUT STD_LOGIC;
    s_axis_tdata : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
    m_axis_tvalid : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    m_axis_tready : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    m_axis_tdata : OUT STD_LOGIC_VECTOR(255 DOWNTO 0)
  );
END COMPONENT;

COMPONENT AXI4_Matrix_Broadcaster
  PORT (
    aclk : IN STD_LOGIC;
    aresetn : IN STD_LOGIC;
    s_axis_tvalid : IN STD_LOGIC;
    s_axis_tready : OUT STD_LOGIC;
    s_axis_tdata : IN STD_LOGIC_VECTOR(255 DOWNTO 0);
    m_axis_tvalid : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    m_axis_tready : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    m_axis_tdata : OUT STD_LOGIC_VECTOR(511 DOWNTO 0)
  );
END COMPONENT;

signal H_matrix: std_logic_vector(127 downto 0):=x"0000000000000002_FFFFFFFFFFFFFFFE";
signal R_matrix: std_logic_vector(63 downto 0):=x"FFFFFFFFFFFFFF95";

signal Kalman_Gain: std_logic_vector(127 downto 0):=(others => '0');
signal Kalman_ready,Kalman_valid:std_logic:='0';

signal Kalman_Gain_FIFO: std_logic_vector(127 downto 0):=(others => '0');
signal Kalman_ready_FIFO,Kalman_valid_FIFO:std_logic:='0';

signal Kalman_Gain_Broadcaster: std_logic_vector(255 downto 0):=(others => '0');
signal Kalman_ready_Broadcaster,Kalman_valid_Broadcaster:std_logic_vector(1 downto 0):="00";

signal Covriance_tdata_Broadcaster:std_logic_vector(511 downto 0);
signal Covriance_ready_Broadcaster,Covriance_valid_Broadcaster:std_logic_vector(1 downto 0):="00";

begin

CovarianceBroadcast:AXI4_Matrix_Broadcaster port map
(
    aclk => aclk,
    aresetn => aresetn,
    s_axis_tvalid => s_axis_predicted_covariance_matrix_tvalid,
    s_axis_tready => s_axis_predicted_covariance_matrix_tready,
    s_axis_tdata => s_axis_predicted_covariance_matrix_tdata,
    m_axis_tvalid => Covriance_valid_Broadcaster,
    m_axis_tready => Covriance_ready_Broadcaster,
    m_axis_tdata => Covriance_tdata_Broadcaster
  );


 m_axis_predicted_covariance_matrix_tdata <= Covriance_tdata_Broadcaster(511 downto 256);
 m_axis_predicted_covariance_matrix_tvalid <= Covriance_valid_Broadcaster(1);
 Covriance_ready_Broadcaster(1) <= m_axis_predicted_covariance_matrix_tready;

KalmanGainCompute:KalmanGain port map
(
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_predicted_covariance_matrix_tdata =>Covriance_tdata_Broadcaster(255 downto 0),
    s_axis_H_matrix_tdata =>H_matrix,
    s_axis_R_matrix_tdata =>R_matrix,
    s_axis_predicted_covariance_matrix_tready =>Covriance_ready_Broadcaster(0),
 --   s_axis_H_matrix_tready =>,
 --   s_axis_R_matrix_tready =>,
    s_axis_predicted_covariance_matrix_tvalid =>Covriance_valid_Broadcaster(0),
    s_axis_H_matrix_tvalid =>'1',
    s_axis_R_matrix_tvalid =>'1',
    m_axis_Kalman_Gain_tdata =>Kalman_Gain,
    m_axis_Kalman_Gain_tready =>Kalman_ready,
    m_axis_Kalman_Gain_tvalid =>Kalman_valid

);

kalman_fifo : AXI4_Vect_FIFO
  PORT MAP (
    s_axis_aresetn => aresetn,
    s_axis_aclk => aclk,
    s_axis_tvalid => Kalman_valid,
    s_axis_tready => Kalman_ready,
    s_axis_tdata => Kalman_Gain,
    m_axis_tvalid => Kalman_valid_FIFO,
    m_axis_tready => Kalman_ready_FIFO,
    m_axis_tdata => Kalman_Gain_FIFO
  );
  
  
kalman_broadcaster : AXI4_Vector_Broadcaster
  PORT MAP (
    aclk => aclk,
    aresetn => aresetn,
    s_axis_tvalid => Kalman_valid_FIFO,
    s_axis_tready => Kalman_ready_FIFO,
    s_axis_tdata => Kalman_Gain_FIFO,
    m_axis_tvalid => Kalman_valid_Broadcaster,
    m_axis_tready => Kalman_ready_Broadcaster,
    m_axis_tdata => Kalman_Gain_Broadcaster
  );
  
  m_axis_kalman_gain_tdata <= Kalman_Gain_Broadcaster(255 downto 128);
  m_axis_kalman_gain_tvalid <= Kalman_valid_Broadcaster(1);
  Kalman_ready_Broadcaster(1) <= m_axis_kalman_gain_tready;

estimateValueCompute:Estimate_value port map
( 
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_measurement_tdata =>s_axis_measurement_tdata,
    s_axis_H_matrix_tdata =>H_matrix,
    s_axis_predicted_estimate_tdata =>s_axis_predicted_estimate_tdata,
    s_axis_Kalman_Gain_tdata =>Kalman_Gain_Broadcaster(127 downto 0),
    s_axis_measurement_tready =>s_axis_measurement_tready,
    --s_axis_H_matrix_tready =>,
    s_axis_predicted_estimate_tready =>s_axis_predicted_estimate_tready,
    s_axis_Kalman_Gain_tready =>Kalman_ready_Broadcaster(0),
    s_axis_measurement_tvalid =>s_axis_measurement_tvalid,
    s_axis_H_matrix_tvalid =>'1',
    s_axis_predicted_estimate_tvalid =>s_axis_predicted_estimate_tvalid,
    s_axis_Kalman_Gain_tvalid =>Kalman_valid_Broadcaster(0),
    m_axis_estimate_tdata =>m_axis_estimate_tdata,
    m_axis_estimate_tready =>m_axis_estimate_tready,
    m_axis_estimate_tvalid =>m_axis_estimate_tvalid
 );

end Behavioral;
