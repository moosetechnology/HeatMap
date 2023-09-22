Class {
	#name : #HMFileHeatMapStyle,
	#superclass : #HDefaultStyle,
	#category : #HeatMap
}

{ #category : #'public - hooks' }
HMFileHeatMapStyle >> borderFor: node [

	^ node hasChildren
		  ifTrue: [
			  RSBorder new
				  width: 2;
				  capSquare;
				  joinMiter;
				  color: Smalltalk ui theme textColor;
				  dashArray: #( 5 10 );
				  yourself ]
		  ifFalse: [
			  RSBorder new
				  width: 2;
				  color: Color black translucent;
				  yourself ]
]

{ #category : #'public - hooks' }
HMFileHeatMapStyle >> boxChildrenFor: anHNode [

	^ RSBox new
		  color: (self boxChildrenColorFor: anHNode);
		  border: (RSBorder new
				   width: 2;
				   color: Smalltalk ui theme baseColor;
				   yourself);
		  yourself
]
