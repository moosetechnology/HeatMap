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
fileHeatMap fileValueBlock: [ :child | child basename asString size ].
fileHeatMap build.
fileHeatMap rootNode open

```
"
Class {
	#name : #HMHeatMap,
	#superclass : #HNodeBuilder,
	#instVars : [
		'maxValue',
		'minValue',
		'colorPalette',
		'fileValueBlock',
		'collapseBlock',
		'hideNodeBlock',
		'childrenBlock',
		'root'
	],
	#category : #HeatMap
}

{ #category : #building }
HMHeatMap >> build [

	rootNode := HMValuedNode named: 'Root'.
	rootNode addAll: (self hnodesFrom: self root).
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
HMHeatMap >> buildLayoutFor: node [

	^ RSFlowLayout new
		alignment: #middle;
		gapSize: 10;
		yourself
]

{ #category : #accessing }
HMHeatMap >> childrenBlock [

	^ childrenBlock
]

{ #category : #accessing }
HMHeatMap >> childrenBlock: anObject [

	childrenBlock := anObject
]

{ #category : #building }
HMHeatMap >> childrenFor: node [

	^ self childrenBlock value: node rawValue
]

{ #category : #accessing }
HMHeatMap >> collapseBlock [

	^ collapseBlock
]

{ #category : #accessing }
HMHeatMap >> collapseBlock: anObject [

	collapseBlock := anObject
]

{ #category : #accessing }
HMHeatMap >> colorPalette [

	^ colorPalette
]

{ #category : #accessing }
HMHeatMap >> colorPalette: anObject [

	colorPalette := anObject
]

{ #category : #accessing }
HMHeatMap >> fileValueBlock [

	^ fileValueBlock
]

{ #category : #accessing }
HMHeatMap >> fileValueBlock: anObject [

	fileValueBlock := anObject
]

{ #category : #accessing }
HMHeatMap >> hideNodeBlock [

	^ hideNodeBlock
]

{ #category : #accessing }
HMHeatMap >> hideNodeBlock: anObject [

	hideNodeBlock := anObject
]

{ #category : #building }
HMHeatMap >> hnodesFrom: aFileReference [

	^ ((aFileReference children collect: [ :child |
		    | node |
		    node := HMValuedNode new
			            rawModel: child;
			            style: HMHeatMapStyle new;
			            yourself.
		    node layout: (self buildLayoutFor: node).
		    child isDirectory
			    ifTrue: [
				    node addAll: (self hnodesFrom: child).
				    node value: ((self childrenFor: node)
						     ifEmpty: [ 0 ]
						     ifNotEmpty: [ :children | children max: #value ]) ]
			    ifFalse: [ node value: (self fileValueBlock value: child) ].
		    (self collapseBlock value: node) ifTrue: [ node collapse ].
		    node name: node value printString , ' | ' , child basename.
		    node ]) reject: [ :node | self hideNodeBlock value: node ])
		  sorted: #value descending
]

{ #category : #accessing }
HMHeatMap >> initialize [

	super initialize.
	maxValue := 0.
	minValue := 0.
	collapseBlock := [ :node | true ].
	self hideNodeBlock: [ :file | false ]
]

{ #category : #accessing }
HMHeatMap >> maxValue [

	^ maxValue
]

{ #category : #accessing }
HMHeatMap >> maxValue: anObject [

	maxValue := anObject
]

{ #category : #accessing }
HMHeatMap >> minValue [

	^ minValue
]

{ #category : #accessing }
HMHeatMap >> minValue: anObject [

	minValue := anObject
]

{ #category : #accessing }
HMHeatMap >> root [

	^ root
]

{ #category : #accessing }
HMHeatMap >> root: anObject [

	root := anObject
]

{ #category : #accessing }
HMHeatMap >> updateNode: node [

	node color: (self colorPalette scale: node value).
	node children do: [ :child | self updateNode: child ]
]
