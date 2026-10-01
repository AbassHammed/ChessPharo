Class {
	#name : 'MyFENGame',
	#superclass : 'Object',
	#instVars : [
		'board',
		'sideToMove',
		'players',
		'enPassantTargetSquare',
		'halfMoveClock',
		'moveCount',
		'white',
		'black',
		'castlingAbility'
	],
	#category : 'Myg-Chess-Importers',
	#package : 'Myg-Chess-Importers'
}

{ #category : 'accessing' }
MyFENGame >> board [
	^ board
]

{ #category : 'accessing' }
MyFENGame >> castlingAbility [

	^ castlingAbility copy
]

{ #category : 'accessing' }
MyFENGame >> castlingAbility: aCollection [

	castlingAbility := aCollection copy
]

{ #category : 'accessing' }
MyFENGame >> enPassantTargetSquare: aString [ 
	enPassantTargetSquare := aString
]

{ #category : 'accessing' }
MyFENGame >> halfMoveClock: anInteger [ 
	halfMoveClock := anInteger
]

{ #category : 'accessing' }
MyFENGame >> moveCount [
	^ moveCount
]

{ #category : 'accessing' }
MyFENGame >> moveCount: anInteger [ 
	moveCount := anInteger
]

{ #category : 'accessing' }
MyFENGame >> ranks: aCollection [

	board := Dictionary new.
	aCollection reversed with: (1 to: 8) do: [ :rankPieces :rank |
		rankPieces with: ($a to: $h) do: [ :piece :column |
			board at: column asString , rank asString put: piece ] ]
]

{ #category : 'accessing' }
MyFENGame >> sideToMove [
	^ sideToMove
]

{ #category : 'accessing' }
MyFENGame >> sideToMove: aString [ 
	sideToMove := aString
]
