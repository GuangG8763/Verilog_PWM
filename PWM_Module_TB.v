`timescale 1ns / 1ns
    
module PWM_Module_TB;

reg R_CLK = 0;
reg R_rest = 1;
reg R_inverse = 0; // 1:-1 0:+1
reg [7:0] R_cnt = 0;

wire W_PWM;

always #5 R_CLK = ~R_CLK;

initial
begin
	R_rest = 1'b0;
	#100
	R_rest = 1'b1;
	//repeat (1_000_000) @(posedge R_CLK)
	//R_cnt <= R_cnt + 1'b1;
end

always
begin
	repeat (1_000_000) @(posedge R_CLK) //10ms
	if(R_cnt >=100)
		R_inverse = 1; //-1
	else if(R_cnt == 0)
		R_inverse = 0; //+1
		
	if(R_inverse)
		R_cnt = R_cnt - 1'b1;
	else
		R_cnt = R_cnt + 1'b1;
end


PWM_Module PWM_Module_U1
(
	.I_clk			(R_CLK	),	// 100Mhz = 10ns
	.I_rst_n		(R_rest	),	// rst_n_in, active low
	.I_en			(1'b1	),	// enable active high
	.I_PWM_percen	(R_cnt	),	// 8bit input range 0-100
	.O_PWM			(W_PWM	)	// pin output
);	


endmodule
