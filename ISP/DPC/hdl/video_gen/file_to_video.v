`timescale 1ns/100ps 
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

module   file_to_video (
input 					I_video_clk 	,
input 					I_reset_n 		,
output 	[2:0]			O_video_syn		,
output 	[7:0] 			O_video_r 		,
output 	[7:0] 			O_video_g 		,
output 	[7:0] 			O_video_b 		
);
// -----------------------------------------------------------------------------------------
wire 	[2:0]			patten_syn 		;
wire 	[29:0] 			patten_rgb 		;
// -----------------------------------------------------------------------------------------
localparam  	R_FILE_PATH  = "E:/peng/source/release_1_dpc/code/matlab/dpc_patten.txt" ;
localparam  	G_FILE_PATH  = "E:/peng/source/release_1_dpc/code/matlab/dpc_patten.txt" ;
localparam  	B_FILE_PATH  = "E:/peng/source/release_1_dpc/code/matlab/dpc_patten.txt" ;


 // *****  I_pattern_format  *****
//4'b0000 	---> 1920*1200
//4'b0001 	---> 1920*1080p60
//4'b0010 	---> 1280*1024p60
//4'b0011 	---> 1024*768   
//4'b0100 	---> 1280*720   
// ***** I_pattern_colour  *****
//4'b0000  --->  full colour bar 
//4'b0001  --->  almost full colour bar 
//4'b0010  --->  gray  bar 
// --------------------------------------------------------------------------------------------
vesa_timing_gen     vesa_timing_gen ( 
//pattern_gen_10bit   pattern_gen_10bit( 
        .I_video_clk          	(I_video_clk    	), 
        .I_reset_n              (I_reset_n			), 
        .I_pattern_format    	(4'b0001      		),
		.I_pattern_colour 		(4'b0010			),
        .O_pattern_rgb      	(patten_rgb  		),
        .O_pattern_syn     		(patten_syn 		)  // V ,H ,DE 
		);
//---------------------------------------------------------------------
reg 	[23:0] 		rom_addr ;
always @(posedge I_video_clk)
	if(patten_syn[0])			rom_addr <= rom_addr + 24'd1; //24'd2 ;
	else if(patten_syn[2])		rom_addr <= 24'd0 ;
// --------------------------------------------------------------------
wire 	[7:0]		video_r,	video_g,	video_b;
vir_rom #(
		.ROM_ADDR_WIDTH 		(24					),
		.ROM_DATA_WIDTH  		(8					),
		.ROM_MEMORY_TYPE 		("distributed"		), // auto // block //uram // reg
		.ROM_INITIAL_FILE 		( R_FILE_PATH		) 
)vir_rom_r(
		.I_rd_clk				(I_video_clk		), 
		.I_rd_en 				(patten_syn[0] 		),
		.I_rd_add 				(rom_addr			), 
		.O_rd_dat				(video_r			)	
);


vir_rom #(
		.ROM_ADDR_WIDTH 		(24					),
		.ROM_DATA_WIDTH  		(8					),
		.ROM_MEMORY_TYPE 		("distributed"		), // auto // block //uram // reg
		.ROM_INITIAL_FILE 		(G_FILE_PATH		)
)vir_rom_g(
		.I_rd_clk				(I_video_clk		), 
		.I_rd_en 				(patten_syn[0] 		),
		.I_rd_add 				(rom_addr			), 
		.O_rd_dat				(video_g			)	
);

vir_rom #(
		.ROM_ADDR_WIDTH 		(24					),
		.ROM_DATA_WIDTH  		(8					),
		.ROM_MEMORY_TYPE 		("distributed"		), // auto // block //uram // reg
		.ROM_INITIAL_FILE 		( B_FILE_PATH		)
)vir_rom_b(
		.I_rd_clk				(I_video_clk		), 
		.I_rd_en 				(patten_syn[0] 		),
		.I_rd_add 				(rom_addr			), 
		.O_rd_dat				(video_b			)	
);

// ------------------------------------------------------------
reg 	[2:0]  video_syn ;
reg 	[29:0] video_patten_rgb ;
always @(posedge I_video_clk)video_syn<= patten_syn;
always @(posedge I_video_clk)video_patten_rgb<= patten_rgb;

assign 	O_video_syn = video_syn;
assign 	O_video_r = {video_r}	;
assign 	O_video_g = {video_g}	;  //8'd120; // video_patten_rgb[7:0] ; // 
assign 	O_video_b = {video_b}	;

//
//initial  begin 
//	#100 ; 
//	wait (I_reset_n);
//	#100 ;
//	force  patten_syn[2]  = 0 ;
//	wait(patten_syn[1]==1);
//	wait(patten_syn[1]==0);
//	#500  force  patten_syn[2]  = 1 ;
//	wait(patten_syn[1]==1);
//	wait(patten_syn[1]==0);
//	wait(patten_syn[1]==1);
//	wait(patten_syn[1]==0);
//	#500  release patten_syn[2] ;
//	end 
//

endmodule 
