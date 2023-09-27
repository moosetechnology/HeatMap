Class {
	#name : #HMHeatMapStyle,
	#superclass : #HDefaultStyle,
	#category : #HeatMap
}

{ #category : #'public - hooks' }
HMHeatMapStyle >> borderFor: node [

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
HMHeatMapStyle >> boxChildrenFor: anHNode [

	^ RSBox new
		  color: (self boxChildrenColorFor: anHNode);
		  border: (RSBorder new
				   width: 2;
				   color: Smalltalk ui theme baseColor;
				   yourself);
		  yourself
]
