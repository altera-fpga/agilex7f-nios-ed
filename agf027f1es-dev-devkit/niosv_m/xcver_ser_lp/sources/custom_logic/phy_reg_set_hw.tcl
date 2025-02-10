package require qsys 19.1


# module properties
set_module_property NAME {phy_reg_set}
set_module_property DISPLAY_NAME {Phy Register Set}

# default module properties
set_module_property VERSION {22.2}
set_module_property GROUP {default group}
set_module_property DESCRIPTION {default description}
set_module_property AUTHOR {Peter Schepers - Intel PSG}



proc compose { } {

    set NPHYS [get_parameter_value NPHYS]
    set NAVMM_PER_PHY [get_parameter_value NAVMM_PER_PHY] 
	 
    # Instances and instance parameters
    # (disabled instances are intentionally culled)
 
    add_instance clk_0 altera_clock_bridge 19.*
    set_instance_parameter_value clk_0 {EXPLICIT_CLOCK_RATE} {125000000.0}
    set_instance_parameter_value clk_0 {NUM_CLOCK_OUTPUTS} {1}

    add_instance reset_0 altera_reset_bridge 19.*
    set_instance_parameter_value reset_0 {ACTIVE_LOW_RESET} {0}
    set_instance_parameter_value reset_0 {NUM_RESET_OUTPUTS} {1}
    set_instance_parameter_value reset_0 {SYNCHRONOUS_EDGES} {deassert}
    set_instance_parameter_value reset_0 {SYNC_RESET} {1}
    set_instance_parameter_value reset_0 {USE_RESET_REQUEST} {0}	 

	 add_connection clk_0.out_clk reset_0.clk clock

	 
    add_instance mm_bridge altera_avalon_mm_bridge 20.*
    set_instance_parameter_value mm_bridge {DATA_WIDTH} {32}
    set_instance_parameter_value mm_bridge {SYMBOL_WIDTH} {8}
    set_instance_parameter_value mm_bridge {ADDRESS_WIDTH} {4}
    set_instance_parameter_value mm_bridge {USE_AUTO_ADDRESS_WIDTH} {1}
    set_instance_parameter_value mm_bridge {ADDRESS_UNITS} {WORDS}
    set_instance_parameter_value mm_bridge {MAX_BURST_SIZE} {1}
    set_instance_parameter_value mm_bridge {MAX_PENDING_RESPONSES} {1}
    set_instance_parameter_value mm_bridge {LINEWRAPBURSTS} {0}
    set_instance_parameter_value mm_bridge {PIPELINE_COMMAND} {1}
    set_instance_parameter_value mm_bridge {PIPELINE_RESPONSE} {1}

    for {set i 0} {$i < $NPHYS} {incr i 1} {

	
    for {set j 0} {$j < $NAVMM_PER_PHY} {incr j 1} {	
	 		set z [expr ($NAVMM_PER_PHY)*$i + $j]
			
	add_instance reconfig_xcvr_$z reconfig_mgmt 1.1
	
	add_instance reconfig_pdp_$z reconfig_mgmt 1.1	
	
	}
	# $NAVMM_PER_PHY
	 
		add_instance control_reg_$i altera_avalon_pio 19.*
		set_instance_parameter_value control_reg_$i {bitClearingEdgeCapReg} {0}
		set_instance_parameter_value control_reg_$i {bitModifyingOutReg} {0}
		set_instance_parameter_value control_reg_$i {captureEdge} {1}
		set_instance_parameter_value control_reg_$i {direction} {Output}
		set_instance_parameter_value control_reg_$i {edgeType} {RISING}
		set_instance_parameter_value control_reg_$i {generateIRQ} {0}
		set_instance_parameter_value control_reg_$i {irqType} {LEVEL}
		set_instance_parameter_value control_reg_$i {resetValue} {0.0}
		set_instance_parameter_value control_reg_$i {simDoTestBenchWiring} {0}
		set_instance_parameter_value control_reg_$i {simDrivenValue} {0.0}
		set_instance_parameter_value control_reg_$i {width} {16}
		
		add_instance control2_reg_$i altera_avalon_pio 19.*
		set_instance_parameter_value control2_reg_$i {bitClearingEdgeCapReg} {0}
		set_instance_parameter_value control2_reg_$i {bitModifyingOutReg} {0}
		set_instance_parameter_value control2_reg_$i {captureEdge} {1}
		set_instance_parameter_value control2_reg_$i {direction} {Output}
		set_instance_parameter_value control2_reg_$i {edgeType} {RISING}
		set_instance_parameter_value control2_reg_$i {generateIRQ} {0}
		set_instance_parameter_value control2_reg_$i {irqType} {LEVEL}
		set_instance_parameter_value control2_reg_$i {resetValue} {0.0}
		set_instance_parameter_value control2_reg_$i {simDoTestBenchWiring} {0}
		set_instance_parameter_value control2_reg_$i {simDrivenValue} {0.0}
		set_instance_parameter_value control2_reg_$i {width} {16}		
		
		# add_instance adapt_sip_control_$i altera_avalon_pio 19.*
		# set_instance_parameter_value adapt_sip_control_$i {bitClearingEdgeCapReg} {0}
		# set_instance_parameter_value adapt_sip_control_$i {bitModifyingOutReg} {0}
		# set_instance_parameter_value adapt_sip_control_$i {captureEdge} {1}
		# set_instance_parameter_value adapt_sip_control_$i {direction} {Output}
		# set_instance_parameter_value adapt_sip_control_$i {edgeType} {RISING}
		# set_instance_parameter_value adapt_sip_control_$i {generateIRQ} {0}
		# set_instance_parameter_value adapt_sip_control_$i {irqType} {LEVEL}
		# set_instance_parameter_value adapt_sip_control_$i {resetValue} {0.0}
		# set_instance_parameter_value adapt_sip_control_$i {simDoTestBenchWiring} {0}
		# set_instance_parameter_value adapt_sip_control_$i {simDrivenValue} {0.0}
		# set_instance_parameter_value adapt_sip_control_$i {width} {32}
	
		# add_instance adapt_sip_control_treshold_reg_$i altera_avalon_pio 19.*
		# set_instance_parameter_value adapt_sip_control_treshold_reg_$i {bitClearingEdgeCapReg} {0}
		# set_instance_parameter_value adapt_sip_control_treshold_reg_$i {bitModifyingOutReg} {0}
		# set_instance_parameter_value adapt_sip_control_treshold_reg_$i {captureEdge} {1}
		# set_instance_parameter_value adapt_sip_control_treshold_reg_$i {direction} {Output}
		# set_instance_parameter_value adapt_sip_control_treshold_reg_$i {edgeType} {RISING}
		# set_instance_parameter_value adapt_sip_control_treshold_reg_$i {generateIRQ} {0}
		# set_instance_parameter_value adapt_sip_control_treshold_reg_$i {irqType} {LEVEL}
		# set_instance_parameter_value adapt_sip_control_treshold_reg_$i {resetValue} {0.0}
		# set_instance_parameter_value adapt_sip_control_treshold_reg_$i {simDoTestBenchWiring} {0}
		# set_instance_parameter_value adapt_sip_control_treshold_reg_$i {simDrivenValue} {0.0}
		# set_instance_parameter_value adapt_sip_control_treshold_reg_$i {width} {32}			

	# add_instance adapt_sip_status_$i altera_avalon_pio 19.*
	# set_instance_parameter_value adapt_sip_status_$i {bitClearingEdgeCapReg} {0}
	# set_instance_parameter_value adapt_sip_status_$i {bitModifyingOutReg} {0}
	# set_instance_parameter_value adapt_sip_status_$i {captureEdge} {1}
	# set_instance_parameter_value adapt_sip_status_$i {direction} {Input}
	# set_instance_parameter_value adapt_sip_status_$i {edgeType} {RISING}
	# set_instance_parameter_value adapt_sip_status_$i {generateIRQ} {0}
	# set_instance_parameter_value adapt_sip_status_$i {irqType} {LEVEL}
	# set_instance_parameter_value adapt_sip_status_$i {resetValue} {0.0}
	# set_instance_parameter_value adapt_sip_status_$i {simDoTestBenchWiring} {0}
	# set_instance_parameter_value adapt_sip_status_$i {simDrivenValue} {0.0}
	# set_instance_parameter_value adapt_sip_status_$i {width} {32}
	
		# add_instance reset_control_$i altera_avalon_pio 19.*
		# set_instance_parameter_value reset_control_$i {bitClearingEdgeCapReg} {0}
		# set_instance_parameter_value reset_control_$i {bitModifyingOutReg} {0}
		# set_instance_parameter_value reset_control_$i {captureEdge} {1}
		# set_instance_parameter_value reset_control_$i {direction} {Output}
		# set_instance_parameter_value reset_control_$i {edgeType} {RISING}
		# set_instance_parameter_value reset_control_$i {generateIRQ} {0}
		# set_instance_parameter_value reset_control_$i {irqType} {LEVEL}
		# set_instance_parameter_value reset_control_$i {resetValue} {0.0}
		# set_instance_parameter_value reset_control_$i {simDoTestBenchWiring} {0}
		# set_instance_parameter_value reset_control_$i {simDrivenValue} {0.0}
		# set_instance_parameter_value reset_control_$i {width} {32}		
	
	# add_instance reset_status_$i altera_avalon_pio 19.*
	# set_instance_parameter_value reset_status_$i {bitClearingEdgeCapReg} {0}
	# set_instance_parameter_value reset_status_$i {bitModifyingOutReg} {0}
	# set_instance_parameter_value reset_status_$i {captureEdge} {1}
	# set_instance_parameter_value reset_status_$i {direction} {Input}
	# set_instance_parameter_value reset_status_$i {edgeType} {RISING}
	# set_instance_parameter_value reset_status_$i {generateIRQ} {0}
	# set_instance_parameter_value reset_status_$i {irqType} {LEVEL}
	# set_instance_parameter_value reset_status_$i {resetValue} {0.0}
	# set_instance_parameter_value reset_status_$i {simDoTestBenchWiring} {0}
	# set_instance_parameter_value reset_status_$i {simDrivenValue} {0.0}
	# set_instance_parameter_value reset_status_$i {width} {32}
	

	add_instance bitrate_$i altera_avalon_pio 19.*
	set_instance_parameter_value bitrate_$i {bitClearingEdgeCapReg} {0}
	set_instance_parameter_value bitrate_$i {bitModifyingOutReg} {0}
	set_instance_parameter_value bitrate_$i {captureEdge} {1}
	set_instance_parameter_value bitrate_$i {direction} {Input}
	set_instance_parameter_value bitrate_$i {edgeType} {RISING}
	set_instance_parameter_value bitrate_$i {generateIRQ} {0}
	set_instance_parameter_value bitrate_$i {irqType} {LEVEL}
	set_instance_parameter_value bitrate_$i {resetValue} {0.0}
	set_instance_parameter_value bitrate_$i {simDoTestBenchWiring} {0}
	set_instance_parameter_value bitrate_$i {simDrivenValue} {0.0}
	set_instance_parameter_value bitrate_$i {width} {32}

	add_instance rxclock_$i altera_avalon_pio 19.*
	set_instance_parameter_value rxclock_$i {bitClearingEdgeCapReg} {0}
	set_instance_parameter_value rxclock_$i {bitModifyingOutReg} {0}
	set_instance_parameter_value rxclock_$i {captureEdge} {1}
	set_instance_parameter_value rxclock_$i {direction} {Input}
	set_instance_parameter_value rxclock_$i {edgeType} {RISING}
	set_instance_parameter_value rxclock_$i {generateIRQ} {0}
	set_instance_parameter_value rxclock_$i {irqType} {LEVEL}
	set_instance_parameter_value rxclock_$i {resetValue} {0.0}
	set_instance_parameter_value rxclock_$i {simDoTestBenchWiring} {0}
	set_instance_parameter_value rxclock_$i {simDrivenValue} {0.0}
	set_instance_parameter_value rxclock_$i {width} {32}
	
	add_instance counter_1ms_reg_$i altera_avalon_pio 19.*
	set_instance_parameter_value counter_1ms_reg_$i {bitClearingEdgeCapReg} {0}
	set_instance_parameter_value counter_1ms_reg_$i {bitModifyingOutReg} {0}
	set_instance_parameter_value counter_1ms_reg_$i {captureEdge} {1}
	set_instance_parameter_value counter_1ms_reg_$i {direction} {Input}
	set_instance_parameter_value counter_1ms_reg_$i {edgeType} {RISING}
	set_instance_parameter_value counter_1ms_reg_$i {generateIRQ} {0}
	set_instance_parameter_value counter_1ms_reg_$i {irqType} {LEVEL}
	set_instance_parameter_value counter_1ms_reg_$i {resetValue} {0.0}
	set_instance_parameter_value counter_1ms_reg_$i {simDoTestBenchWiring} {0}
	set_instance_parameter_value counter_1ms_reg_$i {simDrivenValue} {0.0}
	set_instance_parameter_value counter_1ms_reg_$i {width} {32}




	
	
    } 	 
	 # $NPHYS

    # connections and connection parameters
    add_connection clk_0.out_clk mm_bridge.clk clock

    add_connection reset_0.out_reset mm_bridge.reset reset
	 

    set ia 0
	 
	 


    for {set i 0} {$i < $NPHYS} {incr i 1} {
	
	
    for {set j 0} {$j < $NAVMM_PER_PHY} {incr j 1} {	
	 		set z [expr ($NAVMM_PER_PHY)*$i + $j]
			
	add_connection clk_0.out_clk reconfig_xcvr_$z.clock clock

	add_connection clk_0.out_clk reconfig_pdp_$z.clock clock		
	 }	

	
	 
	add_connection clk_0.out_clk control_reg_$i.clk clock	 

	add_connection clk_0.out_clk control2_reg_$i.clk clock	
	
	# add_connection clk_0.out_clk adapt_sip_control_$i.clk clock		
	
	# add_connection clk_0.out_clk adapt_sip_control_treshold_reg_$i.clk clock			
	
	# add_connection clk_0.out_clk adapt_sip_status_$i.clk clock
	
	# add_connection clk_0.out_clk reset_control_$i.clk clock

	# add_connection clk_0.out_clk reset_status_$i.clk clock	

	add_connection clk_0.out_clk bitrate_$i.clk clock

	add_connection clk_0.out_clk rxclock_$i.clk clock
	
	add_connection clk_0.out_clk counter_1ms_reg_$i.clk clock

	


	
    for {set j 0} {$j < $NAVMM_PER_PHY} {incr j 1} {	
	 		set z [expr ($NAVMM_PER_PHY)*$i + $j]
			
	add_connection reset_0.out_reset reconfig_xcvr_$z.reset reset
	
	add_connection reset_0.out_reset reconfig_pdp_$z.reset reset	
	
	}
	
	
	add_connection reset_0.out_reset control_reg_$i.reset reset	

	add_connection reset_0.out_reset control2_reg_$i.reset reset	

	# add_connection clk_0.out_clk_reset adapt_sip_control_$i.reset reset		
	
	# add_connection clk_0.out_clk_reset adapt_sip_control_treshold_reg_$i.reset reset		

	# add_connection clk_0.out_clk_reset adapt_sip_status_$i.reset reset
	
	# add_connection clk_0.out_clk_reset reset_control_$i.reset reset		

	# add_connection clk_0.out_clk_reset reset_status_$i.reset reset	

	add_connection reset_0.out_reset bitrate_$i.reset reset

	add_connection reset_0.out_reset rxclock_$i.reset reset
	
	add_connection reset_0.out_reset counter_1ms_reg_$i.reset reset

	
		for {set j 0} {$j < $NAVMM_PER_PHY} {incr j 1} {	
	 		set z [expr ($NAVMM_PER_PHY)*$i + $j]
		add_connection mm_bridge.m0 reconfig_xcvr_$z.s0 avalon
		set_connection_parameter_value mm_bridge.m0/reconfig_xcvr_$z.s0 arbitrationPriority {1}
		set_connection_parameter_value mm_bridge.m0/reconfig_xcvr_$z.s0 baseAddress $ia
		set_connection_parameter_value mm_bridge.m0/reconfig_xcvr_$z.s0 defaultConnection {0}
		
	
		set myparamname RECONFIG_XCVR_
		append myparamname $z _OFFSET

		set_module_assignment embeddedsw.CMacro.$myparamname $ia
	
		set ia [expr $ia + 0x1000000]
		
		}

		for {set j 0} {$j < $NAVMM_PER_PHY} {incr j 1} {	
	 		set z [expr ($NAVMM_PER_PHY)*$i + $j]		
		add_connection mm_bridge.m0 reconfig_pdp_$z.s0 avalon
		set_connection_parameter_value mm_bridge.m0/reconfig_pdp_$z.s0 arbitrationPriority {1}
		set_connection_parameter_value mm_bridge.m0/reconfig_pdp_$z.s0 baseAddress $ia
		set_connection_parameter_value mm_bridge.m0/reconfig_pdp_$z.s0 defaultConnection {0}
	
		set myparamname RECONFIG_PDP_
		append myparamname $z _OFFSET
		set_module_assignment embeddedsw.CMacro.$myparamname $ia
	
		set ia [expr $ia + 0x1000000]
		}

		

	}
	
		for {set i 0} {$i < $NPHYS} {incr i 1} {
	
		add_connection mm_bridge.m0 control_reg_$i.s1 avalon
		set_connection_parameter_value mm_bridge.m0/control_reg_$i.s1 arbitrationPriority {1}
		set_connection_parameter_value mm_bridge.m0/control_reg_$i.s1 baseAddress $ia
		set_connection_parameter_value mm_bridge.m0/control_reg_$i.s1 defaultConnection {0}
	
		set myparamname CONTROL_REG_
		append myparamname $i _OFFSET
		set_module_assignment embeddedsw.CMacro.$myparamname $ia
	
		set ia [expr $ia + 0x10]
		

		add_connection mm_bridge.m0 control2_reg_$i.s1 avalon
		set_connection_parameter_value mm_bridge.m0/control2_reg_$i.s1 arbitrationPriority {1}
		set_connection_parameter_value mm_bridge.m0/control2_reg_$i.s1 baseAddress $ia
		set_connection_parameter_value mm_bridge.m0/control2_reg_$i.s1 defaultConnection {0}
	
		set myparamname CONTROL2_REG_
		append myparamname $i _OFFSET
		set_module_assignment embeddedsw.CMacro.$myparamname $ia
	
		set ia [expr $ia + 0x10]


		# add_connection mm_bridge.m0 adapt_sip_control_$i.s1 avalon
		# set_connection_parameter_value mm_bridge.m0/adapt_sip_control_$i.s1 arbitrationPriority {1}
		# set_connection_parameter_value mm_bridge.m0/adapt_sip_control_$i.s1 baseAddress $ia
		# set_connection_parameter_value mm_bridge.m0/adapt_sip_control_$i.s1 defaultConnection {0}
	
		# set myparamname ADAPT_SIP_CONTROL_
		# append myparamname $i _OFFSET
		# set_module_assignment embeddedsw.CMacro.$myparamname $ia
	
		# set ia [expr $ia + 0x10]
		
		# add_connection mm_bridge.m0 adapt_sip_control_treshold_reg_$i.s1 avalon
		# set_connection_parameter_value mm_bridge.m0/adapt_sip_control_treshold_reg_$i.s1 arbitrationPriority {1}
		# set_connection_parameter_value mm_bridge.m0/adapt_sip_control_treshold_reg_$i.s1 baseAddress $ia
		# set_connection_parameter_value mm_bridge.m0/adapt_sip_control_treshold_reg_$i.s1 defaultConnection {0}
	
		# set myparamname ADAPT_SIP_CONTROL_TRESHOLD_REG_
		# append myparamname $i _OFFSET
		# set_module_assignment embeddedsw.CMacro.$myparamname $ia
	
		# set ia [expr $ia + 0x10]		
		
	

	# add_connection mm_bridge.m0 adapt_sip_status_$i.s1 avalon
	# set_connection_parameter_value mm_bridge.m0/adapt_sip_status_$i.s1 arbitrationPriority {1}
	# set_connection_parameter_value mm_bridge.m0/adapt_sip_status_$i.s1 baseAddress $ia
	# set_connection_parameter_value mm_bridge.m0/adapt_sip_status_$i.s1 defaultConnection {0}
	
	# set myparamname ADAPT_SIP_STATUS_
	# append myparamname $i "_OFFSET"
	
	# set_module_assignment embeddedsw.CMacro.$myparamname $ia
	
        # set ia [expr $ia + 16]
		  

		# add_connection mm_bridge.m0 reset_control_$i.s1 avalon
		# set_connection_parameter_value mm_bridge.m0/reset_control_$i.s1 arbitrationPriority {1}
		# set_connection_parameter_value mm_bridge.m0/reset_control_$i.s1 baseAddress $ia
		# set_connection_parameter_value mm_bridge.m0/reset_control_$i.s1 defaultConnection {0}
	
		# set myparamname RESET_CONTROL_
		# append myparamname $i _OFFSET
		# set_module_assignment embeddedsw.CMacro.$myparamname $ia
	
		# set ia [expr $ia + 0x10]


		# add_connection mm_bridge.m0 reset_status_$i.s1 avalon
		# set_connection_parameter_value mm_bridge.m0/reset_status_$i.s1 arbitrationPriority {1}
		# set_connection_parameter_value mm_bridge.m0/reset_status_$i.s1 baseAddress $ia
		# set_connection_parameter_value mm_bridge.m0/reset_status_$i.s1 defaultConnection {0}
	
		# set myparamname RESET_STATUS_
		# append myparamname $i _OFFSET
		# set_module_assignment embeddedsw.CMacro.$myparamname $ia
	
		# set ia [expr $ia + 0x10]
		

	add_connection mm_bridge.m0 bitrate_$i.s1 avalon
	set_connection_parameter_value mm_bridge.m0/bitrate_$i.s1 arbitrationPriority {1}
	set_connection_parameter_value mm_bridge.m0/bitrate_$i.s1 baseAddress $ia
	set_connection_parameter_value mm_bridge.m0/bitrate_$i.s1 defaultConnection {0}

	set myparamname BITRATE_
	append myparamname $i "_OFFSET"
	
	set_module_assignment embeddedsw.CMacro.$myparamname $ia
	

        set ia [expr $ia + 16]

	add_connection mm_bridge.m0 rxclock_$i.s1 avalon
	set_connection_parameter_value mm_bridge.m0/rxclock_$i.s1 arbitrationPriority {1}
	set_connection_parameter_value mm_bridge.m0/rxclock_$i.s1 baseAddress $ia
	set_connection_parameter_value mm_bridge.m0/rxclock_$i.s1 defaultConnection {0}

	set myparamname RXCLOCK_
	append myparamname $i "_OFFSET"
	
	set_module_assignment embeddedsw.CMacro.$myparamname $ia

        set ia [expr $ia + 16]
	  
		  
		  
	add_connection mm_bridge.m0 counter_1ms_reg_$i.s1 avalon
	set_connection_parameter_value mm_bridge.m0/counter_1ms_reg_$i.s1 arbitrationPriority {1}
	set_connection_parameter_value mm_bridge.m0/counter_1ms_reg_$i.s1 baseAddress $ia
	set_connection_parameter_value mm_bridge.m0/counter_1ms_reg_$i.s1 defaultConnection {0}

	set myparamname COUNTER_1MS_REG_
	append myparamname $i "_OFFSET"
	
	set_module_assignment embeddedsw.CMacro.$myparamname $ia

        set ia [expr $ia + 16]		  
	  

		  

    }

    # exported interfaces
    add_interface s0 avalon slave
    set_interface_property s0 EXPORT_OF mm_bridge.s0

    add_interface clk clock sink
    set_interface_property clk EXPORT_OF clk_0.in_clk

    add_interface reset reset sink
    set_interface_property reset EXPORT_OF reset_0.in_reset
	 
    for {set i 0} {$i < $NPHYS} {incr i 1} {
	 

		for {set j 0} {$j < $NAVMM_PER_PHY} {incr j 1} {	
	 	set z [expr ($NAVMM_PER_PHY)*$i + $j]		
		add_interface reconfig_xcvr_$z conduit end
		set_interface_property reconfig_xcvr_$z EXPORT_OF reconfig_xcvr_$z.s01
		add_interface reconfig_xcvr_reset_$z conduit end
		set_interface_property reconfig_xcvr_reset_$z EXPORT_OF reconfig_xcvr_$z.reset1
		
		add_interface reconfig_pdp_$z conduit end
		set_interface_property reconfig_pdp_$z EXPORT_OF reconfig_pdp_$z.s01
		add_interface reconfig_pdp_reset_$z conduit end
		set_interface_property reconfig_pdp_reset_$z EXPORT_OF reconfig_pdp_$z.reset1

   }

	add_interface control_reg_$i conduit end
	set_interface_property control_reg_$i EXPORT_OF control_reg_$i.external_connection
	
	add_interface control2_reg_$i conduit end
	set_interface_property control2_reg_$i EXPORT_OF control2_reg_$i.external_connection

	# add_interface adapt_sip_control_$i conduit end
	# set_interface_property adapt_sip_control_$i EXPORT_OF adapt_sip_control_$i.external_connection
	
	# add_interface adapt_sip_control_treshold_reg_$i conduit end
	# set_interface_property adapt_sip_control_treshold_reg_$i EXPORT_OF adapt_sip_control_treshold_reg_$i.external_connection	
	
		
	# add_interface adapt_sip_status_$i conduit end
	# set_interface_property adapt_sip_status_$i EXPORT_OF adapt_sip_status_$i.external_connection
	
	# add_interface reset_control_$i conduit end
	# set_interface_property reset_control_$i EXPORT_OF reset_control_$i.external_connection
	
		
	# add_interface reset_status_$i conduit end
	# set_interface_property reset_status_$i EXPORT_OF reset_status_$i.external_connection	
	
	add_interface bitrate_$i conduit end
	set_interface_property bitrate_$i EXPORT_OF bitrate_$i.external_connection
	
	add_interface rxclock_$i conduit end
	set_interface_property rxclock_$i EXPORT_OF rxclock_$i.external_connection
	
	
	add_interface counter_1ms_reg_$i conduit end
	set_interface_property counter_1ms_reg_$i EXPORT_OF counter_1ms_reg_$i.external_connection
	

			


    }

    # interconnect requirements (new assignment in 19.1)
    set_domain_assignment {$system} {qsys_mm.clockCrossingAdapter} {HANDSHAKE}
    set_domain_assignment {$system} {qsys_mm.maxAdditionalLatency} {4}
    set_domain_assignment {$system} {qsys_mm.insertDefaultSlave} {FALSE}


}
set_module_property COMPOSITION_CALLBACK compose
set_module_property opaque_address_map true

add_parameter NPHYS INTEGER 1 "PHYS"
set_parameter_property NPHYS DEFAULT_VALUE 1
set_parameter_property NPHYS DISPLAY_NAME "PHYS"
#set_parameter_property NPHYS TYPE INTEGER
set_parameter_property NPHYS UNITS None
set_parameter_property NPHYS DESCRIPTION "Number of PHY's in the target system"
set_parameter_property NPHYS HDL_PARAMETER false

add_parameter NAVMM_PER_PHY INTEGER 1 "AVMM_PER_PHY"
set_parameter_property NAVMM_PER_PHY DEFAULT_VALUE 4
set_parameter_property NAVMM_PER_PHY DISPLAY_NAME "AVMM_PER_PHY"
#set_parameter_property NAVMM_PER_PHY TYPE INTEGER
set_parameter_property NAVMM_PER_PHY UNITS None
set_parameter_property NAVMM_PER_PHY DESCRIPTION "Number of AVMM interfaces per PHY (both for NPHY as for RSFEC)"
set_parameter_property NAVMM_PER_PHY HDL_PARAMETER false



	 
