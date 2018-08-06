import ProfesorRobot
--- Este programa lee un archivo fecha.txt que es actualizado por Bash y nos da los comandos de copia del día.


main = do {
       entrada  <- readFile "fecha.txt";
       putStrLn( darOrden ( aRclone (isoAFecha entrada) materias) )
    }
