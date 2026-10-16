Class {
	#name : 'MyBoardBoundaryTest',
	#superclass : 'TestCase',
	#category : 'Myg-Chess-Tests',
	#package : 'Myg-Chess-Tests'
}

{ #category : 'tests' }
MyBoardBoundaryTest >> testCornerPiecesHaveExactlyTheExistingDestinations [

	{
		{ MyPawn. #('a2'). #('h7') }.
		{ MyKnight. #('b3' 'c2'). #('f7' 'g6') }.
		{ MyKing. #('a2' 'b1' 'b2'). #('g7' 'g8' 'h7') }.
		{ MyBishop. #('b2' 'c3' 'd4' 'e5' 'f6' 'g7' 'h8'). #('a1' 'b2' 'c3' 'd4' 'e5' 'f6' 'g7') }.
		{ MyRook. #('a2' 'a3' 'a4' 'a5' 'a6' 'a7' 'a8' 'b1' 'c1' 'd1' 'e1' 'f1' 'g1' 'h1').
			#('a8' 'b8' 'c8' 'd8' 'e8' 'f8' 'g8' 'h1' 'h2' 'h3' 'h4' 'h5' 'h6' 'h7') }.
		{ MyQueen. #('a2' 'a3' 'a4' 'a5' 'a6' 'a7' 'a8' 'b1' 'c1' 'd1' 'e1' 'f1' 'g1' 'h1' 'b2' 'c3' 'd4' 'e5' 'f6' 'g7' 'h8').
			#('a8' 'b8' 'c8' 'd8' 'e8' 'f8' 'g8' 'h1' 'h2' 'h3' 'h4' 'h5' 'h6' 'h7' 'a1' 'b2' 'c3' 'd4' 'e5' 'f6' 'g7') }
	} do: [ :example |
		{ #('a1' 2). #('h8' 3) } do: [ :corner |
			| board piece expected |
			board := MyChessBoard empty.
			piece := corner first = 'a1'
				ifTrue: [ example first white ]
				ifFalse: [ example first black ].
			board at: corner first put: piece.
			expected := example at: corner second.
			self assert: (piece legalTargetSquares collect: #name) asSortedCollection asArray
				equals: expected asSortedCollection asArray.
			self assert: (piece attackingSquares allSatisfy: #isOnBoard) ] ]
]

{ #category : 'tests' }
MyBoardBoundaryTest >> testOffBoardNavigationCannotReenterOrPlayAMove [

	| game board outside pawn |
	game := MyChessGame freshGame.
	board := game pieces first board.
	pawn := (board at: 'a2') contents.
	outside := (board at: 'a1') left.
	self deny: outside isOnBoard.
	self assert: outside right up identicalTo: outside.
	self assert: outside + (1 @ 1) identicalTo: outside.
	self deny: (board at: 'z9') isOnBoard.
	self assert: (board at: 'a3') isOnBoard.
	self deny: (board at: 'a3') hasPiece.
	self deny: (game move: pawn to: outside).
	self deny: (game moveInteractively: pawn to: outside).
	self assert: (board at: 'a2') contents identicalTo: pawn.
	self assert: game moveHistory isEmpty.
	self assert: game currentPlayer isWhite.
	self assert: game moveCount equals: 1
]
