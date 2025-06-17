library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity AXI4_FIFO_Matrix_With_InitialValue is
  PORT (
    s_axis_aresetn : IN STD_LOGIC;
    s_axis_aclk : IN STD_LOGIC;
    s_axis_tvalid : IN STD_LOGIC;
    s_axis_tready : OUT STD_LOGIC;
    s_axis_tdata : IN STD_LOGIC_VECTOR(255 DOWNTO 0);
    m_axis_tvalid : OUT STD_LOGIC;
    m_axis_tready : IN STD_LOGIC;
    m_axis_tdata : OUT STD_LOGIC_VECTOR(255 DOWNTO 0)
  );
end AXI4_FIFO_Matrix_With_InitialValue;

architecture Behavioral of AXI4_FIFO_Matrix_With_InitialValue is

COMPONENT AXI4_Matrix_FIFO
  PORT (
    s_axis_aresetn : IN STD_LOGIC;
    s_axis_aclk : IN STD_LOGIC;
    s_axis_tvalid : IN STD_LOGIC;
    s_axis_tready : OUT STD_LOGIC;
    s_axis_tdata : IN STD_LOGIC_VECTOR(255 DOWNTO 0);
    m_axis_tvalid : OUT STD_LOGIC;
    m_axis_tready : IN STD_LOGIC;
    m_axis_tdata : OUT STD_LOGIC_VECTOR(255 DOWNTO 0)
  );
END COMPONENT;

signal sig_axis_tvalid,sig_axis_tready :  STD_LOGIC:='0';
signal sig_axis_tdata :  STD_LOGIC_VECTOR(255 DOWNTO 0):=(others=>'0');

begin

fifo : AXI4_Matrix_FIFO PORT MAP 
(
    s_axis_aresetn => s_axis_aresetn,
    s_axis_aclk => s_axis_aclk,
    s_axis_tvalid => sig_axis_tvalid,
    s_axis_tready => sig_axis_tready,
    s_axis_tdata => sig_axis_tdata,
    m_axis_tvalid => m_axis_tvalid,
    m_axis_tready => m_axis_tready,
    m_axis_tdata => m_axis_tdata
  );
  
s_axis_tready<=sig_axis_tready;

process(s_axis_aclk)
variable first:std_logic:='0';
begin
    if s_axis_aclk'event and s_axis_aclk='1' then
        if s_axis_aresetn='0' then
            first:='0';
            sig_axis_tvalid<='0';
            sig_axis_tdata<=(others =>'0');
        elsif s_axis_aresetn='1' and first='0' and sig_axis_tready='1' then
            sig_axis_tvalid<='1';
            sig_axis_tdata<=x"0000000000000001_0000000000000001_0000000000000001_0000000000000001";
            first:='1'; 
        elsif first='1' then
            sig_axis_tvalid<=s_axis_tvalid;
            sig_axis_tdata <=s_axis_tdata;    
        end if;
    end if;
end process;

end Behavioral;
