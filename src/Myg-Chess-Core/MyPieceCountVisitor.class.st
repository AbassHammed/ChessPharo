Class {
	#name : 'MyPieceCountVisitor',
	#superclass : 'Object',
	#instVars : [
		'counts'
	],
	#category : 'Myg-Chess-Core',
	#package : 'Myg-Chess-Core'
}

{ #category : 'counting' }
MyPieceCountVisitor >> countPiecesOn: aBoard [

	counts := Dictionary new.
	#(pawn knight bishop rook queen king) do: [ :kind |
		counts at: kind put: 0 ].
	aBoard children do: [ :square | square contents acceptVisitor: self ].
	^ counts
]

{ #category : 'counting' }
MyPieceCountVisitor >> increment: aKind [

	counts at: aKind put: (counts at: aKind) + 1
]

{ #category : 'visiting' }
MyPieceCountVisitor >> visitBishop: aBishop [

	self increment: #bishop
]

{ #category : 'visiting' }
MyPieceCountVisitor >> visitKing: aKing [

	self increment: #king
]

{ #category : 'visiting' }
MyPieceCountVisitor >> visitKnight: aKnight [

	self increment: #knight
]

{ #category : 'visiting' }
MyPieceCountVisitor >> visitNoPiece: aNoPiece [
	"An empty square does not add a piece to the inventory."

	^ self
]

{ #category : 'visiting' }
MyPieceCountVisitor >> visitPawn: aPawn [

	self increment: #pawn
]

{ #category : 'visiting' }
MyPieceCountVisitor >> visitQueen: aQueen [

	self increment: #queen
]

{ #category : 'visiting' }
MyPieceCountVisitor >> visitRook: aRook [

	self increment: #rook
]
