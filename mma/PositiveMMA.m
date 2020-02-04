(* ::Package:: *)

(************************************************************************)
(* This file was generated automatically by the Mathematica front end.  *)
(* It contains Initialization cells from a Notebook file, which         *)
(* typically will have the same name as this file except ending in      *)
(* ".nb" instead of ".m".                                               *)
(*                                                                      *)
(* This file is intended to be loaded into the Mathematica kernel using *)
(* the package loading commands Get or Needs.  Doing so is equivalent   *)
(* to using the Evaluate Initialization Cells menu command in the front *)
(* end.                                                                 *)
(*                                                                      *)
(* DO NOT EDIT THIS FILE.  This entire file is regenerated              *)
(* automatically each time the parent Notebook file is saved in the     *)
(* Mathematica front end.  Any changes you make to this file will be    *)
(* overwritten.                                                         *)
(************************************************************************)




(* Method to relabel index of infinite sum such that there is no external power explicit *)
StandardizeSumPower::usage="Given a single sum, write exponent relative to a single power";

(*Method to put sum prefector inside sigma*)
StandardizeSumTerm::usage="Method to put sum prefector inside sigma";

(* Method to standardize all terms in multiple sum expression *)
StandardizeSumTerms::usage="Method to standardize all terms in multiple sum expression";

(* Given a sum of the form \!\(
\*UnderoverscriptBox[\(\[Sum]\), \(n = 0\), \(\[Infinity]\)]\(
\*SuperscriptBox[\(\[Xi]\), \(n\)]\ d[n]\)\), take its derivative such that the correct minimum index is used *)
DerivativeOfSimpleSum::usage="Given a sum of the form \!\(\*UnderoverscriptBox[\(\[Sum]\), \(n = 0\), \(\[Infinity]\)]\)\!\(\*SuperscriptBox[\(\[Xi]\), \(n\)]\) d[n], take its derivative such that the correct minimum index is used";

(* Given linear differential equation with known singular points, determine singular exponents *)
DeriveIndicialSolutions::usage="Given linear differential equation with known singular points, determine singular exponents."

(* Keep largest exponent terms in a sum *)
TakeLargestExponent::usage="Keep largest exponent terms in a sum"

(* Make approximations using in the WKB way *)
WKBApproximate::usage="Make approximations using in the WKB way"

(* Create list of derivatives up to a given order *)
TableD::usage="Create list of derivatives up to a given order"

(* Create rule to replace derivatives *)
MapRuleD::usage="Create rule to replace derivatives"

(* Simplfy terms independently *)
CoeffSimplify::usage="Simplfy terms independently"

(* FullSimplfy terms independently *)
CoeffFullSimplify::usage="FullSimplfy terms independently"

(* Simplfy a product using Log *)
LogSimplify::usage="Simplfy a product using Log"

(* Simplfy terms independently *)
CollectSimplify::usage="Wrapper for CoeffSimplify"
CollectFullSimplify::usage="Wrapper for CoeffFullSimplify"

(* Commutator for methods with one input *)
Commutator::usage="Commutator[A,B,Y] = (AB-BA)Y"

(* Given a Riccati equation (expressiion that hould equal zero), linearize it *)
RiccatiLinearize::usage="Given a Riccati equation (expressiion that hould equal zero), linearize it"

(* Method to compute adjoint of linear differential operator *)
Adjoint::usage="Method to compute adjoint of linear differential operator"

(* Elegant function to return python string of MMA expressions *)
PythonForm::usage="Elegant function to return python string of MMA expressions"
PyForm::usage="Elegant function to return python string of MMA expressions"

(* Method to determine highest derivative order in expression *)
MaxD::usage="Method to determine highest derivative order in expression"



(* Method to determine highest derivative order in expression *)
Remove[MaxD]; 
MaxD[Expression_,F_,var_]:=Module[
	(* Internals *)
	{Answer,Done,n,k,HasOrder,ExpressionVars},
	ExpressionVars = Variables[Expression];
	Answer = 0; k = 0;
	Done = False;
	While[ !Done,
		HasOrder = MemberQ[ExpressionVars,D[F,{var,k}]];
		If[HasOrder,Answer=k];
		Done = !HasOrder;
		k++
	];
	Return[Answer];
]


Remove[TakeLargestExponent];
TakeLargestExponent[Terms_,var_]:=Module[
	{Ans,MaxDeg,Terms2},
	(* Define holder for output *)
	Terms2 = Terms;
	(* Find largest exponent *)
	MaxDeg = Max@Table[ Exponent[Terms[[k]],var], {k,Length[Terms]} ];
	(* *)
	Do[
		If[Exponent[Terms[[j]][[k]],var] != MaxDeg,
			(*Remove the term*)
			Terms2[[j]][[k]]=0;
		];
		,
		{j,Length[Terms]},{k,Length[Terms[[j]]]}
	];
	(* Handle constant numerical entries in Terms *)
	Do[
		If[Length[Terms[[j]]] == 0,
			(*Remove the term*)
			Terms2[[j]]=0;
		];
		,
		{j,Length[Terms]}
	];
	Ans = Simplify@Terms2;
	Return[Ans]
]


(* Method to relabel index of infinite sum such that there is no external power explicit *)
Remove[StandardizeSumPower];
StandardizeSumPower[SumPart_,var_:v]:=Module[
	(* Internals *)
	{Ans,NewSumPart,OldPwr,OldDex,OldMinDex,OldMaxDex,NewDex,
	NewSumPart1,NewSumPart2,NewMinDex,NewMaxDex,OldDexRule},
	(* Extract Info from Sum *)
	{OldDex,OldMinDex,OldMaxDex} = SumPart[[2]];
	OldPwr = Exponent[SumPart[[1]],var];
	NewSumPart = SumPart;
	(* If needed, adjust labels and limits *)
	If[Simplify[OldPwr==OldDex],
		(* Do Nothing *)
		Ans = SumPart,
		(* Do Things *)
		OldDexRule = Solve[  NewDex == OldPwr, OldDex][[1]];
		NewSumPart1 = SumPart[[1]]/.OldDexRule;
		NewMinDex = OldMinDex+OldPwr-OldDex;
		NewMaxDex = OldMaxDex+OldPwr-OldDex; (* Only works for infinite sums anyway! *)
		NewSumPart2 = {NewDex,NewMinDex,NewMaxDex};
		NewSumPart[[1]] = NewSumPart1;
		NewSumPart[[2]] = NewSumPart2;
		Ans = NewSumPart/.{NewDex->OldDex};
	];
	Return[Ans];
]
(* Method to put sum prefector inside sigma *)
Remove[StandardizeSumTerm];
StandardizeSumTerm[Term_,var_:v]:=Module[ {Ans,SumPart,PreFact ,NewSumPart,NewPreFact,Limits,Pwr,OldDex,NewDex},
	SumPart = Term[[-1]]; PreFact = Term[[1;;-2]];
	NewSumPart = Simplify[SumPart[[1]] PreFact]; NewPreFact =  1;
	Ans = Term; Limits = SumPart[[2]];
	Ans[[-1]][[1]] = NewSumPart; Ans[[1;;-2]] = NewPreFact;
	Limits = Ans[[-1]][[2]];
	(* Standardize power label *)
	Ans = StandardizeSumPower[Ans,var];
	(*Print[Term,"  -->  ",Ans];*)
	Return[Ans]
]
(* Method to standardize all terms in multiple sum expression *)
Remove[StandardizeSumTerms];
StandardizeSumTerms[Terms_,var_:v]:=Module[ {Ans,ExpandedTerms},
	ExpandedTerms = Expand@Terms;
	Ans = ExpandedTerms;
	Table[ Ans[[INDEX]] = StandardizeSumTerm[ExpandedTerms[[INDEX]],var];, {INDEX,Length[ExpandedTerms]} ];
	Return[Ans];
]
(* Given a sum of the form \!\(
\*UnderoverscriptBox[\(\[Sum]\), \(n = 0\), \(\[Infinity]\)]\(
\*SuperscriptBox[\(\[Xi]\), \(n\)]\ d[n]\)\), take its derivative such that the correct minimum index is used *)
Remove[DerivativeOfSimpleSum];
DerivativeOfSimpleSum[S_,DInputs_:None]:=Module[

	(* Internals *)
	{Answer,RawDS,Order,dex,min,max,var,MinDex},

	(* Determine the correct minimum index *)
	RawDS = D[S,DInputs];
	{dex,min,max} = S[[2]];
	var = S[[1]]/.{dex ->1}/.{_[1]->1};
	Order = Exponent[RawDS[[1]],var];
	MinDex = dex/.Solve[Order==0,dex][[1]];
	
	(* Apply the correct minimum index to the sum *)
	Answer = RawDS;
	Answer[[2]][[2]] = MinDex;

	(* Return *)
	Return[Answer];

]
(*(* Simplify coefficients of power expansion in select variable *)
Remove[CoeffSimplify];
CoeffSimplify[A_,var_]:=Module[
	(* Define Internal Vars *)
	{ans,MaxPow,A1,A2,A3,Coeffs},
	
	(* Determine Max Power in desired variable *)
	MaxPow = Exponent[A,var];
	(* Find corresponding Series Expansion *)
	A1 = Normal@Series[A,{var,0,MaxPow+1}];
	(* FullSimplify each term *)
	A2 = A1;
	Coeffs = CoefficientList[A1,var];
	A2 = Sum[FullSimplify[Coeffs[[k]] var^(k-1) ],{k,MaxPow+1}];
	ans = FullSimplify[A2];
	(* Return Answer *)
	Return[ans];
]*)


Remove[DeriveIndicialSolutions];
Options[DeriveIndicialSolutions] = {PreScale->1};
DeriveIndicialSolutions[Dy_,y_,x_,SingularPoints_,order_:2,f_:f,opts:OptionsPattern[]]:=Module[

	(* Internal variables *)
	{Ans,SingularScale,xSingular,SingularIndex,xRef,IndicialSolution,
	yTest,yDelta,TestDy,IndicialPolynomial,g,IndEqnK,SingularExponent},
	
	(*Determine a singular scaling for the solution ansatz*)
	SingularScale = OptionValue[PreScale]; SingularIndex = {}; yDelta = 1;
	Do[
		(* Create expressions for singular indices *)
		SingularIndex = Join[SingularIndex,{ToExpression["k"<>ToString[k]]}];
		(* Construct singular scaling based on singular points and indices *)
		xSingular = SingularPoints[[k]];
		SingularScale = (x-xSingular)^SingularIndex[[k]] SingularScale;
		yDelta = (x-xSingular) yDelta;
		, 
		{k,Length[SingularPoints]}
	];
	
	(* Write series solution ansatz *)
	xRef = SingularPoints[[1]];
	g = Sum[a[k](x-xRef )^k,{k,0,order}];
	yTest = SingularScale g;
	
	(* Apply ansatz, and then determine indicial polynomial *)
	TestDy = Dy/.Table[D[y[x],{x,k}]->D[yTest,{x,k}],{k,0,order}];
	
	(* The Indicial Polynomial is determine by enforcing that the 
	solution is regular at the singular points. This is equivalent 
	to enforcing that the leading coefficient of the solution's series
	expansion is zero at the singular points. This latter condition 
	yields the indicial equation(s). *)
	IndicialPolynomial = Simplify[(yDelta/SingularScale)Coefficient[TestDy,a[0]]];
	
	(* Solve indicial equation at evenery singular point *)
	SingularExponent = {};
	Do[
		xSingular = SingularPoints[[k]];
		IndEqnK = (IndicialPolynomial/.{x -> xSingular})==0;
		IndicialSolution = Solve[ IndEqnK, SingularIndex[[k]] ];
		SingularExponent = Join[SingularExponent,{IndicialSolution}];
		, 
		{k,Length[SingularPoints]}
	];
	
	(* Return answer: The singular exponents and the singular scale function and associated Delta quantity *)
	Ans = Join[{SingularExponent},{ SingularScale f[x] }];
	Return[Ans];
]


Remove[DeriveIndicialSolutions2];
DeriveIndicialSolutions2[DyFunctions_,y_,x_,SingularPoints_,f_:f]:=Module[
	
	(* Internal variables *)
	{Ans,p,SingularScale,xSingular,SingularIndex,IndicialSolution,Dy,IndicialEquation,
	A,B,C1,C2,Delta,V,IndEqnK,SingularExponent,TestDy,yTest,xRef,Df},
	
	(* Check for correct 1st input format *)
	Catch[
		If[ Simplify[4==Length[DyFunctions]],
			(* Unpack *)
			{A,B,C1,C2} = DyFunctions;
			, (* Otherwise *)
			Print["
				ERROR: The first input should be a table of 4 functions of the dependent variable. 
				These functions, {A,B,C1,C2}, should correspond to a differential equation of the form
				----------------------------------------------------------------------------------------
				Dy = (C1[x]+\!\(\*FractionBox[\(C2[x]\), \(Delta[x]\)]\)) y[x]+B[x] \!\(\*SuperscriptBox[\(y\), \(\[Prime]\),\nMultilineFunction->None]\)[x]+Delta[x] A[x] \!\(\*SuperscriptBox[\(y\), \(\[Prime]\[Prime]\),\nMultilineFunction->None]\)[x]
				----------------------------------------------------------------------------------------
				Where Delta[x] is the product of x minus all singular pionts: (x-x1)(x-x2)...(x-xN).
			"];
			Return[{0,0}];
		];
	];
	
	(* Use DyFunctions to construct the differential equation *)
	Delta = 1;
	Do[
		xSingular = SingularPoints[[k]];
		Delta = Delta (x-xSingular);
		,
		{k,Length[SingularPoints]}
	];
	(* Define a list containing the coefficitents of the defferential equation *)
	p = {  C1+C2/Delta, B, Delta A };
	
	(* Construct the differential equation *)
	Dy =Sum[p[[k]]D[y[x],{x,k-1}],{k,Length[p]}];
	
	(*Determine a singular scaling for the solution ansatz*)
	SingularScale = 1; SingularIndex = {};
	Do[
		(* Create expressions for singular indices *)
		SingularIndex = Join[SingularIndex,{ToExpression["k"<>ToString[k]]}];
		(* Construct singular scaling based on singular points and indices *)
		xSingular = SingularPoints[[k]];
		SingularScale = (x-xSingular)^SingularIndex[[k]] SingularScale;
		, 
		{k,Length[SingularPoints]}
	];
	
	(* Apply test ansatz to differential equation *)
	yTest = SingularScale f[x];
	TestDy = Simplify[
				Dy  /.  Table[ D[y[x],{x,k-1}]-> D[yTest,{x,k-1}], {k,Length[p]} ]
			 ];
	(* Derive indicial polynomial *)
	Df = Collect[Simplify[(Delta/SingularScale)TestDy],{Derivative[1][f][x],f[x]}];
	p = Simplify@Coefficient[Df,Table[D[f[x],{x,k-1}],{k,Length[p]}]];
	(* We wish to define the trasformed potential, V = p[[1]], so that it is zero
	   at the singular points. *)
	V = p[[1]];
	(* Solve indicial equation at evenery singular point *)
	SingularExponent = {};
	IndicialEquation = {};
	Do[
		xSingular = SingularPoints[[k]];
		IndEqnK = (V/.{x -> xSingular})==0;
		IndicialSolution = Solve[ IndEqnK, SingularIndex[[k]] ];
		SingularExponent = Join[SingularExponent,{IndicialSolution}];
		, 
		{k,Length[SingularPoints]}
	];
	
	
	(* Return answer *)
	Ans = Join[{SingularExponent},{ SingularScale f[x] }];
	Return[Ans];
	
]


Remove[PythonForm,PyForm];
(* Elegant function to return python string of MMA expressions *)
PythonForm[A_]:=Module[
	{Answer},
	(* Handle complex numbers *)
	Answer = StringReplace[ToString[InputForm[A]],{"^"->"**","I"->"1j"}];
	(* Handle Pi *)
	Answer = StringReplace[Answer,{"Pi"->"pi"}];
	(* Handle Exp[X] *)
	Answer = StringReplace[Answer,{"E**"->"exp"}];
	(* Handle Floor[X] *)
	Answer = StringReplace[Answer,{"Floor"->"floor"}];
	(* Handle Arg[X] *)
	Answer = StringReplace[Answer,{"Arg"->"angle"}];
	(* Handle Abs[X] *)
	Answer = StringReplace[Answer,{"Abs"->"abs"}];
	(* Handle Sign[X] *)
	Answer = StringReplace[Answer,{"Sign"->"sign"}];
	(* Handle Sqrt[X] *)
	Answer = StringReplace[Answer,{"Sqrt"->"sqrt"}];
	(* Handle ArcTanh[X] *)
	Answer = StringReplace[Answer,{"ArcTanh"->"arctanh"}];
	(* Handle Tanh[X] *)
	Answer = StringReplace[Answer,{"Tanh"->"tanh"}];
	(* Handle [ and ] *)
	Answer = StringReplace[Answer,{"["->"(","]"->")"}];
	(* Handle division *)
	Answer = StringReplace[Answer,{"/"->"*1.0/"}];
	Return[Answer];
]
PyForm[A_]:=Module[
	{Answer},
	Answer = PythonForm[A];
	Return[Answer];
]


(* Create list of derivatives up to a given order *)
Remove[TableD];
TableD[F_,var_,order_:2]:=Module[
	(* Internals *)
	{Ans},
	(* Create table of derivatives *)
	Ans = Table[
				D[F,{var,kkk-1}]
				,{kkk,order+1}
			];
	Return[Ans];
]

(*(* Simplify a product using log *)
Clear[LogSimplify];
LogSimplify[X_,XAssumptions_:{k\[GreaterEqual]1/2,Abs[m]\[LessEqual]k,k\[GreaterEqual]Abs[s],k\[Element]Integers,m\[Element]Integers,s\[Element]Integers}] :=Simplify[
							Exp@Expand@PowerExpand[Log[X],Assumptions\[Rule]XAssumptions]
															//.{(Sqrt[a_]Sqrt[b_])/c_\[RuleDelayed]Sqrt[Factor[a b]]/c}
															//.{c_/(Sqrt[a_]Sqrt[b_])\[RuleDelayed]c/Sqrt[Factor[a b]]}
															//.{a_/(b_ Sqrt[c_])\[RuleDelayed]a/(b Sqrt[Factor[c]])}
				]//.{a_/(b_ Sqrt[c_])\[RuleDelayed]a/(b Sqrt[Factor[c]])}//.{a_/b_\[RuleDelayed]a/Factor[b]}*)

(*(* Log simplify multiple terms *)
Remove[LogSimplify];
LogSimplify[X_,XAssumptions_:{k\[GreaterEqual]1/2,Abs[m]\[LessEqual]k,k\[GreaterEqual]Abs[s],k\[Element]Integers,m\[Element]Integers,s\[Element]Integers}]:= Module[
	(* Internals *)
	{Ans},
	(* Return Answer *)
	Return[
		PowerExpand[X,Assumptions\[Rule]XAssumptions]
		//.{Sqrt[a_]Sqrt[b_]\[RuleDelayed]Sqrt[a b]}
		//.{Sqrt[a_]\[RuleDelayed]Sqrt[Factor[a]],1/Sqrt[a_]\[RuleDelayed]1/Sqrt[Factor[a]]}
	]
];*)

(* Log simplify multiple terms *)
Remove[LogSimplify];
LogSimplify[X_]:= Module[
	(* Internals *)
	{Ans},
	(* Return Answer *)
	Return[X]
];
				
(* Create rule to replace derivatives *)
Remove[MapRuleD];
MapRuleD[F_,G_,var_,order_:2]:=Module[
	(* Internals *)
	{Ans,kkk},
	(* Create table of derivatives *)
	Ans = Table[
				(*If[ (G[[0]]\[Equal]Sum),
					(* Use derivative of simple sum *)
					D[F,{var,kkk-1}]\[Rule]DerivativeOfSimpleSum[G,{var,kkk-1}]
					,
					(* Use standard derivative *)
					D[F,{var,kkk-1}]\[Rule]D[G,{var,kkk-1}]
				]*)
				D[F,{var,kkk-1}]->D[G,{var,kkk-1}]
				,{kkk,order+1}
			];
	Return[Ans];
]
(* Simplfy coefficients independently *)
Remove[CoeffSimplify];
CoeffSimplify[F_,vars_]:=Module[
	(* Internals *)
	{CollectedF,Ans},
	(* Create table of derivatives *)
	CollectedF = Collect[Simplify@F,vars];
	Ans = CollectedF;
	Table[
		Ans = Ans/.{
					Coefficient[CollectedF,vars[[kkkk]]] :> Simplify[Coefficient[CollectedF,vars[[kkkk]]]]
					};
		,{kkkk,Length[vars]}
	];
	Return[Ans];
]
(* FullSimplfy coefficients independently *)
Remove[CoeffFullSimplify];
CoeffFullSimplify[F_,vars_]:=Module[
	(* Internals *)
	{CollectedF,Ans},
	(* Create table of derivatives *)
	CollectedF = Collect[Simplify@F,vars];
	Ans = CollectedF;
	Table[
		Ans = Ans/.{
					Coefficient[CollectedF,vars[[kkkk]]] :> FullSimplify[Coefficient[CollectedF,vars[[kkkk]]]]
					};
		,{kkkk,Length[vars]}
	];
	Return[Ans];
]
(* FullSimplfy coefficients independently *)
Remove[CollectSimplify];
CollectSimplify[F_,vars_]:=Module[
	(* Internals *)
	{Ans},
	(* Wrap and return *)
	Return[CoeffSimplify[F,vars]];
]
(* FullSimplfy coefficients independently *)
Remove[CollectFullSimplify];
CollectFullSimplify[F_,vars_]:=Module[
	(* Internals *)
	{Ans},
	(* Wrap and return *)
	Return[CoeffFullSimplify[F,vars]];
]
(* Commutator for methods with one input *)
Remove[Commutator];
Commutator[A_,B_,Field_]:=Module[
	(* Internals *)
	{Ans},
	(* Calculate Commutator *)
	Ans = A[B[Field]] - B[A[Field]];
	Return[Simplify@Ans];
]
(* Linearize Riccati equation *)
Remove[RiccatiLinearize];
RiccatiLinearize[ L_, f_,fNew_, var_ ]:=Module[
	(* Internals *)
	{Answer,q2,q1,q0,q1d,c0,u,Q0,Q1,Q2,L1,LinearizedL,L3,\[Beta]Rule,\[Beta]},
	(* Shorthand *)
	u = var; \[Beta] = fNew;
	(* Initial prefactors of interest *)
	Q0 = {f'[u],f[u],f[u]^2};
	(* Collect terms *)
	{q1d,q1,q2} = Coefficient[L,Q0];
	(* Divide by derivate coefficient and recollect *)
	L1 = CoeffSimplify[L/q1d,Q0];
	{q1d,q1,q2} = Coefficient[L1,Q0];
	(* Deterine the term that is not proportial to a memer of Q0 *)
	q0 = Simplify[L1 - Total[{q1d,q1,q2}Q0]];
	(* Define the linearizing variable *)
	\[Beta]Rule = MapRuleD[f[u],1/q2 D[Log[\[Beta][u]],u],u];
	LinearizedL = CoeffSimplify[\[Beta][u] L1/.\[Beta]Rule,TableD[\[Beta][u],u]];
	LinearizedL = CoeffSimplify[LinearizedL*Denominator[Coefficient[LinearizedL,D[\[Beta][u],{u,2}]]],TableD[\[Beta][u],u]];
	Answer={\[Beta]Rule[[1]],LinearizedL};
	Return[Answer];
]
(* Method to compute adjoint of linear differential operator *)
Remove[Adjoint]; 
Adjoint[Df_,f_,var_,assumptions_:{},NoConj_:False]:=Module[
	(* Internal variables *)
	{Answer,Coeffs,AdjCoeffs,ReducedDf,TemplateConjCoeffs,TemplateAdjDf,QList,AdjDf,zzz,kkkk,OrderD},
	
	(* Make template *)
	OrderD = MaxD[Df,f,var]+1;
	ReducedDf = CoeffSimplify[Df,TableD[f,var,OrderD-1]];
	If[!Simplify[Df==ReducedDf],Print[Style["Error",Background->Red]]];
	TemplateConjCoeffs = Table[Symbol["Q" <> ToString@kkkk][var], {kkkk, OrderD}];
	
	(*  *)
	Coeffs = Coefficient[ReducedDf,TableD[f,var,OrderD-1]];
	
	(*  *)
	TemplateAdjDf = CoeffSimplify[
					Sum[ 
						Simplify[(-1)^zzz D[TemplateConjCoeffs[[zzz+1]] f,{var,zzz}]],
					    {zzz,0,Length[TemplateConjCoeffs]-1}
					],
					TableD[f,var,Length[Coeffs]]
			];
			
	(*  *)
	(*Print[TemplateConjCoeffs];
	Print[OrderD];
	Print[TableD[f,var,OrderD-1]];
	Print[Length[ReducedDf]];
	Print[ReducedDf];
	Print[Length[TemplateConjCoeffs]];
	Print[Length[TemplateConjCoeffs]];
	Print@Coeffs;
	Print@Length[Coeffs];*)
			
	(*  *)
	AdjDf = TemplateAdjDf
						/.Flatten[
						    Table[
								MapRuleD[TemplateConjCoeffs[[kkkk]],Refine[ Coeffs[[kkkk]],Assumptions->assumptions],var,OrderD],
								{kkkk,Length[Coeffs]}
						    ]
						  ];
						  
	(* Handle optional conjugation if reality is assumed *)
	AdjCoeffs = Coefficient[AdjDf,TableD[f,var,OrderD]];
	AdjDf = Total[ Table[ D[f,{var,kkk-1}] If[NoConj,AdjCoeffs[[kkk]],Conjugate[AdjCoeffs[[kkk]]]], {kkk,Length[AdjCoeffs]} ] ]; 
	
	(* Return answer *)
	Answer = CoeffSimplify[AdjDf,TableD[f,var,Length[Coeffs]]];
	Return[Answer];
]



