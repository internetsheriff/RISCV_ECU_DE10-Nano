//-----------------------------------------------------
// Design Name : adder_128
// File Name   : adder_128.sv
// Function    : somador com reset
// Coder      : Wellington Melo
//-----------------------------------------------------
module adder_128
( input  logic [8:0] c_01, c_02, c_03, c_04, c_05, c_06, c_07, c_08,
  input  logic [8:0] c_09, c_10, c_11, c_12, c_13, c_14, c_15, c_16,
  input  logic [8:0] c_17, c_18, c_19, c_20, c_21, c_22, c_23, c_24,
  input  logic [8:0] c_25, c_26, c_27, c_28, c_29, c_30, c_31, c_32,
  input  logic [8:0] c_33, c_34, c_35, c_36, c_37, c_38, c_39, c_40,
  input  logic [8:0] c_41, c_42, c_43, c_44, c_45, c_46, c_47, c_48,
  input  logic [8:0] c_49, c_50, c_51, c_52, c_53, c_54, c_55, c_56,
  input  logic [8:0] c_57, c_58, c_59, c_60, c_61, c_62, c_63, c_64,
  input  logic [8:0] c_65, c_66, c_67, c_68, c_69, c_70, c_71, c_72,
  input  logic [8:0] c_73, c_74, c_75, c_76, c_77, c_78, c_79, c_80,
  input  logic [8:0] c_81, c_82, c_83, c_84, c_85, c_86, c_87, c_88,
  input  logic [8:0] c_89, c_90, c_91, c_92, c_93, c_94, c_95, c_96,
  input  logic [8:0] c_97, c_98, c_99, c_100c, c_101c, c_102c, c_103c, c_104c,
  input  logic [8:0] c_105c, c_106c, c_107c, c_108c, c_109c, c_110c, c_111c, c_112c,
  input  logic [8:0] c_113c, c_114c, c_115c, c_116c, c_117c, c_118c, c_119c, c_120c,
  input  logic [8:0] c_121c, c_122c, c_123c, c_124c, c_125c, c_126c, c_127c, c_128c,
  output logic [14:0] sum,
  output logic co
);

//


//------------start code -----------

  always_comb begin
    	
	
  	{co, sum} =  c_01 + c_02 + c_03 + c_04 + c_05 + c_06 + c_07 + c_08 +
					 c_09 + c_10 + c_11 + c_12 + c_13 + c_14 + c_15 + c_16 +
					 c_17 + c_18 + c_19 + c_20 + c_21 + c_22 + c_23 + c_24 +
					 c_25 + c_26 + c_27 + c_28 + c_29 + c_30 + c_31 + c_32 +
					 c_33 + c_34 + c_35 + c_36 + c_37 + c_38 + c_39 + c_40 +
					 c_41 + c_42 + c_43 + c_44 + c_45 + c_46 + c_47 + c_48 +
					 c_49 + c_50 + c_51 + c_52 + c_53 + c_54 + c_55 + c_56 +
					 c_57 + c_58 + c_59 + c_60 + c_61 + c_62 + c_63 + c_64 +
					 c_65 + c_66 + c_67 + c_68 + c_69 + c_70 + c_71 + c_72 +
					 c_73 + c_74 + c_75 + c_76 + c_77 + c_78 + c_79 + c_80 +
					 c_81 + c_82 + c_83 + c_84 + c_85 + c_86 + c_87 + c_88 +
					 c_89 + c_90 + c_91 + c_92 + c_93 + c_94 + c_95 + c_96 +
					 c_97 + c_98 + c_99 + c_100c + c_101c + c_102c + c_103c + c_104c +
					 c_105c + c_106c + c_107c + c_108c + c_109c + c_110c + c_111c + c_112c +
					 c_113c + c_114c + c_115c + c_116c + c_117c + c_118c + c_119c + c_120c +
					 c_121c + c_122c + c_123c + c_124c + c_125c + c_126c + c_127c + c_128c;
	end
 
endmodule: adder_128
