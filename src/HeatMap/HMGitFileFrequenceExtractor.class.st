Class {
	#name : #HMGitFileFrequenceExtractor,
	#superclass : #Object,
	#instVars : [
		'branchName',
		'dictionnaryClassFrequence',
		'dictionnaryJiraFrequence',
		'maxNumber',
		'repository',
		'toCommitish'
	],
	#category : #HeatMap
}

{ #category : #accessing }
HMGitFileFrequenceExtractor >> branchName [

	^ branchName
]

{ #category : #accessing }
HMGitFileFrequenceExtractor >> branchName: anObject [

	branchName := anObject
]

{ #category : #'private - accessing' }
HMGitFileFrequenceExtractor >> computeFrequences [
	| commits |	
	commits := self walker commits.
	commits withIndexDo: [ :commit :id | 
		| tag |
		(id printString , '/', commits size printString) recordInfo.
		commit id asString recordInfo.
		tag := commit comment
			       ifNotEmpty: [ 
				       commit comment first == $[
					       ifTrue: [ commit comment allButFirst copyUpTo: $] ]
					       ifFalse: [ nil ] ]
			       ifEmpty: [ nil ].
		commit ancestors ifNotEmpty: [ 
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
						put: (dictionnaryClassFrequence at: fileChanged) ] ] ] ]
]

{ #category : #accessing }
HMGitFileFrequenceExtractor >> dictionnaryClassFrequence [

	^ dictionnaryClassFrequence
]

{ #category : #accessing }
HMGitFileFrequenceExtractor >> dictionnaryJiraFrequence [

	^ dictionnaryJiraFrequence
]

{ #category : #initialization }
HMGitFileFrequenceExtractor >> initialize [

	super initialize.
	dictionnaryClassFrequence := Dictionary new.
	dictionnaryJiraFrequence := Dictionary new
]

{ #category : #accessing }
HMGitFileFrequenceExtractor >> maxNumber [

	^ maxNumber
]

{ #category : #accessing }
HMGitFileFrequenceExtractor >> maxNumber: anObject [

	maxNumber := anObject.
	toCommitish := nil
]

{ #category : #accessing }
HMGitFileFrequenceExtractor >> repository [

	^ repository
]

{ #category : #accessing }
HMGitFileFrequenceExtractor >> repository: anObject [

	repository := anObject
]

{ #category : #accessing }
HMGitFileFrequenceExtractor >> toCommitish [

	^ toCommitish
]

{ #category : #accessing }
HMGitFileFrequenceExtractor >> toCommitish: anObject [

	toCommitish := anObject
]

{ #category : #accessing }
HMGitFileFrequenceExtractor >> upToCommitish: aString [

	toCommitish := aString.
	maxNumber := nil
]

{ #category : #'private - accessing' }
HMGitFileFrequenceExtractor >> walker [

	| branch walker |
	branch := self repository allBranches detect: [ :branch2 |
		          branch2 name endsWith: self branchName ].
	walker := self repository newCommitWalk fromBranch: branch.
	self maxNumber ifNotNil: [ :maxNum | walker maxNumber: maxNum ].
	self toCommitish ifNotNil: [ :commitizzh |
		walker revwalk hideCommit: (LGitId fromHexString: commitizzh) ].
	^ walker
]
