module MIPS_CPU (clock);
	input clock;
	reg[31:0] PC, Regs[0:31], IMemory[0:1023], DMemory[0:1023], IR, ALUOut;
	wire [4:0] rd, rs, rt;
	wire [31:0] Ain, Bin;
	wire [5:0] op;
	assign op = IR[31:26];
	assign rs = IR[25:21];
	assign rt = IR[20:16];
	assign rd = IR[15:11];
	assign Ain = Regs[rs];
	assign Bin = Regs[rt];
	initial begin
		PC = 0;
		IMemory[0] = 32'h02119020;
		IMemory[1] = 32'h02119822;
		IMemory[2] = 32'h0211A024;
		IMemory[3] = 32'h0211A825;
		Regs[16] = 32'h00000014;
		Regs[17] = 32'h0000005A;
	end

	always @ (posedge clock)
	begin
		IR <= IMemory[PC>>2];
		PC <= PC + 4;
		if (op == 6'b000000)
			case (IR[5:0])
				32 : ALUOut <= Ain + Bin;
				34 : ALUOut <= Ain - Bin;
				36 : ALUOut <= Ain & Bin;
				37 : ALUOut <= Ain | Bin;
			endcase
		Regs[rd] <= ALUOut;
	end
endmodule

module MIPS_TEST;
	Clock C(CLK);
	CPU mips(CLK);
endmodule
