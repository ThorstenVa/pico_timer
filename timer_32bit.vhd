library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;



entity timer_32bit is
	port(
		clk, reset  : in std_logic;
		timer_in 	: in std_logic_vector(31 downto 0);
		timer_en, int_en : in std_logic;
		timer_out 	: out std_logic_vector(31 downto 0);
		int_out		: out std_logic;
		int_ack		: in std_logic
		);
	
end timer_32bit;

architecture Behavioral of timer_32bit is

	signal count : std_logic_vector(31 downto 0);

begin

	process(clk, reset)
	begin
		if (reset = '1') then 
			count <= (others => '0');
			int_out <= '0';
		elsif clk'event and clk = '1' then
			if int_ack = '1' then
				int_out <= '0';
			end if;
		
			if (timer_en = '1') then
				count <= count + 1;
				
				if count = timer_in -1 then
					if int_en = '1' then
						int_out <= '1';
					end if;
					count <= (others => '0');
				end if;		
				
			end if;
		end if;	
	end process;
	
	timer_out <= count;


end Behavioral;

