`timescale 1ns/1ps

module tb_crc;
  // Parameters
  parameter width = 32;			// adjust
  parameter poly_width = 9;		// adjust

  // Testbench signals
  reg clk;
  reg [width-1:0] message;
  reg reset;
  reg [poly_width - 1:0] poly;
  wire [poly_width - 2:0] crc_value;

  // Instantiate DUT
  crc #(width, poly_width) uut (
    .clk(clk),
    .message(message),
    .reset(reset),
    .poly(poly),
    .crc_value(crc_value)
  );

  // Clock 10ns period
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Stimulus
  initial begin
    
    poly = 'b100000111;
    message = 'b10001111100111001101101111111000;
    #10 reset = 0;
    #5 reset = 1;
    #5 reset = 0;
    #1000;
    $display("Final CRC value = %b", crc_value);
    
    poly = 'b111010101;
    message = 'b00110011110000111101000011001010;
    #10 reset = 0;
    #5 reset = 1;
    #5 reset = 0;
    #1000;
    $display("Final CRC value = %b", crc_value);
    
    $finish;
   end

  initial begin
    $monitor("Time=%0t       | state=%0d       | i=%0d       | shift_poly = %b       | temp = %b",
             $time, uut.state, uut.i, uut.shift_poly, uut.temp);
  end
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1, tb_crc);
  end
endmodule
