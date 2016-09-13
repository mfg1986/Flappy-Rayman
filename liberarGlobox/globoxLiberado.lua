--require('mobdebug').start()
--Cargamos el modulo de soporte
local soporte=require("soporte")
--Cargamos la libreria "json"
local json=require("json")
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
--Declaramos variables
local datos={}
local datosString
local rayman,globox,choque,cartelFinal
local posYrayman,posYglobox
local fondo={}
local datosBtnOk={}
local btnOk,btnOkPulsado,grupoBtn
local pasosTimerRay, pasosTimerGlobox
local flagCartel=false
local flagAndar=false
local flagGolpe=false
local globoxAndando=false
local tPrevious = system.getTimer()--Obtenemos el instante incial de tiempo
local tablaSonido={}

--Funcion para mostrar el cartel informativo de la liberacion de globox y el boton para aceptar
local function moverCartelGlobox()
  --Mostramos el cartel informativo
  transition.to(cartelFinal,{time=900, y=0})
  --Mostramos el boton de aceptar
  for i=1,grupoBtn.numChildren do
   transition.to(grupoBtn[i],{time=900, y=cartelFinal.contentHeight-80})
  end
end
--Funcion listener del boton Ok del cartel afirmativo
local function IrSeleccionPersonaje(event)
   local phase=event.phase
    if phase=="began" then--Cuando el usuario pulsa el boton
       --Reproducimos el sonido de pulsar el boton
        audio.play( tablaSonido["pulsarBtn"],{channel=3})
      --Mostramos el boton en modo pulsado
        btnOk.isVisible = false
        btnOkPulsado.isVisible = true

    elseif phase=="ended" then--Cuando el usuario levanta el dedo del boton
     --Mostramos el boton en su estado normal
     btnOk.isVisible = true
     btnOkPulsado.isVisible = false
     --Cambiamos el estado de personaje de Globox de "preso" a "libre" para poder seleccionarlo en el modo survival
     datos.estadoGlobox="libre"
     --Guardamos los cambios en el archivo de datos
     datosString=json.encode(datos)
     soporte:guardarDatos(datosString)
     --Lanzamos la escena que nos permite seleccionar personaje
     composer.gotoScene("seleccionPersonaje")
  end
   --Como ya hemos tratado el evento devolvemos true para que no siga propagandose
  return true 
end
--Funcion para mover al personaje de rayman que responde al evento "enterFrame"
local function moverRaymanGlobox(event)
    	--Obtenemos un incremento de tiempo como la resta del momento en que se produce el evento y el instante inicial guardado al inicio
	local tDelta = event.time - tPrevious
	tPrevious = event.time--Actualizamos el isntante inicial 
 --Obtenemos el desplazamiento  en el eje x
	local xOffset = ( 0.2 * tDelta )

  if flagAndar==true then--Si el flag de andar esta activado 
   if flagGolpe==false then--Si rayman todavia no ha roto la jaula
     rayman.x=rayman.x+xOffset--movemos a rayman hacia la derecha
     --Si rayman llego a la jaula de globox y no la rompio todavia
      if(rayman.x>=globox.x-globox.contentWidth) and flagGolpe==false then
        --Desactivamos el flag de andar para parar a rayman
        flagAndar=false
      end
   end
    if flagGolpe==true then--Si ya realizo el golpe a la jaula
      for i=1,2 do--movemos las dos imagen concatenadas que forman el fondo
        fondo[i].x=fondo[i].x-xOffset--movemos el fondo hacia la izquierda
  
        if fondo[2].x<=0 then--Si la ultima de las imagenes llego al margen izquierdo de la pantalla
          fondo[2].x=0--fijamos la imagen al margen izquierdo
        
          if rayman.x>=W  then--Si rayman se salio de la pantalla
            if flagCartel==false then--Si el cartel no se desplego
              flagCartel=moverCartelGlobox()--Desplegamos el cartel
              --Cancelamos los timer que reproducen los sonidos de pasos de rayman y globox
              timer.cancel(pasosTimerGlobox)
              timer.cancel(pasosTimerRay)
           end
          else --Si rayman todavia sigue en pantalla
            rayman.x=rayman.x+xOffset*0.5--movemos a rayman hacia la derecha
          if globoxAndando==true then--Si el flag de que globox esta andando esta activado
            globox.x=globox.x+xOffset*0.5--movemos a globox hacia la derecha
           end
          end
        end
      end
    end
   
  end  
  --Como ya hemos tratado el evento devolvemos true para que no siga propagandose
  return true
  end

--Funcion listener del sprite de rayman
local function raymanListener (event)
  local sprite=event.target
 if event.phase=="ended" then
    if sprite.sequence=="aterrizando" then--Si la secuencia que termino es ray aterrizando
      --Reproducimos la llamada de auxilio de globox    
      audio.play(tablaSonido["vozGlobox"],{channel=7})
      --Creamos un timer para reproducir el sonido de los pasos de rayman
      pasosTimerRay=timer.performWithDelay(200,function()audio.play(tablaSonido["pasos"],{channel=4})end,-1) 
      --Cambiamos la secuencia para que rayman empiece a andar
      soporte:cambiarSecuencia(rayman,"andando")
      flagAndar=true--Activamos el flag para indicar que rayman va a ponerse a andar
      
    elseif sprite.sequence=="andando" then--Si la secuencia que termino es ray andando
      if flagGolpe==false then--Si todavia no golpero la jaula de globox
        timer.cancel(pasosTimerRay)--Cancelamos el timer que reproduce el sonido de los pasos de rayman
        --Pausamos la llamada de auxilio de globox
        audio.pause(7)
        soporte:cambiarSecuencia(rayman,"golpeando")--Cambiamos la secuencia para que rayman golpee la jaula
        --Creamos un timer para que se libere a globox justo cuando el puño de en la jaula-->1.4s despues de comenzar la secuencia de rayman golpeando
        timer.performWithDelay(1400,function()
            audio.play(tablaSonido["golpe"],{channel=2,duration=100})--Reproducimos el sonido del golpe
            choque.isVisible=true--Hacemos visible la imagen del choque
            timer.performWithDelay(500,function()choque.isVisible=false end,1)--0.5s despues ocultamos la imagen de choque
            soporte:cambiarSecuencia(globox,"globoxAndando")--Cambiamos la secuencia de globox para que este se ponga a caminar
            globox:scale(0.55,0.55)--Redimensionamos su tamaño
            globox.y=globox.y+10--Lo recolocamos en pantalla
            globoxAndando=true--Activamos el flag que indica que globox esta andando
          end,1)
        --6s despues de que comience a andar hacemos que globox hable
        timer.performWithDelay(6000,function()audio.resume(7)end,1)
        --1s despues de que hable paramos el canal de audio de la voz de globox
        timer.performWithDelay(7000,function()audio.stop(7)end,1)
      else--Si rayman ya golpero la jaula y la secuencia que termino era la de rayman andando
         soporte:cambiarSecuencia(rayman,"andando")--Volvemos a cargar la secuencia de rayman andando
      end
    
  elseif sprite.sequence=="golpeando" then--Si la secuencia que termino era rayman golpeando la jaula
    --Hacemos que suenen los pasos de ambos personajes
      pasosTimerRay=timer.performWithDelay(200,function()audio.play(tablaSonido["pasos"],{channel=4})end,-1) 
      pasosTimerGlobox=timer.performWithDelay(300,function()audio.play(tablaSonido["pasos"],{channel=5})end,-1) 
      soporte:cambiarSecuencia(rayman,"andando")--Cambiamos la secuencia para que rayman comience a andar
      flagAndar=true--Activamos el flag que indica que rayman va a empezar a andar
      flagGolpe=true--Activamos el flag que indica que ya golpeo la jaula
    end
  end
  --Como ya hemos tratado el evento devolvemos true para que no siga propagandose
  return true
 end

-- "scene:create()"
function scene:create( event )
   
    local sceneGroup = self.view
    --Registramos el tipo de dispositivo en el que se esta ejecutando el juego
    tipoDispositivo=soporte:TipoDispositivo(W,H)
    --Leemos los datos del archivo de datos
   datosString=soporte:leerDatos()
   datos=json.decode(datosString)
   --Cargamos todos los sonidos de la escena
 tablaSonido = { 
            musicaFondo=audio.loadStream("sonido/musicaGloboxLiberado.wav"),
            golpe=audio.loadSound( "sonido/golpe.wav" ),
            pulsarBtn = audio.loadSound( "sonido/pulsarBtn.wav" ),
            pasos=audio.loadSound("sonido/pasos.wav"),
            vozGlobox=audio.loadSound("sonido/vocesElectroons.wav")
          }

    --Creamos fondo y lo insertamos en la escena
  for i=1,2 do
     fondo[i]=soporte:CrearObjeto("graficos/liberarGlobox/globoxLiberado/fondoGloboxLiberado ("..i..").png",W,H,0,0,W*(i-1),0)
     sceneGroup:insert(fondo[i])
    end
       
    --En funcion del tipo de dispositivo colocamos en una posicion u otra el sprite de rayman
    if tipoDispositivo=="alto" then 
      posYrayman=centroY-30
      posYglobox=centroY+80
  else  
    posYrayman=centroY-60 
    posYglobox=centroY+40
  end
  --Creamos la animacion de globox
    globox=soporte:CrearAnimacionGlobox(centroX+270,posYglobox)
   --Creamos la animacion de rayman 
    rayman=soporte:CrearAnimacionRay(0,posYrayman)
   
   --Creamos el choque
   choque=soporte:CrearObjeto("graficos/personajes/choque.png",50,50,0,0.5,globox.x-60,globox.y)
   choque:scale(5,5)--Redimensionamos el choque
   choque.isVisible=false--Ocultamos el choque
  --Creamos el cartel informativo del final
   cartelFinal=soporte:CrearObjeto("graficos/liberarGlobox/globoxLiberado/cartelGloboxLiberado.png",700,700,0.5,0,centroX,-700)

   --Creamos el boton de Ok del cartel informativo que aparece cuando liberamos a globox
   grupoBtn=display.newGroup()--Creamos un grupo para el boton de Ok
    --Rellenamos los datos del boton, en estado normal y pulsado
   datosBtnOk=soporte:RellenarDatosBtn("graficos/liberarGlobox/globoxLiberado/btnOk.png","graficos/liberarGlobox/globoxLiberado/btnOkPulsado.png",nil,256,100,0.5,0,centroX,-100,1,1,1)
     --Creamos los botones en estado normal y pulsado y los añadimos al grupo creado
   btnOk,btnOkPulsado=soporte:CrearBoton(datosBtnOk,grupoBtn)
   
   
   --Insertamos los elementos en la escena
   sceneGroup:insert(globox)
   sceneGroup:insert(rayman)
   sceneGroup:insert(choque)
   sceneGroup:insert(cartelFinal)
   sceneGroup:insert(grupoBtn)
   
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
      
      --Reproducimos la musica de fondo  con un volumen al 50%
       audio.setVolume(0.5,{channel=1})
       audio.play(tablaSonido["musicaFondo"],{channel=1,loops=-1})
     
      --Arrancamos las animaciones de los personajes
      globox:play()
      rayman:play()
       --Añadimos los listerners
      Runtime:addEventListener("enterFrame",moverRaymanGlobox)--Listerner para mover a rayman y globox
      rayman:addEventListener("sprite",raymanListener)--Listener del sprite del personaje de rayman
      grupoBtn:addEventListener("touch",IrSeleccionPersonaje)--Listener del boton de Ok del cartel informativo
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
    --Paramos las animaciones de los personajes
      globox:pause()
      rayman:pause()
    
     --Eliminamos los listeners
      Runtime:removeEventListener("enterFrame",moverRaymanGlobox)
      rayman:removeEventListener("sprite",raymanListener)
      grupoBtn:removeEventListener("touch",IrSeleccionPersonaje)


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
   soporte,json,composer=nil,nil,nil--Ponemos sus variables a nil

   --Variables para la gestion del archivo de datos
   for n,m in pairs(datos) do
     datos[n]=nil
   end
   datos=nil
   --Variables de los objetos display
    rayman,globox,choque,cartelFinal=nil,nil,nil,nil
   --Variable del fondo
   for i=#fondo,1,-1 do
     fondo[i]=nil
    end
    fondo=nil
   --Varible que almacena los datos del boton de Ok
   for n=#datosBtnOk,1,-1 do
     datosBtnOk[n]=nil
    end
    datosBtnOk=nil
    --Variables del boton Ok y su grupo
    btnOk,btnOkPulsado,grupoBtn=nil,nil,nil
   --Variables de los timer que reproducen los pasos
   pasosTimerRay, pasosTimerGlobox=nil,nil
   
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene