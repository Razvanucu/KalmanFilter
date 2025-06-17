library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity AXI4_Vect_Add_Subtract is
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
end AXI4_Vect_Add_Subtract;

architecture Behavioral of AXI4_Vect_Add_Subtract is

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

signal matrix_add_ready0,matrix_add_ready1 : std_logic :='0';
signal matrix_add_ready2,matrix_add_ready3 : std_logic :='0';

signal op_tready0,op_tready1 : std_logic :='0';

signal add_matrix_tvalid0,add_matrix_tvalid1 : std_logic :='0';

begin

s_axis_vect0_tready <= matrix_add_ready0 and matrix_add_ready2;
s_axis_vect1_tready <= matrix_add_ready1 and matrix_add_ready3;
s_axis_op_tready <= op_tready0 and op_tready1;

add0: AXI4_Adder_Subtracter port map
(
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_a_tdata =>s_axis_vect0_tdata(63 downto 0),
    s_axis_b_tdata =>s_axis_vect1_tdata(63 downto 0),
    s_axis_op_tdata => s_axis_op_tdata,
    s_axis_a_tready =>matrix_add_ready0,
    s_axis_b_tready =>matrix_add_ready1,
    s_axis_op_tready => op_tready0,
    s_axis_a_tvalid =>s_axis_vect0_tvalid,
    s_axis_b_tvalid =>s_axis_vect1_tvalid,
    s_axis_op_tvalid => s_axis_op_tvalid,
    m_axis_res_tdata =>m_axis_vect_tdata(63 downto 0),
    m_axis_res_tready =>m_axis_vect_tready,
    m_axis_res_tvalid =>add_matrix_tvalid0

);


add1: AXI4_Adder_Subtracter port map
(
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_a_tdata =>s_axis_vect0_tdata(127 downto 64),
    s_axis_b_tdata =>s_axis_vect1_tdata(127 downto 64),
    s_axis_op_tdata =>s_axis_op_tdata,
    s_axis_a_tready =>matrix_add_ready2,
    s_axis_b_tready =>matrix_add_ready3,
    s_axis_op_tready =>op_tready1,
    s_axis_a_tvalid =>s_axis_vect0_tvalid,
    s_axis_b_tvalid =>s_axis_vect1_tvalid,
    s_axis_op_tvalid =>s_axis_op_tvalid,
    m_axis_res_tdata => m_axis_vect_tdata(127 downto 64),
    m_axis_res_tready =>m_axis_vect_tready,
    m_axis_res_tvalid =>add_matrix_tvalid1

);

m_axis_vect_tvalid <= add_matrix_tvalid0 and add_matrix_tvalid1;

end Behavioral;
