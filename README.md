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
