Class {
	#name : 'MyRecordingMoveStrategy',
	#superclass : 'Object',
	#instVars : [
		'strategy',
		'choices'
	],
	#category : 'Myg-Chess-Core',
	#package : 'Myg-Chess-Core'
}

{ #category : 'instance creation' }
MyRecordingMoveStrategy class >> on: aStrategy [

	^ self new
		strategy: aStrategy;
		yourself
]

{ #category : 'accessing' }
MyRecordingMoveStrategy >> choices [

	^ choices copy
]

{ #category : 'playing' }
MyRecordingMoveStrategy >> chooseMoveFrom: aCollection [

	| move |
	move := strategy chooseMoveFrom: aCollection.
	move ifNotNil: [ choices add: move ].
	^ move
]

{ #category : 'initialization' }
MyRecordingMoveStrategy >> initialize [

	super initialize.
	choices := OrderedCollection new
]

{ #category : 'accessing' }
MyRecordingMoveStrategy >> strategy: aStrategy [

	strategy := aStrategy
]
