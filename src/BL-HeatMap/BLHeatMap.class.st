Class {
	#name : #BLHeatMap,
	#superclass : #HSimpleVisualizationBuilder,
	#instVars : [
		'elements',
		'property',
		'valueMax',
		'valueMin',
		'colorMax',
		'colorMin'
	],
	#category : #'BL-HeatMap'
}

{ #category : #building }
BLHeatMap >> build [
	self buildNodes.
	super build
	
]

{ #category : #building }
BLHeatMap >> buildElementNode: anElement [

	| elementValue |
	elementValue := property value: anElement.
	self updateValueRange: elementValue.

	^ BLValuedNode new
		  name: anElement printString;
		  rawModel: anElement;
		  value: elementValue;
		  yourself
]

{ #category : #building }
BLHeatMap >> buildNodes [
	| allNodes |
	rootNode := HNode new.
	allNodes := elements collect: [ :elt | self buildElementNode: elt].

	colorPalette := (NSScale linear
		range: {colorMin . colorMax} ;
		domain: {valueMin .valueMax} ;
		yourself ).

	allNodes do: [ :node | self updateNodeColor: node ].
	rootNode addAll: (allNodes sorted: [ :a :b | a value < b value ]).

	super build
	
]

{ #category : #accessing }
BLHeatMap >> colorMax [

	^ colorMax
]

{ #category : #accessing }
BLHeatMap >> colorMax: anObject [

	colorMax := anObject
]

{ #category : #accessing }
BLHeatMap >> colorMin [

	^ colorMin
]

{ #category : #accessing }
BLHeatMap >> colorMin: anObject [

	colorMin := anObject
]

{ #category : #accessing }
BLHeatMap >> elements [

	^ elements
]

{ #category : #accessing }
BLHeatMap >> elements: anObject [

	elements := anObject
]

{ #category : #initialization }
BLHeatMap >> initialize [ 
	super initialize.
	valueMax := nil.
	valueMin := nil.
	colorMin := Color white.
	colorMax := Color red.
	elements := #().
	property := [ :elt | 0 ]
]

{ #category : #accessing }
BLHeatMap >> property [

	^ property
]

{ #category : #accessing }
BLHeatMap >> property: anObject [

	property := anObject
]

{ #category : #building }
BLHeatMap >> updateNodeColor: node [
	node color: (colorPalette scale: node level).
	node children do: [ :child| self updateNodeColor: child ].
	
]

{ #category : #building }
BLHeatMap >> updateValueRange: aValue [

	valueMin
		ifNil: [ valueMin := aValue ]
		ifNotNil: [ valueMin := valueMin min: aValue ].
	valueMax
		ifNil: [ valueMax := aValue ]
		ifNotNil: [ valueMax := valueMax max: aValue ]
]

{ #category : #accessing }
BLHeatMap >> valueMax [

	^ valueMax
]

{ #category : #accessing }
BLHeatMap >> valueMin [

	^ valueMin
]
