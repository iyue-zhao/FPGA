
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


(*use_dsp="yes"*) module   subtr_s_dsp #(
parameter 	INPUT_DATA_WIDTH1 		= 	8,	
parameter 	INPUT_DATA_WIDTH2 		= 	8 	
)(
input 								I_clk 				,
input 								I_dat_en 			,
input 	[INPUT_DATA_WIDTH1-1:0]		I_dat1				,
input 	[INPUT_DATA_WIDTH2-1:0]		I_dat2				,
output	[INPUT_DATA_WIDTH1-1:0]		O_dat				, 
output 								O_dat_vaild
);
// -----------------------------------------------------------------------------------------------------------------------------------
reg 	[2:0] 		en_r ;
always @(posedge I_clk) 	en_r <= {en_r[1:0], I_dat_en};

reg	 signed [INPUT_DATA_WIDTH1-1:0] 	reg1  , reg3, reg4;
reg	 signed [INPUT_DATA_WIDTH2-1:0] 	reg2 ;
always @(posedge I_clk) 	
	if(I_dat_en)	{reg1, reg2} <= {I_dat1,I_dat2} ; 
always @(posedge I_clk) 	reg3	<= $signed(reg1) - $signed(reg2) 	;
always @(posedge I_clk) 	reg4	<= reg3 	;

assign 	O_dat_vaild  = en_r[2] ;
assign 	O_dat = reg4;
// ----------------------------------------------------------------------------

endmodule 