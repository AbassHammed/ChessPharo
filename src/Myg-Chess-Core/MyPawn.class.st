Class {
	#name : 'MyPawn',
	#superclass : 'MyPiece',
	#category : 'Myg-Chess-Core',
	#package : 'Myg-Chess-Core'
}

{ #category : 'path commands' }
MyPawn >> attackingSquares [

	| forward |
	forward := self forwardSquare.
	forward ifNil: [ ^ #() ].

	^ { forward left. forward right } select: [ :each | each notNil ]
]

{ #category : 'path commands' }
MyPawn >> forwardSquare [

	^ self isWhite
		ifTrue: [ square up ]
		ifFalse: [ square down ]
]

{ #category : 'accessing' }
MyPawn >> id [

	^ 'P'
]

{ #category : 'testing' }
MyPawn >> isOnStartingRank [

	^ self isWhite
		ifTrue: [ square file = $2 ]
		ifFalse: [ square file = $7 ]
]

{ #category : 'rendering' }
MyPawn >> renderPieceOn: aSquare [ 
	
	^ aSquare renderPawn: self
]

{ #category : 'path commands' }
MyPawn >> targetSquaresLegal: aBoolean [
	"Pawn destinations obey occupancy rules for movement and highlighting."

	| targets forward second |
	targets := OrderedCollection new.
	forward := self forwardSquare.

	(forward notNil and: [ forward hasPiece not ]) ifTrue: [
		targets add: forward.
		self isOnStartingRank ifTrue: [
			second := self isWhite
				ifTrue: [ forward up ]
				ifFalse: [ forward down ].
			(second notNil and: [ second hasPiece not ]) ifTrue: [
				targets add: second ] ] ].

	self attackingSquares do: [ :each |
		(each hasPiece and: [ each contents color ~= color ]) ifTrue: [
			targets add: each ] ].

	^ targets
]
