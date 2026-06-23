// alu_tb.v
// Testbench for 4-bit ALU — tests all 8 operations

`timescale 1ns/1ps

module alu_tb;

    // Inputs (reg because we drive them)
    reg [3:0] a;
    reg [3:0] b;
    reg [2:0] opcode;

    // Outputs (wire because ALU drives them)
    wire [3:0] result;
    wire       carry_out;
    wire       zero_flag;

    // Instantiate the ALU
    alu uut (
        .a(a),
        .b(b),
        .opcode(opcode),
        .result(result),
        .carry_out(carry_out),
        .zero_flag(zero_flag)
    );

    // Task to display results neatly
    task show_result;
        input [24*8:1] op_name;
        begin
            #10;
            $display("OP: %-6s | A=%b(%0d) B=%b(%0d) | Result=%b(%0d) | Carry=%b | Zero=%b",
                op_name, a, a, b, b, result, result, carry_out, zero_flag);
        end
    endtask

    initial begin
        // Setup waveform dump
        $dumpfile("simulation/alu_wave.vcd");
        $dumpvars(0, alu_tb);

        $display("============================================");
        $display("       4-bit ALU Simulation Results        ");
        $display("============================================");

        // --- TEST 1: ADD ---
        a = 4'b0101; b = 4'b0011; opcode = 3'b000; // 5 + 3 = 8
        show_result("ADD");

        // --- TEST 2: ADD with carry ---
        a = 4'b1111; b = 4'b0001; opcode = 3'b000; // 15 + 1 = 16 (overflow, carry=1)
        show_result("ADD");

        // --- TEST 3: SUB ---
        a = 4'b1000; b = 4'b0011; opcode = 3'b001; // 8 - 3 = 5
        show_result("SUB");

        // --- TEST 4: SUB giving zero ---
        a = 4'b0101; b = 4'b0101; opcode = 3'b001; // 5 - 5 = 0, zero_flag=1
        show_result("SUB");

        // --- TEST 5: AND ---
        a = 4'b1100; b = 4'b1010; opcode = 3'b010; // 1100 & 1010 = 1000
        show_result("AND");

        // --- TEST 6: OR ---
        a = 4'b1100; b = 4'b1010; opcode = 3'b011; // 1100 | 1010 = 1110
        show_result("OR");

        // --- TEST 7: XOR ---
        a = 4'b1100; b = 4'b1010; opcode = 3'b100; // 1100 ^ 1010 = 0110
        show_result("XOR");

        // --- TEST 8: NOT ---
        a = 4'b1010; b = 4'bxxxx; opcode = 3'b101; // ~1010 = 0101
        show_result("NOT");

        // --- TEST 9: SHL ---
        a = 4'b0110; b = 4'bxxxx; opcode = 3'b110; // 0110 << 1 = 1100
        show_result("SHL");

        // --- TEST 10: SHR ---
        a = 4'b0110; b = 4'bxxxx; opcode = 3'b111; // 0110 >> 1 = 0011
        show_result("SHR");

        // --- TEST 11: SHL with carry ---
        a = 4'b1010; b = 4'bxxxx; opcode = 3'b110; // MSB=1 shifts into carry
        show_result("SHL");

        $display("============================================");
        $display("         Simulation Complete!              ");
        $display("============================================");

        $finish;
    end

endmodule