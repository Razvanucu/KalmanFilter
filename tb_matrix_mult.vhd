library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_matrix_mult is
--  Port ( );
end tb_matrix_mult;

architecture Behavioral of tb_matrix_mult is

component AXI4_Mult_Matrix_Matrix is
  Port ( 
    aclk: in std_logic;
    aresetn: in std_logic;
    s_axis_matrix0_tdata: in std_logic_vector(255 downto 0);
    s_axis_matrix1_tdata: in std_logic_vector(255 downto 0);
    s_axis_matrix0_tready: out std_logic;
    s_axis_matrix1_tready: out std_logic;
    s_axis_matrix0_tvalid: in std_logic;
    s_axis_matrix1_tvalid: in std_logic;
    m_axis_matrix_tdata: out std_logic_vector(255 downto 0);
    m_axis_matrix_tready: in std_logic; 
    m_axis_matrix_tvalid: out std_logic
  );
end component AXI4_Mult_Matrix_Matrix;

 signal   aclk:  std_logic:='0';
 signal   aresetn:  std_logic:='0';
 signal   s_axis_matrix0_tdata:  std_logic_vector(255 downto 0):=(others =>'0');
 signal   s_axis_matrix1_tdata:  std_logic_vector(255 downto 0):=(others =>'0');
 signal   s_axis_matrix0_tready:  std_logic:='0';
 signal   s_axis_matrix1_tready:  std_logic:='0';
 signal   s_axis_matrix0_tvalid:  std_logic:='0';
 signal   s_axis_matrix1_tvalid:  std_logic:='0';
 signal   m_axis_matrix_tdata:  std_logic_vector(255 downto 0):=(others =>'0');
 signal   m_axis_matrix_tready:  std_logic:='0'; 
 signal   m_axis_matrix_tvalid:  std_logic:='0';
 
 signal a,b,c,d : std_logic_vector(63 downto 0):=(others =>'0');  

begin

aclk <= not aclk after 5ns;

add:AXI4_Mult_Matrix_Matrix port map
(
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_matrix0_tdata =>s_axis_matrix0_tdata,
    s_axis_matrix1_tdata =>s_axis_matrix1_tdata,
    s_axis_matrix0_tready =>s_axis_matrix0_tready,
    s_axis_matrix1_tready =>s_axis_matrix1_tready,
    s_axis_matrix0_tvalid =>s_axis_matrix0_tvalid,
    s_axis_matrix1_tvalid =>s_axis_matrix1_tvalid,
    m_axis_matrix_tdata =>m_axis_matrix_tdata,
    m_axis_matrix_tready =>m_axis_matrix_tready,
    m_axis_matrix_tvalid =>m_axis_matrix_tvalid
);

s_axis_matrix0_tvalid <='1';
s_axis_matrix1_tvalid <='1';

m_axis_matrix_tready <='1';

a<= m_axis_matrix_tdata(63 downto 0);
b<= m_axis_matrix_tdata(127 downto 64);
c<= m_axis_matrix_tdata(191 downto 128);
d<= m_axis_matrix_tdata(255 downto 192);

process
begin

s_axis_matrix0_tdata(63 downto 0) <=x"0000000000000001";
s_axis_matrix0_tdata(127 downto 64) <=x"0000000000000001";
s_axis_matrix0_tdata(191 downto 128) <=x"0000000000000001";
s_axis_matrix0_tdata(255 downto 192) <=x"0000000000000001";

s_axis_matrix1_tdata(63 downto 0) <=x"0000000000000001";
s_axis_matrix1_tdata(127 downto 64) <=x"0000000000000001";
s_axis_matrix1_tdata(191 downto 128) <=x"0000000000000001";
s_axis_matrix1_tdata(255 downto 192) <=x"0000000000000001";

wait for 20ns;
s_axis_matrix0_tdata(63 downto 0) <=x"0000000000000001";
s_axis_matrix0_tdata(127 downto 64) <=x"0000000000000000";
s_axis_matrix0_tdata(191 downto 128) <=x"0000000000000000";
s_axis_matrix0_tdata(255 downto 192) <=x"0000000000000001";

s_axis_matrix1_tdata(63 downto 0) <=x"0000000000000002";
s_axis_matrix1_tdata(127 downto 64) <=x"0000000000000002";
s_axis_matrix1_tdata(191 downto 128) <=x"0000000000000002";
s_axis_matrix1_tdata(255 downto 192) <=x"0000000000000002";
wait for 20ns;

end process;

end Behavioral;
