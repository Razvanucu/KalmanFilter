library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_vect_mult is
--  Port ( );
end tb_vect_mult;

architecture Behavioral of tb_vect_mult is

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

signal    aclk:  std_logic :='0';
signal    aresetn:  std_logic:='0';
signal    s_axis_vect0_tdata:  std_logic_vector(127 downto 0):=(others =>'0');
signal    s_axis_vect1_tdata:  std_logic_vector(127 downto 0):=(others =>'0');
signal    s_axis_vect0_tready:  std_logic:='0';
signal    s_axis_vect1_tready:  std_logic:='0';
signal    s_axis_vect0_tvalid:  std_logic:='0';
signal    s_axis_vect1_tvalid:  std_logic:='0';
signal    m_axis_res_tdata:  std_logic_vector(63 downto 0):=(others =>'0');
signal    m_axis_res_tready:  std_logic:='0'; 
signal    m_axis_res_tvalid:  std_logic:='0';

begin

aclk <= not aclk after 5ns;

add:AXI4_Mult_Vect_Vect port map
(
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_vect0_tdata =>s_axis_vect0_tdata,
    s_axis_vect1_tdata =>s_axis_vect1_tdata,
    s_axis_vect0_tready =>s_axis_vect0_tready,
    s_axis_vect1_tready =>s_axis_vect1_tready,
    s_axis_vect0_tvalid =>s_axis_vect0_tvalid,
    s_axis_vect1_tvalid =>s_axis_vect1_tvalid,
    m_axis_res_tdata =>m_axis_res_tdata,
    m_axis_res_tready =>m_axis_res_tready,
    m_axis_res_tvalid =>m_axis_res_tvalid
);

s_axis_vect0_tvalid <='1';
s_axis_vect1_tvalid <='1';
m_axis_res_tready <='1';

process
begin

s_axis_vect0_tdata(63 downto 0)<=x"0000000000000001";
s_axis_vect0_tdata(127 downto 64)<=x"0000000000000001";

s_axis_vect1_tdata(63 downto 0)<=x"0000000000000001";
s_axis_vect1_tdata(127 downto 64)<=x"0000000000000001";

wait for 20ns;

s_axis_vect0_tdata(63 downto 0)<=x"0000000000000002";
s_axis_vect0_tdata(127 downto 64)<=x"0000000000000002";

s_axis_vect1_tdata(63 downto 0)<=x"0000000000000003";
s_axis_vect1_tdata(127 downto 64)<=x"0000000000000004";

wait for 20ns;

s_axis_vect0_tdata(63 downto 0)<=x"0000000000000005";
s_axis_vect0_tdata(127 downto 64)<=x"0000000000000002";

s_axis_vect1_tdata(63 downto 0)<=x"ffffffffffffffff";
s_axis_vect1_tdata(127 downto 64)<=x"0000000000000002";

wait for 20ns;


end process;


end Behavioral;
