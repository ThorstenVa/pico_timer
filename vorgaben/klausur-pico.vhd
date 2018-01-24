library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity klausur_pico is
  Port ( a, b    : in  std_logic;
         led	  : out std_logic_vector(7 downto 0);
         reset   : in std_logic;			
         clk     : in  std_logic);
end klausur_pico;

architecture behavioral of klausur_pico is

  component kcpsm3
    port (address       : out std_logic_vector(9 downto 0);
          instruction   : in std_logic_vector(17 downto 0);
          port_id       : out std_logic_vector(7 downto 0);
          write_strobe  : out std_logic;
          out_port      : out std_logic_vector(7 downto 0);
          read_strobe   : out std_logic;
          in_port       : in std_logic_vector(7 downto 0);
          interrupt     : in std_logic;
          interrupt_ack : out std_logic;
          reset         : in std_logic;
          clk           : in std_logic);
  end component;
  
  component programm
     port (address     : in std_logic_vector(9 downto 0);
           instruction : out std_logic_vector(17 downto 0);
           clk         : in std_logic);
  end component;
  
  component timer_32bit 
	port(
		clk, reset  : in std_logic;
		timer_in 	: in std_logic_vector(31 downto 0);
		timer_en, int_en : in std_logic;
		timer_out 	: out std_logic_vector(31 downto 0);
		int_out		: out std_logic;
		int_ack		: in std_logic
		);
	end component;


  
  -- Signale zwischen PicoBlaze und Umwelt

  signal address              : std_logic_vector(9 downto 0);
  signal instruction          : std_logic_vector(17 downto 0);
  signal port_id_signal       : std_logic_vector(7 downto 0);
  signal out_port_signal      : std_logic_vector(7 downto 0);
  signal in_port_signal       : std_logic_vector(7 downto 0);
  signal write_strobe_signal  : std_logic;
  signal read_strobe_signal   : std_logic;
  signal interrupt_signal     : std_logic;
  signal interrupt_ack_signal : std_logic;

     

	signal timer_in_signal   	: std_logic_vector(31 downto 0);
	signal timer_out_signal		: std_logic_vector(31 downto 0);
	signal timer_en_signal		: std_logic;
	signal int_en_signal			: std_logic;
	signal int_out_signal		: std_logic;



  
  -- Hier fangen Ihre Deklarationen an
  
  signal s_reg0, s_reg1, s_reg2 : std_logic_vector(7 downto 0);
    
 
begin

  i_processor : kcpsm3 port map (address => address,
                              instruction => instruction,   
                              port_id => port_id_signal,
                              write_strobe => write_strobe_signal,
                              out_port => out_port_signal,
                              read_strobe => read_strobe_signal,
                              in_port => in_port_signal,
                              interrupt => interrupt_signal,
                              interrupt_ack => interrupt_ack_signal,
                              reset => reset,
										clk => clk);

  i_program: programm port map( address => address,
                          instruction => instruction,
                          clk => clk);
								  
							
  i_timer: timer_32bit port map(
		clk => clk, 
		reset  => reset,
		timer_in =>	timer_in_signal,
		timer_en => timer_en_signal,
		int_en => int_en_signal,
		timer_out => timer_out_signal,
		int_out	=> int_out_signal,
		int_ack => interrupt_ack_signal
		);

 
	-- write
	read_process : process(clk)
	begin
		if clk'event and clk = '1' then
			if write_strobe_signal = '1' then
				case port_id_signal is
					when x"00" => timer_in_signal(31 downto 24) <= out_port_signal;
					when x"01" => timer_in_signal(23 downto 16) <= out_port_signal;
					when x"02" => timer_in_signal(15 downto 8)  <= out_port_signal;
					when x"03" => timer_in_signal(7 downto 0)   <= out_port_signal;
					when x"04" => 
						timer_en_signal <= out_port_signal(1);
						int_en_signal <= out_port_signal(0);
					when x"05" => led <= out_port_signal;
					when others => null;	
				end case;
			end if;
		end if;	
	end process;
	 
	
	-- read
	with port_id_signal select
		in_port_signal <= timer_in_signal(31 downto 24) when x"00",
								timer_in_signal(23 downto 16) when x"01",
								timer_in_signal(15 downto  8) when x"02",
								timer_in_signal(7  downto  0) when x"03",
								"000000" & timer_en_signal & int_en_signal when x"04",
								(others => '0') when others;
 
 

  
end behavioral;
