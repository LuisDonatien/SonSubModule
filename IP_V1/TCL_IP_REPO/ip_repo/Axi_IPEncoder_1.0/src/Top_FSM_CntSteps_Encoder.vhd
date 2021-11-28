library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity Top_FSM_CntSteps_Encoder is
Generic(
    SIZE_VECTOR_COUNT : integer:=32
);
Port ( 
    CLK :       in std_logic;   
    RESET:      in std_logic;
    RESET_CNT:  in std_logic;
    A:          in std_logic;
    B:          in std_logic;
    COUNT:      out std_logic_vector(SIZE_VECTOR_COUNT-1 downto 0)
    
  );
end Top_FSM_CntSteps_Encoder;

architecture Behavioral of Top_FSM_CntSteps_Encoder is

COMPONENT FSM_ENCODER
Port(
	RESET      : in std_logic;
    A          : in std_logic;
    B          : in std_logic;
    CLK        : in std_logic;
    STEP       : out std_logic;
    SENSE      : out std_logic
);
END COMPONENT;

COMPONENT CntSteps_Encoder
Generic(
 SIZE : integer   --Size of Vector COUNT 
);
Port ( 
    CLK     :   in std_logic;
    RESET   : in std_logic;  -- Double reset: one from lector/calculator rpm and the other from general reset.
    INPUT   : in std_logic;
    COUNT   : out std_logic_vector(SIZE-1 downto 0)
);
END COMPONENT;

signal RESET_CNT_s  : std_logic;
signal STEP_s       : std_logic;
signal SENSE_s      : std_logic;

begin
uut0: FSM_ENCODER 
PORT MAP(
	RESET   =>RESET_CNT_s,
    A       =>A,
    B       =>B,  
    CLK     =>CLK, 
    STEP    =>STEP_s,
    SENSE   =>SENSE_s
);
uut1: CntSteps_Encoder
GENERIC MAP(
    SIZE => SIZE_VECTOR_COUNT
)
PORT MAP(
    CLK     =>CLK,
    RESET   =>RESET_CNT_s,
    INPUT   =>STEP_s,
    COUNT   =>COUNT
);
RESET_CNT_s<=RESET_CNT OR RESET;
end Behavioral;
