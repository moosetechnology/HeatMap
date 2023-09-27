Class {
	#name : #HMHeatSunburstBuilder,
	#superclass : #RSSunburstBuilder,
	#instVars : [
		'maxValue',
		'minValue',
		'colorPalette',
		'nodeValueBlock',
		'childrenBlock',
		'root',
		'colorMin',
		'colorMax'
	],
	#category : #HeatMap
}

{ #category : #accessing }
HMHeatSunburstBuilder >> build [

	super build.


	self rootNodes do: [ :node | self updateNodeValue: node ].
	colorPalette := NSScale linear
		                range: {
				                self colorMin.
				                self colorMax };
		                domain: {
				                0.
				                (self rootNodes collect: [ :slice |
						                 slice propertyAt: #value ]) max };
		                yourself.

	self rootNodes do: [ :node | self updateNodeColor: node ]
]

{ #category : #api }
HMHeatSunburstBuilder >> buildShapes [
	self from: self root using: self childrenBlock.
]

{ #category : #accessing }
HMHeatSunburstBuilder >> childrenBlock [

	^ childrenBlock
]

{ #category : #accessing }
HMHeatSunburstBuilder >> childrenBlock: anObject [

	childrenBlock := anObject
]

{ #category : #accessing }
HMHeatSunburstBuilder >> colorMax [

	^ colorMax
]

{ #category : #accessing }
HMHeatSunburstBuilder >> colorMax: anObject [

	colorMax := anObject
]

{ #category : #accessing }
HMHeatSunburstBuilder >> colorMin [

	^ colorMin
]

{ #category : #accessing }
HMHeatSunburstBuilder >> colorMin: anObject [

	colorMin := anObject
]

{ #category : #accessing }
HMHeatSunburstBuilder >> colorPalette [

	^ colorPalette
]

{ #category : #accessing }
HMHeatSunburstBuilder >> colorPalette: anObject [

	colorPalette := anObject
]

{ #category : #initialization }
HMHeatSunburstBuilder >> initialize [

	super initialize.
	colorMin := Smalltalk ui theme backgroundColor.
	colorMax := Color red
]

{ #category : #accessing }
HMHeatSunburstBuilder >> maxValue [

	^ maxValue
]

{ #category : #accessing }
HMHeatSunburstBuilder >> maxValue: anObject [

	maxValue := anObject
]

{ #category : #accessing }
HMHeatSunburstBuilder >> minValue [

	^ minValue
]

{ #category : #accessing }
HMHeatSunburstBuilder >> minValue: anObject [

	minValue := anObject
]

{ #category : #accessing }
HMHeatSunburstBuilder >> nodeValueBlock [

	^ nodeValueBlock
]

{ #category : #accessing }
HMHeatSunburstBuilder >> nodeValueBlock: anObject [

	nodeValueBlock := anObject
]

{ #category : #accessing }
HMHeatSunburstBuilder >> root [

	^ self rootNodes
]

{ #category : #accessing }
HMHeatSunburstBuilder >> root: anObject [

	self rootNodes: { anObject }
]

{ #category : #accessing }
HMHeatSunburstBuilder >> updateNodeColor: node [

	node schildren do: [ :child | self updateNodeColor: child ].
	node color: (self colorPalette scale: (node propertyAt: #value))
]

{ #category : #accessing }
HMHeatSunburstBuilder >> updateNodeValue: node [

	node schildren
		ifNotEmpty: [ :children |
			children do: [ :child | self updateNodeValue: child ].
			node
				propertyAt: #value
				put:
				(node schildren collect: [ :child | child propertyAt: #value ])
					max ]
		ifEmpty: [
			node
				propertyAt: #value
				put: (self nodeValueBlock value: node model) ]
]
