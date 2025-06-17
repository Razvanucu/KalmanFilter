library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_intial_value_fifo_vector is
--  Port ( );
end tb_intial_value_fifo_vector;

architecture Behavioral of tb_intial_value_fifo_vector is

component AXI4_FIFO_Vect_With_InitialValue is
  PORT (
    s_axis_aresetn : IN STD_LOGIC;
    s_axis_aclk : IN STD_LOGIC;
    s_axis_tvalid : IN STD_LOGIC;
    s_axis_tready : OUT STD_LOGIC;
    s_axis_tdata : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
    m_axis_tvalid : OUT STD_LOGIC;
    m_axis_tready : IN STD_LOGIC;
    m_axis_tdata : OUT STD_LOGIC_VECTOR(127 DOWNTO 0)
  );
end component AXI4_FIFO_Vect_With_InitialValue;

signal s_axis_aresetn :  STD_LOGIC:='0';
signal s_axis_aclk :  STD_LOGIC:='0';
signal s_axis_tvalid :  STD_LOGIC:='0';
signal s_axis_tready :  STD_LOGIC:='0';
signal s_axis_tdata :  STD_LOGIC_VECTOR(127 DOWNTO 0):=(others=>'0');
signal m_axis_tvalid :  STD_LOGIC:='0';
signal m_axis_tready :  STD_LOGIC:='0';
signal m_axis_tdata :  STD_LOGIC_VECTOR(127 DOWNTO 0):=(others=>'0');

signal x0,x1: STD_LOGIC_VECTOR(63 DOWNTO 0):=(others=>'0');   

begin

s_axis_aclk <= not s_axis_aclk after 5ns;
s_axis_aresetn <= '0','1' after 25ns;

s_axis_tdata <=x"0000000000000002_0000000000000003";
s_axis_tvalid <='1';
m_axis_tready<='1';

x0<=m_axis_tdata(63 DOWNTO 0);
x1 <= m_axis_tdata(127 DOWNTO 64);

fifo : AXI4_FIFO_Vect_With_InitialValue PORT MAP 
(
    s_axis_aresetn => s_axis_aresetn,
    s_axis_aclk => s_axis_aclk,
    s_axis_tvalid => s_axis_tvalid,
    s_axis_tready => s_axis_tready,
    s_axis_tdata => s_axis_tdata,
    m_axis_tvalid => m_axis_tvalid,
    m_axis_tready => m_axis_tready,
    m_axis_tdata => m_axis_tdata
  );

end Behavioral;
