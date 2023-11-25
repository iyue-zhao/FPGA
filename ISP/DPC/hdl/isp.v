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



module   isp #(
parameter 			VIDEO_RAWDATA_WIDTH = 8 
)(
input 										I_video_clk 		, 
input 										I_video_rst 		, 
input 	[2:0]								I_video_syn 		, 
input 	[VIDEO_RAWDATA_WIDTH-1:0]			I_video_raw 		,
// *****************************************************************************************
// -----------------------------------------------------------------
input 	[2:0] 								I_bayer_format 		,
input 	[7:0] 								I_dpc_thrd_value 	,
// -----------------------------------------------------------------
input 	[7:0] 								I_blc_r_value		,
input 	[7:0] 								I_blc_gr_value		,
input 	[7:0] 								I_blc_gb_value		,
input 	[7:0] 								I_blc_b_value		,


// -----------------------------------------------------------------
// *******************************************************************************************
output 	[2:0]								O_video_syn , 
output 	[3*VIDEO_RAWDATA_WIDTH-1:0] 		O_video_dat 
);
// ------------------------------------------------------------------------------------------------- ------- 
wire 	[VIDEO_RAWDATA_WIDTH-1:0] 			video_dpc_dat ; 
wire 	[2:0] 								video_dpc_syn ;
wire 	[5*VIDEO_RAWDATA_WIDTH-1:0]			line_dat_5x5  ;
wire 	[2:0] 								line_syn_5x5  ;

wire 	[VIDEO_RAWDATA_WIDTH-1:0] 			video_blc_dat ;
wire 	[2:0] 								video_blc_syn ;
// ---------------------------------------------------------------------------------------------------------
// --  I_dpc_thrd_value     
//  -- I_bayer_format  
//     3'b000   BGGR
//     3'b001   GBGR    
//     3'b010   RGGB 
//     3'b101   GRGB 
// ---------- 5+4+13   + 13
dpc_top #(
		.VIDEO_DATA_WIDTH 					(VIDEO_RAWDATA_WIDTH	)
)dpc_top(		
		.I_video_clk 						(I_video_clk			),
		.I_video_reset						(I_video_rst			),
		.I_dpc_thrd_value					(I_dpc_thrd_value		),
		.I_bayer_format  					(I_bayer_format[0:0]	),
		.I_video_syn 						(I_video_syn			),
		.I_video_dat 						(I_video_raw			),
//		.O_line_syn_5_5						(line_syn_5x5 			),
//		.O_line_dat_5_5						(line_dat_5x5 			),
		.O_video_syn 						(video_dpc_syn			),
		.O_video_dat 						(video_dpc_dat			)
);

/*
//  5 
blc_top #(
		.VIDEO_DATA_WIDTH 					(VIDEO_RAWDATA_WIDTH	)
)	blc_top	(		
		.I_clk  							(I_video_clk			),
		.I_blc_r_value						(I_blc_r_value			),
		.I_blc_gr_value						(I_blc_gr_value			),
		.I_blc_gb_value						(I_blc_gb_value			),
		.I_blc_b_value						(I_blc_b_value			),
		.I_bayer_format 					(I_bayer_format 		),
		.I_video_syn 						(video_dpc_syn			),
		.I_video_dat 						(video_dpc_dat			),
		.O_video_syn 						(video_blc_syn			),
		.O_video_dat 						(video_blc_dat			)
);		
*/







assign 		O_video_dat   =  {3{video_dpc_dat}} ;
assign 		O_video_syn   =  video_dpc_syn ;


/*	
// 5+4 + 19		
bnr_top #(		
		.VIDEO_DATA_WIDTH 					( VIDEO_DATA_WIDTH	)	
) bnr_top(		
		.I_video_clk 						(I_video_clk 		),
		.I_video_reset						(I_video_reset		),
		.I_bayer_format 					(I_bayer_format		),
		.I_video_syn 						(blc_syn 			),
		.I_video_dat 						(blc_dat			),
		.O_video_syn 						(bnr_syn 			),
		.O_video_dat 						(bnr_dat 			)
);
*/
















endmodule 


