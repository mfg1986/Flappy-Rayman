--require('mobdebug').start()
--Cargamos el modulo de soporte
local soporte=require("soporte")

--Cargamos la libreria "composer"
local composer=require("composer")
local scene=composer.newScene()--Creamos una escena nueva
--Activamos el flag para que al cambiar de escena se elimine la vista de la misma
composer.recycleOnSceneChange=true

--Obtenemos el tamaño de la pantalla
local W=display.contentWidth
local H=display.contentHeight
local centroY=display.contentCenterY
local centroX=display.contentCenterX
local tipoDispositivo
--Declaramos variables necesarias
local personaje,electroons
local fondo={}

local flagAndar=false
local flagGolpe=false
local flagCayendo=false
local bandera=false
local tablaSonido={}
local tPrevious = system.getTimer()
local pasosTimer


  --Funcion para mover los elementos de la escena mediante el evento "enterFrame"
local function mover(event)
 --Obtenemos un incremento de tiempo como la resta del momento en que se produce el evento y el instante inicial guardado al inicio
	local tDelta = event.time - tPrevious
	tPrevious = event.time--Actualizamos el isntante inicial 
 --Creamos un desplazamiento 
	local Offset = ( 0.2 * tDelta )

  if flagAndar==true then--Si el flag del personaje andando esta activo-->Desplazamos a rayman pero no el fondo
   if flagGolpe==false then--Si rayman todavia no golpeo la jaula
     personaje.x=personaje.x+Offset--movemos a ray hacia la derecha
        if(personaje.x>=electroons.x-electroons.contentWidth) and flagGolpe==false then--Si rayman llego hasta a la jaula y todavia no la golpeo
          flagAndar=false--desactivamos el flag de andar
          soporte:cambiarSecuencia(personaje,"golpeando")--Cambiamos la secuencia del personaje para que golpee la jaula
        end
    end
  end
  if flagGolpe==true then--Si rayman ya golpeo la jaula-->Desplazamos el fondo pero no a rayman
      for i=1,3 do
        fondo[i].x=fondo[i].x-Offset--Desplazamos la imagenes del fondo hacia la izquierda
        electroons.x=electroons.x-Offset*0.3--Desplazamos los electroons con las imagenes de fondo
        if fondo[2].x<35 then--Si el personaje comienza a acercarse al precicpicio
          personaje.y=personaje.y+Offset*0.1--Lo desplazamos ligeramente hacia abajo
        end
        if fondo[2].x<-220 then--Si el personaje llego al borde del precicipicio
          if bandera==false then--Si el flag de la bandera esta desactivado
              bandera=true--Activamos la bandera para no volver a ejecutar este bloque
            timer.cancel(pasosTimer)--Cancelamos el timer que reproduce los pasos de rayman
           --Reproducimos el sonido de la voz de rayman
            audio.play(tablaSonido["rayman"],{channel=6,duration=600})
            audio.seek(11000,{channel=6})--Fijamos el minuto en el que se encuentra la voz de rayman
            --Creamos un timer que se ejecutara 0.1s despues para sincronizarse con la caida del personaje
            timer.performWithDelay(100,function()
                --Reproduciremos el sonidod e una caida libre
                audio.play(tablaSonido["caida"],{channel=4})
                audio.seek(4000,{channel=4})
               
            end,1)
             soporte:cambiarSecuencia(personaje,"cayendo")--Cambiamos la secuencia para que el personaje comience a caer
            flagCayendo=true--Activamos el flag que indica que el personaje esta cayendo
          end
       
        end
        if fondo[3].x<=0 then--Si la ultima imagen del fondo llega al margen izquierdo de la pantalla
            fondo[3].x=0--Fijamos al margen la ultima imagen para evitar zonas muertas por la derecha de la pantalla  y que el fondo siga avanzando hacia la izquierda
        end
      end
    end
  if flagCayendo==true then--Si el flag que indica que rayman esta cayendo esta activado
     personaje.y=personaje.y+Offset*1.2--Movemos a rayman hacia abajo
     if personaje.y>H+personaje.contentHeight then--Si rayman se sale de la pantalla
       composer.gotoScene("liberarGlobox.nivelGlobox2")--Lanzamos la escena del nivel 2 del juego liberar a globox
     end
  end
   --Como ya hemos tratado el evento devolvemos true para que no siga propagandose
return true
end

--Funcion listener de los electroons
local function electroonsListener(event)
   local sprite=event.target
  if event.phase=="ended" then
   if sprite.sequence=="abrirJaula" then--Si la secuencia que termino es la de los electroons
     soporte:cambiarSecuencia(sprite,"electroonsLibres")--Cambiamos la secuencia para que los electrones aparezcan libres
    end
  end
   --Como ya hemos tratado el evento devolvemos true para que no siga propagandose
  return true
  
end
--Funcion listener de rayman
local function personajeListener (event)
  local sprite=event.target
  if event.phase=="ended" then
    if sprite.sequence=="aterrizando" then--Si la secuencia que termino era rayman aterrizando
      --Creamos un timer para reproducir el sonido de los pasos cada 0.2s
      pasosTimer=timer.performWithDelay(200,function()audio.play(tablaSonido["pasos"],{channel=5})end,-1) 
      soporte:cambiarSecuencia(personaje,"andando")--Cambiamos la secuencia para que rayman comience a andar
      flagAndar=true--Activamos el flag que indica que rayman comienza a andar
      
    elseif sprite.sequence=="andando" then--Si la secuencia que termino era rayman andando
      if flagGolpe==false then--Si todavia no golpeo la caja
       timer.cancel(pasosTimer)--Paramos el sonido de los pasos
       soporte:cambiarSecuencia(personaje,"golpeando")--Cambiamos la secuencia para que ray golpee la jaula
        --Creamos una funcion en la que se ejecutaran los efectos para liberar a los electroons
        local liberarElectroons=function()
            audio.setVolume(4,{channel=2})
            audio.play(tablaSonido["golpe"],{channel=2,duration=100})--Reproducimos el sonido del golpe
            soporte:cambiarSecuencia(electroons,"abrirJaula")--Cambiamos la secuencia para que se abra la jaula de los electroons
            --Reproducimos el sonido de los electroons libres
             audio.play(tablaSonido["electroons"],{channel=4,duration=5000})
             audio.seek(31000,{channel=4})
    
          end        
        timer.performWithDelay(1400,liberarElectroons,1)--Creamos un timer con un retardo de 1.4s para que se sincronice con el puño dando en la jaula y liberamos a los elecctroons 
      else--Si el golpe a la jaula ya se produjo
         soporte:cambiarSecuencia(personaje,"andando")--Cambiamos la secuencia para que rayman siga andando
        end
    
  elseif sprite.sequence=="golpeando" then--Si la secuencia que se termino era rayman golpeando la jaula
      --Creamos un timer que reproducira el sonido de los pasos
       pasosTimer=timer.performWithDelay(200,function()audio.play(tablaSonido["pasos"],{channel=5})end,-1) 
      soporte:cambiarSecuencia(personaje,"andando")--Cambiamos la secuencia para que rayman ande
      flagAndar=true--Activamos el flag que indica que rayman esta andando
      flagGolpe=true--Activamos el flag que indica que el golpe a la jaula ya se produjo
    end
  end
   --Como ya hemos tratado el evento devolvemos true para que no siga propagandose
  return true
 end

-- "scene:create()"
function scene:create( event )
   
    local sceneGroup = self.view
  --Cargamos todos los sonidos de la escena
  tablaSonido = { 
            musicaFondo=audio.loadStream("sonido/musicaInicioNivelGlobox2.wav"),
            golpe=audio.loadSound( "sonido/golpe.wav" ),
            electroons=audio.loadSound("sonido/vocesElectroons.wav"),
            caida=audio.loadSound("sonido/caida.wav"),
            pasos=audio.loadSound("sonido/pasos.wav"),
            rayman=audio.loadSound("sonido/vocesRaymanGlobox.wav")
          }
    --Creamos fondo y añadimos las imagenes a la escena
  for i=1,3 do
     fondo[i]=soporte:CrearObjeto("graficos/liberarGlobox/inicioNivel2/fondoInicioNivel2 ("..i..").png",W,H,0,0,W*(i-1),0)
     sceneGroup:insert(fondo[i])
    end
    
    --Creamos los electrones
    electroons=soporte:CrearAnimacionElectroons(centroX+270,centroY-150)
    --Creamos la animacion de rayman 
    personaje=soporte:CrearAnimacionRay(0,centroY-300)
    
    
    --Añadimos los elementos a la escena
      sceneGroup:insert(electroons)
      sceneGroup:insert(personaje)
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
           
      --Reproducimos la musica de fondo con el volumen al 50%
      audio.setVolume(0.5,{channel=1})
      audio.play(tablaSonido["musicaFondo"],{channel=1,loops=-1})
      --Reproducimos el sonido de los electroons pidiendo auxilio con el volumen al 15%
      audio.setVolume(0.15,{channel=3})
      audio.play(tablaSonido["electroons"],{channel=3,duration=5000})
      audio.seek(45000,{channel=3})
      --Arrancamos la animacion de los sprites
      electroons:play()--sprite de los electroons
      personaje:play()--sprite de rayman
      --Añadimos los listeners
      Runtime:addEventListener("enterFrame",mover)--Listener para movel al personaje, el fondo y los electroons
      personaje:addEventListener("sprite",personajeListener)--Listener del sprite de rayman
      electroons:addEventListener("sprite",electroonsListener)--Listener del sprite de los electroons
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
      --Paramos los sprites de los electroons y de rayman
       electroons:pause()
       personaje:pause()
    --Eliminamos los listeners
      Runtime:removeEventListener("enterFrame",mover)
      personaje:removeEventListener("sprite",personajeListener)
      electroons:removeEventListener("sprite",electroonsListener)   

     
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
    for s,v in pairs(tablaSonido) do
          audio.dispose(tablaSonido[s])
          tablaSonido[s]=nil
        end
    tablaSonido=nil
  --Liberamos los modulos cargados        
    package.loaded[composer]=nil
    package.loaded[soporte]=nil
    soporte,composer=nil,nil--Ponemos sus variables a nil
    
 --Variables de los objetos display 
  personaje,electroons=nil,nil
   for t=#fondo,1,-1 do
   fondo[t]=nil
 end
 fondo=nil
--Variable del timer que reproduce los pasos de rayman
pasosTimer=nil
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene