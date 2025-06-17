library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity KalmanGain is
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
end KalmanGain;

architecture Behavioral of KalmanGain is

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

component AXI4_Mult_Matrix_ColumnVector is
  Port ( 
    aclk: in std_logic;
    aresetn: in std_logic;
    s_axis_vect_tdata: in std_logic_vector(127 downto 0);
    s_axis_matrix_tdata: in std_logic_vector(255 downto 0);
    s_axis_vect_tready: out std_logic;
    s_axis_matrix_tready: out std_logic;
    s_axis_vect_tvalid: in std_logic;
    s_axis_matrix_tvalid: in std_logic;
    m_axis_vect_tdata: out std_logic_vector(127 downto 0);
    m_axis_vect_tready: in std_logic; 
    m_axis_vect_tvalid: out std_logic
  );
end component AXI4_Mult_Matrix_ColumnVector;

component AXI4_Division is
port(
    aclk: in std_logic;
    aresetn: in std_logic;
    s_axis_a_tdata:in std_logic_vector(63 downto 0);
    s_axis_b_tdata:in std_logic_vector(63 downto 0);
    s_axis_a_tready:out std_logic;
    s_axis_b_tready:out std_logic;
    s_axis_a_tvalid:in std_logic;
    s_axis_b_tvalid:in std_logic;
    m_axis_res_tdata: out std_logic_vector(63 downto 0);
    m_axis_res_tready: in std_logic;
    m_axis_res_tvalid: out std_logic
);
end component AXI4_Division;

signal H_ready0,H_ready1:std_logic:='0';
signal P_ready0,P_ready1:std_logic:='0';

signal Beta_tdata:std_logic_vector(63 downto 0):=(others => '0');
signal Beta_tready,Beta_tvalid:std_logic:='0';
signal Beta_tready0,Beta_tready1:std_logic:='0';

signal PH:std_logic_vector(127 downto 0):=(others => '0');
signal PH_tready,PH_tvalid:std_logic:='0'; 
signal PH_tready0,PH_tready1:std_logic:='0'; 

signal Kalman_valid0,Kalman_valid1:std_logic:='0';

begin

s_axis_H_matrix_tready <= H_ready0 and H_ready1;
s_axis_predicted_covariance_matrix_tready<= P_ready0 and P_ready1;

b:Beta port map
(
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_predicted_covariance_matrix_tdata =>s_axis_predicted_covariance_matrix_tdata,
    s_axis_H_matrix_tdata => s_axis_H_matrix_tdata,
    s_axis_R_matrix_tdata => s_axis_R_matrix_tdata,
    s_axis_predicted_covariance_matrix_tready => P_ready0,
    s_axis_H_matrix_tready =>H_ready0,
    s_axis_R_matrix_tready => s_axis_R_matrix_tready,
    s_axis_predicted_covariance_matrix_tvalid =>s_axis_predicted_covariance_matrix_tvalid,
    s_axis_H_matrix_tvalid =>s_axis_H_matrix_tvalid,
    s_axis_R_matrix_tvalid =>s_axis_R_matrix_tvalid,
    m_axis_Beta_tdata =>Beta_tdata,
    m_axis_Beta_tready =>Beta_tready,
    m_axis_Beta_tvalid =>Beta_tvalid
);

PHmult:AXI4_Mult_Matrix_ColumnVector port map
(
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_vect_tdata =>s_axis_H_matrix_tdata,
    s_axis_matrix_tdata =>s_axis_predicted_covariance_matrix_tdata,
    s_axis_vect_tready =>H_ready1,
    s_axis_matrix_tready =>P_ready1,
    s_axis_vect_tvalid =>s_axis_H_matrix_tvalid,
    s_axis_matrix_tvalid =>s_axis_predicted_covariance_matrix_tvalid,
    m_axis_vect_tdata =>PH,
    m_axis_vect_tready =>PH_tready,
    m_axis_vect_tvalid =>PH_tvalid
);

div0:AXI4_Division port map
(
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_a_tdata => PH(63 downto 0),
    s_axis_b_tdata => Beta_tdata,
    s_axis_a_tready =>PH_tready0,
    s_axis_b_tready =>Beta_tready0,
    s_axis_a_tvalid =>PH_tvalid,
    s_axis_b_tvalid =>Beta_tvalid,
    m_axis_res_tdata =>m_axis_Kalman_Gain_tdata(63 downto 0),
    m_axis_res_tready => m_axis_Kalman_Gain_tready,
    m_axis_res_tvalid => Kalman_valid0
);

div1:AXI4_Division port map
(
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_a_tdata => PH(127 downto 64),
    s_axis_b_tdata => Beta_tdata,
    s_axis_a_tready =>PH_tready1,
    s_axis_b_tready =>Beta_tready1,
    s_axis_a_tvalid =>PH_tvalid,
    s_axis_b_tvalid =>Beta_tvalid,
    m_axis_res_tdata =>m_axis_Kalman_Gain_tdata(127 downto 64),
    m_axis_res_tready => m_axis_Kalman_Gain_tready,
    m_axis_res_tvalid => Kalman_valid1
);

m_axis_Kalman_Gain_tvalid<= Kalman_valid0 and Kalman_valid1;

end Behavioral;
