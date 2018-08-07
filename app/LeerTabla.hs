import ProfesorRobot
import CargarDatos

main = do 
   putStrLn "¿Cómo se llama la tabla de la Materia a procesar?"
   dirección <- getLine
   entrada <- readFile dirección
   let materia = leerTabla entrada
   appendFile "MateriasDelCuatrimestre.untref" $ show materia ++ "\n" 
   putStrLn "Estos son los datos obtenidos: \n"
   ( putStrLn . mostrarMateria ) materia
