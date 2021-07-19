library IEEE, mylib;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use mylib.defSiTCP_XG.all;
use mylib.defToplevel.all;

entity TCPsenderXG is
  port(
    rst 					: in std_logic;
    clk 					: in std_logic;
    dipPat        : in std_logic_vector(kNumSpeedBit-1 downto 0);
    
    -- data from EVB --
    rdFromEVB		  : in std_logic_vector(kWidthDataXGMII-1 downto 0);
    rvFromEVB		  : in std_logic;
    emptyFromEVB  : in std_logic;
    reToEVB		    : out std_logic;
    
    -- data to SiTCP
    isActive		  : in std_logic;
    afullTx		    : in std_logic;
    tcpTxB	      : out std_logic_vector(kNumByteTCPXG'range);
    tcpTxD	      : out std_logic_vector(kWidthDataXGMII-1 downto 0)
    
    );
end TCPsenderXG;

architecture RTL of TCPsenderXG is
  -- signal declaration ---------------------------------------------------
  signal din_wdtx         : std_logic_vector(kWidthDataXGMII-1 downto 0);
  signal num_byte_txd     : std_logic_vector(kNumByteTCPXG'range);
  
-- ================================ body ==================================
begin
  -- signal connection ----------------------------------------------------
  -- Zero padding --
  --din_wdtx  <= rdFromEVB(8*conv_integer(num_byte_txd)-1 downto 0) & conv_std_logic_vector(0, 64-conv_integer(num_byte_txd));

  -- Tx Num Byte --
  num_byte_txd  <= "1000" when(dipPat = "111") else
                   "0111" when(dipPat = "110") else
                   "0110" when(dipPat = "101") else
                   "0101" when(dipPat = "100") else
                   "0100" when(dipPat = "011") else
                   "0011" when(dipPat = "010") else
                   "0010" when(dipPat = "001") else
                   "0001" when(dipPat = "000") else "0000";


  -- FIFO read
  u_buffer_reader : process(RST, CLK)
  begin
    if(RST = '1') then
      tcpTxB	<= (others => '0');
      tcpTxD	<= (others => '0');
    elsif(CLK'event AND CLK = '1') then
      if(rvFromEVB = '1') then
        tcpTxB  <= num_byte_txd;
      else
        tcpTxB  <= "0000";
      end if;

      if(dipPat = "000") then
        tcpTxD	<= rdFromEVB(7 downto 0)  & conv_std_logic_vector(0, 56);
      elsif(dipPat = "001") then
        tcpTxD	<= rdFromEVB(15 downto 0) & conv_std_logic_vector(0, 48);
      elsif(dipPat = "010") then
        tcpTxD	<= rdFromEVB(23 downto 0) & conv_std_logic_vector(0, 40);
      elsif(dipPat = "011") then
        tcpTxD	<= rdFromEVB(31 downto 0) & conv_std_logic_vector(0, 32);
      elsif(dipPat = "100") then
        tcpTxD	<= rdFromEVB(39 downto 0) & conv_std_logic_vector(0, 24);
      elsif(dipPat = "101") then
        tcpTxD	<= rdFromEVB(47 downto 0) & conv_std_logic_vector(0, 16);
      elsif(dipPat = "110") then
        tcpTxD	<= rdFromEVB(55 downto 0) & conv_std_logic_vector(0, 8);
      elsif(dipPat = "111") then
        tcpTxD	<= rdFromEVB;
      end if;
      
      if(emptyFromEVB = '0' AND isActive = '1' AND afullTx = '0') then
        reToEVB	<= '1';
      else
        reToEVB	<= '0';
      end if;
    end if;
  end process u_buffer_reader;

end RTL;

