Class {
	#name : 'MyRandomMoveStrategy',
	#superclass : 'Object',
	#category : 'Myg-Chess-Core',
	#package : 'Myg-Chess-Core'
}

{ #category : 'playing' }
MyRandomMoveStrategy >> chooseMoveFrom: aCollection [

	| pieces |
	pieces := aCollection asOrderedCollection copy.
	[ pieces notEmpty ] whileTrue: [
		| piece legalMoves |
		piece := pieces atRandom.
		pieces remove: piece.
		legalMoves := piece legalTargetSquares.
		legalMoves ifNotEmpty: [
			^ MyMoveCommand piece: piece to: legalMoves atRandom ] ].
	^ nil
]
