library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PredictStage is
  Port (
   x_k_estimated:in  std_logic_vector(31 downto 0);
   covariance_k_estimated:in std_logic_vector(31 downto 0);
   x_k_predicted:out std_logic_vector(31 downto 0);
   covariance_k_predicted:out std_logic_vector(31 downto 0)
   );
end PredictStage;

architecture Behavioral of PredictStage is

begin


end Behavioral;
