library IEEE, mylib;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use mylib.defGlobal.all;
use mylib.defAFC.all;
use mylib.defBCT.all;
use mylib.defToplevel.all;

entity AfullCounter is
  port(
    rst	                : in std_logic;
    clk	                : in std_logic;
    -- Module input --
    tcpAfull            : in std_logic;
    tcpIsActive         : in std_logic;
    
    -- Local bus --
    addrLocalBus        : in LocalAddressType;
    dataLocalBusIn      : in LocalBusInType;
    dataLocalBusOut	    : out LocalBusOutType;
    reLocalBus          : in std_logic;
    weLocalBus          : in std_logic;
    readyLocalBus	      : out std_logic
    );
end AfullCounter;

architecture RTL of AfullCounter is
  -- System --
  signal reset_shiftreg       : std_logic_vector(kWidthResetSync-1 downto 0);
  signal sync_reset           : std_logic;
  
  -- internal signal declaration --
  signal reg_counter : std_logic_vector(31 downto 0);
  signal counter_reset  : std_logic;
  signal state_lbus	 : BusProcessType;

-- =============================== body ===============================
begin	

  u_counter : process(sync_reset, clk)
  begin
    if(sync_reset = '1') then
      reg_counter <= (others => '0');
    elsif(clk'event and clk = '1') then
      if(counter_reset = '1') then
        reg_counter <= (others => '0');
      elsif(tcpAfull = '1' and tcpIsActive = '1') then
        reg_counter <= reg_counter +1;
      end if;
    end if;
  end process;

  u_BusProcess : process(clk, sync_reset)
  begin
    if(sync_reset = '1') then
      state_lbus	<= Init;
    elsif(clk'event and clk = '1') then
      case state_lbus is
        when Init =>
          counter_reset   <= '0';
          dataLocalBusOut <= x"00";
          readyLocalBus		<= '0';
          state_lbus		  <= Idle;
          
        when Idle =>
          readyLocalBus	<= '0';
          if(weLocalBus = '1' or reLocalBus = '1') then
            state_lbus	<= Connect;
          end if;
          
        when Connect =>
          if(weLocalBus = '1') then
            state_lbus	<= Write;
          else
            state_lbus	<= Read;
          end if;
          
        when Write =>
          case addrLocalBus(kNonMultiByte'range) is
            when kReset(kNonMultiByte'range) =>
              counter_reset   <= dataLocalBusIn(0);
            when others => null;
          end case;
          state_lbus	<= Done;
          
        when Read =>
          case addrLocalBus(kNonMultiByte'range) is
            when kCounter(kNonMultiByte'range) =>
              if( addrLocalBus(kMultiByte'range) = k1stbyte ) then
                dataLocalBusOut <= reg_counter(7 downto 0);
              elsif( addrLocalBus(kMultiByte'range) = k2ndbyte ) then
                dataLocalBusOut <= reg_counter(15 downto 8);
              elsif( addrLocalBus(kMultiByte'range) = k3rdbyte ) then
                dataLocalBusOut <= reg_counter(23 downto 16);
              elsif( addrLocalBus(kMultiByte'range) = k4thbyte ) then
                dataLocalBusOut <= reg_counter(31 downto 24);
              else
                dataLocalBusOut <= reg_counter(7 downto 0);
              end if;
            when others =>
              dataLocalBusOut <= x"ff";
          end case;
          state_lbus	<= Done;
          
        when Done =>
          readyLocalBus	<= '1';
          if(weLocalBus = '0' and reLocalBus = '0') then
            state_lbus	<= Idle;
          end if;
          
        -- probably this is error --
        when others =>
          state_lbus	<= Init;
      end case;
    end if;
  end process u_BusProcess;

  -- Reset sequence --
  sync_reset  <= reset_shiftreg(kWidthResetSync-1);
  u_sync_reset : process(rst, clk)
  begin
    if(rst = '1') then
      reset_shiftreg  <= (others => '1');
    elsif(clk'event and clk = '1') then
      reset_shiftreg  <= reset_shiftreg(kWidthResetSync-2 downto 0) & '0';
    end if;
  end process;

end RTL;

