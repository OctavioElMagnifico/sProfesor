>module ProfesorRobot where

>import Data.Maybe(fromJust,isJust,isNothing)
>import Data.List

import Data.Time.Calendar

---Parte 1: El robot sabe reaccionar al dato de la fecha actual escribiendo un guión bash que en particular puede enviar parciales a dropbox usando rclone 


El objeto de este primer programa es lograr un sistema que detecte en base a un archivo sencillo tablaDeMaterias  escrito a mano en qué días se debe entregar las consignas de los trabajos prácticos a los alumnos. 

Una vez que dispone de esta información, escribe un guión de Bash que indica qué archivos se deben copiar desde qué origen hasta qué destino en el día. 

Está pensado para que Crond lo llame todos los días.

El tipo Fecha no aclara el año. La naturaleza cuatrimestral del proceso lo hace innecesario. No sería mala idea añadir una instancia donde esto se controle. 

Necesito derivar varias instancias a clases de tipos para poder realizar operaciones necesarias más tarde. Por ejemplo, no puedo constatar si una fecha está en una lista sin disponer de la instancia de Eq de la clase Fecha. 

-----------------   Declaración de Tipos y sus Funciones Asociadas

>data Fecha = Fecha Int Int
>    deriving (Eq,Ord,Show,Read)

>día :: Fecha -> Int
>día (Fecha a b) = a

>mes :: Fecha -> Int
>mes (Fecha a b) = b

----
showF f = Prelude.show(día f) ++ "/" ++ Prelude.show(mes f)

instance Show Fecha where
 show  = showF 
----

Los eventos van a incluir el archivo que se debe mover en la fecha dada. 

>type Evento = (Fecha , [Char])


El tipo materia posee un nombre, un directorio de origen, uno de llegada y una lista de fechas.
1 - Sería interesante ordenar los directorios de tal forma que sólo agrege cierto trozo a una ruta predecible para definir cada materia.

>data Materia = Materia [Char] [Char] [Evento] 
>  deriving (Show,Read)

>nombre :: Materia -> [Char]
>nombre (Materia n dirs f) = n

>directorios :: Materia -> [Char]
>directorios  (Materia n dirs f) = dirs

>fechas :: Materia -> [Evento]
>fechas (Materia n dirs f) = f

>mostrarMateria :: Materia -> [Char]
>mostrarMateria m  = "\nNombre: " ++ nombre m ++ "\n" ++ "Nombre de las Carpetas: " ++ directorios m ++ "\n" ++ "Fechas: " ++ show(fechas m)
 

--------------- Función Rinden 

La función "rinden" recibe una fecha como argumento y la lista de todas las materias. Devuelve las materias que van a recibir cosas, en pares con las cosas a dar.

>type MatEv = (Materia,[Char])


>rinden :: Fecha -> [Materia] -> [MatEv]
>rinden f ms =  ((map s) . (filter p))  (zip ms es)
>  where es = map (lookup f . fechas) ms
>        p (a,b)  = b /= Nothing 
>        s (a,b)  = (a,fromJust b)

------------ Función aRclone
Esta función va a tomar una lista de pares materias que sabemos que tienen que rendir con sus respectivos eventos, va a mirar qué les toca rendir y va a armar el comando de rclone que lleva el archivo desde donde lo tenemos guardado hasta la carpeta donde los alumnos lo pueden ver.  

>aRclone :: Fecha -> [Materia] -> [[Char]]
>aRclone f ms = map (comandoRclone f) hoyRinden
>   where hoyRinden = rinden f ms

>comandoRclone :: Fecha -> MatEv -> [Char]
>comandoRclone f (m,archivo) = copiar ++ depósito  ++ directorios m ++ "/" ++ archivo ++ ".pdf"  ++ " " ++ público ++ "/" ++ directorios m   

>copiar = "rclone copy "
>depósito = "~/ProfesorRobot/Pruebas/Salida/"
>público = "instituto:Octavio/ProfesorRobot/Pruebas/Entrada/"

Esta es una función de E/S utilitaria que permite separar las diferentes ordenes generadas. Seguro ya estaba incorporada, pero no encontré el nombre. 

>darOrden :: [[Char]] -> [Char]
>darOrden []     = []
>darOrden [c]    = c
>darOrden (c:cs) = c ++ " && " ++ darOrden(cs)

La fecha la entrega BASH en un archivo de texto. Hay que darle la forma necesaria. 

>isoAFecha :: [Char] -> Fecha
>isoAFecha ls = Fecha mes día
>  where 
>        mes = (read . take 2 . drop 5) ls :: Int 
>        día = (read . drop 8) ls :: Int

--- Comando para Compartir Carpetas

https://rclone.org/commands/rclone_link/
