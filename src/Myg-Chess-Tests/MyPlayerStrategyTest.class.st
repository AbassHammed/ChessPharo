Class {
	#name : 'MyPlayerStrategyTest',
	#superclass : 'TestCase',
	#category : 'Myg-Chess-Tests',
	#package : 'Myg-Chess-Tests'
}

{ #category : 'tests' }
MyPlayerStrategyTest >> testChangingStrategyBetweenTurns [

	| game board player pawn knight |
	game := MyChessGame freshGame.
	board := game pieces first board.
	player := game currentPlayer.
	pawn := (board at: 'e2') contents.
	knight := (board at: 'g1') contents.
	player strategy: (MyFixedMoveStrategy new
		move: (MyMoveCommand piece: pawn to: (board at: 'e4'));
		yourself).
	player play.
	self assert: (board at: 'e4') contents identicalTo: pawn.
	self deny: (board at: 'e2') hasPiece.
	self deny: game currentPlayer isWhite.
	self assert: (game move: (board at: 'e7') contents to: (board at: 'e5')).
	player strategy: (MyFixedMoveStrategy new
		move: (MyMoveCommand piece: knight to: (board at: 'f3'));
		yourself).
	self assert: game currentPlayer identicalTo: player.
	player play.
	self assert: (board at: 'f3') contents identicalTo: knight.
	self deny: (board at: 'g1') hasPiece.
	self assert: (board at: 'e4') contents identicalTo: pawn.
	self deny: game currentPlayer isWhite.
	self assert: game moveHistory equals: #('1. Pe4' ' Pe5' '2. Nf3') asOrderedCollection
]

{ #category : 'tests' }
MyPlayerStrategyTest >> testChoosingDoesNotPlayOrRemovePieces [

	| game board king rook pieces before strategy move |
	game := MyChessGame fromFENString: 'rr5k/8/8/8/8/8/2R5/K7 w - - 0 1'.
	board := game pieces first board.
	king := (board at: 'a1') contents.
	rook := (board at: 'c2') contents.
	pieces := { king. rook } asOrderedCollection.
	before := board pieces copy.
	strategy := MyRandomMoveStrategy new.
	move := strategy chooseMoveFrom: pieces.
	self assert: move piece identicalTo: rook.
	self assert: move destination identicalTo: (board at: 'a2').
	self assert: pieces asArray equals: { king. rook }.
	self assert: board pieces equals: before.
	self assert: king square identicalTo: (board at: 'a1').
	self assert: rook square identicalTo: (board at: 'c2').
	self assert: game moveHistory isEmpty.
	self assert: game currentPlayer isWhite.
	self assert: (strategy chooseMoveFrom: { king }) isNil
]

{ #category : 'tests' }
MyPlayerStrategyTest >> testRecordingDecoratorPreservesChoicesAndSupportsNesting [

	| game board player pawn command fixed inner recording choices |
	game := MyChessGame freshGame.
	board := game pieces first board.
	player := game currentPlayer.
	pawn := (board at: 'e2') contents.
	command := MyMoveCommand piece: pawn to: (board at: 'e4').
	fixed := MyFixedMoveStrategy new move: command; yourself.
	inner := MyRecordingMoveStrategy on: fixed.
	recording := MyRecordingMoveStrategy on: inner.
	self assert: (recording chooseMoveFrom: player pieces) identicalTo: command.
	choices := { command } asOrderedCollection.
	self assert: recording choices equals: choices.
	self assert: inner choices equals: choices.
	self assert: pawn square identicalTo: (board at: 'e2').
	self assert: game moveHistory isEmpty.
	player strategy: recording.
	player play.
	choices add: command.
	self assert: recording choices equals: choices.
	self assert: inner choices equals: choices.
	self assert: (board at: 'e4') contents identicalTo: pawn.
	self deny: (board at: 'e2') hasPiece.
	self deny: game currentPlayer isWhite.
	self assert: game moveHistory equals: #('1. Pe4') asOrderedCollection.
	fixed move: nil.
	self assert: (recording chooseMoveFrom: player pieces) isNil.
	self assert: recording choices equals: choices.
	self assert: inner choices equals: choices
]
