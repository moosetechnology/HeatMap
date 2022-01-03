Class {
	#name : #BLValuedNode,
	#superclass : #HNode,
	#instVars : [
		'value'
	],
	#category : #'BL-HeatMap'
}

{ #category : #accessing }
BLValuedNode >> level [
	"compatibility with HSimpleVisualizationBuilder"
	^self value
]

{ #category : #accessing }
BLValuedNode >> value [
	^ value
]

{ #category : #accessing }
BLValuedNode >> value: anObject [

	value := anObject
]
