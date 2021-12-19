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
set_part {xa7a12tcsg325-1Q}

# The  command to associate clock period to the solution1
create_clock -period 6 -name clk
set_clock_uncertainty 0.1

# The  comamnd to run the base C simulaiton
csim_design -clean

# Build the lists of solution's name and target delay
set solutions {ex_sol1 ex_sol2 ex_sol3 ex_sol4}
set periods {{6} {8} {10} {12}}

# The comamnd to run the loop for the lists
foreach solution $solutions period $periods {

  # The command to create the solution named from the list
  open_solution -reset $solution

  # The command to associate clock period to the solution from the list
  create_clock -period $period -name clk
  set_clock_uncertainty 0.1

  # The  command to associate the device to the solution1
  set_part {xa7a12tcsg325-1Q}

  # Insert command to run C simulaiton
  csim_design -clean

  # The comamnd to Synthesize the design
  csynth_design

  # The comamnd to perform C/RTL Cosimmulation
  cosim_design -trace_level all -tool xsim

}
