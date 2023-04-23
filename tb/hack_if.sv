`timescale 1ns/1ns

interface hack_if(input bit clk_50, input clk_phy, input rst);
  logic tx0;
  logic tx1;
  logic tx_en;

  logic rx0   = 0;
  logic rx1   = 0;
  logic rx_en = 0;

  task send_frame(input logic [7:0] frame[]);
    if (!rst) begin
      for (int i = 0; i <= frame.size(); i++) begin
        if (i == frame.size()) begin
          @(posedge clk_50) begin
            rx_en <= 0;
          end
        end else begin
          for (int j = 0; j < 8; j = j+2) begin
            @(posedge clk_50) begin
              rx_en <= 1;
              rx0   <= frame[i][j];
              rx1   <= frame[i][j + 1];
            end
          end
        end
      end
    end else begin
      $error($sformatf("[%0t][HACK_IF] Reset is enabled, frame cannot be sent!", $time));
    end
  endtask

  task automatic capture_frame(ref logic [7:0] frame[]);
    logic [3:0][1:0] data_in;
    logic prev_tx_en = 'b0;
    logic [1:0] prev_tx = 'h0;

    int ptr = 0;
    int size;
    // detect values 01 and 11 then start capturing frame
    int sfd_captured = 0;

    if (!rst) begin
      forever begin
        @(posedge clk_50) begin
          if (prev_tx_en == 'b1 && tx_en == 'b0 && sfd_captured == 2) begin
            if (ptr != 0) begin
              frame = new[1 + size](frame);
              frame[size] = data_in;

              data_in = '{'h0, 'h0, 'h0, 'h0};
            end

            break;
          end

          if (tx_en) begin
            if (sfd_captured == 2) begin
              data_in[ptr] = {tx1, tx0};

              ptr++;
              if (ptr == 4) begin
                ptr = 0;

                size = frame.size();
                frame = new[1 + size](frame);
                frame[size] = data_in;

                data_in = '{'h0, 'h0, 'h0, 'h0};
              end
            end else begin
              if (sfd_captured == 0) begin
                if ({tx1, tx0} == 'b01) begin
                  sfd_captured = 1;
                end
              end else if (sfd_captured == 1) begin
                if ({tx1, tx0} == 'b11) begin
                  frame.delete();
                  sfd_captured = 2;
                end
              end
            end

            prev_tx_en = tx_en;
          end
        end
      end
    end else begin
      $error($sformatf("[%0t][HACK_IF] Reset is enabled, frame cannot be captured!", $time));
    end
  endtask

endinterface
