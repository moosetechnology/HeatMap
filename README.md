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

```st
fileHeatMap := HMFileHeatMap new.
fileHeatMap rootDirectory: 'D:\Dev\seditRH\e-sedit-rh\BLGRHServer\src\main\java\fr'.
fileHeatMap fileValueBlock: [ :child | gitFreq dictionnaryClassFrequence at: child basename ifAbsent: [ 0 ] ].
fileHeatMap build.
fileHeatMap rootNode open
```
