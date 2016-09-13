--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:43d2b5bfbc5b7839ed5a5a2273ab0116:a659d9c87f30b9347f1d34003549e53b:e159256f09c2416a3963177281808b64$
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
            -- Frame00
            x=67,
            y=395,
            width=50,
            height=56,

            sourceX = 21,
            sourceY = 16,
            sourceWidth = 104,
            sourceHeight = 80
        },
        {
            -- Frame01
            x=67,
            y=333,
            width=54,
            height=60,

            sourceX = 25,
            sourceY = 12,
            sourceWidth = 104,
            sourceHeight = 80
        },
        {
            -- Frame02
            x=67,
            y=131,
            width=60,
            height=68,

            sourceX = 33,
            sourceY = 4,
            sourceWidth = 104,
            sourceHeight = 80
        },
        {
            -- Frame03
            x=1,
            y=71,
            width=64,
            height=68,

            sourceX = 35,
            sourceY = 4,
            sourceWidth = 104,
            sourceHeight = 80
        },
        {
            -- Frame04
            x=1,
            y=211,
            width=64,
            height=66,

            sourceX = 35,
            sourceY = 6,
            sourceWidth = 104,
            sourceHeight = 80
        },
        {
            -- Frame05
            x=1,
            y=279,
            width=64,
            height=66,

            sourceX = 35,
            sourceY = 6,
            sourceWidth = 104,
            sourceHeight = 80
        },
        {
            -- Frame06
            x=69,
            y=1,
            width=58,
            height=64,

            sourceX = 30,
            sourceY = 8,
            sourceWidth = 104,
            sourceHeight = 80
        },
        {
            -- Frame07
            x=69,
            y=67,
            width=58,
            height=62,

            sourceX = 25,
            sourceY = 10,
            sourceWidth = 104,
            sourceHeight = 80
        },
        {
            -- Frame08
            x=67,
            y=201,
            width=60,
            height=66,

            sourceX = 17,
            sourceY = 5,
            sourceWidth = 104,
            sourceHeight = 80
        },
        {
            -- Frame09
            x=1,
            y=1,
            width=66,
            height=68,

            sourceX = 8,
            sourceY = 4,
            sourceWidth = 104,
            sourceHeight = 80
        },
        {
            -- Frame10
            x=1,
            y=141,
            width=64,
            height=68,

            sourceX = 7,
            sourceY = 4,
            sourceWidth = 104,
            sourceHeight = 80
        },
        {
            -- Frame11
            x=1,
            y=347,
            width=64,
            height=66,

            sourceX = 8,
            sourceY = 5,
            sourceWidth = 104,
            sourceHeight = 80
        },
        {
            -- Frame12
            x=67,
            y=269,
            width=54,
            height=62,

            sourceX = 17,
            sourceY = 10,
            sourceWidth = 104,
            sourceHeight = 80
        },
    },
    
    sheetContentWidth = 128,
    sheetContentHeight = 452
}

SheetInfo.frameIndex =
{

    ["Frame00"] = 1,
    ["Frame01"] = 2,
    ["Frame02"] = 3,
    ["Frame03"] = 4,
    ["Frame04"] = 5,
    ["Frame05"] = 6,
    ["Frame06"] = 7,
    ["Frame07"] = 8,
    ["Frame08"] = 9,
    ["Frame09"] = 10,
    ["Frame10"] = 11,
    ["Frame11"] = 12,
    ["Frame12"] = 13,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end
function SheetInfo:getSequence(name,imageSheet)
   local sequence
   if name=="raybailando" then
   sequence={name="raybailando",sheet=imageSheet,start=1,count=13,time=1000,loopCount=2}
  end
  return sequence
  end
return SheetInfo
