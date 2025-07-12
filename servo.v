module servo #(
    parameter CLK_FREQ = 25_000_000, // 25 MHz
    parameter PERIOD = 500_000 // 50 Hz (1/50s = 20ms, 25MHz / 50Hz = 500000 cycles)
) (
    input wire clk,
    input wire rst_n,
    output wire servo_out
);

//insira seu código aqui

localparam integer MIN_PULSE_CYCLES = PERIOD * 5 / 100; // 1ms (25MHz -> 25000 ciclos)
localparam integer MAX_PULSE_CYCLES = PERIOD * 10 / 100;  // 2ms (25MHz -> 50000 ciclos)
localparam integer WAIT             = CLK_FREQ * 5;

reg [31:0]  duty_cycle  = MIN_PULSE_CYCLES;
reg [31:0]  delay       = 0;
reg         dir         = 0;

always @( posedge clk or negedge rst_n ) 
begin
    if( !rst_n ) 
    begin
        duty_cycle  <= MIN_PULSE_CYCLES;
        delay       <= 0;
        dir         <= 0;
    end 
    else 
    begin
        if( delay >= WAIT )
        begin
            delay <= 0;
            
            if( dir == 0 )
            begin
                duty_cycle <= MAX_PULSE_CYCLES;
            end
            else
            begin
                duty_cycle <= MIN_PULSE_CYCLES;
            end
            
            dir <= -dir;
        end
        else
        begin
            delay <= delay + 1;
        end
    end
end

PWM pwm0    (
            .clk( clk ),
            .rst_n( rst_n ),
            .duty_cycle( duty_cycle ),
            .period( PERIOD ),
            .pwm_out( servo_out )
            );

endmodule