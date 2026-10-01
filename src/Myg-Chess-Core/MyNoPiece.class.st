Class {
	#name : 'MyNoPiece',
	#superclass : 'MyPiece',
	#category : 'Myg-Chess-Core',
	#package : 'Myg-Chess-Core'
}

{ #category : 'testing' }
MyNoPiece >> isPiece [

	^ false
]

{ #category : 'rendering' }
MyNoPiece >> renderPieceOn: aSquare [

	^ aSquare color isBlack ifTrue: [ 'x' ] ifFalse: [ 'z' ]
]

{ #category : 'rendering' }
MyNoPiece >> targetSquaresLegal: aBoolean [

	^ #()
]
