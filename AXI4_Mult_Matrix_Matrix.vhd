library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity AXI4_Mult_Matrix_Matrix is
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
end AXI4_Mult_Matrix_Matrix;

architecture Behavioral of AXI4_Mult_Matrix_Matrix is

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

--mult matrix
signal vect_mult_ready0,vect_mult_ready1:std_logic:='0';
signal vect_mult_ready2,vect_mult_ready3:std_logic:='0';

signal matrix0_mult_ready0,matrix0_mult_ready1:std_logic:='0';
signal matrix0_mult_ready2,matrix0_mult_ready3:std_logic:='0';
signal matrix0_mult_ready4,matrix0_mult_ready5:std_logic:='0';
signal matrix0_mult_ready6,matrix0_mult_ready7:std_logic:='0';

signal matrix1_mult_ready0,matrix1_mult_ready1:std_logic:='0';
signal matrix1_mult_ready2,matrix1_mult_ready3:std_logic:='0';
signal matrix1_mult_ready4,matrix1_mult_ready5:std_logic:='0';
signal matrix1_mult_ready6,matrix1_mult_ready7:std_logic:='0';

signal mult_matrix_res0,mult_matrix_res1:std_logic_vector(63 downto 0):= (others => '0');
signal mult_matrix_res2,mult_matrix_res3:std_logic_vector(63 downto 0):= (others => '0');
signal mult_matrix_res4,mult_matrix_res5:std_logic_vector(63 downto 0):= (others => '0');
signal mult_matrix_res6,mult_matrix_res7:std_logic_vector(63 downto 0):= (others => '0');

signal mult_matrix_tvalid0,mult_matrix_tvalid1:std_logic:='0';
signal mult_matrix_tvalid2,mult_matrix_tvalid3:std_logic:='0';
signal mult_matrix_tvalid4,mult_matrix_tvalid5:std_logic:='0';
signal mult_matrix_tvalid6,mult_matrix_tvalid7:std_logic:='0';

--add results of multiply
signal matrix_add_ready0,matrix_add_ready1:std_logic:='0';
signal matrix_add_ready2,matrix_add_ready3:std_logic:='0';
signal matrix_add_ready4,matrix_add_ready5:std_logic:='0';
signal matrix_add_ready6,matrix_add_ready7:std_logic:='0';


signal add_matrix_tvalid0,add_matrix_tvalid1:std_logic:='0';
signal add_matrix_tvalid2,add_matrix_tvalid3:std_logic:='0';


begin

s_axis_matrix0_tready <= matrix0_mult_ready0 and matrix0_mult_ready1 and
                         matrix0_mult_ready2 and matrix0_mult_ready3 and
                         matrix0_mult_ready4 and matrix0_mult_ready6 and
                         matrix0_mult_ready6 and matrix0_mult_ready7;
                         

s_axis_matrix1_tready <= matrix1_mult_ready0 and matrix1_mult_ready1 and
                         matrix1_mult_ready2 and matrix1_mult_ready3 and
                         matrix1_mult_ready4 and matrix1_mult_ready6 and
                         matrix1_mult_ready6 and matrix1_mult_ready7;
                                    
mult0:AXI4_Multiplier port map
(
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_a_tdata =>s_axis_matrix0_tdata(63 downto 0),
    s_axis_b_tdata =>s_axis_matrix1_tdata(63 downto 0),
    s_axis_a_tready =>matrix0_mult_ready0,
    s_axis_b_tready =>matrix1_mult_ready0,
    s_axis_a_tvalid =>s_axis_matrix0_tvalid,
    s_axis_b_tvalid =>s_axis_matrix1_tvalid,
    m_axis_res_tdata =>mult_matrix_res0,
    m_axis_res_tready =>matrix_add_ready0,
    m_axis_res_tvalid =>mult_matrix_tvalid0
);

mult1:AXI4_Multiplier port map
(
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_a_tdata =>s_axis_matrix0_tdata(127 downto 64),
    s_axis_b_tdata =>s_axis_matrix1_tdata(191 downto 128),
    s_axis_a_tready =>matrix0_mult_ready1,
    s_axis_b_tready =>matrix1_mult_ready1,
    s_axis_a_tvalid =>s_axis_matrix0_tvalid,
    s_axis_b_tvalid =>s_axis_matrix1_tvalid,
    m_axis_res_tdata =>mult_matrix_res1,
    m_axis_res_tready =>matrix_add_ready1,
    m_axis_res_tvalid =>mult_matrix_tvalid1
);


mult2:AXI4_Multiplier port map
(
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_a_tdata =>s_axis_matrix0_tdata(63 downto 0),
    s_axis_b_tdata =>s_axis_matrix1_tdata(127 downto 64),
    s_axis_a_tready =>matrix0_mult_ready2,
    s_axis_b_tready =>matrix1_mult_ready2,
    s_axis_a_tvalid =>s_axis_matrix0_tvalid,
    s_axis_b_tvalid =>s_axis_matrix1_tvalid,
    m_axis_res_tdata =>mult_matrix_res2,
    m_axis_res_tready =>matrix_add_ready2,
    m_axis_res_tvalid =>mult_matrix_tvalid2
);


mult3:AXI4_Multiplier port map
(
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_a_tdata =>s_axis_matrix0_tdata(127 downto 64),
    s_axis_b_tdata =>s_axis_matrix1_tdata(255 downto 192),
    s_axis_a_tready =>matrix0_mult_ready3,
    s_axis_b_tready =>matrix1_mult_ready3,
    s_axis_a_tvalid =>s_axis_matrix0_tvalid,
    s_axis_b_tvalid =>s_axis_matrix1_tvalid,
    m_axis_res_tdata => mult_matrix_res3,
    m_axis_res_tready =>matrix_add_ready3,
    m_axis_res_tvalid =>mult_matrix_tvalid3
);


mult4:AXI4_Multiplier port map
(
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_a_tdata =>s_axis_matrix0_tdata(191 downto 128),
    s_axis_b_tdata =>s_axis_matrix1_tdata(63 downto 0),
    s_axis_a_tready =>matrix0_mult_ready4,
    s_axis_b_tready =>matrix1_mult_ready4,
    s_axis_a_tvalid =>s_axis_matrix0_tvalid,
    s_axis_b_tvalid =>s_axis_matrix1_tvalid,
    m_axis_res_tdata => mult_matrix_res4,
    m_axis_res_tready =>matrix_add_ready4,
    m_axis_res_tvalid =>mult_matrix_tvalid4
);


mult5:AXI4_Multiplier port map
(
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_a_tdata =>s_axis_matrix0_tdata(255 downto 192),
    s_axis_b_tdata =>s_axis_matrix1_tdata(191 downto 128),
    s_axis_a_tready =>matrix0_mult_ready5,
    s_axis_b_tready =>matrix1_mult_ready5,
    s_axis_a_tvalid =>s_axis_matrix0_tvalid,
    s_axis_b_tvalid =>s_axis_matrix1_tvalid,
    m_axis_res_tdata => mult_matrix_res5,
    m_axis_res_tready =>matrix_add_ready5,
    m_axis_res_tvalid =>mult_matrix_tvalid5
);

mult6:AXI4_Multiplier port map
(
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_a_tdata =>s_axis_matrix0_tdata(191 downto 128),
    s_axis_b_tdata =>s_axis_matrix1_tdata(127 downto 64),
    s_axis_a_tready =>matrix0_mult_ready6,
    s_axis_b_tready =>matrix1_mult_ready6,
    s_axis_a_tvalid =>s_axis_matrix0_tvalid,
    s_axis_b_tvalid =>s_axis_matrix1_tvalid,
    m_axis_res_tdata => mult_matrix_res6,
    m_axis_res_tready =>matrix_add_ready6,
    m_axis_res_tvalid =>mult_matrix_tvalid6
);

mult7:AXI4_Multiplier port map
(
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_a_tdata =>s_axis_matrix0_tdata(255 downto 192),
    s_axis_b_tdata =>s_axis_matrix1_tdata(255 downto 192),
    s_axis_a_tready =>matrix0_mult_ready7,
    s_axis_b_tready =>matrix1_mult_ready7,
    s_axis_a_tvalid =>s_axis_matrix0_tvalid,
    s_axis_b_tvalid =>s_axis_matrix1_tvalid,
    m_axis_res_tdata => mult_matrix_res7,
    m_axis_res_tready =>matrix_add_ready7,
    m_axis_res_tvalid =>mult_matrix_tvalid7
);


add0: AXI4_Adder_Subtracter port map
(
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_a_tdata =>mult_matrix_res0,
    s_axis_b_tdata =>mult_matrix_res1,
    s_axis_op_tdata =>'0',
    s_axis_a_tready =>matrix_add_ready0,
    s_axis_b_tready =>matrix_add_ready1,
    --s_axis_op_tready =>,
    s_axis_a_tvalid =>mult_matrix_tvalid0,
    s_axis_b_tvalid =>mult_matrix_tvalid1,
    s_axis_op_tvalid =>'1',
    m_axis_res_tdata =>m_axis_matrix_tdata(63 downto 0),
    m_axis_res_tready =>m_axis_matrix_tready,
    m_axis_res_tvalid =>add_matrix_tvalid0

);


add1: AXI4_Adder_Subtracter port map
(
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_a_tdata =>mult_matrix_res2,
    s_axis_b_tdata =>mult_matrix_res3,
    s_axis_op_tdata =>'0',
    s_axis_a_tready =>matrix_add_ready2,
    s_axis_b_tready =>matrix_add_ready3,
    --s_axis_op_tready =>,
    s_axis_a_tvalid =>mult_matrix_tvalid2,
    s_axis_b_tvalid =>mult_matrix_tvalid3,
    s_axis_op_tvalid =>'1',
    m_axis_res_tdata => m_axis_matrix_tdata(127 downto 64),
    m_axis_res_tready =>m_axis_matrix_tready,
    m_axis_res_tvalid =>add_matrix_tvalid1

);

add2: AXI4_Adder_Subtracter port map
(
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_a_tdata =>mult_matrix_res4,
    s_axis_b_tdata =>mult_matrix_res5,
    s_axis_op_tdata =>'0',
    s_axis_a_tready =>matrix_add_ready4,
    s_axis_b_tready =>matrix_add_ready5,
    --s_axis_op_tready =>,
    s_axis_a_tvalid =>mult_matrix_tvalid2,
    s_axis_b_tvalid =>mult_matrix_tvalid3,
    s_axis_op_tvalid =>'1',
    m_axis_res_tdata => m_axis_matrix_tdata(191 downto 128),
    m_axis_res_tready =>m_axis_matrix_tready,
    m_axis_res_tvalid =>add_matrix_tvalid2

);

add3: AXI4_Adder_Subtracter port map
(
    aclk =>aclk,
    aresetn =>aresetn,
    s_axis_a_tdata =>mult_matrix_res6,
    s_axis_b_tdata =>mult_matrix_res7,
    s_axis_op_tdata =>'0',
    s_axis_a_tready =>matrix_add_ready6,
    s_axis_b_tready =>matrix_add_ready7,
    --s_axis_op_tready =>,
    s_axis_a_tvalid =>mult_matrix_tvalid2,
    s_axis_b_tvalid =>mult_matrix_tvalid3,
    s_axis_op_tvalid =>'1',
    m_axis_res_tdata => m_axis_matrix_tdata(255 downto 192),
    m_axis_res_tready =>m_axis_matrix_tready,
    m_axis_res_tvalid =>add_matrix_tvalid3

);

m_axis_matrix_tvalid <= add_matrix_tvalid0 and add_matrix_tvalid1 and add_matrix_tvalid2 and add_matrix_tvalid3;

end Behavioral;
