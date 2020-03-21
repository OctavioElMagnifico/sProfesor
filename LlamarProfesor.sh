#!/bin/sh
cd $CUATRIMESTRE
date -I --date="tomorrow" > fecha.txt
TR=$(TomarParciales)
eval $TR
cd ~
