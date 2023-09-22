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
	#name : #HMGitHeatMap,
	#superclass : #SpPresenter,
	#instVars : [
		'packagesList',
		'heatMap',
		'heatMapBuilder',
		'buttonUnselect',
		'gitFileFrequenceExtractor'
	],
	#category : #HeatMap
}

{ #category : #layout }
HMGitHeatMap class >> defaultLayout [

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
HMGitHeatMap class >> title [
	^ 'Git HeatMap explorer'
]

{ #category : #accessing }
HMGitHeatMap >> gitFileFrequenceExtractor [

	^ gitFileFrequenceExtractor
]

{ #category : #accessing }
HMGitHeatMap >> gitFileFrequenceExtractor: anObject [

	gitFileFrequenceExtractor := anObject
]

{ #category : #initialization }
HMGitHeatMap >> initialize [

	super initialize.
]

{ #category : #initialization }
HMGitHeatMap >> initializePresenters [

	packagesList := self newList whenSelectedDo: [ :item | 
		                self packageSelected: item ].
	buttonUnselect := self newButton whenActivatedDo: [ 
		                  packagesList unselectAll.
		                  self packageAllUnselected ].
	buttonUnselect label: 'Unselect all'.
	heatMap := SpRoassalPresenter new.
	heatMapBuilder := HMHeatMap new
		                  container: heatMap canvas;
		                  yourself
]

{ #category : #api }
HMGitHeatMap >> packageAllUnselected [

	heatMap refresh.
	heatMapBuilder property: [ :key | self gitFileFrequenceExtractor dictionnaryClassFrequence at: key ].
	heatMapBuilder container: heatMap canvas.
	heatMapBuilder build.

	heatMap canvas zoomToFit
]

{ #category : #api }
HMGitHeatMap >> packageSelected: item [

	heatMap refresh.
	heatMapBuilder property: [ :property | 
		(self gitFileFrequenceExtractor dictionnaryJiraFrequence at: item) at: property ifAbsent: [ 0 ] ].
	heatMapBuilder container: heatMap canvas.
	heatMapBuilder build.

	heatMap canvas zoomToFit
]

{ #category : #api }
HMGitHeatMap >> refreshDiagram [

	heatMap refresh.
	packagesList items:
		self gitFileFrequenceExtractor dictionnaryJiraFrequence keys.
	heatMapBuilder
		elements:
			self gitFileFrequenceExtractor dictionnaryClassFrequence keys;
		property: [ :key |
			self gitFileFrequenceExtractor dictionnaryClassFrequence at: key ].
	heatMapBuilder container: heatMap canvas.
	heatMapBuilder build.

	heatMap canvas zoomToFit
]
