>module ProfesorRobot where

>import Data.Maybe(fromJust)

import Data.Time.Calendar

---Parte 1: El robot sabe reaccionar al dato de la fecha actual escribiendo un guión bash que en particular puede enviar parciales a dropbox usando rclone 


El objeto de este primer programa es lograr un sistema que detecte en base a un archivo sencillo tablaDeMaterias  escrito a mano en qué días se debe entregar las consignas de los trabajos prácticos a los alumnos. 

Una vez que dispone de esta información, escribe un guión de Bash que indica qué archivos se deben copiar desde qué origen hasta qué destino en el día. 

Está pensado para que Crond lo llame todos los días.




El tipo Fecha no aclara el año. La naturaleza cuatrimestral del proceso lo hace innecesario. No sería mala idea añadir una instancia donde esto se controle. 

Necesito derivar varias instancias a clases de tipos para poder realizar operaciones necesarias más tarde. Por ejemplo, no puedo constatar si una fecha está en una lista sin disponer de la instancia de Eq de la clase Fecha. 

-----------------   Declaración de Tipos y sus Funciones Asociadas

>data Fecha = Fecha Int Int
>    deriving (Eq,Ord,Read)

>día :: Fecha -> Int
>día (Fecha a b) = a

>mes :: Fecha -> Int
>mes (Fecha a b) = b

>showF f = Prelude.show(día f) ++ "/" ++ Prelude.show(mes f)

>instance Show Fecha where
> show  = showF 

Los eventos van a incluir el archivo que se debe mover en la fecha dada. 

>type Evento = (Fecha , [Char])

>instance Read Evento where
>  read :: String -> Evento
>  read evento = (fecha, suceso)
>    where
>      (día,mes) = words . takeWhile (/= ',') . tail  . dropWhile (/= ' ') $ evento
>      fecha     = Fecha día mes
>      suceso    = takeWhile (/= ')') . tail . dropWhile (/= ',') $ evento

El tipo materia posee un nombre, un directorio de origen, uno de llegada y una lista de fechas.
1 - Sería interesante ordenar los directorios de tal forma que sólo agrege cierto trozo a una ruta predecible para definir cada materia.

>data Materia = Materia [Char] [Char] [Char] [Evento] 

>nombre :: Materia -> [Char]
>nombre (Materia n dA dE f) = n

>directorioArchivos :: Materia -> [Char]
>directorioArchivos  (Materia n dA dE f) = dA

>directorioEntrega :: Materia -> [Char]
>directorioEntrega (Materia n dA dE f) = dE

>fechas :: Materia -> [Evento]
>fechas (Materia n dA dE f) = f

>instance Show Materia where
>  show m = nombre m

instance Read Materia where
  read texto = Materia cSalida cEntrada evs
    where
      palabras = words texto
      cSalida = palabras!!1
      cEntrada = palabras!!2
    


>mostrarMateria :: Materia -> [Char]
>mostrarMateria m  = "\nNombre:" ++ nombre m ++ "\n" ++ "Archivos: " ++ directorioArchivos m ++ "\n" ++ "Entrega: " ++ directorioEntrega m ++ "\n" ++ "Fechas: " ++ show(fechas m)
 
-------------- Tipos de Ejemplo

>s = Fecha 14 5
>análisis = Materia "Análisis" "Análisis/" "Análisis/" [(Fecha 1 3,"TP1"),(Fecha 2 4,"TP2")]
>globología = Materia "Globología" "Globología/" "Globología/" [(Fecha 14 4,"TP1"),(Fecha 2 4,"TP2")]
>t = Fecha 2 4

>materias = [análisis,globología]

--------------- Función Rinden

La función "rinden" recibe una fecha como argumento y la lista de todas las materias. Devuelve las materias que van a recibir cosas, en pares con las cosas a dar.

>type MatEv = (Materia,[Char])


>rinden :: Fecha -> [Materia] -> [MatEv]
>rinden f ms =  ((map s) . (filter p))  ( zip ms es)
>  where es = map (lookup f . fechas) ms
>        p (a,b)  = b /= Nothing 
>        s (a,b)  = (a,fromJust b)

Esta función va a tomar una lista de pares materias que sabemos que tienen que rendir con sus respectivos eventos, va a mirar qué les toca rendir y va a armar el comando de rclone que lleva el archivo desde donde lo tenemos guardado hasta la carpeta donde los alumnos lo pueden ver.  

>aRclone :: Fecha -> [Materia]-> [[Char]]
>aRclone f ms= map (comandoRclone f) mes
>   where mes = rinden f ms

>comandoRclone :: Fecha -> MatEv -> [Char]
>comandoRclone f (m,archivo) = copiar ++ salida  ++ directorioArchivos m ++ archivo++ ".pdf"  ++ " " ++ llegada ++ directorioEntrega m   

>copiar = "rclone copy "
>salida = "~/ProfesorRobot/Pruebas/Salida/"
>llegada = "instituto:Octavio/ProfesorRobot/Pruebas/Entrada/"

Esta es una función de E/S utilitaria que permite separar las diferentes ordenes generadas. Seguro ya estaba incorporada, pero no encontré el nombre. 


>darOrden :: [[Char]] -> [Char]
>darOrden [] = []
>darOrden [c] = c 
>darOrden (c:cs) = c ++ "&&" ++ darOrden(cs)


La fecha la entrega BASH en un archivo de texto. Hay que darle la forma necesaria. 

>isoAFecha :: [Char] -> Fecha
>isoAFecha ls = Fecha dd mm
>  where 
>        mm = (read . take 2 . drop 5) ls :: Int 
>        dd = (read . drop 8) ls :: Int

--- Parte 2: Lectura de la tabla y elaboración de las entradas de este programa.

el formato de la tabla es importante una opción es:
* No sería difícil pedirle a Bash que cree los directorios de Archivos y Entrega. Así nos ahorramos un problema más. 

Nombre de la Materia: Parafernalia 
Directorio de Archivos:  
Directorio de Entrega a los Alumnos: 

Fechas         Eventos   EsTP
1/1      |     Semana de Presentación | No
1/2      |     TP1  |     Sí
2/4      |     TP2    |   Sí
3/4      |     Unidad2 |  No
6/6      |     Recuperatorios | Sí

El programa tiene que leer esta tabla y generar el tipo adecuado.

Esto evidentemente no lo sé hacer. Quizás conviene usar funciones incorporadas de R. 

La base sería ingresar el documento, tomar cada línea como una lista con separador ":" o | y después filtrar lo que no necesito. Al final tendría un cierto orden y podría llevar los elementos según su posición a los atributos de la variable de tipo "materia".

