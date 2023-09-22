"
## Builder config

**Mandatory**

- `rootDirectory:`: the path to the directory root of the file heat map
- `fileValueBlock:`: the way to compute the hot of a file

**Optional**

- `collapseBlock:`: executed after `fileValueBlock:`, it should return a boolean to indicate if the node should be collapse or not by default. Default value is true
- `hideFileBlock:`: return `true` for the files that do not need to create a node in the visualisation

## Example

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
		'fileValueBlock',
		'collapseBlock',
		'hideNodeBlock'
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
				                Smalltalk ui theme backgroundColor.
				                Color red };
		                domain: {
				                0.
				                (rootNode children collect: #value) max };
		                yourself.

	self updateNode: rootNode
]

{ #category : #building }
HMFileHeatMap >> buildLayoutFor: node [

	^ RSFlowLayout new
		alignment: #middle;
		gapSize: 10;
		yourself
]

{ #category : #accessing }
HMFileHeatMap >> collapseBlock [

	^ collapseBlock
]

{ #category : #accessing }
HMFileHeatMap >> collapseBlock: anObject [

	collapseBlock := anObject
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

{ #category : #accessing }
HMFileHeatMap >> hideNodeBlock [

	^ hideNodeBlock
]

{ #category : #accessing }
HMFileHeatMap >> hideNodeBlock: anObject [

	hideNodeBlock := anObject
]

{ #category : #building }
HMFileHeatMap >> hnodesFrom: aFileReference [

	^ ((aFileReference children collect: [ :child |
		    | node |
		    node := HMValuedNode new
			            rawModel: child;
			            style: HMFileHeatMapStyle new;
			            yourself.
		    node layout: (self buildLayoutFor: node).
		    child isDirectory
			    ifTrue: [
				    node addAll: (self hnodesFrom: child).
				    node value: (node children
						     ifEmpty: [ 0 ]
						     ifNotEmpty: [ :children | children max: #value ]) ]
			    ifFalse: [ node value: (self fileValueBlock value: child) ].
		    (self collapseBlock value: node) ifTrue: [ node collapse ].
		    node name: node value printString , ' | ' , child basename.
		    node ]) reject: [ :node | self hideNodeBlock value: node ])
		  sorted: #value descending
]

{ #category : #accessing }
HMFileHeatMap >> initialize [

	super initialize.
	maxValue := 0.
	minValue := 0.
	collapseBlock := [ :node | true ].
	self hideNodeBlock: [ :file | false ]
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
