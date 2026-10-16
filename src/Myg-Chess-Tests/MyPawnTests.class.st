Class {
	#name : 'MyPawnTests',
	#superclass : 'TestCase',
	#category : 'Myg-Chess-Tests',
	#package : 'Myg-Chess-Tests'
}

{ #category : 'tests - support' }
MyPawnTests >> assertAttacksOf: aPawn equal: squareNames [

	self
		assert: (aPawn attackingSquares collect: #name) asSortedCollection asArray
		equals: squareNames asSortedCollection asArray
]

{ #category : 'tests - support' }
MyPawnTests >> assertTargetsOf: aPawn equal: squareNames [

	self
		assert: (aPawn legalTargetSquares collect: #name) asSortedCollection asArray
		equals: squareNames asSortedCollection asArray
]

{ #category : 'tests' }
MyPawnTests >> testAttacksAreDiagonalRegardlessOfOccupancy [
	| board white black |
	board := MyChessBoard empty.
	board at: 'b2' put: (white := MyPawn white).
	board at: 'g7' put: (black := MyPawn black).
	self assertTargetsOf: white equal: #('b3' 'b4').
	self assertTargetsOf: black equal: #('g6' 'g5').
	self assertAttacksOf: white equal: #('a3' 'c3').
	self assertAttacksOf: black equal: #('f6' 'h6').
	board at: 'b3' put: MyRook black.
	board at: 'a3' put: MyRook white.
	board at: 'c3' put: MyRook black.
	board at: 'g6' put: MyRook white.
	board at: 'f6' put: MyRook black.
	board at: 'h6' put: MyRook white.
	self assertAttacksOf: white equal: #('a3' 'c3').
	self assertAttacksOf: black equal: #('f6' 'h6')
]

{ #category : 'tests' }
MyPawnTests >> testBlockedSecondSquareStillAllowsOneStep [
	{ Color white. Color black } do: [ :obstacleColor |
	 | board white black |
	 board := MyChessBoard empty.
	 board at: 'b2' put: (white := MyPawn white).
	 board at: 'g7' put: (black := MyPawn black).
	 board at: 'b4' put: (MyRook new color: obstacleColor).
	 board at: 'g5' put: (MyRook new color: obstacleColor).
	 self assertTargetsOf: white equal: #('b3').
	 self assertTargetsOf: black equal: #('g6') ]
]

{ #category : 'tests' }
MyPawnTests >> testBothBoardEdgesKeepOnlyExistingDiagonal [
	| board whiteLeft whiteRight blackLeft blackRight |
	board := MyChessBoard empty.
	board at: 'a2' put: (whiteLeft := MyPawn white).
	board at: 'h2' put: (whiteRight := MyPawn white).
	board at: 'a7' put: (blackLeft := MyPawn black).
	board at: 'h7' put: (blackRight := MyPawn black).
	board at: 'b3' put: MyRook black.
	board at: 'g3' put: MyRook black.
	board at: 'b6' put: MyRook white.
	board at: 'g6' put: MyRook white.
	self assertTargetsOf: whiteLeft equal: #('a3' 'a4' 'b3').
	self assertTargetsOf: whiteRight equal: #('h3' 'h4' 'g3').
	self assertTargetsOf: blackLeft equal: #('a6' 'a5' 'b6').
	self assertTargetsOf: blackRight equal: #('h6' 'h5' 'g6').
	self assertAttacksOf: whiteLeft equal: #('b3').
	self assertAttacksOf: whiteRight equal: #('g3').
	self assertAttacksOf: blackLeft equal: #('b6').
	self assertAttacksOf: blackRight equal: #('g6')
]

{ #category : 'tests' }
MyPawnTests >> testDiagonalCaptureMovesPawnAndReplacesEnemy [
	| board white black |
	board := MyChessBoard empty.
	board at: 'b2' put: (white := MyPawn white).
	board at: 'g7' put: (black := MyPawn black).
	board at: 'a3' put: MyRook black.
	board at: 'c3' put: MyRook black.
	board at: 'f6' put: MyRook white.
	board at: 'h6' put: MyRook white.
	self assertTargetsOf: white equal: #('b3' 'b4' 'a3' 'c3').
	self assertTargetsOf: black equal: #('g6' 'g5' 'f6' 'h6').
	self assert: (white moveTo: (board at: 'a3')).
	self assert: (black moveTo: (board at: 'f6')).
	self deny: (board at: 'b2') hasPiece.
	self deny: (board at: 'g7') hasPiece.
	self assert: (board at: 'a3') contents identicalTo: white.
	self assert: white square identicalTo: (board at: 'a3').
	self assert: (board at: 'f6') contents identicalTo: black.
	self assert: black square identicalTo: (board at: 'f6')
]

{ #category : 'tests' }
MyPawnTests >> testEnPassantCannotExposeOwnKing [

	| game board pawn victim before |
	game := MyChessGame fromFENString: '7k/8/8/r4pPK/8/8/8/8 w - f6 0 1'.
	board := game pieces first board.
	pawn := (board at: 'g5') contents.
	victim := (board at: 'f5') contents.
	before := board pieces copy.
	self assertTargetsOf: pawn equal: #('g6').
	self deny: (game move: pawn to: (board at: 'f6')).
	self assert: board pieces equals: before.
	self assert: (board at: 'g5') contents identicalTo: pawn.
	self assert: (board at: 'f5') contents identicalTo: victim.
	self deny: (board at: 'f6') hasPiece.
	self assert: game moveHistory isEmpty.
	self assert: game currentPlayer isWhite.
	self assert: board enPassantTargetSquare identicalTo: (board at: 'f6')
]

{ #category : 'tests' }
MyPawnTests >> testEnPassantCaptureForBothColorsAfterDoubleAdvance [

	{
		#('7k/3p4/8/4P3/8/8/8/K7 b - - 0 1' 'd7' 'd5' 'e5' 'd6' 'e6' ' Pd5' '2. Pd6').
		#('7k/8/8/8/4p3/8/3P4/K7 w - - 0 1' 'd2' 'd4' 'e4' 'd3' 'e3' '1. Pd4' ' Pd3')
	} do: [ :example |
		| game board capturingPawn capturedPawn |
		game := MyChessGame fromFENString: example first.
		board := game pieces first board.
		capturingPawn := (board at: (example at: 4)) contents.
		capturedPawn := (board at: (example at: 2)) contents.
		self assert: (game move: capturedPawn to: (board at: (example at: 3))).
		self assertTargetsOf: capturingPawn equal: { example at: 5. example at: 6 }.
		(board at: (example at: 4)) click.
		self assert: ((board children select: #isTargetHighlighted) collect: #name) asSortedCollection asArray
			equals: { example at: 5. example at: 6 } asSortedCollection asArray.
		(board at: (example at: 5)) click.
		self assert: (board at: (example at: 5)) contents identicalTo: capturingPawn.
		self deny: (board at: (example at: 3)) hasPiece.
		self deny: (board at: (example at: 4)) hasPiece.
		self deny: (board pieces includes: capturedPawn).
		self assert: board enPassantTargetSquare isNil.
		self assert: (board children select: #isTargetHighlighted) isEmpty.
		self assert: game currentPlayer isWhite equals: capturedPawn isWhite.
		self assert: game moveHistory equals: { example at: 7. example at: 8 } asOrderedCollection ]
]

{ #category : 'tests' }
MyPawnTests >> testEnPassantFromFENRequiresAnAdjacentEnemyPawn [

	{
		#('7k/8/8/3pP3/8/8/8/K7 w - d6 0 1' 'e5' 'd6' 'd5' 'e6').
		#('7k/8/8/8/3Pp3/8/8/K7 b - d3 0 1' 'e4' 'd3' 'd4' 'e3')
	} do: [ :example |
		| game board pawn |
		game := MyChessGame fromFENString: example first.
		board := game pieces first board.
		pawn := (board at: (example at: 2)) contents.
		self assertTargetsOf: pawn equal: { example at: 3. example at: 5 }.
		self assert: (game move: pawn to: (board at: (example at: 3))).
		self deny: (board at: (example at: 4)) hasPiece.
		self assert: (board at: (example at: 3)) contents identicalTo: pawn ].
	#('7k/8/8/4P3/8/8/8/K7 w - d6 0 1'
	  '7k/8/8/3PP3/8/8/8/K7 w - d6 0 1'
	  '7k/8/8/3rP3/8/8/8/K7 w - d6 0 1') do: [ :fen |
		| game board pawn |
		game := MyChessGame fromFENString: fen.
		board := game pieces first board.
		pawn := (board at: 'e5') contents.
		self assertTargetsOf: pawn equal: #('e6').
		self deny: (game move: pawn to: (board at: 'd6')).
		self assert: game moveHistory isEmpty ]
]

{ #category : 'tests' }
MyPawnTests >> testEnPassantOpportunitySurvivesRejectionButExpiresAfterAnotherMove [

	| game board pawn |
	game := MyChessGame fromFENString: '7k/3p4/8/4P3/8/8/8/K7 b - - 0 1'.
	board := game pieces first board.
	pawn := (board at: 'e5') contents.
	self assert: (game move: (board at: 'd7') contents to: (board at: 'd5')).
	self deny: (game move: pawn to: (board at: 'e7')).
	self assertTargetsOf: pawn equal: #('d6' 'e6').
	self assert: game currentPlayer isWhite.
	self assert: game moveHistory equals: #(' Pd5') asOrderedCollection.
	self assert: (game move: (board at: 'a1') contents to: (board at: 'a2')).
	self assert: board enPassantTargetSquare isNil.
	self assert: (game move: (board at: 'h8') contents to: (board at: 'h7')).
	self assertTargetsOf: pawn equal: #('e6').
	self deny: (game move: pawn to: (board at: 'd6')).
	self assert: (board at: 'e5') contents identicalTo: pawn.
	self assert: (board at: 'd5') hasPiece.
	self assert: game moveHistory equals: #(' Pd5' '2. Ka2' ' Kh7') asOrderedCollection
]

{ #category : 'tests' }
MyPawnTests >> testForwardBlockPreventsMovingOrCapturing [
	{ Color white. Color black } do: [ :obstacleColor |
	 | board white black first second |
	 board := MyChessBoard empty.
	 board at: 'b2' put: (white := MyPawn white).
	 board at: 'g7' put: (black := MyPawn black).
	 board at: 'b3' put: (first := MyRook new color: obstacleColor).
	 board at: 'g6' put: (second := MyRook new color: obstacleColor).
	 self assertTargetsOf: white equal: #().
	 self assertTargetsOf: black equal: #().
	 self deny: (white moveTo: (board at: 'b3')).
	 self deny: (black moveTo: (board at: 'g6')).
	 self assert: (board at: 'b2') contents identicalTo: white.
	 self assert: white square identicalTo: (board at: 'b2').
	 self assert: (board at: 'g7') contents identicalTo: black.
	 self assert: black square identicalTo: (board at: 'g7').
	 self assert: (board at: 'b3') contents identicalTo: first.
	 self assert: (board at: 'g6') contents identicalTo: second ]
]

{ #category : 'tests' }
MyPawnTests >> testFriendlyDiagonalPiecesCannotBeCaptured [
	| board white black |
	board := MyChessBoard empty.
	board at: 'b2' put: (white := MyPawn white).
	board at: 'g7' put: (black := MyPawn black).
	board at: 'a3' put: MyRook white.
	board at: 'c3' put: MyRook white.
	board at: 'f6' put: MyRook black.
	board at: 'h6' put: MyRook black.
	self assertTargetsOf: white equal: #('b3' 'b4').
	self assertTargetsOf: black equal: #('g6' 'g5')
]

{ #category : 'tests' }
MyPawnTests >> testInitialMoveAndLaterSingleMoveForBothColors [
	| board white black |
	board := MyChessBoard empty.
	board at: 'b2' put: (white := MyPawn white).
	board at: 'g7' put: (black := MyPawn black).
	self assertTargetsOf: white equal: #('b3' 'b4').
	self assertTargetsOf: black equal: #('g6' 'g5').
	self assert: (white moveTo: (board at: 'b4')).
	self assert: (black moveTo: (board at: 'g5')).
	self assertTargetsOf: white equal: #('b5').
	self assertTargetsOf: black equal: #('g4').
	self deny: (board at: 'b2') hasPiece.
	self deny: (board at: 'g7') hasPiece.
	self assert: (board at: 'b4') contents identicalTo: white.
	self assert: white square identicalTo: (board at: 'b4').
	self assert: (board at: 'g5') contents identicalTo: black.
	self assert: black square identicalTo: (board at: 'g5').
	board at: 'c4' put: (white := MyPawn white).
	board at: 'f5' put: (black := MyPawn black).
	self assertTargetsOf: white equal: #('c5').
	self assertTargetsOf: black equal: #('f4')
]

{ #category : 'tests' }
MyPawnTests >> testPawnAtFinalRankHasNoPawnMovesOrAttacks [
	| board white black |
	board := MyChessBoard empty.
	board at: 'e8' put: (white := MyPawn white).
	board at: 'e1' put: (black := MyPawn black).
	self assertTargetsOf: white equal: #().
	self assertTargetsOf: black equal: #().
	self assertAttacksOf: white equal: #().
	self assertAttacksOf: black equal: #()
]
