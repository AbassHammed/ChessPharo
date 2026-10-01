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

{ #category : 'tests' }
MyMoveFeedbackTest >> testAcceptedClickClearsHighlightsAndRecordsOnce [

	| pawn |
	pawn := (board at: 'e2') contents.
	(board at: 'e2') click.
	(board at: 'e4') click.
	self assert: self highlightedSquareNames isEmpty.
	self assert: game moveHistory equals: #('1. Pe4') asOrderedCollection.
	self assert: (board at: 'e4') contents identicalTo: pawn.
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
MyMoveFeedbackTest >> testRejectedClickClearsHighlightsWithoutRecordingMove [

	| pawn |
	pawn := (board at: 'e2') contents.
	(board at: 'e2') click.
	(board at: 'e5') click.
	self assert: self highlightedSquareNames isEmpty.
	self assert: game moveHistory isEmpty.
	self assert: (board at: 'e2') contents identicalTo: pawn.
	self deny: (board at: 'e5') hasPiece.
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
MyMoveFeedbackTest >> testSelectingPawnHighlightsOnlyLegalMoves [

	(board at: 'e2') click.
	self assert: self highlightedSquareNames asSortedCollection asArray
		equals: #('e3' 'e4')
]
