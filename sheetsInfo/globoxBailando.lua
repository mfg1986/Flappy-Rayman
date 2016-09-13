--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:74e5aacc56918931ddbd483f01561b4c:8af341b811ed3fa8452aafe3865a2374:f0b64f7bec891650d71d2036f9d74112$
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
            -- G01
            x=81,
            y=1,
            width=74,
            height=71,

            sourceX = 2,
            sourceY = 13,
            sourceWidth = 78,
            sourceHeight = 91
        },
        {
            -- G02
            x=1,
            y=1,
            width=78,
            height=69,

            sourceX = 0,
            sourceY = 15,
            sourceWidth = 78,
            sourceHeight = 91
        },
        {
            -- G05
            x=1,
            y=145,
            width=78,
            height=67,

            sourceX = 0,
            sourceY = 17,
            sourceWidth = 78,
            sourceHeight = 91
        },
        {
            -- G06
            x=1,
            y=72,
            width=74,
            height=71,

            sourceX = 2,
            sourceY = 13,
            sourceWidth = 78,
            sourceHeight = 91
        },
        {
            -- G10
            x=157,
            y=1,
            width=74,
            height=71,

            sourceX = 2,
            sourceY = 13,
            sourceWidth = 78,
            sourceHeight = 91
        },
        {
            -- G11
            x=81,
            y=147,
            width=78,
            height=67,

            sourceX = 0,
            sourceY = 17,
            sourceWidth = 78,
            sourceHeight = 91
        },
        {
            -- G12
            x=77,
            y=74,
            width=78,
            height=69,

            sourceX = 0,
            sourceY = 15,
            sourceWidth = 78,
            sourceHeight = 91
        },
        {
            -- G13
            x=157,
            y=74,
            width=74,
            height=71,

            sourceX = 2,
            sourceY = 13,
            sourceWidth = 78,
            sourceHeight = 91
        },
        {
            -- G16
            x=77,
            y=74,
            width=78,
            height=69,

            sourceX = 0,
            sourceY = 15,
            sourceWidth = 78,
            sourceHeight = 91
        },
        {
            -- G17
            x=157,
            y=74,
            width=74,
            height=71,

            sourceX = 2,
            sourceY = 13,
            sourceWidth = 78,
            sourceHeight = 91
        },
        {
            -- G18
            x=81,
            y=1,
            width=74,
            height=71,

            sourceX = 2,
            sourceY = 13,
            sourceWidth = 78,
            sourceHeight = 91
        },
    },
    
    sheetContentWidth = 232,
    sheetContentHeight = 215
}

SheetInfo.frameIndex =
{

    ["G01"] = 1,
    ["G02"] = 2,
    ["G05"] = 3,
    ["G06"] = 4,
    ["G10"] = 5,
    ["G11"] = 6,
    ["G12"] = 7,
    ["G13"] = 8,
    ["G16"] = 9,
    ["G17"] = 10,
    ["G18"] = 11,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end
function SheetInfo:getSequence(name,imageSheet)
   local sequence
   if name=="globoxBailando" then
    sequence={name="globoxBailando",sheet=imageSheet,start=1,count=11,time=2000}

   end
  return sequence
end
return SheetInfo
