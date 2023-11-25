module wptr_full #(parameter ASIZE = 4)
 (output reg wfull,
 output [ASIZE-1:0] waddr,
 output reg [ASIZE :0] wptr,
 input [ASIZE :0] wq2_rptr,
 input winc, wclk, wrst_n);
 reg [ASIZE:0] wbin;
 wire [ASIZE:0] wgraynext, wbinnext;
 // GRAYSTYLE2 pointer
 always @(posedge wclk )
 if (!wrst_n) {wbin, wptr} <= {(2*ASIZE){1'd0}};
 else {wbin, wptr} <= {wbinnext, wgraynext};
 // Memory write-address pointer (okay to use binary to address memory)
 assign waddr = wbin[ASIZE-1:0];
 assign wbinnext = wbin + (winc & ~wfull);
 assign wgraynext = (wbinnext>>1) ^ wbinnext;
 //------------------------------------------------------------------
 // Simplified version of the three necessary full-tests:
 // assign wfull_val=((wgnext[ASIZE] !=wq2_rptr[ASIZE] ) &&
 // (wgnext[ASIZE-1] !=wq2_rptr[ASIZE-1]) &&
 // (wgnext[ASIZE-2:0]==wq2_rptr[ASIZE-2:0]));
 //------------------------------------------------------------------
 assign wfull_val = (wgraynext==={~wq2_rptr[ASIZE:ASIZE-1],
 wq2_rptr[ASIZE-2:0]});
 always @(posedge wclk )
 if (!wrst_n) wfull <= 1'b0;
 else wfull <= wfull_val;
endmodule