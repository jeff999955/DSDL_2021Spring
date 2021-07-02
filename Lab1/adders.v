`ifndef ADDERS
`define ADDERS
`include "gates.v"

// half adder, gate level modeling
module HA(output C, S, input A, B);
	XOR g0(S, A, B);
	AND g1(C, A, B);
endmodule

// full adder, gate level modeling
module FA(output CO, S, input A, B, CI);
	wire c0, s0, c1, s1;
	HA ha0(c0, s0, A, B);
	HA ha1(c1, s1, s0, CI);
	assign S = s1;
	OR or0(CO, c0, c1);
endmodule

// adder without delay, register-transfer level modeling
module adder_rtl(
	output C3,       // carry output
	output[2:0] S,   // sum
	input[2:0] A, B, // operands
	input C0         // carry input
	);
	assign {C3, S} = A+B+C0;
endmodule

//  ripple-carry adder, gate level modeling
//  Do not modify the input/output of module
module rca_gl(
	output C3,       // carry output
	output[2:0] S,   // sum
	input[2:0] A, B, // operands
	input C0         // carry input
	);
	// TODO:: Implement gate-level RCA
	wire C1, C2;
	FA fa0(C1, S[0], A[0], B[0], C0);
	FA fa1(C2, S[1], A[1], B[1], C1);
	FA fa2(C3, S[2], A[2], B[2], C2);
endmodule

// carry-lookahead adder, gate level modeling
// Do not modify the input/output of module
module cla_gl(
	output C3,       // carry output
	output[2:0] S,   // sum
	input[2:0] A, B, // operands
	input C0         // carry input
	);

	// TODO:: Implement gate-level CLA
	wire [2:0] g, p;
	wire c1, c2;
	// my naming is bad, sorry~~

	// c1 = g0 | (p0 & c0)
	OR xb0(p[0], A[0], B[0]);
	AND ab0(g[0], A[0], B[0]);
	AND pc_0(cp0, p[0], C0);
	OR c_1(c1, g[0], cp0); 
	FA fa0(tmpc0, S[0], A[0], B[0], C0);

	// c2 = g1 | (g0 & p1) | (c0 & p0 & p1)
	OR xb1(p[1], A[1], B[1]);
	AND ab1(g[1], A[1], B[1]);
	AND gp_1(gp1, g[0], p[1]);
	AND4 cpp_1(cpp1, 1, C0, p[0], p[1]);
	OR4 c_2(c2, g[1], gp1, cpp1, 0); 
	FA fa1(tmpc1, S[1], A[1], B[1], c1);

	// c3 = g2 | (g1 & p2) | (g0 & p1 & p2) | (c0 & p0 & p1 & p2)
	OR xb2(p[2], A[2], B[2]);
	AND ab2(g[2], A[2], B[2]);
	AND gp_2(gp2, g[1], p[2]);
	AND4 gpp_2(gpp2, g[0], p[1], p[2], 1);
	AND4 cppp_2(cppp2, C0, p[0], p[1], p[2]);
	OR4 c_3(C3, g[2], gp2, gpp2, cppp2);
	FA fa2(tmpc2, S[2], A[2], B[2], c2);
endmodule

`endif
