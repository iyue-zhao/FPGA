


module asyn_fifo #
(parameter DSIZE = 8,
 parameter ASIZE = 4
 )(
 output reg [DSIZE-1:0] rdata,
 output wfull,
 output rempty,
 input [DSIZE-1:0] wdata,
 input winc, wclk, wrst_n,
 input rinc, rclk, rrst_n);
 wire [ASIZE-1:0] waddr, raddr;
 wire [ASIZE:0] wptr, rptr, wq2_rptr, rq2_wptr;
 wire [DSIZE-1:0] rdata_wire;
 sync_r2w  #(.ASIZE(ASIZE))
 sync_r2w
 (.wq2_rptr(wq2_rptr), .rptr(rptr),
 .wclk(wclk), .wrst_n(wrst_n));
 
 sync_w2r  #(.ASIZE(ASIZE))
 sync_w2r
 (.rq2_wptr(rq2_wptr), .wptr(wptr),
 .rclk(rclk), .rrst_n(rrst_n));
 
 fifomem #(.DSIZE(DSIZE), .ASIZE(ASIZE)) fifomem
 (.rdata(rdata_wire), .wdata(wdata),
 .waddr(waddr), .raddr(raddr),
 .wclken(winc), .wfull(wfull),
 .wclk(wclk));
 
 rptr_empty #(.ASIZE(ASIZE)) rptr_empty
 (.rempty(rempty),
 .raddr(raddr),
 .rptr(rptr), .rq2_wptr(rq2_wptr),
 .rinc(rinc), .rclk(rclk),
 .rrst_n(rrst_n));
 
 wptr_full #(.ASIZE(ASIZE)) wptr_full
 (.wfull(wfull), .waddr(waddr),
 .wptr(wptr), .wq2_rptr(wq2_rptr),
 .winc(winc), .wclk(wclk),
 .wrst_n(wrst_n));

always @(posedge rclk)
	if(!rrst_n)	rdata <= {(DSIZE){1'd0}};
	else if(rinc)rdata<=rdata_wire;

endmodule

/*

asyn_fifo #( 
		.DSIZE   			(),
		.ASIZE 				()
 )asyn_fifo(
		.wclk				(), 
		.wrst_n				(),
		.winc				(), 
		.wdata				(),
		.rclk				(), 
		.rrst_n				(),
		.rinc				(), 
		.rdata				(), 
		.wfull				(),
		.rempty				()
		
 );



*/