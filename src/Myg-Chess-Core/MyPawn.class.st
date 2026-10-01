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
MyPawn >> isOnPromotionRank [

	^ square notNil and: [
		self isWhite
			ifTrue: [ square file = $8 ]
			ifFalse: [ square file = $1 ] ]
]

{ #category : 'testing' }
MyPawn >> isOnStartingRank [

	^ self isWhite
		ifTrue: [ square file = $2 ]
		ifFalse: [ square file = $7 ]
]

{ #category : 'path commands' }
MyPawn >> moveTo: aSquare promotingTo: aPieceClass [

	({ MyQueen. MyRook. MyBishop. MyKnight } includes: aPieceClass)
		ifFalse: [ ^ false ].
	(aSquare file = (self isWhite ifTrue: [ $8 ] ifFalse: [ $1 ]))
		ifFalse: [ ^ false ].
	(super moveTo: aSquare) ifFalse: [ ^ false ].
	^ self promoteTo: aPieceClass
]

{ #category : 'testing' }
MyPawn >> needsPromotionAt: aSquare [

	^ aSquare file = (self isWhite ifTrue: [ $8 ] ifFalse: [ $1 ])
]

{ #category : 'promotion' }
MyPawn >> promoteTo: aPieceClass [

	| replacement |
	self isOnPromotionRank ifFalse: [ ^ false ].
	square contents == self ifFalse: [ ^ false ].
	({ MyQueen. MyRook. MyBishop. MyKnight } includes: aPieceClass)
		ifFalse: [ ^ false ].
	replacement := aPieceClass new color: color; yourself.
	self board at: square name put: replacement.
	square := nil.
	^ true
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
