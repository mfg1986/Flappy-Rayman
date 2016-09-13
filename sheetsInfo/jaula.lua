--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:38c32de320ec720a8a874863527ff934:8c393168c061090a94b16502d2da816b:658724fb91151275e59ae468e710e471$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- jaulaRota_01
            x=1,
            y=1,
            width=62,
            height=72,

            sourceX = 8,
            sourceY = 0,
            sourceWidth = 70,
            sourceHeight = 72
        },
        {
            -- jaulaRota_02
            x=65,
            y=1,
            width=52,
            height=72,

            sourceX = 9,
            sourceY = 0,
            sourceWidth = 70,
            sourceHeight = 72
        },
        {
            -- jaulaRota_03
            x=119,
            y=59,
            width=69,
            height=52,

            sourceX = 0,
            sourceY = 19,
            sourceWidth = 69,
            sourceHeight = 72
        },
        {
            -- jaulaRota_04
            x=119,
            y=1,
            width=70,
            height=56,

            sourceX = 0,
            sourceY = 16,
            sourceWidth = 70,
            sourceHeight = 72
        },
        {
            -- jaulaRota_05
            x=1,
            y=75,
            width=70,
            height=30,

            sourceX = 0,
            sourceY = 41,
            sourceWidth = 70,
            sourceHeight = 72
        },
    },
    
    sheetContentWidth = 190,
    sheetContentHeight = 112
}

SheetInfo.frameIndex =
{
    --Jaula movimiento
    ["jaulaRota_01"] = 1,
    ["jaulaRota_02"] = 2,
    ["jaulaRota_03"] = 3,
    --Jaula abriendo
    ["jaulaRota_04"] = 4,
    ["jaulaRota_05"] = 5,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end
function SheetInfo:getSequence(name,imageSheet)
   local sequence
   if name=="electroonsJaula" then
    sequence={name="electroonsJaula",sheet=imageSheet,frames={1,2,3,2},time=1000}--frames={1,1,1,2,2,2,3,3,3,2,2,2}
   elseif name=="abrirJaula" then
    sequence={name="abrirJaula",sheet=imageSheet,start=4,count=2,time=1000,loopCount=1}
   end
  return sequence
end


return SheetInfo
