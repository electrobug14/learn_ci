// File: adder_4bit.v
module adder_4bit (
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);

    // Verilog uses two's complement arithmetic, so we can simply add them
    // and cast the result to 5 bits to get the sum and carry-out.
    wire [4:0] result = {1'b0, a} + {1'b0, b} + {1'b0, cin};

    assign sum = result[3:0]; // The lower 4 bits are the sum
    assign cout = result[4];   // The 5th bit is the carry-out

endmodule
