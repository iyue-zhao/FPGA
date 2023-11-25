//
// ***********************************************************************
//     ____     ___      |       |
//    /        /   \     |____   |____
//   |        |     |    |    |  |    |
//    \____    \___/     |____|  |____|

//  COPYRIGHT        :  COBB.PENG 
//  URL              :  www..com
//  TEMPLATE VERSION :  V00
//
//
//  FileName         :   
//  ModuleName       :   
//  HardWare Version :   
//  Software Version :   
//  Verilog  Version :  verilog 2001 
//  Target Devices   :   
//  Description      :      
//
//   ____________________________________________________
//  |          |           |   
//  | Version  |  Designer |  Update 
//  |----------|-----------|-----------------------------
//  |  00      |  CobbPeng | File Created. 
//  |----------|-----------|-----------------------------
//  |          |           | 
// ------------------------------------------------------------
//
// 
//


module   video_to_file #(
parameter 		VIDEO_DATA_WIDTH    =  11 ,
parameter 		FRAME_PRINT_NUMBER  =  2  ,   // 0-9
parameter 		FILE_NAME_DEFINE    =  "dat.txt"
)(
input 							I_video_clk 	,
input 							I_video_rst_n 	,
input 							I_video_v		,
input 							I_video_d 		,
input 	[VIDEO_DATA_WIDTH-1:0] 	I_video_dat 		
);
// --------------------------------------------------------------------
reg 	 				syn_v  ;
wire 					syn_v_pos ;
always @(posedge  I_video_clk)syn_v<= I_video_v;
assign 		syn_v_pos = (!syn_v)&I_video_v;
// --------------------------------------------------------------------
integer 	dat_file ;
reg 	[9:0] 	frame_select ;
always @(posedge  I_video_clk)
	if(!I_video_rst_n)		frame_select <= 10'b00_0000_0001;
	else if(syn_v_pos)		frame_select <= frame_select<<1;
always @(posedge  I_video_clk)
	if(frame_select[FRAME_PRINT_NUMBER]&I_video_d)  begin 
		$fdisplay (dat_file,"%h",I_video_dat);
		if((I_video_dat==8'hxx)|(I_video_dat==8'hzz))
			$display ("data error \n");
		end 
// --------------------------------------------------------------------
initial begin 
	wait (frame_select[FRAME_PRINT_NUMBER-1]);
	dat_file = $fopen(FILE_NAME_DEFINE);
	wait (frame_select[FRAME_PRINT_NUMBER+1]);
	$fclose (dat_file);
	end 
	
endmodule 
