--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:d4a28e35c2e4727c4bd2eaf877f4e54e:5d66e1fd4868bdc82e5faa154e223b07:0c51e308a4856ada80680edacd4422f0$
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
            -- A (1)
            x=325,
            y=1,
            width=65,
            height=62,

            sourceX = 4,
            sourceY = 8,
            sourceWidth = 73,
            sourceHeight = 78
        },
        {
            -- A (2)
            x=1,
            y=1,
            width=65,
            height=68,

            sourceX = 5,
            sourceY = 5,
            sourceWidth = 73,
            sourceHeight = 78
        },
        {
            -- A (3)
            x=125,
            y=1,
            width=58,
            height=64,

            sourceX = 1,
            sourceY = 32,
            sourceWidth = 64,
            sourceHeight = 100
        },
        {
            -- A (4)
            x=68,
            y=1,
            width=55,
            height=66,

            sourceX = 8,
            sourceY = 16,
            sourceWidth = 73,
            sourceHeight = 90
        },
        {
            -- B (1)
            x=392,
            y=1,
            width=68,
            height=61,

            sourceX = 11,
            sourceY = 10,
            sourceWidth = 82,
            sourceHeight = 79
        },
        {
            -- B (2)
            x=185,
            y=1,
            width=68,
            height=63,

            sourceX = 5,
            sourceY = 10,
            sourceWidth = 82,
            sourceHeight = 79
        },
        {
            -- B (3)
            x=255,
            y=1,
            width=68,
            height=63,

            sourceX = 0,
            sourceY = 11,
            sourceWidth = 82,
            sourceHeight = 79
        },
        {
            -- B (4)
            x=185,
            y=1,
            width=68,
            height=63,

            sourceX = 5,
            sourceY = 10,
            sourceWidth = 82,
            sourceHeight = 79
        },
        {
            -- B (5)
            x=392,
            y=1,
            width=68,
            height=61,

            sourceX = 11,
            sourceY = 10,
            sourceWidth = 82,
            sourceHeight = 79
        },
    },
    
    sheetContentWidth = 461,
    sheetContentHeight = 70
}

SheetInfo.frameIndex =
{
    --Caida
    ["A (1)"] = 1,
    ["A (2)"] = 2,
    ["A (3)"] = 3,
    ["A (4)"] = 4,
    --Volar
    ["B (1)"] = 5,
    ["B (2)"] = 6,
    ["B (3)"] = 7,
    ["B (4)"] = 8,
    ["B (5)"] = 9,
}


function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end
function SheetInfo:getSequence(name)
  
  if name=="caida" then
    sequence={name="caida",time=400,frames={1,2,3,4},loopCount=1}
  elseif name=="vuela" then  
    sequence={name="vuela",time=200,frames={5,6,7,8,9},loopCount=1}
  end
  
   
    return sequence;
end
return SheetInfo
