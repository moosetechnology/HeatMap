"
# Initialize

To initialize this heat map: 

1. Create a repository using LibGit
```
| repo branch |
repo := IceLibgitRepository new
	name: 'aName';
	location: ('D:\Path\To\Folder' asFileReference);
	initBare: false;
	yourself.
```
2. Select a branch to explore
```
| branch repo |
branch := repo allBranches detect: [ :branch | branch name endsWith: 'master' ].
```
3. Configure the GitHeatMap
```
| gitHeatMap repo |
gitHeatMap := BLGitHeatMap new
	repository: repo;
	branchName: 'main';
	maxNumber: 10.
```
4. Open the visualization
```
| gitHeatMap |
gitHeatMap open
```
"
Class {
	#name : #BLGitHeatMap,
	#superclass : #SpPresenter,
	#instVars : [
		'repository',
		'maxNumber',
		'branchName',
		'dictionnaryClassFrequence',
		'packagesList',
		'heatMap',
		'heatMapBuilder'
	],
	#category : #'BL-HeatMap'
}

{ #category : #api }
BLGitHeatMap class >> defaultSpec [

	^ SpBoxLayout newLeftToRight
		  add: #packagesList width: self buttonWidth * 2;
		  add: #heatMap;
		  yourself
]

{ #category : #api }
BLGitHeatMap class >> title [
	^ 'Git HeatMap explorer'
]

{ #category : #accessing }
BLGitHeatMap >> branchName [

	^ branchName
]

{ #category : #accessing }
BLGitHeatMap >> branchName: anObject [

	branchName := anObject
]

{ #category : #'private - accessing' }
BLGitHeatMap >> frequences [

	"return the frequence of changes for each class"

	| dictionnaryClassFrequence |
	dictionnaryClassFrequence := Dictionary new.
	self walker commitsDo: [ :commit | 
		(commit changesFromCommit: commit ancestors first) do: [ :change | 
			| fileChanged |
			fileChanged := change path segments last.
			dictionnaryClassFrequence at: fileChanged ifAbsentPut: 0.
			dictionnaryClassFrequence
				at: fileChanged
				put: (dictionnaryClassFrequence at: fileChanged) + 1 ] ].
	^ dictionnaryClassFrequence
]

{ #category : #api }
BLGitHeatMap >> initialize [
	super initialize.
	maxNumber := 10.
]

{ #category : #api }
BLGitHeatMap >> initializePresenters [

	packagesList := self newList.
	heatMap := SpRoassalPresenter new.
	heatMapBuilder := BLHeatMap new
		                  container: heatMap canvas;
		                  yourself.
]

{ #category : #accessing }
BLGitHeatMap >> maxNumber [

	^ maxNumber
]

{ #category : #accessing }
BLGitHeatMap >> maxNumber: anObject [

	maxNumber := anObject.
	self refreshDiagram
]

{ #category : #api }
BLGitHeatMap >> refreshDiagram [

	heatMap refresh.
	dictionnaryClassFrequence := self frequences.
	packagesList items: dictionnaryClassFrequence keys.
	heatMapBuilder
		elements: dictionnaryClassFrequence keys;
		property: [ :key | dictionnaryClassFrequence at: key ].
	heatMapBuilder container: heatMap canvas.
	heatMapBuilder build.

	heatMap canvas zoomToFit
]

{ #category : #accessing }
BLGitHeatMap >> repository [

	^ repository
]

{ #category : #accessing }
BLGitHeatMap >> repository: anObject [

	repository := anObject.
	self refreshDiagram
]

{ #category : #'private - accessing' }
BLGitHeatMap >> walker [
	| branch |
	branch := self repository allBranches detect: [ :branch2 | branch2 name endsWith: self branchName ].
	^ self repository newCommitWalk
		fromBranch: branch;
		maxNumber: self maxNumber
]
