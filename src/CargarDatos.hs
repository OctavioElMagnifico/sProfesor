module CargarDatos where

import ProfesorRobot
import Data.Char(toUpper)
import Data.List(stripPrefix)
import Data.Maybe(fromJust)
import System.Environment

---Este programa lee una tabla de texto plano con formato fijo y organiza la información en los tipos que el robot lee (el tipo "materia"). El separador de palabras no es ningún signo. El de campos es el espacio.


--- HECHO: Ahora incluye un booleano para aclarar. Una mejora próxima es que de alguna forma procese los datos de los sucesos que no son TPs y los guarde para hacer la tabla. Conviene mejorar el tipo "Evento" para que tenga título y archivo. Para el archivo puedo usar Maybe y enviar un archivo sólo cuando hay just nombreDeArchivo

--- Una mejora posterior es rehacer el tipo "Materia" para que incluya una lista de aulas. Probablemente va a convenir que haya un tipo Aula y que uno de los campos del mismo sea la materia.

--- Otra mejora deseable es que sea el programa el que reparte el tiempo, contando la cantidad de semanas.


---               FALTANTES
--- leerTabla depura los eventos nulos.
--- Agregar las variables nulas como la salida que da pl para no tps a la librería
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
       nombreCarpeta = mejorarNombreCarpeta . dropWhile (==' ') . fromJust . stripPrefix ("Nombre Para Carpetas:") $ ( renglones!!2 )
       eventos       = leerEventos (drop 4 renglones)

mejorarNombreCarpeta :: String -> String
mejorarNombreCarpeta = map p
  where p x = if x == ' ' then '-' else x

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

---Este ejemplo está porque el GHC de Stack no tolera caracteres UTF8.

ej = "sintildes.untref" :: String


ingresarMateria :: String -> IO Materia
ingresarMateria nombre = do  tablaMateria <- readFile nombre
                             let materia = leerTabla tablaMateria
                             appendFile "MateriasDelCuatrimestre.untref" ( show materia ++ "\n" )
                             return ( materia )
