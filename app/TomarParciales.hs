import ProfesorRobot
import CargarDatos

TomarParciales = do
  fecha <- readFile "fecha.txt"
  cuatrimestre <- readFile "MateriasDelCuatrimestre.untref"
  let materias = recuperarMaterias cuatrimestre
       putStrLn( darOrden ( aRclone (isoAFecha entrada) materias) )

