--require('mobdebug').start()
--Cargamos la libreria de soporte
local soporte=require("soporte")
--Cargamos la libreria "composer"
local composer=require("composer")
--Creamos una escena nueva
local scene=composer.newScene()
--Activamos el flag para que al cambiar de escena se elimine la vista de la misma
composer.recycleOnSceneChange=true


--Obtenemos el tamaño de la pantalla
local W=display.contentWidth
local H=display.contentHeight
local centroX=display.contentCenterX
local centroY=display.contentCenterY
--Declaramos la variables necesarias
local  fondo,martillo,rayymosqui
local btnJugar,btnJugarPulsado,btnHeroes,btnHeroesPulsado
local grupoBtnJugar,grupoBtnHeroes,grupoCuerdasHeroes,grupoCuerdasJugar
local tablaSonido={}
local tPrevious = system.getTimer()--Obtenemos el instante incial de tiempo



--Funcion Listener del boton Jugar
local function jugar(event)
  local phase=event.phase
  
  if phase=="began" then--Cuando el usuario pulsa el boton
    --Reproducimos el sonido de pulsar botón
    audio.play( tablaSonido["pulsarBtn"],{channel=2} )
    --Ponemos el boton de Jugar en modo pulsado
    btnJugar.isVisible = false
    btnJugarPulsado.isVisible = true
   
  elseif phase=="ended" then--Cuando el usuario levanta el dedo del boton
   --Devolvemos el boton de Jugar al estado de no pulsado
   btnJugar.isVisible = true
   btnJugarPulsado.isVisible = false
   --Lanzamos la escena del Menu del Juego
    composer.gotoScene("menuJuego")
  end
  --Como ya hemos tratado el evento devolvemos true para que no siga propagandose
  return true 
end
--Funcion Listener del boton Heroes
local function seleccionPersonaje(event)
  local phase=event.phase
  
  if phase=="began" then--Cuando el usuario levanta el dedo del boton
     --Reproducimos el sonido de pulsar botón
    audio.play( tablaSonido["pulsarBtn"],{channel=2})
    --Ponemos el boton de heroes en modo pulsado
    btnHeroes.isVisible = false
    btnHeroesPulsado.isVisible = true
   
  elseif phase=="ended" then--Cuando el usuario levanta el dedo del boton
    --Devolvemos el boton de Heroes al estado de no pulsado
   btnHeroes.isVisible = true
   btnHeroesPulsado.isVisible = false
   --Lanzamos la escena de Seleccion de Personaje
   composer.gotoScene("seleccionPersonaje")
  
   
  end
  
   return true 
end

--Funcion para desplazar el martillo
local function moverMartillo(event)
	--Obtenemos un incremento de tiempo como la resta del momento en que se produce el evento y el instante inicial guardado al inicio
  local tDelta = event.time - tPrevious
  --Actualizamos el isntante inicial 
	tPrevious = event.time
--Calculamos  un desplazamiento en x con el incremento de tiempo obtenido
	local xOffset = ( 0.2 * tDelta )
  --Movemos el martillo hacia la derecha
  martillo.x=martillo.x+xOffset
  --Si el martillo se sale de la pantalla por la derecha
	if (martillo.x + martillo.contentWidth)>(900+2*martillo.contentWidth) then 
    --Lo volvemos a colocar en la posicion inicial-->Fuera del margen izquierdo
		martillo:translate(-900-2*martillo.contentWidth,0)
	end
  --Como ya tratamos el evento devolvemos true para evitar su propagacion
  return true
end


-- "scene:create()"
function scene:create( event )
   
    local sceneGroup = self.view 

    --Creamos el fondo
    fondo=soporte:CrearObjeto("graficos/inicio/fondoInicio.jpg",W,H,0.5,1,centroX,H)
    --Creamos el titulo de la appp
    titulo=soporte:CrearObjeto("graficos/inicio/titulo.png",712,208,0.5,0.5,centroX,centroY-100)
    
    --Creamos una tabla con los sonidos que se van a reproducir en la escena
    tablaSonido = { 
      musicaFondo=audio.loadStream("sonido/musicaInicio.wav"),
      pulsarBtn = audio.loadSound( "sonido/pulsarBtn.wav" )
    }
    
    --Creamos los botones de Jugar y Heroes
   -- crearBotones()
    btnJugar,btnJugarPulsado,grupoBtnJugar,grupoCuerdasJugar,btnHeroes,btnHeroesPulsado,grupoBtnHeroes,grupoCuerdasHeroes= soporte:CrearBotonesInicio(centroX,centroY)
    
    --Creamos el sprite del martillo
    martillo=soporte:CrearSpriteSimple("sheetsInfo.martilloInicio","graficos/inicio/martillo.png","martillo",0.5,0.5,3,3,0,centroY+80)   
    martillo.x=-martillo.contentWidth*0.5--colocamos el martillo en la posicion inicial, fuera del margen izquierdo
    --Creamos el sprite de rayman y mosqui
    rayymosqui=soporte:CrearSpriteSimple("sheetsInfo.rayymosquiInicio","graficos/inicio/rayymosqui.png","rayymosqui",0.5,0.5,3,3,centroX,centroY-280)

   --Añadimos los elementos a la escena 
  sceneGroup:insert(fondo)
  sceneGroup:insert(titulo)
  sceneGroup:insert(grupoCuerdasHeroes)
  sceneGroup:insert(grupoBtnJugar)
  sceneGroup:insert(grupoCuerdasJugar)
  sceneGroup:insert(grupoBtnHeroes)
  sceneGroup:insert(martillo)
  sceneGroup:insert(rayymosqui)
    
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
      
        --Comenzamos la animacion del martillo
          martillo:play()
        --Comenzamos la animacion de ray y mosqui
          rayymosqui:play()
       
      --Añadimos los listener a los objetos 
      Runtime:addEventListener( "enterFrame", moverMartillo );--Listener para mover el martillo
      grupoBtnJugar:addEventListener("touch",jugar)--Listener del boton jugar para lanzar el menu del Juego
      grupoBtnHeroes:addEventListener("touch",seleccionPersonaje)--Listener del boton heroes para lanzar la seleccion de personaje
      
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
        --Paramos la animacion del martillo
        martillo:pause()
        --Paramos la animacion de rayman
        rayymosqui:pause()
        
        --Eliminamos los Listener
        Runtime:removeEventListener("enterFrame",moverMartillo)
        grupoBtnJugar:removeEventListener("touch",jugar)
        grupoBtnHeroes:removeEventListener("touch",seleccionPersonaje)
        
      
    
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
    
    --Eliminamos  todos los objetos de la escena y liberamos su memoria
    soporte:EliminarElementos(sceneGroup) 
    sceneGroup=nil
    
    --Liberamos la memoria del audio
     for s,v in pairs(tablaSonido) do
          audio.dispose(tablaSonido[s])
          tablaSonido[s]=nil
        end
    tablaSonido=nil
      --Liberamos los modulos cargados        
    package.loaded[composer]=nil
    package.loaded[soporte]=nil
    soporte,json,composer=nil,nil,nil--Ponemos sus variables a nil

  --Variables de los objetos display
  fondo,martillo,rayymosqui=nil,nil,nil
  --Variables de los botones
  btnJugar,btnJugarPulsado,btnHeroes,btnHeroesPulsado=nil,nil,nil,nil
  --Variables de los grupos
  grupoBtnJugar,grupoBtnHeroes,grupoCuerdasHeroes,grupoCuerdasJugar=nil,nil,nil,nil

end
-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene