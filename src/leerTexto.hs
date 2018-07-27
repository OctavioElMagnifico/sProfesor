--- La idea es practicar interpetación de textos y entrada de parámetros con el comando "interact". Creo que es un uso rebuscado porque requiere una lambda.  

lineaX t x = putStrLn(lines(t)!!x)

main = do
   putStrLn("\nIndicar el número de línea y tocar ENTRAR.\n")
   texto <- readFile "/home/octavio/ProfesorRobot/textodePrueba.txt"
   interact( ((lines texto)!!) . read . takeWhile (/='\n')) 
   putStrLn("\n")
