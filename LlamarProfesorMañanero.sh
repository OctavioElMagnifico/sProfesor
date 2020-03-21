#!/bin/sh
cd $CUATRIMESTRE
date -I > fecha.txt
TR=$(TomarParciales)
eval $TR
cd ~
