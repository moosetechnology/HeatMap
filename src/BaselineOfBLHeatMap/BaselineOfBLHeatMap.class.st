Class {
	#name : #BaselineOfBLHeatMap,
	#superclass : #BaselineOf,
	#category : #BaselineOfBLHeatMap
}

{ #category : #baselines }
BaselineOfBLHeatMap >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ 
			self defineDependencies: spec.
			self definePackages: spec.
			self defineGroups: spec ]
]

{ #category : #baselines }
BaselineOfBLHeatMap >> defineDependencies: spec [
]

{ #category : #baselines }
BaselineOfBLHeatMap >> defineGroups: spec [
]

{ #category : #baselines }
BaselineOfBLHeatMap >> definePackages: spec [

	spec package: 'BL-HeatMap'
]
