Class {
	#name : #HMFileHeatMap,
	#superclass : #HMHeatMap,
	#category : #HeatMap
}

{ #category : #building }
HMFileHeatMap >> hnodesFrom: aFileReference [

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
				    node value: (node children
						     ifEmpty: [ 0 ]
						     ifNotEmpty: [ :children | children max: #value ]) ]
			    ifFalse: [ node value: (self fileValueBlock value: child) ].
		    (self collapseBlock value: node) ifTrue: [ node collapse ].
		    node name: node value printString , ' | ' , child basename.
		    node ]) reject: [ :node | self hideNodeBlock value: node ])
		  sorted: #value descending
]
