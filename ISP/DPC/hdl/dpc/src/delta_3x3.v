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



module  delta_3x3  #(
parameter DATA_WIDTH 		= 8	
)(
input 							I_clk 			, 
input 	[3*DATA_WIDTH-1:0]		I_line3_1		,
input 	[3*DATA_WIDTH-1:0]		I_line3_2		, 
input 	[3*DATA_WIDTH-1:0]		I_line3_3 		,
input 							I_line_vaild 	,
output 	[3*DATA_WIDTH+2:0]		O_line3_1		, 
output 	[3*DATA_WIDTH+2:0]		O_line3_2		, 
output 	[3*DATA_WIDTH+2:0]		O_line3_3 		, 
output 							O_line_vaild 	
);
// ------------------------------------------------------------------------
reg	 	[DATA_WIDTH-1:0] 	reg1_1, reg1_2,reg1_3 ;
reg	 	[DATA_WIDTH-1:0] 	reg2_1, reg2_2,reg2_3 ;
reg	 	[DATA_WIDTH-1:0] 	reg3_1, reg3_2,reg3_3 ;
reg	 	[DATA_WIDTH-1:0] 	reg2_2_1, reg2_2_2, reg2_2_3 ;
reg  						data_vaild ;
always @(posedge I_clk)		data_vaild	<= I_line_vaild ;
always @(posedge I_clk) begin 
 	{reg1_1, reg1_2, reg1_3} 	= {I_line3_1} ; 
 	{reg2_1, reg2_2, reg2_3} 	= {I_line3_2} ; 
 	{reg3_1, reg3_2, reg3_3} 	= {I_line3_3} ;  
	end 
always @(posedge I_clk)  
 	{reg2_2_1, reg2_2_2, reg2_2_3} 	= {3{I_line3_2[2*DATA_WIDTH-1:DATA_WIDTH]}} ;   
// ------------------------------------------------------------------------ -------------------
wire 	[DATA_WIDTH:0]			O_dat1,O_dat2,O_dat3,O_dat4,O_dat6,O_dat7,O_dat8,O_dat9;

subtr_signed #(
		.SUB_CALCU_TYPE				("DSP"			), // "DSP "
		.INPUT_DATA_WIDTH1			(DATA_WIDTH+1	),
		.INPUT_DATA_WIDTH2			(DATA_WIDTH+1	)
) subtr_lty3_8_1(
		.I_clk 						(I_clk			),
		.I_dat_en 					(data_vaild		),
		.I_dat1						({1'd0,reg2_2}	),
		.I_dat2						({1'd0,reg1_1}	),
		.O_dat						(O_dat1			),
		.O_dat_vaild 				()
);

subtr_signed #(
		.SUB_CALCU_TYPE				("LUT"			),
		.INPUT_DATA_WIDTH1			(DATA_WIDTH+1	),
		.INPUT_DATA_WIDTH2			(DATA_WIDTH+1	)
) subtr_lty3_8_2(	
		.I_clk 						(I_clk			),
		.I_dat_en 					(data_vaild		),
		.I_dat1						({1'd0,reg2_2}	),
		.I_dat2						({1'd0,reg1_2}	),
		.O_dat						(O_dat2			),
		.O_dat_vaild 				()
);

subtr_signed #(
		.SUB_CALCU_TYPE				("LUT"			),
		.INPUT_DATA_WIDTH1			(DATA_WIDTH+1	),
		.INPUT_DATA_WIDTH2			(DATA_WIDTH+1	)
) subtr_lty3_8_3(	
		.I_clk 						(I_clk			),
		.I_dat_en 					(data_vaild		),
		.I_dat1						({1'd0,reg2_2_1}),
		.I_dat2						({1'd0,reg1_3}	),
		.O_dat						(O_dat3			),
		.O_dat_vaild 				()
);

subtr_signed #(
		.SUB_CALCU_TYPE				("LUT"			),
		.INPUT_DATA_WIDTH1			(DATA_WIDTH+1	),
		.INPUT_DATA_WIDTH2			(DATA_WIDTH+1	)
) subtr_lty3_8_4(	
		.I_clk 						(I_clk			),
		.I_dat_en 					(data_vaild		),
		.I_dat1						({1'd0,reg2_2_1}),
		.I_dat2						({1'd0,reg2_1}	),
		.O_dat						(O_dat4			),
		.O_dat_vaild 				()
);

subtr_signed #(
		.SUB_CALCU_TYPE				("LUT"			),
		.INPUT_DATA_WIDTH1			(DATA_WIDTH+1	),
		.INPUT_DATA_WIDTH2			(DATA_WIDTH+1	)
) subtr_lty3_8_5(	
		.I_clk 						(I_clk			),
		.I_dat_en 					(data_vaild		),
		.I_dat1						({1'd0,reg2_2_2}),
		.I_dat2						({1'd0,reg2_3}	),
		.O_dat						(O_dat6			),
		.O_dat_vaild 				()
);

subtr_signed #(
		.SUB_CALCU_TYPE				("LUT"			),
		.INPUT_DATA_WIDTH1			(DATA_WIDTH+1	),
		.INPUT_DATA_WIDTH2			(DATA_WIDTH+1	)
) subtr_lty3_8_6(	
		.I_clk 						(I_clk			),
		.I_dat_en 					(data_vaild		),
		.I_dat1						({1'd0,reg2_2_2}),
		.I_dat2						({1'd0,reg3_1}	),
		.O_dat						(O_dat7			),
		.O_dat_vaild 				()
);

subtr_signed #(
		.SUB_CALCU_TYPE				("LUT"			),
		.INPUT_DATA_WIDTH1			(DATA_WIDTH+1	),
		.INPUT_DATA_WIDTH2			(DATA_WIDTH+1	)
) subtr_lty3_8_7(	
		.I_clk 						(I_clk			),
		.I_dat_en 					(data_vaild		),
		.I_dat1						({1'd0,reg2_2_3}),
		.I_dat2						({1'd0,reg3_2}	),
		.O_dat						(O_dat8			),
		.O_dat_vaild 				()
);

subtr_signed #(
		.SUB_CALCU_TYPE				("LUT"			),
		.INPUT_DATA_WIDTH1			(DATA_WIDTH+1	),
		.INPUT_DATA_WIDTH2			(DATA_WIDTH+1	)
) subtr_lty3_8_8(	
		.I_clk 						(I_clk			),
		.I_dat_en 					(data_vaild		),
		.I_dat1						({1'd0,reg2_2_3}),
		.I_dat2						({1'd0,reg3_3}	),
		.O_dat						(O_dat9			),
		.O_dat_vaild 				()
);
//-----------------------------------------------------------------------------------------
reg 	[3:0] 				vaild_r ; 
wire 	[DATA_WIDTH-1:0]	reg2_2r ;
always @(posedge I_clk) vaild_r <= {vaild_r[2:0],I_line_vaild};

latency_module #(
		.DATA_WIDTH 			(DATA_WIDTH			), 	//输入数据位宽	
		.LATENCY_VECTOR  		(3					)   
)latency_delta(
		.I_clk   				(I_clk				),
		.I_dat 					(reg2_2				),
		.O_dat 					(reg2_2r			)
);
// ---------------------------------------------------------------------------------------
assign 	O_line3_1   = {O_dat1,	O_dat2,				O_dat3};
assign 	O_line3_2   = {O_dat4,	{{1'd0},reg2_2r},	O_dat6};
assign 	O_line3_3   = {O_dat7,	O_dat8,				O_dat9};
assign 	O_line_vaild = vaild_r[3] ;


endmodule 
