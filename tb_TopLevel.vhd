library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_TopLevel is
--  Port ( );
end tb_TopLevel;

architecture Behavioral of tb_TopLevel is

component TopLevel is
   Port (
        clk: in std_logic;
        sw : in std_logic_vector(15 downto 0);
        btn : in std_logic_vector(4 downto 0);
        an: out std_logic_vector(3 downto 0);
        cat: out std_logic_vector(6 downto 0);
        JB1: in std_logic;
        JB2: out std_logic
    );
end component TopLevel;

signal clk: std_logic:='0';
signal JB1,JB2: std_logic:='1';

signal sw: std_logic_vector(15 downto 0) := (others => '0');
signal btn: std_logic_vector(4 downto 0) := (others => '0');
signal an: std_logic_vector(3 downto 0) := (others => '0');
signal cat: std_logic_vector(6 downto 0) := (others => '0');

constant BIT_PERIOD   : time := 54*4*16 ns;

begin

clk <= not clk after 5ns;
btn(0) <= '1','0' after 25ns;

TopLeveltb:TopLevel port map(
    clk => clk,
    sw => sw,
    btn => btn,
    an => an,
    cat => cat,
    JB1 => JB1,
    JB2 => JB2
);

process
begin

wait until falling_edge(btn(0));

   --Start0
    JB1 <= '0';
    wait for BIT_PERIOD;
    
    --Data
    JB1 <= '1';
    wait for BIT_PERIOD;
    JB1 <= '1';
    wait for BIT_PERIOD;
    JB1 <= '1';
    wait for BIT_PERIOD;
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0'; -- MSB
    wait for BIT_PERIOD;

    --Stop
    JB1 <= '1';
    wait for BIT_PERIOD;
    
    
    --Start1
    JB1 <= '0';
    wait for BIT_PERIOD;
    
    --Data
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0'; -- MSB
    wait for BIT_PERIOD;

    --Stop
    JB1 <= '1';
    wait for BIT_PERIOD;
    
    
    --Start2
    JB1 <= '0';
    wait for BIT_PERIOD;
    
    --Data
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0'; -- MSB
    wait for BIT_PERIOD;

    --Stop
    JB1 <= '1';
    wait for BIT_PERIOD;
    
    
        --Start3
    JB1 <= '0';
    wait for BIT_PERIOD;
    
    --Data
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0'; -- MSB
    wait for BIT_PERIOD;

    --Stop
    JB1 <= '1';
    wait for BIT_PERIOD;
    
    
        --Start4
    JB1 <= '0';
    wait for BIT_PERIOD;
    
    --Data
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0'; -- MSB
    wait for BIT_PERIOD;

    --Stop
    JB1 <= '1';
    wait for BIT_PERIOD;
    
    
        --Start5
    JB1 <= '0';
    wait for BIT_PERIOD;
    
    --Data
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0'; -- MSB
    wait for BIT_PERIOD;

    --Stop
    JB1 <= '1';
    wait for BIT_PERIOD;
    
    
        --Start6
    JB1 <= '0';
    wait for BIT_PERIOD;
    
    --Data
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0'; -- MSB
    wait for BIT_PERIOD;

    --Stop
    JB1 <= '1';
    wait for BIT_PERIOD;
    
    
    
        --Start7
    JB1 <= '0';
    wait for BIT_PERIOD;
    
    --Data
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0';
    wait for BIT_PERIOD;
    JB1 <= '0'; -- MSB
    wait for BIT_PERIOD;

    --Stop
    JB1 <= '1';
    wait for BIT_PERIOD;
    
end process;
end Behavioral;
