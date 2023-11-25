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

module  line_buffer_fifo  #(
parameter 	VIDEO_DATA_WIDTH 	 =  8  ,		
parameter 	FIFO_ADDR_WIDTH 	 =  12 ,		
parameter 	LINE_NUMBER_VECTOR 	 =  5     	
)(
input 					      	   	      	    	I_video_clk 	, 
input 					      	   	      	    	I_reset 		,
input 					      	   	      	    	I_de_vaild 		,
input 	[2:0] 			      	   	      	    	I_video_syn		,
input 	[VIDEO_DATA_WIDTH-1:0] 						I_video_dat 	,
output 	[LINE_NUMBER_VECTOR*VIDEO_DATA_WIDTH-1:0] 	O_video_line	, // first in low , new to high 
output 	[2:0] 				                        O_video_syn		,
output 	[LINE_NUMBER_VECTOR-2:0] 					O_lb_debug 		
); 
// **************************************************************************************
reg 	[3:0] 					syn_v, syn_h, syn_d ;
reg 	[VIDEO_DATA_WIDTH-1:0]	dat_r0,  dat_r1, dat_r2;
wire 							syn_de_pos ;
always @(posedge I_video_clk)	syn_d	<= {syn_d[2:0],I_video_syn[0]};
always @(posedge I_video_clk)	syn_h	<= {syn_h[2:0],I_video_syn[1]};
always @(posedge I_video_clk)	syn_v	<= {syn_v[2:0],I_video_syn[2]};
always @(posedge I_video_clk)	{dat_r2,dat_r1,dat_r0}	<= {dat_r1,dat_r0,I_video_dat} ;
assign 	syn_de_pos  = ({syn_d[0],I_video_syn[0]}==2'b01)? 1'd1:1'd0 ;
// --------------------------------------------------------------------------------------
reg		 [LINE_NUMBER_VECTOR-1:0] 	fifo_disable 								;
wire 	 [VIDEO_DATA_WIDTH-1:0] 	fifo_data 		[0:LINE_NUMBER_VECTOR-1]	;
wire 	 [LINE_NUMBER_VECTOR-2:0]	wfull , 		rempty 					;
always @(posedge I_video_clk)
	if(syn_v[0]|I_reset)		fifo_disable	<= {(LINE_NUMBER_VECTOR){1'd1}}; 
	else if(syn_de_pos)			fifo_disable	<= fifo_disable<<1 ;
assign 	fifo_data[0] 	=   dat_r2 ;
genvar  fifo_num ;	
generate 
	for (fifo_num = 0;fifo_num< LINE_NUMBER_VECTOR-1; fifo_num = fifo_num + 1) begin:dat_bf 
/* xilinx_fifo_in_lb   xilinx_fifo_in_lb(
		.clk					(I_video_clk							), 
		.srst					(syn_v[0]								),
		.wr_en					((!fifo_disable[fifo_num])&syn_d[2]		), 
		.din					(fifo_data[fifo_num]					),
		.rd_en					((!fifo_disable[fifo_num+1])&syn_d[1]	), 
		.dout					(fifo_data[fifo_num+1]					), 
		.full					(wfull[fifo_num]						),
		.empty					(rempty[fifo_num]						)	
 ); */
asyn_fifo #( 
		.DSIZE   				(VIDEO_DATA_WIDTH						),
		.ASIZE 					(FIFO_ADDR_WIDTH						)
 )asyn_fifo(		
		.wclk					(I_video_clk							), 
		.wrst_n					(!(syn_v[0]	|I_reset)					),
		.winc					((!fifo_disable[fifo_num])&syn_d[2]		), 
		.wdata					(fifo_data[fifo_num]					),
		.rclk					(I_video_clk							), 
		.rrst_n					(!(syn_v[0]	|I_reset)					),
		.rinc					((!fifo_disable[fifo_num+1])&syn_d[1]	), 
		.rdata					(fifo_data[fifo_num+1]					), 
		.wfull					(wfull[fifo_num]						),
		.rempty					(rempty[fifo_num]						)
 );
 end 
endgenerate 
// -------------------------------------------------------------------------------------------
wire 	[LINE_NUMBER_VECTOR*VIDEO_DATA_WIDTH-1:0]   lb_dat ;
genvar  dat_num ;	
generate 
	for (dat_num=0; dat_num < LINE_NUMBER_VECTOR;dat_num=dat_num+1)   begin: reshape_fifo_dat
		assign 	lb_dat[(dat_num+1)*VIDEO_DATA_WIDTH-1:dat_num*VIDEO_DATA_WIDTH] 
						= fifo_data[LINE_NUMBER_VECTOR-dat_num-1];
		end 
endgenerate
// -------------------------------------------------------------------------------------------
reg  [LINE_NUMBER_VECTOR*VIDEO_DATA_WIDTH-1:0]	 lb_dat_r ;
wire 											 de_vaild ;
always @(posedge I_video_clk)	lb_dat_r	<=  lb_dat ;
assign 	de_vaild = (fifo_disable=={(LINE_NUMBER_VECTOR){1'd0}})?1'd1:1'd0;
assign 	O_video_line	=  lb_dat_r ;
assign 	O_video_syn[0]	=  syn_d[3] & (de_vaild | (!I_de_vaild));
assign 	O_video_syn[1]	=  syn_h[3];
assign 	O_video_syn[2]	=  syn_v[3];
assign 	O_lb_debug      = wfull;
endmodule 


/*


line_buffer_fifo #(
		.VIDEO_DATA_WIDTH 				(VIDEO_DATA_WIDTH	),		//输入数据位宽
		.FIFO_ADDR_WIDTH 				(12					),		// 2**12= 4096>3840
		.LINE_NUMBER_VECTOR 			(5					)     	
)line_buffer_cov_5x5(
		.I_video_clk 					(I_clk				), 
		.I_reset 						(I_video_reset		),
		.I_de_vaild						(1'd1				),
		.I_video_syn					(I_video_syn		),
		.I_video_dat 					(I_video_dat		),
		.O_video_line					(line_5_5			), 
		.O_video_syn					(video_syn_5_5		),
		.O_lb_debug 					(lb_debug 			)
);

*/