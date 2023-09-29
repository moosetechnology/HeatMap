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
		'popupNameText',
		'nodeNameBlock',
		'label',
		'maxDomainValue'
	],
	#category : #HeatMap
}

{ #category : #building }
HMHeatSunburstBuilder >> build [

	self buildShapes.
	super build.
	colorPalette := NSScale linear
		                range: {
				                self colorMin.
				                self colorMax };
		                yourself.
	RSNormalizer color
		scale: colorPalette;
		shapes: self shapes;
		normalize: [ :el |
			self maxDomainValue
				ifNotNil: [ :max | (self nodeValueBlock value: el) min: max ]
				ifNil: [ self nodeValueBlock value: el ] ].


	self shapes
	@ (RSPopup text: [ :node | self popupNameText value: node ]).
	self setActions.
	label ifNil: [
		label := RSLabel new.
		label text: 'fooo'.
		label isFixed: true.
		self canvas add: label ]
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
	shape schildren:
		(children reject: [ :child | self hideSliceBlock value: child model ]).
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
	nodeNameBlock := popupNameText := [ :el | el printString ].
]

{ #category : #accessing }
HMHeatSunburstBuilder >> maxDomainValue [

	^ maxDomainValue ifNil: [
		  self rootNodes max: [ :slice |
			  self nodeValueBlock value: slice model ] ]
]

{ #category : #accessing }
HMHeatSunburstBuilder >> maxDomainValue: anObject [

	maxDomainValue := anObject
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
HMHeatSunburstBuilder >> nodeNameBlock [

	^ nodeNameBlock
]

{ #category : #accessing }
HMHeatSunburstBuilder >> nodeNameBlock: anObject [

	nodeNameBlock := anObject
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

	| interaction |
	interaction := RSSunburstFadeInteraction new builder: self.

	self canvas shapes first
		when: RSMouseClick
		do: [ :evt |
			self updateRootWith: (self parentBlock value: evt shape model) ]
		for: self.

	(self canvas shapes allButFirst reject: #isSLeaf)
		when: RSMouseClick
		do: [ :evt | self updateRootWith: evt shape model ]
		for: self.

	self canvas shapes
		when: RSMouseEnter do: [ :evt |
			| path |
			path := (interaction pathFor: evt shape) reverse.
			path := String streamContents: [ :s |
					        path
						        do: [ :node |
							        s << (self nodeNameBlock value: node model) ]
						        separatedBy: [ s << '>>' ] ].
			label
				text: path;
				signalUpdate.
			label position: label extent / 2 ]
		for: self;
		when: RSMouseLeave do: [ :evt | label text: '' ] for: self
]

{ #category : #building }
HMHeatSunburstBuilder >> updateRootWith: aModel [

	| lastShapes newShapes oshape |
	lastShapes := self canvas shapes copy.
	self root: aModel.
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
