import ProfesorRobot

---Este programa lee una tabla de texto plano con formato fijo y organiza la información en los tipos que el robot lee (el tipo "materia"). El separador de palabras no es ningún signo. El de campos es el espacio.


--- Una mejora próxima es que de alguna forme los datos de los sucesos que no son TPs y los guarde para hacer la tabla. 

--- Una mejora posterior es rehacer el tipo "Materia" para que incluya una lista de aulas. 

--- Otra mejora deseable es que sea el programa el que reparte el tiempo, contando la cantidad de semanas. 

LeerTabla :: [Char] -> [Char]
LeerTabla tablaCSV = "Materia" ++ nombre ++ dA ++ dE ++ eventos
  where 
       lista = lines tablaCSV
       nombre = takeWhile (/= ' ')lista!!1  
       dA = nombre 
       dE = nombre
       eventos = LeerEventos (drop 3 lista)


LeerEventos :: [Char] -> [Evento]
LeerEventos lineas 
                  |null (lineas) = []
                  |  l:[] = (p l)
                  | l:ls = p l : (LeerEventos ls)
  where
       p l = if ( (toUpper $ last (words l)) == "SÍ" || (toUpper $ last (words l)) == "SI")  then (LeerTP l) else []


LeerTP :: [Char] -> Evento
LeerTP linea  =  (fecha, archivo) 
  where
       palabras = words linea
       día = takeWhile (/= '-') palabras!!0
       mes = (tail . dropWhile (/= '-')) palabras!!1
       fecha = Fecha día mes 
       archivo = (unwords . tail. init) palabras


main = do {
   putStrLn "¿Cómo se llama la tabla de la Materia a Analizar?";
   dirección <- getLine;
   entrada <- readFile dirección;
   putStrLn (LeerTabla entrada)
}

