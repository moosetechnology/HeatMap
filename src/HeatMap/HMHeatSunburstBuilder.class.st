"
## API

- `childrenBlock:` isValued to determine the children of a model
- `parentBlock:` isValued to determine the parent of a model when clicking on the center of the sunburst
- `hideNodeBlock:` do not create child that answer true to the block 
"
Class {
	#name : #HMHeatSunburstBuilder,
	#superclass : #RSSunburstBuilder,
	#instVars : [
		'maxValue',
		'minValue',
		'colorPalette',
		'nodeValueBlock',
		'childrenBlock',
		'parentBlock',
		'root',
		'colorMin',
		'colorMax',
		'hideSliceBlock',
		'popupNameText'
	],
	#category : #HeatMap
}

{ #category : #building }
HMHeatSunburstBuilder >> build [

	super build.
	colorPalette := NSScale linear
		                range: {
				                self colorMin.
				                self colorMax };
		                domain: {
				                0.
				                (self rootNodes collect: [ :slice |
						                 slice propertyAt: #value ]) max };
		                yourself.

	self rootNodes do: [ :node | self updateNodeColor: node ].
	self setActions.
	self shapes
	@ (RSPopup text: [ :node | self popupNameText value: node ])
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

{ #category : #private }
HMHeatSunburstBuilder >> createElements: atree using: ablock depth: depth [

	| children shape |
	shape := self shapeFor: atree.
	shapes add: shape.

	children := ablock rsValue: atree.
	shape depth: depth.
	children := children
		            collect: [ :child |
			            | e2 |
			            e2 := self
				                  createElements: child
				                  using: ablock
				                  depth: depth + 1.
			            e2 sparent: shape.
			            e2 ]
		            as: Array.
	children
		ifEmpty: [
			shape
				propertyAt: #value
				put: (self nodeValueBlock value: shape model) ]
		ifNotEmpty: [ :childrn |
			shape
				propertyAt: #value
				put: (childrn collect: [ :child | child propertyAt: #value ]) max ].
	shape schildren:
		(children reject: [ :child | self hideSliceBlock value: child ]).
	^ shape
]

{ #category : #accessing }
HMHeatSunburstBuilder >> hideSliceBlock [

	^ hideSliceBlock
]

{ #category : #accessing }
HMHeatSunburstBuilder >> hideSliceBlock: anObject [

	hideSliceBlock := anObject
]

{ #category : #initialization }
HMHeatSunburstBuilder >> initialize [

	super initialize.
	colorMin := Smalltalk ui theme backgroundColor.
	colorMax := Color red.
	hideSliceBlock := [ :el | false ].
	popupNameText := [ :el | el printString ]
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
HMHeatSunburstBuilder >> parentBlock [

	^ parentBlock
]

{ #category : #accessing }
HMHeatSunburstBuilder >> parentBlock: anObject [

	parentBlock := anObject
]

{ #category : #accessing }
HMHeatSunburstBuilder >> popupNameText [

	^ popupNameText
]

{ #category : #accessing }
HMHeatSunburstBuilder >> popupNameText: anObject [

	popupNameText := anObject
]

{ #category : #accessing }
HMHeatSunburstBuilder >> root [

	^ self rootNodes
]

{ #category : #accessing }
HMHeatSunburstBuilder >> root: anObject [

	self rootNodes: { anObject }
]

{ #category : #building }
HMHeatSunburstBuilder >> setActions [

	self canvas shapes first
		when: RSMouseClick
		do: [ :evt |
			self updateRootWith: (self parentBlock value: evt shape model) ]
		for: self.

	(self canvas shapes allButFirst reject: #isSLeaf)
		when: RSMouseClick
		do: [ :evt | self updateRootWith: evt shape model ]
		for: self
]

{ #category : #accessing }
HMHeatSunburstBuilder >> updateNodeColor: node [

	node schildren do: [ :child | self updateNodeColor: child ].
	node color: (self colorPalette scale: (node propertyAt: #value))
]

{ #category : #building }
HMHeatSunburstBuilder >> updateRootWith: aModel [

	| lastShapes newShapes oshape |
	lastShapes := self canvas shapes copy.
	self root: aModel.
	self buildShapes.
	self build.
	newShapes := self shapes.
	newShapes size < lastShapes size
		ifTrue: [
			newShapes do: [ :new |
				| old |
				old := lastShapes shapeFromModel: new model.
				old remove ].
			oshape := lastShapes shapeFromModel: aModel.
			lastShapes do: [ :old |
				| new |
				new := RSPieSlice new.
				oshape betaAngle < old betaAngle ifTrue: [
					new
						alphaAngle: 360;
						betaAngle: 360 ].
				old depth = 1 ifTrue: [
					new
						alphaAngle: 0;
						betaAngle: 360 ].
				old remove ] ]
		ifFalse: [
			oshape := lastShapes
				          ifEmpty: [ RSPieSlice new ]
				          ifNotEmpty: [
				          newShapes shapeFromModel: lastShapes first model ].
			newShapes do: [ :new |
				| old |
				old := lastShapes shapeFromModel: new model.
				old ifNil: [
					old := RSPieSlice new.
					oshape betaAngle < new betaAngle
						ifTrue: [
							old
								alphaAngle: 360;
								betaAngle: 360 ]
						ifFalse: [
							old
								alphaAngle: 0;
								betaAngle: 0 ] ].
				new depth = 1 ifTrue: [
					old
						alphaAngle: 0;
						betaAngle: 360 ].
				old remove ] ].
	self setActions.
]
