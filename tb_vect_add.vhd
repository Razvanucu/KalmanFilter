library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_vect_add is
--  Port ( );
end tb_vect_add;

architecture Behavioral of tb_vect_add is

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

signal    aclk:  std_logic :='0';
signal    aresetn:  std_logic:='0';
signal    s_axis_vect0_tdata:  std_logic_vector(127 downto 0):=(others =>'0');
signal    s_axis_vect1_tdata:  std_logic_vector(127 downto 0):=(others =>'0');
signal    s_axis_op_tdata:  std_logic:='0';
signal    s_axis_vect0_tready:  std_logic:='0';
signal    s_axis_vect1_tready:  std_logic:='0';
signal    s_axis_op_tready:  std_logic:='0';
signal    s_axis_vect0_tvalid:  std_logic:='0';
signal    s_axis_vect1_tvalid:  std_logic:='0';
signal    s_axis_op_tvalid:  std_logic:='0';
signal    m_axis_vect_tdata:  std_logic_vector(127 downto 0):=(others =>'0');
signal    m_axis_vect_tready:  std_logic:='0'; 
signal    m_axis_vect_tvalid:  std_logic:='0';

signal a,b : std_logic_vector (63  downto 0):=(others =>'0');
begin

aclk <= not aclk after 5ns;

add:AXI4_Vect_Add_Subtract port map
(
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_vect0_tdata =>s_axis_vect0_tdata,
    s_axis_vect1_tdata =>s_axis_vect1_tdata,
    s_axis_op_tdata =>s_axis_op_tdata,
    s_axis_vect0_tready =>s_axis_vect0_tready,
    s_axis_vect1_tready =>s_axis_vect1_tready,
    s_axis_op_tready =>s_axis_op_tready,
    s_axis_vect0_tvalid =>s_axis_vect0_tvalid,
    s_axis_vect1_tvalid =>s_axis_vect1_tvalid,
    s_axis_op_tvalid =>s_axis_op_tvalid,
    m_axis_vect_tdata =>m_axis_vect_tdata,
    m_axis_vect_tready =>m_axis_vect_tready,
    m_axis_vect_tvalid =>m_axis_vect_tvalid
);

s_axis_vect0_tvalid <='1';
s_axis_vect1_tvalid <='1';
s_axis_op_tvalid <='1';
m_axis_vect_tready <='1';

a <= m_axis_vect_tdata(63 downto 0);
b <= m_axis_vect_tdata(127 downto 64);

process 
begin

s_axis_vect0_tdata(63 downto 0)<=x"0000000000000001";
s_axis_vect0_tdata(127 downto 64)<=x"0000000000000001";

s_axis_vect1_tdata(63 downto 0)<=x"0000000000000001";
s_axis_vect1_tdata(127 downto 64)<=x"0000000000000001";

s_axis_op_tdata<='0';

wait for 20ns;

s_axis_vect0_tdata(63 downto 0)<=x"0000000000000001";
s_axis_vect0_tdata(127 downto 64)<=x"0000000000000001";

s_axis_vect1_tdata(63 downto 0)<=x"0000000000000001";
s_axis_vect1_tdata(127 downto 64)<=x"0000000000000001";

s_axis_op_tdata<='1';

wait for 20ns;

end process;

end Behavioral;
