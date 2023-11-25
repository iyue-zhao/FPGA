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



module   dpc_delta_5x5 #(
parameter VIDEO_DATA_WIDTH 			= 8	
)
(
input 								I_video_clk			,
input 	[7:0]						I_dpc_thrd_value	,
input 	[0:0]						I_bayer_format		, // 0: B/R G B/R  ,  1: G  B/R  G  
input 	[2:0]						I_video_syn 		,
input 	[VIDEO_DATA_WIDTH-1:0]		I_video_dat1		,
input 	[VIDEO_DATA_WIDTH-1:0]		I_video_dat2		,
input 	[VIDEO_DATA_WIDTH-1:0]		I_video_dat3		,
input 	[VIDEO_DATA_WIDTH-1:0]		I_video_dat4		,
input 	[VIDEO_DATA_WIDTH-1:0]		I_video_dat5		,
output 	[2:0]						O_video_syn 		,
output 	[VIDEO_DATA_WIDTH-1:0]		O_video_dat 		
);
// ---------------------------------------------------------------------------------------------------------
reg 	[VIDEO_DATA_WIDTH-1:0]		r1_1, r1_2, r1_3, r1_4, r1_5; 
reg 	[VIDEO_DATA_WIDTH-1:0]		r2_1, r2_2, r2_3, r2_4, r2_5; 
reg 	[VIDEO_DATA_WIDTH-1:0]		r3_1, r3_2, r3_3, r3_4, r3_5; 
reg 	[VIDEO_DATA_WIDTH-1:0]		r4_1, r4_2, r4_3, r4_4, r4_5; 
reg 	[VIDEO_DATA_WIDTH-1:0]		r5_1, r5_2, r5_3, r5_4, r5_5; 
reg 	[12:0]  		syn_v,syn_h,syn_d;
wire 					synd_pos,synv_neg;
always @(posedge I_video_clk)	{r1_1,r1_2,r1_3,r1_4,r1_5} <= {r1_2,r1_3,r1_4,r1_5,I_video_dat1};
always @(posedge I_video_clk)	{r2_1,r2_2,r2_3,r2_4,r2_5} <= {r2_2,r2_3,r2_4,r2_5,I_video_dat2};
always @(posedge I_video_clk)	{r3_1,r3_2,r3_3,r3_4,r3_5} <= {r3_2,r3_3,r3_4,r3_5,I_video_dat3};
always @(posedge I_video_clk)	{r4_1,r4_2,r4_3,r4_4,r4_5} <= {r4_2,r4_3,r4_4,r4_5,I_video_dat4};
always @(posedge I_video_clk)	{r5_1,r5_2,r5_3,r5_4,r5_5} <= {r5_2,r5_3,r5_4,r5_5,I_video_dat5};
always @(posedge I_video_clk)	syn_v <= {syn_v[11:0],I_video_syn[2]};
always @(posedge I_video_clk)	syn_h <= {syn_h[11:0],I_video_syn[1]};
always @(posedge I_video_clk)	syn_d <= {syn_d[11:0],I_video_syn[0]};
assign 	synd_pos = (syn_d[4:3]==2'b01)? 1'd1:1'd0 ;
assign 	synv_neg = (syn_v[4:3]==2'b10)? 1'd1:1'd0 ;
// ---------------------------------------------------------------------------------------------------------
reg 								pixel_odd, line_odd ;
reg 	[VIDEO_DATA_WIDTH-1:0]		r1_1r0,r1_3r0,r1_5r0;
reg 	[VIDEO_DATA_WIDTH-1:0]		r3_1r0,r3_3r0,r3_5r0;
reg 	[VIDEO_DATA_WIDTH-1:0]		r5_1r0,r5_3r0,r5_5r0;
always @(posedge I_video_clk)
	if(synd_pos)				pixel_odd  	<= ~I_bayer_format ;
	else if(syn_d[4])			pixel_odd  	<= ~pixel_odd ;
always @(posedge I_video_clk)
	if(synv_neg)				line_odd  	<= 1'd0 ;
	else if(synd_pos)			line_odd  	<= ~line_odd ;
always @(posedge I_video_clk)
	if(pixel_odd == line_odd)	begin  // B / R 
		{r1_1r0,r1_3r0,r1_5r0}<={r1_1,r1_3,r1_5};
		{r3_1r0,r3_3r0,r3_5r0}<={r3_1,r3_3,r3_5};
        {r5_1r0,r5_3r0,r5_5r0}<={r5_1,r5_3,r5_5};
		end 
	else begin    // G 
		{r1_3r0}				<={r1_3};
		{r1_1r0,r1_5r0}			<={r2_2,r2_4};	
		{r3_1r0,r3_3r0,r3_5r0}	<={r3_1,r3_3,r3_5};	
		{r5_1r0,r5_5r0}			<={r4_2,r4_4};	
		{r5_3r0}				<={r5_3};		
		end 
// -----------------------------------------------------------------------------------------------------------
wire 	[VIDEO_DATA_WIDTH:0]		dlt1,dlt2,dlt3,dlt4,dlt5,dlt6,dlt7,dlt8,dlt9 ;	
wire	[VIDEO_DATA_WIDTH-1:0]		mid_dat ;
delta_3x3  #(
		.DATA_WIDTH 				(VIDEO_DATA_WIDTH		)
) delta_3x3 (			
		.I_clk 						(I_video_clk 			), 
		.I_line3_1					({r1_1r0,r1_3r0,r1_5r0}	),
		.I_line3_2					({r3_1r0,r3_3r0,r3_5r0}	), 
		.I_line3_3 					({r5_1r0,r5_3r0,r5_5r0}	),
		.I_line_vaild 				(	syn_d[5]			),
		.O_line3_1		 			({dlt1,dlt2,dlt3}		), 
		.O_line3_2		 			({dlt4,dlt5,dlt6}		), 
		.O_line3_3 		 			({dlt7,dlt8,dlt9}		), 
		.O_line_vaild 	 			(				 		)
);

mid_3x3 #(
		.DATA_WIDTH 				(VIDEO_DATA_WIDTH		)			//输入数据位宽
) mid_3x3 (
		.I_clk 						(I_video_clk 			), 
		.I_line3_1					({r1_1r0,r1_3r0,r1_5r0}	),
		.I_line3_2					({r3_1r0,r3_3r0,r3_5r0}	), 
		.I_line3_3 					({r5_1r0,r5_3r0,r5_5r0}	),
		.I_line_vaild 				(	syn_d[5]	 		),
		.O_mid_dat 					(mid_dat	 			), 
		.O_mid_vaild	 	        (						)
);
// -----------------------------------------------------------------------------
dpc_dat_judge #(
		.DATA_WIDTH 				(VIDEO_DATA_WIDTH		)	
)dpc_dat_judge(		
		.clk 						(I_video_clk			),
		.I_dpc_thrd_value			(I_dpc_thrd_value		),
		.I_line3_1					({dlt1,dlt2,dlt3}		),
		.I_line3_2					({dlt4,dlt5,dlt6}		), 
		.I_line3_3 					({dlt7,dlt8,dlt9}		),
		.I_dat_vaild				( syn_d[9]				),
		.I_mid_dat 					( mid_dat				),
		.O_judge_dat				(O_video_dat			),
		.O_judge_vaild				(						)
);
assign 	O_video_syn = {syn_v[12],syn_h[12],syn_d[12]} ;
endmodule 
