Class {
	#name : 'MyBishopTests',
	#superclass : 'TestCase',
	#category : 'Myg-Chess-Tests',
	#package : 'Myg-Chess-Tests'
}

{ #category : 'tests' }
MyBishopTests >> testMoves [

	| bishop squares board |
	board := MyChessBoard empty.
	board at: 'e4' put: (bishop := MyBishop white).

	squares := bishop legalTargetSquares.
	self
		assert: (squares collect: #name) asSortedCollection asArray
		equals: #('f5' 'g6' 'h7' 'f3' 'g2' 'h1' 'd5' 'c6' 'b7' 'a8' 'd3' 'c2' 'b1') asSortedCollection asArray
]

{ #category : 'tests' }
MyBishopTests >> testMovesWithOponentObstacle [

	| bishop squares board |
	board := MyChessBoard empty.
	board at: 'e4' put: (bishop := MyBishop white).

	"A bishop can capture the enemy on g6, but cannot move beyond it."
	board at: 'g6' put: MyBishop black.

	squares := bishop legalTargetSquares.
	self
		assert: (squares collect: #name) asSortedCollection asArray
		equals: #('f5' 'g6' 'f3' 'g2' 'h1' 'd5' 'c6' 'b7' 'a8' 'd3' 'c2' 'b1') asSortedCollection asArray
]

{ #category : 'tests' }
MyBishopTests >> testMovesWithSameColorObstacle [

	| bishop squares board |
	board := MyChessBoard empty.
	board at: 'e4' put: (bishop := MyBishop white).

	"A bishop cannot capture its own piece on g6 or move beyond it."
	board at: 'g6' put: MyBishop white.

	squares := bishop legalTargetSquares.
	self
		assert: (squares collect: #name) asSortedCollection asArray
		equals: #('f5' 'f3' 'g2' 'h1' 'd5' 'c6' 'b7' 'a8' 'd3' 'c2' 'b1') asSortedCollection asArray
]
