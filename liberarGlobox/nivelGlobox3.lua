--require('mobdebug').start()
--Cargamos el modulo de soporte
local soporte=require("soporte")

--Cargamos la librería "json"
local json=require("json")


--Cargamos la libreria "composer"
local composer=require("composer")
local scene=composer.newScene()--Creamos una escena nueva
--Activamos el flag para que al cambiar de escena se elimine la vista de la misma
composer.recycleOnSceneChange=true

--Cargamos el motor de fisica
local physics=require("physics")
physics.start()--Arrancamos el motor de fisica
physics.setGravity(0,100)--Establecemos el valor de la gravedad


--Obtenemos el tamaño de la pantalla
local W=display.contentWidth
local H=display.contentHeight
local centroY=display.contentCenterY
local centroX=display.contentCenterX

--Declaramos variables necesarias
local math_random=math.random--Optimimizacion
local tPrevious = system.getTimer()--Guardamos el instante inicial
local anyadirObstaculoTimer
local personaje, instrucciones,muelle,cara,vida,choque,casa
local fondo={}
local datos={}
local datosString
local fin=false
local juegoEmpezado=false
local flagPausa=false
local grupoObstaculos
local tablaSonido={}
local grupoBtn,btnPlay,btnPausa

--Funcion para salir del Nivel y lanzar la escena del Game Over
local function irGameOverTimer()
       if json and datos and soporte then
         --Ponemos las vidas del personaje a 5
         datos.vidas=5
         --Guardamos los cambios
         datosString=json.encode(datos)--Convertimos la tabla de datos a un String
         soporte:guardarDatos(datosString)--Guardamos los datos en el archivo permanente de datos 
       end
       --Paramos todos los canales de audio
        audio.stop()
        --Limpiamos y liberamos la memoria del audio
        if tablaSonido then 
          for s,v in pairs(tablaSonido) do
              audio.dispose(tablaSonido[s])
              tablaSonido[s]=nil
            end
          tablaSonido=nil
        end
       
          --Nos vamos al Game Over del Timer
       if composer then
       composer.gotoScene("gameOver.gameOverTimer")
       --Liberamos el modulo cargado y su variable
         package.loaded[composer]=nil; composer=nil
      end
    end



--Funcion Listener del sprite de rayman
local function personajeListener(event)
  local sprite=event.target
  if event.phase=="ended" then
    if sprite.sequence=="vuela" then--Si la secuencia que termino era rayman volando
      soporte:cambiarSecuencia(sprite,"caida")--Cambiamos la secuencia para que rayman pase a caer
    end
  end
    --Como ya hemos tratado el evento devolvemos true para que no siga propagandose
  return true
end



--Funcion para guardar los datos y lanzar la escena de en la que se libera a Globox
local function siguienteNivel()
     --Guardamos en nivel el valor de 1 para que si el jugador quiere volver a jugar el juego comience en 1
     datos.nivelGlobox=1
      --Restablecemos el contador de vidas
     datos.vidas=5
     if datos.estadoGlobox=="preso" then--Si es la primera vex que se libera a Globox
      --Guardamos el estado del nuevo personaje que indica que ya puede ser seleccionado en el modo Survival
     datos.estadoGlobox="libre"

    --Guardamos los cambios en el archivo de datos
    datosString=json.encode(datos)
    soporte:guardarDatos(datosString)
    --Lanzamos la escena que inicia la animacion donde se libera a globox
    composer.gotoScene("liberarGlobox.globoxLiberado")
    
    elseif datos.estadoGlobox=="libre" then--Si el jugador ya se paso el juego y libero a Globox anteriormente
      --Guardamos los cambios en el archivo de datos
    datosString=json.encode(datos)
    soporte:guardarDatos(datosString)
     --Lanzamos la escena del menu donde elegir juego
     composer.gotoScene("menuJuego")
  end
end


--Funcion para mover obstaculos
local function MoverObstaculoX(xOffset)
  for i=grupoObstaculos.numChildren,1,-1 do--Recorremos todo el grupo de los obstaculos
    local obs=grupoObstaculos[i]
    if obs.x>-obs.contentWidth*0.5 then--Si el obstaculo es visible en pantalla desplazalo
      obs.x=obs.x-xOffset--Movemos el obstaculo hacia la izquierda
    else--Si el obstaculo ya no es visible en pantalla lo eliminamos
      physics.removeBody(grupoObstaculos[i])--Eliminamos el obstaculo del motor de fisica
      grupoObstaculos:remove(grupoObstaculos[i])--Eliminamos el objeto display
      grupoObstaculos[i]=nil--Ponemos su variable a nil
    end
  end
end


--Funcion para mover el fondo
local function MoverFondo(xOffset)
    for i=1,7 do
        if fondo[7].x<=W and fin==false then--Si la ultima imagen del fondo no se ha terminado de colocar en pantalla
        muelle.x=muelle.x-xOffset*0.1--Movemos el muelle que indica la salida hacia la izquierda
        casa.x=casa.x-xOffset*0.1--Movemos la casa del fondo hacia la izquierda
        end
        if fondo[7].x<=0 then--Si la ultima imagen del fondo se coloco en pantalla
          fondo[i].x=0--La fijamos para que no se desplace al margen izquierdo de la pantalla
          fin=true--Activamos el flag que indica que llegamos al final del nivel
         else--Si la ultima imagen del fondo no se coloco
           fondo[i].x=fondo[i].x-xOffset--Desplazamos todas las imagenes hacia la izquierda
        end
      end
   --Devolvemos el flag que indica que llegamos al final del nivel
  return fin
  
end

--Funcion para mover los elementos de la escena mediante el evento "enterframe"
local function mover(event)
  	--Obtenemos un incremento de tiempo como la resta del momento en que se produce el evento y el instante inicial guardado al inicio
	local tDelta = event.time - tPrevious
  tPrevious = event.time--Actualizamos el isntante inicial 
    --Obtenemos los desplazamientos para el fondo, el personaje y para los obstaculos 
	local xOffsetFondo = ( 0.3 * tDelta )
  local xOffsetObstaculo = ( 0.8 * tDelta )
  local xOffsetPersonaje = ( 0.4 * tDelta ) 
  
  
    if juegoEmpezado==true then--Si hemos comenzado a jugar
      if flagPausa==false then--Si el juego no esta pausado
         fin=MoverFondo(xOffsetFondo)--Movemos el fondo y obtenemos el flag que indica si termino
         if (personaje.y>H) or(personaje.y<-personaje.contentWidth*0.5)or (personaje.x<=-personaje.contentWidth) then--Si el personaje se sale de la pantalla por abajo, por la izquierda  o por arriba
            --Reproducimos el sonido de la muerte del personaje y cuando se haya terminado lanzamos la escena del gameOver con cuenta atras
            audio.play(tablaSonido["muerte"],{channel=4,onComplete=irGameOverTimer})
          end
        if fin==false then--Si el fondo no ha terminado seguimos moviendo los obstaculos
          MoverObstaculoX(xOffsetObstaculo)--Movemos los obstaculos horizontalmente
        else--Si el fondo termino su recorrido y esta colocado en su ultima imagen
           timer.cancel(anyadirObstaculoTimer)--Cancelamos el timer de los obstaculos
          personaje.x=personaje.x+xOffsetPersonaje--Movemos el personaje hacia la derecha
          if personaje.x>=W then--Si el personaje se salio de la pantalla
            siguienteNivel()--guardamos los cambios y lanzamos el inicio del siguiente Nivel
          end
        end
      end
    end
     --Como ya hemos tratado el evento devolvemos true para que no siga propagandose
    return true
end



--Funcion Listener para el boton de play/pause
local function playAndPause(event)
   local phase=event.phase
  if phase=="began" then
    --Reproducimos el sonido de pulsar boton
    audio.play( tablaSonido["pulsarBtn"],{channel=6} )
    if btnPausa.isVisible==true then--Estamos jugando y hemos presionado el pause-->Pausamos el juego
      --Cambiamos la apariencia del boton: de Pause a Play
      btnPausa.isVisible = false
      btnPlay.isVisible = true
      --Paramos el canal de la musica de fondo
      audio.pause(1)
      --Paramos el motor de fisica para que el personaje no caiga y se quede congelado
      physics.pause()
      --Actimavamos el flag que indica que el juego esta pausado
      flagPausa=true
      --Paramos el sprite del personaje
      personaje:pause()
    
     if fin==false then--Si todavia no llegamos al final del nivel
        --Pausamos el timer que genera los obstaculos para que no se agolpen fuera de pantalla obstaculos nuevos
        timer.pause( anyadirObstaculoTimer )
     end
  else--Estamos pausados y presionamos start-->Arrancamos el juego
    --Cambiamos el aspecto del boton: de Play a Pausa
    btnPausa.isVisible = true
    btnPlay.isVisible = false
    
    --Volvemos a activar el sonido de la musica de fondo
    audio.resume(1)
    --Volvemos a activar el motor de fisica
    physics.start()
    --Desactivamos el flag que indica que el juego esta pausado
    flagPausa=false
    --Activamos el sprite del personaje
    personaje:play()
    
    if fin==false then--Si todavia no se llego al final del nivel
      --Volvemos a activar el timer que genera los obstaculos
      timer.resume(anyadirObstaculoTimer)
    end
  end
end
  --Como ya hemos tratado el evento devolvemos true para que no siga propagandose
 return true 
end

--Funcion Listener para las colisiones
local function onCollision(event)
  if(event.phase=="began") then--Si se produce una colision 
   --Reproducimos el sonido del golpe
    audio.play(tablaSonido["golpe"],{channel=3,duration=100})
   --Colocamos el golpe en la posicion del personaje
   choque.x=personaje.x; choque.y=personaje.y
   --Hacemos visible el golpe
   choque.isVisible=true
    --Funcion que oculta la imagen del choque y evalua el resultado
   local evaluarChoque = function()  
       if choque and datos and vida and tablaSonido then  
        choque.isVisible=false--Ocultamos el golpe 
           --Quitamos una vida al personaje
         if datos.vidas>0 then
         datos.vidas=datos.vidas-1
         end
         --Actualizamos el marcador de vidas
         vida.text="x "..datos.vidas
         --Si el numero de vidas es 0 se acabo la partida
         if datos.vidas==0 then 
           --Reproducimos el sonido de la muerte y lanzamos la escena del Game Over del modo Survival
              audio.play(tablaSonido["muerte"],{channel=4,onComplete=irGameOverTimer})
             
          end
       else--Si alguno de los objetos es nil-->Se ejecuta la funcion despues de salir de la escena
         irGameOverTimer()--Lanzamos la escena del Game Over del modo Survival
      end
    end
    --Pasados  0.1 seg ocultamos el choque y evaluamos el resultado del mismo
   timer.performWithDelay(100,evaluarChoque,1)
 
end
  --Como ya hemos tratado el evento devolvemos true para que no siga propagandose
  return true
end

--Funcion para anyadir obstaculos
local function AnyadirObstaculo()
  local datosObstaculo
  --Creamos una altura aleatoria para colocal el obstaculo
   local altura=math_random(0,H) 
    --Guardamos todos los datos del obstaculo 
  datosObstaculo=soporte:RellenarDatosObs("graficos/liberarGlobox/nivel3/nube.png",300,100,0.5,0,W+150,altura,nil,false)
  --Creamos el obstaculo y lo añadimos al grupo de obstaculos
  local obstaculo=soporte:crearObstaculoSimple(datosObstaculo,grupoObstaculos)
  --Añadimos el obstaculo al motor de fisica
  physics.addBody(obstaculo,"static",{density=0.1,friction=0.2,bounce=0})
  
end


--Funcion listener para elevar al personaje cuando tocamos la pantalla
local function vuela(event)
  local phase=event.phase
  if phase=="began" then--Si el usuario toca con el dedo la pantalla
   
  --Si el juego no ha empezado debemos mostrar las instrucciones
    if juegoEmpezado==false then
      --Reproducimos el sonido del helicoptero de rayman
       audio.play(tablaSonido["rayHelicoptero"],{channel=2,duration=100})
       --Hacemos visible el grupo de botones start/pause
       grupoBtn.isVisible=true
       --Paramos la musica de las instrucciones
        audio.stop(5)
        --Reproducimos la musica del modo survival  con un volumen al 50%
        audio.setVolume(0.5,{channel=1})
        audio.play(tablaSonido["musicaFondo"],{channel=1,loops=-1})
      --Activamos el flag de juego empezado
      juegoEmpezado=true
      --Hacemos invisibles las instrucciones
      instrucciones.alpha=0
      --Hacemos visible la vida
      cara.isVisible=true
      vida.isVisible=true
   
      --Hacemos visible a rayman y le ponemos haciendo el helicoptero
      personaje.alpha=1
      personaje=soporte:cambiarSecuencia(personaje,"caida")
      
      --Cambiamos el tipo de objeto a dynamic
      personaje.bodyType="dynamic"

      --Aplicamos una fuerza leve para elevar al personaje 
        personaje:applyForce(0,-300,personaje.x,personaje.y)
   
      --Creamos un timer para añadir obstaculos cada 1.5 seg
     anyadirObstaculoTimer=timer.performWithDelay(250,AnyadirObstaculo,-1)
         
    
  else--Si el juego ya comenzo cada vez que pulsemos la pantalla debera de elevarse el personaje y activarse el helicoptero
    if flagPausa==false then--Si el juego no esta en pause 
            --Reproducimos el sonido del helicoptero
            audio.play(tablaSonido["rayHelicoptero"],{channel=2,duration=100})
            --Cambiamos la secuencia del sprite del personaje para que vuele
          personaje=soporte:cambiarSecuencia(personaje,"vuela")
          --Aplicamos una fuerza para elevar al personaje
          personaje:applyForce(0,-600,personaje.x,personaje.y)
        
    end
  end
  
end
  --Como ya hemos tratado el evento devolvemos true para que no siga propagandose
  return true
  
end


-- "scene:create()"
function scene:create( event )
   
    local sceneGroup = self.view
    --Desactivamos el flag de juegoEmpezado para que se muestren las instrucciones
    juegoEmpezado=false
        
    --Leemos los datos del archivo de datos
    datosString=soporte:leerDatos()
    datos=json.decode(datosString)
     --Cargamos todos los sonidos de la escena
     tablaSonido = { 
            musicaFondo=audio.loadStream("sonido/musicaNivelGlobox3.wav"),
            rayHelicoptero = audio.loadSound( "sonido/rayHelicoptero.wav" ),
            golpe=audio.loadSound( "sonido/golpe.wav" ),
            muerte=audio.loadSound( "sonido/muerte.wav" ),
            instrucciones=audio.loadStream("sonido/musicaInstruccionesGlobox3.wav")
          }
          
    --Creamos fondo y lo añadimos a la escena
    for i=1,7 do
       fondo[i]=soporte:CrearObjeto("graficos/liberarGlobox/nivel3/fondoNivel3 ("..i..").png",W,H,0,0,W*(i-1),0)
       sceneGroup:insert(fondo[i])  
    end

  --Grupo para los objetos de obstaculos
  grupoObstaculos=soporte:CrearGrupo(0,1,0,0)
  
  --Creamos el sprite del personaje
    personaje=soporte:CrearPersonaje("sheetsInfo.raymanPersonaje","graficos/personajes/raymanPersonaje.png",0.5,0.5,3,3,centroX-170,centroY)
    --Añadimos el personaje al motor de fisica
    physics.addBody(personaje,"static",{density=0.1,friction=1,bounce=0})
   
    --Creamos las instrucciones
   instrucciones=soporte:CrearInstrucciones("rayman",centroX,centroY,1)
  
    
  --Creamos la salida del nivel
  --Creamos el muelle de salida
  muelle=soporte:CrearObjeto("graficos/liberarGlobox/nivel3/muelle.png",800,500,0,0,W,H-400)
  physics.addBody(muelle,"static",{density=0.1,friction=1,bounce=0})--Añadimos el muelle al motor de fisica
  --Creamos una casa en el fondo a modo de descoracion
  casa=soporte:CrearObjeto("graficos/liberarGlobox/nivel3/casa.png",400,900,0,0,W+100,H-1000)
  
  
  --Creamos el icono del personaje seleccionado y el contador de vidas
   cara,vida=soporte:CrearVida("rayman",datos.vidas)
   
 --Creamos el boton de play/pause
   btnPausa,btnPlay,grupoBtn=soporte:CrearBotonPlayPause(W-100,vida.y)
   
   --Creamos el choque
   choque=soporte:CrearObjeto("graficos/personajes/choque.png",25,50,0,0.5,personaje.x,personaje.y)
   choque.isVisible=false
   choque:scale(3,3)
   
  --Añadimos los elementos a la vista
  sceneGroup:insert(casa)
  sceneGroup:insert(instrucciones)
  sceneGroup:insert(muelle)
  sceneGroup:insert(grupoObstaculos)
  sceneGroup:insert(personaje)
  sceneGroup:insert(cara)
  sceneGroup:insert(vida)
  sceneGroup:insert(grupoBtn)
  sceneGroup:insert(choque)


end
-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen)
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen
        -- Insert code here to make the scene come alive
        -- Example: start timers, begin animation, play audio, etc.
        -- Start everything moving
       
        --Reproducimos la musica de las instrucciones
        audio.play(tablaSonido["instrucciones"],{channel=5,loops = -1})
        --Arrancamos el sprite del personaje
        personaje:play() 
        --Añadimos los listeners
        Runtime:addEventListener("touch",vuela)--Listener para hacer que el personaje se eleve al tocar la pantalla
        Runtime:addEventListener("enterFrame",mover)--Listener para mover el fondo, la salida y los obstaculos
        Runtime:addEventListener("collision",onCollision)--Listener de las colisiones con los obstaculos
        grupoBtn:addEventListener("touch",playAndPause)--Listener para los botones de play/pause
        personaje:addEventListener("sprite",personajeListener)--Listener para cambiar la secuencia del personaje
    end
end


-- "scene:hide()"
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen)
        -- Insert code here to "pause" the scene
        -- Example: stop timers, stop animation, stop audio, etc.
        
      --Paramos todos los canales de audio
      audio.stop()
     --Paramos el Sprite del personaje
        personaje:pause()
    
      --Eliminamos los listeners
      Runtime:removeEventListener("touch",vuela)  
      Runtime:removeEventListener("enterFrame",mover)
      Runtime:removeEventListener("collision",onCollision)
      personaje:removeEventListener("sprite",personajeListener)
      grupoBtn:removeEventListener("touch",playAndPause)
      --Cancelamos el timer de anyadir obstaculos
      timer.cancel(anyadirObstaculoTimer)
      
      --Eliminamos los objetos del motor de fisica      
      physics.removeBody(personaje)
      physics.removeBody(muelle)
      physics.stop()--Paramos el motor de física
       
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen
        
    end
end


-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view

    -- Called prior to the removal of scene's view
    -- Insert code here to clean up the scene
    -- Example: remove display objects, save state, etc.
 
 --Eliminamos y liberamos la memoria de todos los elementos de la escena
    soporte:EliminarElementos(sceneGroup)
    sceneGroup=nil
    --Limpiamos y liberamos la memoria del audio
   if tablaSonido then
     for s,v in pairs(tablaSonido) do
            audio.dispose(tablaSonido[s])
            tablaSonido[s]=nil
          end
      tablaSonido=nil
    end
     --Liberamos los modulos cargados        
    package.loaded[physics] = nil
    package.loaded[json]=nil
    package.loaded[soporte]=nil
    soporte,json,physics=nil,nil,nil--Ponemos sus variables a nil
   if composer then--Si no se libero la variable antes-->El jugador supero el nivel
        package.loaded[composer]=nil; 
        composer=nil 
      end
   --Variables para la gestion del archivo de datos
   for n,m in pairs(datos) do
     datos[n]=nil
   end
   datos=nil
   --Optimizacion
   math_random=nil  
    
--Variables de los objetos display
personaje, instrucciones,muelle,cara,vida,choque,casa=nil,nil,nil,nil,nil,nil,nil
for t=#fondo,1,-1 do
  fondo[t]=nil
end
fondo=nil
--Variables de boton play/pause
btnPlay,btnPausa=nil,nil
--Variables de los grupos
grupoObstaculos,grupoBtn=nil,nil
--Variable del timer de añadir obstaculos
anyadirObstaculoTimer=nil


end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene