>module ProfesorRobot where

>import Data.Maybe(fromJust,isJust,isNothing)


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

>type Actividad = (Materia,[Char])

>type Evento = ((Fecha,[Char]),Bool)

>esTP :: Evento -> Bool
>esTP (par,tp) = tp

>fechayArchivo :: Evento -> (Fecha,[Char])
>fechayArchivo (par,tp) = par

El tipo materia posee un nombre, un directorio de origen, uno de llegada y una lista de fechas.
1 - Sería interesante ordenar los directorios de tal forma que sólo agrege cierto trozo a una ruta predecible para definir cada materia.

>data Materia = Materia [Char] [Char] [Evento] 
>  deriving (Show,Read)

>nombre :: Materia -> [Char]
>nombre (Materia n dirs e) = n

>directorios :: Materia -> [Char]
>directorios  (Materia n dirs e) = dirs

>eventos :: Materia -> [Evento]
>eventos (Materia n dirs e) = e

>mostrarMateria :: Materia -> [Char]
>mostrarMateria m  = "\nNombre: " ++ nombre m ++ "\n" ++ "Nombre de las Carpetas: " ++ directorios m ++ "\n" ++ "Fechas: " ++ show ( eventos m )


>dirDepósito :: Materia -> String
>dirDepósito m = raiz ++ período ++ directorios m ++ "/Parciales/"

>dirPúblico :: Materia -> String
>dirPúblico m = raiz ++ período ++ directorios m ++ "/VisibleAlumnos/"

--------------- Función Rinden

La función "rinden" recibe una fecha como argumento y la lista de todas las materias. Devuelve las materias que van a recibir cosas, en pares con las cosas a dar.



>rinden :: Fecha -> [Materia] -> [Actividad]
>rinden f ms =   map q . filter p $ zip ms es
>  where es = map (lookup f) tps
>        tps = map (map fechayArchivo . filter esTP . eventos) ms
>        p (a,b)  = b /= Nothing
>        q (a,b)  = (a,fromJust b)

------------ Función aRclone

Esta función va a tomar una lista de pares materias que sabemos que tienen que rendir con sus respectivos eventos, va a mirar qué les toca rendir y va a armar el comando de rclone que lleva el archivo desde donde lo tenemos guardado hasta la carpeta donde los alumnos lo pueden ver.

>aRclone :: Fecha -> [Materia] -> [[Char]]
>aRclone f ms = map (comandoRclone f) hoyRinden
>   where hoyRinden = rinden f ms

>comandoRclone :: Fecha -> Actividad -> [Char]
>comandoRclone f (m,archivo) = copiar ++ (dirDepósito m) ++ subsanarTexto archivo ++ ".pdf"  ++ " " ++ (dirPúblico m)



>copiar = "rclone copy "
>raiz = "instituto:UNTREF/"
>período = "Cuatrimestre2-2018/"

-------- Función darOrden

Esta es una función de E/S utilitaria que permite separar las diferentes ordenes generadas. Seguro ya estaba incorporada, pero no encontré el nombre.

>darOrden :: [[Char]] -> [Char]
>darOrden []     = []
>darOrden [c]    = c
>darOrden (c:cs) = c ++ " && " ++ darOrden(cs)

-------- Función subsanarTexto

La etapa de la generación de la orden es sensible dado que los comandos BASH necesitan que se aplique escapado a varios signos. Por eso es importante controlar con cuidado las partes de la salida a BASH donde aparece texto ingresado por el usuario.

Más allá de esta precaución, lo mejor es filtrar el uso del caracter ' ' en las entradas.

El nombre de la carpeta y el del archivo son los primeros puntos donde aparecieron problemas.

>subsanarTexto :: String -> String
>subsanarTexto ss 
>                | null ps = preEspacio
>                | otherwise = preEspacio ++ "\\ " ++ subsanarTexto (tail ps)
>  where (preEspacio,ps) = span (/= ' ') ss


La fecha la entrega BASH en un archivo de texto. Hay que darle la forma necesaria.

>isoAFecha :: [Char] -> Fecha
>isoAFecha ls = Fecha mes día
>  where
>        día = (read . take 2 . drop 5) ls :: Int
>        mes = (read . drop 8) ls :: Int

--- Comando para Compartir Carpetas

https://rclone.org/commands/rclone_link/
