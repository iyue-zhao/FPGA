
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


module  dpc_dat_judge #(
parameter DATA_WIDTH 		= 8	
)
(
input 								clk 				,
input 	[7:0]						I_dpc_thrd_value	,
input 	[3*DATA_WIDTH+2:0]			I_line3_1			,
input 	[3*DATA_WIDTH+2:0]			I_line3_2			, 
input 	[3*DATA_WIDTH+2:0]			I_line3_3 			,
input 								I_dat_vaild			,
input	[DATA_WIDTH-1:0]			I_mid_dat 			,
output 	[DATA_WIDTH-1:0]			O_judge_dat			,
output 								O_judge_vaild		
);
// ------------------------------------------------------- ----------------------------- FIRST BLOOD 
reg  [DATA_WIDTH:0]	dat1r0,dat2r0,dat3r0,dat4r0,dat5r0,dat6r0,dat7r0,dat8r0,dat9r0;
reg  	[7:0]				thr1r0;
wire 	[7:0] 				sig_bit ;
wire 						comp_en ;
always @(posedge clk) {dat1r0,dat2r0,dat3r0,dat4r0,dat5r0,dat6r0,dat7r0,dat8r0,dat9r0} 
													<= {I_line3_1,I_line3_2,I_line3_3};
always @(posedge clk) thr1r0<= I_dpc_thrd_value;
assign 	sig_bit = {	dat1r0[DATA_WIDTH],dat2r0[DATA_WIDTH],dat3r0[DATA_WIDTH],dat4r0[DATA_WIDTH],
					dat6r0[DATA_WIDTH],dat7r0[DATA_WIDTH],dat8r0[DATA_WIDTH],dat9r0[DATA_WIDTH]};
assign 	comp_en = ((sig_bit==8'd0)| (sig_bit==8'hff))?1'd1:1'd0 ;
// -------------------------------------------------------------------------------------- SECOND BLOOD 
reg	[DATA_WIDTH-1:0]		dat1r1,dat2r1,dat3r1,dat4r1,dat6r1,dat7r1,dat8r1,dat9r1;
reg  		[7:0]			thr1r1,thr2r1,thr3r1,thr4r1,thr6r1,thr7r1,thr8r1,thr9r1;
reg 						comp_enr ;
always @(posedge clk) {thr1r1,thr2r1,thr3r1,thr4r1,thr6r1,thr7r1,thr8r1,thr9r1} <= {8{thr1r0}};
always @(posedge clk)				comp_enr<= comp_en ;
always @(posedge clk) 
	if(dat1r0[DATA_WIDTH])			dat1r1 <= ~dat1r0[DATA_WIDTH-1:0];
	else 							dat1r1 <=  dat1r0[DATA_WIDTH-1:0];
always @(posedge clk) 
	if(dat2r0[DATA_WIDTH])			dat2r1 <= ~dat2r0[DATA_WIDTH-1:0];
	else 							dat2r1 <=  dat2r0[DATA_WIDTH-1:0];	
always @(posedge clk) 
	if(dat3r0[DATA_WIDTH])			dat3r1 <= ~dat3r0[DATA_WIDTH-1:0];
	else 							dat3r1 <=  dat3r0[DATA_WIDTH-1:0];	
always @(posedge clk) 
	if(dat4r0[DATA_WIDTH])			dat4r1 <= ~dat4r0[DATA_WIDTH-1:0];
	else 							dat4r1 <=  dat4r0[DATA_WIDTH-1:0];
always @(posedge clk) 
	if(dat6r0[DATA_WIDTH])			dat6r1 <= ~dat6r0[DATA_WIDTH-1:0];
	else 							dat6r1 <=  dat6r0[DATA_WIDTH-1:0];
always @(posedge clk) 
	if(dat7r0[DATA_WIDTH])			dat7r1 <= ~dat7r0[DATA_WIDTH-1:0];
	else 							dat7r1 <=  dat7r0[DATA_WIDTH-1:0];	
always @(posedge clk) 
	if(dat8r0[DATA_WIDTH])			dat8r1 <= ~dat8r0[DATA_WIDTH-1:0];
	else 							dat8r1 <=  dat8r0[DATA_WIDTH-1:0];	
always @(posedge clk) 
	if(dat9r0[DATA_WIDTH])			dat9r1 <= ~dat9r0[DATA_WIDTH-1:0];
	else 							dat9r1 <=  dat9r0[DATA_WIDTH-1:0];
// --------------------------------------------------------------------------
wire 	[7:0]	flg;
assign 	flg[0] = dat1r1 > thr1r1 ? 1'd1:1'd0 ;
assign 	flg[1] = dat2r1 > thr2r1 ? 1'd1:1'd0 ;
assign 	flg[2] = dat3r1 > thr3r1 ? 1'd1:1'd0 ;
assign 	flg[3] = dat4r1 > thr4r1 ? 1'd1:1'd0 ;
assign 	flg[4] = dat6r1 > thr6r1 ? 1'd1:1'd0 ;
assign 	flg[5] = dat7r1 > thr7r1 ? 1'd1:1'd0 ;
assign 	flg[6] = dat8r1 > thr8r1 ? 1'd1:1'd0 ;
assign 	flg[7] = dat9r1 > thr9r1 ? 1'd1:1'd0 ;
// --------------------------------------------------------------------------------------------- THIRD BLOOD
reg  [DATA_WIDTH-1:0]		new_dat ;
reg  [DATA_WIDTH-1:0]		dat5r1 ;
reg  [DATA_WIDTH-1:0]		midr0,  midr1  ;
reg  [2:0] 					vaild_r ; 
wire 						judge_flag ;	
always @(posedge clk) dat5r1			<= dat5r0;
always @(posedge clk) {midr1,  midr0 }	<= {midr0 ,I_mid_dat};
always @(posedge clk) vaild_r           <= {vaild_r[1:0],I_dat_vaild};
always @(posedge clk)
	if(judge_flag)				new_dat <= midr1 	;
	else 						new_dat <= dat5r1    ;
assign 	judge_flag = comp_enr&(flg==8'hff) ;
assign 	O_judge_dat 	=  new_dat 		;
assign 	O_judge_vaild 	= vaild_r[2] 	;

endmodule 
