

# #####################################################################################################
quit -sim 
.main  clear

vlib work 
vmap work work 


# ###################################################################################################
vlog   ../isp.v 

vlog   ../dpc/src/*.v 


vlog   ../comm/subtr_signed/*.v 
vlog   ../comm/latency_module.v 

vlog   ../line_buffer_fifo/line_buffer_fifo.v 
vlog   ../asyn_fifo/*.v 

vlog   ../virtual_rom/vir_rom.v

# ########################################
vlog   ../video_gen/file_to_video.v

vlog   ../video_gen/vesa_timing_gen.v
vlog   ../video_gen/video_to_file.v





# ##################################
vlog   ./isp_tb.v
# ##################################################################################################
#vsim  -novopt isp_tb 
#vsim  -assertdebug isp_tb  
vsim -voptargs=+acc isp_tb 
# #################################################################################################
add wave ./isp_tb.file_to_video.vesa_timing_gen/*
add wave ./isp_tb.isp.dpc_top/*
add wave ./isp_tb.isp.dpc_top.dpc_delta_5x5/*
add wave ./isp_tb.isp.dpc_top.dpc_delta_5x5.dpc_dat_judge/*





#do wave.do 

# ###############################################################################################
run -all 
# ###############################################################################################
# ################  END OF THE FILE #############################################################
# ###############################################################################################

