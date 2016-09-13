
local soporte={}

--[[Funcion para determinar en que tipo de dispositivo se esta ejecutando el juego
      Como argumento se le pasa:
        W-->Anchura de pantalla establecido en el config.lua
        H-->Altura de pantalla establecida en el config.lua
    La funcion devuelce el tipo de dispositivo "alto"(dispositivos con una altura superior a 1200) o "ancho" (para una anchura superior a 800)
--]]
function soporte:TipoDispositivo(W,H)
  local tipoDispositivo
  if W>800 and H==1200 then--Si se ha fijado la altura a 1200 como referencia para obtener el ancho-->Dispositivos anchos
    tipoDispositivo="ancho"
  elseif W==800 and H>1200 then--Si se ha fijado la anchura a 800 como referencia para obtener el alto-->Dispositicos altos
    tipoDispositivo="alto"
  end
  return tipoDispositivo
end
-- ---------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------

--[[Funcion para eliminar y liberar la memoria de los objetos display de la escena que se pasa como argumento
      Como argumentos se le pasa:
        escena-->Grupo escena que se desea limpiar
--]]
function soporte:EliminarElementos(escena)
   for i=escena.numChildren,1,-1 do--Recorremos todos los hijos del grupo
      if escena[i] then--Si no estan a nil
        
        if escena[i].numChildren then--Si el elemento es un grupo
           for j=escena[i].numChildren,1,-1 do--Recorremos todos los hijos del grupo
             escena[i][j]:removeSelf()--Eliminamos el objeto display hijo
             escena[i][j]=nil--Ponemos a nil la variable
           end
        end
        
        escena[i]:removeSelf()--Eliminamos el objeto display
        escena[i]=nil --Ponemos a nil la variable
      end
    end

end



-- ---------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------
--[[Funcion para crear un Objeto display: 
Como argumento se le pasa:
        imagen-->Ruta de la imagen
        ancho, alto-->dimensiones del objeto a crear
        ptoRefX,ptoRexY-->Punto de referencia del objeto a crear
        x,y-->Posicion del objeto a crear
La funcion devuelve el objeto display creado
        --]]
function soporte:CrearObjeto(imagen,ancho,alto,ptoRefX,ptoRefY,x,y)
  local objeto=display.newImageRect(imagen,ancho,alto)
    --Establecemos el punto de referencia-->En el centro abajo
    objeto.anchorX=ptoRefX
    objeto.anchorY=ptoRefY
    --Colocamos el fondo en la pantalla-->Hacemos que cubra toda la pantalla
    objeto.x=x
    objeto.y=y
   
  return objeto
end
-- ---------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------
--[[Funcion para crear el boton de PlayAndPause.
      Como argumento se le pasa:
         x,y-->Posicion en la que crear el boton
La funcion devuelve el grupo creado para el boton y el boton en estado de play y de pause
--]]

function soporte:CrearBotonPlayPause(x,y)
  
   --Creamos el boton de start/pause
   local grupoBtn=display.newGroup()--Creamos un grupo para los botones de start/pause
   local datosBtn=soporte:RellenarDatosBtn("graficos/survival/btnPausa.png","graficos/survival/btnPlay.png",nil,45,45,0.5,0.5,x,y,1.5,1.5,1)--Rellenamos los datos del boton cuando esta normal y cuando esta pulsado
    local btnPausa,btnPlay=soporte:CrearBoton(datosBtn,grupoBtn)--Creamos los botones y los añadios al grupo creado
   grupoBtn.isVisible=false --Ocultamos el grupo de botones de start/pause
   --Devolvemos el grupo creado y el boton en estado de play y de pause
   return btnPausa,btnPlay,grupoBtn
 
end

-- ---------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------
--[[Funcion para crear el boton de Frenado del nivel 2 del juego Liberar a Globox.
      Como argumento se le pasa:
         x,y-->Posicion en la que crear el boton
La funcion devuelve el grupo creado para el boton y el boton en estado de pulsado y normal
--]]
function soporte:CrearBotonFrenado(x,y)
  
   --Creamos el boton de start/pause
   local grupoBtn=display.newGroup()--Creamos un grupo para los botones de start/pause
   local datosBtn=soporte:RellenarDatosBtn("graficos/liberarGlobox/nivel2/frena.png","graficos/liberarGlobox/nivel2/frenaPulsado.png",nil,236,158,0.5,0.5,x,y,0.6,0.6,1)--Rellenamos los datos del boton cuando esta normal y cuando esta pulsado
    local btnFrena,btnFrenaPulsado=soporte:CrearBoton(datosBtn,grupoBtn)--Creamos los botones y los añadios al grupo creado
   grupoBtn.isVisible=false --Ocultamos el grupo de botones de start/pause
   --Devolvemos el grupo creado y el boton en estado de frenado pulsado y sin pulsar
   return btnFrena,btnFrenaPulsado,grupoBtn
 
end
-- ---------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------
--[[Funcion para crear el contador de vidas y el icono del personaje que se selecciono.
      Como argumento se le pasa:
          heroe-->nombre del heroe "Rayman" o "Globox"
          vidas-->El numero de vidas 
La funcion devuelve el icono del personaje seleccionado y el contador de vidas
--]]

function soporte:CrearVida(heroe,vidas)
   --Creamos la vida y el icono del personaje activo
   local cara=soporte:CrearObjeto("graficos/personajes/vida"..heroe..".png",100,100,0,0,20,20)
   cara.isVisible=false--Ocultamos el icono
   --Creamos el marcador de vidas
   local vida=display.newText( "x "..vidas, cara.x+cara.contentWidth+30, 100, "font/Rayman_Adventures_TTF.ttf", 50 )
   vida:setFillColor(240/255,81/255,186/255)--Establecemos el color del marcador de vidas
   vida.isVisible=false--Ocultamos el marcador
   --Devolvemos el icono del personaje y el contador de vidas
   return cara,vida
  
end

-- ---------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------
--[[Funcion para crear el contador de vidas y el icono del personaje que se selecciono.
      Como argumento se le pasa:
          heroe-->nombre del heroe "Rayman" o "Globox"
          x,y-->Posicion en la pantalla donde se desea colocar las instrucciones
La funcion el objeto display con la imagen de las instrucciones
--]]


function soporte:CrearInstrucciones(heroe,x,y,tipo)
   --Creamos las instrucciones
   local instrucciones=soporte:CrearObjeto("graficos/personajes/instrucciones"..heroe.."_"..tipo..".png",400,328,0.5,0.5,x,y)
   instrucciones:scale(2,2)--Redimensionamos su tamaño
  
    return instrucciones
  end
-- ---------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------
--[[Funcion para crear la puerta de salida del nivel del nivel 1 del juego "Liberar a Globox"
      Como argumento se le pasa:
        W-->Anchura de pantalla establecido en el config.lua
        H-->Altura de pantalla establecida en el config.lua
La funcion devuelve la imagen de la puerta y el grupo con las columnas que la representan en el motor de fisica
--]]
--
function soporte:CrearSalidaNivelGlobox1(W,H,tipoDispositivo)
    local physics=require("physics")--Obtenemos el motor de fisica
    --Creamos un grupo para las columnas que representan la puerta de salida en el motor de fisica
   local grupoColumnas=display.newGroup()
   local ancho
   --En funcion del tipo de dispositivo estableces un ancho u otro para la imagen de la puerta de salida
   if tipoDispositivo=="ancho" then ancho=580 
   else ancho=580*0.9 end
   --Creamos la imagen de la puerta de salida del nivel
   local finNivel=soporte:CrearObjeto("graficos/liberarGlobox/nivel1/finnivel1.png ",ancho,H,1,0,W*12,0)
  
 
   --Creamos una columna superior
  local colarriba=display.newRect(finNivel.x-finNivel.contentWidth,100,10,240)
   colarriba.isVisible=false--La ocultamos
   physics.addBody(colarriba,"static",{density=0.1,friction=1,bounce=0.1})--La añadimos al motor de fisica
   grupoColumnas:insert(colarriba)--Insertamos la columna superior en el grupo anterior
   
   --Creamos una columna inferior
   local colabajo=display.newRect(finNivel.x-finNivel.contentWidth,H-340,10,640)---450
   colabajo.isVisible=false--La ocultamos
   physics.addBody(colabajo,"static",{density=0.1,friction=1,bounce=0.1})--La añadimos al motor de fisica
   grupoColumnas:insert(colabajo)--Insertamos la columna inferior en el grupo anterior

   --Delvolvemos la imagen de la puerta y el grupo con las columnas que la representan en el motor de fisica
   return finNivel,grupoColumnas
  end
  
  
  -- ---------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------
--[[Funcion para crear la salida del nivel del nivel 2 del juego "Liberar a Globox"
      Como argumento se le pasa:
        xArriba, yArriba-->posicion de la parte de arriba de la salida
        xAbajo, yAbajo-->posicion de la parte de abajo de la salida
La funcion devuelve el grupo que contiene ambas partes de la salida
--]]
function soporte:CrearSalidaNivelGlobox2(xArriba,yArriba,xAbajo,yAbajo)
   local physics=require("physics")--Obtenemos el motor de fisica
  --Creamos la parte de arriba de la salida y la parte de abajo
  local salidaAbajo=soporte:CrearObjeto("graficos/liberarGlobox/nivel2/obs1abajo.png",400,714,0,0,xAbajo,yAbajo)
  local salidaArriba=soporte:CrearObjeto("graficos/liberarGlobox/nivel2/obs1arriba.png",400,750,0,1,xArriba,yArriba)
   --Insertamos ambas partes en el motor de fisica
  physics.addBody(salidaAbajo,"static",{density=0.1,friction=1,bounce=0.1})
  physics.addBody(salidaArriba,"static",{density=0.1,friction=1,bounce=0.1})
 
  --Devolvemos las dos partes de la salida y el grupo 
  return salidaAbajo,salidaArriba
  end
  
  
  
--[[**********************************************************************************************************
*********************************FUNCIONES PARA CREAR Y GESTIONAR SPRITES**************************************
********************************************************************************************************--]]
--[[Funcion para crear un objeto diplay con movimiento o sprite simple-->Que ejecuta una sola secuencia de un mismo imageSheet
      Como argumento se le pasa:
         info-->ruta del archivo .lua con la informacion del imagen Sheet
         rutaImageSheet-->ruta del archivo .png de la imagen Sheet
         nombre-->nombre de la secuencia que va a reproducir el sprite
         ptoRefX,ptoRefY-->Punto de referencia del sprite
         escalaX,escalaY-->escala a aplicarle al sprite en ambos ejes
         x,y-->Posicion en la que crear el sprite
   La funcion devuelve el sprite creado 
      --]]
function soporte:CrearSpriteSimple(info,rutaImageSheet,nombre, ptoRefX,ptoRefY,escalaX,escalaY,x,y)
    --Obtenemos el modulo con la informacion de la imagen sheet 
    local sheetInfo = require(info)
    --Obtenemos del modulo de informacion la tabla de opciones
    local opciones=sheetInfo:getSheet()
    --Creamos la imagen Sheet  con la tabla de opciones anterior y la ruta del archivo png de la imagen sheet
    local imagenSheet = graphics.newImageSheet( rutaImageSheet, opciones)
    --Obtenemos la secuencia a cargar del modulo de informacion
    local secuencia=sheetInfo:getSequence(nombre)
    --Creamos el sprite con la imagen sheet y la secuencia
    local sprite= display.newSprite( imagenSheet ,secuencia )
    --Establecemos el punto de referencia
    sprite.anchorX=ptoRefX; sprite.anchorY=ptoRefY
    --Establecemos la escala
    sprite:scale(escalaX,escalaY)--Aumentamos el tamaño
    --Colocamos el sprite en la posicion deseada
    sprite.x=x; sprite.y=y
    --Devolvemos el sprite creado
   return sprite
end
-- ---------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------
--[[Funcion para crear un sprite compuesto-->Que ejecuta varias secuencias que no tienen porque ser de la misma imagenSheet
      Como argumento se le pasa:
        imagenSheet-->La imagen Sheet que contendra la secuencia que se ejecute primero
        secuencia-->Tabla con las secuencias que se van a ejecutar
         ptoRefX,ptoRefY-->Punto de referencia del sprite
         escalaX,escalaY-->escala a aplicarle al sprite en ambos ejes
         x,y-->Posicion en la que crear el sprite
        
--]]
function soporte:CrearSpriteCompuesto(imagenSheet,secuencia,ptoRefX,ptoRefY,escalaX,escalaY,x,y)
  
     --Creamos el sprite
    local sprite= display.newSprite( imagenSheet ,secuencia )
     --Establecemos el punto de referencia
    sprite.anchorX=ptoRefX;sprite.anchorY=ptoRefY
     --Establecemos la escala
    sprite:scale(escalaX,escalaY)--Aumentamos el tamaño
    --Colocamos el sprite en la posicion deseada
    sprite.x=x;sprite.y=y
    --Devolvemos el sprite creado
    return sprite
  end
-- ---------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------
--[[Funcion para obtener la ImagenSheet a partir de la ruta del archivo png de la imagen sheet y de la ruta del archivo que contiene la informacion de la imagen sheet
    Como argumento se le pasa:
      rutaSheet-->ruta del archivo .lua con la informacion del imagen Sheet
      rutaImageSheet-->ruta del archivo .png de la imagen Sheet
--]]
function soporte:ObtenerImagenSheet(rutaSheet,rutaImagenSheet)
   --Obtenemos el modulo con la informacion de la imagen sheet 
  local sheetInfo = require(rutaSheet)
    --Obtenemos del modulo de informacion la tabla de opciones necesaria para crear la imagen sheet
  local opciones=sheetInfo:getSheet()
  --Creamos la imagen Sheet  con la tabla de opciones anterior y la ruta del archivo png 
  local imagenSheet = graphics.newImageSheet( rutaImagenSheet, opciones)
  --Devolvemos la imagenSheet creada
  return imagenSheet
end

-- ---------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------
--[[Funcion para obtener las secuencias de una imagen sheet
      Como argumento se le pasa:
        rutaSheet-->ruta del archivo .lua con la informacion del imagen Sheet
        rutaImageSheet-->ruta del archivo .png de la imagen Sheet
        listadoSecuencias-->Tabla con todos los nombres de las secuencias que se desean cargar en el sprite
    La funcion devuelve una tabla con todas las secuencias nombradas en el listado de secuencias pasado como argumento
--]]

function soporte:ObtenerSecuencias(rutaSheet,rutaImagenSheet,listadoSecuencias)
  local secuencias={}
  --Obtenemos el modulo con la informacion de la imagen sheet 
  local sheetInfo = require(rutaSheet)
  --Creamos la imagenSheet
  local imagenSheet=soporte:ObtenerImagenSheet(rutaSheet,rutaImagenSheet)
  --Recorremos el listado de secuencias 
  for i=1,#listadoSecuencias do
    --Guardamos aquellas secuencias de la imagenSheet que esten en la lista
    secuencias[i]=sheetInfo:getSequence(listadoSecuencias[i],imagenSheet) 
  end
  --Devolvemos la tabla con las secuencias pedidas
    return secuencias
 
end


-- ---------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------
--[[Funcion para crear el sprite del personaje que se utilizara en los distintos juegos-->Este sprite tendra dos secuencias, una que será el personaje cayendo y otra el personaje volando
      Como argumento se le pasa:
        info-->ruta del archivo .lua con la informacion del imagen Sheet
        rutaImagenSheet-->ruta del archivo .png de la imagen sheet
        ptoRefX,ptoRefY-->punto de referencia
        escalaX,escalaY-->escala
        x,y-->Posicion donde se quiere crear el sprite
    La funcion devuelve el sprite del personaje creado
--]]
function soporte:CrearPersonaje(info,rutaImageSheet, ptoRefX,ptoRefY,escalaX,escalaY,x,y)
  
    --Obtenemos las opciones para crear la imagen sheet
    local sheetInfo = require(info)
    local opciones=sheetInfo:getSheet()
     
    --Creamos el imagen sheet con las opciones
    local imagenSheet = graphics.newImageSheet( rutaImageSheet, opciones)
   
   --Obtenemos las dos secuencias
    local secuencia1=sheetInfo:getSequence("vuela")--personaje volando
    local secuencia2=sheetInfo:getSequence("caida")--personaje cayendo
    local secuencia={secuencia1,secuencia2}--Creamos una tabla con ambas secuencias
    
    --Creamos el sprite a partir de la imagen sheet y la tabla de secuencias
    local personaje= display.newSprite( imagenSheet ,secuencia )
    --Establecemos el punto de referencia
    personaje.anchorX=ptoRefX; personaje.anchorY=ptoRefY
    --Establecemos la escala
    personaje:scale(escalaX,escalaY)
    --Colocamos el sprite en pantalla
    personaje.x=x; personaje.y=y
     --Hacemos invisible al personaje
    personaje.alpha=0
    --Devolvemos el sprite del personaje
   return personaje
  
end




-- ---------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------
--[[Funcion para crear la animacion de rayman en el Inicio de nivel del juego liberar a Globox
      Como argumento se le pasa:
        x,y-->posicion en pantalla en la que se desea crear el sprite
    La funcion devuelve el sprite de rayman creado
--]]
function soporte:CrearAnimacionRay(x,y)
    local listadoSecuencias={"aterrizando","andando","golpeando","cayendo"}
    local secuencias=soporte:ObtenerSecuencias("sheetsInfo.rayInicioNivel", "graficos/liberarGlobox/personajes/rayInicioNivel.png",listadoSecuencias)
 
    local imagenSheet=soporte:ObtenerImagenSheet("sheetsInfo.rayInicioNivel", "graficos/liberarGlobox/personajes/rayInicioNivel.png")
    local ray=soporte:CrearSpriteCompuesto(imagenSheet,secuencias,0,0,3,3,x,y)--0,centroY-300) 
    return ray
end
-- ---------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------
--[[Funcion para crear la animacion de los electroons en el Inicio de nivel del juego liberar a globox
      Como argumento se le pasa:
        x,y-->posicion en pantalla en la que se desea crear el sprite
    La funcion devuelve el sprite de rayman creado
--]]
function soporte:CrearAnimacionElectroons(x,y)
   local listadoSecuencias1={"electroonsJaula","abrirJaula"}
   local secuencias=soporte:ObtenerSecuencias("sheetsInfo.jaula", "graficos/liberarGlobox/personajes/jaula.png",listadoSecuencias1)
   local listadoSecuencias2={"electroonsLibres"}
   local ultimaSecuencia=soporte:ObtenerSecuencias("sheetsInfo.electroons", "graficos/liberarGlobox/personajes/electroons.png",listadoSecuencias2)
   secuencias[3]=ultimaSecuencia[1]
  
  local imagenSheet=soporte:ObtenerImagenSheet("sheetsInfo.jaula", "graficos/liberarGlobox/personajes/jaula.png")
  local electroons=soporte:CrearSpriteCompuesto(imagenSheet,secuencias,0.5,0.5,3,3,x,y)--centroX+270,centroY-150)--200 
  return electroons
end

-- ---------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------
--[[Funcion para crear la animacion de globox en el Final del juego liberar a globox
      Como argumento se le pasa:
        x,y-->posicion en pantalla en la que se desea crear el sprite
    La funcion devuelve el sprite de rayman creado
--]]

function soporte:CrearAnimacionGlobox(x,y)
 
  --Creamos el listado con las secuencias de la primera imagen sheet que queremos cargar en el sprite
   local listadoSecuencias1={"globoxJaula"}
   --Obtenemos las secuencias del listado
   local secuencias=soporte:ObtenerSecuencias("sheetsInfo.globoxJaula", "graficos/liberarGlobox/personajes/globoxJaula.png",listadoSecuencias1)
   --Creamos otro listado con las secuencias del segundo imagen sheet
   local listadoSecuencias2={"globoxAndando"}
   --Obtenemos las secuencias del segundo listado
   local ultimaSecuencia=soporte:ObtenerSecuencias("sheetsInfo.globoxAndando", "graficos/liberarGlobox/personajes/globoxAndando.png" ,listadoSecuencias2)
   --Añadimos a la tabla de secuencias de la primera imagen sheet las secuencias de la segunda imagen sheet para tener una tabla con todas las secuencias
   secuencias[2]=ultimaSecuencia[1]
  
  --Creamos la imagen Sheet
  local imagenSheet=soporte:ObtenerImagenSheet("sheetsInfo.globoxJaula", "graficos/liberarGlobox/personajes/globoxJaula.png")

  --Creamos el sprite de globox
  local globox=soporte:CrearSpriteCompuesto(imagenSheet,secuencias,0.5,0.5,4,4,x,y)
  --Devolvemos el sprite creado
  return globox
end

-- ---------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------
--[[Funcion para crear la animacion de rayman en el game Over del modo Survival
      Como argumento se le pasa:
        x,y-->posicion en pantalla en la que se desea crear el sprite
    La funcion devuelve el sprite de rayman creado
--]]

function soporte:CrearAnimacionRayGameOver(x,y)
    --Creamos un listado con las secuencias a utilizar de la primera imagen sheet
    local listadoSecuencias1={"andandoDcha","muecaDcha","andandoIzqda","muecaIzqda","paradoDcha","paradoIzqda"}
    --Obtenemos las secuencias listadas del primer imagen sheet
    local secuencias=soporte:ObtenerSecuencias("sheetsInfo.raymuecaGameOver", "graficos/gameOver/raymuecaGameOver.png",listadoSecuencias1)
    --Creamos el listado con la secuencias a utilizar de la segunda imagen sheet
    local listadoSecuencias2={"raybailando"}
    --Obtenemos las secuencias listadas del segundo imagen sheet
    local ultimaSecuencia=soporte:ObtenerSecuencias("sheetsInfo.raybailandoGameOver", "graficos/gameOver/raybailandoGameOver.png",listadoSecuencias2)
 
   --Añadimos a la tabla de secuencias del primer imagen sheet las del segundo
    secuencias[7]=ultimaSecuencia[1]
  --Creamos la imagen sheet que contenga la primera secuencia a ejecutar
    local imagenSheet=soporte:ObtenerImagenSheet("sheetsInfo.raymuecaGameOver", "graficos/gameOver/raymuecaGameOver.png")
 
    --Creamos el sprite del personaje con la imagen sheet y la tabla de secuencias
    local ray=soporte:CrearSpriteCompuesto(imagenSheet,secuencias,0,0,2.5,2.5,x,y) 
  --Devolvemos el sprite creado
    return ray
end

-- ---------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------
--[[Funcion para cambiar las secuencias que se estan reproduciendo en el sprite
    Como argumento se le pasa:
      sprite-->Sprite al que se le va a cambiar la secuencia
      secuencia-->nombre de la secuencia deseamos que ejecute el sprite
    La función devuelve el sprite
--]]
function soporte:cambiarSecuencia(sprite,secuencia)
  --Establecemos la secuencia a reproducir en el sprite
  sprite:setSequence(secuencia)
  --Comenzamos a reproducir la secuencia cargada
  sprite:play()
  --Devolvemos el sprite
  return sprite
end



--[[***************************FUNCIONES PARA CREAR GRUPOS***********************************
************************************************************************************--]]
--[[Funcion para crear los grupos de los obstáculos
      Como argumento se le pasa:
          ptoRefX,ptoRefY-->punto de referencia del grupo
          x,y-->posicion en la pantalla del grupo
      La funcion devuelve el grupo creado
--]]

function soporte:CrearGrupo(ptoRefX,ptoReY,x,y)
  local grupo=display.newGroup()--Creamos un grupo
  grupo.anchorChildren=true--Hacemos que el grupo respete los puntos de referencia
  --Fijamos el punto de refrencia
  grupo.anchorX=ptoRefX;   grupo.anchorY=ptoReY
  --Fijamos la posicion en la pantalla
  grupo.x=x;   grupo.y=y
  --Devolvemos el grupo creado
  return grupo
end

--[[***************************FUNCIONES DE OBSTACULOS***********************************
************************************************************************************--]]
--[[Funcion para crear una tabla con los datos necesarios para crear los obstaculos
      Como argumento se le pasa:
          ruta--> ruta del archivo .png del obstaculo
          ancho,alto-->dimensiones del obstaculo
          ptoRefX,ptoRefY-->punto de referencia del obstaculo
          x,y-->posicion en la pantalla del obstaculo
          posicion-->indica si el obstaculo estará colocado arriba o abajo
          movimientoY-->indica si el obstaculo posee movimiento en el eje Y     
      La funcion devuelve la tabla datos 
--]]
function soporte:RellenarDatosObs(ruta,ancho,alto,ptoRefX,ptoRefY,x,y,posicion,movimientoY)
  local datos={}
  datos.ruta=ruta
  datos.ancho=ancho; datos.alto=alto
  datos.ptoRefX=ptoRefX; datos.ptoRefY=ptoRefY
  datos.x=x; datos.y=y
  datos.posicion=posicion; datos.movimientoY=movimientoY
  return datos
end
-- ---------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------
--[[Funcion que crea un obstaculo simple, lo coloca en pantalla, lo añade al motor de fisica  y lo inserta en el grupo de obstaculos
      Como argumento se le pasa:
        obs-->tabla con los datos del obstaculo que se desea crear
        grupoObstaculos--> el grupo en el que se desea insertar el obstaculo
--]]
function soporte:crearObstaculoSimple(obs,grupoObstaculos)
  --Creamos un objeto display a partir de los datos del obstaculo
  local obstaculo=soporte:CrearObjeto(obs.ruta,obs.ancho,obs.alto,obs.ptoRefX,obs.ptoRefY,obs.x,obs.y)
  if(obs.posicion=="arriba") then--Si el obstaculo creado es un obstaculo de arriba
   obstaculo.pasado=false--Ponemos el flag que indica que el personaje paso el obstaculo a false
  end
   obstaculo.pos=obs.posicion--Guardamos el obstaculo como un obstaculo de arriba
   obstaculo.movimientoY=obs.movimientoY--Guardamos el flag que indica si se mueve o no verticalmente
   grupoObstaculos:insert(obstaculo)--Insertamos el obstaculo en el grupo pasado como argumento
   --Devolvemos el obstaculo creado
  return obstaculo 
end
-- ---------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------
--[[Funcion para crear un obstaculo multiple que constara de un obstaculos arriba y abajo en la misma posicion del eje x
      Como argumento se le pasa:
        obsArriba-->obstaculo de arriba
        obsAbajo-->obstaculo de abajo
        grupoObstaculos--> el grupo en el que se desea insertar el obstaculo
    La funcion devuelve una tabla con los dos obstaculos (arriba y abajo) creados
--]]
function soporte:crearObstaculoMultiple(obsArriba,obsAbajo,grupoObstaculos)
  --Creamos el obstaculo de arriba y lo insertamos en el grupo 
  local obstaculoArriba=soporte:crearObstaculoSimple(obsArriba,grupoObstaculos)
    --Creamos el obstaculo de abajo y lo insertamos en el grupo 
  local obstaculoAbajo=soporte:crearObstaculoSimple(obsAbajo,grupoObstaculos)
  --Creamos la tabla con los obstaculos creados
  local obstaculos={obstaculoArriba,obstaculoAbajo}
  --Devolvemos la tabla anterior
  return obstaculos
end




--[[**********************************************************************************
**********************FUNCION PARA CREAR BOTONES**************************************
*************************************************************************************--]]
--[[Funcion para crear una tabla con los datos necesarios para crear los botones
      Como argumento se le pasa:
        rutaNormal-->ruta de la imagen a mostrar cuando el boton esta en estado normal
        rutaPulsado-->ruta de la imagen a mostrar cuando el boton esta en estado pulsado
        rutaBloqueado-->ruta de la imagen a mostrar cuando el boton esta en estado bloqueado
        ancho,alto-->dimensiones del boton
        ptoRefX,ptoRefY-->punto de referencia del boton
        x,y-->posicion en la pantalla del boton
        tipo-->Indica el tipo de boton:
                  -Si es de tipo=1-->tendra 2 estados normal y pulsado
                  -Si es de tipo=2-->tendra 3 estados normal, pulsado y bloqueado
--]]
function soporte:RellenarDatosBtn(rutaNormal,rutaPulsado,rutaBloqueado,ancho,alto,ptoRefX,ptoRefY,x,y,scaleX,scaleY,tipo)
  local datos={}
 if tipo==2 then--Si es de tipo 2 el boton guardamos la ruta de la imagen cuando esta bloqueado
    datos.rutaBloqueado=rutaBloqueado
  end
  --Guardamos el resto de datos
   datos.rutaNormal=rutaNormal
  datos.rutaPulsado=rutaPulsado
  datos.tipo=tipo
  datos.ancho=ancho; datos.alto=alto
  datos.ptoRefX=ptoRefX; datos.ptoRefY=ptoRefY
  datos.x=x; datos.y=y
  datos.scaleX=scaleX;datos.scaleY=scaleY
  --Devolvemos la tabla con los datos del boton
  return datos
end
-- ---------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------
--[[Funcion que crea el objeto boton
      Como argumento se le pasa:
        datosBtn-->Tabla con los datos necesarios para crear el boton
        grupo-->grupo en el que se desea insertar el boton
  La funcion devuelve el boton en estado pulsado y normal si es de tipo 1 y el boton en estado normal, pulsado y bloqueado si es de tipo 2
--]]
function soporte:CrearBoton(datosBtn,grupo)
  local btnNormal,btnPulsado,btnBloqueado
  --Creamos el boton en estado normal
  btnNormal=soporte:CrearObjeto(datosBtn.rutaNormal,datosBtn.ancho,datosBtn.alto,datosBtn.ptoRefX,datosBtn.ptoRefY,datosBtn.x,datosBtn.y)
  --Creamos el boton en estado pulsado
  btnPulsado=soporte:CrearObjeto(datosBtn.rutaPulsado,datosBtn.ancho,datosBtn.alto,datosBtn.ptoRefX,datosBtn.ptoRefY,datosBtn.x,datosBtn.y)
  
  --Redimensionamos el boton al tamaño deseado
  btnNormal:scale(datosBtn.scaleX,datosBtn.scaleY)
  btnPulsado:scale(datosBtn.scaleX,datosBtn.scaleY)
  --Ocultamos el boton en estado pulsado
  btnPulsado.isVisible=false
  
  --Insertamos los dos botones en el grupo
  grupo:insert(btnNormal)
  grupo:insert(btnPulsado)
  --Si es de tipo 2 debemos crear e insertar tambien el boton en estado bloqueado
  if datosBtn.tipo==2 then
    --Creamos el boton en estado bloqueado
    btnBloqueado=soporte:CrearObjeto(datosBtn.rutaBloqueado,datosBtn.ancho,datosBtn.alto,datosBtn.ptoRefX,datosBtn.ptoRefY,datosBtn.x,datosBtn.y)
    --Redimensionamos el boton con la escala deseada
    btnBloqueado:scale(datosBtn.scaleX,datosBtn.scaleY)
    --Ocultamos el boton en estado normal ya que si esta bloqueado no podra ser estar no seleccionado(normal)
    btnNormal.isVisible=false
     --Ocultamos el boton en estado pulsado ya que si esta bloqueado no podra ser estar seleccionado(pulsado)
    btnPulsado.isVisible=false
    --Hacemos visible el boton en estado bloqueado
    btnBloqueado.isVisible=true
    --Insertamos el boton en el grupo
    grupo:insert(btnBloqueado)
    --Devolvemos los tres botones
    return btnNormal,btnPulsado,btnBloqueado
  else
    --Devolvemos el boton normal y pulsado
    return btnNormal,btnPulsado
end

end


-- ---------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------
--[[Funcion que crear los botones Inicio y Jugar de la escena Game Over del modo survival
      Como argumento se le pasa:
        W-->Anchura de pantalla establecido en el config.lua
        H-->Altura de pantalla establecida en el config.lua
        
  La funcion devuelve el boton Incio y Jugar en estado pulsado y normal y el grupo al que se añadieron y los objetos display de las cuerdas que sujetan al boton jugar
--]]

function soporte:CrearBotonesGameOver(W,H)
    local centroX=W*0.5--Obtenemos el centro de la pantalla en el eje X
    --Creamos el boton para volver a jugar al modo Survival
    local grupoBtnJugar=display.newGroup()--Creamos un grupo para el boton de Jugar
    grupoBtnJugar.x=centroX;grupoBtnJugar.y=-500--Los colocamos en la pantalla centrado pero fuera de la pantalla por arriba
    --Rellenamos los datos del boton, en estado normal y pulsado
    local datosBtnJugar=soporte:RellenarDatosBtn("graficos/inicio/btnJugar.png","graficos/inicio/btnJugarPulsado.png",nil,496,161,0.5,0.5,0,0,1,1,1)--centrox y -500
     --Creamos los botones en estado normal y pulsado y los añadimos al grupo creado
    local btnJugar,btnJugarPulsado=soporte:CrearBoton(datosBtnJugar,grupoBtnJugar)
    --Creamos las cuerdas que sujetan el boton de volver a jugar
    local cuerda1=soporte:CrearObjeto("graficos/inicio/cuerda.png",13,220,0,1,centroX-btnJugar.contentWidth/2+25,-500)
    local cuerda2=soporte:CrearObjeto("graficos/inicio/cuerda.png",13,220,0,1,centroX+btnJugar.contentWidth/2-38,-500)
   
   
    --Creamos el boton para regresar a la pantalla de inicio
    local grupoBtnInicio=display.newGroup()--Creamos un grupo para el boton de Inicio
    --Rellenamos los datos del boton, en estado normal y pulsado
    local datosBtnInicio=soporte:RellenarDatosBtn("graficos/gameOver/btnInicio.png","graficos/gameOver/btnInicioPulsado.png",nil,97,73,0.5,0.5,centroX-300,H-225,2,2,1)--centroY+400;btnJugar.y+1180
    --Creamos los botones en estado normal y pulsado y los añadimos al grupo creado
    local btnInicio,btnInicioPulsado=soporte:CrearBoton(datosBtnInicio,grupoBtnInicio)
    
    --Devolvemos los objetos creados y los grupos en los que se insertaron
    return btnJugar,btnJugarPulsado,grupoBtnJugar,cuerda1,cuerda2,btnInicio,btnInicioPulsado,grupoBtnInicio
  end

-- ---------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------
--[[Funcion que crear los botones para seleccionar los juegos del la escena de Menu de Juego
      Como argumento se le pasa:
      x,y-->Posicion de referencia del primer boton
        
  La funcion devuelve todos los botones en estado pulsado y normal y el grupo al que se añadieron 
--]]

 function soporte:CrearBotonesMenuJuego(x,y)
  
  --Creamos el boton para ir al modo Survival
  --Creamos un grupo el boton Survival 
    local grupoBtnSurvival=display.newGroup()
    --Rellenamos los datos del boton, en estado normal y pulsado
    local datosBtn=soporte:RellenarDatosBtn("graficos/menuJuego/Survival.png","graficos/menuJuego/SurvivalPulsado.png",nil,103,22,0.5,0.5,x,y,3,3,1)
     --Creamos los botones en estado normal y pulsado y los añadimos al grupo creado
    local btnSurvival,btnSurvivalPulsado=soporte:CrearBoton(datosBtn,grupoBtnSurvival)

  --Repetimos el proceso con el resto de botones:

    --Creamos el boton para ir a liberar a GLOBOX
    local grupoBtnGlobox=display.newGroup()
    datosBtn=soporte:RellenarDatosBtn("graficos/menuJuego/LiberarGlobox.png","graficos/menuJuego/LiberarGloboxPulsado.png",nil,114,19,0.5,0.5,btnSurvival.x,btnSurvival.y+150,3,3,1)
    local btnGlobox,btnGloboxPulsado=soporte:CrearBoton(datosBtn,grupoBtnGlobox)
  
  --Creamos el boton para ir a liberar al Gran Diminuto
    local grupoBtnMinimo=display.newGroup()
    datosBtn=soporte:RellenarDatosBtn("graficos/menuJuego/LiberarMinimo.png","graficos/menuJuego/LiberarMinimoPulsado.png",nil,147,19,0.5,0.5,btnGlobox.x-20,btnGlobox.y+160,3,3,1)
    local btnMinimo,btnMinimoPulsado=soporte:CrearBoton(datosBtn,grupoBtnMinimo)
    
    --Creamos el boton para ir a liberar al Gran Diminuto
    local grupoBtnBarbara=display.newGroup()
    datosBtn=soporte:RellenarDatosBtn("graficos/menuJuego/LiberarBarbara.png","graficos/menuJuego/LiberarBarbaraPulsado.png",nil,125,19,0.5,0.5,btnMinimo.x,btnMinimo.y+150,3,3,1)   
    local btnBarbara,btnBarbaraPulsado=soporte:CrearBoton(datosBtn,grupoBtnBarbara)
  
   --Creamos el boton para volver al Inicio
    local grupoBtnInicio=display.newGroup()
    datosBtn=soporte:RellenarDatosBtn("graficos/menuJuego/btnInicioMenu.png","graficos/menuJuego/btnInicioMenuPulsado.png",nil,112,102,0.5,0.5,x-20,y-170,2,2,1)
    local btnInicio,btnInicioPulsado=soporte:CrearBoton(datosBtn,grupoBtnInicio)
  
  --Devolvemos todos los botones creados y sus grupos
  return btnSurvival,btnSurvivalPulsado,grupoBtnSurvival, btnGlobox,btnGloboxPulsado,grupoBtnGlobox,btnMinimo,btnMinimoPulsado,grupoBtnMinimo, btnBarbara,btnBarbaraPulsado,grupoBtnBarbara,btnInicio,btnInicioPulsado,grupoBtnInicio
end



-- ---------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------
--[[Funcion que crear los botones para seleccionar el personaje en la escena de seleccion de personaje
      Como argumento se le pasa:
      x-->coordena x de referencia
      H-->Altura de pantalla establecida en el config.lua
  La funcion devuelve todos los botones en estado pulsado, normal y/o bloqueado y el grupo al que se añadieron 
--]]

function soporte:CrearBotonesSeleccionPersonaje(x,H)
  
   --Creamos el grupo de boton volver
   local grupoBtnVolver=display.newGroup()
   --Rellenamos los datos del boton con los dos estados del mismo, el tamaño, el pto de referencia, la posicion, la escala y el tipo de boton que sera simple o de tipo 1-->dos estados:normal y pulsado
   local datosBtnVolver=soporte:RellenarDatosBtn("graficos/selecPersonaje/btnVolver.png","graficos/selecPersonaje/btnVolverPulsado.png",nil,97,73,0.5,1,x+150,H-120,3,3.5,1)
   --Creamos el boton con los datos anteriores y lo insertamos en el grupo que creamos antes
   local btnVolver,btnVolverPulsado=soporte:CrearBoton(datosBtnVolver,grupoBtnVolver)

  --Creamos un grupo para el boton de rayman
   local grupoBtnRay=display.newGroup()
   --Rellenamos todos los datos del boton indicando que es de tipo 1-->dos estados: seleccionado y no seleccionado
   local datosBtnRayman=soporte:RellenarDatosBtn("graficos/selecPersonaje/raymanSeleccionado.png","graficos/selecPersonaje/raymanNoSeleccionado.png",nil,258,460,0.5,1,x+700,H-150,1.5,1.5,1)
   --Creamos el boton y lo añadimos al grupo creado anteriormente
   local btnRayPulsado,btnRayNoPulsado=soporte:CrearBoton(datosBtnRayman,grupoBtnRay)

   
   --Creamos el boton para seleccionar a globox con el mismo proceso que con el boton de rayman
   local grupoBtnGlobox=display.newGroup()
  --Rellenamos los datos del boton pero este caso será de tipo 2--> tendra tres estados:seleccionado, no seleccionado y bloqueado
    local datosBtnGlobox=soporte:RellenarDatosBtn("graficos/selecPersonaje/globoxSeleccionado.png","graficos/selecPersonaje/globoxNoSeleccionado.png","graficos/selecPersonaje/globoxBloqueado.png",258,460,0.5,1,btnRayPulsado.x+btnRayPulsado.contentWidth*0.5+300,H-150,1.5,1.5,2)
   local btnGloboxPulsado,btnGloboxNoPulsado,btnGloboxBloqueado=soporte:CrearBoton(datosBtnGlobox,grupoBtnGlobox)

 
  --Creamos el boton para seleccionar al gran minimo-->en este caso sera solo un objeto display de imagen ya que este personaje se pretende implementar en futuras expansiones del juego y actualmente permanece bloqueado
   local btnMinimoBloqueado=soporte:CrearObjeto("graficos/selecPersonaje/minimoBloqueado.png",258,460,0.5,1,btnGloboxBloqueado.x+btnGloboxBloqueado.contentWidth*0.5+300,H-150)
  btnMinimoBloqueado:scale(1.5,1.5)
   
     --Creamos el boton para seleccionar a Barbara-->en este caso sera solo un objeto display de imagen ya que este personaje se pretende implementar en futuras expansiones del juego y actualmente permanece bloqueado
  local btnBarbaraBloqueado=soporte:CrearObjeto("graficos/selecPersonaje/barbaraBloqueado.png",258,460,0.5,1,btnMinimoBloqueado.x+btnMinimoBloqueado.contentWidth*0.5+300,H-150)
  btnBarbaraBloqueado:scale(1.5,1.5)
  
  return btnVolver,btnVolverPulsado, grupoBtnVolver,btnRayPulsado,btnRayNoPulsado,grupoBtnRay,btnGloboxPulsado,btnGloboxNoPulsado,btnGloboxBloqueado,grupoBtnGlobox, btnMinimoBloqueado,btnBarbaraBloqueado
  
  end

-- ---------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------
--[[Funcion que crear los botones Inicio y Heroes de la escena de Inicio
      Como argumento se le pasa:
        centroX,centroY-->Coordenadas del centro de la pantalla
  La funcion devuelve todos los botones en estado pulsado, normal,el grupo al que se añadieron y las cuerdas que los sujetan 
--]]

function soporte:CrearBotonesInicio(centroX,centroY)
  
  --Creamos el boton de Jugar
   
    --Creamos un grupo para el boton Jugar
    local grupoBtnJugar=display.newGroup()
    --Rellenamos los datos del boton, en estado normal y pulsado
    local datosBtn=soporte:RellenarDatosBtn("graficos/inicio/btnJugar.png","graficos/inicio/btnJugarPulsado.png",nil,496,161,0.5,0.5,centroX,centroY+260,1,1,1)
    --Creamos los botones en estado normal y pulsado y los añadimos al grupo creado
    local btnJugar,btnJugarPulsado=soporte:CrearBoton(datosBtn,grupoBtnJugar)
     
     --Creamos un grupo para las dos cuerdas del boton Jugar
     local grupoCuerdasJugar=display.newGroup()
     --Creamos las dos cuerdas que sujetan el letrero del boton
    local cuerdajugar1=soporte:CrearObjeto("graficos/inicio/cuerda.png",13,300,0,1,centroX-btnJugar.contentWidth/2+25,centroY+209)
    local cuerdajugar2=soporte:CrearObjeto("graficos/inicio/cuerda.png",13,300,0,1,centroX+btnJugar.contentWidth/2-38,centroY+209)
    --Añadimos las cuerdas al grupo creado
    grupoCuerdasJugar:insert(cuerdajugar1)
    grupoCuerdasJugar:insert(cuerdajugar2)
    
    
    --Creamos el boton de Heroes
    
    --Creamos las dos cuerdas que sujetan el letrero del boton Heroes
    local grupoCuerdasHeroes=display.newGroup()--Creamos un grupo para las dos cuerdas
    --Creamos las imagenes de las cuerdas
    local cuerdaheroes1=soporte:CrearObjeto("graficos/inicio/cuerda.png",13,70,0,1,centroX-200,centroY+400)
    local cuerdaheroes2=soporte:CrearObjeto("graficos/inicio/cuerda.png",13,70,0,1,centroX+188,centroY+400)
    --Añadimos las cuerdas al grupo creado
    grupoCuerdasHeroes:insert(cuerdaheroes1)
    grupoCuerdasHeroes:insert(cuerdaheroes2)
    
    --Creamos un grupo para el boton Heroes
    local grupoBtnHeroes=display.newGroup()
    --Rellenamos los datos del boton, en estado normal y pulsado
     datosBtn=soporte:RellenarDatosBtn("graficos/inicio/btnHeroes.png","graficos/inicio/btnHeroesPulsado.png",nil,496,161,0.5,0.5,centroX,centroY+320+btnJugar.contentHeight,1,1,1)
    --Creamos los botones en estado normal y pulsado y los añadimos al grupo creado
    local btnHeroes,btnHeroesPulsado=soporte:CrearBoton(datosBtn,grupoBtnHeroes)

--Devolvemos los botones creados, sus grupos y las cuerdas que los sujetan
  return btnJugar,btnJugarPulsado,grupoBtnJugar,grupoCuerdasJugar,btnHeroes,btnHeroesPulsado,grupoBtnHeroes,grupoCuerdasHeroes

end





--[[****************************************************************************************
*********************FUNCION PARA GUARDAR,LEER Y ACTUALIZAR EL NIVEL*********************************************
**************************************************************************************--]]
--[[Funcion que permite guardar cadenas de string en el archivo de texto "datos.txt"
      Como argumento se le pasa:
          datos--> cadena de strings a guardar en el archivo "datos.txt"
--]]
function soporte:guardarDatos(datos)
  
  -- Obtenemos la ruta del archivo "datos.txt" que queremos abrir
  local path = system.pathForFile( "datos.txt", system.DocumentsDirectory )

  -- Abrimos el archivo en modo escritura con la ruta anterior
  local file, errorString = io.open( path, "w" )

  if not file then --Si se produce un error al abrir el archivo
     --Lo mostramos por consola
      print( "Error: " .. errorString )
  else--Si no hubo errores al abrir el archivo
      --Escribimos los datos en el archivo
       file:write( datos )
     -- Cerramos el archivo
      io.close( file )
  end
end

-- ---------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------
--[[Funcion para leer el archivo de texto "datos.txt"
    La funcion devuelve los datos leidos del archivo
--]]
function soporte:leerDatos()
 -- Obtenemos la ruta del archivo "datos.txt" que queremos abrir
  local path = system.pathForFile( "datos.txt", system.DocumentsDirectory )
 -- Abrimos el archivo en modo lectura con la ruta anterior
local file, errorString = io.open( path, "r" )

if not file then--Si se produce un error al abrir el archivo
    --Lo mostramos por consola
    print("Error:"..errorString)
    --Devolvemos un false
    return false
else--Si no hubo errores al abrir el archivo
    -- Leemos todo el contenido del archivo
     datos = file:read( "*a" )
    --Cerramos el archivo
    io.close( file )
    --Devolvemos los datos obtenidos del archivo 
    return datos
end


end
-- ---------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------
--[[Funcion creada para el desarrollo del juego-->Elimina el archivo de texto "datos.txt"--]]
function soporte:eliminarArchivo()
  --Eliminamos el archivo datos.txt
  local result, reason = os.remove( system.pathForFile( "datos.txt",system.DocumentsDirectory  ) )

if result then--Si se elimino correctamente
  --Lo mostramos por consola
   print( "Archivo eliminado" )
else--Si hubo problemas
  --Mostramos la razon del problema por consola
   print( "Archivo no existe", reason )  --> File does not exist    apple.txt: No such file or directory
end
end


return soporte