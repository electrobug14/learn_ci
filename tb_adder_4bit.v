// File: tb_adder_4bit.v
`timescale 1ns/1ps

module tb_adder_4bit;

    // DUT Signals (Inputs and Outputs)
    reg [3:0] tb_a;
    reg [3:0] tb_b;
    reg tb_cin;
    wire [3:0] dut_sum;
    wire dut_cout;

    // Reference Model Signals (Expected Outputs)
    reg [3:0] expected_sum;
    reg expected_cout;
    
    // Test Control Variables
    integer i;
    integer num_tests = 1000;
    integer errors = 0;

    // Instantiate the Design Under Test (DUT)
    adder_4bit DUT (
        .a(tb_a),
        .b(tb_b),
        .cin(tb_cin),
        .sum(dut_sum),
        .cout(dut_cout)
    );
    
    // *** REFERENCE MODEL - Calculates the expected result ***
    // This logic must be functionally identical to the intended behavior
    // of the DUT, but implemented simply and clearly.
    always @(tb_a or tb_b or tb_cin) begin
        // Calculate the full 5-bit result
        reg [4:0] expected_result;
        expected_result = {1'b0, tb_a} + {1'b0, tb_b} + {1'b0, tb_cin};
        
        // Extract the expected sum and carry-out
        expected_sum  = expected_result[3:0];
        expected_cout = expected_result[4];
    end
    
    // *** STIMULUS AND COMPARISON GENERATION ***
    initial begin
        $display("--- Starting Randomized Adder Test ---");
        
        // Loop to run all random tests
        for (i = 0; i < num_tests; i = i + 1) begin
            
            // 1. Generate Random Inputs
            // $urandom returns a 32-bit random number. We mask it (using & 15) 
            // to get a 4-bit number (0-15).
            tb_a   = $urandom & 15; 
            tb_b   = $urandom & 15; 
            tb_cin = $urandom & 1;  // Random 1-bit value (0 or 1)
            
            // Wait a small amount of time for signals to propagate/settle
            #5; 

            // 2. Comparison Logic
            if (dut_sum !== expected_sum || dut_cout !== expected_cout) begin
                $display("--- Test FAILED at test #%0d ---", i);
                $display("  Inputs: A=%d, B=%d, Cin=%b", tb_a, tb_b, tb_cin);
                $display("  DUT Output: Sum=%d, Cout=%b", dut_sum, dut_cout);
                $display("  Expected: Sum=%d, Cout=%b", expected_sum, expected_cout);
                errors = errors + 1;
            end
        end
        
        // *** REPORTING AND EXIT STATUS ***
        if (errors == 0) begin
            $display("--- SUCCESS! All %0d tests passed. ---", num_tests);
            $finish; // Exit cleanly on success
        end else begin
            $display("--- FAILURE! %0d out of %0d tests failed. ---", errors, num_tests);
            // $fatal causes the simulation to terminate and exit with a non-zero status,
            // which is essential for the GitHub Action to register a failure.
            $fatal(1); 
        end
    end

endmodule
