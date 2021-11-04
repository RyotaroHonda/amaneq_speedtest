library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_MISC.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library UNISIM;
use UNISIM.VComponents.all;

library mylib;
use mylib.defToplevel.all;
use mylib.defBCT.all;
use mylib.defSiTCP_XG.all;
--use mylib.defMiiRstTimer.all;

entity toplevel is
  Port (
-- System ---------------------------------------------------------------
    PROGB_ON            : out std_logic;
    BASE_CLKP           : in std_logic;
    BASE_CLKN           : in std_logic;
    USR_RSTB            : in std_logic;
    LED                 : out std_logic_vector(4 downto 1);
    DIP                 : in std_logic_vector(4 downto 1);
    VP                  : in std_logic;
    VN                  : in std_logic;

-- GTX ------------------------------------------------------------------
    GTX_REFCLK_P        : in std_logic;
    GTX_REFCLK_N        : in std_logic;
    GTX_TX_P            : out std_logic;
    GTX_RX_P            : in std_logic;
    GTX_TX_N            : out std_logic;
    GTX_RX_N            : in std_logic;
    -- GTX_TX_P            : out std_logic_vector(1 downto 0);
    -- GTX_RX_P            : in std_logic_vector(1 downto 0);
    -- GTX_TX_N            : out std_logic_vector(1 downto 0);
    -- GTX_RX_N            : in std_logic_vector(1 downto 0);

-- SPI flash ------------------------------------------------------------
    MOSI                : out std_logic;
    DIN                 : in std_logic;
    NC1                 : in std_logic;
    NC2                 : in std_logic;
    FCSB                : out std_logic;

-- EXBASE connector -----------------------------------------------------

-- EEPROM ---------------------------------------------------------------
    EEP_CS              : out std_logic;
    EEP_SK              : out std_logic;
    EEP_DI              : out std_logic;
    EEP_DO              : in std_logic;
    -- EEP_CS              : out std_logic_vector(2 downto 1);
    -- EEP_SK              : out std_logic_vector(2 downto 1);
    -- EEP_DI              : out std_logic_vector(2 downto 1);
    -- EEP_DO              : in std_logic_vector(2 downto 1);

-- NIM-IO ---------------------------------------------------------------
    NIM_IN              : in std_logic_vector(2 downto 1);
    NIM_OUT             : out std_logic_vector(2 downto 1);

-- JItter cleaner -------------------------------------------------------

-- Belle2 Link ----------------------------------------------------------

-- Main port ------------------------------------------------------------
-- Up port --
    MAIN_IN_U           : in std_logic_vector(31 downto 0);
-- Down port --
    MAIN_IN_D           : in std_logic_vector(31 downto 0)

-- Mezzanine slot -------------------------------------------------------
-- Up slot --
-- Dwon slot --

-- DDR3 SDRAM -----------------------------------------------------------

  );
end toplevel;

architecture Behavioral of toplevel is
  attribute mark_debug : string;

  -- System --------------------------------------------------------------------------------
  signal async_reset  : std_logic;
  signal core_master_reset  : std_logic;
  
  signal system_reset : std_logic;
  signal user_reset   : std_logic;
  signal emergency_reset  : std_logic;
  signal bct_reset    : std_logic;
  signal rst_from_bus : std_logic;

  
  -- USER ----------------------------------------------------------------------------------

  -- DIP -----------------------------------------------------------------------------------
  signal dip_sw       : std_logic_vector(DIP'range);
  subtype DipID is integer range 0 to 4;
  type regLeaf is record
    Index : DipID;
  end record;
  constant kSiTCP     : regLeaf := (Index => 1);
  constant kSpeed1    : regLeaf := (Index => 2);
  constant kSpeed2    : regLeaf := (Index => 3);
  constant kSpeed3    : regLeaf := (Index => 4);
  constant kDummy     : regLeaf := (Index => 0);

  signal speed_bits       : std_logic_vector(kNumSpeedBit-1 downto 0);
  signal reg_speed_bits   : std_logic_vector(kNumSpeedBit-1 downto 0);
    
  -- LED ----------------------------------------------------------------------------------
  signal out_led  : std_logic_vector(LED'range);

  -- SDS ---------------------------------------------------------------------
  signal shutdown_over_temp     : std_logic;
  
  -- FMP ---------------------------------------------------------------------
  
  -- BCT -----------------------------------------------------------------------------------
  signal addr_LocalBus          : LocalAddressType;
  signal data_LocalBusIn        : LocalBusInType;
  signal data_LocalBusOut       : DataArray;
  signal re_LocalBus            : ControlRegArray;
  signal we_LocalBus            : ControlRegArray;
  signal ready_LocalBus         : ControlRegArray;
  
  -- TSD -----------------------------------------------------------------------------------
  signal wd_to_tsd                              : std_logic_vector(kWidthDaqData-1 downto 0);
  signal we_to_tsd, empty_to_tsd, re_from_tsd   : std_logic;

  signal counter : std_logic_vector(63 downto 0);

  -- SiTCP ---------------------------------------------------------------------------------
  signal tcp_is_active, close_req, close_ack    : std_logic;

  signal tcp_tx_afull : std_logic;
  signal tcp_txb      : std_logic_vector(kNumByteTCPXG'range);
  signal tcp_txd      : std_logic_vector(kWidthDataXGMII-1 downto 0);

  signal tcp_rx_clr_enb   : std_logic;
  signal tcp_rx_wadr      : std_logic_vector(kWidthAddrRx-1 downto 0);
  
  signal rbcp_act     : std_logic;
  signal rbcp_addr    : std_logic_vector(kWidthAddrRBCP-1 downto 0);
  signal rbcp_wd      : std_logic_vector(kWidthDataRBCP-1 downto 0);
  signal rbcp_we      : std_logic;
  signal rbcp_re      : std_logic;
  signal rbcp_ack     : std_logic;
  signal rbcp_rd      : std_logic_vector(kWidthDataRBCP-1 downto 0);

  component WRAP_SiTCPXG_XC7K_128K
    generic(
      RxBufferSize	: string
      );
    port(
      REG_FPGA_VER              : in std_logic_vector(31 downto 0);
      REG_FPGA_ID               : in std_logic_vector(31 downto 0);
      
      --		==== System I/F ====
      FORCE_DEFAULTn            : in std_logic;
      XGMII_CLOCK               : in std_logic;
      RSTs                      : in std_logic;
      
      --		==== XGMII I/F ====
      XGMII_RXC 								: in std_logic_vector(7 downto 0);
      XGMII_RXD 								: in std_logic_vector(63 downto 0);
      XGMII_TXC									: out std_logic_vector(7 downto 0);
			XGMII_TXD									: out std_logic_vector(63 downto 0);
      
      --		==== 93C46 I/F ====
			EEPROM_CS									: out std_logic;
			EEPROM_SK									: out std_logic;
			EEPROM_DI									: out std_logic;
      EEPROM_DO									: in std_logic;
      
      --		==== User I/F ====
      SiTCP_RESET_OUT	          : out std_logic;
      --		--- RBCP ---
			RBCP_ACT                  : out std_logic;
			RBCP_ADDR                 : out std_logic_vector(31 downto 0);
			RBCP_WE										: out std_logic;
			RBCP_WD										: out std_logic_vector(7 downto 0);
			RBCP_RE										: out std_logic;
      RBCP_ACK                  : in std_logic;
			RBCP_RD	                  : in std_logic_vector(7 downto 0);
      -- --- TCP ---
      USER_SESSION_OPEN_REQ	    : in std_logic;
		 	USER_SESSION_ESTABLISHED  : out std_logic;
		 	USER_SESSION_CLOSE_REQ    : out std_logic;
      USER_SESSION_CLOSE_ACK    : in std_logic;
      USER_TX_D                 : in std_logic_vector(63 downto 0);
      USER_TX_B	                : in std_logic_vector(3 downto 0);
		 	USER_TX_AFULL             : out std_logic;
      USER_RX_SIZE              : in std_logic_vector(15 downto 0);
		 	USER_RX_CLR_ENB	          : out std_logic;
      USER_RX_CLR_REQ           : in std_logic;
      USER_RX_RADR 							: in std_logic_vector(15 downto 0);
      USER_RX_WADR 							: out std_logic_vector(15 downto 0);
      USER_RX_WENB 							: out std_logic_vector(7 downto 0);
      USER_RX_WDAT 							: out std_logic_vector(63 downto 0)
      );
  end component;
  
  -- GTX transceiver -----------------------------------------------------------------------
--  constant kMiiPhyad      : std_logic_vector(kWidthPhyAddr-1 downto 0):= "00000";
--  signal mii_init_mdc, mii_init_mdio : std_logic;

  signal clk_xgmii        : std_logic;
  signal qpll_locked      : std_logic;

  signal xgmii_rxc        : std_logic_vector(kWidthCtrlXGMII-1 downto 0);
  signal xgmii_rxd        : std_logic_vector(kWidthDataXGMII-1 downto 0);
  signal xgmii_txc        : std_logic_vector(kWidthCtrlXGMII-1 downto 0);
  signal xgmii_txd        : std_logic_vector(kWidthDataXGMII-1 downto 0);

  -- DRP --
  signal drp_req          : std_logic;
  signal drp_den, drp_dwe, drp_drdy : std_logic;
  signal drp_addr         : std_logic_vector(15 downto 0);
  signal drp_di           : std_logic_vector(15 downto 0);
  signal drp_drpdo        : std_logic_vector(15 downto 0);
    
  COMPONENT ten_gig_eth_pcs_pma
    PORT (
      -- Core block --
      refclk_p              : IN STD_LOGIC;
      refclk_n              : IN STD_LOGIC;
      reset                 : IN STD_LOGIC;
      resetdone_out         : OUT STD_LOGIC;
      coreclk_out           : OUT STD_LOGIC;
      rxrecclk_out          : OUT STD_LOGIC;
      
      -- Tranceiver --
      txp 									: OUT STD_LOGIC;
      txn 									: OUT STD_LOGIC;
      rxp 									: IN STD_LOGIC;
      rxn 									: IN STD_LOGIC;

      -- SFP+ IF --
      signal_detect         : IN STD_LOGIC;
      tx_disable            : OUT STD_LOGIC;
      tx_fault              : IN STD_LOGIC;

      -- XGMII --
      xgmii_txd             : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
      xgmii_txc             : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      xgmii_rxd             : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
      xgmii_rxc             : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);

      -- MDIO --
      mdc                   : IN STD_LOGIC;
      mdio_in               : IN STD_LOGIC;
      mdio_out              : OUT STD_LOGIC;
      mdio_tri              : OUT STD_LOGIC;
      prtad                 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);

      -- DRP IF --
      dclk                  : IN STD_LOGIC;
      drp_req               : OUT STD_LOGIC;
      drp_gnt               : IN STD_LOGIC;

      drp_den_o             : OUT STD_LOGIC;
      drp_dwe_o             : OUT STD_LOGIC;
      drp_daddr_o           : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      drp_di_o              : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      drp_drdy_o            : OUT STD_LOGIC;
      drp_drpdo_o           : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      drp_den_i             : IN STD_LOGIC;
      drp_dwe_i             : IN STD_LOGIC;
      drp_daddr_i           : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      drp_di_i              : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      drp_drdy_i            : IN STD_LOGIC;
      drp_drpdo_i           : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

      -- mics --
      pma_pmd_type          : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      core_status           : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      sim_speedup_control   : IN STD_LOGIC;
      
      txusrclk_out          : OUT STD_LOGIC;
      txusrclk2_out         : OUT STD_LOGIC;
      areset_datapathclk_out : OUT STD_LOGIC;
      gttxreset_out         : OUT STD_LOGIC;
      gtrxreset_out         : OUT STD_LOGIC;
      txuserrdy_out         : OUT STD_LOGIC;
      reset_counter_done_out : OUT STD_LOGIC;
      qplllock_out          : OUT STD_LOGIC;
      qplloutclk_out        : OUT STD_LOGIC;
      qplloutrefclk_out     : OUT STD_LOGIC
      );
  END COMPONENT;

  -- Clock ---------------------------------------------------------------------------
  signal clk_gbe, clk_sys   : std_logic;
  signal clk_locked         : std_logic;
  signal clk_sys_locked     : std_logic;
  signal clk_icap, clk_spi  : std_logic;
  
  component clk_wiz_sys
    port
      (-- Clock in ports
        -- Clock out ports
        clk_sys          : out    std_logic;
        clk_spi          : out    std_logic;
        clk_icap_ce      : in     std_logic;
        clk_icap         : out    std_logic;
--        clk_buf          : out    std_logic;
        -- Status and control signals
        reset            : in     std_logic;
        locked           : out    std_logic;
        clk_in1_p        : in     std_logic;
        clk_in1_n        : in     std_logic
        );
  end component;

  -- debug -----------------------------------------------------------------------------
  
begin
  -- ===================================================================================
  -- body
  -- ===================================================================================
  -- Global ----------------------------------------------------------------------------
  clk_locked      <= clk_sys_locked;
  async_reset     <= (not USR_RSTB);
  
  user_reset      <= system_reset or rst_from_bus or emergency_reset;
  bct_reset       <= system_reset or emergency_reset;

  u_RST_Inst : entity mylib.SystemReset
    port map(
      -- Seed of the master reset --
      asyncReset    => async_reset,
      mmcmLocked    => clk_locked,
      -- Async reset to 10GbE_PCSPMA --
      masterReset   => core_master_reset,
      clkXgmii      => clk_xgmii,

      -- System reset synchronized with clkXgmii --
      qpllLocked    => qpll_locked,
      syncSysReset  => system_reset
      );

  -- Input --
--  NIM_OUT   <= NIM_IN;
  NIM_OUT(1)  <= tcp_tx_afull;
  NIM_OUT(2)  <= '0';
  
  dip_sw(1)   <= DIP(1); -- SiTCP
--  dip_sw(2)   <= not DIP(2);
--  dip_sw(3)   <= not DIP(3);
--  dip_sw(4)   <= not DIP(4);
  
  u_bufdip : process(system_reset, clk_xgmii)
  begin
    if(system_reset = '1') then
      reg_speed_bits  <= (others => '0');
    elsif(clk_xgmii'event and clk_xgmii = '1') then
      speed_bits      <= DIP(kSpeed3.Index downto kSpeed1.Index);
      reg_speed_bits  <= speed_bits;
    end if;
  end process;
  
  LED     <= tcp_is_active & tcp_tx_afull & out_led(2 downto 1);

  -- LED -------------------------------------------------------------------------------
  u_LED_Inst : entity mylib.LEDModule 
    port map(
      rst	                => user_reset,
      clk	                => clk_xgmii,
      -- Module output --
      outLED              => out_led,
      -- Local bus --
      addrLocalBus        => addr_LocalBus, 
      dataLocalBusIn      => data_LocalBusIn,
      dataLocalBusOut     => data_LocalBusOut(kLED.ID),
      reLocalBus          => re_LocalBus(kLED.ID),
      weLocalBus          => we_LocalBus(kLED.ID),
      readyLocalBus       => ready_LocalBus(kLED.ID)
    );

  
  -- SDS --------------------------------------------------------------------
  u_SDS_Inst : entity mylib.SelfDiagnosisSystem
    port map(
      rst               => user_reset,
      clk               => clk_xgmii,
      clkIcap           => clk_icap,
      
      -- Module input  --
      VP                => VP,
      VN                => VN,
      
      -- Module output --
      shutdownOverTemp  => shutdown_over_temp,

      -- Local bus --
      addrLocalBus      => addr_LocalBus, 
      dataLocalBusIn    => data_LocalBusIn,
      dataLocalBusOut   => data_LocalBusOut(kSDS.ID),
      reLocalBus        => re_LocalBus(kSDS.ID),
      weLocalBus        => we_LocalBus(kSDS.ID),
      readyLocalBus     => ready_LocalBus(kSDS.ID)
      );


  -- FMP --------------------------------------------------------------------
  u_FMP_Inst : entity mylib.FlashMemoryProgrammer
    port map(
      rst	              => user_reset,
      clk	              => clk_xgmii,
      clkSpi            => clk_spi,
      
      -- Module output --
      CS_SPI            => FCSB,
--      SCLK_SPI          => USR_CLK,
      MOSI_SPI          => MOSI,
      MISO_SPI          => DIN,

      -- Local bus --
      addrLocalBus      => addr_LocalBus, 
      dataLocalBusIn    => data_LocalBusIn,
      dataLocalBusOut   => data_LocalBusOut(kFMP.ID),
      reLocalBus        => re_LocalBus(kFMP.ID),
      weLocalBus        => we_LocalBus(kFMP.ID),
      readyLocalBus     => ready_LocalBus(kFMP.ID)
      );

  
  -- BCT -------------------------------------------------------------------------------
  u_BCT_Inst : entity mylib.BusController
    port map(
      rstSys                    => bct_reset,
      rstFromBus                => rst_from_bus,
      reConfig                  => PROGB_ON,
      clk                       => clk_xgmii,
      -- Local Bus --
      addrLocalBus              => addr_LocalBus,
      dataFromUserModules       => data_LocalBusOut,
      dataToUserModules         => data_LocalBusIn,
      reLocalBus                => re_LocalBus,
      weLocalBus                => we_LocalBus,
      readyLocalBus             => ready_LocalBus,
      -- RBCP --
      addrRBCP                  => rbcp_addr,
      wdRBCP                    => rbcp_wd,
      weRBCP                    => rbcp_we,
      reRBCP                    => rbcp_re,
      ackRBCP                   => rbcp_ack,
      rdRBCP                    => rbcp_rd
      );

  -- TSD -------------------------------------------------------------------------------

  u_counter : process(tcp_is_active, clk_xgmii)
  begin
    if(tcp_is_active = '0') then
      counter <= (others => '0');
    elsif(clk_xgmii'event and clk_xgmii = '1') then
      counter <= counter +1;
    end if;
  end process;

  
  u_TSD_Inst : entity mylib.TCPsenderXG
    port map(
      rst 					=> user_reset,
      clk 					=> clk_xgmii,
      dipPat        => reg_speed_bits,
      
      -- data from EVB --
      rdFromEVB		  => counter,
      rvFromEVB		  => tcp_is_active,
      emptyFromEVB  => '0',
      reToEVB		    => open,
      
      -- data to SiTCP
      isActive		  => tcp_is_active,
      afullTx		    => tcp_tx_afull,
      tcpTxB	      => tcp_txb,
      tcpTxD	      => tcp_txd
      );
  
  -- SiTCP Inst ------------------------------------------------------------------------
  u_SiTCPXG_Inst : WRAP_SiTCPXG_XC7K_128K
    generic map(
      RxBufferSize	=> "LongLong"
      )
    port map(
      REG_FPGA_VER              => kCurrentVersion,
      REG_FPGA_ID               => X"00000000",
      
      --		==== System I/F ====
      FORCE_DEFAULTn            => dip_sw(kSiTCP.Index),
      XGMII_CLOCK               => clk_xgmii,
      RSTs                      => system_reset,
      
      --		==== XGMII I/F ====
      XGMII_RXC 								=> xgmii_rxc,
      XGMII_RXD 								=> xgmii_rxd,
      XGMII_TXC									=> xgmii_txc,
			XGMII_TXD									=> xgmii_txd,
      
      --		==== 93C46 I/F ====
			EEPROM_CS									=> EEP_CS,
			EEPROM_SK									=> EEP_SK,
			EEPROM_DI									=> EEP_DI,
      EEPROM_DO									=> EEP_DO,
      
      --		==== User I/F ====
      SiTCP_RESET_OUT	          => emergency_reset,
      --		--- RBCP ---
			RBCP_ACT                  => rbcp_act,
			RBCP_ADDR                 => rbcp_addr,
			RBCP_WE										=> rbcp_we,
			RBCP_WD										=> rbcp_wd,
			RBCP_RE										=> rbcp_re,
      RBCP_ACK                  => rbcp_ack,
			RBCP_RD	                  => rbcp_rd,
      -- --- TCP ---
      USER_SESSION_OPEN_REQ	    => '0',
		 	USER_SESSION_ESTABLISHED  => tcp_is_active,
		 	USER_SESSION_CLOSE_REQ    => close_req,
      USER_SESSION_CLOSE_ACK    => close_ack,
      USER_TX_D                 => tcp_txd,
      USER_TX_B	                => tcp_txb,
		 	USER_TX_AFULL             => tcp_tx_afull,
      USER_RX_SIZE              => X"FFF0",
		 	USER_RX_CLR_ENB	          => tcp_rx_clr_enb,
      USER_RX_CLR_REQ           => tcp_rx_clr_enb,
      USER_RX_RADR 							=> tcp_rx_wadr,
      USER_RX_WADR 							=> tcp_rx_wadr,
      USER_RX_WENB 							=> open,
      USER_RX_WDAT 							=> open
	);

  u_gTCP_inst : entity mylib.global_sitcp_manager
    port map(
      RST           => system_reset,
      CLK           => clk_xgmii,
      ACTIVE        => tcp_is_active,
      REQ           => close_req,
      ACT           => close_ack,
      rstFromTCP    => open
      );

  
  -- GTX transceiver -------------------------------------------------------------------
  u_PCSPMA_Inst : ten_gig_eth_pcs_pma
    port map(
      -- Core block --
      refclk_p              => GTX_REFCLK_P,
      refclk_n              => GTX_REFCLK_N,
      reset                 => core_master_reset,
      resetdone_out         => open,
      coreclk_out           => clk_xgmii,
      
      -- Tranceiver --
      txp 									=> GTX_TX_P,
      txn 									=> GTX_TX_N,
      rxp 									=> GTX_RX_P,
      rxn 									=> GTX_RX_N,

      -- SFP+ IF --
      signal_detect         => '1',
      tx_disable            => open,
      tx_fault              => '0',

      -- XGMII --
      xgmii_txd             => xgmii_txd,
      xgmii_txc             => xgmii_txc,
      xgmii_rxd             => xgmii_rxd,
      xgmii_rxc             => xgmii_rxc,

      -- MDIO --
      mdc                   => '1',
      mdio_in               => '1',
      mdio_out              => open,
      mdio_tri              => open,
      prtad                 => "00000",

      -- DRP IF --
      dclk                  => clk_xgmii,
      drp_req               => drp_req,
      drp_gnt               => drp_req,

      drp_den_o             => drp_den,
      drp_dwe_o             => drp_dwe,
      drp_daddr_o           => drp_addr,
      drp_di_o              => drp_di,
      drp_drdy_o            => drp_drdy,
      drp_drpdo_o           => drp_drpdo,
      drp_den_i             => drp_den,
      drp_dwe_i             => drp_dwe,
      drp_daddr_i           => drp_addr,
      drp_di_i              => drp_di,
      drp_drdy_i            => drp_drdy,
      drp_drpdo_i           => drp_drpdo,

      -- mics --
      pma_pmd_type          => "111",
      core_status           => open,
      sim_speedup_control   => '0',
      
      txusrclk_out          => open,
      txusrclk2_out         => open,
      rxrecclk_out          => open,
      areset_datapathclk_out => open,
      gttxreset_out         => open,
      gtrxreset_out         => open,
      txuserrdy_out         => open,
      reset_counter_done_out => open,
      qplllock_out          => qpll_locked,
      qplloutclk_out        => open,
      qplloutrefclk_out     => open
      );


  -- Clock inst ------------------------------------------------------------------------
  u_ClkMan_Inst   : clk_wiz_sys
    port map ( 
      -- Clock out ports  
      clk_sys         => open,
      clk_spi         => clk_spi,
      clk_icap_ce     => clk_sys_locked,
      clk_icap        => clk_icap,
      -- Status and control signals                
      reset           => '0',
      locked          => clk_sys_locked,
      -- Clock in ports
      clk_in1_p       => BASE_CLKP,
      clk_in1_n       => BASE_CLKN
      );

end Behavioral;
