--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:a8bbd7e63a08cf46583b342582a96597:8045d7ecb3be1d321891445f04554eac:c5088c5ecffbead1c43e54da1c1b384b$
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
            -- g01
            x=123,
            y=1,
            width=78,
            height=119,

        },
        {
            -- g02
            x=283,
            y=1,
            width=69,
            height=119,

        },
        {
            -- g03
            x=203,
            y=1,
            width=78,
            height=119,

        },
        {
            -- g04
            x=1,
            y=1,
            width=120,
            height=119,

        },
    },
    
    sheetContentWidth = 353,
    sheetContentHeight = 121
}

SheetInfo.frameIndex =
{

    ["g01"] = 1,
    ["g02"] = 2,
    ["g03"] = 3,
    ["g04"] = 4,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end
function SheetInfo:getSequence(name,imageSheet)
   local sequence
   if name=="globoxAndando" then
    sequence={name="globoxAndando",sheet=imageSheet,start=1,count=4,time=1000}

   end
  return sequence
end
return SheetInfo
