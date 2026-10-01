Class {
	#name : 'MyKingSafetyTest',
	#superclass : 'TestCase',
	#instVars : [
		'board'
	],
	#category : 'Myg-Chess-Tests',
	#package : 'Myg-Chess-Tests'
}

{ #category : 'tests - support' }
MyKingSafetyTest >> assertTargetsOf: aPiece equal: squareNames [

	self
		assert: (aPiece legalTargetSquares collect: #name) asSortedCollection asArray
		equals: squareNames asSortedCollection asArray
]

{ #category : 'running' }
MyKingSafetyTest >> setUp [

	super setUp.
	board := MyChessBoard empty
]

{ #category : 'tests' }
MyKingSafetyTest >> testBlockingOneOfTwoChecksIsNotEnough [

	| king rook |
	board at: 'e1' put: (king := MyKing white).
	board at: 'h2' put: (rook := MyRook white).
	board at: 'e8' put: MyRook black.
	board at: 'b4' put: MyBishop black.
	board at: 'h8' put: MyKing black.
	self assert: king isInCheck.
	self assertTargetsOf: rook equal: #()
]

{ #category : 'tests' }
MyKingSafetyTest >> testCalculatingMovesPreservesBoardAndPieceLocations [

	| king enemy before firstTargets |
	board at: 'e1' put: (king := MyKing white).
	board at: 'd2' put: (enemy := MyRook black).
	board at: 'h8' put: MyKing black.
	before := board pieces copy.
	firstTargets := king legalTargetSquares.
	self assert: (firstTargets includes: (board at: 'd2')).
	self assert: king legalTargetSquares equals: firstTargets.
	self assert: board pieces equals: before.
	self assert: king square identicalTo: (board at: 'e1').
	self assert: enemy square identicalTo: (board at: 'd2').
	self assert: (board at: 'e1') contents identicalTo: king.
	self assert: (board at: 'd2') contents identicalTo: enemy
]

{ #category : 'tests' }
MyKingSafetyTest >> testCheckmateWhenNoPieceCanSaveKing [

	| king |
	board at: 'a1' put: (king := MyKing white).
	board at: 'b2' put: MyQueen black.
	board at: 'c3' put: MyKing black.
	self assert: king isInCheck.
	self assertTargetsOf: king equal: #().
	self assert: king isCheckMated
]

{ #category : 'tests' }
MyKingSafetyTest >> testKingCanCaptureOnlyAnUndefendedEnemy [

	| king |
	board at: 'e1' put: (king := MyKing white).
	board at: 'd2' put: MyRook black.
	board at: 'h8' put: MyKing black.
	board at: 'c3' put: MyBishop black.
	self deny: (king legalTargetSquares includes: (board at: 'd2')).
	(board at: 'c3') emptyContents.
	self assert: (king legalTargetSquares includes: (board at: 'd2')).
	king moveTo: (board at: 'd2').
	self assert: (board at: 'd2') contents identicalTo: king.
	self deny: (board at: 'e1') hasPiece.
	self deny: king isInCheck
]

{ #category : 'tests' }
MyKingSafetyTest >> testKingCannotMoveBackAlongOpenedRookLine [

	| king |
	board at: 'e2' put: (king := MyKing white).
	board at: 'e8' put: MyRook black.
	board at: 'h8' put: MyKing black.
	self deny: (king legalTargetSquares includes: (board at: 'e1')).
	self assert: (king legalTargetSquares includes: (board at: 'd1'))
]

{ #category : 'tests' }
MyKingSafetyTest >> testKingsCannotBecomeAdjacent [

	| king |
	board at: 'e1' put: (king := MyKing white).
	board at: 'e3' put: MyKing black.
	self assertTargetsOf: king equal: #('d1' 'f1')
]

{ #category : 'tests' }
MyKingSafetyTest >> testNotCheckmateWhenBishopCanCaptureAttacker [

	| king bishop |
	board at: 'a1' put: (king := MyKing white).
	board at: 'h1' put: (bishop := MyBishop white).
	board at: 'a8' put: MyRook black.
	board at: 'b8' put: MyRook black.
	board at: 'h8' put: MyKing black.
	self assert: king isInCheck.
	self assertTargetsOf: king equal: #().
	self assertTargetsOf: bishop equal: #('a8').
	self deny: king isCheckMated
]

{ #category : 'tests' }
MyKingSafetyTest >> testNotCheckmateWhenRookCanBlock [

	| king rook |
	board at: 'a1' put: (king := MyKing white).
	board at: 'c2' put: (rook := MyRook white).
	board at: 'a8' put: MyRook black.
	board at: 'b8' put: MyRook black.
	board at: 'h8' put: MyKing black.
	self assert: king isInCheck.
	self assertTargetsOf: king equal: #().
	self assertTargetsOf: rook equal: #('a2').
	self deny: king isCheckMated
]

{ #category : 'tests' }
MyKingSafetyTest >> testOpposingKingCannotBeCaptured [

	| rook |
	board at: 'a1' put: MyKing white.
	board at: 'e1' put: (rook := MyRook white).
	board at: 'e8' put: MyKing black.
	self deny: (rook legalTargetSquares includes: (board at: 'e8'))
]

{ #category : 'tests' }
MyKingSafetyTest >> testPawnThreatsAreDiagonalNotForward [

	| king |
	board at: 'e1' put: (king := MyKing white).
	board at: 'e3' put: MyPawn black.
	board at: 'h8' put: MyKing black.
	self assertTargetsOf: king equal: #('d1' 'e2' 'f1')
]

{ #category : 'tests' }
MyKingSafetyTest >> testPinnedEnemyStillDefendsCaptureSquare [

	| king |
	board at: 'c1' put: (king := MyKing white).
	board at: 'e1' put: MyRook white.
	board at: 'd2' put: MyKnight black.
	board at: 'e2' put: MyRook black.
	board at: 'e8' put: MyKing black.
	self deny: (king legalTargetSquares includes: (board at: 'd2'))
]

{ #category : 'tests' }
MyKingSafetyTest >> testPinnedRookStaysOnKingsFileForBothColors [
	{ Color white. Color black } do: [ :rookColor |
	 | rook ownKing rookSquare attackerSquare otherKing expected |
	 board := MyChessBoard empty.
	 ownKing := rookColor isBlack ifTrue: [ 'e8' ] ifFalse: [ 'e1' ].
	 rookSquare := rookColor isBlack ifTrue: [ 'e7' ] ifFalse: [ 'e2' ].
	 attackerSquare := rookColor isBlack ifTrue: [ 'e1' ] ifFalse: [ 'e8' ].
	 otherKing := rookColor isBlack ifTrue: [ 'a1' ] ifFalse: [ 'a8' ].
	 expected := rookColor isBlack
	  ifTrue: [ #('e6' 'e5' 'e4' 'e3' 'e2' 'e1') ]
	  ifFalse: [ #('e3' 'e4' 'e5' 'e6' 'e7' 'e8') ].
	 board at: ownKing put: (MyKing new color: rookColor).
	 board at: rookSquare put: (rook := MyRook new color: rookColor).
	 board at: attackerSquare put: (MyRook new color: rookColor negated).
	 board at: otherKing put: (MyKing new color: rookColor negated).
	 self assertTargetsOf: rook equal: expected ]
]

{ #category : 'tests' }
MyKingSafetyTest >> testPlayerCanUseRookToSaveImmobileKing [

	| game player rook |
	game := MyChessGame freshGame.
	player := MyPlayer new.
	player white; game: game.
	board := player king board.
	board pieces do: [ :each | each square emptyContents ].
	board at: 'a1' put: MyKing white.
	board at: 'c2' put: (rook := MyRook white).
	board at: 'a8' put: MyRook black.
	board at: 'b8' put: MyRook black.
	board at: 'h8' put: MyKing black.
	self assert: player king isInCheck.
	self assert: player king legalTargetSquares isEmpty.
	self shouldnt: [ player play ] raise: Halt.
	self assert: rook square name equals: 'a2'.
	self deny: player king isInCheck
]

{ #category : 'tests' }
MyKingSafetyTest >> testRejectedMoveDoesNotExposeKing [

	| king rook |
	board at: 'e1' put: (king := MyKing white).
	board at: 'e2' put: (rook := MyRook white).
	board at: 'e8' put: MyRook black.
	board at: 'a8' put: MyKing black.
	rook moveTo: (board at: 'd2').
	self assert: (board at: 'e2') contents identicalTo: rook.
	self assert: rook square identicalTo: (board at: 'e2').
	self deny: (board at: 'd2') hasPiece.
	self deny: king isInCheck
]

{ #category : 'tests' }
MyKingSafetyTest >> testRookCanBlockCheck [

	| king rook |
	board at: 'e1' put: (king := MyKing white).
	board at: 'd2' put: (rook := MyRook white).
	board at: 'e8' put: MyRook black.
	board at: 'a8' put: MyKing black.
	self assert: king isInCheck.
	self assertTargetsOf: rook equal: #('e2').
	rook moveTo: (board at: 'e2').
	self deny: king isInCheck
]

{ #category : 'tests' }
MyKingSafetyTest >> testRookCanCaptureCheckingPiece [

	| king rook |
	board at: 'e1' put: (king := MyKing white).
	board at: 'a8' put: (rook := MyRook white).
	board at: 'e8' put: MyRook black.
	board at: 'h8' put: MyKing black.
	self assert: king isInCheck.
	self assertTargetsOf: rook equal: #('e8').
	rook moveTo: (board at: 'e8').
	self deny: king isInCheck
]

{ #category : 'tests' }
MyKingSafetyTest >> testStalemateIsNotCheckmate [

	| king |
	board at: 'a1' put: (king := MyKing white).
	board at: 'b3' put: MyQueen black.
	board at: 'c3' put: MyKing black.
	self deny: king isInCheck.
	self assertTargetsOf: king equal: #().
	self deny: king isCheckMated
]

{ #category : 'tests' }
MyKingSafetyTest >> testUnrelatedKnightCannotIgnoreCheck [

	| knight |
	board at: 'e1' put: MyKing white.
	board at: 'a1' put: (knight := MyKnight white).
	board at: 'e8' put: MyRook black.
	board at: 'h8' put: MyKing black.
	self assertTargetsOf: knight equal: #()
]
