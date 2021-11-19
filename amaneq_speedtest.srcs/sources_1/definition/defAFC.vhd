library ieee, mylib;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use mylib.defBCT.all;

package defAFC is
  -- Local Address  -------------------------------------------------------
  constant kReset              : LocalAddressType := x"000"; -- W [0:0];
  constant kCounter            : LocalAddressType := x"010"; -- R [31:0];
  
end package defAFC;	

