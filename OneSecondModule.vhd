library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity OneSecondModule is
  Port ( 
    aclk : in std_logic;
    aresetn : in std_logic;
    s_axis_data_tdata :in std_logic_vector(127 downto 0);
    s_axis_data_tready:out std_logic;
    s_axis_data_tvalid:in std_logic;
    m_axis_data_tdata :out std_logic_vector(127 downto 0);
    m_axis_data_tready:in std_logic;
    m_axis_data_tvalid:out std_logic
  );
end OneSecondModule;

architecture Behavioral of OneSecondModule is

type state_type is (READ, WRITE);
signal state :state_type :=READ;

signal cnt: integer range 0 to 100000000 :=0;

signal result : STD_LOGIC_VECTOR (127 downto 0) := (others => '0');
signal internal_ready, external_ready : STD_LOGIC := '0';

begin

s_axis_data_tready <= external_ready;

internal_ready <= '1' when state = READ else '0';
external_ready <= internal_ready and s_axis_data_tvalid;

m_axis_data_tvalid <= '1' when state = WRITE else '0';
m_axis_data_tdata <= result(127 downto 0);

process(aclk)
begin
    if aresetn ='0' then
        state <= READ;
        result <= (others => '0');
        cnt<=0;
    elsif aclk'event and aclk='1' then
          case state is
            when READ=>
                if external_ready = '1' and s_axis_data_tvalid='1' then
                   if cnt=100000000 then 
                    result <= s_axis_data_tdata;
                    state <= WRITE;
                    cnt<=0;
                   else
                    cnt<= cnt + 1;
                   end if;      
                end if;
            when WRITE=>
                if m_axis_data_tready = '1' then
                    state<=READ;
                end if;
           end case;
     end if;
end process;


end Behavioral;
