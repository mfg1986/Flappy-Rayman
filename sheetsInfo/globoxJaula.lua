--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:a86c2cd1049c740f2c1cda9679c1edb8:aaf06a45cad8793ee9591202a1b790eb:a7c01321ccfaa5eccbd286dfc75b1f36$
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
            -- globoxJaula01
            x=223,
            y=1,
            width=70,
            height=87,

            sourceX = 2,
            sourceY = 0,
            sourceWidth = 78,
            sourceHeight = 91
        },
        {
            -- globoxJaula02
            x=223,
            y=1,
            width=70,
            height=87,

            sourceX = 2,
            sourceY = 0,
            sourceWidth = 78,
            sourceHeight = 91
        },
        {
            -- globoxJaula03
            x=295,
            y=1,
            width=70,
            height=87,

            sourceX = 2,
            sourceY = 0,
            sourceWidth = 78,
            sourceHeight = 91
        },
        {
            -- globoxJaula04
            x=295,
            y=1,
            width=70,
            height=87,

            sourceX = 2,
            sourceY = 0,
            sourceWidth = 78,
            sourceHeight = 91
        },
        {
            -- globoxJaula05
            x=367,
            y=1,
            width=70,
            height=87,

            sourceX = 2,
            sourceY = 0,
            sourceWidth = 78,
            sourceHeight = 91
        },
        {
            -- globoxJaula06
            x=367,
            y=1,
            width=70,
            height=87,

            sourceX = 2,
            sourceY = 0,
            sourceWidth = 78,
            sourceHeight = 91
        },
        {
            -- globoxJaula07
            x=1,
            y=1,
            width=72,
            height=87,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 78,
            sourceHeight = 91
        },
        {
            -- globoxJaula08
            x=1,
            y=1,
            width=72,
            height=87,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 78,
            sourceHeight = 91
        },
        {
            -- globoxJaula09
            x=75,
            y=1,
            width=72,
            height=87,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 78,
            sourceHeight = 91
        },
        {
            -- globoxJaula10
            x=75,
            y=1,
            width=72,
            height=87,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 78,
            sourceHeight = 91
        },
        {
            -- globoxJaula11
            x=149,
            y=1,
            width=72,
            height=87,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 78,
            sourceHeight = 91
        },
        {
            -- globoxJaula12
            x=149,
            y=1,
            width=72,
            height=87,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 78,
            sourceHeight = 91
        },
    },
    
    sheetContentWidth = 438,
    sheetContentHeight = 89
}

SheetInfo.frameIndex =
{

    ["globoxJaula01"] = 1,
    ["globoxJaula02"] = 2,
    ["globoxJaula03"] = 3,
    ["globoxJaula04"] = 4,
    ["globoxJaula05"] = 5,
    ["globoxJaula06"] = 6,
    ["globoxJaula07"] = 7,
    ["globoxJaula08"] = 8,
    ["globoxJaula09"] = 9,
    ["globoxJaula10"] = 10,
    ["globoxJaula11"] = 11,
    ["globoxJaula12"] = 12,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

function SheetInfo:getSequence(name,imageSheet)
   local sequence
   if name=="globoxJaula" then
    sequence={name="globoxJaula",sheet=imageSheet,start=1,count=12,time=1000}--frames={1,1,1,2,2,2,3,3,3,2,2,2}

   end
  return sequence
end




return SheetInfo
