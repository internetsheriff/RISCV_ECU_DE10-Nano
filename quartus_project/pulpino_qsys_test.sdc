### Clocks ###

create_clock -period 20.00 -name system_clock [get_ports CLOCK_50]
derive_pll_clocks
derive_clock_uncertainty


### IO ###

## Inputs
# Assuming KEY* and SW* are synchronous inputs to system_clock
# These values are generic and should be tuned based on external component delays
set_input_delay -clock system_clock -max 5.00 [get_ports KEY*]
set_input_delay -clock system_clock -min 1.00 [get_ports KEY*]
set_input_delay -clock system_clock -max 5.00 [get_ports SW*]
set_input_delay -clock system_clock -min 1.00 [get_ports SW*]

## Outputs
# Assuming LEDR* are synchronous outputs from system_clock
# These values are generic and should be tuned based on external component delays
set_output_delay -clock system_clock -max 5.00 [get_ports LEDR*]
set_output_delay -clock system_clock -min 1.00 [get_ports LEDR*]
# HEX* are not used by the top-level entity, so set as false path
set_false_path -to [get_ports HEX*]


### JTAG Signal Constraints ###

# JTAG clock and related I/O constraints are typically handled by the tool
# and should not be manually constrained unless specific requirements exist.
# Commenting out the following lines to avoid conflicts and allow the tool
# to manage JTAG timing.
# create_clock -name tck -period     100.00 [get_ports altera_reserved_tck]
# set_clock_groups -exclusive -group [get_clocks altera_reserved_tck]
# set_input_delay -clock altera_reserved_tck 20 [get_ports altera_reserved_tdi]
# set_input_delay -clock altera_reserved_tck 20 [get_ports altera_reserved_tms]
# set_output_delay -clock altera_reserved_tck 20 [get_ports altera_reserved_tdo]
