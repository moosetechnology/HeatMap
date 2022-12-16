# HeatMap

A heat map browser of the last modification of a git repository 

## Installation

- Install a MooseImage (or better, [MooseBL image](https://gitlab.forge.berger-levrault.com/Benoit.VERHAEGHE/bl-moose)).
- Clone the project with Iceberg.
- Install the default baseline.

### Form a playground

```st
Metacello new
  repository: 'gitlab://gitlab.forge.berger-levrault.com:bl-drit/bl.drit.products/bl-moose/critics-integration/HeatMap:main/src';
  baseline: 'CasinoSeditRHImporter';
  onConflict: [ :ex | ex useIncoming ];
  onUpgrade: [ :ex | ex useIncoming ];
  onDowngrade: [ :ex | ex useLoaded ];
  load
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
