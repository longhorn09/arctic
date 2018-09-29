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
