module fpga_storm_iv_demo(
    input wire clk,           // PIN_91
    input wire rst_n,         // RESET BUTTON (PIN_90)
    input wire [3:0] keys,    // PUSH BUTTONS (Now correctly mapped)
    input wire [3:0] dips,    // DIP SWITCHES (Now correctly mapped)
    output reg [7:0] leds,    // LEDs
    output reg [3:0] seg_sel, // Digit Selects
    output reg [7:0] seg_data,// Segment Data
    output reg beep           // Buzzer
);

    // --- 1. Parameters ---
    parameter ZERO=8'b11000000; parameter ONE=8'b11111001; parameter TWO=8'b10100100;
    parameter THREE=8'b10110000; parameter FOUR=8'b10011001; parameter FIVE=8'b10010010;
    parameter SIX=8'b10000010; parameter SEVEN=8'b11111000; parameter EIGHT=8'b10000000;
    parameter NINE=8'b10010000; parameter OFF=8'b11111111;

    // --- 2. Variables ---
    // We store the number as 4 separate digits to make your requested logic easier
    reg [3:0] digit0 = 0; // Ones
    reg [3:0] digit1 = 0; // Tens
    reg [3:0] digit2 = 0; // Hundreds
    reg [3:0] digit3 = 0; // Thousands
    
    reg [25:0] one_sec_timer = 0;
    
    reg [3:0] last_keys = 4'b1111;
    reg [19:0] debounce_timer = 0;
    
    initial leds = 8'b00001111; 
    reg request_beep = 0; 

    // --- 3. Main Logic ---
    always @(posedge clk) begin
        request_beep <= 0;

        // A. RESET LOGIC (Top Button)
        if (!rst_n) begin
            digit0 <= 0; digit1 <= 0; digit2 <= 0; digit3 <= 0;
            one_sec_timer <= 0;
        end 
        
        // B. TIMER & INCREMENT LOGIC
        else if (one_sec_timer == 49_999_999) begin
            one_sec_timer <= 0;
            
            // LOGIC: Check DIPs (Active Low: 0 is ON)
            
            // Case 1: All DIPs OFF (1111) -> Increment Whole Number
            if (dips == 4'b1111) begin
                if (digit0 == 9) begin
                    digit0 <= 0;
                    if (digit1 == 9) begin
                        digit1 <= 0;
                        if (digit2 == 9) begin
                            digit2 <= 0;
                            if (digit3 == 9) digit3 <= 0;
                            else digit3 <= digit3 + 1;
                        end else digit2 <= digit2 + 1;
                    end else digit1 <= digit1 + 1;
                end else digit0 <= digit0 + 1;
            end
            
            // Case 2: Specific DIPs ON -> Increment specific digits ONLY
            else begin
                // DIP 1 ON: Increment Ones
                if (!dips[0]) digit0 <= (digit0 == 9) ? 0 : digit0 + 1;
                
                // DIP 2 ON: Increment Tens
                if (!dips[1]) digit1 <= (digit1 == 9) ? 0 : digit1 + 1;
                
                // DIP 3 ON: Increment Hundreds
                if (!dips[2]) digit2 <= (digit2 == 9) ? 0 : digit2 + 1;
                
                // DIP 4 ON: Increment Thousands
                if (!dips[3]) digit3 <= (digit3 == 9) ? 0 : digit3 + 1;
            end
        end else begin
            one_sec_timer <= one_sec_timer + 1;
        end

        // C. BUTTON LOGIC (Toggle LED + Beep)
        if (debounce_timer > 0) begin
            debounce_timer <= debounce_timer - 1;
            last_keys <= keys;
        end else begin
            if (last_keys != keys) begin
                // If any key was just pressed (Falling Edge)
                if ((last_keys[0] && !keys[0]) || (last_keys[1] && !keys[1]) || 
                    (last_keys[2] && !keys[2]) || (last_keys[3] && !keys[3])) 
                begin
                    request_beep <= 1;
                    debounce_timer <= 500000;
                    
                    if (!keys[0]) leds[0] <= ~leds[0];
                    if (!keys[1]) leds[1] <= ~leds[1];
                    if (!keys[2]) leds[2] <= ~leds[2];
                    if (!keys[3]) leds[3] <= ~leds[3];
                end
            end
            last_keys <= keys;
        end
    end

    // --- 4. Beeper ---
    reg [2:0] beep_state = 0; 
    reg [24:0] beep_timer = 0;
    reg [15:0] tone_counter = 0;

    always @(posedge clk) begin
        case (beep_state)
            0: begin // IDLE
                beep <= 0;
                beep_timer <= 0;
                if (request_beep) beep_state <= 1;
            end
            1: begin // BEEP
                beep_timer <= beep_timer + 1;
                tone_counter <= tone_counter + 1;
                if (tone_counter > 12500) begin // 2kHz
                    tone_counter <= 0;
                    beep <= ~beep;
                end
                if (beep_timer > 5_000_000) begin // 100ms
                    beep_state <= 0; 
                    beep <= 0;
                end
            end
        endcase
    end

    // --- 5. Screen Multiplexing ---
    reg [1:0] scan_idx;
    reg [17:0] scan_timer;
    reg [3:0] digit_to_show;

    always @(posedge clk) begin
        scan_timer <= scan_timer + 1;
        if (scan_timer == 0) scan_idx <= scan_idx + 1;
    end

    always @(*) begin
        case (scan_idx)
            0: digit_to_show = digit0;
            1: digit_to_show = digit1;
            2: digit_to_show = digit2;
            3: digit_to_show = digit3;
        endcase
        
        case (scan_idx)
            0: seg_sel = 4'b1110; 
            1: seg_sel = 4'b1101; 
            2: seg_sel = 4'b1011; 
            3: seg_sel = 4'b0111; 
        endcase

        case (digit_to_show)
            0: seg_data = ZERO; 1: seg_data = ONE; 2: seg_data = TWO;
            3: seg_data = THREE; 4: seg_data = FOUR; 5: seg_data = FIVE;
            6: seg_data = SIX; 7: seg_data = SEVEN; 8: seg_data = EIGHT;
            9: seg_data = NINE; default: seg_data = OFF;
        endcase
    end
endmodule