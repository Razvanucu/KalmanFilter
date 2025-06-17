library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_signed.ALL;
use IEEE.STD_LOGIC_arith.ALL;

entity tb_multi is
--  Port ( );
end tb_multi;

architecture Behavioral of tb_multi is

signal a,b,c:std_logic_vector(31 downto 0):=(others=>'0');
begin

c<= a * b;
process
begin
    a<=x"00000001";
    b<=x"00000001";
    wait for 20ns;

        a<=x"00000002";
    b<=x"00000001";
    wait for 20ns;
    
        a<=x"00000003";
    b<=x"00000003";
    wait for 20ns;
    
        a<=x"00000004";
    b<=x"00000004";
    wait for 20ns;

end process;

end Behavioral;
