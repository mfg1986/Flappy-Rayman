--require('mobdebug').start()
--Cargamos la libreria de soporte
local soporte=require("soporte")
local json=require("json")
--Cargamos la libreria "composer"
--Cargamos la librería "composer"
local composer=require("composer")
--Creamos una nueva escena
local scene=composer.newScene()
--Activamos el flag para que al cambiar de escena se elimine la vista de la misma
composer.recycleOnSceneChange=true


--Obtenemos el tamaño de la pantalla
local W=display.contentWidth
local H=display.contentHeight
local centroX=display.contentCenterX
local centroY=display.contentCenterY

--Declaramos la variables necesarias
local flagPortal=false
local fondo={}
local datos={}
local datosString
local tablaSonido={}

local btnRayNoPulsado,btnRayPulsado,btnVolver,btnVolverPulsado,btnGloboxNoPulsado,btnGloboxPulsado,btnGloboxBloqueado,btnMinimoBloqueado,btnBarbaraBloqueado
local grupoBtnVolver,grupoBtnRay,grupoBtnGlobox,grupoBtns,grupoPersonajes

local portalEntrada,portalSalida
local rayman, globox

--Funcion para crear el objeto display del portal de entrada y salida
local function crearPortal()
 
    --Creamos el objeto portal
    local portal = soporte:CrearObjeto("graficos/selecPersonaje/portal.png",512,512,0.5,0.5,nil,nil)
    --Hacemos invisible el portal
    portal.alpha=0
    --Devolvemos el objeto display
  return portal
end
--Funcion Listener del sprite de rayman
local function listenerRayman(event)
  local phase=event.phase
  local sprite=event.target
  --Si el sprite termina de ejecutar la secuencia de bailando
  if event.phase=="ended" then
   if sprite.sequence=="raybailando" then
     --Hacemos que vuelva a ejecutar la secuencia de bailando
    soporte:cambiarSecuencia(sprite,"raybailando")   
   end
  end
  --Como ya hemos tratado el evento devolvemos true para que no siga propagandose 
  return true
end

--Funcion para crear el sprite de los personajes en una determinada posicion
local function CrearPersonajeSeleccionado(heroe,x,y)
  local personaje
  if heroe=="rayman" then--Si queremos crear a Rayman
     personaje=soporte:CrearSpriteSimple("sheetsInfo.raybailandoGameOver","graficos/gameOver/raybailandoGameOver.png","raybailando", 0.5,0.5,3.5,3.5,x,y)
    -- personaje.name="rayman"
             
  elseif heroe=="globox" then--Si queremos crear a Globox
      personaje=soporte:CrearSpriteSimple("sheetsInfo.globoxBailando","graficos/selecPersonaje/globoxBailando.png","globoxBailando",0.5,0.5,4.5,4.5,x,y)
      --personaje.name="globox"
        
  end
  --Devolvemos el sprite del personaje creado
    return personaje
end

--Funcion Listener para poder desplazarnos por la escena con el movimiento del dedo
local function arrastrarFondo( event )
  if flagPortal==false then--Si no se esta abriendo ni cerrando ninguno de los portales de entrada o salida de los personajes
  if event.phase == "began" then

    --Establecemos el foco en el fondo
    display.getCurrentStage():setFocus( fondo, event.id )
    --Activamos  la propiedad del fondo que indica que posee el foco
    fondo.isFocus = true
 
    --Guardamos la posicion inicial de x del foco
    fondo.markX = fondo.x

  elseif fondo.isFocus and event.phase == "moved" then--Si el foco del fondo esta activado y hemos movido el dedo por la pantalla
     --Obtenemos el desplazamiento que hemos realizado
     local desplazamiento=event.x - event.xStart
     --Movemos el fondo 
      fondo.x =fondo.markX+desplazamiento
      --Colocamos el grupo de botones en la posicion x del fondo para que se desplacen a la vez que este
      grupoBtns.x=fondo.x
      --Colocamos el grupo de personajes en la posicion x del grupo de botones para que se desplacen a la vez que este
      grupoPersonajes.x=grupoBtns.x
      --Cuando al desplazarnos por el fondo con el dedo 
      --Si el margen izquierdo del fondo se mueve hacia la derecha lo fijamos para evitar zonas muertas
     if fondo.x>=0 then 
        fondo.x=0--Fijamos el margen izquierdo del fondo al margen izquierdo  de la pantalla
        grupoBtns.x=0--Fijamos el margen izquierdo del grupo de botones al margen izquierdo de la pantalla
        grupoPersonajes.x=0--Fijamos el grupo de personajes para que no se desplazen hacia la derecha
      elseif fondo.x<-2*W then --Si el margen derecho del fondo se mueve hacia la izquierda lo fijamos tambien para evitar zonas muertas
        fondo.x=-2*W--Fijamos el margen derecho del fondo al margen derecho de la pantalla
        grupoBtns.x=-2*W--Fijamos el margen derecho del grupo de botones al margen derecho de la pantalla
      end
    
    
     
    elseif event.phase == "ended" or event.phase == "cancelled" then--Si el evento es cancelado o levantamos el dedo de la pantalla, lo que implica que el evento termino
      --Cuando terminamos de mover el fondo eliminamos el foco sobre el mismo
      display.getCurrentStage():setFocus( fondo, nil )
      --Desactivamos la propiedad que indica que  el fondo posee el foco
      fondo.isFocus = false
    end

 end
--Como ya hemos tratado el evento devolvemos true para que no siga propagandose 
 return true
end






--Funcion Listener del boton Inicio
local function irInicio(event)
   local phase=event.phase
    if phase=="began" then--Cuando el usuario pulsa el boton
      --Reproducimos el sonido de pulsar botón
        audio.play( tablaSonido["pulsarBtn"],{channel=2})
      --Ponemos el boton de Inicio en modo pulsado
        btnVolver.isVisible = false
        btnVolverPulsado.isVisible = true

    elseif phase=="ended" then--Cuando el usuario levanta el dedo del boton
     --Devolvemos el boton de Jugar al estado de no pulsado
      btnVolver.isVisible = true
      btnVolverPulsado.isVisible = false
     --Guardamos los cambios de la tabla datos en el archivo de datos
      datosString=json.encode(datos)
      soporte:guardarDatos(datosString)
     --Regresamos a la escena de Inicio
      composer.gotoScene("inicio") 
end
  --Como ya hemos tratado el evento devolvemos true para que no siga propagandose
  return true 
end




--Método para abrir el portal y hacer aparecer al personaje seleccionado
local function AbrirPortal(heroe)
 
if heroe=="rayman" and datos.personaje=="globox" then--Si el personaje que queremos seleccionar es globox y estaba selecionado rayman
     --Reproducimos el sonido del portal y hacemos desaparecer a globox
     audio.play( tablaSonido["portal"],{channel=3})
     transition.to(globox, {time=1000,alpha=0} ) 
     
     --Esperamos 3s, reproducimos el sonido del portal y hacemos aparecer a rayman         
      timer.performWithDelay(3000,function() 
            audio.play( tablaSonido["portal"],{channel=3})
            transition.to(rayman, {time=1000,alpha=1})  
          end,1 ) 
     
      --Obtenemos las correspondientes posiciones de los portales
      portalEntrada.x ,portalEntrada.y=btnRayPulsado:localToContent( 0, 0 )
      portalSalida.x,portalSalida.y=btnGloboxPulsado:localToContent(0,0)

elseif heroe=="globox" and datos.personaje=="rayman" then--Si el personaje que queremos seleccionar es rayman y estaba seleccionado globox   
   
    --Reproducimos el sonido del portal y hacemos desaparecer a rayman
      audio.play( tablaSonido["portal"],{channel=3})
      transition.to(rayman, {time=1000,alpha=0} )
      
      --Esperamos 3s,reproducimos el sonido del portal y hacemos aparecer a globox   
      timer.performWithDelay(3000,function() 
          audio.play( tablaSonido["portal"],{channel=3}) 
          transition.to(globox, {time=1000,alpha=1}) end,1 ) 
      
       --Obtenemos las correspondientes posiciones de los portales
      portalEntrada.x ,portalEntrada.y=btnGloboxPulsado:localToContent( 0, 0 )
      portalSalida.x,portalSalida.y=btnRayPulsado:localToContent(0,0)
end
--Desactivamos el movimiento de la pantalla con el dedo
flagPortal=true
--Recolocamos los portales de entrada y salida a los pies del cartel correspondiente
 portalEntrada.x=portalEntrada.x-10;portalEntrada.y=portalEntrada.y+150
 portalSalida.x=portalSalida.x-10;portalSalida.y=portalSalida.y+150
--Ponemos los portales invisibles
portalEntrada.alpha=0;portalSalida.alpha=0

transition.to( portalSalida, { time=1000,alpha=1,--Abrimos el portal de salida 
    onComplete=function() --Cuando termine abrimos el portal de entrada del personaje seleccionado
                 
                  transition.to( portalEntrada, { time=2000,alpha=1,
          onComplete=function() --Cuando termine cerramos el portal de salida 
                     
                      transition.to( portalSalida, { time=1000,alpha=0} )
                    end
      } )
      end
      
    } )
--Esperamos un poco y cerramos el portal de entrada del personaje y activamos el movimiento de la pantalla
timer.performWithDelay(5000,function()
    transition.to( portalEntrada, { time=2000,alpha=0,onComplete=function() flagPortal=false end} )    
    end,1)
end



--Listener del boton que selecciona como personaje a rayman
local function seleccionarRay(event)
  if flagPortal==false then --Si no estamos en mitad del proceso de aparicion del personaje 
   local phase=event.phase
     if phase=="began" then
        if btnRayPulsado.isVisible==false then--Si el personaje que estaba seleccionado no es rayman
        --Reproducimos el sonido de boton pulsado
        audio.play( tablaSonido["pulsarBtn"],{channel=2})
          --Hacemos que aparezca globox y desaparezca rayman  a traves del portal
         AbrirPortal("rayman")
         --Iluminamos el cartel de rayman y apagamos el cartel de globox
         btnRayPulsado.isVisible=true
         btnRayNoPulsado.isVisible=false
         btnGloboxPulsado.isVisible=false
         btnGloboxNoPulsado.isVisible=true  
         --Guardamos como personaje actual a rayman
         datos.personaje="rayman"
        end
    end
  end
  --Como ya hemos tratado el evento devolvemos true para que no siga propagandose
return true
end
--Listener del botón que selecciona como personaje a globox
local function seleccionarGlobox(event)
 if datos.estadoGlobox=="libre" then 
  if flagPortal==false then--Si no estamos en mitad del proceso de aparicion del personaje 
   local phase=event.phase
     if phase=="began" then
        if btnGloboxPulsado.isVisible==false then--Si el personaje que estaba seleccionado no es globox
         --Reproducimos el sonido de boton pulsado
        audio.play( tablaSonido["pulsarBtn"],{channel=2})
         --Hacemos que aparezca globox y desaparezca rayman  a traves del portal
         AbrirPortal("globox")
          --Iluminamos el cartel de globox  y apagamos el cartel de rayman
         btnGloboxPulsado.isVisible=true
         btnGloboxNoPulsado.isVisible=false
         btnRayPulsado.isVisible=false
         btnRayNoPulsado.isVisible=true
           --Guardamos como personaje actual a globox
          datos.personaje="globox"
      end
    end
  end
end
--Como ya hemos tratado el evento devolvemos true para que no siga propagandose
return true
end


--Funcion para indicar el personaje activo al inicio de la escena
local function ComprobarPersonajeActivo()
  
   if datos.estadoGlobox=="preso" then--Si globox esta preso solo podemos seleccionar a rayman
      --Hacemos visible el sprite de rayman  y ocultamos el de globox
      globox.alpha=0;rayman.alpha=1
      --Ponemos el cartel de bloqueado en el boton de globox
      btnGloboxBloqueado.isVisible=true;btnGloboxPulsado.isVisible=false;btnGloboxNoPulsado.isVisible=false
     --Iluminamos el cartel de rayman
     btnRayPulsado.isVisible=true;btnRayNoPulsado.isVisible=false
    
    else--Si globox esta libre
       --Desbloqueamos el boton de globox para que pueda ser seleccionado como personaje
       btnGloboxBloqueado.isVisible=false;
      
      if datos.personaje=="globox" then --Si el personaje actual es globox
        --Hacemos visible el sprite de globox y ocultamos el de rayman
        globox.alpha=1;rayman.alpha=0
        --Iluminamos el cartel de globox y apagamos el cartel de rayman
       btnGloboxPulsado.isVisible=true;btnGloboxNoPulsado.isVisible=false
       btnRayPulsado.isVisible=false;btnRayNoPulsado.isVisible=true
     else --Si el personaje actual es rayman  
       --Hacemos visible el sprite de rayman y ocultamos el de globox
       globox.alpha=0;rayman.alpha=1
        --Iluminamos el cartel de rayman y apagamos el cartel de globox
       btnGloboxPulsado.isVisible=false;btnGloboxNoPulsado.isVisible=true
       btnRayPulsado.isVisible=true;btnRayNoPulsado.isVisible=false
       end
      
   end
end






-- "scene:create()"
function scene:create( event )
    
    local sceneGroup = self.view
    
     --Leemos los datos del jugador
    datosString=soporte:leerDatos()
    datos=json.decode(datosString)
    
     --Creamos una tabla con los sonidos que se van a reproducir en la escena
    tablaSonido = { 
      musicaFondo=audio.loadStream("sonido/musicaSeleccionarPersonaje.wav"),
      pulsarBtn = audio.loadSound( "sonido/pulsarBtn.wav" ),
      portal=audio.loadSound("sonido/portal.wav"),
      rayBaile= audio.loadSound( "sonido/rayBaile.wav" )
    }
   
    
    --Creamos el fondo
    fondo=soporte:CrearObjeto("graficos/selecPersonaje/fondoSeleccionPersonaje.png",3*W,H,0,0,0,0)

    --Creamos los botones de la escena   
    btnVolver,btnVolverPulsado, grupoBtnVolver,btnRayPulsado,btnRayNoPulsado,grupoBtnRay,btnGloboxPulsado,btnGloboxNoPulsado,btnGloboxBloqueado,grupoBtnGlobox, btnMinimoBloqueado,btnBarbaraBloqueado=soporte:CrearBotonesSeleccionPersonaje(fondo.x,H)
    --Creamos el portal de entrada y salida de los personajes
    portalEntrada=crearPortal()
    portalSalida=crearPortal()

   
    
    --[[Creamos al personaje de rayman:
          1.-Obtenemos las coordenadas del boton (cartel) de rayman dentro del grupo de botones
          2.-Creamos el objeto y colocamos a rayman en el lugar del boton pero a los pies y centrado --]]
    local xRay ,yRay=btnRayPulsado:localToContent(0,0)
    rayman=CrearPersonajeSeleccionado("rayman",xRay-10,yRay+200 )
   
    --[[Creamos al personaje de globox:
          1.-Obtenemos las coordenadas del boton (cartel) de globox dentro del grupo de botones
          2.-Creamos el objeto y colocamos a globox en el lugar del boton pero a los pies y centrado --]]
    local xGlobox ,yGlobox=btnGloboxPulsado:localToContent(0,0)
    globox=CrearPersonajeSeleccionado("globox",xGlobox-10,yGlobox+150 )
   
   --Comprobamos que personaje esta activo segun los datos y lo activamos en la escena
   ComprobarPersonajeActivo()
  
  --Insertamos todos los botones en el grupo botones para poder desplazarlos con el dedo cuando movamos el fondo
   grupoBtns=display.newGroup()
   grupoBtns:insert(grupoBtnVolver)
   grupoBtns:insert(grupoBtnRay)
   grupoBtns:insert(grupoBtnGlobox)
   grupoBtns:insert(btnMinimoBloqueado)
   grupoBtns:insert(btnBarbaraBloqueado)
   
   --Insertamos todos los personajes en el grupo de personajes para poder desplazarlos con el dedo cuando movamos el fondo
   grupoPersonajes=display.newGroup()
   grupoPersonajes:insert(rayman)
   grupoPersonajes:insert(globox)

    --Añadimos los objetos a la escena
    sceneGroup:insert(fondo)
    sceneGroup:insert(grupoBtns)
    sceneGroup:insert(portalEntrada)
    sceneGroup:insert(portalSalida)
    sceneGroup:insert(grupoPersonajes)
   
   
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
        
    --Reproducimos la musica de fondo la escena con un volumen al 50% en el canal 1
      audio.setVolume(0.5,{channel=1})
      audio.play(tablaSonido["musicaFondo"],{channel=1,loops=-1})
    --Activamos los sprites de los personajes
      rayman:play()
      globox:play()
    --Añadimos todos los listener a sus correspondientes objetos
    fondo:addEventListener( "touch", arrastrarFondo)--Listener para poder mover el fondo con el dedo
    grupoBtnVolver:addEventListener("touch",irInicio)--Listener del boton volver para regresar a la pantalla de inicio
    grupoBtnRay:addEventListener("touch",seleccionarRay)--Listener del boton para seleccionar como personaje a rayman
    grupoBtnGlobox:addEventListener("touch",seleccionarGlobox)--Listeber del boton para seleccionar como personaje a globox
    rayman:addEventListener("sprite",listenerRayman)--Listener para reproducir indefinidamente a rayman bailando
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
      
        --Paramos los sprites de los personajes
        rayman:pause()
        globox:pause()
        
        --Paramos todos los canales de audio
        audio.stop()
        
        --Eliminamos todos los listener que creamos anteriormente
        fondo:removeEventListener("touch",arrastrarFondo)
        grupoBtnRay:removeEventListener("touch",seleccionarRay)
        grupoBtnGlobox:removeEventListener("touch",seleccionarGlobox)
        grupoBtnVolver:removeEventListener("touch",irInicio)
        rayman:removeEventListener("sprite",listenerRayman)
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
    package.loaded[json]=nil
    package.loaded[soporte]=nil
    soporte,json,composer=nil,nil,nil

    --Variables para la gestion del archivo de datos
   for n,m in pairs(datos) do
     datos[n]=nil
   end
   datos=nil

--Ponemos a nil las variables de los objetos display
portalEntrada,portalSalida,rayman,globox=nil,nil,nil,nil
for t=#fondo,1,-1 do
   fondo[t]=nil
 end
fondo=nil
--Variables de los botones
btnRayNoPulsado,btnRayPulsado,btnVolver,btnVolverPulsado,btnGloboxNoPulsado,btnGloboxPulsado,btnGloboxBloqueado,btnMinimoBloqueado,btnBarbaraBloqueado=nil,nil,nil,nil,nil,nil,nil,nil,nil

--Variables de los grupos
grupoBtnVolver,grupoBtnRay,grupoBtnGlobox,grupoBtns,grupoPersonajes=nil,nil,nil,nil,nil

end


 


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene