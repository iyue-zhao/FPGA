
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



module  latency_module #(
parameter 		DATA_WIDTH 			= 8	, 	
parameter 		LATENCY_VECTOR  	= 3     
)(
input 							I_clk   ,
input 	[DATA_WIDTH-1:0]		I_dat 	,
output 	[DATA_WIDTH-1:0]		O_dat 
);
// **********************************************************************
reg [LATENCY_VECTOR*DATA_WIDTH-1:0] dat_reg ;
always @(posedge I_clk) 	
	dat_reg <= {I_dat,dat_reg[LATENCY_VECTOR*DATA_WIDTH-1:DATA_WIDTH]};
assign 	O_dat = dat_reg[DATA_WIDTH-1:0] ;
endmodule 



/*

latency_module #(
		.DATA_WIDTH 			(VIDEO_DATA_WIDTH	), 	//输入数据位宽	
		.LATENCY_VECTOR  		(3										)   
)latency_pr1(
		.I_clk   				(I_clk									),
		.I_dat 					(mult_dat[24]							),
		.O_dat 					(mult_r1								)
);	



*/

