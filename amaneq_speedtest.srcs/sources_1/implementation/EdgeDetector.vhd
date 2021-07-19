library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity EdgeDetector is
  port (
    rst : in std_logic;
    clk : in std_logic;
    dIn : in std_logic;
    dOut : out std_logic 
    );
end EdgeDetector;

architecture RTL of EdgeDetector is
  -- Internal signal declaration ---------------------------------------
  signal q1, q2   : std_logic;

begin
  --============================ body ==================================
  dOut    <= (NOT q1) NOR q2;

  u_DFF : process(rst, clk)
  begin
    if(rst = '1') then
      q1  <= '0';
      q2  <= '0';       
    elsif(clk'event AND clk = '1') then
      q1  <= dIn;
      q2  <= q1;
    end if;
  end process u_DFF;

end RTL;
