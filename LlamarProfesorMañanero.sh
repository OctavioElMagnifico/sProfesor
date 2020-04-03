#!/us/bin/env bash
PATH="$HOME/.local/bin:$PATH"
cd $CUATRIMESTRE
date -I > fecha.txt
TR=$(TomarParciales)
eval $TR
cd ~
