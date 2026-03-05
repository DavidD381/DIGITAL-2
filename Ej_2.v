module ej_2 (
    input clk,
    input [3:0] btn,
    input [3:0] sw,
    output reg [2:0] rgb,
    output reg [3:0] led
);

reg [3:0] num_1;
reg [3:0] num_2;
reg [4:0] result;

integer counter = 0;
integer s = 125000000;

reg [4:0] state;

localparam IDLE = 4'b0000;
localparam READ_N1 = 4'b0001;
localparam READ_N2 = 4'b0010;
localparam SELECT = 4'b0011;
localparam ADD = 4'b0100;
localparam AND_OP = 4'b0101;
localparam OR_OP = 4'b0110;
localparam NAND_OP = 4'b0111;
localparam NOR_OP = 4'b1000;
localparam XOR_OP = 4'b1001;
localparam SUB = 4'b1010;

always @(posedge clk) begin
   
    if (btn[0]) begin
        counter <= 0;
        num_1 <= 0;
        num_2 <= 0;
        led <= 0;
        result <= 0;
        state <= IDLE;
    end
    else if (counter > (10*s)) begin
        counter <= s;
    end
    else begin
        case (state)
            IDLE: begin
                rgb <= 3'b001; //Rojo
                if (btn[3] && (counter >= s) ) begin
                    state <= READ_N1;
                    counter <= 0;
                end
                else begin
                    counter <= counter + 1;
                    state <= IDLE;
                end
            end

            READ_N1: begin
                rgb <= 3'b011; //Amarillo
                led <= sw;
                if (btn[3] && (counter >= s) ) begin
                    num_1 <= sw;
                    state <= READ_N2;
                    counter <= 0;
                    led <= 0;
                end
                else begin
                    counter <= counter + 1;
                    state <= READ_N1;
                end
            end

            READ_N2: begin
                rgb <= 3'b010; //Verde
                led <= sw;
                if (btn[3] && (counter >= s) ) begin
                    num_2 <= sw;
                    state <= SELECT;
                    counter <= 0;
                    led <= 0;
                end
                else begin
                    counter <= counter + 1;
                    state <= READ_N2;
                end
            end

            SELECT: begin
                rgb <= 3'b111; //Blanco
                if (btn[1] && (counter >= s) ) begin
                    state <= ADD;
                    counter <= 0;
                end

                else if (btn[2] && (counter >= s) ) begin
                    state <= AND_OP;
                    counter <= 0;
                end    

                else if (btn[3] && (counter >= s) ) begin
                    state <= OR_OP;
                    counter <= 0;
                end

                else if (sw[0] && (counter >= s)) begin
                    state <= NAND_OP;
                    counter <= 0;
                end

                else if (sw[1] && (counter >= s)) begin
                    state <= NOR_OP;
                    counter <= 0;
                end

                else if (sw[1] && (counter >= s)) begin
                    state <= XOR_OP;
                    counter <= 0;
                end

                else begin
                    counter <= counter + 1;
                    state <= SELECT;
                end                
            end

            ADD: begin
                result <= num_1 + num_2;
                if (btn[1] && (counter >= s) ) begin
                    state <= SELECT;
                    counter <= 0;
                    led <= 0;
                end                
               
                else begin
                    counter <= counter + 1;
                    state <= ADD;
                    led <= result[3:0];
                    rgb <= result[4]; //Rojo
                end                  
            end

            AND_OP: begin
                rgb <= 0;
                result <= num_1 & num_2;
                if (btn[2] && (counter >= s) ) begin
                    state <= SELECT;
                    counter <= 0;
                    led <= 0;
                end                
               
                else begin
                    counter <= counter + 1;
                    state <= AND_OP;
                    led <= result;
                end      
            end

            OR_OP: begin
                rgb <= 0;
                result <= num_1 | num_2;
                if (btn[3] && (counter >= s) ) begin
                    state <= SELECT;
                    counter <= 0;
                    led <= 0;
                end                
               
                else begin
                    counter <= counter + 1;
                    state <= OR_OP;
                    led <= result;
                end                
            end

            NAND_OP: begin
                rgb <= 0;
                result <= ~(num_1 & num_2);
                if (~sw[0] && (counter >= s) ) begin
                    state <= SELECT;
                    counter <= 0;
                    led <= 0;
                end                
                else begin
                    counter <= counter + 1;
                    state <= NAND_OP;
                    led <= result;
                end                  
            end

            NOR_OP: begin
                rgb <= 0;
                result <= ~(num_1 | num_2);
                if (~sw[1] && (counter >= s) ) begin
                    state <= SELECT;
                    counter <= 0;
                    led <= 0;
                end                
                else begin
                    counter <= counter + 1;
                    state <= NOR_OP;
                    led <= result;
                end                  
            end

            XOR_OP: begin
                rgb <= 0;
                result <= num_1 ^ num_2;
                if (~sw[2] && (counter >= s) ) begin
                    state <= SELECT;
                    counter <= 0;
                    led <= 0;
                end                
                else begin
                    counter <= counter + 1;
                    state <= XOR_OP;
                    led <= result;
                end                  
            end

            SUB: begin
                result <= num_1 - num_2;  
                if (~sw[3] && (counter >= s)) begin
                    state  <= SELECT;
                    counter <= 0;
                    led    <= 0;
                end
                else begin
                    counter <= counter + 1;
                    state   <= SUB;
                    if (result[4]) begin
                        led <= (~result[3:0]) + 1; // Resultado NEGATIVO
                        rgb <= 3'b001; 
                    end
                    else begin
                        led <= result[3:0];
                        rgb <= 3'b010; 
                    end
                end
            end
        endcase
    end
end
endmodule
