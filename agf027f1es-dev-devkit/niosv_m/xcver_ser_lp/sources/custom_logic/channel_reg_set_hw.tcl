package require qsys 19.1


# module properties
set_module_property NAME {channel_reg_set}
set_module_property DISPLAY_NAME {Channel Register Set}

# default module properties
set_module_property VERSION {22.2}
set_module_property GROUP {default group}
set_module_property DESCRIPTION {default description}
set_module_property AUTHOR {Peter Schepers - Intel PSG}



proc compose { } {

    set NCHAN [get_parameter_value NCHAN]

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

    for {set i 0} {$i < $NCHAN} {incr i 1} {

	add_instance channel_$i altera_avalon_pio 19.*
	set_instance_parameter_value channel_$i {bitClearingEdgeCapReg} {0}
	set_instance_parameter_value channel_$i {bitModifyingOutReg} {0}
	set_instance_parameter_value channel_$i {captureEdge} {1}
	set_instance_parameter_value channel_$i {direction} {Input}
	set_instance_parameter_value channel_$i {edgeType} {RISING}
	set_instance_parameter_value channel_$i {generateIRQ} {0}
	set_instance_parameter_value channel_$i {irqType} {LEVEL}
	set_instance_parameter_value channel_$i {resetValue} {0.0}
	set_instance_parameter_value channel_$i {simDoTestBenchWiring} {0}
	set_instance_parameter_value channel_$i {simDrivenValue} {0.0}
	set_instance_parameter_value channel_$i {width} {16}

	add_instance error_count_h_$i altera_avalon_pio 19.*
	set_instance_parameter_value error_count_h_$i {bitClearingEdgeCapReg} {0}
	set_instance_parameter_value error_count_h_$i {bitModifyingOutReg} {0}
	set_instance_parameter_value error_count_h_$i {captureEdge} {1}
	set_instance_parameter_value error_count_h_$i {direction} {Input}
	set_instance_parameter_value error_count_h_$i {edgeType} {RISING}
	set_instance_parameter_value error_count_h_$i {generateIRQ} {0}
	set_instance_parameter_value error_count_h_$i {irqType} {LEVEL}
	set_instance_parameter_value error_count_h_$i {resetValue} {0.0}
	set_instance_parameter_value error_count_h_$i {simDoTestBenchWiring} {0}
	set_instance_parameter_value error_count_h_$i {simDrivenValue} {0.0}
	set_instance_parameter_value error_count_h_$i {width} {32}

	add_instance error_count_l_$i altera_avalon_pio 19.*
	set_instance_parameter_value error_count_l_$i {bitClearingEdgeCapReg} {0}
	set_instance_parameter_value error_count_l_$i {bitModifyingOutReg} {0}
	set_instance_parameter_value error_count_l_$i {captureEdge} {1}
	set_instance_parameter_value error_count_l_$i {direction} {Input}
	set_instance_parameter_value error_count_l_$i {edgeType} {RISING}
	set_instance_parameter_value error_count_l_$i {generateIRQ} {0}
	set_instance_parameter_value error_count_l_$i {irqType} {LEVEL}
	set_instance_parameter_value error_count_l_$i {resetValue} {0.0}
	set_instance_parameter_value error_count_l_$i {simDoTestBenchWiring} {0}
	set_instance_parameter_value error_count_l_$i {simDrivenValue} {0.0}
	set_instance_parameter_value error_count_l_$i {width} {32}

	add_instance prbslock_alarm_count_$i altera_avalon_pio 19.*
	set_instance_parameter_value prbslock_alarm_count_$i {bitClearingEdgeCapReg} {0}
	set_instance_parameter_value prbslock_alarm_count_$i {bitModifyingOutReg} {0}
	set_instance_parameter_value prbslock_alarm_count_$i {captureEdge} {1}
	set_instance_parameter_value prbslock_alarm_count_$i {direction} {Input}
	set_instance_parameter_value prbslock_alarm_count_$i {edgeType} {RISING}
	set_instance_parameter_value prbslock_alarm_count_$i {generateIRQ} {0}
	set_instance_parameter_value prbslock_alarm_count_$i {irqType} {LEVEL}
	set_instance_parameter_value prbslock_alarm_count_$i {resetValue} {0.0}
	set_instance_parameter_value prbslock_alarm_count_$i {simDoTestBenchWiring} {0}
	set_instance_parameter_value prbslock_alarm_count_$i {simDrivenValue} {0.0}
	set_instance_parameter_value prbslock_alarm_count_$i {width} {32}
	
#	add_instance fec_cor_ec_$i altera_avalon_pio 19.*
#	set_instance_parameter_value fec_cor_ec_$i {bitClearingEdgeCapReg} {0}
#	set_instance_parameter_value fec_cor_ec_$i {bitModifyingOutReg} {0}
#	set_instance_parameter_value fec_cor_ec_$i {captureEdge} {1}
#	set_instance_parameter_value fec_cor_ec_$i {direction} {Input}
#	set_instance_parameter_value fec_cor_ec_$i {edgeType} {RISING}
#	set_instance_parameter_value fec_cor_ec_$i {generateIRQ} {0}
#	set_instance_parameter_value fec_cor_ec_$i {irqType} {LEVEL}
#	set_instance_parameter_value fec_cor_ec_$i {resetValue} {0.0}
#	set_instance_parameter_value fec_cor_ec_$i {simDoTestBenchWiring} {0}
#	set_instance_parameter_value fec_cor_ec_$i {simDrivenValue} {0.0}
#	set_instance_parameter_value fec_cor_ec_$i {width} {32}

#	add_instance fec_uncor_ec_$i altera_avalon_pio 19.*
#	set_instance_parameter_value fec_uncor_ec_$i {bitClearingEdgeCapReg} {0}
#	set_instance_parameter_value fec_uncor_ec_$i {bitModifyingOutReg} {0}
#	set_instance_parameter_value fec_uncor_ec_$i {captureEdge} {1}
#	set_instance_parameter_value fec_uncor_ec_$i {direction} {Input}
#	set_instance_parameter_value fec_uncor_ec_$i {edgeType} {RISING}
#	set_instance_parameter_value fec_uncor_ec_$i {generateIRQ} {0}
#	set_instance_parameter_value fec_uncor_ec_$i {irqType} {LEVEL}
#	set_instance_parameter_value fec_uncor_ec_$i {resetValue} {0.0}
#	set_instance_parameter_value fec_uncor_ec_$i {simDoTestBenchWiring} {0}
#	set_instance_parameter_value fec_uncor_ec_$i {simDrivenValue} {0.0}
#	set_instance_parameter_value fec_uncor_ec_$i {width} {32}
    }

    # connections and connection parameters
    add_connection clk_0.out_clk mm_bridge.clk clock

    add_connection reset_0.out_reset mm_bridge.reset reset

    set ia 0
	 
	 

    for {set i 0} {$i < $NCHAN} {incr i 1} {

	add_connection clk_0.out_clk channel_$i.clk clock

	add_connection clk_0.out_clk error_count_h_$i.clk clock

	add_connection clk_0.out_clk error_count_l_$i.clk clock
	
	add_connection clk_0.out_clk prbslock_alarm_count_$i.clk clock	

#	add_connection clk_0.out_clk fec_cor_ec_$i.clk clock
#
#	add_connection clk_0.out_clk fec_uncor_ec_$i.clk clock

	add_connection reset_0.out_reset channel_$i.reset reset

	add_connection reset_0.out_reset error_count_h_$i.reset reset

	add_connection reset_0.out_reset error_count_l_$i.reset reset
	
	add_connection reset_0.out_reset prbslock_alarm_count_$i.reset reset
	

#	add_connection reset_0.out_reset fec_cor_ec_$i.reset reset
#
#	add_connection reset_0.out_reset fec_uncor_ec_$i.reset reset

	add_connection mm_bridge.m0 channel_$i.s1 avalon
	set_connection_parameter_value mm_bridge.m0/channel_$i.s1 arbitrationPriority {1}
	set_connection_parameter_value mm_bridge.m0/channel_$i.s1 baseAddress $ia
	set_connection_parameter_value mm_bridge.m0/channel_$i.s1 defaultConnection {0}
	
	set myparamname CHANNEL_
	append myparamname $i "_OFFSET"
	
	set_module_assignment embeddedsw.CMacro.$myparamname $ia
	
        set ia [expr $ia + 16]

	add_connection mm_bridge.m0 error_count_h_$i.s1 avalon
	set_connection_parameter_value mm_bridge.m0/error_count_h_$i.s1 arbitrationPriority {1}
	set_connection_parameter_value mm_bridge.m0/error_count_h_$i.s1 baseAddress $ia
	set_connection_parameter_value mm_bridge.m0/error_count_h_$i.s1 defaultConnection {0}

	set myparamname ERROR_COUNT_H_
	append myparamname $i "_OFFSET"
	
	set_module_assignment embeddedsw.CMacro.$myparamname $ia
	

        set ia [expr $ia + 16]

	add_connection mm_bridge.m0 error_count_l_$i.s1 avalon
	set_connection_parameter_value mm_bridge.m0/error_count_l_$i.s1 arbitrationPriority {1}
	set_connection_parameter_value mm_bridge.m0/error_count_l_$i.s1 baseAddress $ia
	set_connection_parameter_value mm_bridge.m0/error_count_l_$i.s1 defaultConnection {0}

	set myparamname ERROR_COUNT_L_
	append myparamname $i "_OFFSET"
	
	set_module_assignment embeddedsw.CMacro.$myparamname $ia

        set ia [expr $ia + 16]
		  

	add_connection mm_bridge.m0 prbslock_alarm_count_$i.s1 avalon
	set_connection_parameter_value mm_bridge.m0/prbslock_alarm_count_$i.s1 arbitrationPriority {1}
	set_connection_parameter_value mm_bridge.m0/prbslock_alarm_count_$i.s1 baseAddress $ia
	set_connection_parameter_value mm_bridge.m0/prbslock_alarm_count_$i.s1 defaultConnection {0}

	set myparamname PRBSLOCK_ALARM_COUNT_
	append myparamname $i "_OFFSET"
	
	set_module_assignment embeddedsw.CMacro.$myparamname $ia

        set ia [expr $ia + 16]		  

#	add_connection mm_bridge.m0 fec_cor_ec_$i.s1 avalon
#	set_connection_parameter_value mm_bridge.m0/fec_cor_ec_$i.s1 arbitrationPriority {1}
#	set_connection_parameter_value mm_bridge.m0/fec_cor_ec_$i.s1 baseAddress $ia
#	set_connection_parameter_value mm_bridge.m0/fec_cor_ec_$i.s1 defaultConnection {0}
#
#	set myparamname FEC_COR_EC_
#	append myparamname $i "_OFFSET"
#	
#	set_module_assignment embeddedsw.CMacro.$myparamname $ia
#
#        set ia [expr $ia + 16]


#	add_connection mm_bridge.m0 fec_uncor_ec_$i.s1 avalon
#	set_connection_parameter_value mm_bridge.m0/fec_uncor_ec_$i.s1 arbitrationPriority {1}
#	set_connection_parameter_value mm_bridge.m0/fec_uncor_ec_$i.s1 baseAddress $ia
#	set_connection_parameter_value mm_bridge.m0/fec_uncor_ec_$i.s1 defaultConnection {0}
#
#	set myparamname FEC_UNCOR_EC_
#	append myparamname $i "_OFFSET"
#	
#	set_module_assignment embeddedsw.CMacro.$myparamname $ia
#
#        set ia [expr $ia + 16]


    }

    # exported interfaces
    add_interface s0 avalon slave
    set_interface_property s0 EXPORT_OF mm_bridge.s0

    add_interface clk clock sink
    set_interface_property clk EXPORT_OF clk_0.in_clk

    add_interface reset reset sink
    set_interface_property reset EXPORT_OF reset_0.in_reset
    for {set i 0} {$i < $NCHAN} {incr i 1} {


	add_interface channel_$i conduit end
	set_interface_property channel_$i EXPORT_OF channel_$i.external_connection
	add_interface error_count_h_$i conduit end
	set_interface_property error_count_h_$i EXPORT_OF error_count_h_$i.external_connection
	add_interface error_count_l_$i conduit end
	set_interface_property error_count_l_$i EXPORT_OF error_count_l_$i.external_connection
	add_interface prbslock_alarm_count_$i conduit end
	set_interface_property prbslock_alarm_count_$i EXPORT_OF prbslock_alarm_count_$i.external_connection	
	
#	add_interface fec_cor_ec_$i conduit end
#	set_interface_property fec_cor_ec_$i EXPORT_OF fec_cor_ec_$i.external_connection

#	add_interface fec_uncor_ec_$i conduit end
#	set_interface_property fec_uncor_ec_$i EXPORT_OF fec_uncor_ec_$i.external_connection


    }

	     # interconnect requirements (new assignment in 19.1)
    set_domain_assignment {$system} {qsys_mm.clockCrossingAdapter} {HANDSHAKE}
    set_domain_assignment {$system} {qsys_mm.maxAdditionalLatency} {4}
    set_domain_assignment {$system} {qsys_mm.insertDefaultSlave} {FALSE}

	 
}
set_module_property COMPOSITION_CALLBACK compose
set_module_property opaque_address_map true

add_parameter NCHAN INTEGER 1 "Channels"
set_parameter_property NCHAN DEFAULT_VALUE 1
set_parameter_property NCHAN DISPLAY_NAME "Channels"
#set_parameter_property NCHAN TYPE INTEGER
set_parameter_property NCHAN UNITS None
set_parameter_property NCHAN DESCRIPTION "Number of xcvr channels in the target system"
set_parameter_property NCHAN HDL_PARAMETER false
