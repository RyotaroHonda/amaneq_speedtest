# Clock definition
#create_clock -name clk_in -period 8 -waveform {0 4} [get_ports PHY_RX_CLK]

#create_clock -period 7.692 -name clk_b2tt -waveform {0.000 3.846} [get_ports RJ45_TRG_P]
#set_input_jitter clk_b2tt 0.100

# SiTCP
#set_false_path -through [get_nets gen_SiTCP[*].u_SiTCP_Inst/SiTCP/SiTCP_INT/SiTCP_INT_REG/regX11Data*]
#set_false_path -through [get_nets gen_SiTCP[*].u_SiTCP_Inst/SiTCP/SiTCP_INT/SiTCP_INT_REG/regX12Data*]
#set_false_path -through [get_nets gen_SiTCP[*].u_SiTCP_Inst/SiTCP/SiTCP_INT/SiTCP_INT_REG/regX13Data*]
#set_false_path -through [get_nets gen_SiTCP[*].u_SiTCP_Inst/SiTCP/SiTCP_INT/SiTCP_INT_REG/regX14Data*]
#set_false_path -through [get_nets gen_SiTCP[*].u_SiTCP_Inst/SiTCP/SiTCP_INT/SiTCP_INT_REG/regX15Data*]
#set_false_path -through [get_nets gen_SiTCP[*].u_SiTCP_Inst/SiTCP/SiTCP_INT/SiTCP_INT_REG/regX16Data*]
#set_false_path -through [get_nets gen_SiTCP[*].u_SiTCP_Inst/SiTCP/SiTCP_INT/SiTCP_INT_REG/regX17Data*]
#set_false_path -through [get_nets gen_SiTCP[*].u_SiTCP_Inst/SiTCP/SiTCP_INT/SiTCP_INT_REG/regX18Data*]
#set_false_path -through [get_nets gen_SiTCP[*].u_SiTCP_Inst/SiTCP/SiTCP_INT/SiTCP_INT_REG/regX19Data*]
#set_false_path -through [get_nets gen_SiTCP[*].u_SiTCP_Inst/SiTCP/SiTCP_INT/SiTCP_INT_REG/regX1AData*]
#set_false_path -through [get_nets gen_SiTCP[*].u_SiTCP_Inst/SiTCP/SiTCP_INT/SiTCP_INT_REG/regX1BData*]
#set_false_path -through [get_nets gen_SiTCP[*].u_SiTCP_Inst/SiTCP/BBT_SiTCP_RST/resetReq*]
#set_false_path -through [get_nets gen_SiTCP[*].u_SiTCP_Inst/SiTCP/GMII/GMII_TXBUF/memRdReq*]
#set_false_path -through [get_nets gen_SiTCP[*].u_SiTCP_Inst/SiTCP/GMII/GMII_TXBUF/orRdAct*]
#set_false_path -through [get_nets gen_SiTCP[*].u_SiTCP_Inst/SiTCP/GMII/GMII_TXBUF/dlyBank0LastWrAddr*]
#set_false_path -through [get_nets gen_SiTCP[*].u_SiTCP_Inst/SiTCP/GMII/GMII_TXBUF/dlyBank1LastWrAddr*]
#set_false_path -through [get_nets gen_SiTCP[*].u_SiTCP_Inst/SiTCP/GMII/GMII_TXBUF/muxEndTgl]

create_generated_clock -name clk_sys     [get_pins u_ClkMan_Inst/inst/mmcm_adv_inst/CLKOUT0]
create_generated_clock -name clk_spi     [get_pins u_ClkMan_Inst/inst/mmcm_adv_inst/CLKOUT1]
create_generated_clock -name clk_icap    [get_pins u_ClkMan_Inst/inst/mmcm_adv_inst/CLKOUT2]

#create_generated_clock -name clk_gmii1 [get_pins u_GtClockDist_Inst/core_clocking_i/mmcm_adv_inst/CLKOUT0]
#create_generated_clock -name clk_gmii2 [get_pins u_GtClockDist_Inst/core_clocking_i/mmcm_adv_inst/CLKOUT1]
#create_generated_clock -name clk_gmii1   [get_pins gen_pcspma[0].u_pcspma_Inst/core_support_i/core_clocking_i/mmcm_adv_inst/CLKOUT0]
#create_generated_clock -name clk_gmii2   [get_pins gen_pcspma[1].u_pcspma_Inst/core_support_i/core_clocking_i/mmcm_adv_inst/CLKOUT0]

#create_generated_clock -name clk_base     [get_pins u_ClkTdc_Inst/inst/plle2_adv_inst/CLKOUT0]
#create_generated_clock -name clk_tdc0     [get_pins u_ClkTdc_Inst/inst/plle2_adv_inst/CLKOUT1]
#create_generated_clock -name clk_tdc90    [get_pins u_ClkTdc_Inst/inst/plle2_adv_inst/CLKOUT2]
#create_generated_clock -name clk_tdc180   [get_pins u_ClkTdc_Inst/inst/plle2_adv_inst/CLKOUT3]
#create_generated_clock -name clk_tdc270   [get_pins u_ClkTdc_Inst/inst/plle2_adv_inst/CLKOUT4]

#set_multicycle_path -setup -from [get_clocks clk_tdc270] -to [get_clocks clk_tdc0] 2

set_clock_groups -name async_sys_xgmii -asynchronous \
    -group clk_sys \
    -group clk_spi \
    -group clk_icap \
    -group GTX_REFCLK_P


#set_clock_groups -name async_sys_indep -asynchronous -group clk_sys 
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets clk_b2tt_raw]

set_false_path -through [get_ports {LED[1]}]
set_false_path -through [get_ports {LED[2]}]
set_false_path -through [get_ports {LED[3]}]
set_false_path -through [get_ports {LED[4]}]

#set_false_path -through [get_nets u_BCT_Inst/rst_from_bus]







