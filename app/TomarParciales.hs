import ProfesorRobot
import CargarDatos

main :: IO()
main = do
  fechaISO <- readFile "fecha.txt"
  cuatrimestre <- readFile "MateriasDelCuatrimestre.lista"
  let materias = recuperarMaterias cuatrimestre
  putStrLn( darOrden ( aRclone (isoAFecha fechaISO) materias) )
