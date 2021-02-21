# Oligo's scripts for Arctic
Client scripts for MUSHClient

## Getting started

First create the below directories if they do not exist and ensure that the 3 files are in the following 3 file paths

```
c:\dev\luadev\test\arctic.lua
C:\Program Files (x86)\MUSHclient\worlds\arcticmud.MCL
C:\Program Files (x86)\MUSHclient\worlds\plugins\Chat_Capture_Miniwindow.xml
```

## Ensuring your Arctic settings are properly configured

Within Arctic - the scripts are sensitive to the in-game settings

The following settings need to be ```on```
```
prompt newline
opt gag_move
```

The following setting is needed so carriage return is not necessary and there are no breaks in screen output, therefore the scripts can fully capture and parse the mem and spell list.
```
opt lines 200
``` 

## Recommended Arctic settings

The following settings need to be ```off```
```
opt expert
opt compact
``` 


## 2021 Updates

Due to new buff timing descriptors in `score`, for example
```
You are affected by the following:
    resist negative energy [7 hrs]
    sanctuary            [16 hrs]
    stone skin           [1 hour]
    ancestral blessing   [permanent]
    regenerate           [3 rnds]
    spirit mastery

45H 123V 1499X 0.00% 0C Mem:1 Exits:W>
```

You need to modify `buffs_pattern` trigger to have the regex be
```
^\s\s\s\s([a-z0-9 \(\)]+)(\s+\[([0-9]+\shrs|[0-9]+\srnds|permanent|1 hour)\])?$
```
