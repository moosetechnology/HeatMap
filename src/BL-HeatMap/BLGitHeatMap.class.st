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
	#superclass : #Object,
	#instVars : [
		'repository',
		'maxNumber',
		'branchName'
	],
	#category : #'BL-HeatMap'
}

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

{ #category : #accessing }
BLGitHeatMap >> maxNumber [

	^ maxNumber
]

{ #category : #accessing }
BLGitHeatMap >> maxNumber: anObject [

	maxNumber := anObject
]

{ #category : #api }
BLGitHeatMap >> open [
	"Open the GitHeatMap based on the repository"
	self frequences
]

{ #category : #accessing }
BLGitHeatMap >> repository [

	^ repository
]

{ #category : #accessing }
BLGitHeatMap >> repository: anObject [

	repository := anObject
]

{ #category : #'private - accessing' }
BLGitHeatMap >> walker [
	| branch |
	branch := self repository allBranches detect: [ :branch2 | branch2 name endsWith: 'master' ].
	^ self repository newCommitWalk
		fromBranch: branch;
		maxNumber: self maxNumber
]
