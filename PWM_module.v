module PWM_Module
(
	input		I_clk			,  	// 100Mhz = 10ns
	input		I_rst_n			,	// rst_n_in, active low
	input		I_en			,	// enable active high
	input [7:0]	I_PWM_percen		, 	// 8bit input range 0-100
	output		O_PWM				// pin output
);

parameter
	TIME_100HZ 		= 1_000_000	/ 100 - 1;

reg [31:0] R_cycle_cnt = 0;
reg R_out = 0;
reg [7:0] R_percen_rise = 0, R_percen_down = 0;	// percen count
reg [3:0] R_state = 0;

assign O_PWM = R_out & I_en;	// 輸出綁定I_en

always @(posedge I_clk or negedge I_rst_n)
begin
	if(!I_rst_n)
	begin
		R_cycle_cnt <= 0;
		R_state <= 0;
		R_percen_rise <= 0;
		R_percen_down <= 0;
		R_out <= 0;
	end
	else
	begin
		case(R_state)
			4'd0:
			begin
				if(I_en == 1'b1)	//判斷EN
				begin
					R_state = 4'd1;
					R_percen_rise = (I_PWM_percen <= 100) ? I_PWM_percen : 8'd0; //防止overflow，載入%
					R_percen_down = 100 - R_percen_rise;
				end
				else
					R_state <= 4'd0;
			end
		
			4'd1:	// rise cycle
			begin
				// percen計數，R_cycle_cnt計數到指定數值R_percen_rise-1，
				// 直到R_percen_rise為0跳至下降時間
				if(R_percen_rise == 0)	
				begin
					R_state 	<= 4'd2;	//to down cycle
					R_out 		<= 1'b0;
				end
				else
				begin
					if(R_cycle_cnt >= TIME_100HZ)
					begin
						R_percen_rise <= R_percen_rise - 1;
						R_cycle_cnt <= 0;
					end
					else
					begin
						R_cycle_cnt <= R_cycle_cnt + 1'b1;
						R_out 		<= 1'b1;	//輸出1
					end
				end
			end			
		
			4'd2:	// down cycle
			begin
				// percen計數，R_cycle_cnt計數到指定數值R_percen_down-1，
				// 直到R_percen_down為0跳至判斷
				if(R_percen_down == 0)	
				begin
					R_state 	<= 4'd0;	//to down cycle
					R_out 		<= 1'b0;
				end
				else
				begin
					if(R_cycle_cnt >= TIME_100HZ)
					begin
						R_percen_down <= R_percen_down - 1;
						R_cycle_cnt	<= 0;
					end
					else
					begin
						R_cycle_cnt <= R_cycle_cnt + 1'b1;
						R_out 		<= 1'b0;	//輸出0
					end
				end
			end			
		
			default: R_state <= 4'd0;
		endcase 
	end
end

endmodule
