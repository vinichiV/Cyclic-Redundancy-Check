module crc #(parameter width = 32, parameter poly_width = 9) // adjust
  (input clk,
   input write_n,
   input read_n,
   input [width-1:0] message,
   input [poly_width - 1:0] poly,
   input reset,
   output [poly_width - 2:0] crc_value);
  
  reg [1:0] state;
  reg [width + poly_width - 2:0] shift_poly;
  reg [7:0] i;
  reg [width + poly_width - 2:0] temp;
  reg [poly_width - 2:0] final_value;
  
  localparam INIT = 2'd0,
  	     	 CALC = 2'd1,
             DONE = 2'd2;
  
  always @(posedge clk) begin
    if(reset) begin
      state <= INIT;
    end
    
	  else begin
		 case(state)
			INIT:begin
			  if (~write_n) begin
				  i <= width;
				  shift_poly <= poly << (width - 1);
				  temp <= message << (poly_width - 1);
				  state <= CALC;
			  end
			end
       
			CALC: begin
			  if(temp[width + poly_width - 2]) begin
				 temp <= (temp ^ shift_poly) << 1;
			  end else begin
				 temp <= temp << 1;
			  end
			  i <= i - 1;
			  state <= DONE;
			end
       
			DONE: begin
			  if(i == 0) begin
			  	 if(~read_n) begin
			 		final_value <= temp[width + poly_width - 2:width];
			 		state <= INIT;
			 	 end else state <= DONE;
			 	 
			  end else state <= CALC;
			end
    endcase
  end
    
end
  
assign crc_value = final_value[poly_width - 2:0];
  
endmodule
