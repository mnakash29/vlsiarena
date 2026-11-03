module number_formats(
    // Step 1: Define output ports
    // Each should be 4 bits wide [3:0]
    output [3:0] bin_out,    // Binary format output
    output [3:0] oct_out,    // Octal format output
    output [3:0] dec_out,    // Decimal format output
    output [3:0] hex_out     // Hexadecimal format output
);

    // Step 2: Assign binary value 1010
    // Use format: assign <signal> = <size>'b<value>;
    assign bin_out='b1010;
    assign oct_out='o12;
    assign dec_out='d10;
    assign hex_out='hA;
    // Step 3: Assign octal value 12 (= decimal 10)

    // Step 4: Assign decimal value 10

    // Step 5: Assign hex value A (= decimal 10)

endmodule