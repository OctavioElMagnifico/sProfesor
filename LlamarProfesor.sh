#!/bin/bash
cd /mnt/Archivos/Cuatrimestre2-2018/
date -I --date="tomorrow" > fecha.txt
TR=$(TomarExamenes.hs)
eval $TR
cd ~
