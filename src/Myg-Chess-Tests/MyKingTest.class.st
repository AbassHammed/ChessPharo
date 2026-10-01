Class {
	#name : 'MyKingTest',
	#superclass : 'TestCase',
	#category : 'Myg-Chess-Tests',
	#package : 'Myg-Chess-Tests'
}

{ #category : 'tests' }
MyKingTest >> testOnlyEnemyRookChecksKing [
	| king board |
	board := MyChessBoard empty.
	board at: 'e4' put: (king := MyKing white).
	board at: 'e1' put: MyRook white.
	self deny: king isInCheck.
	board at: 'e1' put: MyRook black.
	self assert: king isInCheck
]
