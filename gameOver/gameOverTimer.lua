
--Cargamos el modulo de soporte
local soporte=require("soporte")
--Cargamos la librería "json"
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
local centroY=display.contentCenterY
local centroX=display.contentCenterX
--Declaramos variable necesarias
local datosString
local datos={}
local fondo
local grupoBtn,datosBtn,btnReintentar,btnReintentarPulsado
local contadorLabel,contadorTimer
local contador=10
local tablaSonido={}

--Funcion para reducir el valor de la cuenta atras del Game Over
local function reducirContador()
  --Reproducimos el sonido del contador
   audio.play( tablaSonido["contador"],{channel=3})
   --Decrementamos el contador 
  contador=contador-1
  --Ponemos el valor del contador en la etiqueta de la cuenta atras de la escena
  contadorLabel.text=contador
  if contador==-1 then--Cuando el contador marque -1
    --Lanzamos la escena de Inicio
    composer.gotoScene("inicio")
  end
end

--Funcion listener del boton de volver a jugar
local function reintentar(event)
  local phase=event.phase
  
  if phase=="began" then--Si el usuario presiona el boton
    --Reproducimos el sonido de pulsar el boton
    audio.play( tablaSonido["pulsarBtn"],{channel=2})
    --Mostramos el boton con aspecto de pulsado
    btnReintentar.isVisible = false
    btnReintentarPulsado.isVisible = true
   
  elseif phase=="ended" then--Cuando el usuario levanta el dedo del boton
   --Mostramos el boton con su apariencia normal
   btnReintentar.isVisible = true
   btnReintentarPulsado.isVisible = false
   --Si el nivel juego seleccionado es "liberar a Globox"-->De momento solo hay implementado este juego, el desarrollo de "liberar al Gran minino y "liberar a Barbara" se deja para futuras expansiones
   if datos.juegoActual=="liberarGlobox" then
     if datos.nivelGlobox==1 then--Si el usuario murio en el nivel 1 del juego 
      composer.gotoScene("liberarGlobox.nivelGlobox1")--Lanzamos el nivel 1 del juego
     elseif datos.nivelGlobox==2 then--Si el usuario murio en el nivel 2 del juego 
      composer.gotoScene("liberarGlobox.nivelGlobox2")--Lanzamos el nivel 2 del juego
     elseif datos.nivelGlobox==3 then--Si el usuario murio en el nivel 3 del juego 
      composer.gotoScene("liberarGlobox.nivelGlobox3") --lanzamos el nivel 3
    end
  end
end
--Como ya hemos tratado el evento devolvemos true para que no siga propagandose
  return true 

end
-- "scene:create()"
function scene:create( event )
   
    local sceneGroup = self.view
    --Leemos los datos de la partida del jugador del archivo de texto datos.txt
        datosString=soporte:leerDatos()
        datos=json.decode(datosString)
     --Cargamos todos los sonidos de la escena
     tablaSonido = { 
            musicaFondo=audio.loadStream("sonido/musicaGameOverTimer.wav"),
              pulsarBtn = audio.loadSound( "sonido/pulsarBtn.wav" ),
              contador=audio.loadSound( "sonido/contador.wav" ),}
    
    --Creamos el fondo 
     fondo=soporte:CrearObjeto("graficos/gameOver/fondoGameOverTimer.png",W,H,0,0,0,0)
     
     --Creamos el boton de reintentar 
     grupoBtn=display.newGroup()
    datosBtn=soporte:RellenarDatosBtn("graficos/gameOver/btnReintentar.png","graficos/gameOver/btnReintentarPulsado.png",nil,97,73,0.5,1,centroX-250,centroY+400,2.5,2.5,1)
    btnReintentar,btnReintentarPulsado=soporte:CrearBoton(datosBtn,grupoBtn)
   
    
    --Creamos el contador de la cuenta atrás para el game Over
    contadorLabel=display.newText( contador, centroX+250, centroY+400, "font/Rayman_Adventures_TTF.ttf", 200 )
    contadorLabel:setFillColor(163/255,8/255,88/255)--Establecemos el color del contador
    
  --Añadimos los elementos a la escena
    sceneGroup:insert(fondo)
    sceneGroup:insert(grupoBtn)
    sceneGroup:insert(contadorLabel)
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
        
      --Creamos un Timer con el contador de la cuenta atras
         contadorTimer=timer.performWithDelay(1000,reducirContador,11)
         
      --Añadimos los listeners  
      grupoBtn:addEventListener("touch",reintentar)--Listener del boton reitentar
     
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
       
       --Eliminamos los listerner
       grupoBtn:removeEventListener("touch",reintentar)
      
      --Cancelamos el timer del contador
       timer.cancel(contadorTimer)
    
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
    package.loaded[json]=nil
    soporte,composer,json=nil,nil,nil--Ponemos sus variables a nil

--Variables para la gestion del archivo de datos
   for n,m in pairs(datos) do
     datos[n]=nil
   end
   datos=nil
--Variables de los objetos display
fondo,contadorLabel=nil,nil
--Variable que almacena los datos del boton de jugar
for t=#datosBtn,1,-1 do
  datosBtn[t]=nil
end
datosBtn=nil
--Variables del boton jugar y su grupo
btnReintentar,btnReintentarPulsado,grupoBtn=nil,nil,nil
--Variable del timer del contador
contadorTimer=nil
  
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene