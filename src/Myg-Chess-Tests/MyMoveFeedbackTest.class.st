Class {
	#name : 'MyMoveFeedbackTest',
	#superclass : 'TestCase',
	#instVars : [
		'game',
		'board'
	],
	#category : 'Myg-Chess-Tests',
	#package : 'Myg-Chess-Tests'
}

{ #category : 'tests - support' }
MyMoveFeedbackTest >> highlightedSquareNames [

	^ (board children select: #isTargetHighlighted) collect: #name

]

{ #category : 'running' }
MyMoveFeedbackTest >> setUp [

	super setUp.
	game := MyChessGame freshGame.
	board := game pieces first board

]

{ #category : 'tests - support' }
MyMoveFeedbackTest >> setUpPinnedRook [

	board pieces do: [ :each | each square emptyContents ].
	board at: 'e1' put: MyKing white.
	board at: 'e2' put: MyRook white.
	board at: 'e8' put: MyRook black.
	board at: 'a8' put: MyKing black

]

{ #category : 'tests' }
MyMoveFeedbackTest >> testAcceptedClickClearsHighlightsAndRecordsOnce [

	| rook |
	self setUpPinnedRook.
	rook := (board at: 'e2') contents.
	(board at: 'e2') click.
	(board at: 'e3') click.
	self assert: self highlightedSquareNames isEmpty.
	self assert: game moveHistory equals: #('1. Re3') asOrderedCollection.
	self assert: (board at: 'e3') contents identicalTo: rook.
	self deny: (board at: 'e2') hasPiece.
	self deny: game currentPlayer isWhite.
	self assert: game moveCount equals: 1

]

{ #category : 'tests' }
MyMoveFeedbackTest >> testAcceptedMovesAlternatePlayersAndCountCompletedRounds [

	| whitePawn blackPawn knight |
	whitePawn := (board at: 'e2') contents.
	blackPawn := (board at: 'e7') contents.
	knight := (board at: 'g1') contents.
	self assert: game currentPlayer isWhite.
	self assert: game moveCount equals: 1.
	self deny: (game move: blackPawn to: (board at: 'e5')).
	self assert: game currentPlayer isWhite.
	self assert: game moveCount equals: 1.
	self assert: game moveHistory isEmpty.
	self assert: (board at: 'e7') contents identicalTo: blackPawn.
	self deny: (board at: 'e5') hasPiece.
	self assert: (game move: whitePawn to: (board at: 'e4')).
	self deny: game currentPlayer isWhite.
	self assert: game moveCount equals: 1.
	self assert: game moveHistory equals: #('1. Pe4') asOrderedCollection.
	self deny: (game move: knight to: (board at: 'f3')).
	self assert: (board at: 'g1') contents identicalTo: knight.
	self deny: (board at: 'f3') hasPiece.
	self deny: game currentPlayer isWhite.
	self assert: game moveCount equals: 1.
	self assert: game moveHistory equals: #('1. Pe4') asOrderedCollection.
	self assert: (game move: blackPawn to: (board at: 'e5')).
	self assert: game currentPlayer isWhite.
	self assert: game moveCount equals: 2.
	self assert: (board at: 'e5') contents identicalTo: blackPawn.
	self deny: (board at: 'e7') hasPiece.
	self assert: (game move: knight to: (board at: 'f3')).
	self assert: (board at: 'f3') contents identicalTo: knight.
	self deny: (board at: 'g1') hasPiece.
	self deny: game currentPlayer isWhite.
	self assert: game moveCount equals: 2.
	self assert: game moveHistory equals: #('1. Pe4' ' Pe5' '2. Nf3') asOrderedCollection

]

{ #category : 'tests' }
MyMoveFeedbackTest >> testBotButtonPassesTurnOnlyOnce [

	game play.
	self deny: game currentPlayer isWhite.
	self assert: game moveCount equals: 1.
	self assert: game moveHistory size equals: 1.
	game play.
	self assert: game currentPlayer isWhite.
	self assert: game moveCount equals: 2.
	self assert: game moveHistory size equals: 2

]

{ #category : 'tests' }
MyMoveFeedbackTest >> testEndingSelectionClearsHighlightsAfterPlayMovesThePiece [

	| pawn blackPawn |
	pawn := (board at: 'e2') contents.
	blackPawn := (board at: 'e7') contents.
	game currentPlayer strategy: (MyFixedMoveStrategy new
		move: (MyMoveCommand piece: pawn to: (board at: 'e4'));
		yourself).
	(board at: 'e2') click.
	self assert: self highlightedSquareNames asSortedCollection asArray equals: #('e3' 'e4').
	game play.
	self assert: (board at: 'e4') contents identicalTo: pawn.
	self deny: (board at: 'e2') hasPiece.
	(board at: 'd3') click.
	self assert: self highlightedSquareNames isEmpty.
	self assert: game moveHistory equals: #('1. Pe4') asOrderedCollection.
	self deny: game currentPlayer isWhite.
	(board at: 'e7') click.
	self assert: self highlightedSquareNames asSortedCollection asArray equals: #('e5' 'e6').
	(board at: 'e5') click.
	self assert: self highlightedSquareNames isEmpty.
	self deny: (board at: 'e7') hasPiece.
	self assert: (board at: 'e5') contents identicalTo: blackPawn.
	self assert: game currentPlayer isWhite.
	self assert: game moveHistory equals: #('1. Pe4' ' Pe5') asOrderedCollection
]

{ #category : 'tests' }
MyMoveFeedbackTest >> testKingCaptureIsRecordedOnce [

	| king |
	board pieces do: [ :each | each square emptyContents ].
	board at: 'e1' put: (king := MyKing white).
	board at: 'd2' put: MyRook black.
	board at: 'h8' put: MyKing black.
	game move: king to: (board at: 'd2').
	self assert: game moveHistory equals: #('1. Kd2') asOrderedCollection.
	self assert: (board at: 'd2') contents identicalTo: king.
	self deny: (board at: 'e1') hasPiece

]

{ #category : 'tests' }
MyMoveFeedbackTest >> testRejectedClickClearsHighlightsWithoutRecordingMove [

	| rook |
	self setUpPinnedRook.
	rook := (board at: 'e2') contents.
	(board at: 'e2') click.
	(board at: 'd2') click.
	self assert: self highlightedSquareNames isEmpty.
	self assert: game moveHistory isEmpty.
	self assert: (board at: 'e2') contents identicalTo: rook.
	self deny: (board at: 'd2') hasPiece.
	self assert: game currentPlayer isWhite.
	self assert: game moveCount equals: 1

]

{ #category : 'tests' }
MyMoveFeedbackTest >> testRejectedMovePreservesExistingHistory [

	| whitePawn blackPawn |
	whitePawn := (board at: 'e2') contents.
	blackPawn := (board at: 'e7') contents.
	self deny: (game move: whitePawn to: (board at: 'e5')).
	self assert: game moveHistory isEmpty.
	self assert: game currentPlayer isWhite.
	self assert: game moveCount equals: 1.
	self assert: (board at: 'e2') contents identicalTo: whitePawn.
	self deny: (board at: 'e5') hasPiece.
	self assert: (game move: whitePawn to: (board at: 'e4')).
	self deny: (game move: blackPawn to: (board at: 'e4')).
	self assert: game moveHistory equals: #('1. Pe4') asOrderedCollection.
	self deny: game currentPlayer isWhite.
	self assert: game moveCount equals: 1.
	self assert: (board at: 'e7') contents identicalTo: blackPawn.
	self assert: (board at: 'e4') contents identicalTo: whitePawn

]

{ #category : 'tests' }
MyMoveFeedbackTest >> testSelectingPinnedRookHighlightsOnlyLegalMoves [

	self setUpPinnedRook.
	(board at: 'e2') click.
	self
		assert: self highlightedSquareNames asSortedCollection asArray
		equals: #('e3' 'e4' 'e5' 'e6' 'e7' 'e8') asSortedCollection asArray

]
