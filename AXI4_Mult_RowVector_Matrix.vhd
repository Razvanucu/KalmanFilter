library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity AXI4_Mult_RowVector_Matrix is
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
end AXI4_Mult_RowVector_Matrix;

architecture Behavioral of AXI4_Mult_RowVector_Matrix is

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

--mult 
signal vect_mult_ready0,vect_mult_ready1:std_logic:='0';
signal vect_mult_ready2,vect_mult_ready3:std_logic:='0';
signal matrix_mult_ready0,matrix_mult_ready1:std_logic:='0';
signal matrix_mult_ready2,matrix_mult_ready3:std_logic:='0';
signal mult_vect_res0,mult_vect_res1:std_logic_vector(63 downto 0):= (others => '0');
signal mult_vect_res2,mult_vect_res3:std_logic_vector(63 downto 0):= (others => '0');
signal mult_vect_tvalid0,mult_vect_tvalid1:std_logic:='0';
signal mult_vect_tvalid2,mult_vect_tvalid3:std_logic:='0';

--add 
signal vect_add_ready0,vect_add_ready1:std_logic:='0';
signal vect_add_ready2,vect_add_ready3:std_logic:='0';

signal add_vect_tvalid0,add_vect_tvalid1:std_logic:='0';

begin

s_axis_vect_tready <= vect_mult_ready0 and vect_mult_ready1 and
                                   vect_mult_ready2 and vect_mult_ready3;
s_axis_matrix_tready <= matrix_mult_ready0 and matrix_mult_ready1 and matrix_mult_ready2 and matrix_mult_ready3;
                                    
mult0:AXI4_Multiplier port map
(
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_a_tdata =>s_axis_vect_tdata(63 downto 0),
    s_axis_b_tdata =>s_axis_matrix_tdata(63 downto 0),
    s_axis_a_tready =>vect_mult_ready0,
    s_axis_b_tready =>matrix_mult_ready0,
    s_axis_a_tvalid =>s_axis_vect_tvalid,
    s_axis_b_tvalid =>s_axis_matrix_tvalid,
    m_axis_res_tdata =>mult_vect_res0,
    m_axis_res_tready =>vect_add_ready0,
    m_axis_res_tvalid =>mult_vect_tvalid0
);

mult1:AXI4_Multiplier port map
(
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_a_tdata =>s_axis_vect_tdata(127 downto 64),
    s_axis_b_tdata =>s_axis_matrix_tdata(191 downto 128),
    s_axis_a_tready =>vect_mult_ready1,
    s_axis_b_tready =>matrix_mult_ready1,
    s_axis_a_tvalid =>s_axis_vect_tvalid,
    s_axis_b_tvalid =>s_axis_matrix_tvalid,
    m_axis_res_tdata =>mult_vect_res1,
    m_axis_res_tready =>vect_add_ready1,
    m_axis_res_tvalid =>mult_vect_tvalid1
);


mult2:AXI4_Multiplier port map
(
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_a_tdata =>s_axis_vect_tdata(63 downto 0),
    s_axis_b_tdata =>s_axis_matrix_tdata(127 downto 64),
    s_axis_a_tready =>vect_mult_ready2,
    s_axis_b_tready =>matrix_mult_ready2,
    s_axis_a_tvalid =>s_axis_vect_tvalid,
    s_axis_b_tvalid =>s_axis_matrix_tvalid,
    m_axis_res_tdata =>mult_vect_res2,
    m_axis_res_tready =>vect_add_ready2,
    m_axis_res_tvalid =>mult_vect_tvalid2
);


mult3:AXI4_Multiplier port map
(
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_a_tdata =>s_axis_vect_tdata(127 downto 64),
    s_axis_b_tdata =>s_axis_matrix_tdata(255 downto 192),
    s_axis_a_tready =>vect_mult_ready3,
    s_axis_b_tready =>matrix_mult_ready3,
    s_axis_a_tvalid =>s_axis_vect_tvalid,
    s_axis_b_tvalid =>s_axis_matrix_tvalid,
    m_axis_res_tdata => mult_vect_res3,
    m_axis_res_tready =>vect_add_ready3,
    m_axis_res_tvalid =>mult_vect_tvalid3
);



add0: AXI4_Adder_Subtracter port map
(
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_a_tdata =>mult_vect_res0,
    s_axis_b_tdata =>mult_vect_res1,
    s_axis_op_tdata =>'0',
    s_axis_a_tready =>vect_add_ready0,
    s_axis_b_tready =>vect_add_ready1,
    --s_axis_op_tready =>,
    s_axis_a_tvalid =>mult_vect_tvalid0,
    s_axis_b_tvalid =>mult_vect_tvalid1,
    s_axis_op_tvalid =>'1',
    m_axis_res_tdata =>m_axis_vect_tdata(63 downto 0),
    m_axis_res_tready =>m_axis_vect_tready,
    m_axis_res_tvalid =>add_vect_tvalid0

);


add1: AXI4_Adder_Subtracter port map
(
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_a_tdata =>mult_vect_res2,
    s_axis_b_tdata =>mult_vect_res3,
    s_axis_op_tdata =>'0',
    s_axis_a_tready =>vect_add_ready2,
    s_axis_b_tready =>vect_add_ready3,
    --s_axis_op_tready =>,
    s_axis_a_tvalid =>mult_vect_tvalid2,
    s_axis_b_tvalid =>mult_vect_tvalid3,
    s_axis_op_tvalid =>'1',
    m_axis_res_tdata => m_axis_vect_tdata(127 downto 64),
    m_axis_res_tready =>m_axis_vect_tready,
    m_axis_res_tvalid =>add_vect_tvalid1

);

m_axis_vect_tvalid <= add_vect_tvalid0 and add_vect_tvalid1;

end Behavioral;
