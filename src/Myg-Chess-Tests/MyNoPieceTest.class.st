Class {
	#name : 'MyNoPieceTest',
	#superclass : 'TestCase',
	#category : 'Myg-Chess-Tests',
	#package : 'Myg-Chess-Tests'
}

{ #category : 'tests' }
MyNoPieceTest >> testClearedSquareCanBeClickedBeforeMovingAPawn [

	| game board pawn |
	game := MyChessGame freshGame.
	board := game pieces first board.
	pawn := (board at: 'e2') contents.
	board at: 'e3' put: MyBishop black.
	(board at: 'e3') emptyContents.
	self deny: (board at: 'e3') hasPiece.
	self assert: board pieces size equals: 32.
	(board at: 'e3') click.
	(board at: 'e4') click.
	self assert: (board at: 'e2') contents identicalTo: pawn.
	self deny: (board children anySatisfy: #isTargetHighlighted).
	(board at: 'e2') click.
	(board at: 'e4') click.
	self assert: (board at: 'e4') contents identicalTo: pawn.
	self deny: (board at: 'e2') hasPiece
]

{ #category : 'tests' }
MyNoPieceTest >> testEmptyBoardRendersEmptySquaresAndContainsNoPieces [

	| board |
	board := MyChessBoard empty.
	self assert: board pieces isEmpty.
	board children do: [ :square |
	 self deny: square hasPiece.
	 self assert: square contents legalTargetSquares isEmpty ].
	self assert: ((board at: 'a1') contents renderPieceOn: (board at: 'a1')) equals: 'x'.
	self assert: ((board at: 'a2') contents renderPieceOn: (board at: 'a2')) equals: 'z'
]
