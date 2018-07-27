import ProfesorRobot

lista a = aRclone a  materias

main = do {
       interact (darOrden  . lista . read . takeWhile (/='\n'))
    }
