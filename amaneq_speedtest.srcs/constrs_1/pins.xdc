#  ---------------------------------------------------------------------
# Pin assign --
#  ---------------------------------------------------------------------

# System ---------------------------------------------------------------
set_property PACKAGE_PIN E22 [get_ports PROGB_ON]
set_property PACKAGE_PIN F22 [get_ports BASE_CLKP]
set_property PACKAGE_PIN E23 [get_ports BASE_CLKN]
set_property PACKAGE_PIN H9 [get_ports USR_RSTB]
set_property PACKAGE_PIN U7 [get_ports LED[1]]
set_property PACKAGE_PIN V6 [get_ports LED[2]]
set_property PACKAGE_PIN V4 [get_ports LED[3]]
set_property PACKAGE_PIN W3 [get_ports LED[4]]
set_property PACKAGE_PIN U5 [get_ports DIP[1]]
set_property PACKAGE_PIN U6 [get_ports DIP[2]]
set_property PACKAGE_PIN U2 [get_ports DIP[3]]
set_property PACKAGE_PIN U1 [get_ports DIP[4]]
set_property PACKAGE_PIN N12 [get_ports VP]
set_property PACKAGE_PIN P11 [get_ports VN]

# GTX ------------------------------------------------------------------
set_property PACKAGE_PIN D6 [get_ports GTX_REFCLK_P]
set_property PACKAGE_PIN D5 [get_ports GTX_REFCLK_N]
set_property PACKAGE_PIN F2 [get_ports GTX_TX_P]
set_property PACKAGE_PIN G4 [get_ports GTX_RX_P]
set_property PACKAGE_PIN F1 [get_ports GTX_TX_N]
set_property PACKAGE_PIN G3 [get_ports GTX_RX_N]
#set_property PACKAGE_PIN D2 [get_ports GTX_TX_P[1]]
#set_property PACKAGE_PIN E4 [get_ports GTX_RX_P[1]]
#set_property PACKAGE_PIN D1 [get_ports GTX_TX_N[1]]
#set_property PACKAGE_PIN E3 [get_ports GTX_RX_N[1]]

# SPI flash ------------------------------------------------------------
set_property PACKAGE_PIN B24 [get_ports MOSI]
set_property PACKAGE_PIN A25 [get_ports DIN]
set_property PACKAGE_PIN C23 [get_ports FCSB]

# EXBASE connector -----------------------------------------------------

# EEPROM ---------------------------------------------------------------
set_property PACKAGE_PIN C21 [get_ports EEP_CS]
set_property PACKAGE_PIN C22 [get_ports EEP_SK]
set_property PACKAGE_PIN D21 [get_ports EEP_DI]
set_property PACKAGE_PIN E21 [get_ports EEP_DO]
#set_property PACKAGE_PIN D23 [get_ports EEP_CS[2]]
#set_property PACKAGE_PIN C24 [get_ports EEP_SK[2]]
#set_property PACKAGE_PIN D24 [get_ports EEP_DI[2]]
#set_property PACKAGE_PIN D25 [get_ports EEP_DO[2]]

# NIM-IO ---------------------------------------------------------------
set_property PACKAGE_PIN V8 [get_ports NIM_IN[1]]
set_property PACKAGE_PIN V7 [get_ports NIM_IN[2]]
set_property PACKAGE_PIN V11 [get_ports NIM_OUT[1]]
set_property PACKAGE_PIN W11 [get_ports NIM_OUT[2]]

# JItter cleaner -------------------------------------------------------

# Belle2 Link ----------------------------------------------------------

# Main port ------------------------------------------------------------
# Up port --
set_property PACKAGE_PIN C9 [get_ports MAIN_IN_U[0]]
set_property PACKAGE_PIN B9 [get_ports MAIN_IN_U[1]]
set_property PACKAGE_PIN G9 [get_ports MAIN_IN_U[2]]
set_property PACKAGE_PIN F10 [get_ports MAIN_IN_U[3]]
set_property PACKAGE_PIN G10 [get_ports MAIN_IN_U[4]]
set_property PACKAGE_PIN H11 [get_ports MAIN_IN_U[5]]
set_property PACKAGE_PIN G11 [get_ports MAIN_IN_U[6]]
set_property PACKAGE_PIN C12 [get_ports MAIN_IN_U[7]]
set_property PACKAGE_PIN F9 [get_ports MAIN_IN_U[8]]
set_property PACKAGE_PIN D9 [get_ports MAIN_IN_U[9]]
set_property PACKAGE_PIN E10 [get_ports MAIN_IN_U[10]]
set_property PACKAGE_PIN D10 [get_ports MAIN_IN_U[11]]
set_property PACKAGE_PIN E11 [get_ports MAIN_IN_U[12]]
set_property PACKAGE_PIN C11 [get_ports MAIN_IN_U[13]]
set_property PACKAGE_PIN F12 [get_ports MAIN_IN_U[14]]
set_property PACKAGE_PIN E12 [get_ports MAIN_IN_U[15]]
set_property PACKAGE_PIN H12 [get_ports MAIN_IN_U[16]]
set_property PACKAGE_PIN H13 [get_ports MAIN_IN_U[17]]
set_property PACKAGE_PIN D13 [get_ports MAIN_IN_U[18]]
set_property PACKAGE_PIN D14 [get_ports MAIN_IN_U[19]]
set_property PACKAGE_PIN A9 [get_ports MAIN_IN_U[20]]
set_property PACKAGE_PIN A10 [get_ports MAIN_IN_U[21]]
set_property PACKAGE_PIN B11 [get_ports MAIN_IN_U[22]]
set_property PACKAGE_PIN B12 [get_ports MAIN_IN_U[23]]
set_property PACKAGE_PIN A12 [get_ports MAIN_IN_U[24]]
set_property PACKAGE_PIN A13 [get_ports MAIN_IN_U[25]]
set_property PACKAGE_PIN C13 [get_ports MAIN_IN_U[26]]
set_property PACKAGE_PIN C14 [get_ports MAIN_IN_U[27]]
set_property PACKAGE_PIN A14 [get_ports MAIN_IN_U[28]]
set_property PACKAGE_PIN B14 [get_ports MAIN_IN_U[29]]
set_property PACKAGE_PIN B15 [get_ports MAIN_IN_U[30]]
set_property PACKAGE_PIN A15 [get_ports MAIN_IN_U[31]]
# Down port --
set_property PACKAGE_PIN F13 [get_ports MAIN_IN_D[0]]
set_property PACKAGE_PIN E13 [get_ports MAIN_IN_D[1]]
set_property PACKAGE_PIN G14 [get_ports MAIN_IN_D[2]]
set_property PACKAGE_PIN F14 [get_ports MAIN_IN_D[3]]
set_property PACKAGE_PIN G15 [get_ports MAIN_IN_D[4]]
set_property PACKAGE_PIN H16 [get_ports MAIN_IN_D[5]]
set_property PACKAGE_PIN H17 [get_ports MAIN_IN_D[6]]
set_property PACKAGE_PIN G17 [get_ports MAIN_IN_D[7]]
set_property PACKAGE_PIN E15 [get_ports MAIN_IN_D[8]]
set_property PACKAGE_PIN D15 [get_ports MAIN_IN_D[9]]
set_property PACKAGE_PIN G16 [get_ports MAIN_IN_D[10]]
set_property PACKAGE_PIN E16 [get_ports MAIN_IN_D[11]]
set_property PACKAGE_PIN F17 [get_ports MAIN_IN_D[12]]
set_property PACKAGE_PIN E17 [get_ports MAIN_IN_D[13]]
set_property PACKAGE_PIN E18 [get_ports MAIN_IN_D[14]]
set_property PACKAGE_PIN D18 [get_ports MAIN_IN_D[15]]
set_property PACKAGE_PIN G19 [get_ports MAIN_IN_D[16]]
set_property PACKAGE_PIN F19 [get_ports MAIN_IN_D[17]]
set_property PACKAGE_PIN E20 [get_ports MAIN_IN_D[18]]
set_property PACKAGE_PIN D20 [get_ports MAIN_IN_D[19]]
set_property PACKAGE_PIN C16 [get_ports MAIN_IN_D[20]]
set_property PACKAGE_PIN B16 [get_ports MAIN_IN_D[21]]
set_property PACKAGE_PIN D16 [get_ports MAIN_IN_D[22]]
set_property PACKAGE_PIN C17 [get_ports MAIN_IN_D[23]]
set_property PACKAGE_PIN A17 [get_ports MAIN_IN_D[24]]
set_property PACKAGE_PIN B17 [get_ports MAIN_IN_D[25]]
set_property PACKAGE_PIN C18 [get_ports MAIN_IN_D[26]]
set_property PACKAGE_PIN A18 [get_ports MAIN_IN_D[27]]
set_property PACKAGE_PIN B19 [get_ports MAIN_IN_D[28]]
set_property PACKAGE_PIN A19 [get_ports MAIN_IN_D[29]]
set_property PACKAGE_PIN C19 [get_ports MAIN_IN_D[30]]
set_property PACKAGE_PIN D19 [get_ports MAIN_IN_D[31]]

# Mezzanine slot -------------------------------------------------------
# Up slot --
# Dwon slot --

# DDR3 SDRAM -----------------------------------------------------------
#  ---------------------------------------------------------------------
# Port attribute --
#  ---------------------------------------------------------------------

# System ---------------------------------------------------------------
set_property IOSTANDARD LVCMOS25 [get_ports PROGB_ON]
set_property IOSTANDARD LVDS_25 [get_ports BASE_CLKP]
set_property DIFF_TERM TRUE [get_ports BASE_CLKP]
set_property IOSTANDARD LVCMOS33 [get_ports USR_RSTB]
set_property IOSTANDARD LVCMOS15 [get_ports LED[*]]
set_property IOSTANDARD LVCMOS15 [get_ports DIP[*]]
set_property PULLUP TRUE [get_ports DIP[*]]

# GTX ------------------------------------------------------------------

# SPI flash ------------------------------------------------------------
set_property IOSTANDARD LVCMOS25 [get_ports MOSI]
set_property IOB TRUE [get_ports MOSI]
set_property IOSTANDARD LVCMOS25 [get_ports DIN]
set_property IOB TRUE [get_ports DIN]
set_property IOSTANDARD LVCMOS25 [get_ports FCSB]
set_property IOB TRUE [get_ports FCSB]

# EXBASE connector -----------------------------------------------------

# EEPROM ---------------------------------------------------------------
set_property IOSTANDARD LVCMOS25 [get_ports EEP_CS]
set_property IOSTANDARD LVCMOS25 [get_ports EEP_SK]
set_property IOSTANDARD LVCMOS25 [get_ports EEP_DI]
set_property IOSTANDARD LVCMOS25 [get_ports EEP_DO]

# NIM-IO ---------------------------------------------------------------
set_property IOSTANDARD LVCMOS15 [get_ports NIM_IN[*]]
set_property IOSTANDARD LVCMOS15 [get_ports NIM_OUT[*]]

# JItter cleaner -------------------------------------------------------

# Belle2 Link ----------------------------------------------------------

# Main port ------------------------------------------------------------
# Up port --
set_property IOSTANDARD LVCMOS33 [get_ports MAIN_IN_U[*]]
# Down port --
set_property IOSTANDARD LVCMOS33 [get_ports MAIN_IN_D[*]]

# Mezzanine slot -------------------------------------------------------
# Up slot --
# Dwon slot --

# DDR3 SDRAM -----------------------------------------------------------
