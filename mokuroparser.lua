--[[
    MokuroParser - Handles parsing of .mokuro JSON files
]]--

local rapidjson = require("rapidjson")
local logger = require("logger")

local MokuroParser = {}

function MokuroParser:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function MokuroParser:parse(json_content)
    if not json_content or json_content == "" then
        logger.warn("MokuroParser: empty JSON content")
        return nil
    end
    
    local ok, data = pcall(rapidjson.decode, json_content)
    if not ok then
        logger.err("MokuroParser: failed to parse JSON:", data)
        return nil
    end
    
    if not data.pages or type(data.pages) ~= "table" then
        logger.err("MokuroParser: invalid mokuro format - missing pages")
        return nil
    end
    
    logger.info("MokuroParser: successfully parsed", #data.pages, "pages")
    return data
end

function MokuroParser:getPageData(mokuro_data, page_num)
    if not mokuro_data or not mokuro_data.pages then
        return nil
    end
    
    -- Handle both 0-indexed and 1-indexed
    local page = mokuro_data.pages[page_num] or mokuro_data.pages[page_num - 1]
    
    if not page then
        logger.dbg("MokuroParser: no data for page", page_num)
        return nil
    end
    
    return page
end

function MokuroParser:getBlockText(block)
    if not block or not block.lines then
        return ""
    end
    
    local text_lines = {}
    for _, line in ipairs(block.lines) do
        table.insert(text_lines, line)
    end
    
    -- Concatenate all lines into continuous text without line breaks
    -- This allows natural text wrapping in the popup
    return table.concat(text_lines, "")
end

return MokuroParser
