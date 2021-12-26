# gcc hls-source/conv.* hls-source/conv_test_local.c -O3 -o res.exe
# export PATH="$PATH:/tools/Xilinx/Vivado/2020.1/bin"
# https://www.xilinx.com/support/documentation/sw_manuals/xilinx2017_4/ug1270-vivado-hls-opt-methodology-guide.pdf
# https://docs.xilinx.com/r/en-US/ug1399-vitis-hls/

# The command to create new project
open_project -reset conv_hls

# The  command to specify the top-level function
set_top conv

# The  command to add design file
add_files ./hls-source/conv.c
add_files ./hls-source/conv.h

# The  command to add testbench file
add_files -tb ./hls-source/conv_test.c


# The command to create the solution named from the list
open_solution -reset sol0

# The  command to associate the device to the solution1
set_part {xa7a100tfgg484-2i}

# The command to associate clock period to the solution from the list
create_clock -period 8 -name clk
set_clock_uncertainty 0.1

#######################################################################
#--------------------------- clocks brute-forcing ---------------------
#######################################################################
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
  # csim_design -clean

  # The comamnd to Synthesize the design
  csynth_design

  # The comamnd to perform C/RTL Cosimmulation
  # cosim_design -trace_level all -tool xsim

}

#######################################################################
#---------------------------- flatten ---------------------------------
#######################################################################
open_solution -reset sol2_fl

create_clock -period 8 -name clk
set_clock_uncertainty 0.1

set_part {xa7a100tfgg484-2i}

set_directive_loop_flatten "conv/L4"

# Insert command to run C simulaiton
# csim_design -clean

# The comamnd to Synthesize the design
csynth_design

# The comamnd to perform C/RTL Cosimmulation
# cosim_design -trace_level all -tool xsim


#######################################################################
#------------------------------ pipeline  -----------------------------
#######################################################################
set pl_solutions {sol2_ppl4 sol2_ppl3 sol2_ppl2}
set pls {conv/L4 conv/L3 conv/L2}

# The comamnd to run the loop for the lists
foreach solution $pl_solutions pl $pls {

  open_solution -reset $solution

  create_clock -period 8 -name clk
  set_clock_uncertainty 0.1

  set_part {xa7a100tfgg484-2i}

  set_directive_pipeline "$pl"
  
  # Insert command to run C simulaiton
  # csim_design -clean

  # The comamnd to Synthesize the design
  csynth_design

  # The comamnd to perform C/RTL Cosimmulation
  # cosim_design -trace_level all -tool xsim

}


#######################################################################
#---------------------------- unroll  ---------------------------------
#######################################################################
set pl_solutions {sol2_unr4 sol2_unr3 sol2_unr2}
set pls {conv/L4 conv/L3 conv/L2}

# The comamnd to run the loop for the lists
foreach solution $pl_solutions pl $pls {

  open_solution -reset $solution

  create_clock -period 8 -name clk
  set_clock_uncertainty 0.1

  set_part {xa7a100tfgg484-2i}

  set_directive_unroll -factor 4 "$pl"

  # Insert command to run C simulaiton
  # csim_design -clean

  # The comamnd to Synthesize the design
  csynth_design

  # The comamnd to perform C/RTL Cosimmulation
  # cosim_design -trace_level all -tool xsim

}


#######################################################################
#------------------------------- unroll + part  -----------------------
#######################################################################
set pl_solutions {sol2_unr4_part sol2_unr3_part sol2_unr2_part}
set pls {conv/L4 conv/L3 conv/L2}

# The comamnd to run the loop for the lists
foreach solution $pl_solutions pl $pls {

  open_solution -reset $solution

  create_clock -period 8 -name clk
  set_clock_uncertainty 0.1

  set_part {xa7a100tfgg484-2i}

  set_directive_unroll -factor 4 "$pl"
  set_directive_array_partition -type block -factor 4 "conv" input_img
  set_directive_array_partition -type complete "conv" conv_matrix
  set_directive_array_partition -type block -factor 4 "conv" output_img


  # Insert command to run C simulaiton
  # csim_design -clean

  # The comamnd to Synthesize the design
  csynth_design

  # The comamnd to perform C/RTL Cosimmulation
  # cosim_design -trace_level all -tool xsim

}