// alu.v
// 4-bit ALU — 8 operations via 3-bit opcode


module alu (
    input  [3:0] a,
    input  [3:0] b,
    input  [2:0] opcode,
    output reg [3:0] result,
    output reg       carry_out,
    output           zero_flag
);

    // Operation constants — makes code readable
    localparam ADD = 3'b000;
    localparam SUB = 3'b001;
    localparam AND = 3'b010;
    localparam OR  = 3'b011;
    localparam XOR = 3'b100;
    localparam NOT = 3'b101;
    localparam SHL = 3'b110;
    localparam SHR = 3'b111;

    wire [3:0] add_result, sub_result;
    wire       add_carry,  sub_borrow;

    // Instantiate adder for ADD
    ripple_adder ADDER (
        .a(a), .b(b), .cin(1'b0),
        .sum(add_result), .cout(add_carry)
    );

    // SUB uses 2's complement: A + (~B) + 1
    ripple_adder SUBTRACTOR (
        .a(a), .b(~b), .cin(1'b1),
        .sum(sub_result), .cout(sub_borrow)
    );

    // zero_flag: result is zero when all bits are 0
    assign zero_flag = (result == 4'b0000) ? 1'b1 : 1'b0;

    always @(*) begin
        carry_out = 1'b0; // default

        case (opcode)
            ADD: begin
                result    = add_result;
                carry_out = add_carry;
            end
            SUB: begin
                result    = sub_result;
                carry_out = sub_borrow;
            end
            AND: result = a & b;
            OR:  result = a | b;
            XOR: result = a ^ b;
            NOT: result = ~a;
            SHL: begin
                result    = a << 1;
                carry_out = a[3]; // MSB shifts out into carry
            end
            SHR: begin
                result    = a >> 1;
                carry_out = a[0]; // LSB shifts out into carry
            end
            default: result = 4'b0000;
        endcase
    end

endmodule