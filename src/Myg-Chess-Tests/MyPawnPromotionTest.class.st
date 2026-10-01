Class {
	#name : 'MyPawnPromotionTest',
	#superclass : 'TestCase',
	#instVars : [
		'board'
	],
	#category : 'Myg-Chess-Tests',
	#package : 'Myg-Chess-Tests'
}

{ #category : 'running' }
MyPawnPromotionTest >> setUp [

	super setUp.
	board := MyChessBoard empty
]

{ #category : 'tests' }
MyPawnPromotionTest >> testBothColorsCanCaptureAndPromote [
	{ Color white. Color black } do: [ :pawnColor |
	 | pawn start finish victim |
	 board := MyChessBoard empty.
	 pawn := MyPawn new color: pawnColor.
	 start := pawn isWhite ifTrue: [ 'e7' ] ifFalse: [ 'e2' ].
	 finish := pawn isWhite ifTrue: [ 'd8' ] ifFalse: [ 'd1' ].
	 victim := MyRook new color: pawnColor negated.
	 board at: start put: pawn.
	 board at: finish put: victim.
	 self assert: (pawn moveTo: (board at: finish) promotingTo: MyKnight).
	 self assert: (board at: finish) contents class equals: MyKnight.
	 self assert: (board at: finish) contents color equals: pawnColor.
	 self deny: (board at: start) hasPiece.
	 self deny: (board pieces includes: victim).
	 self deny: (board pieces includes: pawn) ]
]

{ #category : 'tests' }
MyPawnPromotionTest >> testBothColorsCanChooseEachPromotionPiece [
	{ Color white. Color black } do: [ :pawnColor |
	 { MyQueen. MyRook. MyBishop. MyKnight } do: [ :pieceClass |
	  | pawn start finish replacement |
	  board := MyChessBoard empty.
	  pawn := MyPawn new color: pawnColor.
	  start := pawn isWhite ifTrue: [ 'e7' ] ifFalse: [ 'e2' ].
	  finish := pawn isWhite ifTrue: [ 'e8' ] ifFalse: [ 'e1' ].
	  board at: start put: pawn.
	  self assert: (pawn moveTo: (board at: finish) promotingTo: pieceClass).
	  replacement := (board at: finish) contents.
	  self assert: replacement class equals: pieceClass.
	  self assert: replacement color equals: pawnColor.
	  self assert: replacement square identicalTo: (board at: finish).
	  self deny: (board at: start) hasPiece.
	  self deny: (board pieces includes: pawn) ] ]
]

{ #category : 'tests' }
MyPawnPromotionTest >> testInvalidPromotionChoiceDoesNotMoveOrCapture [

	{ MyPawn. MyKing. MyPiece. Object. nil } do: [ :pieceClass |
	 | pawn victim |
	 board := MyChessBoard empty.
	 pawn := MyPawn white.
	 victim := MyRook black.
	 board at: 'e7' put: pawn.
	 board at: 'd8' put: victim.
	 self deny: (pawn moveTo: (board at: 'd8') promotingTo: pieceClass).
	 self assert: (board at: 'e7') contents identicalTo: pawn.
	 self assert: (board at: 'd8') contents identicalTo: victim ]
]

{ #category : 'tests' }
MyPawnPromotionTest >> testPromotedRookImmediatelyChecksAndMovesAsRook [

	| pawn king rook |
	pawn := MyPawn white.
	king := MyKing black.
	board at: 'a1' put: MyKing white.
	board at: 'h8' put: king.
	board at: 'e7' put: pawn.
	self assert: (pawn moveTo: (board at: 'e8') promotingTo: MyRook).
	rook := (board at: 'e8') contents.
	self assert: king isInCheck.
	self assert: (rook moveTo: (board at: 'e6')).
	self assert: (board at: 'e6') contents identicalTo: rook.
	self deny: (board at: 'e8') hasPiece
]

{ #category : 'tests' }
MyPawnPromotionTest >> testPromotionCanCreateASecondQueen [

	| pawn firstQueen |
	firstQueen := MyQueen white.
	pawn := MyPawn white.
	board at: 'd1' put: firstQueen.
	board at: 'e7' put: pawn.
	self assert: (pawn moveTo: (board at: 'e8') promotingTo: MyQueen).
	self assert: (board at: 'd1') contents identicalTo: firstQueen.
	self assert: (board at: 'e8') contents class equals: MyQueen.
	self assert: (board pieces count: [ :each | each class = MyQueen ]) equals: 2
]

{ #category : 'tests' }
MyPawnPromotionTest >> testPromotionCannotCaptureForward [

	| pawn victim |
	pawn := MyPawn white.
	victim := MyRook black.
	board at: 'e7' put: pawn.
	board at: 'e8' put: victim.
	self deny: (pawn moveTo: (board at: 'e8') promotingTo: MyQueen).
	self assert: (board at: 'e7') contents identicalTo: pawn.
	self assert: (board at: 'e8') contents identicalTo: victim
]

{ #category : 'tests' }
MyPawnPromotionTest >> testPromotionCannotExposeOwnKing [

	| pawn victim |
	pawn := MyPawn white.
	victim := MyKnight black.
	board at: 'e1' put: MyKing white.
	board at: 'e7' put: pawn.
	board at: 'e8' put: MyRook black.
	board at: 'd8' put: victim.
	board at: 'a8' put: MyKing black.
	self deny: (pawn moveTo: (board at: 'd8') promotingTo: MyQueen).
	self assert: (board at: 'e7') contents identicalTo: pawn.
	self assert: (board at: 'd8') contents identicalTo: victim
]

{ #category : 'tests' }
MyPawnPromotionTest >> testPromotionRequiresCorrectFinalRank [
	| white black |
	board at: 'e1' put: (white := MyPawn white).
	board at: 'e8' put: (black := MyPawn black).
	self deny: (white promoteTo: MyQueen).
	self deny: (black promoteTo: MyQueen).
	self assert: (board at: 'e1') contents identicalTo: white.
	self assert: (board at: 'e8') contents identicalTo: black.
	board := MyChessBoard empty.
	board at: 'e6' put: (white := MyPawn white).
	self deny: (white promoteTo: MyQueen).
	self deny: (white moveTo: (board at: 'e7') promotingTo: MyQueen).
	self assert: (board at: 'e6') contents identicalTo: white.
	self deny: (board at: 'e7') hasPiece
]

{ #category : 'tests' }
MyPawnPromotionTest >> testReplacedPawnCannotPromoteAgain [

	| pawn queen |
	pawn := MyPawn white.
	board at: 'e8' put: pawn.
	self assert: (pawn promoteTo: MyQueen).
	queen := (board at: 'e8') contents.
	self deny: (pawn promoteTo: MyRook).
	self assert: (board at: 'e8') contents identicalTo: queen
]
