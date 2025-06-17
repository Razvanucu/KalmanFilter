library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use STD.TEXTIO.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


entity tb_KalmanReadFromFile is
--  Port ( );
end tb_KalmanReadFromFile;

architecture Behavioral of tb_KalmanReadFromFile is

component KalmanFilter is
 Port (
  aclk: in std_logic;
  aresetn: in std_logic;
  s_axis_measurement_tdata:in std_logic_vector(63 downto 0);
  s_axis_measurement_tready:out std_logic;
  s_axis_measurement_tvalid:in std_logic;
  m_axis_estimate_tdata:out std_logic_vector(127 downto 0);
  m_axis_estimate_tready:in std_logic;
  m_axis_estimate_tvalid:out std_logic
  );
end component KalmanFilter;

signal aclk:  std_logic := '0';
signal aresetn:  std_logic := '0';
signal s_axis_measurement_tdata: std_logic_vector(63 downto 0) := (others => '0');
signal s_axis_measurement_tready: std_logic := '0';
signal s_axis_measurement_tvalid: std_logic := '0';
signal m_axis_estimate_tdata: std_logic_vector(127 downto 0) := (others => '0');
signal m_axis_estimate_tready: std_logic := '0';
signal m_axis_estimate_tvalid: std_logic := '0';

signal rd_count, wr_count : integer := 0;
signal end_of_reading : std_logic := '0';

begin

aclk <= not aclk after 2ns;
aresetn <= '0','1' after 25ns;

KalmanFiltertb:KalmanFilter port map(
aclk => aclk,
aresetn => aresetn,
s_axis_measurement_tdata => s_axis_measurement_tdata,
s_axis_measurement_tready => s_axis_measurement_tready,
s_axis_measurement_tvalid => s_axis_measurement_tvalid,
m_axis_estimate_tdata => m_axis_estimate_tdata,
m_axis_estimate_tready => m_axis_estimate_tready,
m_axis_estimate_tvalid => m_axis_estimate_tvalid
);

m_axis_estimate_tready<='1';

 -- read values from the input file
    process (aclk)
        file sensors_data : text open read_mode is "photoresistor.csv";
        variable in_line : line;
        
        variable which: std_logic :='0';
        variable ptr:integer:=0;
                   
        variable data_sensor:std_logic_vector(63 downto 0):= (others => '0');
        
    begin
        if rising_edge(aclk) then
            if aresetn = '1' and end_of_reading = '0' then
                if not endfile(sensors_data) then        
                    if s_axis_measurement_tready = '1' then
                        readline(sensors_data, in_line);
                        which:='0';
                        ptr:=0; 
                        for i in in_line'range loop
                                if in_line(i) = ',' then
                                    which :='1';
                                else
                                    if which = '1' then
                                        if in_line(i) = '1' then
                                            data_sensor(63 - ptr):='1';
                                        elsif in_line(i) = '0' then
                                            data_sensor(63 - ptr):='0';
                                        end if;
                                        ptr:=ptr+1;                              
                                    end if;
                                end if;                     
                            end loop; 
                        s_axis_measurement_tdata <= data_sensor;    
                        s_axis_measurement_tvalid <= '1'; 
                        rd_count <= rd_count + 1;                                             
                     else
                        s_axis_measurement_tvalid <= '0';
                     end if;         
                else
                    file_close(sensors_data);
                    end_of_reading <= '1';
                end if;
            end if;
        end if;
    end process;
    
    
    process 
       file results : text open write_mode is "F:\StrucutreOfComputerSystems\filteredResults.csv";
       variable out_line : line;
    begin
        wait until rising_edge(aclk);
            
        if aresetn = '0' then
            wait until rising_edge(aresetn);
        end if;
    
        
        if wr_count <= rd_count then
            if m_axis_estimate_tvalid = '1' then   -- write the result only when it is valid
                write(out_line, wr_count);
                write(out_line, string'(", "));
                write(out_line, m_axis_estimate_tdata(63 downto 0));
                write(out_line, string'(", "));
                write(out_line, m_axis_estimate_tdata(127 downto 64));
                writeline(results, out_line);
                
                wr_count <= wr_count + 1;
                
            end if;
        else
            file_close(results);
            report "execution finished...";
            wait;
        end if;
    end process;
end Behavioral;
