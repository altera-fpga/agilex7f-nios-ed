#----------------------------------------------------------------------------------------------------------
# Copyright (C) 2022 Intel Corporation
# 
# This code and the related documents are Intel copyrighted materials, and 
# your use of them is governed by the express license under which they were 
# provided to you ("License"). Unless the License provides otherwise, you may 
# not use, modify, copy, publish, distribute, disclose or transmit this 
# code or the related documents without Intel's prior written permission.
#
# This code and the related documents are provided as is, with no express 
# or implied warranties, other than those that are expressly stated in the 
# License.
#
#----------------------------------------------------------------------------------------------------------

puts {==============================================================================================================}
puts {This tcl file contains a number of procedures to do additional configuration and status updates for Agilex F-tile} 
puts {This version of the script can be used for both FGT and FHT on both PHY direct IP designs as well as Ethernet HIP designs}
puts {Revision 1.2}
puts {Date : 14 November 2022}
puts {Author : Peter Schepers}
puts {==============================================================================================================}
puts ""


###############################################################################
# DEFINES
###############################################################################

set offset_ftile 			0x100000 
set offset_ftile_pdp 	0x10000 
set LOOPBACK_ADDR_FGT 	0x4781C
set LOOPBACK_ADDR_FHT 	0x45800

#set to 1 for test_mode (note that this expects the 48 or 96 channel design in terms of indexes for the phy)
set test_mode 0


###############################################################################
# Map all and claim all F-tile Slaves (reconfig_xcvr/avmm2)
# Once claimed they can be used using the $phy_key
###############################################################################
set FTILE_SLAVE_MAP {}

proc map_all_ftile_slaves {dump_map} {
    global FTILE_SLAVE_MAP
    set num_slave_services [llength [get_service_paths slave]]
    set array_list {}
	 puts "Below is the list of F-tile PHY's claimed (reconfig_xcvr/avmm2)"
	 puts "Use ftile_phy_<i> as phy identifier in the functions"
    for {set i 0} {$i < $num_slave_services} {incr i} {
        catch {
            set marker_info [marker_get_info [lindex [get_service_paths slave] $i]]
            regexp {TYPE_NAME(.+)FULL_HPATH} $marker_info full_match matched_typename
				#puts $matched_typename
            regexp {FULL_HPATH(.+)BASE_ADDRESS} $marker_info full_match matched_hpath
            if {[string match "*f_adme_dphy_avmm2*" $matched_typename] || [string match "*f_adme_eth_f_avmm2*" $matched_typename]} {
				    #puts $i
                set claimed_slave_value [claim_service slave [lindex [get_service_paths slave] $i] ""]
					 set slave_addr [dict get $marker_info BASE_ADDRESS]
                set phy_key "ftile_phy_$i"
                lappend array_list $phy_key
                lappend array_list $claimed_slave_value
                
                if {$dump_map} {
                    puts "Phy : \"$phy_key\" ---> Hierarchy Path: $matched_hpath   Slave: [format 0x%x $slave_addr]"					  
                }
            }
        }
    }
	 puts ""
    set FTILE_SLAVE_MAP $array_list
}

if {$test_mode == 1} {
map_all_ftile_slaves 1
}

###############################################################################
# Map all and claim all F-tile Slaves (reconfig_pdp/avmm1)
# Once claimed they can be used using the $phy_pdp_key
###############################################################################

set FTILE_SLAVE_PDP_MAP {}

proc map_all_ftile_pdp_slaves {dump_map} {
    global FTILE_SLAVE_PDP_MAP
    set num_slave_services [llength [get_service_paths slave]]
    set array_list_pdp {}
	 puts "Below is the list of F-tile PDP PHY's claimed (reconfig_pdp/avmm1)"
	 puts "Use ftile_phy_pdp_<i> as phy identifier in the functions"
    for {set i 0} {$i < $num_slave_services} {incr i} {
        catch {
            set marker_info [marker_get_info [lindex [get_service_paths slave] $i]]
            regexp {TYPE_NAME(.+)FULL_HPATH} $marker_info full_match matched_typename
				#puts $matched_typename
            regexp {FULL_HPATH(.+)BASE_ADDRESS} $marker_info full_match matched_hpath
            if {[string match "*f_adme_dphy_avmm1*" $matched_typename] || [string match "*f_adme_eth_f_avmm1*" $matched_typename]} {
				    #puts $i
                set claimed_slave_value [claim_service slave [lindex [get_service_paths slave] $i] ""]
					 set slave_addr [dict get $marker_info BASE_ADDRESS]
                set phy_pdp_key "ftile_phy_pdp_$i"
                lappend array_list_pdp $phy_pdp_key
                lappend array_list_pdp $claimed_slave_value
                
                if {$dump_map} {
                    puts "Phy_pdp : \"$phy_pdp_key\" ---> Hierarchy Path: $matched_hpath   Slave: [format 0x%x $slave_addr]"					  
                }
            }
        }
    }
	 puts ""
    set FTILE_SLAVE_PDP_MAP $array_list_pdp
}

if {$test_mode == 1} {
map_all_ftile_pdp_slaves 1
}


###############################################################################
# 2 complement functions
###############################################################################

proc decode_tap_6bits {tap_encoded} {
	 if {$tap_encoded > 0x20} {
		 set decoded_tap [expr -($tap_encoded - 0x20)]
		 } else {
		 set decoded_tap $tap_encoded
		 }
} 

proc decode_tap_7bits {tap_encoded} {
	 if {$tap_encoded > 0x40} {
		 set decoded_tap [expr -($tap_encoded - 0x40)]
		 } else {
		 set decoded_tap $tap_encoded
		 }
} 

proc twos_complement_12bit {value} {
	if {$value > 0x800} {
		set temp [expr -((0xFFF - $value) + 1)]
	} else {
		set temp $value
	}
} 

proc twos_complement {value} {
	if {$value > 0xF000} {
		set temp [expr -((65535 - $value) + 1)]
	} else {
		set temp $value
	}
}

proc twos_complement_6bit {value} {
	if {$value > 0x20} {
		set temp [expr -((0x3F - $value) + 1)]
	} else {
		set temp $value
	}
} 

proc twos_complement_8bit {value} {
	if {$value > 0x80} {
		set temp [expr -((0xFF - $value) + 1)]
	} else {
		set temp $value
	}
} 

#This function converts a reflected binary Gray code number to a binary number.
proc GrayToBinary {num} {
	set mask $num
   while {$mask} {           
        set mask [expr $mask >> 1]
        set num  [expr $num ^ $mask]
    }
    return $num
}



###############################################################################
# read register
###############################################################################
#Since byte addressses are used no need to multiply with 4 the offset 
proc rd {m base_addr offset } {
  set value [master_read_32 $m [expr $base_addr + $offset] 1] 

}
#puts {rd m base_addr offset }
#puts {example usage: rd $m $base_addr 0x138}
#puts ""

###############################################################################
# write register
###############################################################################
#Since byte addressses are used no need to multiply with 4 the offset 
proc wr {m base_addr offset newval} {
  # write the new data back
  master_write_32 $m [expr $base_addr + $offset] $newval
}


proc rd_mask_dec {m base_addr offset bitmask } {
  set value [master_read_32 $m [expr $base_addr + $offset ] 1]
  puts -nonewline [format %d [expr $value & $bitmask]]
}

proc rd_mask_hex {m base_addr offset bitmask } {
  set value [master_read_32 $m [expr $base_addr + $offset ] 1]
  puts -nonewline [format 0x%x [expr $value & $bitmask]]
}


###############################################################################
# read modify write register
###############################################################################
#Since byte addresssed are used no need to multiply with 4 the offset 
proc rmw {m base_addr offset bitmask newval} {
  # mask out the newval so that un-masked bits do not change
  set newval_masked [expr $newval & $bitmask]

  # read from data register
  set value [master_read_32 $m [expr $base_addr + $offset ] 1]
  
  # bitwise-AND with the negative of bitmask to clear out only the bitmask bits
  set value [expr $value & [expr 0xffffffff & ~$bitmask]] 

  # bitwise-OR this data with the newval_masked so that only the masked bits get changed
  set value [expr $value | $newval_masked] 

  # write the new data back
  master_write_32 $m [expr $base_addr + $offset ] $value


}
#puts {rmw {m base_addr offset bitmask newval} }
#puts {example usage: rmw $m $base_addr 0x160 0xE 0x4}
#puts ""


###############################################################################		
#read a register from a specific channel in a phy (reconfig_xcvr/avmm2)
###############################################################################
proc rd_channel {phy channel offset verbose} {

global offset_ftile


global FTILE_SLAVE_MAP

array set ftile_slave_array $FTILE_SLAVE_MAP
set m $ftile_slave_array($phy)
	 

				set base_addr [expr $offset_ftile * $channel]		
				# Print info
				#set identifier [rd $m 0x0 0x40000]
				if {$verbose == 1} {
				puts -nonewline "Slave reconfig_xcvr/AVMM2: $phy  "
				#puts -nonewline "Identifier: $identifier  "
				puts -nonewline "channel  : $channel	"
				puts -nonewline "base_addr : [format 0x%x $base_addr]	 "
				puts -nonewline "Offset : [format 0x%x $offset]  " 
				}
				set read_back [rd $m $base_addr $offset]
				if {$verbose == 1} {				
				puts -nonewline "	Read : [format 0x%x $read_back] " 
				puts ""
				}
return $read_back
}
puts {rd_channel {phy channel offset verbose}}
puts {to read and printout use e.g. rd_channel ftile_phy_15 3 0xFFFFC 1}
puts {when only reading without printing use e.g. set d [rd_channel ftile_phy_15 3 0xFFFFC 0]}
puts ""
if {$test_mode == 1} {
rd_channel ftile_phy_15 0 0xFFFFC 1
}
	
###############################################################################		
#rd_channel_ftile
###############################################################################
proc rd_channel_ftile {phy channel address verbose} {

global offset_ftile
global FTILE_SLAVE_MAP

array set ftile_slave_array $FTILE_SLAVE_MAP

set readout  [rd_channel  $phy $channel 0xFFFFC $verbose];
set lane [expr $readout & 0x03]

set readout [rd_channel $phy $channel [expr $address + $lane*0x8000] $verbose]

return $readout
}
puts {rd_channel_ftile {phy channel address verbose}}
puts {to read and printout use e.g. rd_channel_file ftile_phy_15 3 0x47830 1}
puts {when only reading without printing use e.g. set d [rd_channel_ftile ftile_phy_15 3 0x47830 0]}
puts ""
if {$test_mode == 1} {
rd_channel_ftile ftile_phy_15 0 0x47830 1
}




##########################################################################################		
#read a register from a specific channel in a phy using PDP interface (reconfig_pdp/avmm1)
##########################################################################################
proc rd_channel_pdp {phy channel offset verbose} {

global offset_ftile_pdp

global FTILE_SLAVE_PDP_MAP

array set ftile_slave_array $FTILE_SLAVE_PDP_MAP
set m $ftile_slave_array($phy)
	 

				set base_addr [expr $offset_ftile_pdp * $channel]		
				# Print info
				#set identifier [rd $m 0x0 0x40000]
				if {$verbose == 1} {
				puts -nonewline "Slave reconfig_pdp/AVMM1: $phy  "
				#puts -nonewline "Identifier: $identifier  "
				puts -nonewline "channel  : $channel	"
				puts -nonewline "base_addr : [format 0x%x $base_addr]	 "
				puts -nonewline "Offset : [format 0x%x $offset]  " 
				}
				set read_back [rd $m $base_addr $offset]
				if {$verbose == 1} {				
				puts -nonewline "	Read : [format 0x%x $read_back] " 
				puts ""
				}
return $read_back
}
puts {rd_channel_pdp {phy channel offset verbose}}
puts {to read and printout use e.g. rd_channel_pdp ftile_phy_pdp_16 0 0x60C0 1}
puts {when only reading without printing use e.g. set d [rd_channel_pdp ftile_phy_pdp_16 0 0x60C0 1]}
puts ""
if {$test_mode == 1} {
rd_channel_pdp ftile_phy_pdp_16 0 0x60C0 1
}


###############################################################################		
#write to a channel (reconfig_xcvr/avmm2)
###############################################################################
proc wr_channel {phy channel offset newval verbose} {
global offset_ftile


global FTILE_SLAVE_MAP
array set ftile_slave_array $FTILE_SLAVE_MAP
set m $ftile_slave_array($phy)


					set base_addr [expr $offset_ftile * $channel]
		
				wr $m $base_addr $offset $newval

				
				
				# Print info
				if {$verbose == 1} {				
				puts -nonewline "Slave: $phy  "
				puts -nonewline "channel  : $channel	"
				puts -nonewline "base_addr : [format 0x%x $base_addr]	"
				puts -nonewline "	Offset : [format 0x%x $offset] " 
				}
				if {$verbose == 1} {						
				puts -nonewline "	Newval : [format 0x%x $newval] " 
				puts ""
				}

}
puts {wr_channel {phy channel offset newval verbose}}
puts {example useage wr_channel ftile_phy_15 1 0x207 0x91 1}
puts ""

###############################################################################		
#Do rmw for specific channel within a phy (reconfig_xcvr/avmm2)
###############################################################################
proc rmw_channel {phy channel offset mask newval verbose} {
global offset_ftile
global FTILE_SLAVE_MAP
array set ftile_slave_array $FTILE_SLAVE_MAP

set m $ftile_slave_array($phy)

					set base_addr [expr $offset_ftile * $channel]

		
				rmw $m $base_addr $offset $mask $newval

				
				
				# Print info
				if {$verbose == 1} {				
				puts -nonewline "Slave: $phy  "
				puts -nonewline "channel  : $channel	"
				puts -nonewline "base_addr : [format 0x%x $base_addr]	"
				puts -nonewline "	Offset : [format 0x%x $offset] " 
				}
				set read_back [rd $m $base_addr $offset]
				set read_back_mask [expr [expr $read_back & $mask ]]
				if {$verbose == 1} {						
				puts -nonewline "	Newval : [format 0x%x $read_back_mask] " 
				puts ""
				}

}
puts {rmw_channel {phy channel offset mask newval verbose}}
puts {example useage rmw_channel ftile_phy_15 0 0x47830 0x0000FC00 [expr 35 << 10] 1}
puts ""

###############################################################################		
#rmw_channel_ftile (reconfig_xcvr/avmm2)
###############################################################################
proc rmw_channel_ftile {phy channel address mask newval verbose} {
global offset_ftile
global FTILE_SLAVE_MAP
array set ftile_slave_array $FTILE_SLAVE_MAP

set readout  [rd_channel  $phy $channel 0xFFFFC $verbose];
set lane [expr $readout & 0x03]

rmw_channel $phy $channel [expr $address + $lane*0x8000] $mask $newval $verbose

}
puts {rmw_channel_ftile {phy channel address mask newval verbose}}
puts {example useage (set maintap to 35) rmw_channel_ftile ftile_phy_15 1 0x47830 0x0000FC00 [expr 35 << 10] 1}
puts ""


###############################################################################		
#write to a channel (reconfig_pdp/avmm1)
###############################################################################
proc wr_channel_pdp {phy channel offset newval verbose} {

global offset_ftile_pdp


global FTILE_SLAVE_PDP_MAP
array set ftile_slave_array $FTILE_SLAVE_PDP_MAP

set m $ftile_slave_array($phy)


					set base_addr [expr $offset_ftile_pdp * $channel]
		
				wr $m $base_addr $offset $newval

				
				
				# Print info
				if {$verbose == 1} {				
				puts -nonewline "Slave reconfig_pdp/AVMM1: $phy  "
				puts -nonewline "channel  : $channel	"
				puts -nonewline "base_addr : [format 0x%x $base_addr]	"
				puts -nonewline "	Offset : [format 0x%x $offset] " 
				}
				if {$verbose == 1} {						
				puts -nonewline "	Newval : [format 0x%x $newval] " 
				puts ""
				}

}
puts {wr_channel_pdp {phy channel offset newval verbose}}
puts {example useage wr_channel ftile_phy_pdp_16 0 0x1E0 0x00000001 1}
puts ""



###############################################################################		
#cpi_request_fgt
###############################################################################
proc cpi_request_fgt {phy channel data opcode assert set_getn verbose} {
global offset_ftile
global FTILE_SLAVE_MAP
array set ftile_slave_array $FTILE_SLAVE_MAP

set readout  [rd_channel  $phy $channel 0xFFFFC $verbose];
set lane [expr $readout & 0x03]

set readout [rd_channel $phy $channel 0x90044 $verbose]
set cpi_busy [expr $readout & 0xFFFF]

if {$cpi_busy == 0xF} {

set cpi_command [expr [expr $data<<16] + [expr $assert<<15] + [expr $set_getn<<13] + [expr $lane<<8] + $opcode]
if {$verbose} {
puts -nonewline "data : [format 0x%x $data ] " 
puts -nonewline "assert : $assert  "
puts -nonewline "set_getn : $set_getn "
puts -nonewline "lane : $lane "
puts -nonewline "opcode : $opcode  "


puts "cpi_command : [format 0x%x $cpi_command] "
}

#CPI service request assert 
rmw_channel $phy $channel 0x9003C 0xFFFFFFFF $cpi_command $verbose
after 10

         set readout [rd_channel $phy $channel 0x90040 $verbose]
			set cpi_service_requested [expr [expr $readout >> 15] & 0x0001]
			set cpi_in_reset [expr [expr $readout >> 14] & 0x0001]	
			
	  if {$assert == 0} {
		set not_assert 1
		} else {
		 set not_assert 0
		} 
	  #after 1000
     while {($cpi_service_requested == $not_assert) || ($cpi_in_reset == 1) } { 
         set readout [rd_channel $phy $channel 0x90040 $verbose]
			set cpi_service_requested [expr [expr $readout >> 15] & 0x0001]
			set cpi_in_reset [expr [expr $readout >> 14] & 0x0001]			
     }
} else {
  puts "CPI currently in use, CPI request ignored"
}

return $readout;

}
puts {cpi_request_fgt {phy channel data opcode assert set_getn verbose} }
puts ""


##############################################################################		
#get_cpidata
###############################################################################
proc get_cpidata {phy channel data opcode verbose} {
global offset_ftile
global FTILE_SLAVE_MAP
array set ftile_slave_array $FTILE_SLAVE_MAP

set readout  [cpi_request_fgt  $phy $channel $data $opcode 1 0 $verbose]
set cpi_read_data [expr $readout >> 16]
set readout  [cpi_request_fgt  $phy $channel $data $opcode 0 0 $verbose] 


return $cpi_read_data;

}
puts {get_cpidata {phy channel data opcode verbose}  }
#puts {example useage (set maintap to 35) rmw_channel_ftile ftile_phy_15 1 0x47830 0x0000FC00 [expr 35 << 10] 1}
puts ""

##############################################################################		
#get_fom
###############################################################################
proc get_fom {phy channel verbose} {
global offset_ftile
global FTILE_SLAVE_MAP
array set ftile_slave_array $FTILE_SLAVE_MAP

set readout  [get_cpidata  $phy $channel [expr 3<<13] 0x94 $verbose]
 


return $readout;
#TBC requires twos_complement conversion
}
puts {get_fom {phy channel verbose}  }
puts {example useage (read from from channel 7):  get_fom ftile_phy_15 7 0}
puts ""


##############################################################################		
#get_vga
###############################################################################
proc get_vga {phy channel verbose} {
global offset_ftile
global FTILE_SLAVE_MAP
array set ftile_slave_array $FTILE_SLAVE_MAP

set readout  [get_cpidata  $phy $channel [expr 2<<13] 0x94 $verbose]
 


return $readout;
}
puts {get_vga {phy channel verbose}  }
puts {example useage (read from from channel 7):  get_vga ftile_phy_15 7 0}
puts ""

##############################################################################		
#get_ctle
###############################################################################
proc get_ctle {phy channel verbose} {
global offset_ftile
global FTILE_SLAVE_MAP
array set ftile_slave_array $FTILE_SLAVE_MAP

set readout  [get_cpidata  $phy $channel [expr [expr 2<<13] | 1] 0x94 $verbose]
 


return $readout;
}
puts {get_ctle {phy channel verbose}  }
puts {example useage (read from from channel 7):  get_ctle ftile_phy_15 7 0}
puts ""




##############################################################################		
#set_media_mode
###############################################################################

proc set_media_mode {phy number_of_lanes media_mode verbose} {
global offset_ftile
global FTILE_SLAVE_MAP
array set ftile_slave_array $FTILE_SLAVE_MAP

set firmware [get_firmware_fgt $phy $verbose]
puts $firmware

	if {$firmware >= 0x196} {
	 
	 for {set i 0} {$i < $number_of_lanes} {incr i} {
	 
	 set readout  [cpi_request_fgt  $phy $i $media_mode 0x64 1 1 $verbose] 
	 set readout  [cpi_request_fgt  $phy $i $media_mode 0x64 0 1 $verbose]  
	 }
	} else {
	puts "Firmware version not supported to change media_mode, operation aborted"
	}
}
puts {set_media_mode {phy number_of_lanes media_mode verbose}  }
puts {example useage to set to VSR/Optical Module :  set_media_mode ftile_phy_15 8 0x14 0}
puts {example useage to set to FW Default         :  set_media_mode ftile_phy_15 8 0x10 0}
puts ""


###############################################################################
# Function to readout firmware version
###############################################################################

proc get_firmware_fgt {phy verbose} {

set  firmware [rd_channel $phy 0 0x7001C 0]
set  firmware_version [expr $firmware & 0xFFF] 
if {$verbose} {
puts "firmware version fgt : [format 0x%x  $firmware_version]"
}

return $firmware_version
}
puts {get_firmware_fgt {phy verbose}}
puts {example to get firmware version for fgt:  get_firmware_fgt ftile_phy_15 1}	
puts ""

proc get_firmware_fht {phy verbose} {

set  firmware [rd_channel $phy 0 0x6187C 0]
set  firmware_version [expr $firmware & 0xFFF] 
if {$verbose} {
puts "firmware version fht : [format 0x%x  $firmware_version]"
}

return $firmware_version
}
puts {get_firmware_fht {phy verbose}}
puts {example to get firmware version for fht :  get_firmware_fht ftile_phy_15 1}	
puts ""

###############################################################################
# readback loopbacks
###############################################################################
proc readback_loopbacks {phy number_of_lanes verbose} {
global offset_ftile
global FTILE_SLAVE_MAP
array set ftile_slave_array $FTILE_SLAVE_MAP

global LOOPBACK_ADDR_FGT 
global LOOPBACK_ADDR_FHT

	#Read FHT Firmware (if readback is 0 it is an FGT, otherwise it is an FHT)
	set readout [get_firmware_fht $phy 0]
	if {$readout == 0} {
		set fgt 1
		set fht 0
	} else {
		set fht 1
		set fgt 0				
	}

	if {$fht} {
		set loopback_address $LOOPBACK_ADDR_FHT
		} else {
		set loopback_address $LOOPBACK_ADDR_FGT
		}
					
 for {set i 0} {$i < $number_of_lanes} {incr i} {

 set readout  [rd_channel_ftile  $phy $i $loopback_address $verbose]  
 
	 if {$fht} {
		set serial_loop [expr [expr $readout >> 14] & 0x0001]
		set rev_parallel [expr [expr $readout >> 0] & 0x0001]
		} else {
		set serial_loop [expr [expr $readout >> 1] & 0x0001]
		set rev_parallel [expr [expr $readout >> 2] & 0x0001]
		}	
	

 
 puts -nonewline "channel  : $i	" 
 puts -nonewline "serial_loop  : $serial_loop	"
 puts -nonewline "rev_parallel  : $rev_parallel	"
 puts ""

 }

}
puts {readback_loopbacks {phy number_of_lanes verbose}  }
puts {example useage :  readback_loopbacks ftile_phy_15 8 0}
puts ""


##############################################################################		
#recovered clock output functions (only available on Quad2/Quad3)
###############################################################################

proc read_recclk_status {phy channel verbose} {
global offset_ftile
global FTILE_SLAVE_MAP
array set ftile_slave_array $FTILE_SLAVE_MAP

set readout  [rd_channel  $phy $channel 0xFFFFC $verbose];  
set quad [expr [expr $readout >> 2]  & 0x03]

	if {$quad >= 2} {	 
    set readout  [get_cpidata $phy $channel 0x0 0xB1 $verbose]	 
	 set clkdiv [expr [expr $readout >> 9]  & 0x0F]
	 
	 if {$clkdiv == 0} {
		puts "Readback : [format 0x%x $clkdiv] : Recovered clock output Enabled for Lane 0 on $phy"
		} elseif { $clkdiv == 1} {
		puts "Readback : [format 0x%x $clkdiv] : Recovered clock output Enabled for Lane 1 on $phy"
		} elseif { $clkdiv == 2} {
		puts "Readback : [format 0x%x $clkdiv] : Recovered clock output Enabled for Lane 2 on $phy"		
		} elseif { $clkdiv == 3} {
		puts "Readback : [format 0x%x $clkdiv] : Recovered clock output Enabled for Lane 3 on $phy"		
		} elseif { $clkdiv == 0xf} {
		puts "Readback : [format 0x%x $clkdiv] : Recovered clock output Disabled on $phy"	
		} else {
		puts "Error : data readback not correct"
		}
	} else {
		puts "This is only supported on quad2 or quad 3, aborted"
	}
}
puts {read_recclk_status {phy channel verbose}  }
puts {example useage to read the status of the recovered clock output :  read_recclk_status ftile_phy_15 0 0}
puts ""

proc enable_recclk {phy channel verbose} {
global offset_ftile
global FTILE_SLAVE_MAP
array set ftile_slave_array $FTILE_SLAVE_MAP

set readout  [rd_channel  $phy $channel 0xFFFFC $verbose];  
set quad [expr [expr $readout >> 2]  & 0x03]
set lane [expr $readout & 0x03]

	if {$quad >= 2} {	
		#disable first the recovered clock output.
		set readout  [cpi_request_fgt  $phy $channel 0x0000 0xB1 1 1 $verbose]
		set readout  [cpi_request_fgt  $phy $channel 0x0000 0xB1 0 1 $verbose]
		
		#check it is effective disabled
		set readout  [get_cpidata $phy $channel 0x0 0xB1 $verbose]	 
		set clkdiv [expr [expr $readout >> 9]  & 0x0F]
	 
		if {$clkdiv == 0xF} {
			set data1 [expr $lane << 14]
			set data [expr 0x2000 + $data1]
			puts "Info : data used : [format 0x%x $data]"
			set readout  [cpi_request_fgt  $phy $channel $data 0xB1 1 1 $verbose]
			set readout  [cpi_request_fgt  $phy $channel $data 0xB1 0 1 $verbose]
			#check if ok
			read_recclk_status $phy $channel $verbose

		} else {
			puts "Error : cannot proceed as recovered clock output is still enabled, command aborted"
		}
	} else {
		puts "This is only supported on quad2 or quad 3,aborted"
	}
}
puts {enable_recclk {phy channel verbose}  }
puts {example useage to enable the recovered clock from phy_15  :  enable_recclk ftile_phy_15 0 0}
puts ""

proc disable_recclk {phy channel verbose} {
global offset_ftile
global FTILE_SLAVE_MAP
array set ftile_slave_array $FTILE_SLAVE_MAP

set readout  [rd_channel  $phy $channel 0xFFFFC $verbose];  
set quad [expr [expr $readout >> 2]  & 0x03]


	if {$quad >= 2} {	
		#disable all recovered clock outputs.
		set readout  [cpi_request_fgt  $phy $channel 0x0000 0xB1 1 1 $verbose]
		set readout  [cpi_request_fgt  $phy $channel 0x0000 0xB1 0 1 $verbose]
		
		#check it is effective disabled
		set readout  [get_cpidata $phy $channel 0x0 0xB1 $verbose]	 
		set clkdiv [expr [expr $readout >> 9]  & 0x0F]
	 
		if {$clkdiv == 0xF} {
		puts "Readback : [format 0x%x $clkdiv] : Recovered clock output Disabled on $phy"
		} else {
			puts "Error : cannot proceed as recovered clock output is still enabled, command aborted"
		}
	} else {
		puts "This is only supported on quad2 or quad 3,aborted"
	}
}
puts {disable_recclk {phy channel verbose}  }
puts {example useage to disable the recovered clock output on phy_15  :  disable_recclk ftile_phy_15 0 0}
puts ""




# puts [format 0x%x $readout] 
# => 0x1E00 (CLKDIV disabled)

# #Enable lane 0 clkdiv

# set readout  [cpi_request_fgt  ftile_phy_19 0 0x2000 0xB1 1 1 1]
# set readout  [cpi_request_fgt  ftile_phy_19 0 0x2000 0xB1 0 1 1]
# set readout [get_cpidata ftile_phy_19 0 0x0 0xB1 1]
# puts [format 0x%x $readout]

# => 0x0 (lane 0 enabled)
###############################################################################
#Determine rx_ready
###############################################################################

proc get_rx_ready_fgt {phy channel verbose} {

set readout [rd_channel_ftile $phy $channel 0x47814 $verbose]
 if {[expr $readout & 0x000F] == 0xF} {
	set rx_ready 1
	} else {
	set rx_ready 0
	}
return $rx_ready
}
puts {get_rx_ready_fgt {phy channel verbose}  }
puts {example useage :  get_rx_ready_fgt ftile_phy_15 0 0}
puts ""


proc get_rx_ready_fht {phy channel verbose} {

set readout [rd_channel_ftile $phy $channel 0x4003C $verbose]
 if {[expr $readout & 0x0001] == 0x1} {
	set rx_ready 1
	} else {
	set rx_ready 0
	}
return $rx_ready
}
puts {get_rx_ready_fht {phy channel verbose}  }
puts {example useage :  get_rx_ready_fht ftile_phy_15 0 0}
puts ""

###############################################################################
#Determine tx_ready
###############################################################################

proc get_tx_ready_fgt {phy channel verbose} {

set readout [rd_channel_ftile $phy $channel 0x41758 $verbose]
 if {[expr [expr $readout >> 24] & 0x0007] == 0x5} {
	set tx_ready 1
	} else {
	set tx_ready 0
	}
return $tx_ready
}
puts {get_tx_ready_fgt {phy channel verbose}  }
puts {example useage :  get_tx_ready_fgt ftile_phy_15 0 0}
puts ""
	
###############################################################################
#Compare differences between channels
###############################################################################

proc compare_xcvr_channels {phy ch1 ch2 start_addr stop_addr} {
global offset_ftile

global FTILE_SLAVE_MAP
array set ftile_slave_array $FTILE_SLAVE_MAP
set m $ftile_slave_array($phy)
		

					set base_addr1 [expr $offset_ftile * $ch1]
					set base_addr2 [expr $offset_ftile * $ch2]

					
	
set addr $start_addr

	for {set i 0} {$i < [expr {$stop_addr - $start_addr}]} {incr i} {
		set d1 [rd $m $base_addr1 $addr]
		set d2 [rd $m $base_addr2 $addr]
		#puts $d1
		#puts $d2
		if {[expr {$d1 ne $d2}] } {
			puts [format "ADDR: 0x%03x --> ch%d:  0x%02x   /   ch%d: 0x%02x" $addr $ch1 $d1 $ch2 $d2]  
			}
		incr addr
	}
}

puts {compare_xcvr_channels {phy ch1 ch2 start_addr stop_addr}}
puts {example useage compare_xcvr_channels ftile_phy_15 0 1 0x0 0xF}
puts ""
if {$test_mode == 1} {
compare_xcvr_channels ftile_phy_15 0 1 0x0 0xF
}



###############################################################################
#  Turn on or off serial loopback for all channels in a PHY
###############################################################################

proc set_serial_loopback_phy_ftile {phy phy_pdp number_of_lanes serial_loop verbose} {
global offset_ftile
global FTILE_SLAVE_MAP
array set ftile_slave_array $FTILE_SLAVE_MAP

set csr_available 1

					if {$serial_loop == 1} {	
	#check if CSR is enabled (TBC : for Ethernet designs it is a different register)
	set readout [rd_channel_pdp $phy_pdp 0 0x800 $verbose]
		if {$readout == 0x0}	{
			set csr_available 0
			puts "CSR not enabled to control rx_reset : cannot set serial loopback, operation aborted"
					} else { 
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
			#assert soft_rx_reset 0x808[1] and rx_rst_ovr 0x808[5] 
			wr_channel_pdp  $phy_pdp $channel 0x808 0x22 $verbose
							#cpi_request_fgt {phy channel data opcode assert set_getn verbose}
		set readout  [cpi_request_fgt  $phy $channel 0x0006 0x40 1 1 $verbose]
		set readout  [cpi_request_fgt  $phy $channel 0x0006 0x40 0 1 $verbose]
			
			#de-assert soft rx_reset and rx_rst_ovr
			wr_channel_pdp  $phy_pdp $channel 0x808 0x00 $verbose
			}
		}
	} else {
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
							#cpi_request_fgt {phy channel data opcode assert set_getn verbose}
		set readout  [cpi_request_fgt  $phy $channel 0x0000 0x40 1 1 $verbose]
		set readout  [cpi_request_fgt  $phy $channel 0x0000 0x40 0 1 $verbose]
		}
	}


		if {$verbose == 1} {	
		puts -nonewline "Phy : $phy  "
			if {$serial_loop == 1} {	
					if {$csr_available == 1 } {
				puts -nonewline "	Turned on Serial Loopback on All channels" 
				}
			} else { 
			puts -nonewline "	Turned off Serial Loopback on All channels" 
			}				
		puts ""
		}


}
puts {set_serial_loopback_phy_ftile {phy phy_pdp number_of_lanes serial_loop verbose}}
puts {note that both the reconfig_xcr or phy (AVMM2) as well as the corresponding reconfig_pdp or phy_pdp (AVMM1) needs to be specified}
puts {this information can be obtained by looking that the claimed phy's and pdp_phy's}
puts {example to turn serial loopback ON for all channels of ftile_phy_14 with corr. ftile_phy_pdp_29 :  set_serial_loopback_phy_ftile ftile_phy_14 ftile_phy_pdp_29 1 1 1}
puts ""
if {$test_mode == 1} {
set_serial_loopback_phy_ftile ftile_phy_14 ftile_phy_pdp_29 1 1 1
}


##############################################################################
#  Display phy information of PHY direct IP (if CSR is enabled)
###############################################################################

proc show_phy_direct_info {phy_pdp verbose} {

set csr_available 1

	#check if CSR is enabled (TBC : for Ethernet designs it is a different register)
	set readout [rd_channel_pdp $phy_pdp 0 0x800 $verbose]
		if {$readout == 0x0}	{
			set csr_available 0
			puts "CSR not enabled : cannot provide information, operation aborted"
			} else {
			puts -nonewline "Phy_pdp        : $phy_pdp"	
			puts ""
			set temp1 [expr [expr $readout >> 0] & 0x00FFF]
			set line_rate [expr $temp1 * 0.1]
			puts -nonewline "Line Rate      : "
			puts -nonewline "[format %3.2f $line_rate] Gbps"
			puts ""
			set pma_type [expr [expr $readout >> 12] & 0x001]
			puts -nonewline "PMA Type       : "
			if {$pma_type == 0 } {
				puts -nonewline "FGT"			
				} else {
				puts -nonewline "FHT"				
				}
			puts ""
			set modulation [expr [expr $readout >> 13] & 0x001]
			puts -nonewline "Modulation     : "
			if {$modulation == 0 } {
				puts -nonewline "NRZ"			
				} else {
				puts -nonewline "PAM4"				
				}	
			puts ""
			set pma_mode [expr [expr $readout >> 14] & 0x003]
			puts -nonewline "PMA Mode       : "
			switch $pma_mode {
				 0 {
						puts -nonewline "Not used"
				 }
				 1 {
						puts -nonewline "Rx Simplex"	
				 }	 
				 2 {
						puts -nonewline "Tx Simplex"	
				 }
				 3 {
						puts -nonewline "Duplex"	
				 }
				 default {
				 }
			}
			puts ""
			set num_pma_lanes [expr [expr $readout >> 16] & 0x001F]
			puts -nonewline "#PMA Lanes     : $num_pma_lanes"	
			puts ""
			set fec_mode [expr [expr $readout >> 21] & 0x001]
			puts -nonewline "FEC            : "
			if {$fec_mode == 0 } {
				puts -nonewline "Disabled"			
				} else {
				puts -nonewline "Enabled"				
				}		
			puts ""
			set num_emibs [expr [expr $readout >> 24] & 0x001F]
			puts -nonewline "#EMIB's        : $num_emibs"					
				
	}	


}
puts {show_phy_direct_info {phy_pdp}}
puts {example to show phy info ON of ftile_phy_pdp_15 :  show_phy_direct_info ftile_phy_pdp_15 1}
puts ""
if {$test_mode == 1} {
show_phy_direct_info ftile_phy_pdp_15 1
}


###############################################################################
# show pma settings ftile
###############################################################################

proc show_pma_settings_ftile {phy number_of_lanes} {
global offset_ftile
global FTILE_SLAVE_MAP
global LOOPBACK_ADDR_FGT 
global LOOPBACK_ADDR_FHT
array set ftile_slave_array $FTILE_SLAVE_MAP
	
set verbose 0

#Read FHT Firmware (if readback is 0 it is an FGT, otherwise it is an FHT)
set readout [get_firmware_fht $phy 0]
if {$readout == 0} {
	set fgt 1
	set fht 0
} else {
	set fht 1
	set fgt 0				
}
	
if {$fht} {
	set loopback_address $LOOPBACK_ADDR_FHT
	} else {
	set loopback_address $LOOPBACK_ADDR_FGT
	}		

set readout [rd_channel_ftile $phy 0 0x47800 $verbose]
set fgt_pam4 [expr [expr $readout >> 2] & 0x0001]	

if {$fht} {
	set readout [rd_channel_ftile $phy 0 0x45860 $verbose]
	set temp [expr [expr $readout >> 3] & 0x0003]
	if {($temp == 0) || ($temp == 1) } {
		set fht_pam4 1
	} else {
		set fht_pam4 0
	}
}

if {$fgt} {
puts -nonewline "FGT Firmware   :|"
set firmware [get_firmware_fgt $phy $verbose]
puts -nonewline "[format 0x%x $firmware]"
} else {
puts -nonewline "FHT Firmware   :|"
set firmware [get_firmware_fht $phy $verbose]
puts -nonewline "[format 0x%x $firmware]"
}
puts ""
puts ""


puts -nonewline "Channel        :|"  
for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
	puts -nonewline "[format %8d $channel]|"  
}
puts ""

puts -nonewline "                |"  
for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
	puts -nonewline "========|"  
}
puts ""

puts -nonewline "Transc. Type   :|"   
for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
	if {$fgt} {
		puts -nonewline "     FGT|"  
		} else {
		puts -nonewline "     FHT|"  		
		}
}
puts ""

if {$fgt} {
	puts -nonewline "FGT Quad       :|"
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel  $phy $channel 0xFFFFC $verbose];  
	set quad [expr [expr $readout >> 2]  & 0x03]
		puts -nonewline "[format %8d $quad]|" 	
	}
	puts ""
}

if {$fgt} {
	puts -nonewline "FGT Lane       :|"
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel  $phy $channel 0xFFFFC $verbose];  
		set lane [expr $readout & 0x03]
		puts -nonewline "[format %8d $lane]|"	
	}
} else {
	puts -nonewline "FHT Lane       :|"
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel  $phy $channel 0xFFFFC $verbose];  
		set lane [expr $readout & 0x03]
		puts -nonewline "[format %8d $lane]|"	
	}
}
puts ""

puts -nonewline "Line Encoding  :|"   
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
	if {$fgt} {
		if {$fgt_pam4} {
			puts -nonewline "    PAM4|"  
			} else {
			puts -nonewline "     NRZ|"  		
			} 
	} else {
		if {$fht_pam4} {
			puts -nonewline "    PAM4|"  
			} else {
			puts -nonewline "     NRZ|"  		
			}
	} 	
}
puts ""

#TBC tx_ready for FHT

puts -nonewline "tx_ready       :|"
for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
	if {$fgt} {
		set tx_ready  [get_tx_ready_fgt  $phy $channel $verbose] 
		} else {
		set tx_ready 1
		#set tx_ready  [get_tx_ready_fht  $phy $channel $verbose] 		
		}
	puts -nonewline "[format %8d $tx_ready]|"	
}
puts ""


puts -nonewline "rx_ready       :|"
for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
	if {$fgt} {
		set rx_ready  [get_rx_ready_fgt  $phy $channel $verbose] 
		} else {
		set rx_ready  [get_rx_ready_fht  $phy $channel $verbose] 		
		}
	puts -nonewline "[format %8d $rx_ready]|"	
}
puts ""


puts -nonewline "SerialLoop     :|"
for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
	if {$fgt} {
		set readout  [rd_channel_ftile  $phy $channel $LOOPBACK_ADDR_FGT $verbose] 
		set serial_loop [expr [expr $readout >> 1] & 0x0001] 
	} else {
		set readout  [rd_channel_ftile  $phy $channel $LOOPBACK_ADDR_FHT $verbose] 
		set serial_loop [expr [expr $readout >> 14] & 0x0001]
	}
	puts -nonewline "[format %8d $serial_loop]|"	
}
puts ""

puts -nonewline "Reverse //Loop :|"
for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
	if {$fgt} {
		set readout  [rd_channel_ftile  $phy $channel $LOOPBACK_ADDR_FGT $verbose] 
		set rev_parallel [expr [expr $readout >> 2] & 0x0001]
	} else {
		set readout  [rd_channel_ftile  $phy $channel $LOOPBACK_ADDR_FHT $verbose] 
		set rev_parallel [expr [expr $readout >> 0] & 0x0001]
	}	
	puts -nonewline "[format %8d $rev_parallel]|"	
}
puts ""

if {$fht} {
	puts -nonewline "PreTap3        :|"
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x45084 $verbose] 
		set temp1 [expr [expr $readout >> 18] & 0x0000003F]
		set temp2 [twos_complement_6bit $temp1]
		set pretap3 [expr $temp2/4.0]
		puts -nonewline "[format %8.2f $pretap3]|"	
	}
	puts ""
	
	puts -nonewline "PreTap2        :|"
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x45080 $verbose] 
		set temp1 [expr [expr $readout >> 2] & 0x0000003F]
		set temp2 [twos_complement_6bit $temp1]
		set pretap2 [expr $temp2/4.0]
		puts -nonewline "[format %8.2f $pretap2]|"	
	}
	puts ""

	puts -nonewline "PreTap1        :|"
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x45080 $verbose] 
		set temp1 [expr [expr $readout >> 8] & 0x003F]		
		set temp2 [twos_complement_6bit $temp1]
		set pretap1 [expr $temp2/2.0]
		puts -nonewline "[format %8.2f $pretap1]|"	
	}
	puts ""	
	
	puts -nonewline "MainTap        :|"	
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x45080 $verbose] 
		set temp1 [expr [expr $readout >> 14] & 0x0007F]
		set maintap [expr $temp1/2.0]
		puts -nonewline "[format %8.2f $maintap]|"	
	}
	puts ""	

	puts -nonewline "PostTap1       :|"
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x45080 $verbose] 
		set temp1 [expr [expr $readout >> 21] & 0x003F]
		set temp2 [twos_complement_6bit $temp1]
		set posttap1 [expr $temp2/2.0]
		puts -nonewline "[format %8.2f $posttap1]|"	
	}
	puts ""		

	puts -nonewline "PostTap2       :|"
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x45084 $verbose] 
		set temp1 [expr [expr $readout >> 0] & 0x003F]
		set temp2 [twos_complement_6bit $temp1]
		set posttap2 [expr $temp2/4.0]
		puts -nonewline "[format %8.2f $posttap2]|"	
	}
	puts ""	

	puts -nonewline "PostTap3       :|"
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x45084 $verbose] 
		set temp1 [expr [expr $readout >> 6] & 0x003F]
		set temp2 [twos_complement_6bit $temp1]
		set posttap3 [expr $temp2/4.0]
		puts -nonewline "[format %8.2f $posttap3]|"	
	}
	puts ""
	
	puts -nonewline "PostTap4       :|"
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x45084 $verbose] 
		set temp1 [expr [expr $readout >> 12] & 0x003F]
		set temp2 [twos_complement_6bit $temp1]
		set posttap4 [expr $temp2/4.0]
		puts -nonewline "[format %8.2f $posttap4]|"	
	}
	puts ""	
	
	# set fht_tx_sum1 [expr (abs($pretap3) + abs($pretap2) + abs($pretap1) + abs($maintap) + abs($posttap1) + abs($posttap2) + abs($posttap3) + abs($posttap4))]
	# set fht_tx_sum2 [expr (abs($pretap3) + abs($pretap2) + abs($pretap1) + abs($posttap1) + abs($posttap2)  + abs($posttap3) + abs($posttap4))]

	# if {($fht_tx_sum1 <= 41.5) && ($fht_tx_sum2 <= $maintap)} {
		 # set fht_tx_setting_valid 1
	 # } else { 
		 # set fht_tx_setting_valid 0
	 # }
	# puts -nonewline "FHT TXPMA Valid:|"
	# for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		# puts -nonewline "[format %8d $fht_tx_setting_valid]|"			
	# }
	# puts ""
	
	puts -nonewline "VGA Gain St1   :|"
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x4382C $verbose] 
		set temp1 [expr [expr $readout >> 0] & 0x003F]
		set fht_vga_gain_1_n [GrayToBinary $temp1]
		set temp2 [expr [expr $readout >> 6] & 0x003F]		
		set fht_vga_gain_1_p [GrayToBinary $temp2]
		set fht_vga_gain_1 [expr ($fht_vga_gain_1_n + $fht_vga_gain_1_p)]
		puts -nonewline "[format %8.2f $fht_vga_gain_1]|"	
	}
	puts ""	

	puts -nonewline "VGA Gain St2   :|"
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x43830 $verbose] 
		set temp1 [expr [expr $readout >> 0] & 0x003F]
		set fht_vga_gain_2_n [GrayToBinary $temp1]
		set temp2 [expr [expr $readout >> 6] & 0x003F]		
		set fht_vga_gain_2_p [GrayToBinary $temp2]
		set fht_vga_gain_2 [expr ($fht_vga_gain_2_n + $fht_vga_gain_2_p)]
		puts -nonewline "[format %8.2f $fht_vga_gain_2]|"	
	}
	puts ""	
	
	puts -nonewline "VGA Gain St3   :|"
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x43834 $verbose] 
		set temp1 [expr [expr $readout >> 0] & 0x003F]
		set fht_vga_gain_3_n [GrayToBinary $temp1]
		set temp2 [expr [expr $readout >> 6] & 0x003F]		
		set fht_vga_gain_3_p [GrayToBinary $temp2]
		set fht_vga_gain_3 [expr ($fht_vga_gain_3_n + $fht_vga_gain_3_p)]
		puts -nonewline "[format %8.2f $fht_vga_gain_3]|"	
	}
	puts ""	

	puts -nonewline "CTLE Boost St1 :|"	
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x4382C $verbose] 
		set temp1 [expr [expr $readout >> 13] & 0x007F]		
		set fht_ctle_boost_st1 [GrayToBinary $temp1]
		puts -nonewline "[format %8.2f $fht_ctle_boost_st1]|"	
	}
	puts ""		

	puts -nonewline "CTLE Boost St2 :|"	
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x43830 $verbose] 
		set temp1 [expr [expr $readout >> 13] & 0x007F]		
		set fht_ctle_boost_st2 [GrayToBinary $temp1]
		puts -nonewline "[format %8.2f $fht_ctle_boost_st2]|"	
	}
	puts ""	
	
	puts -nonewline "CTLE Boost     :|"	
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x4382C $verbose] 
		set temp1 [expr [expr $readout >> 13] & 0x007F]		
		set fht_ctle_boost_st1 [GrayToBinary $temp1]	
		set readout  [rd_channel_ftile  $phy $channel 0x43830 $verbose] 
		set temp1 [expr [expr $readout >> 13] & 0x007F]		
		set fht_ctle_boost_st2 [GrayToBinary $temp1]
		set fht_ctle_boost [expr ($fht_ctle_boost_st1 + $fht_ctle_boost_st2)]
		puts -nonewline "[format %8.2f $fht_ctle_boost]|"	
	}
	puts ""		

	puts -nonewline "FFE_PRE_TAP3   :|"	
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x41820 $verbose] 
		set temp1 [expr [expr $readout >> 8] & 0x00FF]		
		set temp2 [twos_complement_8bit $temp1]
		puts -nonewline "[format %8.2f $temp2]|"	
	}
	puts ""	

	puts -nonewline "FFE_PRE_TAP2   :|"	
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x41820 $verbose] 
		set temp1 [expr [expr $readout >> 16] & 0x00FF]		
		set temp2 [twos_complement_8bit $temp1]
		puts -nonewline "[format %8.2f $temp2]|"	
	}
	puts ""

	puts -nonewline "FFE_PRE_TAP1   :|"	
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x41820 $verbose] 
		set temp1 [expr [expr $readout >> 24] & 0x00FF]		
		set temp2 [twos_complement_8bit $temp1]
		puts -nonewline "[format %8.2f $temp2]|"	
	}
	puts ""	
	
	puts -nonewline "FFE_POST_TAP1  :|"	
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x41814 $verbose] 
		set temp1 [expr [expr $readout >> 0] & 0x00FF]		
		set temp2 [twos_complement_8bit $temp1]
		puts -nonewline "[format %8.2f $temp2]|"	
	}
	puts ""

	puts -nonewline "FFE_POST_TAP2  :|"	
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x41814 $verbose] 
		set temp1 [expr [expr $readout >> 8] & 0x00FF]		
		set temp2 [twos_complement_8bit $temp1]
		puts -nonewline "[format %8.2f $temp2]|"	
	}
	puts ""	

	puts -nonewline "FFE_POST_TAP3  :|"	
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x41814 $verbose] 
		set temp1 [expr [expr $readout >> 16] & 0x00FF]		
		set temp2 [twos_complement_8bit $temp1]
		puts -nonewline "[format %8.2f $temp2]|"	
	}
	puts ""	

	puts -nonewline "FFE_POST_TAP4  :|"	
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x41814 $verbose] 
		set temp1 [expr [expr $readout >> 24] & 0x00FF]		
		set temp2 [twos_complement_8bit $temp1]
		puts -nonewline "[format %8.2f $temp2]|"	
	}
	puts ""	
	
	puts -nonewline "FFE_POST_TAP5  :|"	
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x41818 $verbose] 
		set temp1 [expr [expr $readout >> 0] & 0x00FF]		
		set temp2 [twos_complement_8bit $temp1]
		puts -nonewline "[format %8.2f $temp2]|"	
	}
	puts ""

	puts -nonewline "FFE_POST_TAP6  :|"	
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x41818 $verbose] 
		set temp1 [expr [expr $readout >> 8] & 0x00FF]		
		set temp2 [twos_complement_8bit $temp1]
		puts -nonewline "[format %8.2f $temp2]|"	
	}
	puts ""	

	puts -nonewline "FFE_POST_TAP7  :|"	
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x41818 $verbose] 
		set temp1 [expr [expr $readout >> 16] & 0x00FF]		
		set temp2 [twos_complement_8bit $temp1]
		puts -nonewline "[format %8.2f $temp2]|"	
	}
	puts ""	

	puts -nonewline "FFE_POST_TAP8  :|"	
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x41818 $verbose] 
		set temp1 [expr [expr $readout >> 24] & 0x00FF]		
		set temp2 [twos_complement_8bit $temp1]
		puts -nonewline "[format %8.2f $temp2]|"	
	}
	puts ""		

	puts -nonewline "FFE_POST_TAP9  :|"	
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x4181C $verbose] 
		set temp1 [expr [expr $readout >> 0] & 0x00FF]		
		set temp2 [twos_complement_8bit $temp1]
		puts -nonewline "[format %8.2f $temp2]|"	
	}
	puts ""

	puts -nonewline "FFE_POST_TAP10 :|"	
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x4181C $verbose] 
		set temp1 [expr [expr $readout >> 8] & 0x00FF]		
		set temp2 [twos_complement_8bit $temp1]
		puts -nonewline "[format %8.2f $temp2]|"	
	}
	puts ""	

	puts -nonewline "FFE_POST_TAP11 :|"	
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x4181C $verbose] 
		set temp1 [expr [expr $readout >> 16] & 0x00FF]		
		set temp2 [twos_complement_8bit $temp1]
		puts -nonewline "[format %8.2f $temp2]|"	
	}
	puts ""	

	puts -nonewline "FFE_POST_TAP12 :|"	
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x4181C $verbose] 
		set temp1 [expr [expr $readout >> 24] & 0x00FF]		
		set temp2 [twos_complement_8bit $temp1]
		puts -nonewline "[format %8.2f $temp2]|"	
	}
	puts ""	

	puts -nonewline "FFE_POST_TAP13 :|"	
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x41820 $verbose] 
		set temp1 [expr [expr $readout >> 0] & 0x00FF]		
		set temp2 [twos_complement_8bit $temp1]
		puts -nonewline "[format %8.2f $temp2]|"	
	}
	puts ""	
	

	puts -nonewline "SNR (db)       :|"	
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set rx_ready  [get_rx_ready_fht  $phy $channel $verbose]
		if {$rx_ready} {
			set fht_snr [get_snr_fht $phy $channel]
			set fht_snr_db [expr 10*log10($fht_snr)]
		} else {
			set fht_snr_db 0.0
		}
		puts -nonewline "[format %8.2f $fht_snr_db]|"	
	}
	puts ""	
	





} else {
	puts -nonewline "PreTap2        :|"
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x47830 $verbose] 
		set pretap2 [expr [expr $readout >> 16] & 0x0007]
		puts -nonewline "[format %8d $pretap2]|"	
	}
	puts ""

	puts -nonewline "PreTap1        :|"
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x47830 $verbose] 
		set pretap1 [expr [expr $readout >> 5] & 0x001F]
		puts -nonewline "[format %8d $pretap1]|"	
	}
	puts ""

	puts -nonewline "MainTap        :|"
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x47830 $verbose] 
		set maintap [expr [expr $readout >> 10] & 0x003F]
		puts -nonewline "[format %8d $maintap]|"	
	}
	puts ""

	puts -nonewline "PostTap1       :|"
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x47830 $verbose] 
		set posttap1 [expr [expr $readout >> 0] & 0x001F]
		puts -nonewline "[format %8d $posttap1]|"	
	}
	puts ""

	puts -nonewline "DFETap1        :|"
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x41914 $verbose] 
		set temp [expr [expr $readout >> 0] & 0x003F]
		set dfetap [decode_tap_6bits $temp]
		puts -nonewline "[format %8d $dfetap]|"	
	}
	puts ""

	puts -nonewline "DFETap2        :|"
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x41914 $verbose] 
		set temp [expr [expr $readout >> 8] & 0x007F]
		set dfetap [decode_tap_7bits $temp]
		puts -nonewline "[format %8d $dfetap]|"	
	}
	puts ""

	puts -nonewline "DFETap3        :|"
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x41914 $verbose] 
		set temp [expr [expr $readout >> 16] & 0x007F]
		set dfetap [decode_tap_7bits $temp]
		puts -nonewline "[format %8d $dfetap]|"	
	}
	puts ""

	puts -nonewline "DFETap4        :|"
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x41914 $verbose] 
		set temp [expr [expr $readout >> 24] & 0x003F]
		set dfetap [decode_tap_6bits $temp]
		puts -nonewline "[format %8d $dfetap]|"	
	}
	puts ""

	puts -nonewline "DFETap5        :|"
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x41918 $verbose] 
		set temp [expr [expr $readout >> 0] & 0x003F]
		set dfetap [decode_tap_6bits $temp]
		puts -nonewline "[format %8d $dfetap]|"	
	}
	puts ""

	puts -nonewline "DFETap6        :|"
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x41918 $verbose] 
		set temp [expr [expr $readout >> 8] & 0x003F]
		set dfetap [decode_tap_6bits $temp]
		puts -nonewline "[format %8d $dfetap]|"	
	}
	puts ""

	puts -nonewline "DFETap7        :|"
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x41918 $verbose] 
		set temp [expr [expr $readout >> 16] & 0x003F]
		set dfetap [decode_tap_6bits $temp]
		puts -nonewline "[format %8d $dfetap]|"	
	}
	puts ""

	puts -nonewline "DFETap8        :|"
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x41918 $verbose] 
		set temp [expr [expr $readout >> 24] & 0x003F]
		set dfetap [decode_tap_6bits $temp]
		puts -nonewline "[format %8d $dfetap]|"	
	}
	puts ""

	puts -nonewline "DFETap9        :|"
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x4191C $verbose] 
		set temp [expr [expr $readout >> 0] & 0x003F]
		set dfetap [decode_tap_6bits $temp]
		puts -nonewline "[format %8d $dfetap]|"	
	}
	puts ""

	puts -nonewline "DFETap10       :|"
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x4191C $verbose] 
		set temp [expr [expr $readout >> 8] & 0x003F]
		set dfetap [decode_tap_6bits $temp]
		puts -nonewline "[format %8d $dfetap]|"	
	}
	puts ""

	puts -nonewline "DFETap11       :|"
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x4191C $verbose] 
		set temp [expr [expr $readout >> 16] & 0x003F]
		set dfetap [decode_tap_6bits $temp]
		puts -nonewline "[format %8d $dfetap]|"	
	}
	puts ""

	puts -nonewline "DFETap12       :|"
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x4191C $verbose] 
		set temp [expr [expr $readout >> 24] & 0x003F]
		set dfetap [decode_tap_6bits $temp]
		puts -nonewline "[format %8d $dfetap]|"	
	}
	puts ""

	puts -nonewline "DFETap13       :|"
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x41920 $verbose] 
		set temp [expr [expr $readout >> 0] & 0x003F]
		set dfetap [decode_tap_6bits $temp]
		puts -nonewline "[format %8d $dfetap]|"	
	}
	puts ""

	puts -nonewline "DFETap14       :|"
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x41920 $verbose] 
		set temp [expr [expr $readout >> 8] & 0x003F]
		set dfetap [decode_tap_6bits $temp]
		puts -nonewline "[format %8d $dfetap]|"	
	}
	puts ""

	puts -nonewline "DFETap15       :|"
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x41920 $verbose] 
		set temp [expr [expr $readout >> 16] & 0x003F]
		set dfetap [decode_tap_6bits $temp]
		puts -nonewline "[format %8d $dfetap]|"	
	}
	puts ""

	puts -nonewline "DFETap16       :|"
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set readout  [rd_channel_ftile  $phy $channel 0x41920 $verbose] 
		set temp [expr [expr $readout >> 24] & 0x003F]
		set dfetap [decode_tap_6bits $temp]
		puts -nonewline "[format %8d $dfetap]|"	
	}
	puts ""


	puts -nonewline "FOM            :|"
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set fom  [get_fom $phy $channel 0];  
		if {$fom < 60000} {
			puts -nonewline "[format %8d $fom]|"	
			} else {
			puts -nonewline "--------|" 
			}
	}
	puts ""

	puts -nonewline "VGA            :|"
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set vga  [get_vga $phy $channel 0];  
		puts -nonewline "[format %8d $vga]|"	
	}
	puts ""

	puts -nonewline "CTLE           :|"
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
		set ctle  [get_ctle $phy $channel 0];  
		puts -nonewline "[format %8d $ctle]|"	
	}
	puts ""

	puts -nonewline "ConvTime       :|"
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
	set convtime [get_cpidata  $phy $channel 0x0 0x90 $verbose]
		puts -nonewline "[format %8d $convtime]|"	
	}

	puts " ms"

	puts -nonewline "Rx_Flow_State  :|"
	for {set channel 0} {$channel < $number_of_lanes} {incr channel} {
	set Rx_Flow_State [get_cpidata  $phy $channel 0x3 0x90 $verbose]
		if {$Rx_Flow_State == 2} {
			puts -nonewline "  SigDet|"
		} else {
		puts -nonewline "[format %8d $Rx_Flow_State]|"
		}
	}
}




}
puts {show_pma_settings_ftile {phy number_of_lanes}  }
puts {example useage :  show_pma_settings_ftile ftile_phy_15 8}
puts ""

###############################################################################		
#check_cpi_test_status
###############################################################################

proc check_cpi_test_status {phy channel opcode verbose} {

global offset_ftile
global FTILE_SLAVE_MAP

array set ftile_slave_array $FTILE_SLAVE_MAP
	
	set success 0
		
	set readout [rd_channel  $phy $channel 0xFFFFC $verbose]
	set lane [expr $readout & 0x03]
		
	set cpi_command [expr [expr 0x0 << 16] + [expr 1 << 15] + [expr 0 <<13] + [expr $lane << 8] + $opcode]

	rmw_channel $phy $channel 0x9003C 0xFFFFFFFF $cpi_command $verbose
					 
	after 1

			
	set readout [rd_channel $phy $channel 0x90040 $verbose]
	set cpi_service_requested [expr [expr $readout >> 15] & 0x0001]
	set test_status [expr [expr $readout >> 24] & 0x0003]			
		
		
	set cpi_command [expr [expr 0x0 << 16] + [expr 0 << 15] + [expr 0 <<13] + [expr $lane << 8] + $opcode]

	rmw_channel $phy $channel 0x9003C 0xFFFFFFFF $cpi_command $verbose	
					 

	# read returns [15] should be 0 
	set cpi_service_requested 1
			
	while {$cpi_service_requested == 1} {				
		set readout [rd_channel $phy $channel 0x90040 $verbose]
		set cpi_service_requested [expr [expr $readout >> 15] & 0x0001]



	}	

	
	if {$test_status == 3} {
		set success 1
	} else {
		set success 0
	}
		
return $success
	
}


proc get_ehm_fgt {phy channel basic_measure_config ber_target pos verbose} {


#Defines the eventrates for different BER targets
set DEBUG_EHM 0

set EVENT_RATE_1E3_POS_LSB1	0xa029
set EVENT_RATE_1E3_POS_LSB2	0x419
set EVENT_RATE_1E3_POS_MSB		0x100

set EVENT_RATE_1E3_NEG_LSB1	0x5fd7
set EVENT_RATE_1E3_NEG_LSB2	0xfbe6
set EVENT_RATE_1E3_NEG_MSB		0xff

set EVENT_RATE_1E4_POS_LSB1	0xde3a
set EVENT_RATE_1E4_POS_LSB2	0x68
set EVENT_RATE_1E4_POS_MSB		0x100

set EVENT_RATE_1E4_NEG_LSB1	0x21c6
set EVENT_RATE_1E4_NEG_LSB2	0xff97
set EVENT_RATE_1E4_NEG_MSB		0xff

set EVENT_RATE_1E5_POS_LSB1	0x7c61
set EVENT_RATE_1E5_POS_LSB2	0xa
set EVENT_RATE_1E5_POS_MSB		0x100

set EVENT_RATE_1E5_NEG_LSB1	0x839f
set EVENT_RATE_1E5_NEG_LSB2	0xfff5
set EVENT_RATE_1E5_NEG_MSB		0xff

set EVENT_RATE_1E6_POS_LSB1	0xc6f
set EVENT_RATE_1E6_POS_LSB2	0x1
set EVENT_RATE_1E6_POS_MSB		0x100

set EVENT_RATE_1E6_NEG_LSB1	0xf391
set EVENT_RATE_1E6_NEG_LSB2	0xfffe
set EVENT_RATE_1E6_NEG_MSB		0xff

set EVENT_RATE_1E7_POS_LSB1	0x1ad7
set EVENT_RATE_1E7_POS_LSB2	0x0
set EVENT_RATE_1E7_POS_MSB		0x100

set EVENT_RATE_1E7_NEG_LSB1	0xe529
set EVENT_RATE_1E7_NEG_LSB2	0xffff
set EVENT_RATE_1E7_NEG_MSB		0xff

set EVENT_RATE_1E8_POS_LSB1	0x2af
set EVENT_RATE_1E8_POS_LSB2	0x0
set EVENT_RATE_1E8_POS_MSB		0x100

set EVENT_RATE_1E8_NEG_LSB1	0xfd51
set EVENT_RATE_1E8_NEG_LSB2	0xffff
set EVENT_RATE_1E8_NEG_MSB		0xff

set EVENT_RATE_1E9_POS_LSB1	0x44
set EVENT_RATE_1E9_POS_LSB2	0x0
set EVENT_RATE_1E9_POS_MSB		0x100

set EVENT_RATE_1E9_NEG_LSB1	0xffbc
set EVENT_RATE_1E9_NEG_LSB2	0xffff
set EVENT_RATE_1E9_NEG_MSB		0xff

set EVENT_RATE_1E10_POS_LSB1	0x6
set EVENT_RATE_1E10_POS_LSB2	0x0
set EVENT_RATE_1E10_POS_MSB	0x100

set EVENT_RATE_1E10_NEG_LSB1	0xfffa
set EVENT_RATE_1E10_NEG_LSB2	0xffff
set EVENT_RATE_1E10_NEG_MSB	0xff

switch $ber_target {
		 3 {
				set event_rate_lsb1_int_pos 				$EVENT_RATE_1E3_POS_LSB1 
				set event_rate_lsb2_int_pos	 			$EVENT_RATE_1E3_POS_LSB2
				set event_rate_msb_and_sign_int_pos		$EVENT_RATE_1E3_POS_MSB
				set event_rate_lsb1_int_neg 				$EVENT_RATE_1E3_NEG_LSB1 
				set event_rate_lsb2_int_neg	 			$EVENT_RATE_1E3_NEG_LSB2
				set event_rate_msb_and_sign_int_neg		$EVENT_RATE_1E3_NEG_MSB	
		 }
		 4 {
				set event_rate_lsb1_int_pos 				$EVENT_RATE_1E4_POS_LSB1 
				set event_rate_lsb2_int_pos	 			$EVENT_RATE_1E4_POS_LSB2
				set event_rate_msb_and_sign_int_pos		$EVENT_RATE_1E4_POS_MSB
				set event_rate_lsb1_int_neg 				$EVENT_RATE_1E4_NEG_LSB1 
				set event_rate_lsb2_int_neg	 			$EVENT_RATE_1E4_NEG_LSB2
				set event_rate_msb_and_sign_int_neg		$EVENT_RATE_1E4_NEG_MSB	
		 }	 
		 5 {
				set event_rate_lsb1_int_pos 				$EVENT_RATE_1E5_POS_LSB1 
				set event_rate_lsb2_int_pos	 			$EVENT_RATE_1E5_POS_LSB2
				set event_rate_msb_and_sign_int_pos		$EVENT_RATE_1E5_POS_MSB
				set event_rate_lsb1_int_neg 				$EVENT_RATE_1E5_NEG_LSB1 
				set event_rate_lsb2_int_neg	 			$EVENT_RATE_1E5_NEG_LSB2
				set event_rate_msb_and_sign_int_neg		$EVENT_RATE_1E5_NEG_MSB	
		 }
		 6 {
				set event_rate_lsb1_int_pos 				$EVENT_RATE_1E6_POS_LSB1 
				set event_rate_lsb2_int_pos	 			$EVENT_RATE_1E6_POS_LSB2
				set event_rate_msb_and_sign_int_pos		$EVENT_RATE_1E6_POS_MSB
				set event_rate_lsb1_int_neg 				$EVENT_RATE_1E6_NEG_LSB1 
				set event_rate_lsb2_int_neg	 			$EVENT_RATE_1E6_NEG_LSB2
				set event_rate_msb_and_sign_int_neg		$EVENT_RATE_1E6_NEG_MSB	
		 }
		 7 {
				set event_rate_lsb1_int_pos 				$EVENT_RATE_1E7_POS_LSB1 
				set event_rate_lsb2_int_pos	 			$EVENT_RATE_1E7_POS_LSB2
				set event_rate_msb_and_sign_int_pos		$EVENT_RATE_1E7_POS_MSB
				set event_rate_lsb1_int_neg 				$EVENT_RATE_1E7_NEG_LSB1 
				set event_rate_lsb2_int_neg	 			$EVENT_RATE_1E7_NEG_LSB2
				set event_rate_msb_and_sign_int_neg		$EVENT_RATE_1E7_NEG_MSB	
		 }
		 8 {
				set event_rate_lsb1_int_pos 				$EVENT_RATE_1E8_POS_LSB1 
				set event_rate_lsb2_int_pos	 			$EVENT_RATE_1E8_POS_LSB2
				set event_rate_msb_and_sign_int_pos		$EVENT_RATE_1E8_POS_MSB
				set event_rate_lsb1_int_neg 				$EVENT_RATE_1E8_NEG_LSB1 
				set event_rate_lsb2_int_neg	 			$EVENT_RATE_1E8_NEG_LSB2
				set event_rate_msb_and_sign_int_neg		$EVENT_RATE_1E8_NEG_MSB	
		 }
		 9 {
				set event_rate_lsb1_int_pos 				$EVENT_RATE_1E9_POS_LSB1 
				set event_rate_lsb2_int_pos	 			$EVENT_RATE_1E9_POS_LSB2
				set event_rate_msb_and_sign_int_pos		$EVENT_RATE_1E9_POS_MSB
				set event_rate_lsb1_int_neg 				$EVENT_RATE_1E9_NEG_LSB1 
				set event_rate_lsb2_int_neg	 			$EVENT_RATE_1E9_NEG_LSB2
				set event_rate_msb_and_sign_int_neg		$EVENT_RATE_1E9_NEG_MSB	
		 }	 
		 default {
				set event_rate_lsb1_int_pos 				$EVENT_RATE_1E6_POS_LSB1 
				set event_rate_lsb2_int_pos	 			$EVENT_RATE_1E6_POS_LSB2
				set event_rate_msb_and_sign_int_pos		$EVENT_RATE_1E6_POS_MSB
				set event_rate_lsb1_int_neg 				$EVENT_RATE_1E6_NEG_LSB1 
				set event_rate_lsb2_int_neg	 			$EVENT_RATE_1E6_NEG_LSB2
				set event_rate_msb_and_sign_int_neg		$EVENT_RATE_1E6_NEG_MSB	
		 }
	}	


		
	###############################################################################
	#Setup test for Eye Height 
	###############################################################################

	if {$DEBUG_EHM} {
		puts {==============>DEBUG_EHM: Setup Test for Eye Height}
	}

	set readout [cpi_request_fgt $phy $channel  0x07 0x45 1 1 $verbose]
	set readout [cpi_request_fgt $phy $channel  0x07 0x45 0 1 $verbose]	

			
	###############################################################################
	#Clear and Reset previous parameters
	###############################################################################

	if {$DEBUG_EHM} {
		puts {==============>DEBUG_EHM: Clear and Reset previous parameters}
	}

	set readout [cpi_request_fgt $phy $channel  0x05 0x91 1 1 $verbose]
	set readout [cpi_request_fgt $phy $channel  0x05 0x91 0 1 $verbose]	
	
		

	###############################################################################
	#config :  Set Cursor ID, slicer ID, interfering symbol and victim
	###############################################################################

	if {$DEBUG_EHM} {
		puts "==============>DEBUG_EHM: config : Set basic_measure_config to [format 0x%x $basic_measure_config]"
	}

	set readout [cpi_request_fgt $phy $channel  $basic_measure_config 0x48 1 1 $verbose]
	set readout [cpi_request_fgt $phy $channel  $basic_measure_config 0x48 0 1 $verbose]	

	
	###############################################################################
	#config :  Set event_rate_lsb1_int
	###############################################################################
	
	if {$pos == 1} {
		if {$DEBUG_EHM} {
			puts "==============>DEBUG_EHM: config : Set event_rate_lsb1_int to [format 0x%x $event_rate_lsb1_int_pos]"
		}	

		set readout [cpi_request_fgt $phy $channel  $event_rate_lsb1_int_pos 0x48 1 1 $verbose]
		set readout [cpi_request_fgt $phy $channel  $event_rate_lsb1_int_pos 0x48 0 1 $verbose]	
	} else {

		if {$DEBUG_EHM} {
			puts "==============>DEBUG_EHM: config : Set event_rate_lsb1_int to [format 0x%x $event_rate_lsb1_int_neg]"
		}	

		set readout [cpi_request_fgt $phy $channel  $event_rate_lsb1_int_neg 0x48 1 1 $verbose]
		set readout [cpi_request_fgt $phy $channel  $event_rate_lsb1_int_neg 0x48 0 1 $verbose]	

	}		
	
	###############################################################################
	#config :  Set event_rate_lsb2_int
	###############################################################################
	
	if {$pos == 1} {
		if {$DEBUG_EHM} {
			puts "==============>DEBUG_EHM: config : Set event_rate_lsb2_int to [format 0x%x $event_rate_lsb2_int_pos]"
		}	

		set readout [cpi_request_fgt $phy $channel  $event_rate_lsb2_int_pos 0x48 1 1 $verbose]
		set readout [cpi_request_fgt $phy $channel  $event_rate_lsb2_int_pos 0x48 0 1 $verbose]	
	} else {

		if {$DEBUG_EHM} {
			puts "==============>DEBUG_EHM: config : Set event_rate_lsb2_int to [format 0x%x $event_rate_lsb2_int_neg]"
		}	

		set readout [cpi_request_fgt $phy $channel  $event_rate_lsb2_int_neg 0x48 1 1 $verbose]
		set readout [cpi_request_fgt $phy $channel  $event_rate_lsb2_int_neg 0x48 0 1 $verbose]	

	}	

	###############################################################################
	#config :  event_rate_msb_and_sign_int
	###############################################################################
	
	if {$pos == 1} {
		if {$DEBUG_EHM} {
			puts "==============>DEBUG_EHM: config : Set event_rate_msb_and_sign_int to [format 0x%x $event_rate_msb_and_sign_int_pos]"
		}	

		set readout [cpi_request_fgt $phy $channel  $event_rate_msb_and_sign_int_pos 0x48 1 1 $verbose]
		set readout [cpi_request_fgt $phy $channel  $event_rate_msb_and_sign_int_pos 0x48 0 1 $verbose]	
	} else {

		if {$DEBUG_EHM} {
			puts "==============>DEBUG_EHM: config : Set event_rate_msb_and_sign_int to [format 0x%x $event_rate_msb_and_sign_int_neg]"
		}	

		set readout [cpi_request_fgt $phy $channel  $event_rate_msb_and_sign_int_neg 0x48 1 1 $verbose]
		set readout [cpi_request_fgt $phy $channel  $event_rate_msb_and_sign_int_neg 0x48 0 1 $verbose]	

	}
		
		
	
	###############################################################################
	#Start test
	###############################################################################	

	if {$DEBUG_EHM} {
		puts {==============>DEBUG_EHM: Start Test}
	}

	set readout [cpi_request_fgt $phy $channel  0x20 0x0F 1 1 $verbose]
	set readout [cpi_request_fgt $phy $channel  0x20 0x0F 0 1 $verbose]	
	


	if {$DEBUG_EHM} {
		puts {==============>DEBUG_EHM : Wait for 10 ms}
	}
	
	#wait for 10 ms
   after 10

	###############################################################################
	#Check test status
	###############################################################################		

	set success 0
	
	while {$success == 0} {

		if {$DEBUG_EHM} {
			puts {==============>DEBUG_EHM : Check Test Status}
		}
			
		set success [check_cpi_test_status $phy $channel 0x49 $verbose]
		after 10
	}


	if {$success == 1} {

		if {$DEBUG_EHM} {
			puts {==============>DEBUG_EHM : measurement done}
		}
		

		###############################################################################
		#Stop Test
		###############################################################################	

		if {$DEBUG_EHM} {
			puts {==============>DEBUG_EHM : Stop Test}
		}
		

		set readout [cpi_request_fgt $phy $channel  0x21 0x0F 1 1 $verbose]
		set readout [cpi_request_fgt $phy $channel  0x21 0x0F 0 1 $verbose]	
	
		if {$DEBUG_EHM} {
			puts {==============>DEBUG_EHM : Test stopped}
		}	

		###############################################################################
		#Readout result
		###############################################################################	

		if {$DEBUG_EHM} {
			puts {==============>DEBUG_EHM : Read Result}
		}
		
		set readout [get_cpidata $phy $channel 0x0 0x4A $verbose]
		
		if {$DEBUG_EHM} {
			puts "==============>DEBUG_EHM : Readout 0x4A : [format 0x%x $readout]"
		}		
		
	}	


return $readout;

}


###############################################################################
# Perform EHM on FGT
###############################################################################

proc measure_ehm_fgt {phy channel ber_target verbose} {

global offset_ftile
global FTILE_SLAVE_MAP
array set ftile_slave_array $FTILE_SLAVE_MAP


set POS 1
set NEG 0

set CONVERT_TO_MV      1.33

set CORE0_SYMBOL_3		0xdb
set CORE0_SYMBOL_1		0xc9
set CORE0_SYMBOL_MIN_1	0xff
set CORE0_SYMBOL_MIN_3	0xed


set readout [rd_channel_ftile $phy $channel 0x47800 $verbose]
set fgt_pam4 [expr [expr $readout >> 2] & 0x0001]

set rx_ready [get_rx_ready_fgt $phy $channel $verbose]

if {($ber_target < 3) || ($ber_target > 9 )} {
	puts "EHM aborted, not a valid ber_target, please use a value between 3 and 9"
} else {
	if {$rx_ready} {
		set TIME_start [clock clicks -milliseconds]

				if {$fgt_pam4  == 1} {
					puts "PAM4 EHM measurement on Phy $phy Channel $channel with BER-Target of 1E-$ber_target"
				} else {
					puts "NRZ EHM measurement on Phy $phy Channel $channel with BER-Target of 1E-$ber_target"
				}
				puts ""
				puts -nonewline "Please wait for EHM measurement to complete "

		#Top Eye 
		if {$fgt_pam4 == 1} {

			#positive Core0, top eye, symbol 3
			set basic_measure_config $CORE0_SYMBOL_3

			set vertical_eye_fgt_top_pos [get_ehm_fgt $phy $channel $basic_measure_config $ber_target $POS $verbose]
			puts -nonewline "."
			#negative Core0, top eye, symbol 1
			set basic_measure_config $CORE0_SYMBOL_1

			set readout [get_ehm_fgt $phy $channel $basic_measure_config $ber_target $NEG $verbose]
			
			set vertical_eye_fgt_top_neg [twos_complement_12bit $readout]
			puts -nonewline "."
		}


		#Middle Eye 
		if {$fgt_pam4 == 1} {

			#positive Core0, middle eye, symbol 1
			set basic_measure_config $CORE0_SYMBOL_1

			set vertical_eye_fgt_middle_pos [get_ehm_fgt $phy $channel $basic_measure_config $ber_target $POS $verbose]
			puts -nonewline "."
			#positive Core0, middle eye, symbol -1
			set basic_measure_config $CORE0_SYMBOL_MIN_1

			set readout [get_ehm_fgt $phy $channel $basic_measure_config $ber_target $NEG $verbose]
			
			set vertical_eye_fgt_middle_neg [twos_complement_12bit $readout]
			puts -nonewline "."
		} else {
		#NRZ
			#positive Core0, middle eye, symbol 3
			set basic_measure_config $CORE0_SYMBOL_3

			set vertical_eye_fgt_middle_pos [get_ehm_fgt $phy $channel $basic_measure_config $ber_target $POS $verbose]
			puts -nonewline "."
			
			#positive Core0, middle eye, symbol -3
			set basic_measure_config $CORE0_SYMBOL_MIN_3

			set readout [get_ehm_fgt $phy $channel $basic_measure_config $ber_target $NEG $verbose]
			
			set vertical_eye_fgt_middle_neg [twos_complement_12bit $readout]
			puts -nonewline "."
		}

		#Bottom Eye
		if {$fgt_pam4 == 1} {

			#positive Core0, bot eye, symbol -1
			set basic_measure_config $CORE0_SYMBOL_MIN_1

			set readout [get_ehm_fgt $phy $channel $basic_measure_config $ber_target $POS $verbose]
			
			set vertical_eye_fgt_bot_pos [twos_complement_12bit $readout]
			puts -nonewline "."
			
			#negative Core0, bot eye symbol -3
			set basic_measure_config $CORE0_SYMBOL_MIN_3

			set readout [get_ehm_fgt $phy $channel $basic_measure_config $ber_target $NEG $verbose]
			
			set vertical_eye_fgt_bot_neg [twos_complement_12bit $readout]
		}
			set TIME_taken [expr [clock clicks -milliseconds] - $TIME_start]	
			puts -nonewline " Done!"
			puts ""
			puts "EHM Measurement time $TIME_taken ms"
			
		puts ""
			if {$fgt_pam4 == 1} {
				set vertical_eye_fgt_top 		[expr $vertical_eye_fgt_top_pos - $vertical_eye_fgt_top_neg]
				}
			set vertical_eye_fgt_middle 	[expr $vertical_eye_fgt_middle_pos - $vertical_eye_fgt_middle_neg]
			if {$fgt_pam4 == 1} {			
				set vertical_eye_fgt_bot 		[expr -($vertical_eye_fgt_bot_neg) - (- $vertical_eye_fgt_bot_pos)]
				}
			puts "----------------------------------------------------------------------"
			if {$fgt_pam4  == 1} {
			puts "Phy : $phy  Channel : $channel Top Eye Positive         : [format %8.2f [expr $CONVERT_TO_MV * $vertical_eye_fgt_top_pos]] mV"
			puts "Phy : $phy  Channel : $channel Top Eye Negative         : [format %8.2f [expr $CONVERT_TO_MV * $vertical_eye_fgt_top_neg]] mV"
			puts "Phy : $phy  Channel : $channel Top Eye Height           : [format %8.2f [expr $CONVERT_TO_MV * $vertical_eye_fgt_top]] mV"		
			puts "----------------------------------------------------------------------"
			}
			
			if {$fgt_pam4  == 1} {
			puts "Phy : $phy  Channel : $channel Middle Eye Positive      : [format %8.2f [expr $CONVERT_TO_MV * $vertical_eye_fgt_middle_pos]] mV"
			puts "Phy : $phy  Channel : $channel Middle Eye Negative      : [format %8.2f [expr $CONVERT_TO_MV * $vertical_eye_fgt_middle_neg]] mV"
			puts "Phy : $phy  Channel : $channel Middle Eye Height        : [format %8.2f [expr $CONVERT_TO_MV * $vertical_eye_fgt_middle]] mV"	
			puts "----------------------------------------------------------------------"
			} else {	
			puts "Phy : $phy  Channel : $channel Eye Positive             : [format %8.2f [expr $CONVERT_TO_MV * $vertical_eye_fgt_middle_pos]] mV"	
			puts "Phy : $phy  Channel : $channel Eye Negative             : [format %8.2f [expr $CONVERT_TO_MV * $vertical_eye_fgt_middle_neg]] mV"	
			puts "Phy : $phy  Channel : $channel Eye Height               : [format %8.2f [expr $CONVERT_TO_MV * $vertical_eye_fgt_middle]] mV"		
			puts "----------------------------------------------------------------------"
			}
			
			if {$fgt_pam4  == 1} {
			puts "Phy : $phy  Channel : $channel Bottom Eye Positive      : [format %8.2f [expr $CONVERT_TO_MV * $vertical_eye_fgt_bot_pos]] mV"
			puts "Phy : $phy  Channel : $channel Bottom Eye Negative      : [format %8.2f [expr $CONVERT_TO_MV * $vertical_eye_fgt_bot_neg]] mV"
			puts "Phy : $phy  Channel : $channel Bottom Eye Height        : [format %8.2f [expr $CONVERT_TO_MV * $vertical_eye_fgt_bot]] mV"		
			puts "----------------------------------------------------------------------"	
			}
					
		} else {
			puts "EHM aborted because rx_ready is not asserted on Phy $phy Channel $channel"
		}
	}
}
puts {measure_ehm_fgt {phy channel ber_target verbose}  }
puts {example useage measure ehm on fgt with ber target of 1E-6:  measure_ehm_fgt ftile_phy_15 0 6 0}
puts ""

proc get_snr_fht {phy channel} {

	#read out SNR FHT

	#measure SNR on lane 0 bitprog register 0x619A8
	#0xa | (lane & 0x3 ) << 6 | 0x5 << 28
	#e.g. 0x5000000A (lane 0)

	set verbose 0
	
	set readout  [rd_channel  $phy $channel 0xFFFFC $verbose];
	set lane [expr $readout & 0x03]	


	
	set bitprog_command [expr 0xA + [expr $lane<<6] + [expr 0x5 << 28]] 

	rmw_channel $phy $channel 0x619A8 0xFFFFFFFF $bitprog_command $verbose	
	#wait 1 ms (mandatory)
	after 1

	# busy 1 never detected in tcl (too slow)				 
	# set busy 0	
	##wait till busy (bit 0) is 1
	# while {$busy == 0} {				
		# set readout [rd_channel $phy $channel 0x619B0 $verbose]
		# set busy [expr $readout & 0x00000001]
		# puts "busy $busy"
	# }

	set test_done 0	
	# wait till test_done (bit 1) is 1
	while {$test_done == 0} {				
		set readout [rd_channel $phy $channel 0x619B0 $verbose]
		set test_done [expr $readout & 0x00000002]
		#puts "test_done $test_done"		
	}
	
	#readout bitprog result 0x619AC
	
	set bitprog_result [rd_channel $phy $channel 0x619AC $verbose]

return $bitprog_result

}
puts {get_snr_fht {phy channel}}
puts {example useage measure snr on fht :  get_snr_fht ftile_phy_15 0}
puts ""

proc get_ehm_fht {phy channel bin_threshold test_length} {

	#for EHM – write this to bitprog command register: self.opcode_dict['BP_EHM_TEST'] | (lane & 0x3 ) << 6 | (bin_threshold & 0xf) << 12 | (test_length & 0xF) << 28
	#'BP_EHM_TEST' opcode is 0x2.   bin_threshold =2 , test_length=10

	set verbose 0
	
	set bitprog_command [expr 0x2 + [expr $channel<<6] + [expr [expr $bin_threshold	& 0xF] << 12] + [expr [expr $test_length	& 0xF] << 28]] 

	rmw_channel $phy $channel 0x619A8 0xFFFFFFFF $bitprog_command $verbose	
	#wait 1 ms (mandatory)
	after 1

		
	set busy 0	
	# wait till busy (bit 0) is 1
	while {$busy == 0} {				
		set readout [rd_channel $phy $channel 0x619B0 $verbose]
		set busy [expr $readout & 0x00000001]
	}

	set test_done 0	
	# wait till test_done (bit 1) is 1
	while {$test_done == 0} {				
		set readout [rd_channel $phy $channel 0x619B0 $verbose]
		set test_done [expr $readout & 0x00000002]
	}
	
	#readout bitprog result 0x619AC
	
	set bitprog_result [rd_channel $phy $channel 0x619AC $verbose]

return $bitprog_result
}
puts {get_ehm_fht {phy channel bin_threshold test_length}   }
puts {example useage measure ehm on fht :  get_ehm_fht ftile_phy_15 0 2 10}
puts ""

###############################################################################
# Displays the PHY's found in the design
###############################################################################

#puts {}
#puts {These are the Native PHY's identified in the design : }
#puts {You can use the index of the phy to identify a certain phy }
#set phy [show_phys]

map_all_ftile_slaves 1
map_all_ftile_pdp_slaves 1


###############################################################################
# Some debug functions (uncomment and copy paste if you need to use them)
###############################################################################

# for {set channel 0} {$channel < 8} {incr channel} {
# rd_channel ftile_phy_15 $channel 0xFFFFC 1
# }

##set maintap incremental on each lane starting from 20

# for {set channel 0} {$channel < 8} {incr channel} {
# rmw_channel_ftile ftile_phy_15 $channel 0x47830 0x0000FC00 [expr {20+$channel} << 10] 1
# }

##readback maintap

# for {set channel 0} {$channel < 8} {incr channel} {
# set readout [expr [rd_channel_ftile ftile_phy_15 $channel 0x47830 0] >> 10]
# puts $readout
# }



puts ""




