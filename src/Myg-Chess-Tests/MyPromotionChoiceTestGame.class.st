Class {
	#name : 'MyPromotionChoiceTestGame',
	#superclass : 'MyChessGame',
	#instVars : [
		'promotionChoice',
		'promotionRequests'
	],
	#category : 'Myg-Chess-Tests',
	#package : 'Myg-Chess-Tests'
}

{ #category : 'promotion' }
MyPromotionChoiceTestGame >> choosePromotionPiece [

	promotionRequests := promotionRequests + 1.
	^ promotionChoice
]

{ #category : 'initialize' }
MyPromotionChoiceTestGame >> initialize [

	super initialize.
	promotionChoice := MyKnight.
	promotionRequests := 0
]

{ #category : 'accessing' }
MyPromotionChoiceTestGame >> promotionChoice: aClass [

	promotionChoice := aClass
]

{ #category : 'accessing' }
MyPromotionChoiceTestGame >> promotionRequests [

	^ promotionRequests
]
