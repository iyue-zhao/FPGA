
`timescale  1ns/1ps 
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


module   isp_tb  ; 
reg 		clk  ; 
reg 		video_rst  ;

wire [2:0] 	video_syn  ; 
wire [7:0]  video_raw  ;
// ---------------------------------------------------------------------------
wire  [7:0]  dpc_thrd_value ;
wire  [2:0]  bayer_format   ;

wire 	[7:0]	blc_r_value		;
wire 	[7:0]	blc_gr_value	;
wire 	[7:0]	blc_gb_value	;
wire 	[7:0]	blc_b_value		;

assign 		dpc_thrd_value = 8'd80 ;
assign 		bayer_format   = 3'd0  ; //000:BGGR  001:GBGR  010:RGGB   011:GRGB 
		
assign 		blc_r_value	 = 8'd16 ;
assign 		blc_gr_value = 8'd17 ;
assign 		blc_gb_value = 8'd18 ;
assign 		blc_b_value	 = 8'd15 ;
// -------------------------------------------------------------------------
wire 	[7:0] 		video_r,  video_g, video_b ;
file_to_video     file_to_video(
		.I_video_clk 					(clk				),
		.I_reset_n 						(!video_rst			),
		.O_video_syn					(video_syn 			),
		.O_video_r 						(video_r			),
		.O_video_g 						(video_g			),
		.O_video_b 						(video_b			)
);
// -------------------------------------------------------------------------
wire 	[23:0] 		isp_dat ;
wire 	[2:0] 		isp_syn ;
isp #(
		.VIDEO_RAWDATA_WIDTH 			(8						) 
)isp (                          
		.I_video_clk 					(clk					), 
		.I_video_rst 					(video_rst 				), 
		.I_video_syn 					(video_syn				), 
		.I_video_raw 					(video_r				),
// -----------------------------------------------------------------------------------------------		
		.I_bayer_format 				(bayer_format[2:0]		), // 0: B/R G B/R  ,  1: G  B/R  G 
		.I_dpc_thrd_value 				(dpc_thrd_value			),
		// --------------------------------------------------------
		.I_blc_r_value					(blc_r_value			),
		.I_blc_gr_value					(blc_gr_value			),
		.I_blc_gb_value					(blc_gb_value			),
		.I_blc_b_value					(blc_b_value			),		
		// --------------------------------------------------------
// ------------------------------------------------------------------------------------------------
		.O_video_syn 					(isp_syn 				), 	
		.O_video_dat 					(isp_dat				)
);
// -------------------------------------------------------------------------------------------
video_to_file #(
		.VIDEO_DATA_WIDTH    			(8					) ,
		.FRAME_PRINT_NUMBER  			(2					) ,   
		.FILE_NAME_DEFINE    			( "video_r_dat.txt"	)
)video_to_file_r (	
		.I_video_clk 					(clk				),
		.I_video_rst_n 					(!video_rst			),
		.I_video_v						(isp_syn[2]			),
		.I_video_d 						(isp_syn[0]			),
		.I_video_dat 					(isp_dat[7:0]		)	
);	
/*
video_to_file #(	
		.VIDEO_DATA_WIDTH    			(8					) ,
		.FRAME_PRINT_NUMBER  			(3					) ,  
		.FILE_NAME_DEFINE    			( "video_g_dat.txt"	)
)video_to_file_g (	
		.I_video_clk 					(clk			),
		.I_video_rst_n 					(I_video_rst_n	),
		.I_video_v						(isp_syn[2]		),
		.I_video_d 						(isp_syn[0]		),
		.I_video_dat 					(zoom_data[15:8]	)	
);	
video_to_file #(	
		.VIDEO_DATA_WIDTH   			( 8 				),
		.FRAME_PRINT_NUMBER  			( 3 				),  
		.FILE_NAME_DEFINE    			( "video_b_dat.txt"	)
)video_to_file_b (	
		.I_video_clk 					(clk			),
		.I_video_rst_n 					(I_video_rst_n	),
		.I_video_v						(isp_syn[2]	),
		.I_video_d 						(isp_syn[0]	),
		.I_video_dat 					(zoom_data[7:0]		)	
);
*/
// ----------------------------------------------------------------------------------------
// always @(posedge clk )	rand_dat <= {$random}%255 ;
// -----------------------
always #10 clk = ~clk ;


initial begin 
	clk = 0 ;   video_rst = 1 ; 
	#100 ;
	video_rst = 0 ; 
	#80 ; 
	wait (isp_syn[0]);
	wait (!isp_syn[0]);
	wait (isp_syn[0]);
	wait (isp_syn[2]);
	
	wait (!isp_syn[2]);
	wait (isp_syn[2]);
	
	wait (!isp_syn[2]);
//	wait (isp_syn[2]);
	
	
	$stop ;
	end 
//-----------------------------------------------------------------

endmodule 










