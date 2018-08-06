>type Evento = (Fecha , [Char])

>data Fecha = Fecha Int Int
>    deriving (Eq,Ord,Show,Read)

>data Materia = Materia [Char] [Char] [Char] [Evento] 
>  deriving (Show,Read)

>análisis = Materia "Análisis" "Análisis/" "Análisis/" [(Fecha 1 3,"TP1"),(Fecha 2 4,"TP2")]
>globología = Materia "Globología" "Globología/" "Globología/" [(Fecha 14 4,"TP1"),(Fecha 2 4,"TP2")]
>t = Fecha 2 4
