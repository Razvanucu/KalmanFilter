library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity AXI4_Mult_Vect_Vect is
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
end AXI4_Mult_Vect_Vect;

architecture Behavioral of AXI4_Mult_Vect_Vect is

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

signal vect0_mult_ready0,vect0_mult_ready1 : std_logic:='0';
signal vect1_mult_ready0,vect1_mult_ready1 : std_logic:='0';

signal mult_vect_res0,mult_vect_res1: std_logic_vector(63 downto 0):= (others => '0');
signal mult_vect_tvalid0,mult_vect_tvalid1 : std_logic:='0';

signal  vect_add_ready0,vect_add_ready1 : std_logic:='0';

begin

s_axis_vect0_tready <=  vect0_mult_ready0 and vect0_mult_ready1;
s_axis_vect1_tready <=  vect1_mult_ready0 and vect1_mult_ready1;

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
    m_axis_res_tdata =>mult_vect_res0,
    m_axis_res_tready =>vect_add_ready0,
    m_axis_res_tvalid =>mult_vect_tvalid0
);

mult1:AXI4_Multiplier port map
(
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_a_tdata =>s_axis_vect0_tdata(127 downto 64),
    s_axis_b_tdata =>s_axis_vect1_tdata(127 downto 64),
    s_axis_a_tready =>vect0_mult_ready1,
    s_axis_b_tready =>vect1_mult_ready1,
    s_axis_a_tvalid =>s_axis_vect0_tvalid,
    s_axis_b_tvalid =>s_axis_vect1_tvalid,
    m_axis_res_tdata =>mult_vect_res1,
    m_axis_res_tready =>vect_add_ready1,
    m_axis_res_tvalid =>mult_vect_tvalid1
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
    m_axis_res_tdata =>m_axis_res_tdata,
    m_axis_res_tready =>m_axis_res_tready,
    m_axis_res_tvalid =>m_axis_res_tvalid

);

end Behavioral;
