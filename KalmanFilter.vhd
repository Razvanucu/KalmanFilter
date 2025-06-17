library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity KalmanFilter is
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
end KalmanFilter;

architecture Behavioral of KalmanFilter is

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

COMPONENT AXI4_Matrix_FIFO
  PORT (
    s_axis_aresetn : IN STD_LOGIC;
    s_axis_aclk : IN STD_LOGIC;
    s_axis_tvalid : IN STD_LOGIC;
    s_axis_tready : OUT STD_LOGIC;
    s_axis_tdata : IN STD_LOGIC_VECTOR(255 DOWNTO 0);
    m_axis_tvalid : OUT STD_LOGIC;
    m_axis_tready : IN STD_LOGIC;
    m_axis_tdata : OUT STD_LOGIC_VECTOR(255 DOWNTO 0)
  );
END COMPONENT;

component Predict is
  Port (
    aclk: in std_logic;
    aresetn: in std_logic;
    s_axis_previous_estimate_tdata: in std_logic_vector(127 downto 0);
    s_axis_previous_covariance_matrix_tdata: in std_logic_vector(255 downto 0);
    s_axis_previous_estimate_tready: out std_logic;
    s_axis_previous_covariance_matrix_tready: out std_logic;
    s_axis_previous_estimate_tvalid: in std_logic;
    s_axis_previous_covariance_matrix_tvalid: in std_logic;
    m_axis_predicted_estimate_tdata: out std_logic_vector(127 downto 0);
    m_axis_predicted_covariance_matrix_tdata: out std_logic_vector(255 downto 0);
    m_axis_predicted_estimate_tready: in std_logic; 
    m_axis_predicted_covariance_matrix_tready: in std_logic;
    m_axis_predicted_estimate_tvalid: out std_logic;
    m_axis_predicted_covariance_matrix_tvalid: out std_logic
   );
end component Predict;

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

component ComputeCovariance is
 Port ( 
    aclk : in std_logic;
    aresetn: in std_logic;
    s_axis_kalman_gain_tdata: in std_logic_vector(127 downto 0);
    s_axis_estimate_tdata: in std_logic_vector(127 downto 0);
    s_axis_predicted_covariance_matrix_tdata: in std_logic_vector(255 downto 0);
    s_axis_kalman_gain_tready: out std_logic; 
    s_axis_estimate_tready: out std_logic; 
    s_axis_predicted_covariance_matrix_tready: out std_logic;
    s_axis_kalman_gain_tvalid: in std_logic;
    s_axis_estimate_tvalid: in std_logic;
    s_axis_predicted_covariance_matrix_tvalid: in std_logic;
    m_axis_estimate_tdata: out std_logic_vector(127 downto 0);
    m_axis_predicted_covariance_matrix_tdata: out std_logic_vector(255 downto 0);
    m_axis_estimate_tready: in std_logic; 
    m_axis_predicted_covariance_matrix_tready: in std_logic;
    m_axis_estimate_tvalid: out std_logic;
    m_axis_predicted_covariance_matrix_tvalid: out std_logic
 );
end component ComputeCovariance;

component AXI4_FIFO_Matrix_With_InitialValue is
  PORT (
    s_axis_aresetn : IN STD_LOGIC;
    s_axis_aclk : IN STD_LOGIC;
    s_axis_tvalid : IN STD_LOGIC;
    s_axis_tready : OUT STD_LOGIC;
    s_axis_tdata : IN STD_LOGIC_VECTOR(255 DOWNTO 0);
    m_axis_tvalid : OUT STD_LOGIC;
    m_axis_tready : IN STD_LOGIC;
    m_axis_tdata : OUT STD_LOGIC_VECTOR(255 DOWNTO 0)
  );
end component AXI4_FIFO_Matrix_With_InitialValue;

component AXI4_FIFO_Vect_With_InitialValue is
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
end component AXI4_FIFO_Vect_With_InitialValue;

COMPONENT AXI4_Data_Fifo
  PORT (
    s_axis_aresetn : IN STD_LOGIC;
    s_axis_aclk : IN STD_LOGIC;
    s_axis_tvalid : IN STD_LOGIC;
    s_axis_tready : OUT STD_LOGIC;
    s_axis_tdata : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    m_axis_tvalid : OUT STD_LOGIC;
    m_axis_tready : IN STD_LOGIC;
    m_axis_tdata : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
  );
END COMPONENT;

COMPONENT AXI4_Broadcaster
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

signal sig_estimate_in_tdata,sig_estimate_out_tdata:STD_LOGIC_VECTOR(127 DOWNTO 0) :=(others =>'0');
signal sig_estimate_in_tready,sig_estimate_in_tvalid : std_logic :='0';
signal sig_estimate_out_tready,sig_estimate_out_tvalid : std_logic :='0';

signal sig_covariance_in_tdata,sig_covariance_out_tdata:STD_LOGIC_VECTOR(255 DOWNTO 0) :=(others =>'0');
signal sig_covariance_in_tready,sig_covariance_in_tvalid : std_logic :='0';
signal sig_covariance_out_tready,sig_covariance_out_tvalid : std_logic :='0';


--Predict
signal Predict_estimate_out_tdata:STD_LOGIC_VECTOR(127 DOWNTO 0) :=(others =>'0');
signal Predict_estimate_out_tready,Predict_estimate_out_tvalid : std_logic :='0';

signal Predict_covariance_out_tdata:STD_LOGIC_VECTOR(255 DOWNTO 0) :=(others =>'0');
signal Predict_covariance_out_tready,Predict_covariance_out_tvalid : std_logic :='0';

signal Predict_estimate_in_tdata:STD_LOGIC_VECTOR(127 DOWNTO 0) :=(others =>'0');
signal Predict_estimate_in_tready,Predict_estimate_in_tvalid : std_logic :='0';

signal Predict_covariance_in_tdata:STD_LOGIC_VECTOR(255 DOWNTO 0) :=(others =>'0');
signal Predict_covariance_in_tready,Predict_covariance_in_tvalid : std_logic :='0';

--z
signal z_tdata:STD_LOGIC_VECTOR(63 DOWNTO 0) :=(others =>'0');
signal z_tready,z_tvalid : std_logic :='0';


--Estimate
signal Estimate_Kalman_Gain_out_tdata:STD_LOGIC_VECTOR(127 DOWNTO 0) :=(others =>'0');
signal Estimate_Kalman_Gain_out_tready,Estimate_Kalman_Gain_out_tvalid : std_logic :='0';

signal Estimate_estimate_out_tdata:STD_LOGIC_VECTOR(127 DOWNTO 0) :=(others =>'0');
signal Estimate_estimate_out_tready,Estimate_estimate_out_tvalid : std_logic :='0';

signal Estimate_covariance_out_tdata:STD_LOGIC_VECTOR(255 DOWNTO 0) :=(others =>'0');
signal Estimate_covariance_out_tready,Estimate_covariance_out_tvalid : std_logic :='0';

signal Estimate_Kalman_Gain_in_tdata:STD_LOGIC_VECTOR(127 DOWNTO 0) :=(others =>'0');
signal Estimate_Kalman_Gain_in_tready,Estimate_Kalman_Gain_in_tvalid : std_logic :='0';

signal Estimate_estimate_in_tdata:STD_LOGIC_VECTOR(127 DOWNTO 0) :=(others =>'0');
signal Estimate_estimate_in_tready,Estimate_estimate_in_tvalid : std_logic :='0';

signal Estimate_estimate_in_broadcast_tdata:STD_LOGIC_VECTOR(255 DOWNTO 0) :=(others =>'0');
signal Estimate_estimate_in_broadcast_tready,Estimate_estimate_broadcast_in_tvalid : std_logic_vector(1 downto 0) :="00";

signal Estimate_covariance_in_tdata:STD_LOGIC_VECTOR(255 DOWNTO 0) :=(others =>'0');
signal Estimate_covariance_in_tready,Estimate_covariance_in_tvalid : std_logic :='0';



begin

x0:AXI4_FIFO_Vect_With_InitialValue port map
(
    s_axis_aresetn =>aresetn,
    s_axis_aclk =>aclk,
    s_axis_tvalid =>sig_estimate_in_tvalid,
    s_axis_tready =>sig_estimate_in_tready,
    s_axis_tdata =>sig_estimate_in_tdata,
    m_axis_tvalid =>sig_estimate_out_tvalid,
    m_axis_tready =>sig_estimate_out_tready,
    m_axis_tdata =>sig_estimate_out_tdata
);

p0:AXI4_FIFO_Matrix_With_InitialValue port map
(
    s_axis_aresetn =>aresetn,
    s_axis_aclk =>aclk,
    s_axis_tvalid =>sig_covariance_in_tvalid,
    s_axis_tready =>sig_covariance_in_tready,
    s_axis_tdata =>sig_covariance_in_tdata,
    m_axis_tvalid =>sig_covariance_out_tvalid,
    m_axis_tready =>sig_covariance_out_tready,
    m_axis_tdata =>sig_covariance_out_tdata
);

PredictStep:Predict port map
(
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_previous_estimate_tdata =>sig_estimate_out_tdata,
    s_axis_previous_covariance_matrix_tdata =>sig_covariance_out_tdata,
    s_axis_previous_estimate_tready =>sig_estimate_out_tready,
    s_axis_previous_covariance_matrix_tready =>sig_covariance_out_tready,
    s_axis_previous_estimate_tvalid =>sig_estimate_out_tvalid,
    s_axis_previous_covariance_matrix_tvalid =>sig_covariance_out_tvalid,
    m_axis_predicted_estimate_tdata =>Predict_estimate_out_tdata,
    m_axis_predicted_covariance_matrix_tdata =>Predict_covariance_out_tdata,
    m_axis_predicted_estimate_tready =>Predict_estimate_out_tready,
    m_axis_predicted_covariance_matrix_tready =>Predict_covariance_out_tready,
    m_axis_predicted_estimate_tvalid =>Predict_estimate_out_tvalid,
    m_axis_predicted_covariance_matrix_tvalid =>Predict_covariance_out_tvalid
);

zfifo:AXI4_Data_Fifo
  PORT MAP (
    s_axis_aresetn => aresetn,
    s_axis_aclk => aclk,
    s_axis_tvalid => s_axis_measurement_tvalid,
    s_axis_tready => s_axis_measurement_tready,
    s_axis_tdata => s_axis_measurement_tdata,
    m_axis_tvalid => z_tvalid,
    m_axis_tready => z_tready,
    m_axis_tdata => z_tdata
  );

predictedestimate: AXI4_Vect_FIFO
  PORT MAP (
    s_axis_aresetn => aresetn,
    s_axis_aclk => aclk,
    s_axis_tvalid => Predict_estimate_out_tvalid,
    s_axis_tready => Predict_estimate_out_tready,
    s_axis_tdata => Predict_estimate_out_tdata,
    m_axis_tvalid => Predict_estimate_in_tvalid,
    m_axis_tready => Predict_estimate_in_tready,
    m_axis_tdata => Predict_estimate_in_tdata
  );
  
predictedcovriance: AXI4_Matrix_FIFO   
  PORT MAP (
    s_axis_aresetn => aresetn,
    s_axis_aclk => aclk,
    s_axis_tvalid => Predict_covariance_out_tvalid,
    s_axis_tready => Predict_covariance_out_tready,
    s_axis_tdata => Predict_covariance_out_tdata,
    m_axis_tvalid => Predict_covariance_in_tvalid,
    m_axis_tready => Predict_covariance_in_tready,
    m_axis_tdata => Predict_covariance_in_tdata
  );
  
EstimateStep:Estimate port map
(
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_measurement_tdata =>z_tdata,
    s_axis_predicted_estimate_tdata =>Predict_estimate_in_tdata,
    s_axis_predicted_covariance_matrix_tdata =>Predict_covariance_in_tdata,
    s_axis_measurement_tready =>z_tready,
    s_axis_predicted_estimate_tready =>Predict_estimate_in_tready,
    s_axis_predicted_covariance_matrix_tready =>Predict_covariance_in_tready,
    s_axis_measurement_tvalid =>z_tvalid,
    s_axis_predicted_estimate_tvalid =>Predict_estimate_in_tvalid,
    s_axis_predicted_covariance_matrix_tvalid =>Predict_covariance_in_tvalid,
    m_axis_kalman_gain_tdata =>Estimate_Kalman_Gain_out_tdata,
    m_axis_estimate_tdata =>Estimate_estimate_out_tdata,
    m_axis_predicted_covariance_matrix_tdata =>Estimate_covariance_out_tdata,
    m_axis_kalman_gain_tready =>Estimate_Kalman_Gain_out_tready, 
    m_axis_estimate_tready =>Estimate_estimate_out_tready, 
    m_axis_predicted_covariance_matrix_tready =>Estimate_covariance_out_tready,
    m_axis_kalman_gain_tvalid =>Estimate_Kalman_Gain_out_tvalid,
    m_axis_estimate_tvalid =>Estimate_estimate_out_tvalid,
    m_axis_predicted_covariance_matrix_tvalid =>Estimate_covariance_out_tvalid
);

estimateFIFO: AXI4_Vect_FIFO
  PORT MAP (
    s_axis_aresetn => aresetn,
    s_axis_aclk => aclk,
    s_axis_tvalid => Estimate_estimate_out_tvalid,
    s_axis_tready => Estimate_estimate_out_tready,
    s_axis_tdata => Estimate_estimate_out_tdata,
    m_axis_tvalid => Estimate_estimate_in_tvalid,
    m_axis_tready => Estimate_estimate_in_tready,
    m_axis_tdata => Estimate_estimate_in_tdata
  );

estimateBroadcaters : AXI4_Broadcaster
  PORT MAP (
    aclk => aclk,
    aresetn => aresetn,
    s_axis_tvalid => Estimate_estimate_in_tvalid,
    s_axis_tready => Estimate_estimate_in_tready,
    s_axis_tdata => Estimate_estimate_in_tdata,
    m_axis_tvalid => Estimate_estimate_broadcast_in_tvalid,
    m_axis_tready => Estimate_estimate_in_broadcast_tready,
    m_axis_tdata => Estimate_estimate_in_broadcast_tdata
  );
  
  m_axis_estimate_tdata <= Estimate_estimate_in_broadcast_tdata(255 downto 128);
  Estimate_estimate_in_broadcast_tready(1) <= m_axis_estimate_tready;
  m_axis_estimate_tvalid <= Estimate_estimate_broadcast_in_tvalid(1);
  
predictedCovarianceFIFO: AXI4_Matrix_FIFO   
  PORT MAP (
    s_axis_aresetn => aresetn,
    s_axis_aclk => aclk,
    s_axis_tvalid => Estimate_covariance_out_tvalid,
    s_axis_tready => Estimate_covariance_out_tready,
    s_axis_tdata => Estimate_covariance_out_tdata,
    m_axis_tvalid => Estimate_covariance_in_tvalid,
    m_axis_tready => Estimate_covariance_in_tready,
    m_axis_tdata => Estimate_covariance_in_tdata
  );
  
KalmanGainFIFO: AXI4_Vect_FIFO
  PORT MAP (
    s_axis_aresetn => aresetn,
    s_axis_aclk => aclk,
    s_axis_tvalid => Estimate_Kalman_Gain_out_tvalid,
    s_axis_tready => Estimate_Kalman_Gain_out_tready,
    s_axis_tdata => Estimate_Kalman_Gain_out_tdata,
    m_axis_tvalid => Estimate_Kalman_Gain_in_tvalid,
    m_axis_tready => Estimate_Kalman_Gain_in_tready,
    m_axis_tdata => Estimate_Kalman_Gain_in_tdata
  );
  
ComputeCovarianceMatrixStep:ComputeCovariance port map
(
    aclk => aclk,
    aresetn => aresetn,
    s_axis_kalman_gain_tdata =>Estimate_Kalman_Gain_in_tdata,
    s_axis_estimate_tdata =>Estimate_estimate_in_broadcast_tdata(127 downto 0),
    s_axis_predicted_covariance_matrix_tdata =>Estimate_covariance_in_tdata,
    s_axis_kalman_gain_tready =>Estimate_Kalman_Gain_in_tready,
    s_axis_estimate_tready =>Estimate_estimate_in_broadcast_tready(0), 
    s_axis_predicted_covariance_matrix_tready =>Estimate_covariance_in_tready,
    s_axis_kalman_gain_tvalid =>Estimate_Kalman_Gain_in_tvalid,
    s_axis_estimate_tvalid =>Estimate_estimate_broadcast_in_tvalid(0),
    s_axis_predicted_covariance_matrix_tvalid =>Estimate_covariance_in_tvalid,
    m_axis_estimate_tdata =>sig_estimate_in_tdata,
    m_axis_predicted_covariance_matrix_tdata =>sig_covariance_in_tdata,
    m_axis_estimate_tready =>sig_estimate_in_tready,
    m_axis_predicted_covariance_matrix_tready =>sig_covariance_in_tready,
    m_axis_estimate_tvalid =>sig_estimate_in_tvalid,
    m_axis_predicted_covariance_matrix_tvalid =>sig_covariance_in_tvalid
);

end Behavioral;
