Class {
	#name : 'MyFixedMoveStrategy',
	#superclass : 'Object',
	#instVars : [
		'move'
	],
	#category : 'Myg-Chess-Tests',
	#package : 'Myg-Chess-Tests'
}

{ #category : 'accessing' }
MyFixedMoveStrategy >> move: aMoveCommand [

	move := aMoveCommand
]

{ #category : 'playing' }
MyFixedMoveStrategy >> chooseMoveFrom: aCollection [
	"Test support: return a prescribed move instead of choosing randomly."

	^ move
]
