Class {
	#name : 'MyPieceRenderingTest',
	#superclass : 'TestCase',
	#category : 'Myg-Chess-Tests',
	#package : 'Myg-Chess-Tests'
}

{ #category : 'tests' }
MyPieceRenderingTest >> testPieceSymbolsForBothPieceAndSquareColors [

	| whiteSquare blackSquare whitePiece blackPiece |
	whiteSquare := MyChessSquare white.
	blackSquare := MyChessSquare black.
	{ MyPawn -> #('P' 'p' 'O' 'o').
	  MyRook -> #('R' 'r' 'T' 't').
	  MyKnight -> #('N' 'n' 'M' 'm').
	  MyBishop -> #('B' 'b' 'V' 'v').
	  MyQueen -> #('Q' 'q' 'W' 'w').
	  MyKing -> #('K' 'k' 'L' 'l') } do: [ :example |
		whitePiece := example key white.
		blackPiece := example key black.
		self assert: (whitePiece renderPieceOn: whiteSquare) equals: (example value at: 1).
		self assert: (whitePiece renderPieceOn: blackSquare) equals: (example value at: 2).
		self assert: (blackPiece renderPieceOn: whiteSquare) equals: (example value at: 3).
		self assert: (blackPiece renderPieceOn: blackSquare) equals: (example value at: 4) ]
]
