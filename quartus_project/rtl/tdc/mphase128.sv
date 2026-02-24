//-----------------------------------------------------
// Design Name : mphase128
// File Name   : mphase128.sv
// Function    : fases multiplas do clock
// Coder      : Wellington Melo
//-----------------------------------------------------



module mphase128 (
input  wire clk0, 			// Input clk
output wire clk0out,      	// OSC output
output wire clk1out,   		// OSC Delay 
output wire clk2out,			// OSC Delay 
output wire clk3out,			// OSC Delay 
output wire clk4out,			// OSC Delay 
output wire clk5out, 		// OSC Delay 
output wire clk6out,			// OSC Delay 
output wire clk7out,			// OSC Delay 
output wire clk8out,			// OSC Delay 
output wire clk9out,			// OSC Delay 
output wire clk10out,		// OSC Delay 
output wire clk11out,		// OSC Delay 
output wire clk12out,		// OSC Delay 
output wire clk13out,		// OSC Delay 
output wire clk14out,		// OSC Delay 
output wire clk15out,		// OSC Delay 
output wire clk16out,		// OSC Delay 
output wire clk17out,		// OSC Delay 
output wire clk18out,		// OSC Delay 
output wire clk19out,		// OSC Delay 
output wire clk20out,		// OSC Delay 
output wire clk21out,		// OSC Delay 
output wire clk22out,		// OSC Delay 
output wire clk23out,		// OSC Delay 
output wire clk24out,		// OSC Delay 
output wire clk25out,		// OSC Delay 
output wire clk26out,		// OSC Delay 
output wire clk27out,		// OSC Delay 
output wire clk28out,		// OSC Delay 
output wire clk29out,		// OSC Delay 
output wire clk30out,		// OSC Delay 
output wire clk31out, 		// OSC Delay 
output wire clk32out,      // OSC output
output wire clk33out,   	// OSC Delay 
output wire clk34out,		// OSC Delay 
output wire clk35out,		// OSC Delay 
output wire clk36out,		// OSC Delay 
output wire clk37out, 		// OSC Delay 
output wire clk38out,		// OSC Delay 
output wire clk39out,		// OSC Delay 
output wire clk40out,		// OSC Delay 
output wire clk41out,		// OSC Delay 
output wire clk42out,		// OSC Delay 
output wire clk43out,		// OSC Delay 
output wire clk44out,		// OSC Delay 
output wire clk45out,		// OSC Delay 
output wire clk46out,		// OSC Delay 
output wire clk47out,		// OSC Delay 
output wire clk48out,		// OSC Delay 
output wire clk49out,		// OSC Delay 
output wire clk50out,		// OSC Delay 
output wire clk51out,		// OSC Delay 
output wire clk52out,		// OSC Delay 
output wire clk53out,		// OSC Delay 
output wire clk54out,		// OSC Delay 
output wire clk55out,		// OSC Delay 
output wire clk56out,		// OSC Delay 
output wire clk57out,		// OSC Delay 
output wire clk58out,		// OSC Delay 
output wire clk59out,		// OSC Delay 
output wire clk60out,		// OSC Delay 
output wire clk61out,		// OSC Delay 
output wire clk62out,		// OSC Delay 
output wire clk63out, 		// OSC Delay 

output wire clk64out,		// OSC Delay inverter
output wire clk65out,		// OSC Delay inverter
output wire clk66out,		// OSC Delay inverter
output wire clk67out,		// OSC Delay inverter
output wire clk68out,		// OSC Delay inverter
output wire clk69out,		// OSC Delay inverter
output wire clk70out,		// OSC Delay inverter
output wire clk71out,		// OSC Delay inverter
output wire clk72out,		// OSC Delay inverter
output wire clk73out,		// OSC Delay inverter
output wire clk74out,		// OSC Delay inverter
output wire clk75out,		// OSC Delay inverter
output wire clk76out,		// OSC Delay inverter
output wire clk77out, 		// OSC Delay inverter
output wire clk78out,		// OSC Delay inverter
output wire clk79out,		// OSC Delay inverter
output wire clk80out,		// OSC Delay inverter
output wire clk81out,		// OSC Delay inverter
output wire clk82out,		// OSC Delay inverter
output wire clk83out,		// OSC Delay inverter
output wire clk84out,		// OSC Delay inverter
output wire clk85out,		// OSC Delay inverter
output wire clk86out,		// OSC Delay inverter
output wire clk87out,		// OSC Delay inverter
output wire clk88out,		// OSC Delay inverter
output wire clk89out,		// OSC Delay inverter
output wire clk90out,		// OSC Delay inverter
output wire clk91out, 		// OSC Delay inverter
output wire clk92out,		// OSC Delay inverter
output wire clk93out,		// OSC Delay inverter
output wire clk94out,		// OSC Delay inverter
output wire clk95out,		// OSC Delay inverter
output wire clk96out,		// OSC Delay inverter
output wire clk97out,		// OSC Delay inverter
output wire clk98out, 		// OSC Delay inverter
output wire clk99out, 		// OSC Delay inverter
output wire clk100out, 		// OSC Delay inverter
output wire clk101out, 		// OSC Delay inverter
output wire clk102out, 		// OSC Delay inverter
output wire clk103out, 		// OSC Delay inverter
output wire clk104out, 		// OSC Delay inverter
output wire clk105out, 		// OSC Delay inverter
output wire clk106out, 		// OSC Delay inverter
output wire clk107out, 		// OSC Delay inverter
output wire clk108out, 		// OSC Delay inverter
output wire clk109out, 		// OSC Delay inverter
output wire clk110out, 		// OSC Delay inverter
output wire clk111out, 		// OSC Delay inverter
output wire clk112out, 		// OSC Delay inverter
output wire clk113out, 		// OSC Delay inverter
output wire clk114out, 		// OSC Delay inverter
output wire clk115out, 		// OSC Delay inverter
output wire clk116out, 		// OSC Delay inverter
output wire clk117out, 		// OSC Delay inverter
output wire clk118out, 		// OSC Delay inverter
output wire clk119out, 		// OSC Delay inverter
output wire clk120out, 		// OSC Delay inverter
output wire clk121out, 		// OSC Delay inverter
output wire clk122out, 		// OSC Delay inverter
output wire clk123out, 		// OSC Delay inverter
output wire clk124out, 		// OSC Delay inverter
output wire clk125out, 		// OSC Delay inverter
output wire clk126out, 		// OSC Delay inverter
output wire clk127out 		// OSC Delay inverter
);

//------declaration ----------


wire q0            /* synthesis keep */;
wire q1            /* synthesis keep */;
wire q2            /* synthesis keep */;
wire q3            /* synthesis keep */;
wire q4            /* synthesis keep */;
wire q5            /* synthesis keep */;
wire q6            /* synthesis keep */;
wire q7            /* synthesis keep */;
wire q8		       /* synthesis keep */;
wire q9            /* synthesis keep */;
wire q10           /* synthesis keep */;
wire q11           /* synthesis keep */;
wire q12           /* synthesis keep */;
wire q13           /* synthesis keep */;
wire q14           /* synthesis keep */;
wire q15           /* synthesis keep */;
wire q16           /* synthesis keep */;
wire q17           /* synthesis keep */;
wire q18           /* synthesis keep */;
wire q19           /* synthesis keep */;
wire q20           /* synthesis keep */;
wire q21           /* synthesis keep */;
wire q22           /* synthesis keep */;
wire q23           /* synthesis keep */;
wire q24	          /* synthesis keep */;
wire q25           /* synthesis keep */;
wire q26           /* synthesis keep */;
wire q27           /* synthesis keep */;
wire q28           /* synthesis keep */;
wire q29           /* synthesis keep */;
wire q30           /* synthesis keep */;
wire q31           /* synthesis keep */;
wire q32           /* synthesis keep */;
wire q33           /* synthesis keep */;
wire q34           /* synthesis keep */;
wire q35           /* synthesis keep */;
wire q36           /* synthesis keep */;
wire q37           /* synthesis keep */;
wire q38           /* synthesis keep */;
wire q39           /* synthesis keep */;
wire q40	  			 /* synthesis keep */;
wire q41           /* synthesis keep */;
wire q42           /* synthesis keep */;
wire q43           /* synthesis keep */;
wire q44           /* synthesis keep */;
wire q45           /* synthesis keep */;
wire q46           /* synthesis keep */;
wire q47           /* synthesis keep */;
wire q48           /* synthesis keep */;
wire q49           /* synthesis keep */;
wire q50           /* synthesis keep */;
wire q51           /* synthesis keep */;
wire q52           /* synthesis keep */;
wire q53           /* synthesis keep */;
wire q54           /* synthesis keep */;
wire q55           /* synthesis keep */;
wire q56			    /* synthesis keep */;
wire q57           /* synthesis keep */;
wire q58           /* synthesis keep */;
wire q59           /* synthesis keep */;
wire q60           /* synthesis keep */;
wire q61           /* synthesis keep */;
wire q62           /* synthesis keep */;
wire q63           /* synthesis keep */;

wire q64           /* synthesis keep */;
wire q65           /* synthesis keep */;
wire q66           /* synthesis keep */;
wire q67           /* synthesis keep */;
wire q68           /* synthesis keep */;
wire q69           /* synthesis keep */;
wire q70			    /* synthesis keep */;
wire q71           /* synthesis keep */;
wire q72           /* synthesis keep */;
wire q73           /* synthesis keep */;
wire q74           /* synthesis keep */;
wire q75           /* synthesis keep */;
wire q76           /* synthesis keep */;
wire q77           /* synthesis keep */;
wire q78           /* synthesis keep */;
wire q79           /* synthesis keep */;
wire q80           /* synthesis keep */;
wire q81           /* synthesis keep */;
wire q82           /* synthesis keep */;
wire q83           /* synthesis keep */;
wire q84			    /* synthesis keep */;
wire q85           /* synthesis keep */;
wire q86           /* synthesis keep */;
wire q87           /* synthesis keep */;
wire q88           /* synthesis keep */;
wire q89           /* synthesis keep */;
wire q90           /* synthesis keep */;
wire q91           /* synthesis keep */;
wire q92           /* synthesis keep */;
wire q93           /* synthesis keep */;
wire q94			    /* synthesis keep */;
wire q95           /* synthesis keep */;
wire q96           /* synthesis keep */;
wire q97           /* synthesis keep */;
wire q98           /* synthesis keep */;
wire q99           /* synthesis keep */;
wire q100o           /* synthesis keep */;
wire q101o           /* synthesis keep */;
wire q102o           /* synthesis keep */;
wire q103o           /* synthesis keep */;
wire q104o           /* synthesis keep */;
wire q105o           /* synthesis keep */;
wire q106o           /* synthesis keep */;
wire q107o           /* synthesis keep */;
wire q108o           /* synthesis keep */;
wire q109o           /* synthesis keep */;
wire q110o           /* synthesis keep */;
wire q111o           /* synthesis keep */;
wire q112o           /* synthesis keep */;
wire q113o           /* synthesis keep */;
wire q114o           /* synthesis keep */;
wire q115o           /* synthesis keep */;
wire q116o           /* synthesis keep */;
wire q117o           /* synthesis keep */;
wire q118o           /* synthesis keep */;
wire q119o           /* synthesis keep */;
wire q120o           /* synthesis keep */;
wire q121o           /* synthesis keep */;
wire q122o           /* synthesis keep */;
wire q123o           /* synthesis keep */;
wire q124o           /* synthesis keep */;
wire q125o           /* synthesis keep */;
wire q126o           /* synthesis keep */;
wire q127o           /* synthesis keep */;


wire clkout0int 	/* synthesis keep */;  		// OSC Output
wire clkout1int 	/* synthesis keep */;  		// OSC Delay 
wire clkout2int	/* synthesis keep */;		// OSC Delay 
wire clkout3int	/* synthesis keep */;		// OSC Delay 
wire clkout4int	/* synthesis keep */;		// OSC Delay 
wire clkout5int	/* synthesis keep */;		// OSC Delay 
wire clkout6int	/* synthesis keep */;		// OSC Delay 
wire clkout7int	/* synthesis keep */;		// OSC Delay 
wire clkout8int	/* synthesis keep */;		// OSC Delay 
wire clkout9int 	/* synthesis keep */;  		// OSC Delay 
wire clkout10int	/* synthesis keep */;		// OSC Delay 
wire clkout11int	/* synthesis keep */;		// OSC Delay 
wire clkout12int	/* synthesis keep */;		// OSC Delay 
wire clkout13int	/* synthesis keep */;		// OSC Delay 
wire clkout14int	/* synthesis keep */;		// OSC Delay 
wire clkout15int	/* synthesis keep */;		// OSC Delay 
wire clkout16int 	/* synthesis keep */;  		// OSC Delay 
wire clkout17int 	/* synthesis keep */;  		// OSC Delay 
wire clkout18int	/* synthesis keep */;		// OSC Delay 
wire clkout19int	/* synthesis keep */;		// OSC Delay 
wire clkout20int	/* synthesis keep */;		// OSC Delay 
wire clkout21int	/* synthesis keep */;		// OSC Delay 
wire clkout22int	/* synthesis keep */;		// OSC Delay 
wire clkout23int	/* synthesis keep */;		// OSC Delay 
wire clkout24int	/* synthesis keep */;		// OSC Delay 
wire clkout25int 	/* synthesis keep */;  		// OSC Delay 
wire clkout26int	/* synthesis keep */;		// OSC Delay 
wire clkout27int	/* synthesis keep */;		// OSC Delay 
wire clkout28int	/* synthesis keep */;		// OSC Delay 
wire clkout29int	/* synthesis keep */;		// OSC Delay 
wire clkout30int	/* synthesis keep */;		// OSC Delay 
wire clkout31int	/* synthesis keep */;		// OSC Delay                                           
wire clkout32int 	/* synthesis keep */;  		// OSC Delay
wire clkout33int 	/* synthesis keep */;  		// OSC Delay  
wire clkout34int	/* synthesis keep */;		// OSC Delay  
wire clkout35int	/* synthesis keep */;		// OSC Delay  
wire clkout36int	/* synthesis keep */;		// OSC Delay  
wire clkout37int	/* synthesis keep */;		// OSC Delay  
wire clkout38int	/* synthesis keep */;		// OSC Delay  
wire clkout39int	/* synthesis keep */;		// OSC Delay  
wire clkout40int	/* synthesis keep */;		// OSC Delay  
wire clkout41int 	/* synthesis keep */;  		// OSC Delay  
wire clkout42int	/* synthesis keep */;		// OSC Delay  
wire clkout43int	/* synthesis keep */;		// OSC Delay  
wire clkout44int	/* synthesis keep */;		// OSC Delay  
wire clkout45int	/* synthesis keep */;		// OSC Delay  
wire clkout46int	/* synthesis keep */;		// OSC Delay  
wire clkout47int	/* synthesis keep */;		// OSC Delay  
wire clkout48int 	/* synthesis keep */;  		// OSC Delay  
wire clkout49int 	/* synthesis keep */;  		// OSC Delay 
wire clkout50int	/* synthesis keep */;		// OSC Delay 
wire clkout51int	/* synthesis keep */;		// OSC Delay  
wire clkout52int	/* synthesis keep */;		// OSC Delay  
wire clkout53int	/* synthesis keep */;		// OSC Delay  
wire clkout54int	/* synthesis keep */;		// OSC Delay  
wire clkout55int	/* synthesis keep */;		// OSC Delay  
wire clkout56int	/* synthesis keep */;		// OSC Delay  
wire clkout57int 	/* synthesis keep */;  		// OSC Delay  
wire clkout58int	/* synthesis keep */;		// OSC Delay  
wire clkout59int	/* synthesis keep */;		// OSC Delay  
wire clkout60int	/* synthesis keep */;		// OSC Delay  
wire clkout61int	/* synthesis keep */;		// OSC Delay  
wire clkout62int	/* synthesis keep */;		// OSC Delay  
wire clkout63int	/* synthesis keep */;		// OSC Delay  

wire clkout64int	/* synthesis keep */;		// OSC output inverter
wire clkout65int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout66int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout67int 	/* synthesis keep */;  		// OSC Delay  inverter
wire clkout68int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout69int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout70int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout71int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout72int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout73int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout74int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout75int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout76int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout77int 	/* synthesis keep */;  		// OSC Delay  inverter
wire clkout78int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout79int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout80int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout81int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout82int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout83int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout84int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout85int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout86int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout87int 	/* synthesis keep */;  		// OSC Delay  inverter
wire clkout88int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout89int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout90int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout91int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout92int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout93int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout94int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout95int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout96int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout97int 	/* synthesis keep */;  		// OSC Delay  inverter
wire clkout98int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout99int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout100int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout101int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout102int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout103int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout104int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout105int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout106int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout107int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout108int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout109int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout110int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout111int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout112int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout113int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout114int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout115int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout116int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout117int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout118int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout119int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout120int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout121int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout122int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout123int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout124int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout125int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout126int	/* synthesis keep */;		// OSC Delay  inverter
wire clkout127int	/* synthesis keep */;		// OSC Delay  inverter


assign 	q0 = clk0;
assign 	q1 = clk0;
assign 	q2 = clk0;
assign 	q3 = clk0;
assign 	q4 = clk0;
assign 	q5 = clk0;
assign 	q6 = clk0;
assign 	q7 = clk0;
assign 	q8 = clk0;
assign 	q9 = clk0;
assign 	q10 = clk0;
assign 	q11 = clk0;
assign 	q12 = clk0;
assign 	q13 = clk0;
assign 	q14 = clk0;
assign   q15 = clk0;
assign 	q16 = clk0;
assign 	q17 = clk0;
assign 	q18 = clk0;
assign 	q19 = clk0;
assign 	q20 = clk0;
assign 	q21 = clk0;
assign 	q22 = clk0;
assign 	q23 = clk0;
assign 	q24 = clk0;
assign 	q25 = clk0;
assign 	q26 = clk0;
assign 	q27 = clk0;
assign 	q28 = clk0;
assign 	q29 = clk0;
assign 	q30 = clk0;
assign   q31 = clk0;
assign 	q32 = clk0;
assign 	q33 = clk0;
assign 	q34 = clk0;
assign 	q35 = clk0;
assign 	q36 = clk0;
assign 	q37 = clk0;
assign 	q38 = clk0;
assign 	q39 = clk0;
assign 	q40 = clk0;
assign 	q41 = clk0;
assign 	q42 = clk0;
assign 	q43 = clk0;
assign 	q44 = clk0;
assign 	q45 = clk0;
assign 	q46 = clk0;
assign   q47 = clk0;
assign 	q48 = clk0;
assign 	q49 = clk0;
assign 	q50 = clk0;
assign 	q51 = clk0;
assign 	q52 = clk0;
assign 	q53 = clk0;
assign 	q54 = clk0;
assign 	q55 = clk0;
assign 	q56 = clk0;
assign 	q57 = clk0;
assign 	q58 = clk0;
assign 	q59 = clk0;
assign 	q60 = clk0;
assign 	q61 = clk0;
assign 	q62 = clk0;
assign   q63 = clk0;

assign 	q64 = ~clk0;
assign 	q65 = ~clk0;
assign 	q66 = ~clk0;
assign 	q67 = ~clk0;
assign 	q68 = ~clk0;
assign 	q69 = ~clk0;
assign 	q70 = ~clk0;
assign 	q71 = ~clk0;
assign 	q72 = ~clk0;
assign 	q73 = ~clk0;
assign 	q74 = ~clk0;
assign 	q75 = ~clk0;
assign 	q76 = ~clk0;
assign   q77 = ~clk0;
assign 	q78 = ~clk0;
assign 	q79 = ~clk0;
assign 	q80 = ~clk0;
assign 	q81 = ~clk0;
assign 	q82 = ~clk0;
assign 	q83 = ~clk0;
assign 	q84 = ~clk0;
assign 	q85 = ~clk0;
assign 	q86 = ~clk0;
assign 	q87 = ~clk0;
assign   q88 = ~clk0;
assign 	q89 = ~clk0;
assign 	q90 = ~clk0;
assign 	q91 = ~clk0;
assign 	q92 = ~clk0;
assign 	q93 = ~clk0;
assign 	q94 = ~clk0;
assign 	q95 = ~clk0;
assign 	q96 = ~clk0;
assign 	q97 = ~clk0;
assign 	q98 = ~clk0;
assign 	q99 = ~clk0;
assign	q100o = ~clk0;
assign   q101o = ~clk0;
assign   q102o = ~clk0;
assign	q103o = ~clk0;
assign	q104o = ~clk0;
assign	q105o = ~clk0;
assign	q106o = ~clk0;
assign	q107o = ~clk0;
assign	q108o = ~clk0;
assign	q109o = ~clk0;
assign	q110o = ~clk0;
assign	q111o = ~clk0;
assign	q112o = ~clk0;
assign	q113o = ~clk0;
assign	q114o = ~clk0;
assign	q115o = ~clk0;
assign	q116o = ~clk0;
assign	q117o = ~clk0;
assign	q118o = ~clk0;
assign	q119o = ~clk0;
assign	q120o = ~clk0;
assign	q121o = ~clk0;
assign	q122o = ~clk0;
assign   q123o = ~clk0;
assign   q124o = ~clk0;
assign   q125o = ~clk0;
assign   q126o = ~clk0;
assign   q127o = ~clk0;

			
assign clkout0int = q0;
assign #(15.625ps )  clkout1int = q1;
assign #(31.250ps )  clkout2int = q2;
assign #(46.875ps )  clkout3int = q3;
assign #(62.500ps )  clkout4int = q4;
assign #(78.125ps )  clkout5int = q5;
assign #(93.750ps )  clkout6int = q6;
assign #(109.375ps)  clkout7int = q7;
assign #(125.000ps)  clkout8int = q8;
assign #(140.625ps)  clkout9int = q9;
assign #(156.250ps)  clkout10int = q10;
assign #(171.875ps)  clkout11int = q11;
assign #(187.500ps)  clkout12int = q12;
assign #(203.125ps)  clkout13int = q13;
assign #(218.750ps)  clkout14int = q14;
assign #(234.375ps)  clkout15int = q15;
assign #(250.000ps)  clkout16int = q16;
assign #(265.625ps)  clkout17int = q17;
assign #(281.250ps)  clkout18int = q18;
assign #(296.875ps)  clkout19int = q19;
assign #(312.500ps)  clkout20int = q20;
assign #(328.125ps)  clkout21int = q21;
assign #(343.750ps)  clkout22int = q22;
assign #(359.375ps)  clkout23int = q23;
assign #(375.000ps)  clkout24int = q24;
assign #(390.625ps)  clkout25int = q25;
assign #(406.250ps)  clkout26int = q26;
assign #(421.875ps)  clkout27int = q27;
assign #(437.500ps)  clkout28int = q28;
assign #(453.125ps)  clkout29int = q29;
assign #(468.750ps)  clkout30int = q30;
assign #(484.375ps)  clkout31int = q31;
assign #(500.000ps)  clkout32int = q32;
assign #(515.625ps)  clkout33int = q33;
assign #(531.250ps)  clkout34int = q34;
assign #(546.875ps)  clkout35int = q35;
assign #(562.500ps)  clkout36int = q36;
assign #(578.125ps)  clkout37int = q37;
assign #(593.750ps)  clkout38int = q38;
assign #(609.375ps)  clkout39int = q39;
assign #(625.000ps)  clkout40int = q40;
assign #(640.625ps)  clkout41int = q41;
assign #(656.250ps)  clkout42int = q42;
assign #(671.875ps)  clkout43int = q43;
assign #(687.500ps)  clkout44int = q44;
assign #(703.125ps)  clkout45int = q45;
assign #(718.750ps)  clkout46int = q46;
assign #(734.375ps)  clkout47int = q47;
assign #(750.000ps)  clkout48int = q48;
assign #(765.625ps)  clkout49int = q49;
assign #(781.250ps)  clkout50int = q50;
assign #(796.875ps)  clkout51int = q51;
assign #(812.500ps)  clkout52int = q52;
assign #(828.125ps)  clkout53int = q53;
assign #(843.750ps)  clkout54int = q54;
assign #(859.375ps)  clkout55int = q55;
assign #(875.000ps)  clkout56int = q56;
assign #(890.625ps)  clkout57int = q57;
assign #(906.250ps)  clkout58int = q58;
assign #(921.875ps)  clkout59int = q59;
assign #(937.500ps)  clkout60int = q60;
assign #(953.125ps)  clkout61int = q61;
assign #(968.750ps)  clkout62int = q62;
assign #(984.375ps)  clkout63int = q63;

assign  clkout64int = q64;
assign #(15.625ps ) clkout65int = q65;
assign #(31.250ps ) clkout66int = q66;
assign #(46.875ps ) clkout67int = q67;
assign #(62.500ps ) clkout68int = q68;
assign #(78.125ps ) clkout69int = q69;
assign #(93.750ps ) clkout70int = q70;
assign #(109.375ps) clkout71int = q71;
assign #(125.000ps) clkout72int = q72;
assign #(140.625ps) clkout73int = q73;
assign #(156.250ps) clkout74int = q74;
assign #(171.875ps) clkout75int = q75;
assign #(187.500ps) clkout76int = q76;
assign #(203.125ps) clkout77int = q77;
assign #(218.750ps) clkout78int = q78;
assign #(234.375ps) clkout79int = q79;
assign #(250.000ps) clkout80int = q80;
assign #(265.625ps) clkout81int = q81;
assign #(281.250ps) clkout82int = q82;
assign #(296.875ps) clkout83int = q83;
assign #(312.500ps) clkout84int = q84;
assign #(328.125ps) clkout85int = q85;
assign #(343.750ps) clkout86int = q86;
assign #(359.375ps) clkout87int = q87;
assign #(375.000ps) clkout88int = q88;
assign #(390.625ps) clkout89int = q89;
assign #(406.250ps) clkout90int = q90;
assign #(421.875ps) clkout91int = q91;
assign #(437.500ps) clkout92int = q92;
assign #(453.125ps) clkout93int = q93;
assign #(468.750ps) clkout94int = q94;
assign #(484.375ps) clkout95int = q95;
assign #(500.000ps) clkout96int = q96;
assign #(515.625ps) clkout97int = q97;
assign #(531.250ps) clkout98int = q98;
assign #(546.875ps) clkout99int = q99;
assign #(562.500ps) clkout100int = q100o;
assign #(578.125ps) clkout101int = q101o;
assign #(593.750ps) clkout102int = q102o;
assign #(609.375ps) clkout103int = q103o;
assign #(625.000ps) clkout104int = q104o;
assign #(640.625ps) clkout105int = q105o;
assign #(656.250ps) clkout106int = q106o;
assign #(671.875ps) clkout107int = q107o;
assign #(687.500ps) clkout108int = q108o;
assign #(703.125ps) clkout109int = q109o;
assign #(718.750ps) clkout110int = q110o;
assign #(734.375ps) clkout111int = q111o;
assign #(750.000ps) clkout112int = q112o;
assign #(765.625ps) clkout113int = q113o;
assign #(781.250ps) clkout114int = q114o;
assign #(796.875ps) clkout115int = q115o;
assign #(812.500ps) clkout116int = q116o;
assign #(828.125ps) clkout117int = q117o;
assign #(843.750ps) clkout118int = q118o;
assign #(859.375ps) clkout119int = q119o;
assign #(875.000ps) clkout120int = q120o;
assign #(890.625ps) clkout121int = q121o;
assign #(906.250ps) clkout122int = q122o;
assign #(921.875ps) clkout123int = q123o;
assign #(937.500ps) clkout124int = q124o;
assign #(953.125ps) clkout125int = q125o;
assign #(968.750ps) clkout126int = q126o;
assign #(984.375ps) clkout127int = q127o;



assign clk0out = clkout0int;
assign clk1out = clkout1int;
assign clk2out = clkout2int;
assign clk3out = clkout3int;
assign clk4out = clkout4int;
assign clk5out = clkout5int;
assign clk6out = clkout6int;
assign clk7out = clkout7int;
assign clk8out = clkout8int;			
assign clk9out = clkout9int;
assign clk10out = clkout10int;
assign clk11out = clkout11int;
assign clk12out = clkout12int;
assign clk13out = clkout13int;
assign clk14out = clkout14int;
assign clk15out = clkout15int;
assign clk16out = clkout16int;
assign clk17out = clkout17int;
assign clk18out = clkout18int;
assign clk19out = clkout19int;
assign clk20out = clkout20int;
assign clk21out = clkout21int;
assign clk22out = clkout22int;
assign clk23out = clkout23int;
assign clk24out = clkout24int;			
assign clk25out = clkout25int;
assign clk26out = clkout26int;
assign clk27out = clkout27int;
assign clk28out = clkout28int;
assign clk29out = clkout29int;
assign clk30out = clkout30int;
assign clk31out = clkout31int;
assign clk32out = clkout32int;
assign clk33out = clkout33int;
assign clk34out = clkout34int;
assign clk35out = clkout35int;
assign clk36out = clkout36int;
assign clk37out = clkout37int;
assign clk38out = clkout38int;
assign clk39out = clkout39int;
assign clk40out = clkout40int;			
assign clk41out = clkout41int;
assign clk42out = clkout42int;
assign clk43out = clkout43int;
assign clk44out = clkout44int;
assign clk45out = clkout45int;
assign clk46out = clkout46int;
assign clk47out = clkout47int;
assign clk48out = clkout48int;
assign clk49out = clkout49int;
assign clk50out = clkout50int;
assign clk51out = clkout51int;
assign clk52out = clkout52int;
assign clk53out = clkout53int;
assign clk54out = clkout54int;
assign clk55out = clkout55int;
assign clk56out = clkout56int;			
assign clk57out = clkout57int;
assign clk58out = clkout58int;
assign clk59out = clkout59int;
assign clk60out = clkout60int;
assign clk61out = clkout61int;
assign clk62out = clkout62int;
assign clk63out = clkout63int;

assign clk64out = clkout64int;
assign clk65out = clkout65int;
assign clk66out = clkout66int;			
assign clk67out = clkout67int;
assign clk68out = clkout68int;
assign clk69out = clkout69int;
assign clk70out = clkout70int;
assign clk71out = clkout71int;
assign clk72out = clkout72int;
assign clk73out = clkout73int;
assign clk74out = clkout74int;
assign clk75out = clkout75int;
assign clk76out = clkout76int;			
assign clk77out = clkout77int;
assign clk78out = clkout78int;
assign clk79out = clkout79int;
assign clk80out = clkout80int;
assign clk81out = clkout81int;
assign clk82out = clkout82int;
assign clk83out = clkout83int;
assign clk84out = clkout84int;
assign clk85out = clkout85int;
assign clk86out = clkout86int;			
assign clk87out = clkout87int;
assign clk88out = clkout88int;
assign clk89out = clkout89int;
assign clk90out = clkout90int;
assign clk91out = clkout91int;
assign clk92out = clkout92int;
assign clk93out = clkout93int;
assign clk94out = clkout94int;
assign clk95out = clkout95int;
assign clk96out = clkout96int;			
assign clk97out = clkout97int;
assign clk98out = clkout98int;
assign clk99out = clkout99int;
assign clk100out = clkout100int;	
assign clk101out = clkout101int;
assign clk102out = clkout102int;
assign clk103out = clkout103int;
assign clk104out = clkout104int;
assign clk105out = clkout105int;
assign clk106out = clkout106int;
assign clk107out = clkout107int;
assign clk108out = clkout108int;
assign clk109out = clkout109int;
assign clk110out = clkout110int;
assign clk111out = clkout111int;
assign clk112out = clkout112int;
assign clk113out = clkout113int;
assign clk114out = clkout114int;
assign clk115out = clkout115int;
assign clk116out = clkout116int;
assign clk117out = clkout117int;
assign clk118out = clkout118int;
assign clk119out = clkout119int;
assign clk120out = clkout120int;
assign clk121out = clkout121int;
assign clk122out = clkout122int;
assign clk123out = clkout123int;
assign clk124out = clkout124int;
assign clk125out = clkout125int;
assign clk126out = clkout126int;
assign clk127out = clkout127int;
			         
						

endmodule //End Of Module multi - phase