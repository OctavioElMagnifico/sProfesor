> {-# LANGUAGE OverloadedStrings #-}
> import Network.Wreq
> import Control.Lens ( (^.), (^?), (.~) , (&) )
> import Data.Aeson.Lens (_String, key)
> import Data.Map as Map
> import Data.Aeson


> dropboxGenerar = "https://api.dropboxapi.com/2/file_requests/create" :: String
> dropboxContar = "https://api.dropboxapi.com/2/file_requests/count" :: String
> dropboxListar = "https://api.dropboxapi.com/2/files/list_folder" :: String

> opts = defaults & header  "Authorization" .~ [ "Bearer 02ofM2YxQxAAAAAAAABzGGFeELs49jJyPy0YWJEOKjKXM5-3PgI3nsPAXjGrTvFd" ] & header "Accept" .~ [ "application/json" ]

 postDrop = [ "title" := "pedidoRobot", "destination" := "UNTREF/pruebaRobot", "deadline" := ]

> data Listar = Listar String Bool Bool Bool Bool Bool Bool
> instance ToJSON Listar where
>  toJSON ( Listar directorio recursivo infoMedio borrados miembrosComparten montadas noDescargables ) = object [
>    "path" .= directorio,
>    "recursive" .= recursivo,
>    "include_media_info" .= infoMedio,
>    "include_deleted" .= borrados,
>    "include_has_explicit_shared_members" .= miembrosComparten,
>    "include_mounted_folders" .= montadas,
>    "include_non_downloadable_files" .= noDescargables
>    ]


> ejListar = Listar "/UNTREF/" False False False False False False


salida <- postWith opts dropboxListar ( toJSON ejListar )
s alida ^? responseBody . key "entries"

> data Plazo = Plazo String String

> instance ToJSON Plazo where
>   toJSON ( Plazo fecha tardios ) = object [
>     "deadline" .= fecha
>     , "allow_late_uploads" .= tardios
>     ]

> data PedidoDeEnlace = PedidoDeEnlace String String Plazo Bool

> instance ToJSON PedidoDeEnlace where
>  toJSON ( PedidoDeEnlace título destino plazo abierta  ) = object [
>    "title" .= título,
>    "destination" .= destino,
>    "deadline" .= plazo,
>    "open" .= abierta
>    ]

> ejPedido = PedidoDeEnlace "pruebaRobot" "/UNTREF/pruebaRobot/" ( Plazo "2020-05-02T00:00:00Z" "one_day" ) True

n ecesito una función que lleve el tipo ad hoc fecha a UTC. Probablemente sea mejor eliminar la fecha del programa y usar el tipo definido en Haskell.
  fechaaUTC :: Fecha Año -> 

> pedir :: IO ()
> pedir = do{
>   r <- getWith opts "http://httpbin.org/get";
>   putStrLn . show $ r ^. responseStatus
>            }

 contar :: IO ()
 contar = do {
  entrada <- postWith opts dropboxContar [ "num" := 3 ];
  putStrLn . show $ entrada ^. key "file_request_count"
 }

> main :: IO ()
> main = do {
> pedir
> }

