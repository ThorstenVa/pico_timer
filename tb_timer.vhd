LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

 
ENTITY tb_timer IS
END tb_timer;
 
ARCHITECTURE behavior OF tb_timer IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT timer_32bit
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         timer_in : IN  std_logic_vector(31 downto 0);
         timer_en : IN  std_logic;
         int_en : IN  std_logic;
         timer_out : OUT  std_logic_vector(31 downto 0);
         int_out : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal timer_in : std_logic_vector(31 downto 0) := (others => '0');
   signal timer_en : std_logic := '0';
   signal int_en : std_logic := '0';

 	--Outputs
   signal timer_out : std_logic_vector(31 downto 0);
   signal int_out : std_logic; 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: timer_32bit PORT MAP (
          clk => clk,
          reset => reset,
          timer_in => timer_in,
          timer_en => timer_en,
          int_en => int_en,
          timer_out => timer_out,
          int_out => int_out
        );
		  
		  

	timer_in <= x"00000004";
	timer_en <= '1';
	int_en <= '1';

	reset <= '1',
				'0' after 15 ns;
				
	clk <= not clk after 10 ns;



		  
END;
