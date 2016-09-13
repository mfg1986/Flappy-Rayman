--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:4ab1aba270f9141fe110126917aeb47b:d46480999f89c41974ca2a8e298fb57f:cbc10194d8612a192c21f67604eb4e3f$
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
            -- escobas1_01
            x=136,
            y=1,
            width=47,
            height=47,

            sourceX = 0,
            sourceY = 4,
            sourceWidth = 47,
            sourceHeight = 55
        },
        {
            -- escobas1_02
            x=1,
            y=1,
            width=82,
            height=53,

            sourceX = 0,
            sourceY = 1,
            sourceWidth = 82,
            sourceHeight = 55
        },
        {
            -- escobas1_03
            x=185,
            y=1,
            width=57,
            height=45,

            sourceX = 0,
            sourceY = 8,
            sourceWidth = 59,
            sourceHeight = 55
        },
        {
            -- escobas1_04
            x=85,
            y=1,
            width=49,
            height=53,

            sourceX = 5,
            sourceY = 0,
            sourceWidth = 55,
            sourceHeight = 55
        },
    },
    
    sheetContentWidth = 243,
    sheetContentHeight = 55
}

SheetInfo.frameIndex =
{

    ["escobas1_01"] = 1,
    ["escobas1_02"] = 2,
    ["escobas1_03"] = 3,
    ["escobas1_04"] = 4,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

function SheetInfo:getSequence(name)
   sequence={start=1,count=4,time=500,frames=self.frameIndex[name]}
    return sequence;
end
return SheetInfo
