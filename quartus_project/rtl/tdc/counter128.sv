//-----------------------------------------------------
 // Design Name : up_counter128
 // File Name   : up_counter128.sv
 // Function    : Up counter
 // Coder      : WRMelo
 //-----------------------------------------------------
 module counter128    (
 input  logic      enable  ,  																		// enable for counter
 input  logic      reset   ,  																		// reset Input
 input  logic      clk0, clk1, clk2, clk3, clk4, clk5, clk6, clk7,  						// clock Input
 input  logic      clk8, clk9, clk10, clk11, clk12, clk13, clk14, clk15,  				// clock Input
 input  logic      clk16, clk17, clk18, clk19, clk20, clk21, clk22, clk23,				// clock Input
 input  logic      clk24, clk25, clk26, clk27, clk28, clk29, clk30, clk31, 			// clock Input
 input  logic      clk32, clk33, clk34, clk35, clk36, clk37, clk38, clk39,  			// clock Input
 input  logic      clk40, clk41, clk42, clk43, clk44, clk45, clk46, clk47,  			// clock Input
 input  logic      clk48, clk49, clk50, clk51, clk52, clk53, clk54, clk55,				// clock Input
 input  logic      clk56, clk57, clk58, clk59, clk60, clk61, clk62, clk63, 			// clock Input
 input  logic      clk64, clk65, clk66, clk67, clk68, clk69, clk70, clk71,  			// clock Input
 input  logic      clk72, clk73, clk74, clk75, clk76, clk77, clk78, clk79,  			// clock Input
 input  logic      clk80, clk81, clk82, clk83, clk84, clk85, clk86, clk87,				// clock Input
 input  logic      clk88, clk89, clk90, clk91, clk92, clk93, clk94, clk95, 			// clock Input
 input  logic      clk96, clk97, clk98, clk99, clk100c, clk101c, clk102c, clk103c,	// clock Input
 input  logic      clk104c, clk105c, clk106c, clk107c, clk108c, clk109c, clk110c, clk111c,	// clock Input
 input  logic      clk112c, clk113c, clk114c, clk115c, clk116c, clk117c, clk118c, clk119c,	// clock Input
 input  logic      clk120c, clk121c, clk122c, clk123c, clk124c, clk125c, clk126c, clk127c,	// clock Input
 output logic [8:0] s0o, s1o, s2o, s3o, s4o, s5o, s6o, s7o,						   // Output of the counter
 output logic [8:0] s8o, s9o, s10o, s11o, s12o, s13o, s14o, s15o,				   // Output of the counter
 output logic [8:0] s16o, s17o, s18o, s19o, s20o, s21o, s22o, s23o,				// Output of the counter
 output logic [8:0] s24o, s25o, s26o, s27o, s28o, s29o, s30o, s31o,			   // Output of the counter
 output logic [8:0] s32o, s33o, s34o, s35o, s36o, s37o, s38o, s39o,				// Output of the counter
 output logic [8:0] s40o, s41o, s42o, s43o, s44o, s45o, s46o, s47o,				// Output of the counter
 output logic [8:0] s48o, s49o, s50o, s51o, s52o, s53o, s54o, s55o,				// Output of the counter
 output logic [8:0] s56o, s57o, s58o, s59o, s60o, s61o, s62o, s63o,			   // Output of the counter
 output logic [8:0] s64o, s65o, s66o, s67o, s68o, s69o, s70o, s71o,				// Output of the counter
 output logic [8:0] s72o, s73o, s74o, s75o, s76o, s77o, s78o, s79o,				// Output of the counter
 output logic [8:0] s80o, s81o, s82o, s83o, s84o, s85o, s86o, s87o,			   // Output of the counter
 output logic [8:0] s88o, s89o, s90o, s91o, s92o, s93o, s94o, s95o,				// Output of the counter
 output logic [8:0] s96o, s97o, s98o, s99o, s100o, s101o, s102o, s103o,			// Output of the counter
 output logic [8:0] s104o, s105o, s106o, s107o, s108o, s109o, s110o, s111o,	// Output of the counter
 output logic [8:0] s112o, s113o, s114o, s115o, s116o, s117o, s118o, s119o,	// Output of the counter
 output logic [8:0] s120o, s121o, s122o, s123o, s124o, s125o, s126o, s127o		// Output of the counter
    );
	
 //-------------Code Starts Here-------
 
 always_ff @(negedge clk0 or posedge ~reset)
  if (~reset) begin
   s0o <= 9'b0;
  end else if (enable) begin
    s0o ++;
  end
  
  always_ff @(negedge clk1 or posedge ~reset)
  if (~reset) begin
   s1o <= 9'b0;
  end else if (enable) begin
    s1o ++;
  end
  
  always_ff @(negedge clk2 or posedge ~reset)
  if (~reset) begin
   s2o <= 9'b0;
  end else if (enable) begin
    s2o ++;
  end
  
  always_ff @(negedge clk3 or posedge ~reset)
  if (~reset) begin
   s3o <= 9'b0;
  end else if (enable) begin
    s3o ++;
  end
  
  always_ff @(negedge clk4 or posedge ~reset)
  if (~reset) begin
   s4o <= 9'b0;
  end else if (enable) begin
    s4o ++;
  end
  
  always_ff @(negedge clk5 or posedge ~reset)
  if (~reset) begin
   s5o <= 9'b0;
  end else if (enable) begin
    s5o ++;
  end
  
  always_ff @(negedge clk6 or posedge ~reset)
  if (~reset) begin
   s6o <= 9'b0;
  end else if (enable) begin
    s6o ++;
  end
  
  always_ff @(negedge clk7 or posedge ~reset)
  if (~reset) begin
   s7o <= 9'b0;
  end else if (enable) begin
    s7o ++;
  end
  
  always_ff @(negedge clk8 or posedge ~reset)
  if (~reset) begin
   s8o <= 9'b0;
  end else if (enable) begin
    s8o ++;
  end
  
  always_ff @(negedge clk9 or posedge ~reset)
  if (~reset) begin
   s9o <= 9'b0;
  end else if (enable) begin
    s9o ++;
  end
  
  always_ff @(negedge clk10 or posedge ~reset)
  if (~reset) begin
   s10o <= 9'b0;
  end else if (enable) begin
    s10o ++;
  end
  
  always_ff @(negedge clk11 or posedge ~reset)
  if (~reset) begin
   s11o <= 9'b0;
  end else if (enable) begin
    s11o ++;
  end
  
  always_ff @(negedge clk12 or posedge ~reset)
  if (~reset) begin
   s12o <= 9'b0;
  end else if (enable) begin
    s12o ++;
  end
  
  always_ff @(negedge clk13 or posedge ~reset)
  if (~reset) begin
   s13o <= 9'b0;
  end else if (enable) begin
    s13o ++;
  end
  
  always_ff @(negedge clk14 or posedge ~reset)
  if (~reset) begin
   s14o <= 9'b0;
  end else if (enable) begin
    s14o ++;
  end
  
  always_ff @(negedge clk15 or posedge ~reset)
  if (~reset) begin
   s15o <= 9'b0;
  end else if (enable) begin
    s15o ++;
  end
  
  always_ff @(negedge clk16 or posedge ~reset)
  if (~reset) begin
   s16o <= 9'b0;
  end else if (enable) begin
    s16o ++;
  end
  
  always_ff @(negedge clk17 or posedge ~reset)
  if (~reset) begin
   s17o <= 9'b0;
  end else if (enable) begin
    s17o ++;
  end
  
  always_ff @(negedge clk18 or posedge ~reset)
  if (~reset) begin
   s18o <= 9'b0;
  end else if (enable) begin
    s18o ++;
  end
  
  always_ff @(negedge clk19 or posedge ~reset)
  if (~reset) begin
   s19o <= 9'b0;
  end else if (enable) begin
    s19o ++;
  end
  
  always_ff @(negedge clk20 or posedge ~reset)
  if (~reset) begin
   s20o <= 9'b0;
  end else if (enable) begin
    s20o ++;
  end
  
  always_ff @(negedge clk21 or posedge ~reset)
  if (~reset) begin
   s21o <= 9'b0;
  end else if (enable) begin
    s21o ++;
  end
  
  always_ff @(negedge clk22 or posedge ~reset)
  if (~reset) begin
   s22o <= 9'b0;
  end else if (enable) begin
    s22o ++;
  end
  
  always_ff @(negedge clk23 or posedge ~reset)
  if (~reset) begin
   s23o <= 9'b0;
  end else if (enable) begin
    s23o ++;
  end
  
  always_ff @(negedge clk24 or posedge ~reset)
  if (~reset) begin
   s24o <= 9'b0;
  end else if (enable) begin
    s24o ++;
  end
  
  always_ff @(negedge clk25 or posedge ~reset)
  if (~reset) begin
   s25o <= 9'b0;
  end else if (enable) begin
    s25o ++;
  end
  
  always_ff @(negedge clk26 or posedge ~reset)
  if (~reset) begin
   s26o <= 9'b0;
  end else if (enable) begin
    s26o ++;
  end
  
  always_ff @(negedge clk27 or posedge ~reset)
  if (~reset) begin
   s27o <= 9'b0;
  end else if (enable) begin
    s27o ++;
  end
  
  always_ff @(negedge clk28 or posedge ~reset)
  if (~reset) begin
   s28o <= 9'b0;
  end else if (enable) begin
    s28o ++;
  end
  
  always_ff @(negedge clk29 or posedge ~reset)
  if (~reset) begin
   s29o <= 9'b0;
  end else if (enable) begin
    s29o ++;
  end
  
  always_ff @(negedge clk30 or posedge ~reset)
  if (~reset) begin
   s30o <= 9'b0;
  end else if (enable) begin
    s30o ++;
  end
  
  always_ff @(negedge clk31 or posedge ~reset)
  if (~reset) begin
   s31o <= 9'b0;
  end else if (enable) begin
    s31o ++;
  end
  
  always_ff @(negedge clk32 or posedge ~reset)
  if (~reset) begin
   s32o <= 9'b0;
  end else if (enable) begin
    s32o ++;
  end
  
  always_ff @(negedge clk33 or posedge ~reset)
  if (~reset) begin
   s33o <= 9'b0;
  end else if (enable) begin
    s33o ++;
  end
  
  always_ff @(negedge clk34 or posedge ~reset)
  if (~reset) begin
   s34o <= 9'b0;
  end else if (enable) begin
    s34o ++;
  end
  
  always_ff @(negedge clk35 or posedge ~reset)
  if (~reset) begin
   s35o <= 9'b0;
  end else if (enable) begin
    s35o ++;
  end
  
  always_ff @(negedge clk36 or posedge ~reset)
  if (~reset) begin
   s36o <= 9'b0;
  end else if (enable) begin
    s36o ++;
  end
  
  always_ff @(negedge clk37 or posedge ~reset)
  if (~reset) begin
   s37o <= 9'b0;
  end else if (enable) begin
    s37o ++;
  end
  
  always_ff @(negedge clk38 or posedge ~reset)
  if (~reset) begin
   s38o <= 9'b0;
  end else if (enable) begin
    s38o ++;
  end
  
  always_ff @(negedge clk39 or posedge ~reset)
  if (~reset) begin
   s39o <= 9'b0;
  end else if (enable) begin
    s39o ++;
  end
  
  always_ff @(negedge clk40 or posedge ~reset)
  if (~reset) begin
   s40o <= 9'b0;
  end else if (enable) begin
    s40o ++;
  end
  
  always_ff @(negedge clk41 or posedge ~reset)
  if (~reset) begin
   s41o <= 9'b0;
  end else if (enable) begin
    s41o ++;
  end
  
  always_ff @(negedge clk42 or posedge ~reset)
  if (~reset) begin
   s42o <= 9'b0;
  end else if (enable) begin
    s42o ++;
  end
  
  always_ff @(negedge clk43 or posedge ~reset)
  if (~reset) begin
   s43o <= 9'b0;
  end else if (enable) begin
    s43o ++;
  end
  
  always_ff @(negedge clk44 or posedge ~reset)
  if (~reset) begin
   s44o <= 9'b0;
  end else if (enable) begin
    s44o ++;
  end
  
  always_ff @(negedge clk45 or posedge ~reset)
  if (~reset) begin
   s45o <= 9'b0;
  end else if (enable) begin
    s45o ++;
  end
  
  always_ff @(negedge clk46 or posedge ~reset)
  if (~reset) begin
   s46o <= 9'b0;
  end else if (enable) begin
    s46o ++;
  end
  
  always_ff @(negedge clk47 or posedge ~reset)
  if (~reset) begin
   s47o <= 9'b0;
  end else if (enable) begin
    s47o ++;
  end
  
  always_ff @(negedge clk48 or posedge ~reset)
  if (~reset) begin
   s48o <= 9'b0;
  end else if (enable) begin
    s48o ++;
  end
  
  always_ff @(negedge clk49 or posedge ~reset)
  if (~reset) begin
   s49o <= 9'b0;
  end else if (enable) begin
    s49o ++;
  end
  
  always_ff @(negedge clk50 or posedge ~reset)
  if (~reset) begin
   s50o <= 9'b0;
  end else if (enable) begin
    s50o ++;
  end
  
  always_ff @(negedge clk51 or posedge ~reset)
  if (~reset) begin
   s51o <= 9'b0;
  end else if (enable) begin
    s51o ++;
  end
  
  always_ff @(negedge clk52 or posedge ~reset)
  if (~reset) begin
   s52o <= 9'b0;
  end else if (enable) begin
    s52o ++;
  end
  
  always_ff @(negedge clk53 or posedge ~reset)
  if (~reset) begin
   s53o <= 9'b0;
  end else if (enable) begin
    s53o ++;
  end
  
  always_ff @(negedge clk54 or posedge ~reset)
  if (~reset) begin
   s54o <= 9'b0;
  end else if (enable) begin
    s54o ++;
  end
  
  always_ff @(negedge clk55 or posedge ~reset)
  if (~reset) begin
   s55o <= 9'b0;
  end else if (enable) begin
    s55o ++;
  end
  
  always_ff @(negedge clk56 or posedge ~reset)
  if (~reset) begin
   s56o <= 9'b0;
  end else if (enable) begin
    s56o ++;
  end
  
  always_ff @(negedge clk57 or posedge ~reset)
  if (~reset) begin
   s57o <= 9'b0;
  end else if (enable) begin
    s57o ++;
  end
  
  always_ff @(negedge clk58 or posedge ~reset)
  if (~reset) begin
   s58o <= 9'b0;
  end else if (enable) begin
    s58o ++;
  end
  
  always_ff @(negedge clk59 or posedge ~reset)
  if (~reset) begin
   s59o <= 9'b0;
  end else if (enable) begin
    s59o ++;
  end
  
  always_ff @(negedge clk60 or posedge ~reset)
  if (~reset) begin
   s60o <= 9'b0;
  end else if (enable) begin
    s60o ++;
  end
  
  always_ff @(negedge clk61 or posedge ~reset)
  if (~reset) begin
   s61o <= 9'b0;
  end else if (enable) begin
    s61o ++;
  end
  
  always_ff @(negedge clk62 or posedge ~reset)
  if (~reset) begin
   s62o <= 9'b0;
  end else if (enable) begin
    s62o ++;
  end
  
  always_ff @(negedge clk63 or posedge ~reset)
  if (~reset) begin
   s63o <= 9'b0;
  end else if (enable) begin
    s63o ++;
  end
  
  always_ff @(negedge clk64 or posedge ~reset)
  if (~reset) begin
   s64o <= 9'b0;
  end else if (enable) begin
    s64o ++;
  end
  
  always_ff @(negedge clk65 or posedge ~reset)
  if (~reset) begin
   s65o <= 9'b0;
  end else if (enable) begin
    s65o ++;
  end
  
  always_ff @(negedge clk66 or posedge ~reset)
  if (~reset) begin
   s66o <= 9'b0;
  end else if (enable) begin
    s66o ++;
  end
  
  always_ff @(negedge clk67 or posedge ~reset)
  if (~reset) begin
   s67o <= 9'b0;
  end else if (enable) begin
    s67o ++;
  end
  
  always_ff @(negedge clk68 or posedge ~reset)
  if (~reset) begin
   s68o <= 9'b0;
  end else if (enable) begin
    s68o ++;
  end
  
  always_ff @(negedge clk69 or posedge ~reset)
  if (~reset) begin
   s69o <= 9'b0;
  end else if (enable) begin
    s69o ++;
  end
  
  always_ff @(negedge clk70 or posedge ~reset)
  if (~reset) begin
   s70o <= 9'b0;
  end else if (enable) begin
    s70o ++;
  end
  
  always_ff @(negedge clk71 or posedge ~reset)
  if (~reset) begin
   s71o <= 9'b0;
  end else if (enable) begin
    s71o ++;
  end
  
  always_ff @(negedge clk72 or posedge ~reset)
  if (~reset) begin
   s72o <= 9'b0;
  end else if (enable) begin
    s72o ++;
  end
  
  always_ff @(negedge clk73 or posedge ~reset)
  if (~reset) begin
   s73o <= 9'b0;
  end else if (enable) begin
    s73o ++;
  end
  
  always_ff @(negedge clk74 or posedge ~reset)
  if (~reset) begin
   s74o <= 9'b0;
  end else if (enable) begin
    s74o ++;
  end
  
  always_ff @(negedge clk75 or posedge ~reset)
  if (~reset) begin
   s75o <= 9'b0;
  end else if (enable) begin
    s75o ++;
  end
  
  always_ff @(negedge clk76 or posedge ~reset)
  if (~reset) begin
   s76o <= 9'b0;
  end else if (enable) begin
    s76o ++;
  end
  
  always_ff @(negedge clk77 or posedge ~reset)
  if (~reset) begin
   s77o <= 9'b0;
  end else if (enable) begin
    s77o ++;
  end
  
  always_ff @(negedge clk78 or posedge ~reset)
  if (~reset) begin
   s78o <= 9'b0;
  end else if (enable) begin
    s78o ++;
  end
  
  always_ff @(negedge clk79 or posedge ~reset)
  if (~reset) begin
   s79o <= 9'b0;
  end else if (enable) begin
    s79o ++;
  end
  
  always_ff @(negedge clk80 or posedge ~reset)
  if (~reset) begin
   s80o <= 9'b0;
  end else if (enable) begin
    s80o ++;
  end
  
  always_ff @(negedge clk81 or posedge ~reset)
  if (~reset) begin
   s81o <= 9'b0;
  end else if (enable) begin
    s81o ++;
  end
  
  always_ff @(negedge clk82 or posedge ~reset)
  if (~reset) begin
   s82o <= 9'b0;
  end else if (enable) begin
    s82o ++;
  end
  
  always_ff @(negedge clk83 or posedge ~reset)
  if (~reset) begin
   s83o <= 9'b0;
  end else if (enable) begin
    s83o ++;
  end
  
  always_ff @(negedge clk84 or posedge ~reset)
  if (~reset) begin
   s84o <= 9'b0;
  end else if (enable) begin
    s84o ++;
  end
  
  always_ff @(negedge clk85 or posedge ~reset)
  if (~reset) begin
   s85o <= 9'b0;
  end else if (enable) begin
    s85o ++;
  end
  
  always_ff @(negedge clk86 or posedge ~reset)
  if (~reset) begin
   s86o <= 9'b0;
  end else if (enable) begin
    s86o ++;
  end
  
  always_ff @(negedge clk87 or posedge ~reset)
  if (~reset) begin
   s87o <= 9'b0;
  end else if (enable) begin
    s87o ++;
  end
  
  always_ff @(negedge clk88 or posedge ~reset)
  if (~reset) begin
   s88o <= 9'b0;
  end else if (enable) begin
    s88o ++;
  end
  
  always_ff @(negedge clk89 or posedge ~reset)
  if (~reset) begin
   s89o <= 9'b0;
  end else if (enable) begin
    s89o ++;
  end
  
  always_ff @(negedge clk90 or posedge ~reset)
  if (~reset) begin
   s90o <= 9'b0;
  end else if (enable) begin
    s90o ++;
  end
  
  always_ff @(negedge clk91 or posedge ~reset)
  if (~reset) begin
   s91o <= 9'b0;
  end else if (enable) begin
    s91o ++;
  end
  
  always_ff @(negedge clk92 or posedge ~reset)
  if (~reset) begin
   s92o <= 9'b0;
  end else if (enable) begin
    s92o ++;
  end
  
  always_ff @(negedge clk93 or posedge ~reset)
  if (~reset) begin
   s93o <= 9'b0;
  end else if (enable) begin
    s93o ++;
  end
  
  always_ff @(negedge clk94 or posedge ~reset)
  if (~reset) begin
   s94o <= 9'b0;
  end else if (enable) begin
    s94o ++;
  end
  
  always_ff @(negedge clk95 or posedge ~reset)
  if (~reset) begin
   s95o <= 9'b0;
  end else if (enable) begin
    s95o ++;
  end
  
  always_ff @(negedge clk96 or posedge ~reset)
  if (~reset) begin
   s96o <= 9'b0;
  end else if (enable) begin
    s96o ++;
  end
  
  always_ff @(negedge clk97 or posedge ~reset)
  if (~reset) begin
   s97o <= 9'b0;
  end else if (enable) begin
    s97o ++;
  end
  
  always_ff @(negedge clk98 or posedge ~reset)
  if (~reset) begin
   s98o <= 9'b0;
  end else if (enable) begin
    s98o ++;
  end
  
  always_ff @(negedge clk99 or posedge ~reset)
  if (~reset) begin
   s99o <= 9'b0;
  end else if (enable) begin
    s99o ++;
  end
  
   always_ff @(negedge clk100c or posedge ~reset)
  if (~reset) begin
   s100o <= 9'b0;
  end else if (enable) begin
    s100o ++;
  end
  
  always_ff @(negedge clk101c or posedge ~reset)
  if (~reset) begin
   s101o <= 9'b0;
  end else if (enable) begin
    s101o ++;
  end
  
  always_ff @(negedge clk102c or posedge ~reset)
  if (~reset) begin
   s102o <= 9'b0;
  end else if (enable) begin
    s102o ++;
  end
  
  always_ff @(negedge clk103c or posedge ~reset)
  if (~reset) begin
   s103o <= 9'b0;
  end else if (enable) begin
    s103o ++;
  end
  
  always_ff @(negedge clk104c or posedge ~reset)
  if (~reset) begin
   s104o <= 9'b0;
  end else if (enable) begin
    s104o ++;
  end
  
  always_ff @(negedge clk105c or posedge ~reset)
  if (~reset) begin
   s105o <= 9'b0;
  end else if (enable) begin
    s105o ++;
  end
  
  always_ff @(negedge clk106c or posedge ~reset)
  if (~reset) begin
   s106o <= 9'b0;
  end else if (enable) begin
    s106o ++;
  end
  
  always_ff @(negedge clk107c or posedge ~reset)
  if (~reset) begin
   s107o <= 9'b0;
  end else if (enable) begin
    s107o ++;
  end
  
  always_ff @(negedge clk108c or posedge ~reset)
  if (~reset) begin
   s108o <= 9'b0;
  end else if (enable) begin
    s108o ++;
  end
  
  always_ff @(negedge clk109c or posedge ~reset)
  if (~reset) begin
   s109o <= 9'b0;
  end else if (enable) begin
    s109o ++;
  end
  
  always_ff @(negedge clk110c or posedge ~reset)
  if (~reset) begin
   s110o <= 9'b0;
  end else if (enable) begin
    s110o ++;
  end
  
  always_ff @(negedge clk111c or posedge ~reset)
  if (~reset) begin
   s111o <= 9'b0;
  end else if (enable) begin
    s111o ++;
  end
  
  always_ff @(negedge clk112c or posedge ~reset)
  if (~reset) begin
   s112o <= 9'b0;
  end else if (enable) begin
    s112o ++;
  end
  
  always_ff @(negedge clk113c or posedge ~reset)
  if (~reset) begin
   s113o <= 9'b0;
  end else if (enable) begin
    s113o ++;
  end
  
  always_ff @(negedge clk114c or posedge ~reset)
  if (~reset) begin
   s114o <= 9'b0;
  end else if (enable) begin
    s114o ++;
  end
  
  always_ff @(negedge clk115c or posedge ~reset)
  if (~reset) begin
   s115o <= 9'b0;
  end else if (enable) begin
    s115o ++;
  end
  
  always_ff @(negedge clk116c or posedge ~reset)
  if (~reset) begin
   s116o <= 9'b0;
  end else if (enable) begin
    s116o ++;
  end
  
  always_ff @(negedge clk117c or posedge ~reset)
  if (~reset) begin
   s117o <= 9'b0;
  end else if (enable) begin
    s117o ++;
  end
  
  always_ff @(negedge clk118c or posedge ~reset)
  if (~reset) begin
   s118o <= 9'b0;
  end else if (enable) begin
    s118o ++;
  end
  
  always_ff @(negedge clk119c or posedge ~reset)
  if (~reset) begin
   s119o <= 9'b0;
  end else if (enable) begin
    s119o ++;
  end
  
  always_ff @(negedge clk120c or posedge ~reset)
  if (~reset) begin
   s120o <= 9'b0;
  end else if (enable) begin
    s120o ++;
  end
  
  always_ff @(negedge clk121c or posedge ~reset)
  if (~reset) begin
   s121o <= 9'b0;
  end else if (enable) begin
    s121o ++;
  end
  
  always_ff @(negedge clk122c or posedge ~reset)
  if (~reset) begin
   s122o <= 9'b0;
  end else if (enable) begin
    s122o ++;
  end
  
  always_ff @(negedge clk123c or posedge ~reset)
  if (~reset) begin
   s123o <= 9'b0;
  end else if (enable) begin
    s123o ++;
  end
  
  always_ff @(negedge clk124c or posedge ~reset)
  if (~reset) begin
   s124o <= 9'b0;
  end else if (enable) begin
    s124o ++;
  end
  
  always_ff @(negedge clk125c or posedge ~reset)
  if (~reset) begin
   s125o <= 9'b0;
  end else if (enable) begin
    s125o ++;
  end
  
  always_ff @(negedge clk126c or posedge ~reset)
  if (~reset) begin
   s126o <= 9'b0;
  end else if (enable) begin
    s126o ++;
  end
  
  always_ff @(negedge clk127c or posedge ~reset)
  if (~reset) begin
   s127o <= 9'b0;
  end else if (enable) begin
    s127o ++;
  end
  
 endmodule 