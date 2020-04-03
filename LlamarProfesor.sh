#!/usr/bin/env bash
PATH="$HOME/.local/bin:$PATH"
cd $CUATRIMESTRE
date -I --date="tomorrow" > fecha.txt
TR=$(TomarParciales)
echo $TR > debug.txt
echo $PATH >> debug.txt
eval $TR
cd ~
