

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity FSM_Encoder is
Port(
	RESET      : in std_logic;
    A          : in std_logic;
    B          : in std_logic;
    CLK        : in std_logic;
    STEP      : out std_logic;
    SENSE      : out std_logic
);
end FSM_Encoder;

architecture Behavioral of FSM_Encoder is
	type estate_t is (S0_00,S1_01,S2_10,S3_11,S4_ERROR);                            --Posible state of encoder reception
    signal   estate , nxt_estate : estate_t;
begin

estate_register : process(CLK,RESET)
    begin    	
    if RESET = '1' then
        if A='0' AND B='0' then      ---Determinate estate from reset
            estate <= S0_00;
        elsif A='0' AND B='1' then
            estate <= S1_01;
        elsif A='1' AND B='0' then
            estate <= S2_10;
        elsif A='1' AND B='1' then
            estate <= S3_11;
        else
            estate <=S4_ERROR;                 --Avoid latch defect state
        end if;        
    elsif rising_edge(CLK) then
      --To save the actual state in case of a change in nxt_state.
    	estate<= nxt_estate;  
   	end if;
   end process;
   
   nxtstate_decod : process(A,B,estate)
   begin
   	nxt_estate <= estate; 
    
       	case estate is	
        	when S0_00 =>
        	        if A='0' AND B='0' then      ---Stay on same state
                        nxt_estate <= S0_00;
                    elsif A='0' AND B='1' then
                        nxt_estate <= S1_01;
                    elsif A='1' AND B='0' then
                        nxt_estate <=S2_10;
                    else
                        nxt_estate <=S4_ERROR;
                    end if;

            when S1_01 =>
        	        if A='0' AND B='1' then      ---Stay on same state
                        nxt_estate <= S1_01;
                    elsif A='0' AND B='0' then
                        nxt_estate <= S0_00;
                    elsif A='1' AND B='1' then
                        nxt_estate <=S3_11;
                    else
                        nxt_estate <=S4_ERROR;
                    end if;
            when S2_10 =>           
        	        if A='1' AND B='0' then      ---Stay on same state
                        nxt_estate <= S2_10;
                    elsif A='0' AND B='0' then
                        nxt_estate <= S0_00;
                    elsif A='1' AND B='1' then
                        nxt_estate <=S3_11;
                    else
                        nxt_estate <=S4_ERROR;
                    end if;
            when S3_11 =>
        	        if A='1' AND B='1' then      ---Stay on same state
                        nxt_estate <= S3_11;
                    elsif A='0' AND B='1' then
                        nxt_estate <= S1_01;
                    elsif A='1' AND B='0' then
                        nxt_estate <=S2_10;
                    else
                        nxt_estate <=S4_ERROR;
                    end if;            
            when others => --Something wrong happened
                nxt_estate <= S4_ERROR;   		
      	end case;
   end process;
   
   output_decod   : process(estate,nxt_estate) 
   begin
    if estate/=nxt_estate then
        STEP <= '1';
    else
        STEP <='0';
    end if;
   end process;
end architecture;

