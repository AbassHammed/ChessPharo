Class {
	#name : 'MyKnight',
	#superclass : 'MyPiece',
	#category : 'Myg-Chess-Core',
	#package : 'Myg-Chess-Core'
}

{ #category : 'visiting' }
MyKnight >> acceptVisitor: aVisitor [

	^ aVisitor visitKnight: self
]

{ #category : 'accessing' }
MyKnight >> id [
	
	^ 'N'
]

{ #category : 'rendering' }
MyKnight >> renderPieceOn: aSquare [

	^ aSquare renderKnight: self
]

{ #category : 'rendering' }
MyKnight >> targetSquaresLegal: aBoolean [

	^ {
		square right right up.
		square right right down.
		square left left up.
		square left left down.
		square up up left.
		square up up right.
		square down down left.
		square down down right }
		select: [ :target |
			target isOnBoard and: [
				target hasPiece not or: [ target contents color ~= color ] ] ]
]
