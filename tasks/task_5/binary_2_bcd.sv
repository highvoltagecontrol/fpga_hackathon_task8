//============================================================================================================================
// TASK 5: Binary 2 BCD
// 
//============================================================================================================================
module binary2bcd (i_clk, i_rst, i_binary, i_busy_input, i_busy_output, i_empty_input,
 i_full_output,  o_BCD, o_valid_output, o_req_input);
//-----		PARAMETERS	------------------------------------------------------------------------------------------------------
  localparam BINARY_WIDTH = 8;
  localparam DECIMAL_DIGITS = 2;
//-----		INPUTS		------------------------------------------------------------------------------------------------------
  input                            i_clk;              // Clock signal.
  input                            i_rst;              // Reset signal.
  input  [BINARY_WIDTH-1:0]        i_binary;           // Binary number that is being converted to BCD.
  input                            i_busy_input;
  input                            i_busy_output;
  input                            i_empty_input; 
  input                            i_full_output;
//-----		OUTPUTS		------------------------------------------------------------------------------------------------------
  output [DECIMAL_DIGITS*4-1:0]    o_BCD;              // Output number in BCD format.
  output                           o_valid_output;     // Signal that indicates if output o_BCD is valid.
  output                           o_req_input;
//-----		WIRES			------------------------------------------------------------------------------------------------------
  wire   [3:0]                     w_BCD_digit;
//-----		REGS			------------------------------------------------------------------------------------------------------
  reg    [DECIMAL_DIGITS*4-1:0]    r_BCD          = 0; // The vector that contains the output BCD.
  reg    [BINARY_WIDTH-1:0]        r_binary       = 0; // The vector that contains the input binary value being shifted.   
  reg    [DECIMAL_DIGITS-1:0]      r_digit_index  = 0; // Keeps track of which Decimal Digit we are indexing. 
  reg    [7:0]                     r_loop_count   = 0; // Keeps track of which loop iteration we are on.
  reg                              r_valid_output = 0; // Register for o_valid signal.
//-----     OTHERS      ------------------------------------------------------------------------------------------------------
  typedef enum {s_IDLE, s_SEND_REQ, s_GET_DATA, s_SHIFT, s_CHECK_SHIFT, s_ADD, s_CHECK_DIGIT, s_DONE} bcd_enum;
  bcd_enum 					           state          = s_IDLE;
  bcd_enum                         next_state     = s_IDLE; 
  
  
//============================================================================================================================
// 		   MODULE CONTENT		                                                                                               
//============================================================================================================================
 
 
//--------- NEXT STATE LOGIC  ------------------------------------------------------------------------------------------------
  always @(posedge i_clk) begin
   if (i_rst) begin
		next_state <= s_IDLE;
	end
	else begin
		case(state) 
			s_IDLE: begin
				if(!i_busy_input && !i_empty_input)
					next_state <= s_SEND_REQ;
				else
					next_state <= s_IDLE;
			end
			s_SEND_REQ: begin
				next_state <= s_GET_DATA;
			end
			s_GET_DATA: begin
				next_state <= s_SHIFT;
			end
			s_SHIFT: begin
				next_state <= s_CHECK_SHIFT;			
			end
			s_CHECK_SHIFT: begin
				if(r_loop_count == BINARY_WIDTH-1)
					next_state <= s_DONE;
				else
					next_state <= s_ADD;			
			end
			s_ADD: begin
				next_state <= s_CHECK_DIGIT;			
			end
			s_CHECK_DIGIT: begin
				if(r_digit_index == DECIMAL_DIGITS-1)
					next_state <= s_SHIFT;
				else
					next_state <= s_ADD;			
			end
			s_DONE: begin
				if(!i_full_output && !i_busy_output)
					next_state <= s_IDLE;
				else 
					next_state <= s_DONE;
			end
			default: begin
				next_state <= s_IDLE;
			end
		endcase
	end
  end
//--------- UPDATING STATE    ------------------------------------------------------------------------------------------------ 
  always @(posedge i_clk)
   if (i_rst) begin
		state <= s_IDLE;
	end
	else begin
		state <= next_state;
	end
//--------- OUTPUT LOGIC      ------------------------------------------------------------------------------------------------   
  always @(posedge i_clk)
    begin
      case (state) 
        // Stay in this state until module that receives data from outside and sends it to this task is no longer busy
		  // and its FIFO is no longer empty
        s_IDLE: begin
            r_valid_output <= 1'b0;
				r_BCD <= 1'b0;
        end
		  // Send request to the input module 
		  s_SEND_REQ: begin
		  
		  end
		  // Get data from the input module
		  s_GET_DATA: begin
				r_binary <= i_binary[BINARY_WIDTH-1:0];
		  end
        // Always shift the BCD Vector until we have shifted all bits through
        // Shift the most significant bit of r_binary into r_BCD lowest bit.
        s_SHIFT: begin 
            r_BCD     <= r_BCD << 1;
            r_BCD[0]  <= r_binary[BINARY_WIDTH-1];
            r_binary  <= r_binary << 1;
        end             
        // Check if we are done with shifting in r_binary vector
        s_CHECK_SHIFT: begin
            if (r_loop_count == BINARY_WIDTH-1)
                r_loop_count <= 0;
            else
                r_loop_count <= r_loop_count + 1'b1;
		  // Break down each BCD Digit individually. Check them one-by-one to 
		  // see if they are greater than 4. If they are, increment by 3. 
		  // Put the result back into r_BCD vector. 
		  end				 
			s_ADD: begin
				if (w_BCD_digit > 4)                                   
                r_BCD[(r_digit_index*4)+:4] <= w_BCD_digit + 2'b11;       
         end        
        // Check if we are done incrementing all of the BCD Digits
        s_CHECK_DIGIT: begin
            if (r_digit_index == DECIMAL_DIGITS-1)
                r_digit_index <= 0;
            else
                r_digit_index <= r_digit_index + 1'b1;
        end
        s_DONE: begin
		      if(!i_full_output && !i_busy_output)
					r_valid_output <= 1'b1;
		  end	
      endcase
    end   
 
 
  assign w_BCD_digit = r_BCD[r_digit_index*4 +: 4];      
  assign o_BCD = r_BCD;
  assign o_valid_output  = r_valid_output;
  assign o_req_input = (state == s_SEND_REQ) ? 1'b1 : 1'b0; // Send request when you are in s_SEND_REQ state.
  
      
endmodule 
