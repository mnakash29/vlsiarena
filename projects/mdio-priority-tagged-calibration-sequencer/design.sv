module mdio_calib_sequencer #(
    parameter integer FIFO_DEPTH = 4
) (
    input logic clk,
    input logic rst_n,
    input logic req_valid,
    input logic req_prio,
    input logic [4:0] req_addr,
    input logic [15:0] req_data,
    output logic req_ready,
    input logic mdio_done,
    output logic mdio_start,
    output logic [4:0] mdio_addr,
    output logic [15:0] mdio_wdata,
    input logic stall_in
);

    logic [2:0] pending_lp_count;
    logic active_prio;

    typedef enum logic [1:0] {
        IDLE    = 2'd0,
        BUSY    = 2'd1,
        STALLED = 2'd2
    } state_t;

    state_t state_reg;
    state_t next_state;

    // ------------------------------------------
    // Combinational logic
    // ------------------------------------------

    always_comb begin

        next_state = state_reg;

        // Ready immediately follows reset and stall.
        req_ready = rst_n && !stall_in;

        case (state_reg)

            IDLE: begin
                if (req_valid && !stall_in)
                    next_state = BUSY;
            end

            BUSY: begin
                if (mdio_done && stall_in)
                    next_state = STALLED;
                else if (mdio_done && !stall_in)
                    next_state = IDLE;
            end

            STALLED: begin
                if (!stall_in)
                    next_state = IDLE;
            end

            default: begin
                next_state = IDLE;
            end

        endcase

    end

    // ------------------------------------------
    // Sequential logic
    // ------------------------------------------

    always_ff @(posedge clk) begin

        if (!rst_n) begin

            state_reg        <= IDLE;
            pending_lp_count <= 3'd0;
            active_prio      <= 1'b0;

            mdio_start       <= 1'b0;
            mdio_addr        <= 5'd0;
            mdio_wdata       <= 16'd0;

        end else begin

            state_reg <= next_state;

            // One-cycle start pulse.
            mdio_start <= 1'b0;

            case (state_reg)

                IDLE: begin

                    if (req_valid && !stall_in) begin

                        mdio_addr  <= req_addr;
                        mdio_wdata <= req_data;

                        mdio_start <= 1'b1;

                        active_prio <= req_prio;

                        if (!req_prio &&
                            pending_lp_count < 3'd4) begin

                            pending_lp_count <=
                                pending_lp_count + 3'd1;

                        end

                    end

                end

                BUSY: begin

                    // Hold current transaction.
                    if (mdio_done && !stall_in)
                        active_prio <= 1'b0;

                end

                STALLED: begin

                    // Preserve transaction outputs.
                    mdio_addr  <= mdio_addr;
                    mdio_wdata <= mdio_wdata;

                end

                default: begin
                    state_reg <= IDLE;
                end

            endcase

        end

    end

endmodule