>module GenerarEntorno where
>import ProfesorRobot
>import CargarDatos


El objetivo de este módulo es tener un programa que dada la lista de materias genera las carpetas necesarias para que el docente pueda incluir los archivos a enviar (Por ahora, copiar los TP a carpetaDeMateria/Parciales) y para que el ProfesorRobot encuentre los directorios que necesita. De paso genera otros directorios vinculados a tareas no automáticas, un archivo de texto con el vínculo a la capeta VisibleAlumnos y el cronograma de la materia.

1- Lee el archivo MateriasDelCuatrimestre.untref
2- Con una lista de los nombres de directorio, crea las ordenes BASH que los definen.
3- usa rclone link para obtener el vínculo de cada VisibleAlumnos y genera un archivo de texto que ya está listo para compartir y tiene el espacio para añadir las solicitudes y las explicaciones pertinentes. 
4- General el cronograma en PDF. Falta decidir el formato, si uno más automático  o uno que pueda asimilarse a lo que quiere la facultad.

>obtenerDirectorios :: [Materia] -> [String] 
>obtenerDirectorios ms = map dirBase ++ map dirDepósito ms ++ map dirPúblico ms

----- Cosas para revisar: las variables raiz y período, de alguna forma deberían generarse acá. 

raiz = "instituto:UNTREF/" 
período = "Cuatrimestre2-2018/"
------------------

>crearDirectorio :: String -> String
>creadDirectorio nombreCarpeta = comandoCrear ++ nombreCarpeta

--- Escribir base materia
