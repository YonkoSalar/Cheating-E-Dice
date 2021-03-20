library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity e_dice is
port(run, cheat, clk, rst : in std_logic;
    enable : out std_logic;
    sseg : out std_logic_vector(7 downto 0)

);
end e_dice;

architecture Behavioral of e_dice is
type state is (S0, S1, S2, S3, S4, S5, S6, S7);
signal prest, nxtst: state; 

begin

-- state register
process (clk, rst)
begin
   if (rst = '1') then
	  prest <= S0; -- initial state
   elsif rising_edge(clk) then
	  prest <= nxtst;
   end if;
end process;

-- next-state logic
process (cheat, clk)
begin
   nxtst <= prest; -- stay in current state by default

   case prest is
      when S0 =>
         if run='1' then 
            nxtst <= S1;             
         end if;
         
       when S1 =>
         if run='1' 
            then nxtst <= S2;    
         end if;
         
         
       when S2 =>
          if run='1' then 
             nxtst <= S3; 
          end if;
          
        when S3 =>
          if run='1' 
             then nxtst <= S4;    
          end if;
          
       when S4 =>
        if run='1' then 
           nxtst <= S5; 
        end if;
        
      when S5 =>
        if run='1' and cheat='0'  
            then nxtst <= S1;
        elsif run='1' and cheat='1' then 
            nxtst <= S6;      
        end if;
        
      when S6 =>
        if run='1'  
           then nxtst <= S7;     
        end if;
        
      when S7 =>
        if run='1'  
           then nxtst <= S0;     
        end if;

   end case;
end process;

-- Combinational block #2
sseg(6 downto 0) <=  "1111001" when prest=S0 else -- 1
                    "0100100" when prest=S1 else -- 2
                    "0110000" when prest=S2 else -- 3
                    "0011001" when prest=S3 else --4
                    "0010010" when prest=S4 else --5
                    "0000010" when prest=S5 else --6
                    "0000010" when prest=S6 else --6
                    "0000010"; -- 6
sseg(7) <= not(cheat);                  
enable <= '0';



end Behavioral;