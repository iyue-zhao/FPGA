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

module  subtr_signed #(
parameter 	  	SUB_CALCU_TYPE 			= "DSP" , // NULL  
parameter 		INPUT_DATA_WIDTH1 		= 8  , 	
parameter 		INPUT_DATA_WIDTH2 		= 8  	
)
(
input 								I_clk 				,
input 								I_dat_en 			,
input 	[INPUT_DATA_WIDTH1-1:0]		I_dat1				,
input 	[INPUT_DATA_WIDTH2-1:0]		I_dat2				,
output	[INPUT_DATA_WIDTH1-1:0]		O_dat				, 
output 								O_dat_vaild
);
// --------------------------------------------------------------  
generate  
// -----------------------------------------------------------------------------------------------------------------------------------
if (SUB_CALCU_TYPE == "DSP")  begin :sub_us_dsp_module  

subtr_s_dsp #(
		.INPUT_DATA_WIDTH1 		(INPUT_DATA_WIDTH1)  , 	
		.INPUT_DATA_WIDTH2 		(INPUT_DATA_WIDTH2)  	
)subtr_s_dsp (
		.I_clk 					(I_clk				),
		.I_dat_en 				(I_dat_en			),
		.I_dat1					(I_dat1				),
		.I_dat2					(I_dat2				),
		.O_dat					(O_dat				), 
		.O_dat_vaild			( O_dat_vaild       )
);

end 
else  begin  :sub_us_lut_module 
// -------------------------------------------------------------------------------------------------------------------------------------
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

end 
// -----------------------------------------------------------------------------------------------------------------------------------
endgenerate


endmodule 



/*

subtr_signed #(
		.SUB_CALCU_TYPE 		(" DSP "			), 
		.INPUT_DATA_WIDTH1 		(OFFSET_DATA_WIDTH	), 	
		.INPUT_DATA_WIDTH2 		(OFFSET_DATA_WIDTH	)  	
)subtr_h_offset1 (
		.I_clk 					(					),
		.I_dat_en 				(					),
		.I_dat1					(					),
		.I_dat2					(					),
		.O_dat					(					),
		.O_dat_vaild			(					)
);

*/