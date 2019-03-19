>module Entorno where
>import CargarDatos
>import System.Environment
>import System.Directory

El objetivo de este módulo es tener un programa que dada la lista de materias genera el cronograma y las carpetas necesarias para que el docente pueda incluir los archivos a enviar (Por ahora, copiar los TP a carpetaDeMateria/Parciales) y para que el ProfesorRobot encuentre los directorios que necesita. De paso genera otros directorios vinculados a tareas no automáticas, un archivo de texto con el vínculo a la capeta VisibleAlumnos.

Cabe destacar que el cronograma no es el desarrollo que ahorra más esfuerzo pero en cambio tiene un mérito fundamental: incorpora una tarea rutinaria como el disparador de toda la configuración del robot.

Con algo más de esfuerzo, también va a generar comandos de CURL para levantar todas las solicitudes de archivo necesarias y generar el archivo de Enlaces. Esto requiere desarrollar de alguna forma la abstracción Aula. Probablemente esta sea un tipo individual que llame a la materia. Se ahorra reescribir código y no se pierde nada.

1- Lee todos los archivos ".untref"  y ".ulp".
2- Genera las carpetas necesarias para que el robot funcione: raíz de la materia y dentro de ella "Parciales" y "VisibleAlumnos".
3- Ingresa a la tabla "MateriasDelCuatrimestre" las materias halladas.
4- usa rclone link para obtener el vínculo de cada VisibleAlumnos y genera un archivo de texto que ya está listo para compartir y tiene el espacio para añadir las solicitudes y las explicaciones pertinentes.
5- General el cronograma en PDF. Falta decidir el formato, si uno más automático  o uno que pueda asimilarse a lo que quiere la facultad.
6- Genera las solicitudes de archivo necesarias.
7- Se asegura de no tener materias repetidas.

obtenerDirectorios :: [Materia] -> [String]
obtenerDirectorios ms = map dirBase ++ map dirDepósito ms ++ map dirPúblico ms

Cosas para revisar: las variables raiz y período, de alguna forma deberían generarse acá.

raiz = "instituto:UNTREF/"
período = "Cuatrimestre1-2019/"

------------------

crearDirectorio :: String -> String
creadDirectorio nombreCarpeta = comandoCrear ++ nombreCarpeta

--- Escribir base materia


sonMaterias :: [String] -> [String]

>sonMaterias :: [String] -> [String]
>sonMaterias = map fst . filter ( \x -> elem (snd x) [ ".untref", ".ulp" ] ) . map ( break (=='.') )
