Class {
	#name : 'MyChessSquare',
	#superclass : 'BlElement',
	#instVars : [
		'color',
		'name',
		'label',
		'piece',
		'contents',
		'board',
		'target'
	],
	#category : 'Myg-Chess-Core',
	#package : 'Myg-Chess-Core'
}

{ #category : 'api - text weight' }
MyChessSquare class >> black [

	^ self color: Color black
]

{ #category : 'api - text weight' }
MyChessSquare class >> color: aColor [

	^ self basicNew
		  color: aColor;
		  initialize;
		  yourself
]

{ #category : 'api - text weight' }
MyChessSquare class >> white [

	^ self color: Color white
]

{ #category : 'arithmetic' }
MyChessSquare >> + aPoint [

	| column file |
	column := (self column asciiValue + aPoint x) asCharacter asString.
	file := (self file asciiValue + aPoint y) asCharacter asString.

	^ board at: column , file
]

{ #category : 'accessing' }
MyChessSquare >> board [
	^ board
]

{ #category : 'accessing' }
MyChessSquare >> board: aMyChessBoard [ 
	
	board := aMyChessBoard

]

{ #category : 'initialization' }
MyChessSquare >> click [

	board click: self
]

{ #category : 'accessing' }
MyChessSquare >> color [

	^ color
]

{ #category : 'accessing' }
MyChessSquare >> color: anObject [

	color := anObject
]

{ #category : 'accessing' }
MyChessSquare >> column [
	
	^ name first
]

{ #category : 'accessing' }
MyChessSquare >> contents [
	^ contents
]

{ #category : 'accessing' }
MyChessSquare >> contents: aPiece [

	contents := aPiece.
	piece text: ((contents renderPieceOn: self) asRopedText
		fontSize: 48;
		foreground: self foreground;
		fontName: MyOpenChessDownloadedFont new familyName)
]

{ #category : 'api - configuration' }
MyChessSquare >> down [

	^ self + (0 @ -1)
]

{ #category : 'accessing' }
MyChessSquare >> emptyContents [

	self contents: MyNoPiece new
]

{ #category : 'accessing' }
MyChessSquare >> file [
	
	^ name second
]

{ #category : 'accessing' }
MyChessSquare >> foreground [
			
	^ color isBlack
		ifTrue: [ board blackColor ]
		ifFalse: [ board whiteColor ]
]

{ #category : 'testing' }
MyChessSquare >> hasPiece [

	^ contents isPiece
]

{ #category : 'highlighting' }
MyChessSquare >> highlightTarget [

	self addChild: target
]

{ #category : 'initialization' }
MyChessSquare >> initialize [

	super initialize.
	contents := MyNoPiece new.
	target := BlElement new
		  geometry: BlCircleGeometry new;
		  background: (Color gray alpha: 0.3).

	self layout: BlFrameLayout new.

	label := BlTextElement new.
	label constraintsDo: [ :c | c padding: (BlInsets all: 3) ].

	piece := BlTextElement new.
	piece text: '' asRopedText.
	piece constraintsDo: [ :c |
		c frame horizontal alignCenter.
		c frame vertical alignCenter ].

	self
		addChild: label;
		addChild: piece.
	self
		background: Color white;
		geometry: BlSquareGeometry new.

	self addEventHandlerOn: BlClickEvent do: [ :e | self click ]
]

{ #category : 'testing' }
MyChessSquare >> isOnBoard [

	^ true
]

{ #category : 'testing' }
MyChessSquare >> isTargetHighlighted [

	^ self children includes: target
]

{ #category : 'accessing' }
MyChessSquare >> left [

	^ self + (-1 @ 0)
]

{ #category : 'accessing' }
MyChessSquare >> name [
	^ name
]

{ #category : 'accessing' }
MyChessSquare >> name: aString [

	name := aString.
	label text: (name asRopedText foreground: color negated)
]

{ #category : 'printing' }
MyChessSquare >> printOn: aStream [
	"Generate a string representation of the receiver based on its instance variables."

	super printOn: aStream.
	aStream
		nextPutAll: ' name: ';
		print: name
]

{ #category : 'rendering' }
MyChessSquare >> renderBishop: aPiece [

	^ self renderPiece: aPiece using: #(('B' 'b') ('V' 'v'))
]

{ #category : 'rendering' }
MyChessSquare >> renderKing: aPiece [

	^ self renderPiece: aPiece using: #(('K' 'k') ('L' 'l'))
]

{ #category : 'rendering' }
MyChessSquare >> renderKnight: aPiece [

	^ self renderPiece: aPiece using: #(('N' 'n') ('M' 'm'))
]

{ #category : 'rendering' }
MyChessSquare >> renderPawn: aPiece [

	^ self renderPiece: aPiece using: #(('P' 'p') ('O' 'o'))
]

{ #category : 'rendering' }
MyChessSquare >> renderPiece: aPiece using: aSymbolTable [
	"Rows: White piece, Black piece. Columns: light square, dark square."

	| symbols |
	symbols := aSymbolTable at: (aPiece isWhite ifTrue: [ 1 ] ifFalse: [ 2 ]).
	^ symbols at: (color isBlack ifTrue: [ 2 ] ifFalse: [ 1 ])
]

{ #category : 'rendering' }
MyChessSquare >> renderQueen: aPiece [

	^ self renderPiece: aPiece using: #(('Q' 'q') ('W' 'w'))
]

{ #category : 'rendering' }
MyChessSquare >> renderRook: aPiece [

	^ self renderPiece: aPiece using: #(('R' 'r') ('T' 't'))
]

{ #category : 'accessing' }
MyChessSquare >> right [
	
	^ self + (1@0)
]

{ #category : 'initialization' }
MyChessSquare >> select [
	
	self border: Color green
]

{ #category : 'highlighting' }
MyChessSquare >> unhighlightTarget [

	self removeChild: target
]

{ #category : 'initialization' }
MyChessSquare >> unselect [

	self border: BlBorder empty
]

{ #category : 'instance creation' }
MyChessSquare >> up [
	
	^ self + (0@1)
]
