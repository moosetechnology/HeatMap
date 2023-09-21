Class {
	#name : #HMHeatMap,
	#superclass : #HSimpleVisualizationBuilder,
	#instVars : [
		'elements',
		'property',
		'valueMax',
		'valueMin',
		'colorMax',
		'colorMin'
	],
	#category : #HeatMap
}

{ #category : #'public - hooks' }
HMHeatMap >> borderFor: node [

	^ RSBorder new
		  width: 1;
		  capSquare;
		  joinMiter;
		  color: Smalltalk ui theme textColor;
		  yourself
]

{ #category : #building }
HMHeatMap >> build [

	self buildNodes.
	super build.
	self container @ RSCanvasController
]

{ #category : #building }
HMHeatMap >> buildElementNode: anElement [

	| elementValue |
	elementValue := property value: anElement.
	self updateValueRange: elementValue.

	^ HMValuedNode new
		  name: elementValue printString, ' | ', anElement printString;
		  rawModel: anElement;
		  value: elementValue;
		  yourself
]

{ #category : #building }
HMHeatMap >> buildNodes [

	| allNodes |
	rootNode := HNode new.
	allNodes := elements collect: [ :elt | self buildElementNode: elt ].

	colorPalette := NSScale linear
		                range: { 
				                colorMin.
				                colorMax };
		                domain: { 
				                valueMin.
				                valueMax };
		                yourself.

	allNodes do: [ :node | self updateNodeColor: node ].
	rootNode addAll: (allNodes sorted: [ :a :b | a value < b value ]).

	"super build"
]

{ #category : #accessing }
HMHeatMap >> colorMax [

	^ colorMax
]

{ #category : #accessing }
HMHeatMap >> colorMax: anObject [

	colorMax := anObject
]

{ #category : #accessing }
HMHeatMap >> colorMin [

	^ colorMin
]

{ #category : #accessing }
HMHeatMap >> colorMin: anObject [

	colorMin := anObject
]

{ #category : #accessing }
HMHeatMap >> elements [

	^ elements
]

{ #category : #accessing }
HMHeatMap >> elements: anObject [

	elements := anObject
]

{ #category : #initialization }
HMHeatMap >> initialize [

	super initialize.
	valueMax := nil.
	valueMin := nil.
	colorMin := Color white.
	colorMax := Color red.
	elements := #(  ).
	property := [ :elt | 0 ]
]

{ #category : #accessing }
HMHeatMap >> property [

	^ property
]

{ #category : #accessing }
HMHeatMap >> property: anObject [

	property := anObject
]

{ #category : #building }
HMHeatMap >> updateNodeColor: node [
	node color: (colorPalette scale: node level).
	node children do: [ :child| self updateNodeColor: child ].
	
]

{ #category : #building }
HMHeatMap >> updateValueRange: aValue [

	valueMin
		ifNil: [ valueMin := aValue ]
		ifNotNil: [ valueMin := valueMin min: aValue ].
	valueMax
		ifNil: [ valueMax := aValue ]
		ifNotNil: [ valueMax := valueMax max: aValue ]
]

{ #category : #accessing }
HMHeatMap >> valueMax [

	^ valueMax
]

{ #category : #accessing }
HMHeatMap >> valueMin [

	^ valueMin
]
