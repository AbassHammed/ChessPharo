Class {
	#name : 'MyPromotionInteractionTest',
	#superclass : 'TestCase',
	#instVars : [
		'game',
		'board'
	],
	#category : 'Myg-Chess-Tests',
	#package : 'Myg-Chess-Tests'
}

{ #category : 'running' }
MyPromotionInteractionTest >> setUp [

	super setUp.
	game := MyPromotionChoiceTestGame fromFENString: '7k/4P3/8/8/8/8/8/K7 w - - 0 1'.
	board := game pieces first board
]

{ #category : 'tests' }
MyPromotionInteractionTest >> testBotPromotesWithoutOpeningDialog [

	| pawn player |
	pawn := (board at: 'e7') contents.
	board pieces do: [ :each |
	 each ~= pawn ifTrue: [ each square emptyContents ] ].
	player := MyPlayer new white game: game.
	player play.
	self assert: (board at: 'e8') contents class equals: MyQueen.
	self assert: game promotionRequests equals: 0.
	self assert: game moveHistory equals: #('1. Pe8=Q') asOrderedCollection
]

{ #category : 'tests' }
MyPromotionInteractionTest >> testCancellingPromotionPreservesBoardAndAllowsRetry [
	#('e8' 'd8') do: [ :destination |
	 | pawn victim |
	 game := MyPromotionChoiceTestGame fromFENString: '7k/4P3/8/8/8/8/8/K7 w - - 0 1'.
	 board := game pieces first board.
	 pawn := (board at: 'e7') contents.
	 victim := MyRook black.
	 board at: 'd8' put: victim.
	 game promotionChoice: nil.
	 (board at: 'e7') click.
	 (board at: destination) click.
	 self assert: (board at: 'e7') contents identicalTo: pawn.
	 self deny: (board at: 'e8') hasPiece.
	 self assert: (board at: 'd8') contents identicalTo: victim.
	 self assert: game moveHistory isEmpty.
	 self assert: game currentPlayer isWhite.
	 self assert: game moveCount equals: 1.
	 self assert: game promotionRequests equals: 1.
	 self deny: (board children anySatisfy: #isTargetHighlighted).
	 game promotionChoice: MyBishop.
	 (board at: 'e7') click.
	 (board at: destination) click.
	 self assert: (board at: destination) contents class equals: MyBishop.
	 self assert: game moveHistory equals: ({ '1. P' , destination , '=B' } asOrderedCollection) ]
]

{ #category : 'tests' }
MyPromotionInteractionTest >> testCapturePromotionRecordsChosenBishop [

	board at: 'd8' put: MyRook black.
	game promotionChoice: MyBishop.
	(board at: 'e7') click.
	(board at: 'd8') click.
	self assert: (board at: 'd8') contents class equals: MyBishop.
	self assert: game moveHistory equals: #('1. Pd8=B') asOrderedCollection
]

{ #category : 'tests' }
MyPromotionInteractionTest >> testClicksUseChosenPromotionForBothColors [

	(board at: 'e7') click.
	(board at: 'e8') click.
	self assert: (board at: 'e8') contents class equals: MyKnight.
	self assert: (board at: 'e8') contents isWhite.
	self deny: (board at: 'e7') hasPiece.
	self assert: game promotionRequests equals: 1.
	self assert: game moveHistory equals: #('1. Pe8=N') asOrderedCollection.
	self deny: (board children anySatisfy: #isTargetHighlighted).


	game := MyPromotionChoiceTestGame fromFENString: '7k/8/8/8/8/8/4p3/K7 b - - 0 1'.
	board := game pieces first board.
	game promotionChoice: MyRook.
	(board at: 'e2') click.
	(board at: 'e1') click.
	self assert: (board at: 'e1') contents class equals: MyRook.
	self deny: (board at: 'e1') contents isWhite.
	self assert: game promotionRequests equals: 1.
	self assert: game moveHistory equals: #(' Pe1=R') asOrderedCollection
]

{ #category : 'tests' }
MyPromotionInteractionTest >> testExplicitInvalidChoiceDoesNotRecordOrMove [

	| pawn |
	pawn := (board at: 'e7') contents.
	self deny: (game move: pawn to: (board at: 'e8') promotingTo: MyKing).
	self assert: (board at: 'e7') contents identicalTo: pawn.
	self deny: (board at: 'e8') hasPiece.
	self assert: game moveHistory isEmpty
]

{ #category : 'tests' }
MyPromotionInteractionTest >> testInvalidPromotionMoveDoesNotOpenChooser [
	| pawn victim |
	pawn := (board at: 'e7') contents.
	(board at: 'e7') click.
	(board at: 'd8') click.
	self assert: game promotionRequests equals: 0.
	self assert: game moveHistory isEmpty.
	self assert: (board at: 'e7') contents identicalTo: pawn.
	victim := MyRook black.
	board at: 'e8' put: victim.
	(board at: 'e7') click.
	(board at: 'e8') click.
	self assert: game promotionRequests equals: 0.
	self assert: (board at: 'e7') contents identicalTo: pawn.
	self assert: (board at: 'e8') contents identicalTo: victim.
	self assert: game moveHistory isEmpty.
	board at: 'b2' put: (pawn := MyPawn black).
	(board at: 'b2') click.
	(board at: 'b1') click.
	self assert: (board at: 'b2') contents identicalTo: pawn.
	self deny: (board at: 'b1') hasPiece.
	self assert: game promotionRequests equals: 0.
	self assert: game moveHistory isEmpty.
	self assert: game currentPlayer isWhite.
	self assert: game moveCount equals: 1
]

{ #category : 'tests' }
MyPromotionInteractionTest >> testNormalPawnClickDoesNotAsk [

	| pawn |
	pawn := MyPawn white.
	board at: 'd2' put: pawn.
	(board at: 'd2') click.
	(board at: 'd4') click.
	self assert: (board at: 'd4') contents identicalTo: pawn.
	self assert: game promotionRequests equals: 0.
	self assert: game moveHistory equals: #('1. Pd4') asOrderedCollection
]

{ #category : 'tests' }
MyPromotionInteractionTest >> testRookAtLastRankDoesNotAsk [

	| rook |
	rook := MyRook white.
	board at: 'b7' put: rook.
	(board at: 'b7') click.
	(board at: 'b8') click.
	self assert: (board at: 'b8') contents identicalTo: rook.
	self assert: game promotionRequests equals: 0.
	self assert: game moveHistory equals: #('1. Rb8') asOrderedCollection
]
