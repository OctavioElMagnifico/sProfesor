module Pruebas where
import ProfesorRobot

texto :: [Char]
texto = "Materia Análisis \"CarpetaE\" \"CarpetaS\" [(Fecha 1 3,\"TP1\"),(Fecha 2 4,\"TP2\")]"

análisis = read texto :: Materia

main = do 
  putStrLn texto


