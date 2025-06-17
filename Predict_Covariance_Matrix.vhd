library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Predict_Covariance_Matrix is
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
end Predict_Covariance_Matrix;

architecture Behavioral of Predict_Covariance_Matrix is

component AXI4_Mult_Matrix_Matrix is
  Port ( 
    aclk: in std_logic;
    aresetn: in std_logic;
    s_axis_matrix0_tdata: in std_logic_vector(255 downto 0);
    s_axis_matrix1_tdata: in std_logic_vector(255 downto 0);
    s_axis_matrix0_tready: out std_logic;
    s_axis_matrix1_tready: out std_logic;
    s_axis_matrix0_tvalid: in std_logic;
    s_axis_matrix1_tvalid: in std_logic;
    m_axis_matrix_tdata: out std_logic_vector(255 downto 0);
    m_axis_matrix_tready: in std_logic; 
    m_axis_matrix_tvalid: out std_logic
  );
end component AXI4_Mult_Matrix_Matrix;

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

signal AP: std_logic_vector(255 downto 0):= (others =>'0');
signal first_mult_tready,first_mult_tvalid : std_logic:='0';

signal APtrA: std_logic_vector(255 downto 0):= (others =>'0');
signal second_mult_tready,second_mult_tvalid : std_logic:='0';

begin

AtimesP:AXI4_Mult_Matrix_Matrix port map
(
    aclk => aclk,
    aresetn => aresetn,
    s_axis_matrix0_tdata => s_axis_A_matrix_tdata, 
    s_axis_matrix1_tdata => s_axis_previous_covariance_matrix_tdata,
    s_axis_matrix0_tready => s_axis_A_matrix_tready,
    s_axis_matrix1_tready => s_axis_previous_covariance_matrix_tready,
    s_axis_matrix0_tvalid => s_axis_A_matrix_tvalid,
    s_axis_matrix1_tvalid => s_axis_previous_covariance_matrix_tvalid,
    m_axis_matrix_tdata => AP,
    m_axis_matrix_tready => first_mult_tready,
    m_axis_matrix_tvalid => first_mult_tvalid
);

AtimesPtimetrA:AXI4_Mult_Matrix_Matrix port map
(
    aclk => aclk,
    aresetn => aresetn,
    s_axis_matrix0_tdata => AP, 
    s_axis_matrix1_tdata => s_axis_tr_A_matrix_tdata,
    s_axis_matrix0_tready => first_mult_tready,
    s_axis_matrix1_tready => s_axis_tr_A_matrix_tready,
    s_axis_matrix0_tvalid => first_mult_tvalid,
    s_axis_matrix1_tvalid => s_axis_tr_A_matrix_tvalid,
    m_axis_matrix_tdata => APtrA,
    m_axis_matrix_tready => second_mult_tready,
    m_axis_matrix_tvalid => second_mult_tvalid
);

AtimesPTimestrAplusQ:AXI4_Matrix_Add_Subtract port map
(
    aclk => aclk,
    aresetn => aresetn,
    s_axis_matrix0_tdata => APtrA,
    s_axis_matrix1_tdata => s_axis_Q_matrix_tdata,
    s_axis_op_tdata => '0',
    s_axis_matrix0_tready => second_mult_tready,
    s_axis_matrix1_tready => s_axis_Q_matrix_tready,
    --s_axis_op_tready =>
    s_axis_matrix0_tvalid => second_mult_tvalid,
    s_axis_matrix1_tvalid => s_axis_Q_matrix_tvalid,
    s_axis_op_tvalid => '1',
    m_axis_matrix_tdata => m_axis_predicted_covariance_matrix_tdata,
    m_axis_matrix_tready => m_axis_predicted_covariance_matrix_tready,
    m_axis_matrix_tvalid => m_axis_predicted_covariance_matrix_tvalid
);

end Behavioral;
