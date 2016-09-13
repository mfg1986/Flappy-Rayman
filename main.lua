--require('mobdebug').start()
--Obtenemos el tipo de modelo sobre el que se ejecuta el juego
local modelo=system.getInfo("model")
if modelo=="iPad" or modelo=="iPhone" then--Si estamos usando un iphone o un iPad
  display.setStatusBar( display.HiddenStatusBar )--Escondemos la barra de estado
end
--Obtenemos el modulo de soporte
local soporte=require("soporte")
--soporte:eliminarArchivo()
--Leemos los datos del fichero datos.txt
if soporte:leerDatos()==false then--Si devuelve false es que es la primera vez que se ejecuta el juego y por lo tanto debemos crear el archivo con los datos de la partida del  usuario
  local datos={
    personaje="rayman",--Personaje activo
    juegoActual="",--Juego seleccionado
    nivelGlobox=1,--Nivel del juego "Liberar a Globox"
    estadoGlobox="preso",--Estado del personaje Globox
    nivelMinimo=1,--Nivel del juego "Liberar a gran Minimo"
    estadoMinimo="preso",--Estado del personaje Gran Minimo
    nivelBarbara=1,--Nivel del juego "Liberar a gran Barbara"
    estadoBarbara="preso",--Estado del personaje Barbara
    vidas=5,--Numero de vidas
    puntuacion=0,--Puntuacion obtenida en el modo Survival 
    puntuacionMax=0--Puntuacion máxima obtenida en el modo Survival
  }
  --Cargamos la libreria "json" para poder codificar la tabla datos
  local json=require("json")
  --Serializamos la tabla datos para obtener su equivalente string y poder guardarlo en el archivo de texto datos.txt
  local serializacionString=json.encode(datos)
  --Guardamos el string de la tabla datos en el archivo de texto
  soporte:guardarDatos(serializacionString)
end


--Cargamos la librería "composer"
local composer=require("composer")
--Cargamos la escena "inicio"
composer.gotoScene("inicio")

--Liberamos variables utilizadas
package.loaded[soporte]=nil;soporte=nil
package.loaded[composer]=nil;composer=nil
datos=nil
