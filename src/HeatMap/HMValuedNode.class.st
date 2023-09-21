Class {
	#name : #HMValuedNode,
	#superclass : #HNode,
	#instVars : [
		'value'
	],
	#category : #HeatMap
}

{ #category : #accessing }
HMValuedNode >> level [
	"compatibility with HSimpleVisualizationBuilder"
	^self value
]

{ #category : #accessing }
HMValuedNode >> value [
	^ value
]

{ #category : #accessing }
HMValuedNode >> value: anObject [

	value := anObject
]
