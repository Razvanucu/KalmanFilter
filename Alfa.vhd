library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Alfa is
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
end Alfa;

architecture Behavioral of Alfa is

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

signal res:std_logic_vector(63 downto 0):=(others => '0');
signal res_ready,res_valid:std_logic:='0';
begin

hxmult:AXI4_Mult_Vect_Vect port map
(
    aclk => aclk,
    aresetn => aresetn,
    s_axis_vect0_tdata =>s_axis_H_matrix_tdata,
    s_axis_vect1_tdata =>s_axis_predicted_estimate_tdata,
    s_axis_vect0_tready =>s_axis_H_matrix_tready,
    s_axis_vect1_tready =>s_axis_predicted_estimate_tready,
    s_axis_vect0_tvalid =>s_axis_H_matrix_tvalid,
    s_axis_vect1_tvalid =>s_axis_predicted_estimate_tvalid,
    m_axis_res_tdata =>res,
    m_axis_res_tready =>res_ready, 
    m_axis_res_tvalid =>res_valid
);

zminushx:AXI4_Adder_Subtracter port map
(
    aclk => aclk ,
    aresetn => aresetn ,
    s_axis_a_tdata => s_axis_measurement_tdata,
    s_axis_b_tdata => res,
    s_axis_op_tdata => '1',
    s_axis_a_tready => s_axis_measurement_tready ,
    s_axis_b_tready => res_ready ,
   -- s_axis_op_tready => ,
    s_axis_a_tvalid => s_axis_measurement_tvalid ,
    s_axis_b_tvalid => res_valid,
    s_axis_op_tvalid => '1',
    m_axis_res_tdata => m_axis_alfa_tdata ,
    m_axis_res_tready => m_axis_alfa_tready ,
    m_axis_res_tvalid => m_axis_alfa_tvalid
);

end Behavioral;
