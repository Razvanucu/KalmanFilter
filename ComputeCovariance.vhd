library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ComputeCovariance is
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
end ComputeCovariance;

architecture Behavioral of ComputeCovariance is

component AXI4_Mult_ColVect_RowVect is
  Port ( 
     aclk: in std_logic;
    aresetn: in std_logic;
    s_axis_vect0_tdata: in std_logic_vector(127 downto 0);
    s_axis_vect1_tdata: in std_logic_vector(127 downto 0);
    s_axis_vect0_tready: out std_logic;
    s_axis_vect1_tready: out std_logic;
    s_axis_vect0_tvalid: in std_logic;
    s_axis_vect1_tvalid: in std_logic;
    m_axis_matrix_tdata: out std_logic_vector(255 downto 0);
    m_axis_matrix_tready: in std_logic; 
    m_axis_matrix_tvalid: out  std_logic
  );
end component AXI4_Mult_ColVect_RowVect;

component AXI4_Mult_RowVector_Matrix is
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
end component AXI4_Mult_RowVector_Matrix;

component AXI4_Matrix_Add_Subtract is
  Port ( 
    aclk: in std_logic;
    aresetn: in std_logic;
    s_axis_matrix0_tdata: in std_logic_vector(255 downto 0);
    s_axis_matrix1_tdata: in std_logic_vector(255 downto 0);
    s_axis_op_tdata: in std_logic;
    s_axis_matrix0_tready: out std_logic;
    s_axis_matrix1_tready: out std_logic;
    s_axis_op_tready: out std_logic;
    s_axis_matrix0_tvalid: in std_logic;
    s_axis_matrix1_tvalid: in std_logic;
    s_axis_op_tvalid:in std_logic;
    m_axis_matrix_tdata: out std_logic_vector(255 downto 0);
    m_axis_matrix_tready: in std_logic; 
    m_axis_matrix_tvalid: out std_logic
  );
end component AXI4_Matrix_Add_Subtract;

signal H_matrix:std_logic_vector(127 downto 0):=x"FFFFFFFFFFFFFFFE_0000000000000002";
signal P_ready0,P_ready1:std_logic:='0';

signal HP:std_logic_vector(127 downto 0):=(others =>'0');
signal HP_ready,HP_valid:std_logic:='0';

signal KHP:std_logic_vector(255 downto 0):=(others =>'0');
signal KHP_ready,KHP_valid:std_logic:='0';

begin

hpmult:AXI4_Mult_RowVector_Matrix port map
(
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_vect_tdata => H_matrix,
    s_axis_matrix_tdata => s_axis_predicted_covariance_matrix_tdata,
    --s_axis_vect_tready =>,
    s_axis_matrix_tready =>P_ready0,
    s_axis_vect_tvalid =>'1',
    s_axis_matrix_tvalid =>s_axis_predicted_covariance_matrix_tvalid,
    m_axis_vect_tdata =>HP,
    m_axis_vect_tready =>HP_ready,
    m_axis_vect_tvalid =>HP_valid
);

khpmult:AXI4_Mult_ColVect_RowVect port map
(
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_vect0_tdata =>s_axis_kalman_gain_tdata,
    s_axis_vect1_tdata =>HP,
    s_axis_vect0_tready =>HP_ready,
    s_axis_vect1_tready =>s_axis_kalman_gain_tready,
    s_axis_vect0_tvalid =>HP_valid,
    s_axis_vect1_tvalid =>s_axis_kalman_gain_tvalid,
    m_axis_matrix_tdata =>KHP,
    m_axis_matrix_tready =>KHP_ready,
    m_axis_matrix_tvalid =>KHP_valid
);

s_axis_predicted_covariance_matrix_tready <= P_ready0 and P_ready1;

pminuskhp:AXI4_Matrix_Add_Subtract port map
(
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_matrix0_tdata =>s_axis_predicted_covariance_matrix_tdata,
    s_axis_matrix1_tdata =>KHP,
    s_axis_op_tdata =>'1',
    s_axis_matrix0_tready =>P_ready1,
    s_axis_matrix1_tready =>KHP_ready,
    --s_axis_op_tready =>,
    s_axis_matrix0_tvalid =>s_axis_predicted_covariance_matrix_tvalid,
    s_axis_matrix1_tvalid =>KHP_valid,
    s_axis_op_tvalid =>'1',
    m_axis_matrix_tdata =>m_axis_predicted_covariance_matrix_tdata,
    m_axis_matrix_tready =>m_axis_predicted_covariance_matrix_tready,
    m_axis_matrix_tvalid =>m_axis_predicted_covariance_matrix_tvalid
);

m_axis_estimate_tdata <= s_axis_estimate_tdata;
s_axis_estimate_tready <= m_axis_estimate_tready;
m_axis_estimate_tvalid <= s_axis_estimate_tvalid;

end Behavioral;
