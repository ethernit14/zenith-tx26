module sign_extender (
	input [5:0] imm,
	output [15:0] extended
);

	assign extended = { {10{imm[5]}}, imm };
	
endmodule