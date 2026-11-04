`timescale 1ns/1ps

// INTERMEDIATE RTL verification starter
// Clock/reset and interface wiring are provided. Complete the verification below.
// This starter performs no functional checks; finishing a run is not a pass verdict.
module mdio_calib_sequencer_visible_tb;

    // DUT interface (default parameter configuration)
    logic clk;
    logic rst_n;
    logic req_valid;
    logic req_prio;
    logic [4:0] req_addr;
    logic [15:0] req_data;
    wire req_ready;
    logic mdio_done;
    wire mdio_start;
    wire [4:0] mdio_addr;
    wire [15:0] mdio_wdata;
    logic stall_in;

    // Named parameter and port connections
    mdio_calib_sequencer #(
        .FIFO_DEPTH(4)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .req_valid(req_valid),
        .req_prio(req_prio),
        .req_addr(req_addr),
        .req_data(req_data),
        .req_ready(req_ready),
        .mdio_done(mdio_done),
        .mdio_start(mdio_start),
        .mdio_addr(mdio_addr),
        .mdio_wdata(mdio_wdata),
        .stall_in(stall_in)
    );

    // Capture signals for the built-in waveform viewer.
    initial begin
        $dumpfile("sim.vcd");
        $dumpvars(0, mdio_calib_sequencer_visible_tb);
    end

    // 10 ns clock period
    always #5 clk = ~clk;

    initial begin
        // Initialize inputs and hold reset across active clock edges.
        clk = 1'b0;
        rst_n = 1'b0;
        req_valid = '0;
        req_prio = '0;
        req_addr = '0;
        req_data = '0;
        mdio_done = '0;
        stall_in = '0;

        repeat (3) @(posedge clk);
        // Release reset away from the sampling edge to avoid a DUT/TB race.
        @(negedge clk);
        rst_n = 1'b1;

        // Verification work
        // INSTRUCTION: Write directed stimulus for each acceptance criterion in the specification.
        // INSTRUCTION: Derive expected outputs and check them; exercise hold and simultaneous inputs.
        // INSTRUCTION: Add boundary cases, reset recovery and legal parameter configurations.
        // INSTRUCTION: Use $error/$fatal on mismatches and report a verdict only after checking.
        // INSTRUCTION: Verify Observed behavior must satisfy B1: High-priority requests (req_prio=1)
        //              must be serviced before any pending low-priority requests.
        // INSTRUCTION: Verify Observed behavior must satisfy B2: mdio_start must remain high for exactly
        //              one cycle when mdio_done is low and stall_in is low.
        // INSTRUCTION: Verify Observed behavior must satisfy B3: If stall_in is high when a transaction
        //              completes (mdio_done=1), the sequencer must hold the current mdio_addr/wdata and
        //              not accept new requests.
        // INSTRUCTION: Verify Simultaneous req_valid and mdio_done while stall_in is high.
        // INSTRUCTION: Verify High-priority request arriving exactly when a low-priority transaction
        //              finishes.
        // Drive on negedge clk; sample after posedge clk and a #1 settling delay.
        // TODO: Add your stimulus and checking code here.

        // Replace this idle smoke-run window with your completed verification sequence.
        repeat (20) @(posedge clk);
        #1;
        $display("Starter smoke run finished; functional verification is still TODO.");
        $finish;
    end

endmodule
