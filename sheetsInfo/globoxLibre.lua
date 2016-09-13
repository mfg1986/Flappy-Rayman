--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:fa81615022c8d0e1a4831cecb820aae8:613461e5032fe295d775d68855563b5e:34115c8a23ff25023754db547e5377db$
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
            -- globoxlibre01
            x=1,
            y=1,
            width=74,
            height=75,

            sourceX = 2,
            sourceY = 12,
            sourceWidth = 78,
            sourceHeight = 91
        },
        {
            -- globoxlibre011
            x=1,
            y=1,
            width=74,
            height=75,

            sourceX = 2,
            sourceY = 12,
            sourceWidth = 78,
            sourceHeight = 91
        },
        {
            -- globoxlibre02
            x=77,
            y=1,
            width=74,
            height=75,

            sourceX = 2,
            sourceY = 12,
            sourceWidth = 78,
            sourceHeight = 91
        },
        {
            -- globoxlibre03
            x=153,
            y=1,
            width=74,
            height=75,

            sourceX = 2,
            sourceY = 12,
            sourceWidth = 78,
            sourceHeight = 91
        },
        {
            -- globoxlibre04
            x=457,
            y=1,
            width=78,
            height=65,

            sourceX = 0,
            sourceY = 22,
            sourceWidth = 78,
            sourceHeight = 91
        },
        {
            -- globoxlibre041
            x=457,
            y=1,
            width=78,
            height=65,

            sourceX = 0,
            sourceY = 22,
            sourceWidth = 78,
            sourceHeight = 91
        },
        {
            -- globoxlibre05
            x=617,
            y=1,
            width=78,
            height=63,

            sourceX = 0,
            sourceY = 24,
            sourceWidth = 78,
            sourceHeight = 91
        },
        {
            -- globoxlibre06
            x=697,
            y=1,
            width=78,
            height=63,

            sourceX = 0,
            sourceY = 24,
            sourceWidth = 78,
            sourceHeight = 91
        },
        {
            -- globoxlibre07
            x=537,
            y=1,
            width=78,
            height=65,

            sourceX = 0,
            sourceY = 22,
            sourceWidth = 78,
            sourceHeight = 91
        },
        {
            -- globoxlibre071
            x=537,
            y=1,
            width=78,
            height=65,

            sourceX = 0,
            sourceY = 22,
            sourceWidth = 78,
            sourceHeight = 91
        },
        {
            -- globoxlibre08
            x=777,
            y=1,
            width=78,
            height=63,

            sourceX = 0,
            sourceY = 24,
            sourceWidth = 78,
            sourceHeight = 91
        },
        {
            -- globoxlibre09
            x=857,
            y=1,
            width=78,
            height=63,

            sourceX = 0,
            sourceY = 24,
            sourceWidth = 78,
            sourceHeight = 91
        },
        {
            -- globoxlibre10
            x=229,
            y=1,
            width=74,
            height=75,

            sourceX = 2,
            sourceY = 12,
            sourceWidth = 78,
            sourceHeight = 91
        },
        {
            -- globoxlibre11
            x=305,
            y=1,
            width=74,
            height=75,

            sourceX = 2,
            sourceY = 12,
            sourceWidth = 78,
            sourceHeight = 91
        },
        {
            -- globoxlibre12
            x=381,
            y=1,
            width=74,
            height=75,

            sourceX = 2,
            sourceY = 12,
            sourceWidth = 78,
            sourceHeight = 91
        },
    },
    
    sheetContentWidth = 936,
    sheetContentHeight = 77
}

SheetInfo.frameIndex =
{

    ["globoxlibre01"] = 1,
    ["globoxlibre011"] = 2,
    ["globoxlibre02"] = 3,
    ["globoxlibre03"] = 4,
    ["globoxlibre04"] = 5,
    ["globoxlibre041"] = 6,
    ["globoxlibre05"] = 7,
    ["globoxlibre06"] = 8,
    ["globoxlibre07"] = 9,
    ["globoxlibre071"] = 10,
    ["globoxlibre08"] = 11,
    ["globoxlibre09"] = 12,
    ["globoxlibre10"] = 13,
    ["globoxlibre11"] = 14,
    ["globoxlibre12"] = 15,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end
function SheetInfo:getSequence(name,imageSheet)
   local sequence
   if name=="globoxLibre" then
    sequence={name="globoxLibre",sheet=imageSheet,start=1,count=12,time=1000}

   end
  return sequence
end

return SheetInfo
