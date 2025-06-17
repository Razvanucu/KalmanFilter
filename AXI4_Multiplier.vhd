library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity AXI4_Multiplier is
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
end AXI4_Multiplier;

architecture Behavioral of AXI4_Multiplier is

type state_type is (READ,WRITE);
signal state: state_type := READ;

signal result : STD_LOGIC_VECTOR (127 downto 0) := (others => '0');
signal internal_ready, external_ready, inputs_valid : STD_LOGIC := '0';

begin

s_axis_a_tready <= external_ready;
s_axis_b_tready <= external_ready;

internal_ready <= '1' when state = READ else '0';
inputs_valid <= s_axis_a_tvalid and s_axis_b_tvalid;
external_ready <= internal_ready and inputs_valid;

m_axis_res_tvalid <= '1' when state = WRITE else '0';
m_axis_res_tdata <= result(63 downto 0);

process(aclk)
begin
    if aclk'event and aclk='1' then
          case state is
            when READ=>
                if external_ready = '1' and inputs_valid='1' then
                    result <=std_logic_vector(signed(s_axis_a_tdata) * signed(s_axis_b_tdata));   
                    state <= WRITE;
                end if;
            when WRITE=>
                if m_axis_res_tready = '1' then
                    state<=READ;
                end if;
           end case;
     end if;
end process;

end Behavioral;