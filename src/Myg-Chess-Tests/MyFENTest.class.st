Class {
	#name : 'MyFENTest',
	#superclass : 'TestCase',
	#category : 'Myg-Chess-Tests',
	#package : 'Myg-Chess-Tests'
}

{ #category : 'tests' }
MyFENTest >> testCastlingInformationIsPreserved [

	| game |
	game := MyFENParser parse: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR b Kq - 12 23'.
	self assert: game castlingAbility asArray equals: #($K $q).
	self assert: game sideToMove equals: 'Black'.
	self assert: game moveCount equals: 23
]

{ #category : 'tests' }
MyFENTest >> testLoadCompressedPosition [

	| game board occupied |
	game := MyChessGame fromFENString: '4k3/8/8/8/3P4/8/8/4K3 w - - 0 1'.
	board := game pieces first board.
	occupied := game pieces collect: [ :each | each square name ].
	self assert: occupied asSortedCollection asArray equals: #('d4' 'e1' 'e8').
	self assert: (board at: 'd4') contents class equals: MyPawn.
	self assert: (board at: 'd4') contents isWhite.
	self assert: (board at: 'e1') contents class equals: MyKing.
	self assert: (board at: 'e1') contents isWhite.
	self assert: (board at: 'e8') contents class equals: MyKing.
	self deny: (board at: 'e8') contents isWhite
]

{ #category : 'tests' }
MyFENTest >> testOptionalFieldsConsumeOnlyTheirOwnInput [
	| parser |
	parser := MyFENParser forString: '- -'.
	self assert: parser parseCastlingAbility equals: 'NO CASTLING'.
	parser expectString: ' '.
	self assert: parser parseEnPassant equals: 'NO ENPASSANT'.
	parser := MyFENParser forString: 'Kq e3'.
	self assert: parser parseCastlingAbility asArray equals: #($K $q).
	parser expectString: ' '.
	self assert: parser parseEnPassant equals: #($e $3).
	self assert: (MyFENParser forString: 'a6') parseEnPassant equals: #($a $6)
]

{ #category : 'tests' }
MyFENTest >> testParseRanksExpandsEmptySquares [
	self assert: (MyFENParser forString: '8') parseRank asArray
	 equals: #('empty' 'empty' 'empty' 'empty' 'empty' 'empty' 'empty' 'empty').
	self assert: (MyFENParser forString: 'p2rQknB') parseRank asArray
	 equals: #('Black pawn' 'empty' 'empty' 'Black rook' 'White queen' 'Black king' 'Black knight' 'White bishop').
	self assert: (MyFENParser forString: '2p2K2') parseRank asArray
	 equals: #('empty' 'empty' 'Black pawn' 'empty' 'empty' 'White king' 'empty' 'empty')
]

{ #category : 'tests' }
MyFENTest >> testRejectMalformedRanks [

	#('7' '9' '0K7' '8P' 'PPPPPPPPP') do: [ :rank |
	 self should: [ (MyFENParser forString: rank) parseRank ] raise: Error ]
]
