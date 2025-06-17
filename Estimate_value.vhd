library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Estimate_value is
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
end Estimate_value;

architecture Behavioral of Estimate_value is

component AXI4_Vect_Add_Subtract is
   Port ( 
    aclk: in std_logic;
    aresetn: in std_logic;
    s_axis_vect0_tdata: in std_logic_vector(127 downto 0);
    s_axis_vect1_tdata: in std_logic_vector(127 downto 0);
    s_axis_op_tdata: in std_logic;
    s_axis_vect0_tready: out std_logic;
    s_axis_vect1_tready: out std_logic;
    s_axis_op_tready: out std_logic;
    s_axis_vect0_tvalid: in std_logic;
    s_axis_vect1_tvalid: in std_logic;
    s_axis_op_tvalid: in std_logic;
    m_axis_vect_tdata: out std_logic_vector(127 downto 0);
    m_axis_vect_tready: in std_logic; 
    m_axis_vect_tvalid: out std_logic
  );
end component AXI4_Vect_Add_Subtract;

component Alfa is
  Port ( 
    aclk: in std_logic;
    aresetn: in std_logic;
    s_axis_measurement_tdata: in std_logic_vector(63 downto 0);
    s_axis_H_matrix_tdata: in std_logic_vector(127 downto 0);
    s_axis_predicted_estimate_tdata: in std_logic_vector(127 downto 0);
    s_axis_measurement_tready: out std_logic;
    s_axis_H_matrix_tready: out std_logic;
    s_axis_predicted_estimate_tready: out std_logic;
    s_axis_measurement_tvalid: in std_logic;
    s_axis_H_matrix_tvalid: in std_logic;
    s_axis_predicted_estimate_tvalid: in std_logic;
    m_axis_alfa_tdata: out std_logic_vector(63 downto 0);
    m_axis_alfa_tready: in std_logic;
    m_axis_alfa_tvalid: out std_logic
  );
end component Alfa;

component AXI4_Multiplier is
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
end component AXI4_Multiplier;

signal predicted_estimate_ready0,predicted_estimate_ready1 : std_logic:='0';

signal afla:std_logic_vector(63 downto 0):=(others =>'0');
signal alfa_valid:std_logic:='0';
signal alfa_ready,alfa_ready0,alfa_ready1:std_logic:='0';

signal Kalman_Gain_ready0,Kalman_Gain_ready1:std_logic:='0';

signal Ka:std_logic_vector(127 downto 0):=(others =>'0');
signal Ka_ready:std_logic:='0';
signal Ka_valid,Ka_valid0,Ka_valid1:std_logic:='0';

begin

a:Alfa port map
(
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_measurement_tdata =>s_axis_measurement_tdata,
    s_axis_H_matrix_tdata =>s_axis_H_matrix_tdata,
    s_axis_predicted_estimate_tdata =>s_axis_predicted_estimate_tdata,
    s_axis_measurement_tready =>s_axis_measurement_tready,
    s_axis_H_matrix_tready =>s_axis_H_matrix_tready,
    s_axis_predicted_estimate_tready =>predicted_estimate_ready0,
    s_axis_measurement_tvalid =>s_axis_measurement_tvalid,
    s_axis_H_matrix_tvalid =>s_axis_H_matrix_tvalid,
    s_axis_predicted_estimate_tvalid =>s_axis_predicted_estimate_tvalid,
    m_axis_alfa_tdata =>afla,
    m_axis_alfa_tready =>alfa_ready,
    m_axis_alfa_tvalid =>alfa_valid
);

s_axis_Kalman_Gain_tready<= Kalman_Gain_ready0 and Kalman_Gain_ready1;
alfa_ready <= alfa_ready0 and alfa_ready1;

k0:AXI4_Multiplier port map
(
    aclk=>aclk,
    aresetn=>aresetn,
    s_axis_a_tdata=>s_axis_Kalman_Gain_tdata(63 downto 0),
    s_axis_b_tdata=>afla,
    s_axis_a_tready=>Kalman_Gain_ready0,
    s_axis_b_tready=>alfa_ready0,
    s_axis_a_tvalid=>s_axis_Kalman_Gain_tvalid,
    s_axis_b_tvalid=>alfa_valid,
    m_axis_res_tdata=>Ka(63 downto 0),
    m_axis_res_tready=>Ka_ready,
    m_axis_res_tvalid=>Ka_valid0
);

k1:AXI4_Multiplier port map
(
    aclk=>aclk,
    aresetn=>aresetn,
    s_axis_a_tdata=>s_axis_Kalman_Gain_tdata(127 downto 64),
    s_axis_b_tdata=>afla,
    s_axis_a_tready=>Kalman_Gain_ready1,
    s_axis_b_tready=>alfa_ready1,
    s_axis_a_tvalid=>s_axis_Kalman_Gain_tvalid,
    s_axis_b_tvalid=>alfa_valid,
    m_axis_res_tdata=>Ka(127 downto 64),
    m_axis_res_tready=>Ka_ready,
    m_axis_res_tvalid=>Ka_valid1
);

Ka_valid <= Ka_valid0 and Ka_valid1;
s_axis_predicted_estimate_tready <= predicted_estimate_ready0 and predicted_estimate_ready1;

estimatecalc:AXI4_Vect_Add_Subtract port map
(
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_vect0_tdata =>s_axis_predicted_estimate_tdata,
    s_axis_vect1_tdata =>Ka,
    s_axis_op_tdata =>'0',
    s_axis_vect0_tready =>predicted_estimate_ready1,
    s_axis_vect1_tready =>Ka_ready,
    --s_axis_op_tready =>,
    s_axis_vect0_tvalid =>s_axis_predicted_estimate_tvalid,
    s_axis_vect1_tvalid =>Ka_valid,
    s_axis_op_tvalid =>'1',
    m_axis_vect_tdata =>m_axis_estimate_tdata,
    m_axis_vect_tready =>m_axis_estimate_tready,
    m_axis_vect_tvalid =>m_axis_estimate_tvalid
);

end Behavioral;
