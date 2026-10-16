Class {
	#name : 'MyCaptureFirstMoveStrategy',
	#superclass : 'Object',
	#instVars : [
		'fallback'
	],
	#category : 'Myg-Chess-Core',
	#package : 'Myg-Chess-Core'
}

{ #category : 'playing' }
MyCaptureFirstMoveStrategy >> chooseMoveFrom: pieces [

	| captures |
	captures := OrderedCollection new.
	pieces do: [ :piece |
		piece legalTargetSquares do: [ :destination |
			(piece capturedSquareAt: destination) hasPiece ifTrue: [
				captures add: (MyMoveCommand piece: piece to: destination) ] ] ].
	captures ifNotEmpty: [ ^ captures atRandom ].
	^ fallback chooseMoveFrom: pieces
]

{ #category : 'accessing' }
MyCaptureFirstMoveStrategy >> fallback: aStrategy [

	fallback := aStrategy
]

{ #category : 'initialization' }
MyCaptureFirstMoveStrategy >> initialize [

	super initialize.
	fallback := MyRandomMoveStrategy new
]
