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
		'dictionnaryJiraFrequence',
		'packagesList',
		'heatMap',
		'heatMapBuilder',
		'buttonUnselect'
	],
	#category : #'BL-HeatMap'
}

{ #category : #layout }
BLGitHeatMap class >> defaultLayout [

	"unselectAll"

	^ SpBoxLayout newLeftToRight
		  add: (SpBoxLayout newTopToBottom
				   add: #buttonUnselect height: self buttonHeight;
				   add: #packagesList;
				   yourself)
		  width: self buttonWidth * 2;
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

{ #category : #accessing }
BLGitHeatMap >> dictionnaryClassFrequence [

	^ dictionnaryClassFrequence
]

{ #category : #'private - accessing' }
BLGitHeatMap >> frequences [

	"return the frequence of changes for each class"

	self walker commitsDo: [ :commit | 
		| tag |
		tag := commit comment
			       ifNotEmpty: [ 
				       commit comment first == $[
					       ifTrue: [ commit comment allButFirst copyUpTo: $] ]
					       ifFalse: [ nil ] ]
			       ifEmpty: [ nil ].
		(commit changesFromCommit: commit ancestors first) do: [ :change | 
			| fileChanged tagDictionnary |
			fileChanged := change path segments last.

			dictionnaryClassFrequence at: fileChanged ifAbsentPut: 0.
			dictionnaryClassFrequence
				at: fileChanged
				put: (dictionnaryClassFrequence at: fileChanged) + 1.
			tag ifNotNil: [ 
				tagDictionnary := dictionnaryJiraFrequence
					                  at: tag
					                  ifAbsentPut: Dictionary new.
				tagDictionnary at: fileChanged ifAbsentPut: 0.
				"already added + 1"
				tagDictionnary
					at: fileChanged
					put: (dictionnaryClassFrequence at: fileChanged) ] ] ]
]

{ #category : #api }
BLGitHeatMap >> initialize [

	super initialize.
	maxNumber := 10.
	dictionnaryJiraFrequence := Dictionary new.
	dictionnaryClassFrequence := Dictionary new
]

{ #category : #api }
BLGitHeatMap >> initializePresenters [

	packagesList := self newList whenSelectedDo: [ :item | 
		                self packageSelected: item ].
	buttonUnselect := self newButton whenActivatedDo: [ 
		                  packagesList unselectAll.
		                  self packageAllUnselected ].
	buttonUnselect label: 'Unselect all'.
	heatMap := SpRoassalPresenter new.
	heatMapBuilder := BLHeatMap new
		                  container: heatMap canvas;
		                  yourself
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
BLGitHeatMap >> packageAllUnselected [

	heatMap refresh.
	heatMapBuilder property: [ :key | dictionnaryClassFrequence at: key ].
	heatMapBuilder container: heatMap canvas.
	heatMapBuilder build.

	heatMap canvas zoomToFit
]

{ #category : #api }
BLGitHeatMap >> packageSelected: item [

	heatMap refresh.
	heatMapBuilder property: [ :property | 
		(dictionnaryJiraFrequence at: item) at: property ifAbsent: [ 0 ] ].
	heatMapBuilder container: heatMap canvas.
	heatMapBuilder build.

	heatMap canvas zoomToFit
]

{ #category : #api }
BLGitHeatMap >> refreshDiagram [

	dictionnaryClassFrequence := Dictionary new.
	dictionnaryJiraFrequence := Dictionary new.
	self frequences.
	heatMap refresh.
	packagesList items: dictionnaryJiraFrequence keys.
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
