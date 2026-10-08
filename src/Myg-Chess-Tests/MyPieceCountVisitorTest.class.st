Class {
	#name : 'MyPieceCountVisitorTest',
	#superclass : 'TestCase',
	#category : 'Myg-Chess-Tests',
	#package : 'Myg-Chess-Tests'
}

{ #category : 'tests' }
MyPieceCountVisitorTest >> testInventoryCountsKindsAndRefreshesAfterCapture [

	| game board visitor initial expected |
	game := MyChessGame fromFENString: 'rnb1kbn1/8/8/8/3N4/8/PPPPPP2/RNBQKBNR w - - 0 1'.
	board := game pieces first board.
	visitor := MyPieceCountVisitor new.
	expected := Dictionary newFrom: {
		#pawn -> 6. #knight -> 5. #bishop -> 4.
		#rook -> 3. #king -> 2. #queen -> 1 }.
	initial := visitor countPiecesOn: board.
	self assert: initial equals: expected.
	self assert: (game move: (board at: 'a2') contents to: (board at: 'a4')).
	self assert: (game move: (board at: 'a8') contents to: (board at: 'a4')).
	expected at: #pawn put: 5.
	self assert: (visitor countPiecesOn: board) equals: expected.
	self assert: (initial at: #pawn) equals: 6.
	expected keys do: [ :kind | expected at: kind put: 0 ].
	self assert: (visitor countPiecesOn: MyChessBoard empty) equals: expected
]
