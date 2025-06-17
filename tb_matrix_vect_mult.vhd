library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_matrix_vect_mult is
--  Port ( );
end tb_matrix_vect_mult;

architecture Behavioral of tb_matrix_vect_mult is

component AXI4_Mult_Matrix_ColumnVector is
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
end component AXI4_Mult_Matrix_ColumnVector;

 signal   aclk:  std_logic:='0';
 signal   aresetn:  std_logic:='0';
 signal   s_axis_vect_tdata:  std_logic_vector(127 downto 0):=(others =>'0');
 signal   s_axis_matrix_tdata:  std_logic_vector(255 downto 0):=(others =>'0');
 signal   s_axis_vect_tready:  std_logic:='0';
 signal   s_axis_matrix_tready:  std_logic:='0';
 signal   s_axis_vect_tvalid:  std_logic:='0';
 signal   s_axis_matrix_tvalid:  std_logic:='0';
 signal   m_axis_vect_tdata:  std_logic_vector(127 downto 0):=(others =>'0');
 signal   m_axis_vect_tready:  std_logic:='0'; 
 signal   m_axis_vect_tvalid:  std_logic:='0';
 
 signal a,b : std_logic_vector(63 downto 0):=(others =>'0');  
 
begin

aclk <= not aclk after 5ns;

add:AXI4_Mult_Matrix_ColumnVector port map
(
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_vect_tdata =>s_axis_vect_tdata,
    s_axis_matrix_tdata =>s_axis_matrix_tdata,
    s_axis_vect_tready =>s_axis_vect_tready,
    s_axis_matrix_tready =>s_axis_matrix_tready,
    s_axis_vect_tvalid =>s_axis_vect_tvalid,
    s_axis_matrix_tvalid =>s_axis_matrix_tvalid,
    m_axis_vect_tdata =>m_axis_vect_tdata,
    m_axis_vect_tready =>m_axis_vect_tready,
    m_axis_vect_tvalid =>m_axis_vect_tvalid
);

s_axis_matrix_tvalid <='1';
s_axis_vect_tvalid <='1';

m_axis_vect_tready <='1';

a<= m_axis_vect_tdata(63 downto 0);
b<= m_axis_vect_tdata(127 downto 64);

process
begin

s_axis_matrix_tdata(63 downto 0) <=x"0000000000000001";
s_axis_matrix_tdata(127 downto 64) <=x"0000000000000001";
s_axis_matrix_tdata(191 downto 128) <=x"0000000000000001";
s_axis_matrix_tdata(255 downto 192) <=x"0000000000000001";

s_axis_vect_tdata(63 downto 0)<=x"0000000000000001";
s_axis_vect_tdata(127 downto 64)<=x"0000000000000001";

wait for 20ns;

s_axis_matrix_tdata(63 downto 0) <=x"000000000000000F";
s_axis_matrix_tdata(127 downto 64) <=x"000000000000000E";
s_axis_matrix_tdata(191 downto 128) <=x"000000000000000D";
s_axis_matrix_tdata(255 downto 192) <=x"000000000000000C";

s_axis_vect_tdata(63 downto 0)<=x"0000000000000000";
s_axis_vect_tdata(127 downto 64)<=x"0000000000000000";

wait for 20ns;

s_axis_matrix_tdata(63 downto 0) <=x"0000000000000001";
s_axis_matrix_tdata(127 downto 64) <=x"0000000000000000";
s_axis_matrix_tdata(191 downto 128) <=x"0000000000000000";
s_axis_matrix_tdata(255 downto 192) <=x"0000000000000001";

s_axis_vect_tdata(63 downto 0)<=x"0000000000000001";
s_axis_vect_tdata(127 downto 64)<=x"0000000000000001";

wait for 20ns;

end process;

end Behavioral;
