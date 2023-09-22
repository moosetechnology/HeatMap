"
## Usage

```st
fileHeatMap := HMFileHeatMap new.
fileHeatMap rootDirectory: '/path/to/directory'.
fileHeatMap build.
fileHeatMap rootNode open

```
"
Class {
	#name : #HMFileHeatMap,
	#superclass : #HNodeBuilder,
	#instVars : [
		'rootDirectory',
		'maxValue',
		'minValue',
		'colorPalette',
		'fileValueBlock'
	],
	#category : #HeatMap
}

{ #category : #building }
HMFileHeatMap >> build [

	rootNode := HMValuedNode named: 'Root'.
	rootNode addAll: (self hnodesFrom: self rootDirectory).
	rootNode value: (rootNode children sum: #value).



	colorPalette := NSScale linear
		                range: {
				                Color white.
				                Color red };
		                domain: {
				                0.
				                (rootNode children collect: #value) max };
		                yourself.

	self updateNode: rootNode
]

{ #category : #accessing }
HMFileHeatMap >> colorPalette [

	^ colorPalette
]

{ #category : #accessing }
HMFileHeatMap >> colorPalette: anObject [

	colorPalette := anObject
]

{ #category : #accessing }
HMFileHeatMap >> fileValueBlock [

	^ fileValueBlock
]

{ #category : #accessing }
HMFileHeatMap >> fileValueBlock: anObject [

	fileValueBlock := anObject
]

{ #category : #building }
HMFileHeatMap >> hnodesFrom: aFileReference [

	^ aFileReference children collect: [ :child |
		  | node |
		  node := HMValuedNode new
			          rawModel: child;
			          collapse;
			          yourself.
		  child isDirectory
			  ifTrue: [
				  node addAll: (self hnodesFrom: child).
				  node value: (node children max: #value) ]
			  ifFalse: [ node value: (self fileValueBlock value: child) ].
		  node name: node value printString , ' | ' , child basename.
		  node ]
]

{ #category : #accessing }
HMFileHeatMap >> initialize [

	super initialize.
	maxValue := 0.
	minValue := 0
]

{ #category : #accessing }
HMFileHeatMap >> maxValue [

	^ maxValue
]

{ #category : #accessing }
HMFileHeatMap >> maxValue: anObject [

	maxValue := anObject
]

{ #category : #accessing }
HMFileHeatMap >> minValue [

	^ minValue
]

{ #category : #accessing }
HMFileHeatMap >> minValue: anObject [

	minValue := anObject
]

{ #category : #accessing }
HMFileHeatMap >> rootDirectory [

	^ rootDirectory
]

{ #category : #accessing }
HMFileHeatMap >> rootDirectory: anObject [

	rootDirectory := anObject asFileReference
]

{ #category : #accessing }
HMFileHeatMap >> updateNode: node [

	node color: (self colorPalette scale: node value).
	node children do: [ :child | self updateNode: child ]
]
