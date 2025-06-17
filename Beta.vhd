library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Beta is
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
end Beta;

architecture Behavioral of Beta is

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

component AXI4_Mult_Vect_Vect is
  Port ( 
    aclk: in std_logic;
    aresetn: in std_logic;
    s_axis_vect0_tdata: in std_logic_vector(127 downto 0);
    s_axis_vect1_tdata: in std_logic_vector(127 downto 0);
    s_axis_vect0_tready: out std_logic;
    s_axis_vect1_tready: out std_logic;
    s_axis_vect0_tvalid: in std_logic;
    s_axis_vect1_tvalid: in std_logic;
    m_axis_res_tdata: out std_logic_vector(63 downto 0);
    m_axis_res_tready: in std_logic; 
    m_axis_res_tvalid: out std_logic
  );
end component AXI4_Mult_Vect_Vect;

component AXI4_Adder_Subtracter is
port(
    aclk: in std_logic;
    aresetn: in std_logic;
    s_axis_a_tdata:in std_logic_vector(63 downto 0);
    s_axis_b_tdata:in std_logic_vector(63 downto 0);
    s_axis_op_tdata:in std_logic;
    s_axis_a_tready:out std_logic;
    s_axis_b_tready:out std_logic;
    s_axis_op_tready:out std_logic;
    s_axis_a_tvalid:in std_logic;
    s_axis_b_tvalid:in std_logic;
    s_axis_op_tvalid:in std_logic;
    m_axis_res_tdata: out std_logic_vector(63 downto 0);
    m_axis_res_tready: in std_logic;
    m_axis_res_tvalid: out std_logic
);
end component AXI4_Adder_Subtracter;

signal HP: std_logic_vector(127 downto 0):=(others =>'0');
signal HP_tready,HP_tvalid:std_logic:='0';

signal HPtrH: std_logic_vector(63 downto 0):=(others =>'0');
signal HPtrH_tready,HPtrH_tvalid:std_logic:='0';

signal H_ready0,H_ready1:std_logic:='0';
begin

s_axis_H_matrix_tready <= H_ready0 and H_ready1;

HPmult:AXI4_Mult_RowVector_Matrix port map
(
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_vect_tdata =>s_axis_H_matrix_tdata,
    s_axis_matrix_tdata =>s_axis_predicted_covariance_matrix_tdata,
    s_axis_vect_tready =>H_ready0,
    s_axis_matrix_tready =>s_axis_predicted_covariance_matrix_tready,
    s_axis_vect_tvalid =>s_axis_H_matrix_tvalid,
    s_axis_matrix_tvalid =>s_axis_predicted_covariance_matrix_tvalid,
    m_axis_vect_tdata =>HP,
    m_axis_vect_tready =>HP_tready,
    m_axis_vect_tvalid =>HP_tvalid
);

HPtrHmult:AXI4_Mult_Vect_Vect port map
(
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_vect0_tdata =>HP,
    s_axis_vect1_tdata =>s_axis_H_matrix_tdata,
    s_axis_vect0_tready =>HP_tready,
    s_axis_vect1_tready =>H_ready1,
    s_axis_vect0_tvalid =>HP_tvalid,
    s_axis_vect1_tvalid =>s_axis_H_matrix_tvalid,
    m_axis_res_tdata =>HPtrH,
    m_axis_res_tready =>HPtrH_tready,
    m_axis_res_tvalid =>HPtrH_tvalid
);

Add:AXI4_Adder_Subtracter port map
(
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_a_tdata =>HPtrH,
    s_axis_b_tdata =>s_axis_R_matrix_tdata,
    s_axis_op_tdata =>'0',
    s_axis_a_tready =>HPtrH_tready,
    s_axis_b_tready =>s_axis_R_matrix_tready,
    --s_axis_op_tready =>,
    s_axis_a_tvalid =>HPtrH_tvalid,
    s_axis_b_tvalid =>s_axis_R_matrix_tvalid,
    s_axis_op_tvalid =>'1',
    m_axis_res_tdata =>m_axis_Beta_tdata,
    m_axis_res_tready =>m_axis_Beta_tready,
    m_axis_res_tvalid =>m_axis_Beta_tvalid
);

end Behavioral;
