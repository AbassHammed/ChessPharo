Class {
	#name : 'MyMoveCommand',
	#superclass : 'Object',
	#instVars : [
		'piece',
		'destination'
	],
	#category : 'Myg-Chess-Core',
	#package : 'Myg-Chess-Core'
}

{ #category : 'instance creation' }
MyMoveCommand class >> piece: aPiece to: aSquare [

	^ self new
		piece: aPiece;
		destination: aSquare;
		yourself
]

{ #category : 'accessing' }
MyMoveCommand >> destination [

	^ destination
]

{ #category : 'accessing' }
MyMoveCommand >> destination: aSquare [

	destination := aSquare
]

{ #category : 'executing' }
MyMoveCommand >> executeOn: aGame [

	^ aGame move: piece to: destination
]

{ #category : 'accessing' }
MyMoveCommand >> piece [

	^ piece
]

{ #category : 'accessing' }
MyMoveCommand >> piece: aPiece [

	piece := aPiece
]
