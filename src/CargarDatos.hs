module CargarDatos where

import ProfesorRobot
import Data.Char(toUpper,toLower)
import Data.List(stripPrefix)
import Data.Maybe(fromJust)

---Este programa lee una tabla de texto plano con formato fijo y organiza la información en los tipos que el robot lee (el tipo "materia"). El separador de palabras no es ningún signo. El de campos es el espacio.


--- Una mejora próxima es que de alguna forma procese los datos de los sucesos que no son TPs y los guarde para hacer la tabla. Conviene mejorar el tipo "Evento" para que tenga título y archivo. Para el archivo puedo usar Maybe y enviar un archivo sólo cuando hay just nombreDeArchivo

--- Una mejora posterior es rehacer el tipo "Materia" para que incluya una lista de aulas. 

--- Otra mejora deseable es que sea el programa el que reparte el tiempo, contando la cantidad de semanas. 


---               FALTANTES
--- Agregar las variables nulas como la salida que da pl para no tps a la librería. 
--- leerTabla depura los eventos nulos. 
--
--
--- Materia.csv :
--Materia   
--Nombre Oficial: Parafernalia   
--Nombre Para Carpetas: Para2018
-- Fechas Evento EsTP
-- 01-02 Tema 1 No
-- 02-03 Tema 2 No 
-- 04-05 TP 1 Sí
-- 05-05 Tema 3 No

leerTabla :: [Char] -> Materia
leerTabla tablaCSV = Materia nombreMateria nombreCarpeta eventos 
  where 
       renglones     = lines tablaCSV
       nombreMateria = dropWhile (==' ') . fromJust . stripPrefix ("Nombre Oficial:") $ ( renglones!!1 )
       nombreCarpeta = dropWhile (==' ') . fromJust . stripPrefix ("Nombre Para Carpetas:") $ ( renglones!!2 )
       eventos       = leerEventos (drop 4 renglones)


leerEventos :: [[Char]] -> [Evento]
leerEventos (l:ls) 
                  | null (l:ls)  = []
                  | length (l:ls) == 1 = [p l]
                  | otherwise = p l : (leerEventos ls)
  where
       última = map toUpper . last . words
       p l = if ( última l == "SÍ" || última l == "SI")  then (leerTP True l) else (leerTP False l) 

leerTP :: Bool -> [Char] -> Evento
leerTP tp línea =  ((fecha, archivo),tp) 
  where
       palabras = words línea
       día = read ( takeWhile (/= '-') $ palabras!!0 ) :: Int
       mes = read ( (tail . dropWhile (/= '-')) $ palabras!!0 ) :: Int
       fecha = Fecha día mes 
       archivo = (unwords . tail. init) palabras

recuperarMaterias :: String -> [Materia]
recuperarMaterias archivo = lista
  where
    lista =  map read . lines $ archivo 
-- Esto fue copiado a app/LeerTabla.hs
--pedirTabla = do 
--   putStrLn "¿Cómo se llama la tabla de la Materia a procesar?"
--   dirección <- getLine
--   entrada <- readFile dirección
--   let materia = leerTabla entrada
--   appendFile "MateriasDelCuatrimestre.untref" $ show materia ++ "\n" 
--   putStrLn "Estos son los datos obtenidos: \n"
--  ( putStrLn . mostrarMateria ) materia
