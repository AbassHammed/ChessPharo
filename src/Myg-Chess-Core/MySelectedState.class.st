Class {
	#name : 'MySelectedState',
	#superclass : 'Object',
	#instVars : [
		'board',
		'selection',
		'highlightedSquares'
	],
	#category : 'Myg-Chess-Core',
	#package : 'Myg-Chess-Core'
}

{ #category : 'instance creation' }
MySelectedState class >> board: aBoard selected: aMyChessSquare targets: squares [

	^ self new
		  board: aBoard;
		  selection: aMyChessSquare;
		  highlightedSquares: squares;
		  yourself
]

{ #category : 'accessing' }
MySelectedState >> board [

	^ board
]

{ #category : 'accessing' }
MySelectedState >> board: anObject [

	board := anObject
]

{ #category : 'events' }
MySelectedState >> clickOn: aMyChessSquare [

	selection unselect.
	board unhighLightTargets: highlightedSquares.
	selection hasPiece ifTrue: [
		board game moveInteractively: selection contents to: aMyChessSquare ].
	^ MyUnselectedState board: board
]

{ #category : 'accessing' }
MySelectedState >> highlightedSquares: squares [

	highlightedSquares := squares
]

{ #category : 'accessing' }
MySelectedState >> selection [

	^ selection
]

{ #category : 'accessing' }
MySelectedState >> selection: anObject [

	selection := anObject
]
