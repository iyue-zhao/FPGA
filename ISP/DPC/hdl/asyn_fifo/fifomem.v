



module fifomem #(parameter DSIZE = 8, // Memory data word width
 parameter ASIZE = 4) // Number of mem address bits
 (output [DSIZE-1:0] rdata,
 input [DSIZE-1:0] wdata,
 input [ASIZE-1:0] waddr, raddr,
 input wclken, wfull, wclk);
 // RTL Verilog memory model
 localparam DEPTH = 1<<ASIZE;
 reg [DSIZE-1:0] mem [0:DEPTH-1];
 assign rdata = mem[raddr];
 always @(posedge wclk)
 if (wclken && !wfull) mem[waddr] <= wdata;

 
endmodule