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

module    mid_3x3 #(
parameter     DATA_WIDTH 		= 8			
)(
input 								I_clk 			 	, 
input 	[3*DATA_WIDTH-1:0]			I_line3_1		 	,
input 	[3*DATA_WIDTH-1:0]			I_line3_2		 	, 
input 	[3*DATA_WIDTH-1:0]			I_line3_3 		 	,
input 								I_line_vaild 	 	,
output 	[DATA_WIDTH-1:0]			O_mid_dat 		 	, 
output 								O_mid_vaild	 	 	
);
// ********************************************************************
reg 	[3:0] 		line_vaild ;
always @(posedge I_clk) line_vaild  <= {line_vaild[2:0] , I_line_vaild};
// --------------------------------------------------------------------
reg		[DATA_WIDTH-1:0] 	dat1_1, dat1_2,dat1_3 ;
reg		[DATA_WIDTH-1:0] 	dat2_1, dat2_2,dat2_3 ;
reg		[DATA_WIDTH-1:0] 	dat3_1, dat3_2,dat3_3 ;
always @(posedge I_clk) 	{dat1_3,dat1_2,dat1_1} <= {I_line3_1} ; 
always @(posedge I_clk) 	{dat2_3,dat2_2,dat2_1} <= {I_line3_2} ; 
always @(posedge I_clk) 	{dat3_3,dat3_2,dat3_1} <= {I_line3_3} ; 
//---------------------------------------------------------------------  
wire 	a_cmp1_12, a_cmp1_13, a_cmp1_23   ;
wire 	a_cmp2_12, a_cmp2_13, a_cmp2_23   ;
wire 	a_cmp3_12, a_cmp3_13, a_cmp3_23   ;
assign 	a_cmp1_12 = (dat1_1 > dat1_2) ? 1'd0 : 1'd1 ;
assign 	a_cmp1_13 = (dat1_1 > dat1_3) ? 1'd0 : 1'd1 ;
assign 	a_cmp1_23 = (dat1_2 > dat1_3) ? 1'd0 : 1'd1 ;
assign 	a_cmp2_12 = (dat2_1 > dat2_2) ? 1'd0 : 1'd1 ;
assign 	a_cmp2_13 = (dat2_1 > dat2_3) ? 1'd0 : 1'd1 ;
assign 	a_cmp2_23 = (dat2_2 > dat2_3) ? 1'd0 : 1'd1 ;
assign 	a_cmp3_12 = (dat3_1 > dat3_2) ? 1'd0 : 1'd1 ;
assign 	a_cmp3_13 = (dat3_1 > dat3_3) ? 1'd0 : 1'd1 ;
assign 	a_cmp3_23 = (dat3_2 > dat3_3) ? 1'd0 : 1'd1 ;
//---------------------------------------------------------------------
reg	 [DATA_WIDTH-1:0]      dat1_max, dat1_mid, dat1_min ;
reg	 [DATA_WIDTH-1:0]      dat2_max, dat2_mid, dat2_min ;
reg	 [DATA_WIDTH-1:0]      dat3_max, dat3_mid, dat3_min ;
always @(posedge I_clk)
	case ({a_cmp1_12,a_cmp1_23,a_cmp1_13})
		3'b000:   	{dat1_max, dat1_mid, dat1_min} <= {dat1_1,dat1_2,dat1_3};
		3'b010:   	{dat1_max, dat1_mid, dat1_min} <= {dat1_1,dat1_3,dat1_2};
		3'b011:   	{dat1_max, dat1_mid, dat1_min} <= {dat1_3,dat1_1,dat1_2};
		3'b100:   	{dat1_max, dat1_mid, dat1_min} <= {dat1_2,dat1_1,dat1_3};
		3'b101:   	{dat1_max, dat1_mid, dat1_min} <= {dat1_2,dat1_3,dat1_1};
		3'b111:   	{dat1_max, dat1_mid, dat1_min} <= {dat1_3,dat1_2,dat1_1}; 
		default : 	{dat1_max, dat1_mid, dat1_min} <= 0; // {3{DATA_WIDTH{1'd0}}};
	endcase 
always @(posedge I_clk)
	case ({a_cmp2_12,a_cmp2_23,a_cmp2_13})
		3'b000:   	{dat2_max, dat2_mid, dat2_min} <= {dat2_1,dat2_2,dat2_3};
		3'b010:   	{dat2_max, dat2_mid, dat2_min} <= {dat2_1,dat2_3,dat2_2};
		3'b011:   	{dat2_max, dat2_mid, dat2_min} <= {dat2_3,dat2_1,dat2_2};
		3'b100:   	{dat2_max, dat2_mid, dat2_min} <= {dat2_2,dat2_1,dat2_3};
		3'b101:   	{dat2_max, dat2_mid, dat2_min} <= {dat2_2,dat2_3,dat2_1};
		3'b111:   	{dat2_max, dat2_mid, dat2_min} <= {dat2_3,dat2_2,dat2_1}; 
		default : 	{dat2_max, dat2_mid, dat2_min} <= 0; // {3{DATA_WIDTH{1'd0}} };
	endcase 
always @(posedge I_clk)
	case ({a_cmp3_12,a_cmp3_23,a_cmp3_13})
		3'b000:     {dat3_max, dat3_mid, dat3_min} <= {dat3_1,dat3_2,dat3_3};
		3'b010:     {dat3_max, dat3_mid, dat3_min} <= {dat3_1,dat3_3,dat3_2};
		3'b011:     {dat3_max, dat3_mid, dat3_min} <= {dat3_3,dat3_1,dat3_2};
		3'b100:     {dat3_max, dat3_mid, dat3_min} <= {dat3_2,dat3_1,dat3_3};
		3'b101:     {dat3_max, dat3_mid, dat3_min} <= {dat3_2,dat3_3,dat3_1};
		3'b111:     {dat3_max, dat3_mid, dat3_min} <= {dat3_3,dat3_2,dat3_1}; 
		default :   {dat3_max, dat3_mid, dat3_min} <= 0; // {3{DATA_WIDTH{1'd0}} };
	endcase 
// ---------------------------------------------------------------------------
wire    b_cmp1_12,    b_cmp1_23,     b_cmp1_13 ;
wire    b_cmp2_12,    b_cmp2_23,     b_cmp2_13 ;
wire    b_cmp3_12,    b_cmp3_23,     b_cmp3_13 ;
assign 	b_cmp1_12  =  (dat1_max > dat2_max ) ?  1'd0:1'd1;
assign 	b_cmp1_13  =  (dat1_max > dat3_max ) ?  1'd0:1'd1;
assign 	b_cmp1_23  =  (dat2_max > dat3_max ) ?  1'd0:1'd1;
assign 	b_cmp2_12  =  (dat1_mid > dat2_mid ) ?  1'd0:1'd1;
assign 	b_cmp2_13  =  (dat1_mid > dat3_mid ) ?  1'd0:1'd1;
assign 	b_cmp2_23  =  (dat2_mid > dat3_mid ) ?  1'd0:1'd1;
assign 	b_cmp3_12  =  (dat1_min > dat2_min ) ?  1'd0:1'd1;
assign 	b_cmp3_13  =  (dat1_min > dat3_min ) ?  1'd0:1'd1;
assign 	b_cmp3_23  =  (dat2_min > dat3_min ) ?  1'd0:1'd1;
// ---------------------------------------------------------------------------	
reg	 [DATA_WIDTH-1:0]  b_max_max,  b_max_mid,  b_max_min ;
reg	 [DATA_WIDTH-1:0]  b_mid_max,  b_mid_mid,  b_mid_min ;
reg	 [DATA_WIDTH-1:0]  b_min_max,  b_min_mid,  b_min_min ;
always @(posedge I_clk)
	case ({b_cmp1_12,b_cmp1_23,b_cmp1_13})
		3'b000:     {b_max_max, b_max_mid, b_max_min} <= {dat1_max,dat2_max,dat3_max};
		3'b010:     {b_max_max, b_max_mid, b_max_min} <= {dat1_max,dat3_max,dat2_max};
		3'b011:     {b_max_max, b_max_mid, b_max_min} <= {dat3_max,dat1_max,dat2_max};
		3'b100:     {b_max_max, b_max_mid, b_max_min} <= {dat2_max,dat1_max,dat3_max};
		3'b101:     {b_max_max, b_max_mid, b_max_min} <= {dat2_max,dat3_max,dat1_max};
		3'b111:     {b_max_max, b_max_mid, b_max_min} <= {dat3_max,dat2_max,dat1_max}; 
		default :   {b_max_max, b_max_mid, b_max_min} <= 0; // {3{DATA_WIDTH{1'd0}}       };
	endcase 	
always @(posedge I_clk)
	case ({b_cmp2_12,b_cmp2_23,b_cmp2_13})
		3'b000:     {b_mid_max, b_mid_mid, b_mid_min} <= {dat1_mid,dat2_mid,dat3_mid};
		3'b010:     {b_mid_max, b_mid_mid, b_mid_min} <= {dat1_mid,dat3_mid,dat2_mid};
		3'b011:     {b_mid_max, b_mid_mid, b_mid_min} <= {dat3_mid,dat1_mid,dat2_mid};
		3'b100:     {b_mid_max, b_mid_mid, b_mid_min} <= {dat2_mid,dat1_mid,dat3_mid};
		3'b101:     {b_mid_max, b_mid_mid, b_mid_min} <= {dat2_mid,dat3_mid,dat1_mid};
		3'b111:     {b_mid_max, b_mid_mid, b_mid_min} <= {dat3_mid,dat2_mid,dat1_mid}; 
		default :   {b_mid_max, b_mid_mid, b_mid_min} <= 0; // {3{DATA_WIDTH{1'd0}}       };
	endcase 	
always @(posedge I_clk)
	case ({b_cmp3_12,b_cmp3_23,b_cmp3_13})
		3'b000:     {b_min_max, b_min_mid, b_min_min} <= {dat1_min,dat2_min,dat3_min};
		3'b010:     {b_min_max, b_min_mid, b_min_min} <= {dat1_min,dat3_min,dat2_min};
		3'b011:     {b_min_max, b_min_mid, b_min_min} <= {dat3_min,dat1_min,dat2_min};
		3'b100:     {b_min_max, b_min_mid, b_min_min} <= {dat2_min,dat1_min,dat3_min};
		3'b101:     {b_min_max, b_min_mid, b_min_min} <= {dat2_min,dat3_min,dat1_min};
		3'b111:     {b_min_max, b_min_mid, b_min_min} <= {dat3_min,dat2_min,dat1_min}; 
		default :   {b_min_max, b_min_mid, b_min_min} <= 0; // {3{DATA_WIDTH{1'd0}}       };
	endcase	
// ------------------------------------------------------------------------------------ 	
reg	 [DATA_WIDTH-1:0] 	c_max    ,    c_mid    ,    c_min    ;
wire 					c_cmp_12 ,    c_cmp_23 ,    c_cmp_13 ;
assign 	c_cmp_12 = (b_max_min > b_mid_mid) ? 1'd0:1'd1 ;
assign 	c_cmp_13 = (b_max_min > b_min_max) ? 1'd0:1'd1 ;
assign 	c_cmp_23 = (b_mid_mid > b_min_max) ? 1'd0:1'd1 ;
always @(posedge I_clk)
	case ({c_cmp_12,c_cmp_23,c_cmp_13})
		3'b000:     {c_max, c_mid, c_min} <= {b_max_min,b_mid_mid,b_min_max};
		3'b010:     {c_max, c_mid, c_min} <= {b_max_min,b_min_max,b_mid_mid};
		3'b011:     {c_max, c_mid, c_min} <= {b_min_max,b_max_min,b_mid_mid};
		3'b100:     {c_max, c_mid, c_min} <= {b_mid_mid,b_max_min,b_min_max};
		3'b101:     {c_max, c_mid, c_min} <= {b_mid_mid,b_min_max,b_max_min};
		3'b111:     {c_max, c_mid, c_min} <= {b_min_max,b_mid_mid,b_max_min}; 
		default :   {c_max, c_mid, c_min} <= 0; // {3{DATA_WIDTH{1'd0}}          };
	endcase  
// -----------------------------------------------------------------------------------
assign 	O_mid_dat 	  =   c_mid ; 
assign  O_mid_vaild   =   line_vaild[3];	
endmodule 
