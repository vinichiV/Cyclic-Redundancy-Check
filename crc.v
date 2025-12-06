module crc #(parameter width = 32, parameter poly_width = 9) // adjust
  (input clk,
   input [width-1:0] message,
   input [poly_width - 1:0] poly,
   input reset,
   output [poly_width - 2:0] crc_value);
  
  reg [1:0] state;
  reg [width + poly_width - 2:0] shift_poly;
  reg [7:0] i;
  reg [width + poly_width - 2:0] temp;
  reg [poly_width - 2:0] final_value;
  
  always @(posedge clk) begin
    if(reset) begin
      state <= 0;
    end
  end
  
  always @(posedge clk) begin
    case(state)
      0:begin
    	  i <= width;
    	  shift_poly <= poly << (width - 1);
        temp <= message << (poly_width - 1);
        state <= 1;
      end
      1: begin
        if(temp[width + poly_width - 2]) begin
          temp <= (temp ^ shift_poly) << 1;
        end else begin
          temp <= temp << 1;
        end
        i = i - 1;
        state <= 2;
      end
      2: begin
        if(i == 0) begin
          final_value <= temp[width + poly_width - 2:width];
        end else state <= 1;
      end
    endcase
  end
  
  assign crc_value = final_value[poly_width - 2:0];
  
endmodule
