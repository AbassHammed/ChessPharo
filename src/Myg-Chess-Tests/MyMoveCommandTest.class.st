Class {
	#name : 'MyMoveCommandTest',
	#superclass : 'TestCase',
	#category : 'Myg-Chess-Tests',
	#package : 'Myg-Chess-Tests'
}

{ #category : 'tests' }
MyMoveCommandTest >> testPreparedCommandsFollowTheTurnAtExecution [

	| game board whitePawn blackPawn whiteMove blackMove |
	game := MyChessGame freshGame.
	board := game pieces first board.
	whitePawn := (board at: 'e2') contents.
	blackPawn := (board at: 'e7') contents.
	whiteMove := MyMoveCommand piece: whitePawn to: (board at: 'e4').
	blackMove := MyMoveCommand piece: blackPawn to: (board at: 'e5').
	self assert: whitePawn square identicalTo: (board at: 'e2').
	self assert: blackPawn square identicalTo: (board at: 'e7').
	self assert: game moveHistory isEmpty.
	self deny: (blackMove executeOn: game).
	self assert: (board at: 'e7') contents identicalTo: blackPawn.
	self deny: (board at: 'e5') hasPiece.
	self assert: game currentPlayer isWhite.
	self assert: game moveCount equals: 1.
	self assert: game moveHistory isEmpty.
	self assert: (whiteMove executeOn: game).
	self assert: (board at: 'e4') contents identicalTo: whitePawn.
	self deny: (board at: 'e2') hasPiece.
	self deny: game currentPlayer isWhite.
	self assert: game moveHistory equals: #('1. Pe4') asOrderedCollection.
	self assert: (blackMove executeOn: game).
	self assert: (board at: 'e5') contents identicalTo: blackPawn.
	self deny: (board at: 'e7') hasPiece.
	self assert: game currentPlayer isWhite.
	self assert: game moveCount equals: 2.
	self assert: game moveHistory equals: #('1. Pe4' ' Pe5') asOrderedCollection
]
