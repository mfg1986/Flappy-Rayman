

--[[Calculamos la relacion de aspecto del dispositivo:
      relAspecto=pixeles_alto_dispositivo/pixeles_ancho_dispositivo
--]]
local relAspecto = display.pixelHeight / display.pixelWidth

if relAspecto>1.5 then--Si la relacion de aspecto es mayor que 1.5 -->Tendremos dispositivos altos o alargados
  ancho=800--Fijamos el ancho a 800 y calculamos su correspondiente altura
  alto=800*relAspecto
else--Si la relacion de aspect es menor o igual  a 1.5-->Tendremos dispositivos normales y achatados
  alto=1200--Fijamos el alto a 1200 y calculamos el correspondiente ancho
  ancho=1200/relAspecto
end
  
application = {
   content = { 
      width=ancho,--Ancho de la pantalla
      height=alto,--Alto de la pantalla
      scale = "letterbox",--Tipo de escalado
      fps = 30,--frames por segundo
      audioPlayFrequency=11025,--Frecuencia de reproduccion del audio
   },
} 



