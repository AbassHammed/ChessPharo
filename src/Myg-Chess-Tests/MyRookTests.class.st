Class {
	#name : 'MyRookTests',
	#superclass : 'TestCase',
	#category : 'Myg-Chess-Tests',
	#package : 'Myg-Chess-Tests'
}

{ #category : 'tests' }
MyRookTests >> testMoves [

	| rook squares board |
	board := MyChessBoard empty.
	board at: 'e4' put: (rook := MyRook white).

	squares := rook legalTargetSquares.
	self
		assert: (squares collect: #name) asSortedCollection asArray
		equals: #('e5' 'e6' 'e7' 'e8' 'd4' 'c4' 'b4' 'a4' 'f4' 'g4' 'h4' 'e3' 'e2' 'e1') asSortedCollection asArray
]

{ #category : 'tests' }
MyRookTests >> testMovesWithOponentObstacle [

	| rook squares board |
	board := MyChessBoard empty.
	board at: 'e4' put: (rook := MyRook white).

	"A rook can capture the enemy on g4, but cannot move beyond it."
	board at: 'g4' put: MyRook black.

	squares := rook legalTargetSquares.
	self
		assert: (squares collect: #name) asSortedCollection asArray
		equals: #('e5' 'e6' 'e7' 'e8' 'd4' 'c4' 'b4' 'a4' 'f4' 'g4' 'e3' 'e2' 'e1') asSortedCollection asArray
]

{ #category : 'tests' }
MyRookTests >> testMovesWithSameColorObstacle [

	| rook squares board |
	board := MyChessBoard empty.
	board at: 'e4' put: (rook := MyRook white).

	"A rook cannot capture its own piece on g4 or move beyond it."
	board at: 'g4' put: MyRook white.

	squares := rook legalTargetSquares.
	self
		assert: (squares collect: #name) asSortedCollection asArray
		equals: #('e5' 'e6' 'e7' 'e8' 'd4' 'c4' 'b4' 'a4' 'f4' 'e3' 'e2' 'e1') asSortedCollection asArray
]
