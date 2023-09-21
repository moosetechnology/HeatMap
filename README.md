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
2. Select a branch to explore
    ```st
    branch := repo allBranches detect: [ :branch | branch name endsWith: 'master' ].
    ```
3. Configure the GitHeatMap
    ```st
    gitHeatMap := BLGitHeatMap new
        repository: repo;
        branchName: 'main';
        maxNumber: 10.
    ```
4. Open the visualization
    ```st
    gitHeatMap open
    ```
