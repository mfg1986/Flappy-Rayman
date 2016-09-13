
--Cargamos la libreria "composer"
local composer=require("composer")
--Creamos una escena nueva
local scene=composer.newScene()
--Activamos el flag para que al cambiar de escena se elimine la vista de la misma
composer.recycleOnSceneChange=true
--Cargamos la librería "json"
local json=require("json")
--Cargamos el modulo de soporte
local soporte=require("soporte")


--Obtenemos el tamaño de la pantalla
local W=display.contentWidth
local H=display.contentHeight
local centroY=display.contentCenterY
local centroX=display.contentCenterX
local tipoDispositivo

--Declaramos variables necesarias
local personaje,fondo,cartel,cuerda1,cuerda2
local labelRecord,labelMarcador
local datos={}
local datosString
local grupoBtnInicio,grupoBtnJugar
local btnInicio,btnInicioPulsado,btnJugar,btnJugarPulsado
local pasosTimer,rayTimer
local tPrevious = system.getTimer()--Guardamos el instante inicial
local modoLento=false
local flagFinRecord=false
local tablaSonido={}


--Funcion listener del boton Inicio
local function irInicio(event)
   if flagFinRecord==true then--Si se terminaron las operaciones con el record y la puntuacion
    
    if event.phase=="began" then--Cuando el usuario pulsa el boton
      --Reproducimos el sonido de pulsar boton
       audio.play( tablaSonido["pulsarBtn"],{channel=2})
       --Mostramos el boton de inicio como pulsado
      btnInicio.isVisible=false
      btnInicioPulsado.isVisible=true
    elseif event.phase=="ended"then--Cuando el usuario levanta el dedo del boton
      --Regremos el boton de inicio a su apariencia normal
      btnInicio.isVisible=true
      btnInicioPulsado.isVisible=false
       --Guardamos los datos en el fichero de texto
      datosString=json.encode(datos)
      soporte:guardarDatos(datosString)
      
       --Paramos todos los canales de audio        
       audio.stop()
       --Liberamos la memoria del audio
        for s,v in pairs(tablaSonido) do
            audio.dispose(tablaSonido[s])
            tablaSonido[s]=nil
          end
          tablaSonido=nil
        --Lanzamos la escena de Inicio
        composer.gotoScene("inicio")
        --Desactivamos el flag
        flagFinRecord=false
      end
    end
--Como ya tratamos el evento devolvemos true para evitar su propagacion
  return true
end


--Funcion del boton Jugar para volver a intentarlo
local function reiniciar(event)
  if flagFinRecord==true then--Si se terminaron las operaciones con el record y la puntuacion
      if event.phase=="began" then--Cuando el usuario pulsa el boton
        --Reproducimos el sonido de pulsar el boton
         audio.play( tablaSonido["pulsarBtn"],{channel=2})
         --Cambiamos la apariencia del boton y lo ponemos en modo pulsado
        btnJugar.isVisible=false
        btnJugarPulsado.isVisible=true
      elseif event.phase=="ended" then--Cuando el usuario levanta el dedo del boton
        --Cambiamos de nuevo la apariencia del boton y lo ponemos en modo normal
        btnJugar.isVisible=true
        btnJugarPulsado.isVisible=false
        --Ponemos la puntuacion a 0
        datos.puntuacion=0
        --Ponemos el numero de vidas a 5
        datos.vidas=5
        --Guardamos los datos en el fichero de texto
        datosString=json.encode(datos)
        soporte:guardarDatos(datosString)
        --Paramos todos los canales de audio        
         audio.stop()
         --Liberamos la memoria del audio
          for s,v in pairs(tablaSonido) do
              audio.dispose(tablaSonido[s])
              tablaSonido[s]=nil
            end
        tablaSonido=nil
        --Lanzamos el juego el modo survival
        composer.gotoScene("survival.survival")
        --Desactivamos el flag
       flagFinRecord=false
       end
end
--Como ya tratamos el evento devolvemos true para evitar su propagacion
return true
end


--Funcion para mover el personaje por el fondo que responde al evento "enterFrame"
local function moverPersonaje(event)
 if personaje then --Si el personaje es distinto de nil
        --Obtenemos un incremento de tiempo como la resta del momento en que se produce el evento y el instante inicial guardado al inicio
      local tDelta = event.time - tPrevious
      tPrevious = event.time--Actualizamos el isntante inicial 
     
      local xOffset 
      if modoLento==false then--Si el personaje esta en modo rapido
        xOffset = ( 0.2 * tDelta )--Establecemos un deplazamiento mayor que en modo lento
      else--Si el personaje esta en modo lento
         xOffset = ( 0.05* tDelta )--Establecemos un desplazamiento menos que en modo rapido
      end
     
        if personaje.x<600  and personaje.sequence=="andandoDcha" then --Si el personaje esta andando hacia la derecha y no se topa con la pared de la casa
            personaje.x=personaje.x+xOffset--mover el personaje hacia la derecha
        elseif personaje.x>centroX-200 and personaje.sequence=="andandoIzqda" then --Si el personaje esta andando hacia la izquierda y no ha llegado a la pared
            personaje.x=personaje.x-xOffset--mover el personaje hacia la izquierda 
        end
 end
 --Como ya hemos tratado el evento devolvemos true para que no siga propagandose
  return true
end

--Funcion que muestra el cartel con las puntuaciones y realiza el recuento de las mismas
local function mostrarCartel()
 local puntuacion=0
 --Funcion que aumenta el contador de puntuacion del marcador
    local aumentarMarcador=function()
      if datos.puntuacion>0 then--Si la puntuacion ha sido mayor que 0
       puntuacion=puntuacion+1--Aumentamos la puntuacion
      end
       labelMarcador.text=tostring(puntuacion)--Actualizamos el marcador
       if puntuacion==datos.puntuacion then--Si hemos terminado con el contador de la puntuacion
               if datos.puntuacion>datos.puntuacionMax then--Si se supero el record
                   datos.puntuacionMax=datos.puntuacion--Actualizamos el record
                   labelRecord:scale(1.5,1.5)--Aumentamos de tamaño la estiqueta del record
                   labelRecord:setFillColor(255/255,15/255,80/255)--Le cambiamos de color
                   labelRecord.text=tostring(datos.puntuacionMax)--Actualizamos su valor
                   audio.play(tablaSonido["record"],{channel=6})--Reproducimos el sonido de traspaso de record
                   timer.performWithDelay(500,function()--Pasados 0.5 segundo
                       if labelRecord then--Si no nos salimos de la escena para cuando s ejecute el timer
                         labelRecord:scale(1,1)--Recuperamos el tamaño original del record
                         labelRecord:setFillColor(255/255,243/255,104/255)--Y su color original
                         flagFinRecord=true--Activamos el flag de fin de operaciones con la puntuacion
                       end  
                    end,1)
               elseif datos.puntuacion<=datos.puntuacionMax then--Si se igualo el record
                   flagFinRecord=true--Activamos el flag de fin de operaciones con la puntuacion
               end
         end
      end
  
   --Funcion que para arrancar el recuento de marcador
    local startMarcador=function()
 
          local repeticiones=1--Varible que almacenara la cantidad de veces que habra de aumentarse en 1 el marcador
          
          if datos.puntuacion>0 then--Si la puntuacion ha sido mayor que 0
             --flagFinRecord=false--Desactivamos el flag que indica que el recuento de puntuaciones termino
            repeticiones=datos.puntuacion--El numero de repeticiones será el numero de puntos
         end
         --Timer para aumentar el marcador, aumentara el marcador cada 0.1s el numero de veces que indique la variable repeteciones
          timer.performWithDelay(100,aumentarMarcador,repeticiones)--Vamos a aumentando el marcador de puntuacion hasta mostrar la obtenida por el jugador
      
    end
  
    --Desplazamos el cartel
    transition.to(cartel,{time=900, y=centroY-230})
    --Desplazamos el marcador
    transition.to(labelMarcador,{time=900, y=centroY-400})--200
    --Desplazamos el record
    transition.to(labelRecord,{time=900, y=centroY-200})--400
  --Desplazamos el boton de volver a jugar y cuando termine ejecutamos el recuento de puntuacion
    transition.to(grupoBtnJugar,{time=1000, y=centroY+200,onComplete=startMarcador})
  --Desplazamos las cuerdas que sujetan el boton de volver a jugar
    transition.to(cuerda1,{time=1000, y=centroY+149})
    transition.to(cuerda2,{time=1000, y=centroY+149})
end


--Funcion listener del sprite del personaje
local function personajeListener (event)
  local sprite=event.target
  
  if event.phase=="began" then--Si la secuencia que se esta reproduciendo comienza
    if sprite.sequence=="raybailando" then--Si la secuencia que comienza es "raybailando"
      if tablaSonido then--Si tablaSonido es distinta de nil-->Si estamos fuera de la escena para cuando se lance el timer
        audio.play( tablaSonido["rayBaile"],{channel=4,loops=3}) --Reproducimos la voz de rayman bailando 3 veces
      end
  elseif sprite.sequence=="muecaDcha" or sprite.sequence=="muecaIzqda" then--Si la secuencia que va a comenzar es ray haciendo una mueca a la derecha o a la izquierda
         --Creamos un timer que reproduzca el sonido de la mueca con un retardo de 0.5s
      timer.performWithDelay(500,function() 
          if tablaSonido then--Si tablaSonido es distinta de nil-->Si estamos fuera de la escena para cuando se lance el timer
            audio.play( tablaSonido["rayMueca"],{channel=3}) --Reproducimos el sonido
          end
          end,1)
    
     elseif sprite.sequence=="andandoDcha" or sprite.sequence=="andandoIzqda" then--Si la secuencia que a comenzar es ray andando hacia la izquierda o la derecha
         if modoLento==false then--Si esta modo rapido
            --Reproducimos el sonido de los pasos  cada menos tiempo
            pasosTimer=timer.performWithDelay(200,function()
                if tablaSonido then--Si tablaSonido es distinta de nil
                  audio.play(tablaSonido["pasos"],{channel=5})  --Reproducimos el sonido
                end 
                end,8)
               
         else--Si esta en modo lento
           --Reproducimos el sonido de los pasos cada mas tiempo
            pasosTimer=timer.performWithDelay(500,function()
                if tablaSonido then--Si tablaSonido es distinta de nil
                  audio.play(tablaSonido["pasos"],{channel=5}) --Reproducimos el sonido
                end
                end,-1)
          end
    
    end
 elseif event.phase=="ended" then--Si la secuencia que se esta reproduciendo se termina
  if sprite.sequence=="andandoDcha" then--Si la secuencia que termino es ray andando hacia la derecha
     --Paramos el timer de los pasos para que no se reproduzca mas el sonido de los mismos
     timer.cancel(pasosTimer)

     if modoLento==false then--Si esta en modo rapido
       soporte:cambiarSecuencia(sprite,"muecaDcha")--Cambiamos la secuencia para que ejecute una mueca
 
     else--Si esta en modo lento
       soporte:cambiarSecuencia(sprite,"paradoDcha")--Cambiamos la secuencia para que se quede parado mirando hacia la dcha
       sprite.timeScale=1--Cambiamos la velocidad de reproduccion a normal
        
     end
   
  elseif sprite.sequence=="muecaDcha" then--Si la secuencia que termino es ray haciendo una mueca hacia la derecha
     soporte:cambiarSecuencia(sprite,"andandoIzqda")--Cambiamos la secuencia para que comience a andar hacia la izquierda
    
  elseif sprite.sequence=="andandoIzqda" then--Si la secuencia que termino es ray andando hacia la izquierda
    timer.cancel(pasosTimer)--Paramos el timer que reproduce el sonido de los pasos
    soporte:cambiarSecuencia(sprite,"muecaIzqda")--Cambiamos la secuencia para que realice una mueca mirando mirando a la izqda
  
  elseif sprite.sequence=="muecaIzqda" then--Si la secuencia que termino es ray haciendo una mueca hacia la izqda
     soporte:cambiarSecuencia(sprite,"andandoDcha")--Cambiamos la secuencia para que comieze a andar hacia la dcha
    modoLento=true--Activamos el flag que indica que ray debe andar en modo lento
    sprite.timeScale=0.8--Cambiaos la velocidad del sprite para que vaya mas lento
  
  elseif sprite.sequence=="paradoDcha" then--Si la secuencia que termino es ray parado mirando hacia la dcha
    soporte:cambiarSecuencia(sprite,"raybailando")--Cambiamos la secuencia para que comience a bailar   
  
  elseif sprite.sequence=="raybailando" then --Si la secuencia que termino es ray bailando
    soporte:cambiarSecuencia(sprite,"andandoDcha")--Cambiamos la secuencia para que comience a andar hacia la dcha
    modoLento=false--Desactivamos el flag de andar en modo lento
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
     --Leemos los datos de la partida del jugador del archivo de texto datos.txt
    datosString=soporte:leerDatos()
    datos=json.decode(datosString)
   
   --Cargamos todos los sonidos de la escena
    tablaSonido = { 
              musicaFondo=audio.loadStream("sonido/musicaGameOverSurvival.wav"),
              pulsarBtn = audio.loadSound( "sonido/pulsarBtn.wav" ),
              rayMueca= audio.loadSound( "sonido/rayMueca.wav" ),
              rayBaile= audio.loadSound( "sonido/rayBaile.wav" ),
              pasos=audio.loadSound("sonido/pasos.wav"),
              record=audio.loadSound("sonido/record.wav")
             }

    --Obtenemos el ancho que debe tener la imagen de fondo y la posicion en Y que debe tener la animacion de rayman segun el tipo de dispositivo 
    local ancho,posY
    if tipoDispositivo=="ancho" then
      ancho=W*1.5--Aumentamos el ancho de la imagen de fondo para que rayman no se salga de la casa
      posY=centroY+300
    else--Si el tipo de dispositivo es alto la imagen de fondo se queda alargada y la casa se estrecha por lo que es necesario aumentar el ancho de la imagen de fondo (con respecto a dispositivos anchos)  para que rayman no se salga de la casa
      ancho=W*1.6
      posY=centroY+380
    end
     --Creamos la imagen de fondo
      fondo=soporte:CrearObjeto("graficos/gameOver/gameoverFondo.png",ancho,H,0,0,0,0)
    
    --Creamos los botones de Inicio y Volver a Jugar al modo Survival   
     btnJugar,btnJugarPulsado,grupoBtnJugar,cuerda1,cuerda2,btnInicio,btnInicioPulsado,grupoBtnInicio= soporte:CrearBotonesGameOver(W,H)
   

    --Creamos el cartel que mostrara la puntuacion obtenida y el record
    cartel=soporte:CrearObjeto("graficos/gameOver/cartel.png",648,592,0.5,0.5,centroX,-500)
    cartel:scale(1.3,1.3)--Redimensionamos su tamaño
    
    --Creamos la animacion de rayman
    --personaje=CrearAnimacionRay()
    personaje=soporte:CrearAnimacionRayGameOver(centroX-200,posY)
    
   
     --Creamos la puntuacion obtenida
     labelMarcador=display.newText( 0, centroX+170, -700, "font/Rayman_Adventures_TTF.ttf", 70 )
     labelMarcador:setFillColor(1,1,1)--Establecemos el color de la puntuacion
   
     --Creamos el record de puntuacion
     labelRecord=display.newText( datos.puntuacionMax, centroX+40, -500, "font/Rayman_Adventures_TTF.ttf", 100 )
     labelRecord:setFillColor(255/255,243/255,104/255)--Establecemos el color del record
     
     
     --Añadimos los elementos a la escena
      sceneGroup:insert(fondo)
      sceneGroup:insert(grupoBtnJugar)
      sceneGroup:insert(grupoBtnInicio)
      sceneGroup:insert(cuerda1)
      sceneGroup:insert(cuerda2)
      sceneGroup:insert( cartel)
      sceneGroup:insert(personaje)
      sceneGroup:insert(labelMarcador)
      sceneGroup:insert( labelRecord)
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
      --Arrancamos el sprite del personaje
      personaje:play()
      --Desplazamos el cartel  hacia abajo para hacerlo visible (el cartel contiene las puntuaciones y a su vez despliega el boton de volver a jugar)
      mostrarCartel()
      
       --Añadimos los listener 
      Runtime:addEventListener("enterFrame",moverPersonaje)--Listener para mover el personaje por el fondo
      personaje:addEventListener("sprite",personajeListener)--Listener para controlar las secuencias reproducidas por el personaje
      grupoBtnInicio:addEventListener("touch",irInicio)--Listener para el boton que nos dirige a la escena de inicio
      grupoBtnJugar:addEventListener("touch",reiniciar)--Listener para el boton que nos dirige al
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
     
    
     --Paramos la animacion del personaje
     personaje:pause()
   
     --Eliminamos los Listener
     Runtime:removeEventListener("enterFrame",moverPersonaje)
     personaje:removeEventListener("sprite",personajeListener)
     grupoBtnInicio:removeEventListener("touch",irInicio)
     grupoBtnJugar:removeEventListener("touch",reiniciar)
     
     if pasosTimer then
     timer.cancel(pasosTimer)
    end
     
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
    
   
   --Liberamos los modulos cargados        
    package.loaded[composer]=nil
    package.loaded[json]=nil
    package.loaded[soporte]=nil
    soporte,json,composer=nil,nil,nil--Ponemos sus variables a nil
   --Variables para la gestion del archivo de datos
   for n,m in pairs(datos) do
     datos[n]=nil
   end
   datos=nil
--Variables de los objetos display
personaje,fondo,cartel,cuerda1,cuerda2,labelRecord,labelMarcador=nil,nil,nil,nil,nil
--Variables de los grupos
grupoBtnInicio,grupoBtnJugar=nil,nil
--Variables de los botones
btnInicio,btnInicioPulsado,btnJugar,btnJugarPulsado=nil,nil,nil,nil
--Variables de los timer
pasosTimer,rayTimer=nil,nil


end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene