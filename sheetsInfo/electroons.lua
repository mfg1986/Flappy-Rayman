--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:f9563caa00bbf8d4d55a231dd1d2aed1:641ad066a4863f41cdfbb0a2fdfcd451:564d8c71014fdc6e1bb3599033ea00c0$
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
            -- Electroons_01
            x=226,
            y=1,
            width=71,
            height=63,

            sourceX = 4,
            sourceY = 8,
            sourceWidth = 79,
            sourceHeight = 71
        },
        {
            -- Electroons_02
            x=1,
            y=1,
            width=71,
            height=71,

            sourceX = 5,
            sourceY = 0,
            sourceWidth = 79,
            sourceHeight = 71
        },
        {
            -- Electroons_03
            x=74,
            y=1,
            width=71,
            height=71,

            sourceX = 4,
            sourceY = 0,
            sourceWidth = 79,
            sourceHeight = 71
        },
        {
            -- Electroons_04
            x=299,
            y=1,
            width=71,
            height=63,

            sourceX = 1,
            sourceY = 8,
            sourceWidth = 79,
            sourceHeight = 71
        },
        {
            -- Electroons_05
            x=82,
            y=74,
            width=72,
            height=29,

            sourceX = 0,
            sourceY = 42,
            sourceWidth = 78,
            sourceHeight = 71
        },
        {
            -- Electroons_06
            x=1,
            y=74,
            width=79,
            height=45,

            sourceX = 0,
            sourceY = 26,
            sourceWidth = 79,
            sourceHeight = 71
        },
        {
            -- Electroons_07
            x=147,
            y=1,
            width=77,
            height=69,

            sourceX = 0,
            sourceY = 2,
            sourceWidth = 79,
            sourceHeight = 71
        },
        {
            -- Electroons_08
            x=229,
            y=66,
            width=79,
            height=55,

            sourceX = 0,
            sourceY = 16,
            sourceWidth = 79,
            sourceHeight = 71
        },
        {
            -- Electroons_09
            x=156,
            y=72,
            width=71,
            height=29,

            sourceX = 0,
            sourceY = 42,
            sourceWidth = 79,
            sourceHeight = 71
        },
    },
    
    sheetContentWidth = 371,
    sheetContentHeight = 122
}

SheetInfo.frameIndex =
{

    ["Electroons_01"] = 1,
    ["Electroons_02"] = 2,
    ["Electroons_03"] = 3,
    ["Electroons_04"] = 4,
    ["Electroons_05"] = 5,
    ["Electroons_06"] = 6,
    ["Electroons_07"] = 7,
    ["Electroons_08"] = 8,
    ["Electroons_09"] = 9,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end
function SheetInfo:getSequence(name,imageSheet)
    if name=="electroonsLibres" then
      sequence={name="electroonsLibres",sheet=imageSheet,start=1,count=9,time=2000}
    end
    return sequence;
end

return SheetInfo
