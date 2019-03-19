import CargarDatos
import System.Environment

main = do { getArgs >>= \x ->
                       readFile (x!!0) >>=
                       appendFile "MateriasDelCuatrimestre.lista" . show . leerTabla;
                       appendFile "MateriasDelCuatrimestre.lista" "\n";
          }
