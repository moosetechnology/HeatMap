# HeatMap

A heat map browser of the last modification of a git repository 

## Installation

```st
Metacello new
  baseline: 'HeatMap';
  repository: 'github://moosetechnology/HeatMap:main/src';
  load.
```

## Usage

To use this heat map:

1. Create a repository using LibGit
    ```st
    | repo branch gitHeatMap |
    repo := IceLibgitRepository new
        name: 'aName';
        location: ('D:\Path\To\Folder' asFileReference);
        initBare: false;
        yourself.
    ```
2. Configure the GitHeatMap
    ```st
    gitHeatMap := HMGitHeatMap new
        branchName: 'main';
        repository: repo;
        maxNumber: 10.
    ```
3. Open the visualization
    ```st
    gitHeatMap open
    ```

## File HeatMap

You can also build a file heat map with the following piece of code:

### Using GitModel

```st

glhModel := GLHModel new.

glhApi := GLHApi new
    privateToken: '<my token>';
    baseAPIUrl:'<my base api>';
    yourself.

glhImporter := GLHModelImporter new
    glhApi: glhApi;
    glhModel: glhModel.

"137 is the ID of the a Group, you can find the number in the webpage of every project and group"
glhImporter importGroup: 131.

myProject := ((glhModel allWithType: GLHProject) select: [ :project | project name = '<project name>' ]) anyOne.
glhImporter importCommitsOf: myProject withStats: true until: '2023-01-01' asDate.


bag := Bag new.
myProject repository commits do: [ :aCommit |
(NeoJSONObject fromString: (glhApi commitDiff: aCommit id ofProject: myProject id unidiff: false)) do: [:diffFile |
        bag add: diffFile new_path asFileReference basename
    ] ].


fileHeatMap := HMFileHeatMap new.
fileHeatMap rootDirectory: 'D:\Dev\my\path'.
fileHeatMap hideNodeBlock: [ :node | node value < 20 ].
fileHeatMap fileValueBlock: [ :child | bag occurrencesOf: child basename ].
fileHeatMap collapseBlock: [ :node | node value <= 50 ].


fileHeatMap build.
fileHeatMap rootNode open. 

```

### Using Iceberg

```st
"Set up iceberg to the git project to analyse"
repo := IceLibgitRepository new
    name: 'seditRH';
    location: ('D:\Dev\my\path' asFileReference);
    initBare: false;
    yourself.

"Analyse the git history to retrieve all file modified"
gitFreq := HMGitFileFrequenceExtractor new
    branchName: 'master';
    repository: repo;
    upToCommitish:  '<full commit id>';
    yourself.
gitFreq computeFrequences.

"Build a fileFeatMap upon this first analysis"
fileHeatMap := HMFileHeatMap new.
fileHeatMap rootDirectory: 'D:\Dev\my\path'.

fileHeatMap hideNodeBlock: [ :node | node value < 20 ].
fileHeatMap fileValueBlock: [ :child | gitFreq dictionnaryClassFrequence at: child basename ifAbsent: [ 0 ] ].
fileHeatMap collapseBlock: [ :node | node value <= 50 ].

fileHeatMap build.
fileHeatMap rootNode open
```
