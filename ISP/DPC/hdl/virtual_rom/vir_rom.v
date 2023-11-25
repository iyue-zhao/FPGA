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


module vir_rom #(
parameter 	ROM_ADDR_WIDTH 	= 11,
parameter	ROM_DATA_WIDTH  = 8,  // 
parameter 	ROM_MEMORY_TYPE = "distributed" , // auto // block //uram // reg
parameter 	ROM_INITIAL_FILE = "E:/peng/"
)
(
input 								I_rd_clk		, 
input 								I_rd_en 		,
input 	[ROM_ADDR_WIDTH-1:0] 		I_rd_add 		, 
output  reg [ROM_DATA_WIDTH-1:0] 	O_rd_dat			
); 
(*rom_style=ROM_MEMORY_TYPE*)
reg [ROM_DATA_WIDTH-1:0] mem_rom_gen[2**ROM_ADDR_WIDTH-1:0]; 
initial  begin 
    $readmemh(ROM_INITIAL_FILE, mem_rom_gen);
    end 
always @ (posedge I_rd_clk)  
	if(I_rd_en)	O_rd_dat <= mem_rom_gen[I_rd_add]; 

endmodule 



