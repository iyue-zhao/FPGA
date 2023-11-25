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



module   dpc_top #(
parameter VIDEO_DATA_WIDTH 			= 8	
)
(
input 								I_video_clk 	,
input 								I_video_reset	,
input 	[7:0] 						I_dpc_thrd_value,
input 	[0:0] 						I_bayer_format  ,
input 	[2:0]						I_video_syn 	,
input 	[VIDEO_DATA_WIDTH-1:0]		I_video_dat 	,

//output 	[2:0] 						O_line_syn_5_5	,
//output 	[5*VIDEO_DATA_WIDTH-1:0]	O_line_dat_5_5	,
output 	[2:0]						O_video_syn 	,
output 	[VIDEO_DATA_WIDTH-1:0]		O_video_dat 	
);
// --------------------------------------------------------------------------------------
wire 	[2:0] 						line_syn_5_5 ;
wire 	[VIDEO_DATA_WIDTH-1:0]		line_5_1, line_5_2, line_5_3, line_5_4, line_5_5; // 5_5 new
// --------------------------------------------------------------------------------------
line_buffer_fifo #(
		.VIDEO_DATA_WIDTH 		(VIDEO_DATA_WIDTH	),		
		.FIFO_ADDR_WIDTH 		(11					),		
		.LINE_NUMBER_VECTOR 	(5					)     	
)line_buffer_dpc_5x5(
		.I_video_clk 			(I_video_clk		), 
		.I_reset 				(I_video_reset		),
		.I_de_vaild 			(	1'd0			),
		.I_video_syn			(I_video_syn		),
		.I_video_dat 			(I_video_dat		),
		.O_video_line			({line_5_5,line_5_4,line_5_3,line_5_2,line_5_1}), 
		.O_video_syn			(line_syn_5_5		),
		.O_lb_debug 			(					)
);

dpc_delta_5x5 #(
		.VIDEO_DATA_WIDTH 		(VIDEO_DATA_WIDTH	)
) dpc_delta_5x5 (
		.I_video_clk			(I_video_clk		),
		.I_dpc_thrd_value		(I_dpc_thrd_value	),
		.I_bayer_format			(I_bayer_format[0]	),
		.I_video_syn 			(line_syn_5_5		),
		.I_video_dat1			(line_5_1			),
		.I_video_dat2			(line_5_2			),
		.I_video_dat3			(line_5_3			),
		.I_video_dat4			(line_5_4			),
		.I_video_dat5			(line_5_5			),
		.O_video_syn 			(O_video_syn		),
		.O_video_dat 			(O_video_dat		)
);
//assign 	O_line_syn_5_5 = line_syn_5_5 ;
//assign 	O_line_dat_5_5 = {line_5_5,line_5_4,line_5_3,line_5_2,line_5_1};
endmodule 


