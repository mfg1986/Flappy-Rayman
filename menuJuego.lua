--require('mobdebug').start()
--Cargamos la libreria de soporte
local soporte=require("soporte")
--Cargamos la libreria "json"
local json=require("json")
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
--Declaramos las variables necesarias
local  fondo,tablon
local btnSurvival,btnSurvivalPulsado,btnGlobox,btnGloboxPulsado,btnMinimo,btnMinimoPulsado,btnBarbara,btnBarbaraPulsado,btnInicio,btnInicioPulsado
local grupoBtnJugar,grupoBtnGlobox,grupoBtnMinimo,grupoBtnBarbara,grupoBtnInicio
local candadoMinimo,candadoBarbara,cierre1,cierre2
local datos={}
local datosString
local tablaSonido={}

--Funcion Listener del boton Inicio
local function irInicio(event)
  local phase=event.phase
  if phase=="began" then--Cuando el usuario pulsa el boton
    --Reproducimos el sonido de pulsar botón
    audio.play( tablaSonido["pulsarBtn"],{channel=2} )
     --Ponemos el boton de Inicio en modo pulsado
    btnInicio.isVisible = false
    btnInicioPulsado.isVisible = true
   
  elseif phase=="ended" then--Cuando el usuario levanta el dedo del boton
   --Devolvemos el boton de Inicio al estado de no pulsado
   btnInicio.isVisible = true
   btnInicioPulsado.isVisible = false
   --Lanzamos la escena de Inicio
    composer.gotoScene("inicio")
   
  end
   --Como ya hemos tratado el evento devolvemos true para que no siga propagandose
  return true 
end

--Funcion Listener del boton Survival
local function survival(event)
  local phase=event.phase
  
  if phase=="began" then--Cuando el usuario pulsa el boton
     --Reproducimos el sonido de pulsar botón
    audio.play( tablaSonido["pulsarBtn"],{channel=2} )
     --Ponemos el boton de Survival en modo pulsado
    btnSurvival.isVisible = false
    btnSurvivalPulsado.isVisible = true
   
  elseif phase=="ended" then--Cuando el usuario levanta el dedo del boton
    --Guardamos el juego que hemos seleccionado 
    datos.juegoActual="survival"
    --Guardamos los cambios de datos 
    datosString=json.encode(datos)
    soporte:guardarDatos(datosString)

  --Devolvemos el boton de Survival al estado de no pulsado
   btnSurvival.isVisible = true
   btnSurvivalPulsado.isVisible = false
   --Lanzamos la escena del modo de juego Survival
  composer.gotoScene("survival.survival")
  end
    --Como ya hemos tratado el evento devolvemos true para que no siga propagandose
  return true 
end

--Funcion Listener del boton Liberar a Globox
local function liberarGlobox(event)
  local phase=event.phase
  if phase=="began" then--Cuando el usuario pulsa el boton
     --Reproducimos el sonido de pulsar botón
    audio.play( tablaSonido["pulsarBtn"],{channel=2} )
     --Ponemos el boton de Liberar a Globox en modo pulsado
    btnGlobox.isVisible = false
    btnGloboxPulsado.isVisible = true
   
  elseif phase=="ended" then--Cuando el usuario levanta el dedo del boton
     --Guardamos el juego que hemos seleccionado 
    datos.juegoActual="liberarGlobox"
     --Guardamos los cambios de datos 
    datosString=json.encode(datos)
    soporte:guardarDatos(datosString)
    --Devolvemos el boton de Survival al estado de no pulsado
    btnGlobox.isVisible = true
    btnGloboxPulsado.isVisible = false
    --Comprobamos en que pantalla nos quedamos del juego "Liberar a Globox"
     if datos.nivelGlobox==1 then--Si estamos en el nivel 1
       --Lanzamos el nivel 1
      composer.gotoScene("liberarGlobox.nivelGlobox1")
    elseif datos.nivelGlobox==2 then--Si estamos en el nivel 2
      --Lanzamos el nivel 2
      composer.gotoScene("liberarGlobox.nivelGlobox2")
    elseif datos.nivelGlobox==3 then--Si estamos en el nivel 3
      --Lanzamos el nivel 3
      composer.gotoScene("liberarGlobox.nivelGlobox3")
    end
  end
    --Como ya hemos tratado el evento devolvemos true para que no siga propagandose
  return true 
end



-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view
    --Leemos los datos del usuario del archivo datos.txt
    datosString=soporte:leerDatos()
    --decodificamos el string para obtener la tabla datos con todos los datos del usuario y su partida
    datos=json.decode(datosString)
   
   --Creamos una tabla con los sonidos que se van a reproducir en la escena
     tablaSonido = { 
        musicaFondo=audio.loadStream("sonido/musicaMenuJuego.wav") ,
        pulsarBtn = audio.loadSound( "sonido/pulsarBtn.wav" )
     
    }
    --Creamos el fondo
    fondo=soporte:CrearObjeto("graficos/menuJuego/fondoMenuJuego.png",W,H,0,0,0,0)
    
    --Creamos el tablon
    tablon=soporte:CrearObjeto("graficos/menuJuego/tablon.png",236,236,0.5,0,centroX+10,30)
    tablon:scale(3,4)--Redimensionamos el tablon
    
    --Creamos los botones
    btnSurvival,btnSurvivalPulsado,grupoBtnSurvival, btnGlobox,btnGloboxPulsado,grupoBtnGlobox,btnMinimo,btnMinimoPulsado,grupoBtnMinimo, btnBarbara,btnBarbaraPulsado,grupoBtnBarbara,btnInicio,btnInicioPulsado,grupoBtnInicio=soporte:CrearBotonesMenuJuego(tablon.x-20,tablon.y+320)
    --Creamos los candados
    candadoMinimo=soporte:CrearObjeto("graficos/menuJuego/candado2.png",692,154,0.5,0.5,btnMinimo.x,btnMinimo.y)
    candadoBarbara=soporte:CrearObjeto("graficos/menuJuego/candado2.png",692,154,0.5,0.5,btnBarbara.x,btnBarbara.y)
    cierre1=soporte:CrearObjeto("graficos/menuJuego/cierre.png",78,88,0.5,0.5,candadoMinimo.x+20,candadoMinimo.y+40)
    cierre2=soporte:CrearObjeto("graficos/menuJuego/cierre.png",78,88,0.5,0.5,candadoBarbara.x+20,candadoBarbara.y+40)
   
   --Añadimos los elementos a la escena 
  sceneGroup:insert(fondo)
  sceneGroup:insert(tablon)
  sceneGroup:insert(grupoBtnSurvival)
  sceneGroup:insert(grupoBtnGlobox)
  sceneGroup:insert(grupoBtnMinimo)
  sceneGroup:insert(grupoBtnBarbara)
  sceneGroup:insert(grupoBtnInicio)
  sceneGroup:insert(candadoMinimo)
  sceneGroup:insert(candadoBarbara)
  sceneGroup:insert(cierre1)
  sceneGroup:insert(cierre2)
  
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
       --Añadimos los listener a los objetos 
      grupoBtnSurvival:addEventListener("touch",survival)--Listener del boton Survival que nos lleva al modo de Juego Survival
      grupoBtnGlobox:addEventListener("touch",liberarGlobox)--Listener del boton Liberar a Globox que nos lleva al modo de Juego que nos permite liberar a Globox
      grupoBtnInicio:addEventListener("touch",irInicio)--Listener del boton Inicio que nos permite regresar a la pantalla de incio
    
      
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
        
        --Eliminamos elistener del boton de jugar
        grupoBtnSurvival:removeEventListener("touch",survival)
        grupoBtnGlobox:removeEventListener("touch",liberarGlobox)
        grupoBtnInicio:removeEventListener("touch",irInicio)
             
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
    --Liberamos el resto de varibales utilizadas 
     --Liberamos los modulos cargados        
    package.loaded[composer]=nil
    package.loaded[soporte]=nil
    package.loaded[json]=nil
   soporte,json,composer=nil,nil,nil
 
   
   datosString=nil
    for n,m in pairs(datos) do
     datos[n]=nil
   end
   datos=nil

 --Variables de los objetos display
fondo,tablon,candadoMinimo,candadoBarbara,cierre1,cierre2=nil,nil,nil,nil,nil,nil
 --Variables de los botones
btnSurvival,btnSurvivalPulsado,btnGlobox,btnGloboxPulsado,btnMinimo,btnMinimoPulsado,btnBarbara,btnBarbaraPulsado,btnInicio,btnInicioPulsado=nil,nil,nil,nil,nil,nil,nil,nil,nil,nil
--Variables de los grupos
grupoBtnJugar,grupoBtnGlobox,grupoBtnMinimo,grupoBtnBarbara,grupoBtnInicio=nil,nil,nil,nil,nil


end
-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene