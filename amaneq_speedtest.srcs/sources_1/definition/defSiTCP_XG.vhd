library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

package defSiTCP_XG is

  -- RBCP Bus definition
  constant kWidthAddrRBCP   : positive:=32;
  constant kWidthDataRBCP   : positive:=8;

  -- TCP bus definition --
  constant kWidthAddrRx     : positive:= 16;
  
  -- DAQ data definition
  constant kWidthDaqData    : positive:=32; -- Maximum (default): 64
  constant kNumByteTCPXG    : std_logic_vector(3 downto 0):= "0100";

  -- XGMII --
  constant kWidthDataXGMII  : positive:= 64;
  constant kWidthCtrlXGMII  : positive:= 8;

end package defSiTCP_XG;

