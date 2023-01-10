module div(
    input clk,
    output  oclk
);
reg [25:0] cnt;
reg  clkk;
parameter N ;
assign oclk=clkk;
always @(posedge clk)
begin
  if (cnt==N)
    begin
        cnt<=0;
		  clkk<=~clkk;
    end
  else
    cnt<=cnt+25'd1;
end
endmodule

module bt(key,key_pulse,clk,rst);//按键消抖
	parameter n = 4;//要消除的按键的数量

	input [n-1:0] key;//输入的按键
	output [n-1:0] key_pulse; //按键动作产生的脉冲
	input clk;
	input rst;

	reg [18:0] cnt=0;//产生延时所用的计数器
	wire [n-1:0] key_edge;//检测到按键由高到低变化是产生一个高脉冲
	reg [n-1:0] key_gt;
	reg [n-1:0] key_gt_pre;
	reg [n-1:0] key_sec; 
	reg [n-1:0] key_sec_pre; //延时后检测电平寄存器变量
//产生20ms延时，当检测到key_edge有效是计数器清零开始计数
	always @(posedge clk or negedge rst) begin
		if(!rst) begin
			key_gt<={n{1'b1}};
			key_gt_pre<={n{1'b1}};
            key_sec_pre <= {n{1'b1}};
		end
		else begin
			key_gt<=key;
			key_gt_pre<=key_gt;
            key_sec_pre<=key_sec;
		end
	end
//延时后检测key，如果按键状态变低产生一个时钟的高脉冲。如果按键状态是高的话说明按键无效
	assign key_edge = (~key_gt) & key_gt_pre;

	always @(posedge clk or negedge rst) begin
		if(!rst)
			cnt <= 0;
		else if(key_edge)
			cnt <= 0;
		else
			cnt <= cnt + 1;
	end

	always @(posedge clk or negedge rst) begin
		if(!rst)
			key_sec <= {n{1'b1}};
		else if(cnt==19'd500000                                                                 )
			key_sec<=key;
	end

	assign key_pulse = (~key_sec) & key_sec_pre;
	
endmodule
