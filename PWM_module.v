module PWM_Module
(
	input		I_clk	,  	// 100Mhz = 10ns
	input		I_rst_n	,	// rst_n_in, active low
	input		I_en	,	// enable active high
	input [7:0]	I_PWM	, 	// 8bit input range 0-100
	output		O_PWM		// pin output
);

parameter
	TIME_100HZ 		= 1_000_000		,
	TIME_100HZ_cnt	= 10_000		,
;

reg [31:0] R_cnt1 = 0;
reg R_out = 0;
reg [7:0] R_PWM_cnt = 0;
reg [3:0] R_state = 0;

assign O_PWM = R_out & I_en;	// 

always @(posedge I_clk or negedge I_rst_n)
begin
	if(!I_rst_n)
	begin
		R_cnt1 <= 0;
		R_state <= 0;
		R_PWM_cnt <= 0;
		R_out <= 0;
	end
	else
	begin
		case(R_state)
			4'd0:
			begin
				if(I_en == 1'b1)	//判斷EN
				begin
					R_state <= 4'd1;
					R_PWM_cnt <= (I_PWM <= 100) ? I_PWM : 8'd0; //防止overflow，載入%
				end
				else
					R_state <= 4'd0;
			end
		
			4'd1:
			begin
				if(R_PWM_cnt == 0)	//結束% cnt
				begin
					R_state <= 4'd0;
					R_cnt1 <= 0;
				end
				else
				begin
					if(R_cnt1 >= TIME_100HZ-1)
					begin
						
					end
					else
						R_cnt1 <= R_cnt1 + 1'b1;
				end
			end			
		
		
		
			default:
		endcase 
	end
end

				/*if(R_cnt1 >= TIME_100HZ-1)
				begin
					R_cnt1 <= 0;
					R_PWM_cnt -1 
				end
				else
					R_cnt1 <= R_cnt1 + 1'b1;*/

/*
		if(R_cnt1 >= TIME_100HZ-1)
		begin
		
		end
		else
		begin
			R_cnt1 <= R_cnt1 = 1'b1;
		
		end
*/


/*reg clk_div=0;
 
//wire led1,led2;
assign led1 = clk_div;
assign led2 = ~clk_div;
 
//clk_div = clk_in/CLK_DIV_PERIOD
reg[24:0] cnt=0;
always@(posedge clk_in or negedge rst_n_in) begin
    if(!rst_n_in) begin
        cnt<=0;
        clk_div<=0;
    end else begin
        if(cnt==(CLK_DIV_PERIOD-1)) cnt <= 0;
        else cnt <= cnt + 1'b1;
        if(cnt<(CLK_DIV_PERIOD>>1)) clk_div <= 0;
        else clk_div <= 1'b1;
    end
end
 */
endmodule