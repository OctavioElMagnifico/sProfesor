--- La idea es practicar interpetación de textos y entrada de parámetros con el comando "interact". Creo que es un uso rebuscado porque requiere una lambda.  

lineaX t x = putStrLn(lines(t)!!x)

main = do
   texto <- readFile "/home/octavio/ProfesorRobot/textodePrueba.txt"
   interact( ((lines texto)!!) . read . take 1) 
   putStrLn("\n")
