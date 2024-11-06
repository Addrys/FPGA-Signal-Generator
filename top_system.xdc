# clock 
set_property PACKAGE_PIN W5 [get_ports {CLK}]
	set_property IOSTANDARD LVCMOS33 [get_ports {CLK}]

#RST
set_property PACKAGE_PIN T18 [get_ports {RST}]
	set_property IOSTANDARD LVCMOS33 [get_ports {RST}]

##USB-RS232 Interface
set_property PACKAGE_PIN B18 [get_ports RX]						
	set_property IOSTANDARD LVCMOS33 [get_ports RX]
	

# DAC (JC)
    set_property PACKAGE_PIN K17 [get_ports {SYNC}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {SYNC}]
    set_property PACKAGE_PIN P18 [get_ports {SCLK}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {SCLK}]
    set_property PACKAGE_PIN M18 [get_ports {DIN}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {DIN}]
	

##7 segment display
set_property PACKAGE_PIN W7 [get_ports {SEG_AG[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SEG_AG[0]}]
set_property PACKAGE_PIN W6 [get_ports {SEG_AG[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SEG_AG[1]}]
set_property PACKAGE_PIN U8 [get_ports {SEG_AG[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SEG_AG[2]}]
set_property PACKAGE_PIN V8 [get_ports {SEG_AG[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SEG_AG[3]}]
set_property PACKAGE_PIN U5 [get_ports {SEG_AG[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SEG_AG[4]}]
set_property PACKAGE_PIN V5 [get_ports {SEG_AG[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SEG_AG[5]}]
set_property PACKAGE_PIN U7 [get_ports {SEG_AG[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SEG_AG[6]}]

set_property PACKAGE_PIN U2 [get_ports {AND_30[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {AND_30[0]}]
set_property PACKAGE_PIN U4 [get_ports {AND_30[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {AND_30[1]}]
set_property PACKAGE_PIN V4 [get_ports {AND_30[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {AND_30[2]}]
set_property PACKAGE_PIN W4 [get_ports {AND_30[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {AND_30[3]}]

set_property PACKAGE_PIN V7 [get_ports {DP}]					
    set_property IOSTANDARD LVCMOS33 [get_ports {DP}]	
	
	
#led error_recp
set_property PACKAGE_PIN U16 [get_ports {LED}]                        
    set_property IOSTANDARD LVCMOS33 [get_ports {LED}]

	
        
      