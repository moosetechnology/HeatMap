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
	#category : #'BL.HeatMap'
}

{ #category : #accessing }
BLGitHeatMap >> maxNumber [

	^ maxNumber
]

{ #category : #accessing }
BLGitHeatMap >> maxNumber: anObject [

	maxNumber := anObject
]

{ #category : #accessing }
BLGitHeatMap >> repository [

	^ repository
]

{ #category : #accessing }
BLGitHeatMap >> repository: anObject [

	repository := anObject
]
