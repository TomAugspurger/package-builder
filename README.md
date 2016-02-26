About
-----

This repo is a holding area for recipes to fill a conda channel. The builder is based on https://github.com/conda-forge/conda-smithy and https://github.com/conda-forge/staged-recipes/.

The resulting conda packages can be found in the [`janschulz` anaconda channel](https://anaconda.org/janschulz/).

If you want to use packages from this channel:

```
conda install -c janschulz pypandoc
```

You can also permanently add the channel so that you don't need to add `-c janschul` to each `conda install` and `conda update`:

```
conda config --add channels http://conda.anaconda.org/janschulz
conda install pypandoc
```

Build status
------------

[![Circle CI](https://circleci.com/gh/TomAugspurger/package-builder/tree/master.svg?style=svg)](https://circleci.com/gh/TomAugspurger/package-builder/tree/master)

[![Build Status](https://travis-ci.org/TomAugspurger/package-builder.svg?branch=master)](https://travis-ci.org/TomAugspurger/package-builder)

[![Build status](https://ci.appveyor.com/api/projects/status/github/TomAugspurger/package-builder?branch/master&svg=true)](https://ci.appveyor.com/project/TomAugspurger/package-builder/branch/master)

Process
-------

- fork https://github.com/JanSchulz/package-builder
- Turn on CI
  + https://travis-ci.org/profile/<GH Username>
  + https://ci.appveyor.com/project/<GH Username>/package-builder
  + https://circleci.com/add-projects
- git clone
- create an Anaconda/Binstar API key
  - `anaconda auth --create --name packageBuilder --scores 'all'`
- Encrypt the token, add to build
  - https://ci.appveyor.com/tools/encrypt -> appveyor.yml
  - `travis encrypt BINSTAR_TOKEN=<TheKey>` -> .travis.yml
  - Project Settings > Environment Variables on circle CI website.
- Write you're recipe.
- Update upload endpoints

