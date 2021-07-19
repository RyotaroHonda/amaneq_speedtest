library IEEE, mylib;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use mylib.defGlobal.all;

entity SystemReset is
  port(
    -- Seed of the master reset --
    asyncReset    : in std_logic;
    mmcmLocked    : in std_logic;
    -- Async reset to 10GbE_PCSPMA --
    masterReset   : out std_logic;
    clkXgmii      : in std_logic; -- 156 MHz from core

    -- System reset synchronized with clkXgmii --
    qpllLocked    : in std_logic; -- from core
    syncSysReset  : out std_logic
    );
end SystemReset;

architecture RTL of SystemReset is
  -- signal declaration ---------------------------------------------------
  signal reset_shiftreg   : std_logic_vector(kWidthResetSync-1 downto 0);
  signal async_sys_reset  : std_logic;
  
-- ================================ body ==================================
begin
  -- signal connection ----------------------------------------------------
  masterReset   <= asyncReset or (not mmcmLocked);
  syncSysReset  <= reset_shiftreg(kWidthResetSync-1);

  async_sys_reset   <= asyncReset or (not qpllLocked);
  u_sync_reset : process(async_sys_reset, clkXgmii)
  begin
    if(async_sys_reset = '1') then
      reset_shiftreg  <= (others => '1');
    elsif(clkXgmii'event and clkXgmii = '1') then
      reset_shiftreg  <= reset_shiftreg(kWidthResetSync-2 downto 0) & '0';
    end if;
  end process;
  

end RTL;

