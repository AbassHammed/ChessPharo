Class {
	#name : 'MyPawn',
	#superclass : 'MyPiece',
	#category : 'Myg-Chess-Core',
	#package : 'Myg-Chess-Core'
}

{ #category : 'visiting' }
MyPawn >> acceptVisitor: aVisitor [

	^ aVisitor visitPawn: self
]

{ #category : 'path commands' }
MyPawn >> attackingSquares [

	| forward |
	forward := self forwardSquare.
	forward ifNil: [ ^ #() ].

	^ { forward left. forward right } select: [ :each | each notNil ]
]

{ #category : 'testing' }
MyPawn >> canCaptureEnPassantAt: aSquare [

	| capturedSquare |
	aSquare == self board enPassantTargetSquare ifFalse: [ ^ false ].
	aSquare hasPiece ifTrue: [ ^ false ].
	square file = (self isWhite ifTrue: [ $5 ] ifFalse: [ $4 ]) ifFalse: [ ^ false ].
	(self attackingSquares includes: aSquare) ifFalse: [ ^ false ].
	capturedSquare := self isWhite ifTrue: [ aSquare down ] ifFalse: [ aSquare up ].
	^ capturedSquare hasPiece and: [
		capturedSquare contents isPawn and: [ capturedSquare contents color ~= color ] ]
]

{ #category : 'path commands' }
MyPawn >> capturedSquareAt: aSquare [

	(self canCaptureEnPassantAt: aSquare) ifTrue: [
		^ self isWhite ifTrue: [ aSquare down ] ifFalse: [ aSquare up ] ].
	^ super capturedSquareAt: aSquare
]

{ #category : 'path commands' }
MyPawn >> enPassantTargetAfterMovingFrom: source to: destination [

	(source file asciiValue - destination file asciiValue) abs = 2 ifTrue: [
		^ self isWhite ifTrue: [ source up ] ifFalse: [ source down ] ].
	^ nil
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

{ #category : 'testing' }
MyPawn >> isPawn [

	^ true
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
		((each hasPiece and: [ each contents color ~= color ]) or: [
			self canCaptureEnPassantAt: each ]) ifTrue: [
			targets add: each ] ].

	^ targets
]
