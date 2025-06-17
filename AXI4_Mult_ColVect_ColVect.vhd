library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity AXI4_Mult_ColVect_RowVect is
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
end AXI4_Mult_ColVect_RowVect;

architecture Behavioral of AXI4_Mult_ColVect_RowVect is

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

signal vect0_mult_ready0,vect0_mult_ready1,vect0_mult_ready2,vect0_mult_ready3 :std_logic:='0';
signal vect1_mult_ready0,vect1_mult_ready1,vect1_mult_ready2,vect1_mult_ready3 :std_logic:='0';

signal matrix_mult_ready0,matrix_mult_ready1,matrix_mult_ready2,matrix_mult_ready3 :std_logic:='0';
begin

s_axis_vect0_tready <= vect0_mult_ready0 and vect0_mult_ready1 and vect0_mult_ready2 and vect0_mult_ready3;
s_axis_vect1_tready <= vect1_mult_ready0 and vect1_mult_ready1 and vect1_mult_ready2 and vect1_mult_ready3;

mult0:AXI4_Multiplier port map
(
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_a_tdata =>s_axis_vect0_tdata(63 downto 0),
    s_axis_b_tdata =>s_axis_vect1_tdata(63 downto 0),
    s_axis_a_tready =>vect0_mult_ready0,
    s_axis_b_tready =>vect1_mult_ready0,
    s_axis_a_tvalid =>s_axis_vect0_tvalid,
    s_axis_b_tvalid =>s_axis_vect1_tvalid,
    m_axis_res_tdata => m_axis_matrix_tdata(63 downto 0),
    m_axis_res_tready =>m_axis_matrix_tready,
    m_axis_res_tvalid =>matrix_mult_ready0
);

mult1:AXI4_Multiplier port map
(
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_a_tdata =>s_axis_vect0_tdata(63 downto 0),
    s_axis_b_tdata =>s_axis_vect1_tdata(127 downto 64),
    s_axis_a_tready =>vect0_mult_ready1,
    s_axis_b_tready =>vect1_mult_ready1,
    s_axis_a_tvalid =>s_axis_vect0_tvalid,
    s_axis_b_tvalid =>s_axis_vect1_tvalid,
    m_axis_res_tdata =>m_axis_matrix_tdata(127 downto 64),
    m_axis_res_tready =>m_axis_matrix_tready,
    m_axis_res_tvalid =>matrix_mult_ready1
);

mult2:AXI4_Multiplier port map
(
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_a_tdata =>s_axis_vect0_tdata(127 downto 64),
    s_axis_b_tdata =>s_axis_vect1_tdata(63 downto 0),
    s_axis_a_tready =>vect0_mult_ready2,
    s_axis_b_tready =>vect1_mult_ready2,
    s_axis_a_tvalid =>s_axis_vect0_tvalid,
    s_axis_b_tvalid =>s_axis_vect1_tvalid,
    m_axis_res_tdata => m_axis_matrix_tdata(191 downto 128),
    m_axis_res_tready =>m_axis_matrix_tready,
    m_axis_res_tvalid =>matrix_mult_ready2
);

mult3:AXI4_Multiplier port map
(
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_a_tdata =>s_axis_vect0_tdata(127 downto 64),
    s_axis_b_tdata =>s_axis_vect1_tdata(127 downto 64),
    s_axis_a_tready =>vect0_mult_ready3,
    s_axis_b_tready =>vect1_mult_ready3,
    s_axis_a_tvalid =>s_axis_vect0_tvalid,
    s_axis_b_tvalid =>s_axis_vect1_tvalid,
    m_axis_res_tdata => m_axis_matrix_tdata(255 downto 192),
    m_axis_res_tready =>m_axis_matrix_tready,
    m_axis_res_tvalid =>matrix_mult_ready3
);

m_axis_matrix_tvalid <= matrix_mult_ready0 and matrix_mult_ready1 and matrix_mult_ready2 and matrix_mult_ready3;

end Behavioral;
