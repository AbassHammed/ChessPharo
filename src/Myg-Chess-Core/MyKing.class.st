Class {
	#name : 'MyKing',
	#superclass : 'MyPiece',
	#category : 'Myg-Chess-Core',
	#package : 'Myg-Chess-Core'
}

{ #category : 'visiting' }
MyKing >> acceptVisitor: aVisitor [

	^ aVisitor visitKing: self
]

{ #category : 'as yet unclassified' }
MyKing >> attackingSquares [

	^ self basicTargetSquares select: #isOnBoard
]

{ #category : 'rendering' }
MyKing >> basicTargetSquares [

	^ {
		square right.
		square up right.
		square up.
		square up left.
		square left.
		square left down.
		square down.
		square down right }
]

{ #category : 'accessing' }
MyKing >> id [
	
	^ 'K'
]

{ #category : 'testing' }
MyKing >> isCheckMated [

	| friendlyPieces |
	self isInCheck ifFalse: [ ^ false ].
	friendlyPieces := self board pieces select: [ :each |
		each color = color ].

	^ (friendlyPieces anySatisfy: [ :each | each legalTargetSquares notEmpty ]) not
]

{ #category : 'testing' }
MyKing >> isInCheck [
	"We check if the opponent pieces target all my potential movements and myself"

	| threatenedSquares |
	threatenedSquares := self opponentPieces flatCollect: [ :e |
		                     e attackingSquares ].

	^ threatenedSquares includes: self square
]

{ #category : 'testing' }
MyKing >> isKing [
	
	^ true
]

{ #category : 'accessing' }
MyKing >> opponentPieces [

	^ self board pieces select: [ :e |
		  e color = color negated ]
]

{ #category : 'rendering' }
MyKing >> renderPieceOn: aSquare [

	^ aSquare renderKing: self
]

{ #category : 'rendering' }
MyKing >> targetSquaresLegal: aBoolean [
	"King safety is checked by the inherited legalTargetSquares method."

	^ self basicTargetSquares select: [ :target |
		target isOnBoard and: [
			target hasPiece not or: [ target contents color ~= color ] ] ]
]
