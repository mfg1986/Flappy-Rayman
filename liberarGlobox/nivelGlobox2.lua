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

--Cargamos el motor de fisica
local physics=require("physics")
physics.start()--Arrancamos el motor de fisica
physics.setGravity(0,100)--Establecemos el valor de la gravedad


--Obtenemos el tamaño de la pantalla
local W=display.contentWidth
local H=display.contentHeight
local centroY=display.contentCenterY
local centroX=display.contentCenterX
--Declaramos variables
local math_random=math.random--Optimizacion
local tPrevious = system.getTimer()--Guardamos el instante inicial
local personaje, instrucciones,vida,choque,cara
local salidaArriba,salidaAbajo
local fondoFinal={}
local fondo={}
local veces=0
local factorVelocidad=1
local datos={}
local datosString
local flag=false
local fin=false
local juegoEmpezado=false
local flagAbrirObs=false
local flagPausa=false
local flagTimerCancel=false
local obstaculo=1
local grupoObstaculos
local anyadirObstaculoTimer
local tablaSonido={}
local grupoBtn,btnPlay,btnPausa
local grupoBtnFrena, btnFrena,btnFrenaPulsado
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


--Funcion para guardar los datos y lanzar la escena de Inicio de Nivel 3
local function siguienteNivel()
  --Guardamos el nuevo nivel en el que se encuentra el usuario
    datos.nivelGlobox=3
    --Restablecemos el contador de vidas
    datos.vidas=5
    --Guardamos los cambios en el archivo de datos
    datosString=json.encode(datos)
    soporte:guardarDatos(datosString)
    --Lanzamos la escena que inicia el nivel 3
    composer.gotoScene("liberarGlobox.inicioNivelGlobox3")
end


--Funcion para mover horizontalmente obstaculos 
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
--Funcion para mover verticamente obstaculos
local function MoverObstaculoY(yOffset) 
  local obsarriba,obsabajo
  for n=grupoObstaculos.numChildren,1,-2 do--Recorremos el grupo de obstaculos
   if grupoObstaculos[n].pos=="arriba" then --Si el obstaculo es un obstaculo colocado arriba
      obsarriba=grupoObstaculos[n]--Guardamos el obstaculo actual como el obstaculo de arriba
      obsabajo=grupoObstaculos[n-1]--Guardamos el obstaculo anterior como su correspondiente obstaculo de abajo
    else--Si es un obstaculo colocado abaho
       obsarriba=grupoObstaculos[n-1]--Guardamos el obstaculo anterior como el obstaculo de arriba
       obsabajo=grupoObstaculos[n]--Guardamos el obstaculo actual como el obstaculo de abajo
    end
  
    if obsarriba.movimientoY==true and  obsabajo.movimientoY==true then--Si el obstaculo de arriba y el obstaculo de abajo tienen movimoento vertical
      if obsabajo.y<=obsarriba.y then--Si los obstaculos se tocaron
        audio.play(tablaSonido["choquePiedra"],{channel=5})--Reproducimos el sonido del choque de obstaculos
        flagAbrirObs=true--Activamos el flag que indica que debemos empezar a separar el obstaculo de arriba y de abajo
      
      else --Si los obstaculos no se chocaron
        if obsarriba.y<=100 and obsabajo.y>=H-100 then--Si los obstaculos volvieron a sus posicion iniciales
          flagAbrirObs=false--Desactivamos el flag que indica que deben separarse los obstaculos
        end
      end
      
      if  flagAbrirObs==false then--Si los obstaculos deben juntarse
         obsarriba.y=obsarriba.y+yOffset--Movemos el obstaculo de arriba hacia abajo
         obsabajo.y=obsabajo.y-yOffset--Movemos el obstaculo de abajo hacia arriba
      elseif flagAbrirObs==true then--Si lo obstaculos deben separarse
      
        obsarriba.y=obsarriba.y-yOffset--Movemos el obstaculo de arriba hacia arriba
        obsabajo.y=obsabajo.y+yOffset--Movemos el obstaculo de abajo hacia abajo
 
      end
    end
  end

end

--Funcion para ejecutar la primera fase del fondo: Constara de dos imagenes que se mostraran de forma ciclica, cada vez que se cumpla un ciclo se aumentara el valor de la varibale veces-->1 ciclo es que se muestre la imagen 1 y la imagen 2
local function PrimeraFaseFondo(xOffset)
   for i=1,2 do
      fondo[i].x=fondo[i].x-xOffset*factorVelocidad--Desplazamos las imagenes del fondo hacia la izquierda
      if fondo[i].x<=-W then--Si la imagen se salio completamente de la pantalla
        fondo[i].x=fondo[i].x+2*W--La colocamos en cola en el margen derecho para volver a mostrarla
        if i==1 then--Si la imagen que se salio completamente es la primera
          veces=veces+1--Aumentamos el contador
        end
      end 
    end
    return veces--Devolvemos el numero de veces que se ejecuto el ciclo
  end
  --Funcion para ejecutar la segunda fase del fondo: Constara de 3 imagenes que se mostraran de forma sucesiva una sola vez cada una
local function SegundaFaseFondo(xOffset)
    for j=1,3 do
  
     fondoFinal[j].x=fondoFinal[j].x-xOffset*factorVelocidad--movemos la imagenes hacia la izquierda

      --Si se comienza a ver la ultima imagen del fondo pero no se muestra todavia por completo
      if fondoFinal[3].x<=W and fin==false then
        --hacemos aparacer la puerta de salida de nivel de forma lenta
        salidaAbajo.x=salidaAbajo.x-xOffset*0.09
        salidaArriba.x=salidaArriba.x-xOffset*0.09
      end
      if fondoFinal[3].x<=0 then--Si se coloco completamente en pantalla la ultima imagen del fondo paramos el desplazamiento
        fondoFinal[3].x=0
        fin=true--Activamos el flag de fin del fondo   
      end
      if fondoFinal[2].x<=0 then--Si la penultima imagen del fondo ya ha pasado desactivamos el timer de añadir obstaculos
        timer.cancel(anyadirObstaculoTimer)
        flagTimerCancel=true
      end
      
    end
  return fin--Devolvemos la variable que indica que se llego al final del nivel
  end
    
--Funcion para gestionar la transicion entre la primera fase del fondo y la segunda: 
local function TransicionSegundoFondo(xOffset)
  if fondo then--Si la variable fondo es distinta de nil
        if fondo[2].x>=-W  then--Si la segunda imagen del fondo 1 permanece todavia en pantalla
        fondo[2].x=fondo[2].x-xOffset*factorVelocidad--Desplazamos la segunda imagen hacia la izquierda 
        fondo[1].isVisible=false--Ocultamos la primera imagen del fondo
      else--Si la segunda imagen del primero tipo de fondo se ha dejado de ver en pantalla-->Se ha completado la transicion entre los tipo de fondo
          for n=#fondo,1,-1 do--Eliminamos el objeto display del primer fondo
            fondo[n]:removeSelf()
          end
          fondo=nil--Ponemos a nil la variable fondo
      end
    end
end
--Funcion para gestionar el uso de los dos tipos de fondo
local function MoverFondo(xOffset)
  if veces<=3 then--Si el primer se ha ejecutado menos de 3 veces
     veces=PrimeraFaseFondo(xOffset)--Ejecutamos el primer tipo de fondo
  
  else--Si el primer fondo se ejecuto 4 o mas veces
    TransicionSegundoFondo(xOffset)--Realizamos la transicion del fondo 1 al fondo 2
    fin=SegundaFaseFondo(xOffset)--Ejecutamos el segundo tipo de fondo
    
    if fin==true then--Si se llego a la ultima frame del fondo 2 activamos el desplazamiento del personaje en x para que pueda alcanzar la salida
       personaje.x=personaje.x+xOffset*0.8--Movemos al personaje hacia la derecha
      end
  end
  return fin--Devolvemos la variable que indica que se termino el nivel
  
end

--Funcion para generar el movimiento del fondo y los obstaculos mediante el evento "enterFrame"
local function mover(event)
  		--Obtenemos un incremento de tiempo como la resta del momento en que se produce el evento y el instante inicial guardado al inicio
	local tDelta = event.time - tPrevious
  tPrevious = event.time--Actualizamos el isntante inicial 
  --Creamos los desplazamientos horizontales del fondo y de los obstaculos
	local xOffsetFondo = ( 0.3 * tDelta )
  local xOffsetObstaculo = ( 0.4 * tDelta )
 --Creamos el desplazamiento vertical de los obstaculos
  local yOffsetObstaculo = ( 0.5* tDelta )
  
    if juegoEmpezado==true then--Si hemos comenzado a jugar
      if flagPausa==false then--Si el juego no esta pausado
          fin=MoverFondo(xOffsetFondo)--Movemos el fondo
          --Si el personaje se sale de la pantalla por abajo, por arriba o por la izquierda de la pantalla
           if (personaje.y>H) or (personaje.y<-personaje.contentWidth*0.5) or (personaje.x<=-personaje.contentWidth) then
             --Reprducimos el sonido de muerte y una vez terminado lanzamos la escena del game over con la cuenta atras
            audio.play(tablaSonido["muerte"],{channel=4,onComplete=irGameOverTimer})
           end
          if fin==false then--Si el fondo no ha terminado seguimos moviendo los obstaculos
            MoverObstaculoX(xOffsetObstaculo)--Movemos los obstaculos horizontalmente
            MoverObstaculoY(yOffsetObstaculo)--Movemos los obstaculos verticalmente
             
          else--Si el fondo termino y se llego al final del nivel
            if personaje.x>=W then--Si el personaje se sale de la pantalla por la derecha-->Supero la puerta de salida
              --Guardamos los datos y lanzamos la escena de Inicio de Nivel 3
              siguienteNivel()
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
      --Si timer de los obstaculos no se cancelo
       if flagTimerCancel==false then 
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
    --Si timer de los obstaculos no se cancelo
    if flagTimerCancel==false then 
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
  local obstaculo1Arriba , obstaculo1Abajo,obstaculo2Arriba,obstaculo2Abajo={},{},{},{}
  local obstaculos1,obstaculos2={},{}
  --Obtenemos la altura de forma aleatoria 
  local altura=math_random(centroY-200,centroY+200)
  --Creamos los obstaculos 
if obstaculo==1 then --Si el obstaculo que se desea crear es estatico verticalmente--Tipo 1 
      --Rellenamos los datos necesarios para crear obstaculo de arriba
      obstaculo1Arriba=soporte:RellenarDatosObs("graficos/liberarGlobox/nivel2/obs1arriba.png",300,1000,0.5,1,W+150,altura-190,"arriba",false)
        --Rellenamos los datos necesarios para crear el obstaculo de abajo
      obstaculo1Abajo=soporte:RellenarDatosObs("graficos/liberarGlobox/nivel2/obs1abajo.png",300,1000,0.5,0,W+150,altura+190,"abajo",false)
    --Creamos los obstaculos de tipo 1, los añadimos al motor de fisica y al grupo de obstaculos
    obstaculos1=soporte:crearObstaculoMultiple(obstaculo1Arriba,obstaculo1Abajo,grupoObstaculos)
     for n=1,2 do
       physics.addBody(obstaculos1[n],"static",{density=0.1,friction=0.2,bounce=0})
    end
    --Cambiamos el tipo de obstaculo a crear en la siguiente ejecucion
    obstaculo=2
else--Si el obstaculo que se desea crear tiene movimiento vertical-->Tipo 2
   --Rellenamos los datos necesarios para crear obstaculo de arriba
    obstaculo2Arriba=soporte:RellenarDatosObs("graficos/liberarGlobox/nivel2/obs2arriba.png",200,1000,0.5,1,W+100,altura-160,"arriba",true)
     --Rellenamos los datos necesarios para crear obstaculo de abajo
    obstaculo2Abajo=soporte:RellenarDatosObs("graficos/liberarGlobox/nivel2/obs2abajo.png",200,1000,0.5,0,W+100,altura+160,"abajo",true)
   --Creamos los obstaculos de tipo 2, los añadimos al motor de fisica y al grupo de obstaculos
    obstaculos2=soporte:crearObstaculoMultiple(obstaculo2Arriba,obstaculo2Abajo,grupoObstaculos)
    for m=1,2 do
     physics.addBody(obstaculos2[m],"static",{density=0.1,friction=0.2,bounce=0})
    end
   --Cambiamos el tipo de obstaculo a crear en la siguiente ejecucion
   obstaculo=1
  end
  
end
--Funcion listener para frenar el fondo
local function Frenar(event)
  if flagPausa==false then--Si el juego no esta pausado
    if event.phase=="began" then--Cuando el usuario presiona el boton
      --Ponemos el boton en modo pulsado
      btnFrena.isVisible=false
      btnFrenaPulsado.isVisible=true
      --Reducimos la velocidad 
      factorVelocidad=0.3
      
    elseif event.phase=="ended" or event.phase=="moved" then--Cuando el usuario levanta el dedo del boton
      --Ponemos el boton en modo normal
      btnFrena.isVisible=true
      btnFrenaPulsado.isVisible=false
      --Restablecemos la velocidad
      factorVelocidad=1
    end
  end
  --Como ya hemos tratado el evento devolvemos true para que no siga propagandose
  return true
end

--Funcion listener para elevar al personaje cuando tocamos la pantalla
local function vuela(event)
  local phase=event.phase
  if phase=="began" then--Si el usuario toca con el dedo la pantalla
   
  --Si el juego no ha empezado debemos mostrar las instrucciones
    if juegoEmpezado==false then
      --Reproducimos el sonido del helicoptero de rayman
       audio.play(tablaSonido["rayHelicoptero"],{channel=2,duration=100})
       --Hacemos visible el grupo de botones start/pause y el grupo de botones de freno 
       grupoBtn.isVisible=true
       grupoBtnFrena.isVisible=true
       --Paramos la musica de las instrucciones
        audio.stop(6)
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
     anyadirObstaculoTimer=timer.performWithDelay(1500,AnyadirObstaculo,-1)
         
    
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
     juegoEmpezado=false--Desactivamos el flag de juegoEmpezado para que se muestren las instrucciones
    
    --Leemos los datos del archivo de datos
    datosString=soporte:leerDatos()
    datos=json.decode(datosString)

    --Cargamos todos los sonidos de la escena
    tablaSonido = { 
            musicaFondo=audio.loadStream("sonido/musicaNivelGlobox2.wav"),
            rayHelicoptero = audio.loadSound( "sonido/rayHelicoptero.wav" ),
            golpe=audio.loadSound( "sonido/golpe.wav" ),
            muerte=audio.loadSound( "sonido/muerte.wav" ),
            choquePiedra=audio.loadSound( "sonido/choquePiedra.wav" ), 
            instrucciones=audio.loadStream("sonido/musicaInstruccionesGlobox2.wav")}
    
    --Creamos los dos tipos de fondo y los añadimos a la escena
    for i=1,2 do
       fondo[i]=soporte:CrearObjeto("graficos/liberarGlobox/nivel2/fondoNivel2 ("..i..").png",W,H,0,0,W*(i-1),0)
       sceneGroup:insert(fondo[i])  
    end
    for j=1,3 do
      fondoFinal[j]=soporte:CrearObjeto("graficos/liberarGlobox/nivel2/fondoNivel2 ("..(j+2)..").png",W,H,0,0,W*j,0)
      sceneGroup:insert(fondoFinal[j])  
    end
  
  --Grupo para los objetos de obstaculos
  grupoObstaculos=soporte:CrearGrupo(0,1,0,0)

  --Creamos el sprite del personaje
    personaje=soporte:CrearPersonaje("sheetsInfo.raymanPersonaje","graficos/personajes/raymanPersonaje.png",0.5,0.5,3,3,centroX-170,centroY)
    --Añadimos el personale al motor de fisica para que sea sensible a colisiones
    physics.addBody(personaje,"static",{density=0.1,friction=1,bounce=0})
  
    --Creamos las instrucciones
   instrucciones=soporte:CrearInstrucciones("rayman",centroX,centroY,2)
    
   --Creamos la salida del nivel
   salidaAbajo,salidaArriba,grupoSalida=soporte:CrearSalidaNivelGlobox2(W,centroY-400,W,centroY-70)
  
  
    --Creamos el icono del personaje seleccionado y el contador de vidas
   cara,vida=soporte:CrearVida("rayman",datos.vidas)
   
    --Creamos el boton de play/pause
   btnPausa,btnPlay,grupoBtn=soporte:CrearBotonPlayPause(W-100,vida.y)
   --Creamos el boton de frenada
   btnFrena,btnFrenaPulsado,grupoBtnFrena=soporte:CrearBotonFrenado(W-150,H-100)
   --Creamos el choque
   choque=soporte:CrearObjeto("graficos/personajes/choque.png",25,50,0,0.5,personaje.x,personaje.y)
   choque.isVisible=false
   choque:scale(3,3)
   
  --Añadimos los elementos a la vista
  sceneGroup:insert(grupoObstaculos)
  sceneGroup:insert(personaje) 
  sceneGroup:insert(instrucciones)
  sceneGroup:insert(salidaArriba)
  sceneGroup:insert(salidaAbajo)  
  sceneGroup:insert(cara)
  sceneGroup:insert(vida)
  sceneGroup:insert(grupoBtnFrena)
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
        audio.play(tablaSonido["instrucciones"],{channel=6,loops = -1})
        --Arrancamos el sprite del personaje
        personaje:play()
        --Añadimos los listerners
        Runtime:addEventListener("touch",vuela)--Listener para hacer que el personaje se eleve al tocar la pantalla
        Runtime:addEventListener("enterFrame",mover)--Listener para mover los elementos de la escena
        Runtime:addEventListener("collision",onCollision)--Listener de las colisiones con los obstaculos
        salidaAbajo:addEventListener("collision",onCollision)--Listener para las colisiones con la parte de abajo de la salida del nivel
        salidaArriba:addEventListener("collision",onCollision)--Listener para las colisiones con la parte de arriba de la salida del nivel
        personaje:addEventListener("sprite",personajeListener)--Listener para cambiar la secuencia del personaje
        grupoBtn:addEventListener("touch",playAndPause)--Listener para los botones de play/pause
        grupoBtnFrena:addEventListener("touch",Frenar)--Listener para frenar el avance del fondo y parecer que ray frena
          
      
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
      salidaAbajo:removeEventListener("collision",onCollision)
      salidaArriba:removeEventListener("collision",onCollision)
      personaje:removeEventListener("sprite",personajeListener)
      grupoBtn:removeEventListener("touch",playAndPause)
      grupoBtnFrena:remove("touch",Frenar)
      
      --Cancelamos el timer de anyadir obstaculos
      timer.cancel(anyadirObstaculoTimer)
      
     --Eliminamos los objetos del motor de fisica
      physics.removeBody(personaje)
      physics.removeBody(salidaAbajo)
      physics.removeBody(salidaArriba)
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
personaje, instrucciones,vida,choque,cara,salidaArriba,salidaAbajo=nil,nil,nil,nil,nil,nil,nil

--Variables del fondo
for n=#fondoFinal,1,-1 do
  fondoFinal[n]=nil
end
fondoFinal=nil

--Variables de los botones
btnPlay,btnPausa,btnFrena,btnFrenaPulsado=nil,nil,nil,nil
--Variables de los grupos
grupoObstaculos,grupoBtn,grupoBtnFrena=nil,nil,nil
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