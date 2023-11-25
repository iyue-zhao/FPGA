

module sync_w2r #(parameter ASIZE = 4)
 (output reg [ASIZE:0] rq2_wptr,
 input [ASIZE:0] wptr,
 input rclk, rrst_n);
 reg [ASIZE:0] rq1_wptr;
 always @(posedge rclk )
 if (!rrst_n) {rq2_wptr,rq1_wptr} <= {(2*ASIZE){1'd0}};
 else {rq2_wptr,rq1_wptr} <= {rq1_wptr,wptr};
endmodule