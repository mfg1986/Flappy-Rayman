--require('mobdebug').start()
--Cargamos el modulo "soporte"
local soporte=require("soporte")
--Cargamos la libreria "json"
local json=require("json")

--Cargamos el motor de fisica
local physics=require("physics")
physics.start()--Arrancamos el motor de fisica
--Establecemos el valor de la gravedad
 physics.setGravity(0,100)

--Cargamos la libreria "composer"
local composer=require("composer")
--Creamos una escena nueva
local scene=composer.newScene()
--Activamos el flag para que al cambiar de escena se elimine la vista de la misma
composer.recycleOnSceneChange=true


--Obtenemos el tamaño de la pantalla
local W=display.contentWidth
local H=display.contentHeight
local centroY=display.contentCenterY
local centroX=display.contentCenterX
--Declaramos la variables necesarias
local math_random=math.random--optimizacion
local datos={}
local datosString
local fondo={}
local personaje,instrucciones,vida,cara,marcador,choque
local obstaculos,obstaculoFinal,grupoObstaculos

local factorVelocidad=1
local factorVelocidadPrev=1
local grupoBtn,btnPlay,btnPausa

local juegoEmpezado=false
local obstaculoFinalColado=false
local fin=false
local flagPausa=false
local anyadirObstaculoTimer
local tPrevious = system.getTimer()--Obtenemos el instante incial de tiempo
local tablaSonido={}


--Funcion para salir del Nivel y lanzar la escena del Game Over
 local function irGameOverSurvival ()
     if json and datos then
       --Restablecemos el contador de vidas
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
       if composer then
         --Nos vamos al Game Over del Survival
         composer.gotoScene("gameOver.gameOverSurvival")
        --Liberamos la memoria de la librería composer y su variable
        package.loaded[composer]=nil;composer=nil
      end
    end



--Funcion listener del personaje
local function personajeListener(event)
  local sprite=event.target
  if event.phase=="ended" then--Cuando la secuencia que se este reproduciendo se termina
    if sprite.sequence=="vuela" then--Si se ejecutaba la secuencia de "vuela"
      soporte:cambiarSecuencia(sprite,"caida")--Cambiamos la secuencia a "caida"
    end
  end
   --Como ya hemos tratado el evento devolvemos true para que no siga propagandose
  return true
end
--Funcion para mover obstaculos
local function MoverObstaculo(xOffset)
 
  for i=grupoObstaculos.numChildren,1,-1 do--Recorremos todo el grupo de obstaculos
    local obs=grupoObstaculos[i]
    if(personaje.x>=obs.x) then-- Si el obstaculo paso el pto en el que se encuentra el personaje en el eje x en su desplazamiento hacia la izquierda
      if obs.pasado==false then--Si el obstaculo esta marcado como no pasado
        obs.pasado=true--Marcamos el obstaculo como pasado por el personaje
        
      --Aumentamos el numero de obstaculos pasados
        datos.puntuacion=datos.puntuacion+1
        marcador.text=datos.puntuacion--Ponemos en la etiqueta de la pantalla la puntuacion de obstaculos pasados
        
        factorVelocidadPrev=factorVelocidad--Guardamos el valor de factor de velocidad
        factorVelocidad=( datos.puntuacion/10)+1--Calculamos el nuevo factor de velocidad
        
        if factorVelocidadPrev~=factorVelocidad then--Si el factor de velocidad ha cambiado
          anyadirObstaculoTimer._delay = 1500/factorVelocidad--Reducimos el retardo del timer que genera los obstaculos para que los genere mas deprisa puesto que el desplazamiento de los mismos tambien es mas rapido
        end        
      end
    end
    if obs.x>-100 then--Si el obstaculos es visible en pantalla desplazalo
      obs.x=obs.x-xOffset
    else--Si el obstaculo no es visible lo eliminamos
      physics.removeBody(grupoObstaculos[i])
      grupoObstaculos:remove(grupoObstaculos[i])
      grupoObstaculos[i]=nil
    end
  
  end
end
--Funcion para mover el fondo
local function MoverFondo(xOffset)
--El fondo esta compuesto por tres imagenes que se ejecutan de forma ciclica
  for i=1,3 do
        fondo[i].x=fondo[i].x-xOffset--Vamos desplazando cada una de las imagenes de fondo hacia la izquierda
        if fondo[i].x<=-2*W then--Si han pasado por pantalla las 3 imagenes el ciclo debe volver a empezar
         fondo[i].x=fondo[i].x+3*W--Colocamos en posicion inicial la imagen-->en el margen derecho de la pantalla
        end
        
    end
end
--Listener de Runtime al evento "enterframe" que se utiliza para coordinar las funciones de movimiento del fondo y los obstaculos
local function mover(event)
  	--Obtenemos un incremento de tiempo como la resta del momento en que se produce el evento y el instante inicial guardado al inicio
	local tDelta = event.time - tPrevious
  tPrevious = event.time --Actualizamos el isntante inicial 
  --Obtenemos los desplazamientos para el fondo y para los obstaculos en funcion del factor de velocidad
	local xOffsetFondo = ( 0.3 * tDelta )*factorVelocidad
  local xOffsetObstaculo = ( 0.4 * tDelta )*factorVelocidad

    if juegoEmpezado==true  then--Si hemos comenzado a jugar
      if flagPausa==false then--Si el boton de pausa del juego no esta pulsado
         MoverFondo(xOffsetFondo)--Movemos el fondo segun el desplazamiento calculado
         MoverObstaculo(xOffsetObstaculo)--Movemos los obstaculos segun el desplazamiento calculado
         --Si el personaje se sale de la pantalla por abajo o por la izquierda
         if (personaje.y>H) or (personaje.x<=-personaje.contentWidth) then
             --Guardamos los cambios
             datosString=json.encode(datos)
             soporte:guardarDatos(datosString)
          
             --Reproducimos el sonido de la muerte del personaje y cuando finalize lanzamos el game Over del Survival
             audio.play(tablaSonido["muerte"],{channel=4,onComplete=irGameOverSurvival})
           
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
     --Pausamos el timer que genera los obstaculos para que no se agolpen fuera de pantalla obstaculos nuevos
     timer.pause( anyadirObstaculoTimer )
    
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
    --Volvemos a activar el timer que genera los obstaculos
    timer.resume(anyadirObstaculoTimer)
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
              audio.play(tablaSonido["muerte"],{channel=4,onComplete=irGameOverSurvival})
             
          end
       else--Si alguno de los objetos es nil-->Se ejecuta la funcion despues de salir de la escena
         irGameOverSurvival()--Lanzamos la escena del Game Over del modo Survival
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
 
  --Obtenemos la altura de forma aleatoria 
  local altura=math_random(centroY-200,centroY+200)
  
  --Guardamos todos los datos del obstaculo de arriba y de abajo
  local obstaculoArriba=soporte:RellenarDatosObs("graficos/survival/obstaculosSurvivalArriba.png",280,1000,0.5,1,W+100,altura-160,"arriba",false)
  local obstaculoAbajo=soporte:RellenarDatosObs("graficos/survival/obstaculosSurvivalAbajo.png",280,1000,0.5,0,W+100,altura+160,"abajo",false)
 
  --Creamos los obstaculos de tipo 1, los añadimos al motor de fisica y al grupo de obstaculos
  obstaculos=soporte:crearObstaculoMultiple(obstaculoArriba,obstaculoAbajo,grupoObstaculos)
--Añadimos los obtaculos de arriba y abajo al motor de fisica
  for n=1,2 do
     physics.addBody(obstaculos[n],"static",{density=0.1,friction=0.2,bounce=0})
  end
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
      --Hacemos visible el marcador, y la vida
      marcador.alpha=1
      cara.isVisible=true
      vida.isVisible=true
   
      --Hacemos visible a rayman y le ponemos haciendo el helicoptero
      personaje.alpha=1
      personaje=soporte:cambiarSecuencia(personaje,"caida")
      
      --Cambiamos el tipo de objeto a dynamic
      personaje.bodyType="dynamic"
      --Debido a que el peso de los sprites es diferente para poder elevarlos hay que aplicarles fuerzas diferentes
     if datos.personaje=="rayman" then
        personaje:applyForce(0,-300,personaje.x,personaje.y)
    elseif datos.personaje=="globox" then
       personaje:applyForce(0,-1800,personaje.x,personaje.y)
      end

      --Creamos un timer para añadir obstaculos cada 1.5 seg
     anyadirObstaculoTimer=timer.performWithDelay(1500,AnyadirObstaculo,-1)
         
    
  else--Si el juego ya comenzo cada vez que pulsemos la pantalla debera de elevarse el personaje y activarse el helicoptero
    if flagPausa==false then--Si el juego no esta en pause 
            --Reproducimos el sonido del helicoptero
            audio.play(tablaSonido["rayHelicoptero"],{channel=2,duration=100})
            --Cambiamos la secuencia del sprite del personaje para que vuele
          personaje=soporte:cambiarSecuencia(personaje,"vuela")
    --Debido a que el peso de los sprites es diferente para poder elevarlos hay que aplicarles fuerzas diferentes
        if datos.personaje=="rayman" then
          personaje:applyForce(0,-600,personaje.x,personaje.y)
        elseif datos.personaje=="globox" then
           personaje:applyForce(0,-4000,personaje.x,personaje.y)
        end
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
    --Ponemos la puntuacion a 0
    datos.puntuacion=0
   --Cargamos todos los sonidos de la escena
    tablaSonido = { 
            musicaFondo=audio.loadStream("sonido/musicaSurvival.wav"),
            rayHelicoptero = audio.loadSound( "sonido/rayHelicoptero.wav" ),
            golpe=audio.loadSound( "sonido/golpe.wav" ),
            muerte=audio.loadSound( "sonido/muerte.wav" ),
            instrucciones=audio.loadStream("sonido/musicaInstruccionesSurvival.wav"),
            pulsarBtn = audio.loadSound( "sonido/pulsarBtn.wav" )}
    --Creamos el fondo
   for i=1,3 do
     fondo[i]=soporte:CrearObjeto("graficos/survival/fondoSurvival ("..i..").png",W,H,0,0,W*(i-1),0)
     sceneGroup:insert(fondo[i])--Insertamos las imagenes de fondo en la escena
    end
  
 --Grupo para los objetos de obstaculos
  grupoObstaculos=soporte:CrearGrupo(0,1,0,0)
  

 --Si el personaje que esta activo es rayman creamos el personaje
  if datos.personaje=="rayman" then
   --Creamos a rayman
    personaje=soporte:CrearPersonaje("sheetsInfo.raymanPersonaje","graficos/personajes/raymanPersonaje.png", 0.5,0.5,3,3,centroX-170,centroY)

  elseif datos.personaje=="globox" then--Si el personaje que esta activo es globox
   --Creamos a globox
    personaje=soporte:CrearPersonaje("sheetsInfo.globoxPersonaje","graficos/personajes/globoxPersonaje.png", 0.5,0.5,1.3,1.3,centroX-170,centroY)
  end
   --Añadimos el personale al motor de fisica para que sea sensible a colisiones
    physics.addBody(personaje,"static",{density=0.1,friction=1,bounce=0})
    
   --Creamos las instrucciones del personaje
    instrucciones=soporte:CrearInstrucciones(datos.personaje,centroX,centroY,1)
    --Creamos el icono del personaje seleccionado y el contador de vidas
    cara,vida=soporte:CrearVida(datos.personaje,datos.vidas)

    --Creamos el marcador
   marcador=display.newText( datos.puntuacion, centroX, 150, "font/Rayman_Adventures_TTF.ttf", 70 )
   marcador:setFillColor(240/255,81/255,186/255)--Establecemos el color del marcador
   marcador.alpha=0--Ocultamos el marcador

   
     --Creamos el boton de play/pause
   btnPausa,btnPlay,grupoBtn=soporte:CrearBotonPlayPause(W-100,vida.y)
  

   --Creamos el choque
   choque=soporte:CrearObjeto("graficos/personajes/choque.png",25,50,0,0.5,personaje.x,personaje.y)
   choque.isVisible=false--Ocultamos el choque
   choque:scale(3,3)--Ajustamos el tamaño del choque
   
  --Añadimos los elementos a la vista
  sceneGroup:insert(grupoObstaculos)
  sceneGroup:insert(grupoBtn)
  sceneGroup:insert(personaje)
  sceneGroup:insert(instrucciones)
  sceneGroup:insert(cara)
  sceneGroup:insert(vida)
  sceneGroup:insert(choque)
  sceneGroup:insert(marcador)
  


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
        --Añadimos los listener 
        Runtime:addEventListener("touch",vuela)--Listener para hacer que el personaje se eleve al tocar la pantalla
        Runtime:addEventListener("enterFrame",mover)--Listener para mover el fondo y los obstaculos
        Runtime:addEventListener("collision",onCollision)--Listener para tratar las colisiones del personaje y los obstaculos
        personaje:addEventListener("sprite",personajeListener)--Listener para cambiar la secuencia del personaje
        grupoBtn:addEventListener("touch",playAndPause)--Listener para los botones de play/pause
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
        
           
      --Paramos el Sprite del personaje
       personaje:pause()
       
      --Eliminamos los listeners
      Runtime:removeEventListener("touch",vuela)  
      Runtime:removeEventListener("enterFrame",mover)
      Runtime:removeEventListener("collision",onCollision)
      personaje:removeEventListener("sprite",personajeListener)
      grupoBtn:removeEventListener("touch",playAndPause)
     
     --Paramos el timer de anyadir obstaculos
     if anyadirObstaculoTimer then timer.cancel(anyadirObstaculoTimer) end
    
    --Eliminamos el personaje del motor de fisica
       physics.removeBody(personaje)
      physics.stop()  --Paramos el motor de fisica
     
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
        
    --Liberamos los modulos cargados        
    package.loaded[physics] = nil
    package.loaded[json]=nil
    package.loaded[soporte]=nil
    soporte,json,physics=nil,nil,nil--Ponemos sus variables a nil
 
   --Variables para la gestion del archivo de datos
   for n,m in pairs(datos) do
     datos[n]=nil
   end
   datos=nil
   --Variable de la Optimizacion
   math_random=nil
   --Variables de objetos display
   personaje,instrucciones,vida,cara,marcador,choque,obstaculos,obstaculoFinal=nil,nil,nil,nil,nil,nil,nil,nil,nil
    for t=#fondo,1,-1 do
      fondo[t]=nil
    end
  fondo=nil

   --Varibles del boton play/pause
   btnPlay,btnPausa=nil,nil,nil

   --Variable del timer de añadir obstaculos
   anyadirObstaculoTimer=nil

  --Variables de los grupos
  grupoObstaculos,grupoBtn=nil,nil

end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene