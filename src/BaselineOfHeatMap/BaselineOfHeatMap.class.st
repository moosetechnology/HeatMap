Class {
	#name : #BaselineOfHeatMap,
	#superclass : #BaselineOf,
	#category : #BaselineOfHeatMap
}

{ #category : #baselines }
BaselineOfHeatMap >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ 
			self defineDependencies: spec.
			self definePackages: spec.
			self defineGroups: spec ]
]

{ #category : #baselines }
BaselineOfHeatMap >> defineDependencies: spec [
]

{ #category : #baselines }
BaselineOfHeatMap >> defineGroups: spec [
]

{ #category : #baselines }
BaselineOfHeatMap >> definePackages: spec [

	spec package: 'HeatMap'
]
