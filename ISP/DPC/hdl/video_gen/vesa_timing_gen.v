`timescale  1ns/100ps
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
 // ----------------------------------------------------------------
 //   I_pattern_format
//---4'b0000 	  1920 *1200
//---4'b0001 	  1920 *1080 p60
//---4'b0010 	  1280 *1024 p60
//---4'b0011 	  1024 *768   
//---4'b0100 	  1280 *720   
//---other 	      user define 


module vesa_timing_gen (
		input 				I_video_clk , 
		input 				I_reset_n  , 
		input 		[3:0]	I_pattern_format,
		input 		[3:0]	I_pattern_colour,
		output 		[29:0]	O_pattern_rgb ,
		output 		[2:0]	O_pattern_syn   
		);
// ------------------------------------------------------------------------------------------------
reg 	[11:0] 	h_timing_syn, h_timing_ba, h_timing_ac, h_timing_total ; 
reg 	[11:0]	v_timing_syn, v_timing_ba, v_timing_ac, v_timing_total ; 
always @(posedge I_video_clk)
	if(!I_reset_n) 	begin 
			h_timing_syn 		<=  12'd0 ;
			h_timing_ba 	 	<=  12'd0 ;  
			h_timing_ac	 		<=  12'd0 ; 
			h_timing_total 	 	<=  12'd0 ; 
			v_timing_syn 		<=  12'd0 ; 
			v_timing_ba 	 	<=  12'd0 ;  
			v_timing_ac	 		<=  12'd0 ; 
			v_timing_total 	 	<=  12'd0 ; 
			end 
	else case (I_pattern_format)
		4'b0000 	: begin         // --------- ------ 1920*1200  pixl clock = 154 M ----------
// 	syn + back + active + front = total 
// 	44  +  148 +   1920 +  88   = 2200 
// 	5   +  36  +   1200 +   4   = 1245
			h_timing_syn 		<=  12'd44   ;
			h_timing_ba 	 	<=  12'd192  ;   // 44 + 148
			h_timing_ac	 		<=  12'd2112 ;   // 44 + 148 + 1920
			h_timing_total 	 	<=  12'd2200 ; 
			v_timing_syn 		<=  12'd5    ; 
			v_timing_ba 		<=  12'd41   ;   // 5 + 36
			v_timing_ac	 		<=  12'd1241 ;   // 5 + 36 + 1200
			v_timing_total 	 	<=  12'd1245 ;
			end 
		4'b0001 	: begin         // -----------  ---- 1920 *1080p60  pixl clock = 148.5M ----------
// 	syn + back + active + front = total 
// 	44   +  148 +   1920 +  88   = 2200 
// 	5    +  36  +   1080 +   4   = 1125
			h_timing_syn 		<=  12'd44   ;
			h_timing_ba 	 	<=  12'd192  ;   //44 +148
			h_timing_ac	 		<=  12'd2112 ;   //44 + 148 + 1920
			h_timing_total 	 	<=  12'd2200 ; 
			v_timing_syn 		<=  12'd5    ; 
			v_timing_ba 	 	<=  12'd41   ;    // 5 + 36
			v_timing_ac	 		<=  12'd1121 ;    // 5 + 36 + 1080
			v_timing_total 	 	<=  12'd1125 ;
			end 
		4'b0010 	: begin         // ----------- ---  1280 *1024p60   pixl clock = 108M ----------
// 	syn + back + active + front = total 
// 	112  +  248 +  1280  +  48   = 1688 
// 	3    +  38  +  1024  +  1    = 1066
			h_timing_syn 		<=  12'd112  ;
			h_timing_ba 	 	<=  12'd360  ;     //112+248
			h_timing_ac	 		<=  12'd1640 ;      //112+248+1280
			h_timing_total 	 	<=  12'd1688 ;
			v_timing_syn 		<=  12'd3    ; 
			v_timing_ba 	 	<=  12'd41   ;     // 3+38
			v_timing_ac	 		<=  12'd1065 ;     // 3+38+1024
			v_timing_total 	 	<=  12'd1125 ;
			end 
		4'b0011 	: begin          // --------------    1024* 768    pixl clock = 65M ----------
// 	syn + back + active + front = total 
// 	136  +  160 +  1024  +  24   = 1344 
// 	6    +  29  +  768   +  3    = 806
			h_timing_syn 		<=  12'd136  ;
			h_timing_ba 	 	<=  12'd296  ;    //136+160
			h_timing_ac	 		<=  12'd1320 ;    //136+160+1024
			h_timing_total 	 	<=  12'd1344 ; 
			v_timing_syn 		<=  12'd6    ; 
			v_timing_ba 	 	<=  12'd35   ;    // 6+29
			v_timing_ac	 		<=  12'd803  ;     // 6+29+768
			v_timing_total 	 	<=  12'd806  ;
			end 
		4'b0100 	: begin           // ------------- - 1280* 720    pixl clock = 65M ----------
// 	syn + back + active + front = total 
// 	40   +  220 +  1280  +  110   = 1650 
// 	5    +  20  +  720   +  5     = 750
			h_timing_syn 		<=  12'd40   ;
			h_timing_ba 	 	<=  12'd260  ;    //136+160
			h_timing_ac  		<=  12'd1540 ;      //136+160+1024
			h_timing_total   	<=  12'd1650 ; 
			v_timing_syn 		<=  12'd5    ; 
			v_timing_ba 	 	<=  12'd25   ;    // 6+29
			v_timing_ac  		<=  12'd745  ;      // 6+29+768
			v_timing_total   	<=  12'd750  ;
			end 
		default : begin                // ---------  user define ------------------------------
			h_timing_syn 	 	<=  12'd40   ;
			h_timing_ba 	 	<=  12'd260  ;     //136+160
			h_timing_ac  		<=  12'd1540 ;     //136+160+1024
			h_timing_total   	<=  12'd1650 ; 
			v_timing_syn 		<=  12'd5    ; 
			v_timing_ba 	 	<=  12'd25   ;      // 6+29
			v_timing_ac  		<=  12'd745  ;     // 6+29+768
			v_timing_total   	<=  12'd750  ;
			end 			

		endcase 
// -------------------------------------------------------------------------
wire 			h_timing_out ,v_timing_out;
reg 	[11:0]	pix_cnt , hyc_cnt ; 
always @(posedge I_video_clk)
	if((!I_reset_n)|h_timing_out) 		pix_cnt 	 <= 12'd1 ; 
	else 								pix_cnt 	 <= pix_cnt + 12'd1 ; 	
always @(posedge I_video_clk)
	if(!I_reset_n) 						hyc_cnt 	 <= 12'd1 ; 
	else if (h_timing_out)  
		if (v_timing_out) 				hyc_cnt 	 <= 12'd1 ; 
		else  							hyc_cnt 	 <= hyc_cnt + 12'd1 ; 
assign h_timing_out = (pix_cnt==h_timing_total);
assign v_timing_out = (hyc_cnt == v_timing_total);
// -------------------------------------- ---------------------------------
reg 			line_vaild ;
reg 			d_signal, h_signal,v_signal;
always @ (posedge I_video_clk)
	if (!I_reset_n)					line_vaild	 <= 1'd0 ;
	else if(hyc_cnt == v_timing_ba)	line_vaild	 <= 1'd1 ;	
	else if(hyc_cnt == v_timing_ac)	
									line_vaild	 <= 1'd0 ;	
always @ (posedge I_video_clk)
    if(!I_reset_n) 						d_signal <= 1'b0;                                
    else if((pix_cnt == h_timing_ba) &line_vaild)
										d_signal <= 1'b1;    
    else if((pix_cnt == h_timing_ac) &line_vaild)	
										d_signal <= 1'b0;
always @ (posedge I_video_clk)
    if(!I_reset_n) 						h_signal <= 1'b0;                                
    else if(h_timing_out)  				h_signal <= 1'b1;    
    else if((pix_cnt == h_timing_syn))	h_signal <= 1'b0;
always @ (posedge I_video_clk )
    if(!I_reset_n) 						v_signal <= 1'b0;                              
    else if(v_timing_out&h_timing_out)  v_signal <= 1'b1;   
    else if((hyc_cnt == v_timing_syn)&(h_timing_out)) 
										v_signal <= 1'b0;
// ------------------------------------------------------------------------
reg 	syn_v, syn_h , syn_d ;
always @ (posedge I_video_clk )	
	{syn_v, syn_h , syn_d}	<= {v_signal, h_signal, d_signal};

assign 	O_pattern_syn	 =  {v_signal, h_signal, d_signal};  
assign 	O_pattern_rgb    =  {10'h3ff, 10'h3ff,10'h3ff} ;
// ------------------------------------------------------------------------
initial  begin 
	#100 ; 
	wait (I_reset_n);
	#100 ;
	force  O_pattern_syn[2]  = 0 ;
	wait(O_pattern_syn[1]==1);
	wait(O_pattern_syn[1]==0);
	#500  force  O_pattern_syn[2]  = 1 ;
	wait(O_pattern_syn[1]==1);
	wait(O_pattern_syn[1]==0);
	wait(O_pattern_syn[1]==1);
	wait(O_pattern_syn[1]==0);
	#500  release O_pattern_syn[2] ;
	end 

endmodule 



