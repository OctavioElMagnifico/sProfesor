Este programa tiene por objeto automatizar algunas tareas asociadas con la docencia virtual empleando crond, rclone y BASH. 
OBJETIVOS INICIALES:

1) Leer un formato sencillo de entrada para obtener información sobre una materia: Nombre, directorios asociados, fechas de actividades y archivos asociados. 
2) Entregar automatizadamente los archivos, esto es importante para las instancias de evaluación que no deben ser conocidas desde antes. 
3) Generar cronogramas. 

Pendientes:

4) Asistir en la distribución del tiempo a lo largo del temario. 
   Probablemente para esto se necesita un tipo nuevo, algo como "esqueleto de materia".
5) Gestionar la recepción de los archivos.
   Esto con Dropbox parece ser imposible. 
6) Enviar resueltos cuando vencen los plazos. 


Funcionamiento de Profesor Robot:

1) El script de BASH LlamarProfesor inicia el programa y le da como entrada la fecha escribiendo el archivo "fecha.txt".
2) i- El programa lee el archivo "MateriasDelCuatrimestre.untref" donde previamente se cargó todas las materias existentes usando la aplicación "cargarDatos".   
   ii- El programa determina qué materias tienen eventos este día.
   iii- Para cada evento, construye el comando de rclone que copia su archivo asociado desde la carpeta de almacenamiento hasta la que es accesible para los alumnos. 
   iv - Los comandos se escriben a un archivo.
   v- BASH lee el archivo de salida y ejecuta las ordenes. 

Funcionamiento de cargarDatos:

1) La materia se describe en una tabla de texto simple con el sigiuente formato: 
Es FUNDAMENTAL que el nombre del evento sea el del archivo. 

Materia   
Nombre Oficial: Parafernalia   
Nombre Para Carpetas: Para2018
 Fechas Evento EsTP
 01-02 Tema 1 No
 02-03 Tema 2 No 
 04-05 TP 1 Sí
 05-05 Tema 3 No

2) El programa solicita el nombre de la materia a leer, lo lee y lo añade en una línea nueva al archivo MateriasDelCuatrimestre.untref .

FALTANTES:

a) Guión que controla la no repetición de materias Parece buena idea agregar esto a la función que adquiere el listado también.
b) Mejorar el tipo Evento para que tenga un componente Booleano. Este indica su condición de TP y permite bifurcar la reacción ante TP o evento usual.
c) Investigar la incorporación de anacrond.

Procedimiento de Uso:

1) Activar la tarea diaria en Crond.
2) Crear la carpeta del cuatrimestre y copiar en su interior los ejecutables cargarDatos, tomaExamenes y generarEntorno.
3) Escribir las tablas de materias. 
4) cargarDatos .
5) generarEntorno .
6) Cargar los Archivos a entregar en la carpeta "VisibleAlumnos" que el entorno generó.
