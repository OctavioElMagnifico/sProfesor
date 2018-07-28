#!/bin/bash
date -I > fecha.txt
TR=$(stack exec sProfesor-exe)
eval $TR
