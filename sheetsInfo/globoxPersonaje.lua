--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:e171dffc4f1435c110104c1de1a367b6:39133ccacb70d06a1cdb46101b86b66a:0346ae4ea214a204af7a61ecb4e48ab0$
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
            -- cayendo1
            x=127,
            y=1468,
            width=104,
            height=139,

            sourceX = 50,
            sourceY = 12,
            sourceWidth = 200,
            sourceHeight = 185
        },
        {
            -- cayendo2
            x=1,
            y=1468,
            width=124,
            height=131,

            sourceX = 43,
            sourceY = 20,
            sourceWidth = 200,
            sourceHeight = 185
        },
        {
            -- cayendo3
            x=127,
            y=1609,
            width=104,
            height=139,

            sourceX = 50,
            sourceY = 12,
            sourceWidth = 200,
            sourceHeight = 185
        },
        {
            -- cayendo4
            x=1,
            y=1601,
            width=124,
            height=131,

            sourceX = 43,
            sourceY = 20,
            sourceWidth = 200,
            sourceHeight = 185
        },
        {
            -- cayendo5
            x=127,
            y=1750,
            width=104,
            height=139,

            sourceX = 50,
            sourceY = 12,
            sourceWidth = 200,
            sourceHeight = 185
        },
        {
            -- cayendo6
            x=1,
            y=1734,
            width=124,
            height=131,

            sourceX = 43,
            sourceY = 20,
            sourceWidth = 200,
            sourceHeight = 185
        },
        {
            -- volando1
            x=1,
            y=991,
            width=182,
            height=157,

            sourceX = 15,
            sourceY = 23,
            sourceWidth = 200,
            sourceHeight = 185
        },
        {
            -- volando2
            x=1,
            y=1,
            width=188,
            height=155,

            sourceX = 12,
            sourceY = 25,
            sourceWidth = 200,
            sourceHeight = 185
        },
        {
            -- volando3
            x=1,
            y=472,
            width=186,
            height=171,

            sourceX = 14,
            sourceY = 9,
            sourceWidth = 200,
            sourceHeight = 185
        },
        {
            -- volando4
            x=1,
            y=1150,
            width=182,
            height=157,

            sourceX = 15,
            sourceY = 23,
            sourceWidth = 200,
            sourceHeight = 185
        },
        {
            -- volando5
            x=1,
            y=158,
            width=188,
            height=155,

            sourceX = 12,
            sourceY = 25,
            sourceWidth = 200,
            sourceHeight = 185
        },
        {
            -- volando6
            x=1,
            y=645,
            width=186,
            height=171,

            sourceX = 14,
            sourceY = 9,
            sourceWidth = 200,
            sourceHeight = 185
        },
        {
            -- volando7
            x=1,
            y=1309,
            width=182,
            height=157,

            sourceX = 15,
            sourceY = 23,
            sourceWidth = 200,
            sourceHeight = 185
        },
        {
            -- volando8
            x=1,
            y=315,
            width=188,
            height=155,

            sourceX = 12,
            sourceY = 25,
            sourceWidth = 200,
            sourceHeight = 185
        },
        {
            -- volando9
            x=1,
            y=818,
            width=186,
            height=171,

            sourceX = 14,
            sourceY = 9,
            sourceWidth = 200,
            sourceHeight = 185
        },
    },
    
    sheetContentWidth = 232,
    sheetContentHeight = 1890
}

SheetInfo.frameIndex =
{
   --Cayendo
    ["cayendo1"] = 1,
    ["cayendo2"] = 2,
    ["cayendo3"] = 3,
    ["cayendo4"] = 4,
    ["cayendo5"] = 5,
    ["cayendo6"] = 6,
    --Volando
    ["volando1"] = 7,
    ["volando2"] = 8,
    ["volando3"] = 9,
    ["volando4"] = 10,
    ["volando5"] = 11,
    ["volando6"] = 12,
    ["volando7"] = 13,
    ["volando8"] = 14,
    ["volando9"] = 15,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end
function SheetInfo:getSequence(name)
  
  if name=="caida" then
    sequence={name="caida",time=400,start=1,count=6,loopCount=1}
  elseif name=="vuela" then  
    sequence={name="vuela",time=150,start=7,count=9,loopCount=1}
  end
  
   
    return sequence;
end
return SheetInfo
