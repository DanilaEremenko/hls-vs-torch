# gcc hls-source/conv.* hls-source/conv_test_local.c  -o res.exe
# export PATH="$PATH:/tools/Xilinx/Vivado/2020.1/bin"

# The command to create new project
open_project -reset conv_hls

# The  command to specify the top-level function
set_top conv

# The  command to add design file
add_files ./hls-source/conv.c
add_files ./hls-source/conv.h

# The  command to add testbench file
add_files -tb ./hls-source/conv_test.c

# The  command to create the base solution named base
open_solution -reset ex_sol0

# The  command to associate the device to the solution1
set_part {xa7a100tfgg484-2i}

# The  command to associate clock period to the solution1
create_clock -period 6 -name clk
set_clock_uncertainty 0.1

# The  comamnd to run the base C simulaiton
csim_design -clean

# Build the lists of solution's name and target delay
set solutions {sol1 sol2 sol3 sol4}
set periods {{6} {8} {10} {12}}

# The comamnd to run the loop for the lists
foreach solution $solutions period $periods {

  # The command to create the solution named from the list
  open_solution -reset $solution

  # The command to associate clock period to the solution from the list
  create_clock -period $period -name clk
  set_clock_uncertainty 0.1

  # The  command to associate the device to the solution1
  set_part {xa7a100tfgg484-2i}

  # Insert command to run C simulaiton
  csim_design -clean

  # The comamnd to Synthesize the design
  csynth_design

  # The comamnd to perform C/RTL Cosimmulation
  cosim_design -trace_level all -tool xsim

}

#######################################################################
#----------------------- pipeline optimization x1 ---------------------
#######################################################################
# The command to create the solution named from the list
open_solution -reset sol21

# The command to associate clock period to the solution from the list
create_clock -period 8 -name clk
set_clock_uncertainty 0.1

# The  command to associate the device to the solution1
set_part {xa7a100tfgg484-2i}

set_directive_pipeline "conv/LOOP_LOCAL_WIDTH"

# The comamnd to Synthesize the design
csynth_design

# The comamnd to perform C/RTL Cosimmulation
# cosim_design -trace_level all -tool xsim

#######################################################################
#----------------------- pipeline optimization x2 ---------------------
#######################################################################
# The command to create the solution named from the list
open_solution -reset sol22

# The command to associate clock period to the solution from the list
create_clock -period 8 -name clk
set_clock_uncertainty 0.1

# The  command to associate the device to the solution1
set_part {xa7a100tfgg484-2i}

set_directive_pipeline "conv/LOOP_LOCAL_HEIGHT"

# The comamnd to Synthesize the design
csynth_design

# The comamnd to perform C/RTL Cosimmulation
# cosim_design -trace_level all -tool xsim

#######################################################################
#----------------------- pipeline optimization x3 ---------------------
#######################################################################
# The command to create the solution named from the list
open_solution -reset sol23

# The command to associate clock period to the solution from the list
create_clock -period 8 -name clk
set_clock_uncertainty 0.1

# The  command to associate the device to the solution1
set_part {xa7a100tfgg484-2i}

set_directive_pipeline "conv/LOOP_GLOBAL_WIDTH"

# The comamnd to Synthesize the design
csynth_design

# The comamnd to perform C/RTL Cosimmulation
# cosim_design -trace_level all -tool xsim

#######################################################################
#----------------------- pipeline optimization x4 ---------------------
#######################################################################
# The command to create the solution named from the list
open_solution -reset sol24

# The command to associate clock period to the solution from the list
create_clock -period 8 -name clk
set_clock_uncertainty 0.1

# The  command to associate the device to the solution1
set_part {xa7a100tfgg484-2i}

set_directive_pipeline "conv/LOOP_GLOBAL_HEIGHT"

# The comamnd to Synthesize the design
csynth_design

# The comamnd to perform C/RTL Cosimmulation
# cosim_design -trace_level all -tool xsim