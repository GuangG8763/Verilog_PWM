`timescale 1ns / 1ns
    
module Top_module_TB;

reg CLK = 0;
reg rest = 1;
wire W_LED1, W_LED2;

always #5 CLK = ~CLK;

initial
begin
	rest = 1'b0;
	#200
	rest = 1'b1;
end

Top_module U1
(
	.I_clk	(	CLK		),  
	.I_rst_n(	rest	),
	.O_led1	(	W_LED1		), 
	.O_led2 (	W_LED2		) 
);
    
endmodule