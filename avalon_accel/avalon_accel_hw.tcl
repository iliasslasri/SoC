# TCL File Generated by Component Editor 20.1
# Tue Nov 02 10:53:17 CET 2021
# DO NOT MODIFY


# 
# avalon_accel "Avalon DMA accelerator" v0.0
#  2021.11.02.10:53:17
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module avalon_accel
# 
set_module_property DESCRIPTION ""
set_module_property NAME avalon_accel
set_module_property VERSION 0.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME "Avalon DMA accelerator"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL avalon_accel
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file avalon_accel.sv SYSTEM_VERILOG PATH avalon_accel.sv TOP_LEVEL_FILE


# 
# parameters
# 


# 
# display items
# 


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock clk clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset_n reset_n Input 1


# 
# connection point avalon_m
# 
add_interface avalon_m avalon start
set_interface_property avalon_m addressUnits SYMBOLS
set_interface_property avalon_m associatedClock clock
set_interface_property avalon_m associatedReset reset
set_interface_property avalon_m bitsPerSymbol 8
set_interface_property avalon_m burstOnBurstBoundariesOnly false
set_interface_property avalon_m burstcountUnits WORDS
set_interface_property avalon_m doStreamReads false
set_interface_property avalon_m doStreamWrites false
set_interface_property avalon_m holdTime 0
set_interface_property avalon_m linewrapBursts false
set_interface_property avalon_m maximumPendingReadTransactions 0
set_interface_property avalon_m maximumPendingWriteTransactions 0
set_interface_property avalon_m readLatency 0
set_interface_property avalon_m readWaitTime 1
set_interface_property avalon_m setupTime 0
set_interface_property avalon_m timingUnits Cycles
set_interface_property avalon_m writeWaitTime 0
set_interface_property avalon_m ENABLED true
set_interface_property avalon_m EXPORT_OF ""
set_interface_property avalon_m PORT_NAME_MAP ""
set_interface_property avalon_m CMSIS_SVD_VARIABLES ""
set_interface_property avalon_m SVD_ADDRESS_GROUP ""

add_interface_port avalon_m avm_write write Output 1
add_interface_port avalon_m avm_read read Output 1
add_interface_port avalon_m avm_waitrequest waitrequest Input 1
add_interface_port avalon_m avm_writedata writedata Output 32
add_interface_port avalon_m avm_readdata readdata Input 32
add_interface_port avalon_m avm_address address Output 32


# 
# connection point avalon_s
# 
add_interface avalon_s avalon end
set_interface_property avalon_s addressUnits SYMBOLS
set_interface_property avalon_s associatedClock clock
set_interface_property avalon_s associatedReset reset
set_interface_property avalon_s bitsPerSymbol 8
set_interface_property avalon_s burstOnBurstBoundariesOnly false
set_interface_property avalon_s burstcountUnits WORDS
set_interface_property avalon_s explicitAddressSpan 0
set_interface_property avalon_s holdTime 0
set_interface_property avalon_s linewrapBursts false
set_interface_property avalon_s maximumPendingReadTransactions 0
set_interface_property avalon_s maximumPendingWriteTransactions 0
set_interface_property avalon_s readLatency 0
set_interface_property avalon_s readWaitTime 1
set_interface_property avalon_s setupTime 0
set_interface_property avalon_s timingUnits Cycles
set_interface_property avalon_s writeWaitTime 0
set_interface_property avalon_s ENABLED true
set_interface_property avalon_s EXPORT_OF ""
set_interface_property avalon_s PORT_NAME_MAP ""
set_interface_property avalon_s CMSIS_SVD_VARIABLES ""
set_interface_property avalon_s SVD_ADDRESS_GROUP ""

add_interface_port avalon_s avs_write write Input 1
add_interface_port avalon_s avs_writedata writedata Input 32
add_interface_port avalon_s avs_readdata readdata Output 32
add_interface_port avalon_s avs_address address Input 5
set_interface_assignment avalon_s embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_s embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avalon_s embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_s embeddedsw.configuration.isPrintableDevice 0


# 
# connection point interrupt_sender
# 
add_interface interrupt_sender interrupt end
set_interface_property interrupt_sender associatedAddressablePoint avalon_s
set_interface_property interrupt_sender associatedClock clock
set_interface_property interrupt_sender associatedReset reset
set_interface_property interrupt_sender bridgedReceiverOffset ""
set_interface_property interrupt_sender bridgesToReceiver ""
set_interface_property interrupt_sender ENABLED true
set_interface_property interrupt_sender EXPORT_OF ""
set_interface_property interrupt_sender PORT_NAME_MAP ""
set_interface_property interrupt_sender CMSIS_SVD_VARIABLES ""
set_interface_property interrupt_sender SVD_ADDRESS_GROUP ""

add_interface_port interrupt_sender irq irq Output 1

