// File: tb_adder_4bit.v (CORRECTED)
`timescale 1ns/1ps

module tb_adder_4bit;

    // --- 1. DUT Signals (Inputs and Outputs) ---
    reg [3:0] tb_a;
    reg [3:0] tb_b;
    reg tb_cin;
    wire [3:0] dut_sum;
    wire dut_cout;

    // --- 2. Reference Model Signals (Expected Outputs) ---
    reg [3:0] expected_sum;
    reg expected_cout;
    
    // --- 3. Test Control Variables (MUST be declared here, at module level) ---
    integer i;              // Moved to module level
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
    always @(tb_a or tb_b or tb_cin) begin
        reg [4:0] expected_result;
        
        // This is the functional behavior (A + B + Cin)
        expected_result = {1'b0, tb_a} + {1'b0, tb_b} + {1'b0, tb_cin};
        
        expected_sum  = expected_result[3:0];
        expected_cout = expected_result[4];
    end
    
    // *** STIMULUS AND COMPARISON GENERATION ***
    initial begin
        $display("--- Starting Randomized 4-bit Adder Test (%0d runs) ---", num_tests);
        
        // Loop to run all random tests
        for (i = 0; i < num_tests; i = i + 1) begin
            
            // 1. Generate Random Inputs
            // $urandom is a Verilog feature for generating random numbers
            tb_a   = $urandom & 4'hF; // 4'hF is 15, masks to 4 bits
            tb_b   = $urandom & 4'hF; 
            tb_cin = $urandom & 1'b1; // Masks to 1 bit (0 or 1)
            
            #5; // Wait 5 time units for inputs to apply and outputs to settle

            // 2. Comparison Logic
            if (dut_sum !== expected_sum || dut_cout !== expected_cout) begin
                $display("--- Test FAILED at run #%0d ---", i);
                $display("  Inputs: A=%d, B=%d, Cin=%b", tb_a, tb_b, tb_cin);
                $display("  DUT Output: Sum=%d, Cout=%b", dut_sum, dut_cout);
                $display("  Expected: Sum=%d, Cout=%b", expected_sum, expected_cout);
                errors = errors + 1;
            end
        end
        
        // *** REPORTING AND EXIT STATUS ***
        if (errors == 0) begin
            $display("--- SUCCESS! All %0d tests passed. ✅ ---", num_tests);
            $finish; // Exit cleanly on success
        end else begin
            $display("--- FAILURE! %0d out of %0d tests failed. ❌ ---", errors, num_tests);
            // $fatal causes the simulation to terminate and exit with a non-zero status (1).
            // This is what makes the GitHub Action FAIL.
            $fatal(1); 
        end
    end

endmodule
