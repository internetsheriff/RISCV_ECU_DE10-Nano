// Copyright (C) 2020  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and any partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel FPGA IP License Agreement, or other applicable license
// agreement, including, without limitation, that your use is for
// the sole purpose of programming logic devices manufactured by
// Intel and sold by Intel or its authorized distributors.  Please
// refer to the applicable agreement for further details, at
// https://fpgasoftware.intel.com/eula.

// PROGRAM		"Quartus Prime"
// VERSION		"Version 20.1.1 Build 720 11/11/2020 SJ Lite Edition"
// CREATED		"Tue Jan 14 14:59:15 2025"

module tdc_linux128(
	reset,
	PulseA,
	PulseB,
	end_soma
);


input wire	reset;
input wire	PulseA;
input wire	PulseB;
output wire	[14:0] end_soma;

wire	[7:0] c0o;
wire	[7:0] c100o;
wire	[7:0] c101o;
wire	[7:0] c102o;
wire	[7:0] c103o;
wire	[7:0] c104o;
wire	[7:0] c105o;
wire	[7:0] c106o;
wire	[7:0] c107o;
wire	[7:0] c108o;
wire	[7:0] c109o;
wire	[7:0] c10o;
wire	[7:0] c110o;
wire	[7:0] c111o;
wire	[7:0] c112o;
wire	[7:0] c113o;
wire	[7:0] c114o;
wire	[7:0] c115o;
wire	[7:0] c116o;
wire	[7:0] c117o;
wire	[7:0] c118o;
wire	[7:0] c119o;
wire	[7:0] c11o;
wire	[7:0] c120o;
wire	[7:0] c121o;
wire	[7:0] c122o;
wire	[7:0] c123o;
wire	[7:0] c124o;
wire	[7:0] c125o;
wire	[7:0] c126o;
wire	[7:0] c127o;
wire	[7:0] c12o;
wire	[7:0] c13o;
wire	[7:0] c14o;
wire	[7:0] c15o;
wire	[7:0] c16o;
wire	[7:0] c17o;
wire	[7:0] c18o;
wire	[7:0] c19o;
wire	[7:0] c1o;
wire	[7:0] c20o;
wire	[7:0] c21o;
wire	[7:0] c22o;
wire	[7:0] c23o;
wire	[7:0] c24o;
wire	[7:0] c25o;
wire	[7:0] c26o;
wire	[7:0] c27o;
wire	[7:0] c28o;
wire	[7:0] c29o;
wire	[7:0] c2o;
wire	[7:0] c30o;
wire	[7:0] c31o;
wire	[7:0] c32o;
wire	[7:0] c33o;
wire	[7:0] c34o;
wire	[7:0] c35o;
wire	[7:0] c36o;
wire	[7:0] c37o;
wire	[7:0] c38o;
wire	[7:0] c39o;
wire	[7:0] c3o;
wire	[7:0] c40o;
wire	[7:0] c41o;
wire	[7:0] c42o;
wire	[7:0] c43o;
wire	[7:0] c44o;
wire	[7:0] c45o;
wire	[7:0] c46o;
wire	[7:0] c47o;
wire	[7:0] c48o;
wire	[7:0] c49o;
wire	[7:0] c4o;
wire	[7:0] c50o;
wire	[7:0] c51o;
wire	[7:0] c52o;
wire	[7:0] c53o;
wire	[7:0] c54o;
wire	[7:0] c55o;
wire	[7:0] c56o;
wire	[7:0] c57o;
wire	[7:0] c58o;
wire	[7:0] c59o;
wire	[7:0] c5o;
wire	[7:0] c60o;
wire	[7:0] c61o;
wire	[7:0] c62o;
wire	[7:0] c63o;
wire	[7:0] c64o;
wire	[7:0] c65o;
wire	[7:0] c66o;
wire	[7:0] c67o;
wire	[7:0] c68o;
wire	[7:0] c69o;
wire	[7:0] c6o;
wire	[7:0] c70o;
wire	[7:0] c71o;
wire	[7:0] c72o;
wire	[7:0] c73o;
wire	[7:0] c74o;
wire	[7:0] c75o;
wire	[7:0] c76o;
wire	[7:0] c77o;
wire	[7:0] c78o;
wire	[7:0] c79o;
wire	[7:0] c7o;
wire	[7:0] c80o;
wire	[7:0] c81o;
wire	[7:0] c82o;
wire	[7:0] c83o;
wire	[7:0] c84o;
wire	[7:0] c85o;
wire	[7:0] c86o;
wire	[7:0] c87o;
wire	[7:0] c88o;
wire	[7:0] c89o;
wire	[7:0] c8o;
wire	[7:0] c90o;
wire	[7:0] c91o;
wire	[7:0] c92o;
wire	[7:0] c93o;
wire	[7:0] c94o;
wire	[7:0] c95o;
wire	[7:0] c96o;
wire	[7:0] c97o;
wire	[7:0] c98o;
wire	[7:0] c99o;
wire	[7:0] c9o;
wire	clk;
wire	clk0;
wire	clk1;
wire	clk10;
wire	clk100c;
wire	clk101c;
wire	clk102c;
wire	clk103c;
wire	clk104c;
wire	clk105c;
wire	clk106c;
wire	clk107c;
wire	clk108c;
wire	clk109c;
wire	clk11;
wire	clk110c;
wire	clk111c;
wire	clk112c;
wire	clk113c;
wire	clk114c;
wire	clk115c;
wire	clk116c;
wire	clk117c;
wire	clk118c;
wire	clk119c;
wire	clk12;
wire	clk120c;
wire	clk121c;
wire	clk122c;
wire	clk123c;
wire	clk124c;
wire	clk125c;
wire	clk126c;
wire	clk127c;
wire	clk13;
wire	clk14;
wire	clk15;
wire	clk16;
wire	clk17;
wire	clk18;
wire	clk19;
wire	clk2;
wire	clk20;
wire	clk21;
wire	clk22;
wire	clk23;
wire	clk24;
wire	clk25;
wire	clk26;
wire	clk27;
wire	clk28;
wire	clk29;
wire	clk3;
wire	clk30;
wire	clk31;
wire	clk32;
wire	clk33;
wire	clk34;
wire	clk35;
wire	clk36;
wire	clk37;
wire	clk38;
wire	clk39;
wire	clk4;
wire	clk40;
wire	clk41;
wire	clk42;
wire	clk43;
wire	clk44;
wire	clk45;
wire	clk46;
wire	clk47;
wire	clk48;
wire	clk49;
wire	clk5;
wire	clk50;
wire	clk51;
wire	clk52;
wire	clk53;
wire	clk54;
wire	clk55;
wire	clk56;
wire	clk57;
wire	clk58;
wire	clk59;
wire	clk6;
wire	clk60;
wire	clk61;
wire	clk62;
wire	clk63;
wire	clk64;
wire	clk65;
wire	clk66;
wire	clk67;
wire	clk68;
wire	clk69;
wire	clk7;
wire	clk70;
wire	clk71;
wire	clk72;
wire	clk73;
wire	clk74;
wire	clk75;
wire	clk76;
wire	clk77;
wire	clk78;
wire	clk79;
wire	clk8;
wire	clk80;
wire	clk81;
wire	clk82;
wire	clk83;
wire	clk84;
wire	clk85;
wire	clk86;
wire	clk87;
wire	clk88;
wire	clk89;
wire	clk9;
wire	clk90;
wire	clk91;
wire	clk92;
wire	clk93;
wire	clk94;
wire	clk95;
wire	clk96;
wire	clk97;
wire	clk98;
wire	clk99;
wire	delta_interval;
wire	[14:0] inst_soma;
wire	rst_sync;
wire	sample_ena;
wire	SYNTHESIZED_WIRE_0;

assign	SYNTHESIZED_WIRE_0 = 1;




delta_medida	b2v_inst(
	.pulse_A(PulseA),
	.pulse_B(PulseB),
	.pulse_out(delta_interval));



osc3dlatch	b2v_inst2(
	.reset(reset),
	.enable(SYNTHESIZED_WIRE_0),
	.clk0out(clk));


mphase128	b2v_inst3(
	.clk0(clk),
	.clk0out(clk0),
	.clk1out(clk1),
	.clk2out(clk2),
	.clk3out(clk3),
	.clk4out(clk4),
	.clk5out(clk5),
	.clk6out(clk6),
	.clk7out(clk7),
	.clk8out(clk8),
	.clk9out(clk9),
	.clk10out(clk10),
	.clk11out(clk11),
	.clk12out(clk12),
	.clk13out(clk13),
	.clk14out(clk14),
	.clk15out(clk15),
	.clk16out(clk16),
	.clk17out(clk17),
	.clk18out(clk18),
	.clk19out(clk19),
	.clk20out(clk20),
	.clk21out(clk21),
	.clk22out(clk22),
	.clk23out(clk23),
	.clk24out(clk24),
	.clk25out(clk25),
	.clk26out(clk26),
	.clk27out(clk27),
	.clk28out(clk28),
	.clk29out(clk29),
	.clk30out(clk30),
	.clk31out(clk31),
	.clk32out(clk32),
	.clk33out(clk33),
	.clk34out(clk34),
	.clk35out(clk35),
	.clk36out(clk36),
	.clk37out(clk37),
	.clk38out(clk38),
	.clk39out(clk39),
	.clk40out(clk40),
	.clk41out(clk41),
	.clk42out(clk42),
	.clk43out(clk43),
	.clk44out(clk44),
	.clk45out(clk45),
	.clk46out(clk46),
	.clk47out(clk47),
	.clk48out(clk48),
	.clk49out(clk49),
	.clk50out(clk50),
	.clk51out(clk51),
	.clk52out(clk52),
	.clk53out(clk53),
	.clk54out(clk54),
	.clk55out(clk55),
	.clk56out(clk56),
	.clk57out(clk57),
	.clk58out(clk58),
	.clk59out(clk59),
	.clk60out(clk60),
	.clk61out(clk61),
	.clk62out(clk62),
	.clk63out(clk63),
	.clk64out(clk64),
	.clk65out(clk65),
	.clk66out(clk66),
	.clk67out(clk67),
	.clk68out(clk68),
	.clk69out(clk69),
	.clk70out(clk70),
	.clk71out(clk71),
	.clk72out(clk72),
	.clk73out(clk73),
	.clk74out(clk74),
	.clk75out(clk75),
	.clk76out(clk76),
	.clk77out(clk77),
	.clk78out(clk78),
	.clk79out(clk79),
	.clk80out(clk80),
	.clk81out(clk81),
	.clk82out(clk82),
	.clk83out(clk83),
	.clk84out(clk84),
	.clk85out(clk85),
	.clk86out(clk86),
	.clk87out(clk87),
	.clk88out(clk88),
	.clk89out(clk89),
	.clk90out(clk90),
	.clk91out(clk91),
	.clk92out(clk92),
	.clk93out(clk93),
	.clk94out(clk94),
	.clk95out(clk95),
	.clk96out(clk96),
	.clk97out(clk97),
	.clk98out(clk98),
	.clk99out(clk99),
	.clk100out(clk100c),
	.clk101out(clk101c),
	.clk102out(clk102c),
	.clk103out(clk103c),
	.clk104out(clk104c),
	.clk105out(clk105c),
	.clk106out(clk106c),
	.clk107out(clk107c),
	.clk108out(clk108c),
	.clk109out(clk109c),
	.clk110out(clk110c),
	.clk111out(clk111c),
	.clk112out(clk112c),
	.clk113out(clk113c),
	.clk114out(clk114c),
	.clk115out(clk115c),
	.clk116out(clk116c),
	.clk117out(clk117c),
	.clk118out(clk118c),
	.clk119out(clk119c),
	.clk120out(clk120c),
	.clk121out(clk121c),
	.clk122out(clk122c),
	.clk123out(clk123c),
	.clk124out(clk124c),
	.clk125out(clk125c),
	.clk126out(clk126c),
	.clk127out(clk127c));


counter128	b2v_inst4(
	.enable(delta_interval),
	.reset(rst_sync),
	.clk0(clk0),
	.clk1(clk1),
	.clk2(clk2),
	.clk3(clk3),
	.clk4(clk4),
	.clk5(clk5),
	.clk6(clk6),
	.clk7(clk7),
	.clk8(clk8),
	.clk9(clk9),
	.clk10(clk10),
	.clk11(clk11),
	.clk12(clk12),
	.clk13(clk13),
	.clk14(clk14),
	.clk15(clk15),
	.clk16(clk16),
	.clk17(clk17),
	.clk18(clk18),
	.clk19(clk19),
	.clk20(clk20),
	.clk21(clk21),
	.clk22(clk22),
	.clk23(clk23),
	.clk24(clk24),
	.clk25(clk25),
	.clk26(clk26),
	.clk27(clk27),
	.clk28(clk28),
	.clk29(clk29),
	.clk30(clk30),
	.clk31(clk31),
	.clk32(clk32),
	.clk33(clk33),
	.clk34(clk34),
	.clk35(clk35),
	.clk36(clk36),
	.clk37(clk37),
	.clk38(clk38),
	.clk39(clk39),
	.clk40(clk40),
	.clk41(clk41),
	.clk42(clk42),
	.clk43(clk43),
	.clk44(clk44),
	.clk45(clk45),
	.clk46(clk46),
	.clk47(clk47),
	.clk48(clk48),
	.clk49(clk49),
	.clk50(clk50),
	.clk51(clk51),
	.clk52(clk52),
	.clk53(clk53),
	.clk54(clk54),
	.clk55(clk55),
	.clk56(clk56),
	.clk57(clk57),
	.clk58(clk58),
	.clk59(clk59),
	.clk60(clk60),
	.clk61(clk61),
	.clk62(clk62),
	.clk63(clk63),
	.clk64(clk64),
	.clk65(clk65),
	.clk66(clk66),
	.clk67(clk67),
	.clk68(clk68),
	.clk69(clk69),
	.clk70(clk70),
	.clk71(clk71),
	.clk72(clk72),
	.clk73(clk73),
	.clk74(clk74),
	.clk75(clk75),
	.clk76(clk76),
	.clk77(clk77),
	.clk78(clk78),
	.clk79(clk79),
	.clk80(clk80),
	.clk81(clk81),
	.clk82(clk82),
	.clk83(clk83),
	.clk84(clk84),
	.clk85(clk85),
	.clk86(clk86),
	.clk87(clk87),
	.clk88(clk88),
	.clk89(clk89),
	.clk90(clk90),
	.clk91(clk91),
	.clk92(clk92),
	.clk93(clk93),
	.clk94(clk94),
	.clk95(clk95),
	.clk96(clk96),
	.clk97(clk97),
	.clk98(clk98),
	.clk99(clk99),
	.clk100c(clk100c),
	.clk101c(clk101c),
	.clk102c(clk102c),
	.clk103c(clk103c),
	.clk104c(clk104c),
	.clk105c(clk105c),
	.clk106c(clk106c),
	.clk107c(clk107c),
	.clk108c(clk108c),
	.clk109c(clk109c),
	.clk110c(clk110c),
	.clk111c(clk111c),
	.clk112c(clk112c),
	.clk113c(clk113c),
	.clk114c(clk114c),
	.clk115c(clk115c),
	.clk116c(clk116c),
	.clk117c(clk117c),
	.clk118c(clk118c),
	.clk119c(clk119c),
	.clk120c(clk120c),
	.clk121c(clk121c),
	.clk122c(clk122c),
	.clk123c(clk123c),
	.clk124c(clk124c),
	.clk125c(clk125c),
	.clk126c(clk126c),
	.clk127c(clk127c),
	.s0o(c0o),
	.s100o(c100o),
	.s101o(c101o),
	.s102o(c102o),
	.s103o(c103o),
	.s104o(c104o),
	.s105o(c105o),
	.s106o(c106o),
	.s107o(c107o),
	.s108o(c108o),
	.s109o(c109o),
	.s10o(c10o),
	.s110o(c110o),
	.s111o(c111o),
	.s112o(c112o),
	.s113o(c113o),
	.s114o(c114o),
	.s115o(c115o),
	.s116o(c116o),
	.s117o(c117o),
	.s118o(c118o),
	.s119o(c119o),
	.s11o(c11o),
	.s120o(c120o),
	.s121o(c121o),
	.s122o(c122o),
	.s123o(c123o),
	.s124o(c124o),
	.s125o(c125o),
	.s126o(c126o),
	.s127o(c127o),
	.s12o(c12o),
	.s13o(c13o),
	.s14o(c14o),
	.s15o(c15o),
	.s16o(c16o),
	.s17o(c17o),
	.s18o(c18o),
	.s19o(c19o),
	.s1o(c1o),
	.s20o(c20o),
	.s21o(c21o),
	.s22o(c22o),
	.s23o(c23o),
	.s24o(c24o),
	.s25o(c25o),
	.s26o(c26o),
	.s27o(c27o),
	.s28o(c28o),
	.s29o(c29o),
	.s2o(c2o),
	.s30o(c30o),
	.s31o(c31o),
	.s32o(c32o),
	.s33o(c33o),
	.s34o(c34o),
	.s35o(c35o),
	.s36o(c36o),
	.s37o(c37o),
	.s38o(c38o),
	.s39o(c39o),
	.s3o(c3o),
	.s40o(c40o),
	.s41o(c41o),
	.s42o(c42o),
	.s43o(c43o),
	.s44o(c44o),
	.s45o(c45o),
	.s46o(c46o),
	.s47o(c47o),
	.s48o(c48o),
	.s49o(c49o),
	.s4o(c4o),
	.s50o(c50o),
	.s51o(c51o),
	.s52o(c52o),
	.s53o(c53o),
	.s54o(c54o),
	.s55o(c55o),
	.s56o(c56o),
	.s57o(c57o),
	.s58o(c58o),
	.s59o(c59o),
	.s5o(c5o),
	.s60o(c60o),
	.s61o(c61o),
	.s62o(c62o),
	.s63o(c63o),
	.s64o(c64o),
	.s65o(c65o),
	.s66o(c66o),
	.s67o(c67o),
	.s68o(c68o),
	.s69o(c69o),
	.s6o(c6o),
	.s70o(c70o),
	.s71o(c71o),
	.s72o(c72o),
	.s73o(c73o),
	.s74o(c74o),
	.s75o(c75o),
	.s76o(c76o),
	.s77o(c77o),
	.s78o(c78o),
	.s79o(c79o),
	.s7o(c7o),
	.s80o(c80o),
	.s81o(c81o),
	.s82o(c82o),
	.s83o(c83o),
	.s84o(c84o),
	.s85o(c85o),
	.s86o(c86o),
	.s87o(c87o),
	.s88o(c88o),
	.s89o(c89o),
	.s8o(c8o),
	.s90o(c90o),
	.s91o(c91o),
	.s92o(c92o),
	.s93o(c93o),
	.s94o(c94o),
	.s95o(c95o),
	.s96o(c96o),
	.s97o(c97o),
	.s98o(c98o),
	.s99o(c99o),
	.s9o(c9o));


adder_128	b2v_inst5(
	.c_01(c0o),
	.c_02(c1o),
	.c_03(c2o),
	.c_04(c3o),
	.c_05(c4o),
	.c_06(c5o),
	.c_07(c6o),
	.c_08(c7o),
	.c_09(c8o),
	.c_10(c9o),
	.c_100c(c99o),
	.c_101c(c100o),
	.c_102c(c101o),
	.c_103c(c102o),
	.c_104c(c103o),
	.c_105c(c104o),
	.c_106c(c105o),
	.c_107c(c106o),
	.c_108c(c107o),
	.c_109c(c108o),
	.c_11(c10o),
	.c_110c(c109o),
	.c_111c(c110o),
	.c_112c(c111o),
	.c_113c(c112o),
	.c_114c(c113o),
	.c_115c(c114o),
	.c_116c(c115o),
	.c_117c(c116o),
	.c_118c(c117o),
	.c_119c(c118o),
	.c_12(c11o),
	.c_120c(c119o),
	.c_121c(c120o),
	.c_122c(c121o),
	.c_123c(c122o),
	.c_124c(c123o),
	.c_125c(c124o),
	.c_126c(c125o),
	.c_127c(c126o),
	.c_128c(c127o),
	.c_13(c12o),
	.c_14(c13o),
	.c_15(c14o),
	.c_16(c15o),
	.c_17(c16o),
	.c_18(c17o),
	.c_19(c18o),
	.c_20(c19o),
	.c_21(c20o),
	.c_22(c21o),
	.c_23(c22o),
	.c_24(c23o),
	.c_25(c24o),
	.c_26(c25o),
	.c_27(c26o),
	.c_28(c27o),
	.c_29(c28o),
	.c_30(c29o),
	.c_31(c30o),
	.c_32(c31o),
	.c_33(c32o),
	.c_34(c33o),
	.c_35(c34o),
	.c_36(c35o),
	.c_37(c36o),
	.c_38(c37o),
	.c_39(c38o),
	.c_40(c39o),
	.c_41(c40o),
	.c_42(c41o),
	.c_43(c42o),
	.c_44(c43o),
	.c_45(c44o),
	.c_46(c45o),
	.c_47(c46o),
	.c_48(c47o),
	.c_49(c48o),
	.c_50(c49o),
	.c_51(c50o),
	.c_52(c51o),
	.c_53(c52o),
	.c_54(c53o),
	.c_55(c54o),
	.c_56(c55o),
	.c_57(c56o),
	.c_58(c57o),
	.c_59(c58o),
	.c_60(c59o),
	.c_61(c60o),
	.c_62(c61o),
	.c_63(c62o),
	.c_64(c63o),
	.c_65(c64o),
	.c_66(c65o),
	.c_67(c66o),
	.c_68(c67o),
	.c_69(c68o),
	.c_70(c69o),
	.c_71(c70o),
	.c_72(c71o),
	.c_73(c72o),
	.c_74(c73o),
	.c_75(c74o),
	.c_76(c75o),
	.c_77(c76o),
	.c_78(c77o),
	.c_79(c78o),
	.c_80(c79o),
	.c_81(c80o),
	.c_82(c81o),
	.c_83(c82o),
	.c_84(c83o),
	.c_85(c84o),
	.c_86(c85o),
	.c_87(c86o),
	.c_88(c87o),
	.c_89(c88o),
	.c_90(c89o),
	.c_91(c90o),
	.c_92(c91o),
	.c_93(c92o),
	.c_94(c93o),
	.c_95(c94o),
	.c_96(c95o),
	.c_97(c96o),
	.c_98(c97o),
	.c_99(c98o),
	
	.sum(inst_soma));


dlatch_r_e_vector	b2v_inst6(
	.en(sample_ena),
	.reset(reset),
	.clk(clk),
	.data(inst_soma),
	.rst_sync(rst_sync),
	.q(end_soma));


single_pulse	b2v_inst7(
	.data(PulseB),
	.clk(clk),
	.reset(reset),
	
	
	.s_pulse(sample_ena));


endmodule
