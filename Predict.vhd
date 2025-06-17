library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Predict is
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
end Predict;

architecture Behavioral of Predict is

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

component Predict_Covariance_Matrix is
  Port (
    aclk: in std_logic;
    aresetn: in std_logic;
    s_axis_previous_covariance_matrix_tdata: in std_logic_vector(255 downto 0);
    s_axis_Q_matrix_tdata: in std_logic_vector(255 downto 0);
    s_axis_A_matrix_tdata: in std_logic_vector(255 downto 0);
    s_axis_tr_A_matrix_tdata: in std_logic_vector(255 downto 0);
    s_axis_Q_matrix_tready: out std_logic;
    s_axis_A_matrix_tready: out std_logic;
    s_axis_previous_covariance_matrix_tready: out std_logic;
    s_axis_tr_A_matrix_tready: out std_logic;
    s_axis_previous_covariance_matrix_tvalid: in std_logic;
    s_axis_Q_matrix_tvalid: in std_logic;
    s_axis_A_matrix_tvalid: in std_logic;
    s_axis_tr_A_matrix_tvalid: in std_logic;
    m_axis_predicted_covariance_matrix_tdata: out std_logic_vector(255 downto 0);
    m_axis_predicted_covariance_matrix_tready: in std_logic;
    m_axis_predicted_covariance_matrix_tvalid: out std_logic   
   );
end component Predict_Covariance_Matrix;

signal A_matrix:std_logic_vector(255 downto 0):=x"FFFFFFFFFFFFFFFF_0000000000000001_0000000000000003_0000000000000003";
signal Q_matrix:std_logic_vector(255 downto 0):=x"0000000000000002_0000000000000000_0000000000000000_0000000000000002";
signal tr_A_matrix:std_logic_vector(255 downto 0):=x"FFFFFFFFFFFFFFFF_0000000000000003_0000000000000001_0000000000000003";

begin

Predict_Estimate:AXI4_Mult_Matrix_ColumnVector port map
(
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_vect_tdata =>s_axis_previous_estimate_tdata,
    s_axis_matrix_tdata =>A_matrix,
    s_axis_vect_tready =>s_axis_previous_estimate_tready,
    --s_axis_matrix_tready =>,
    s_axis_vect_tvalid =>s_axis_previous_estimate_tvalid,
    s_axis_matrix_tvalid =>'1',
    m_axis_vect_tdata =>m_axis_predicted_estimate_tdata,
    m_axis_vect_tready =>m_axis_predicted_estimate_tready, 
    m_axis_vect_tvalid =>m_axis_predicted_estimate_tvalid
);

Predict_Covariance:Predict_Covariance_Matrix port map
(
    aclk=>aclk,
    aresetn=>aclk,
    s_axis_previous_covariance_matrix_tdata=>s_axis_previous_covariance_matrix_tdata,
    s_axis_Q_matrix_tdata => Q_matrix,
    s_axis_A_matrix_tdata=>A_matrix,
    s_axis_tr_A_matrix_tdata=>tr_A_matrix,
   -- s_axis_Q_matrix_tready=>
   -- s_axis_A_matrix_tready=>
    s_axis_previous_covariance_matrix_tready=>s_axis_previous_covariance_matrix_tready,
    --s_axis_tr_A_matrix_tready=>
    s_axis_previous_covariance_matrix_tvalid=>s_axis_previous_covariance_matrix_tvalid,
    s_axis_Q_matrix_tvalid =>'1',
    s_axis_A_matrix_tvalid=>'1',
    s_axis_tr_A_matrix_tvalid=>'1',
    m_axis_predicted_covariance_matrix_tdata=>m_axis_predicted_covariance_matrix_tdata,
    m_axis_predicted_covariance_matrix_tready=>m_axis_predicted_covariance_matrix_tready,
    m_axis_predicted_covariance_matrix_tvalid=>m_axis_predicted_covariance_matrix_tvalid
);


end Behavioral;
