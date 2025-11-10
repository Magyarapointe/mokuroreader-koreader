--[[
    Mokuro Reader Plugin for KOReader - VERSION 4
    Using ScrollHtmlWidget with CJK space cleanup for Japanese support
]]--

local logger = require("logger")
local WidgetContainer = require("ui/widget/container/widgetcontainer")
local InfoMessage = require("ui/widget/infomessage")
local UIManager = require("ui/uimanager")
local TextViewer = require("ui/widget/textviewer")
local util = require("util")
local _ = require("gettext")

-- G_reader_settings is a global variable, no need to require it

logger.info("MokuroReader: Loading plugin module...")

local MokuroParser = require("mokuroparser")

local MokuroReader = WidgetContainer:extend{
    name = "mokuro",
    is_doc_only = true,
    mokuro_data = nil,
    parser = nil,
    current_page = nil,
    enabled = true,
}

function MokuroReader:init()
    logger.info("MokuroReader: init() called")
    
    self.ui.menu:registerToMainMenu(self)
    self.parser = MokuroParser:new()
    
    logger.info("MokuroReader: Parser created")
    
    -- Hook into document ready
    self.onReaderReady = function()
        logger.info("MokuroReader: onReaderReady triggered")
        UIManager:scheduleIn(1, function()
            self:checkAndLoadMokuro()
        end)
    end
    
    logger.info("MokuroReader: init() complete")
end

function MokuroReader:registerTouchZones()
    logger.info("MokuroReader: Registering touch zones")
    
    self.ui:registerTouchZones({
        {
            id = "mokuro_tap",
            ges = "tap",
            screen_zone = {
                ratio_x = 0, ratio_y = 0, ratio_w = 1, ratio_h = 1,
            },
            overrides = {
                "tap_forward",
                "tap_backward",
            },
            handler = function(ges)
                return self:onMokuroTap(ges)
            end
        },
    })
    
    logger.info("MokuroReader: Touch zones registered!")
end

function MokuroReader:checkAndLoadMokuro()
    logger.info("MokuroReader: checkAndLoadMokuro() called")
    
    if not self.ui.document or not self.ui.document.file then
        logger.dbg("MokuroReader: No document file")
        return
    end
    
    local file_path = self.ui.document.file
    local ext = file_path:match("^.+%.([^.]+)$")
    
    if not ext or (ext:lower() ~= "cbz" and ext:lower() ~= "zip") then
        logger.dbg("MokuroReader: Not a CBZ file")
        return
    end
    
    logger.info("MokuroReader: CBZ detected, loading mokuro data")
    
    local success = self:loadMokuroData()
    
    if success then
        UIManager:show(InfoMessage:new{
            text = string.format(_("Mokuro: Loaded %d pages with OCR!"), #self.mokuro_data.pages),
            timeout = 5,
        })
        
        -- NOW register touch zones after data is loaded
        self:registerTouchZones()
    else
        logger.dbg("MokuroReader: No mokuro data in this CBZ")
    end
end

function MokuroReader:loadMokuroData()
    local file_path = self.ui.document.file
    logger.info("MokuroReader: loadMokuroData from:", file_path)
    
    -- Use KOReader's archiver module (supports all compression types)
    local Archiver = require("ffi/archiver")
    local reader = Archiver.Reader:new()
    
    -- Open the CBZ archive
    if not reader:open(file_path) then
        logger.warn("MokuroReader: Could not open CBZ:", reader.err or "unknown error")
        return false
    end
    
    -- Find the .mokuro file
    local mokuro_entry = nil
    for entry in reader:iterate() do
        if entry.path:match("%.mokuro$") and entry.mode == "file" then
            mokuro_entry = entry
            logger.info("MokuroReader: Found mokuro file:", entry.path)
            break
        end
    end
    
    if not mokuro_entry then
        logger.warn("MokuroReader: No .mokuro file found in CBZ")
        reader:close()
        return false
    end
    
    -- Read the .mokuro file content
    local content = reader:extractToMemory(mokuro_entry.path)
    reader:close()
    
    if not content or content == "" then
        logger.warn("MokuroReader: Could not read .mokuro file content")
        return false
    end
    
    -- Parse the JSON content
    self.mokuro_data = self.parser:parse(content)
    
    if self.mokuro_data then
        logger.info("MokuroReader: Loaded", #self.mokuro_data.pages, "pages")
        return true
    end
    
    return false
end

-- Function to remove spaces between CJK characters (like the patch)
local function strip_cjk_spaces(s)
    if not s then return s end
    -- Pattern matches CJK character + space + CJK character
    local pattern = "([\227-\239][\128-\191][\128-\191])%s+([\227-\239][\128-\191][\128-\191])"
    local result = s
    local count
    repeat
        result, count = result:gsub(pattern, "%1%2")
    until count == 0
    return result
end

function MokuroReader:onMokuroTap(ges)
    logger.info("MokuroReader: ✓✓✓ TAP DETECTED! ✓✓✓")
    
    if not self.mokuro_data or not self.enabled then
        logger.dbg("MokuroReader: Not active, passing through")
        return false
    end
    
    local page_no = self.ui:getCurrentPage()
    logger.info("MokuroReader: Current page:", page_no, "Tap at:", ges.pos.x, ges.pos.y)
    
    -- Get page data
    local page_data = self.parser:getPageData(self.mokuro_data, page_no)
    if not page_data or not page_data.blocks or #page_data.blocks == 0 then
        logger.dbg("MokuroReader: No text blocks on this page")
        return false
    end
    
    logger.info("MokuroReader: Page has", #page_data.blocks, "text blocks, checking tap position")
    
    -- Find which block was tapped
    local tapped_block = self:findBlockAtPosition(page_data, ges.pos)
    
    if not tapped_block then
        logger.dbg("MokuroReader: Tap not on any text block")
        return false  -- Let page turning work
    end
    
    -- Get the text from the tapped block
    local text = self.parser:getBlockText(tapped_block)
    
    if not text or text == "" then
        logger.warn("MokuroReader: Block has no text")
        return false
    end
    
    logger.info("MokuroReader: Showing text popup for tapped block")
    
    -- CRITICAL: Capture self references before creating callbacks
    -- Inside callbacks, 'self' will be mokuro_popup, not MokuroReader!
    local ui = self.ui
    local mokuro_popup  -- Forward declaration, will be set below
    
    -- Use ScrollTextWidget like DictQuickLookup does - it handles everything internally
    local ScrollTextWidget = require("ui/widget/scrolltextwidget")
    local BottomContainer = require("ui/widget/container/bottomcontainer")
    local FrameContainer = require("ui/widget/container/framecontainer")
    local InputContainer = require("ui/widget/container/inputcontainer")
    local Size = require("ui/size")
    local Blitbuffer = require("ffi/blitbuffer")
    local GestureRange = require("ui/gesturerange")
    local Geom = require("ui/geometry")
    local Device = require("device")
    local Screen = Device.screen
    local Event = require("ui/event")
    local Font = require("ui/font")
    
    -- Get user's preferred font size (default 48 for easy selection)
    local font_size = G_reader_settings:readSetting("mokuro_font_size") or 48
    
    -- Calculate dimensions (bottom 1/3 of screen like footnotes)
    local width = Screen:getWidth()
    local height = math.floor(Screen:getHeight() * 1/3)
    
    local padding = Size.padding.large
    local content_width = width - 2 * padding
    local content_height = height - 2 * padding
    
    -- Get font face
    local face = Font:getFace("cfont", font_size)
    
    -- Create the popup container first (we need it as parent for text_widget)
    mokuro_popup = InputContainer:new{
        modal = true,
    }
    self.mokuro_popup = mokuro_popup  -- Keep reference in MokuroReader too
    
    -- Create ScrollTextWidget (like DictQuickLookup does)
    -- ScrollTextWidget wraps TextBoxWidget internally and handles scrolling
    -- CRITICAL: dialog must point to the popup itself for proper event handling!
    -- Add padding spaces at the start to make first character selectable
    local padded_text = "  " .. text  -- Two spaces for easy tap on first char
    local text_widget = ScrollTextWidget:new{
        text = padded_text,
        face = face,
        width = content_width,
        height = content_height,
        dialog = mokuro_popup,  -- CRITICAL: parent is the popup
        justified = false,  -- CRITICAL: no justification for better CJK selection
        para_direction_rtl = false,
        auto_para_direction = false,
        alignment = "left",
        highlight_text_selection = true,  -- Enable text selection highlighting
    }
    
    -- Wrap in frame
    local frame = FrameContainer:new{
        background = Blitbuffer.COLOR_WHITE,
        bordersize = Size.border.window,
        padding = padding,
        margin = 0,
        text_widget,
    }
    
    -- Put in bottom container
    local bottom_container = BottomContainer:new{
        dimen = Screen:getSize(),
        frame,
    }
    
    -- Add the bottom_container to the popup we created earlier
    mokuro_popup[1] = bottom_container
    
    if Device:isTouchDevice() then
        local range = Geom:new{
            x = 0, y = 0,
            w = Screen:getWidth(),
            h = Screen:getHeight(),
        }
        
        local hold_pan_rate = G_reader_settings:readSetting("hold_pan_rate")
        if not hold_pan_rate then
            hold_pan_rate = Screen.low_pan_rate and 5.0 or 30.0
        end
        
        self.mokuro_popup.ges_events = {
            -- Tap outside to close
            TapClose = {
                GestureRange:new{
                    ges = "tap",
                    range = Geom:new{
                        x = 0, y = 0,
                        w = Screen:getWidth(),
                        h = Screen:getHeight(),
                    },
                },
            },
            -- All three Hold events are needed for text selection to work with TextBoxWidget!
            HoldStartText = {
                GestureRange:new{
                    ges = "hold",
                    range = range,
                },
            },
            HoldPanText = {
                GestureRange:new{
                    ges = "hold_pan",
                    range = range,
                    rate = hold_pan_rate,
                },
            },
            HoldReleaseText = {
                GestureRange:new{
                    ges = "hold_release",
                    range = range,
                },
            },
        }
        
        -- Connect gestures to the internal TextBoxWidget of ScrollTextWidget (like DictQuickLookup does)
        -- CRITICAL: ScrollTextWidget.text_widget is the internal TextBoxWidget that has the onHold methods!
        function self.mokuro_popup:onHoldStartText(_, ges)
            return text_widget.text_widget:onHoldStartText(_, ges)
        end
        
        function self.mokuro_popup:onHoldPanText(_, ges)
            return text_widget.text_widget:onHoldPanText(_, ges)
        end
        
        function self.mokuro_popup:onHoldReleaseText(_, ges)
            -- CRITICAL: callback is the FIRST parameter, ges is the second!
            return text_widget.text_widget:onHoldReleaseText(function(selected_text, hold_duration)
                if selected_text and selected_text ~= "" then
                    -- CRITICAL: Clean up CJK spaces before dictionary lookup!
                    local cleaned_text = strip_cjk_spaces(selected_text)
                    
                    logger.info("MokuroReader: Selected text:", selected_text)
                    logger.info("MokuroReader: Cleaned text:", cleaned_text)
                    
                    -- Close the popup first (use captured local variable)
                    UIManager:close(mokuro_popup)
                    
                    -- Trigger dictionary lookup (use captured local variable ui)
                    local lookup_target = hold_duration < require("ui/time").s(3) and "LookupWord" or "LookupWikipedia"
                    ui:handleEvent(
                        Event:new(lookup_target, cleaned_text)
                    )
                end
            end, ges)
        end
    end
    
    function self.mokuro_popup:onTapClose()
        UIManager:close(mokuro_popup)
        return true
    end
    
    UIManager:show(mokuro_popup)
    
    return true  -- Consume the tap
end

function MokuroReader:findBlockAtPosition(page_data, tap_pos)
    -- Get screen dimensions
    local Screen = require("device").screen
    local screen_w = Screen:getWidth()
    local screen_h = Screen:getHeight()
    
    -- Get image dimensions from mokuro
    local img_w = page_data.img_width
    local img_h = page_data.img_height
    
    -- Calculate how the image is scaled on screen
    -- KOReader fits the image to screen, so we need to calculate the scale
    local scale_w = screen_w / img_w
    local scale_h = screen_h / img_h
    local scale = math.min(scale_w, scale_h)  -- Fit to screen
    
    -- Calculate offsets (image is centered)
    local scaled_w = img_w * scale
    local scaled_h = img_h * scale
    local offset_x = (screen_w - scaled_w) / 2
    local offset_y = (screen_h - scaled_h) / 2
    
    logger.dbg(string.format("MokuroReader: Image %dx%d, Screen %dx%d, Scale %.3f, Offset %d,%d",
                            img_w, img_h, screen_w, screen_h, scale, offset_x, offset_y))
    
    -- Check each block
    for i, block in ipairs(page_data.blocks) do
        local box = block.box
        if box and #box >= 4 then
            -- Convert mokuro coordinates to screen coordinates
            local x1 = box[1] * scale + offset_x
            local y1 = box[2] * scale + offset_y
            local x2 = box[3] * scale + offset_x
            local y2 = box[4] * scale + offset_y
            
            -- Check if tap is inside this block
            if tap_pos.x >= x1 and tap_pos.x <= x2 and
               tap_pos.y >= y1 and tap_pos.y <= y2 then
                logger.info(string.format("MokuroReader: Found block %d at tap position", i))
                return block
            end
        end
    end
    
    logger.dbg("MokuroReader: No block found at tap position")
    return nil
end

function MokuroReader:addToMainMenu(menu_items)
    menu_items.mokuro = {
        text = _("Mokuro Reader"),
        sub_item_table = {
            {
                text = _("Enable Mokuro"),
                checked_func = function()
                    return self.enabled
                end,
                callback = function()
                    self.enabled = not self.enabled
                    UIManager:show(InfoMessage:new{
                        text = self.enabled and _("Mokuro enabled") or _("Mokuro disabled"),
                    })
                end,
            },
            {
                text = _("Font Size"),
                sub_item_table = {
                    {
                        text = _("Medium (32)"),
                        checked_func = function()
                            return G_reader_settings:readSetting("mokuro_font_size") == 32
                        end,
                        callback = function()
                            G_reader_settings:saveSetting("mokuro_font_size", 32)
                        end,
                    },
                    {
                        text = _("Large (48) - Default"),
                        checked_func = function()
                            local size = G_reader_settings:readSetting("mokuro_font_size")
                            return size == 48 or size == nil  -- Default
                        end,
                        callback = function()
                            G_reader_settings:saveSetting("mokuro_font_size", 48)
                        end,
                    },
                    {
                        text = _("Extra Large (64)"),
                        checked_func = function()
                            return G_reader_settings:readSetting("mokuro_font_size") == 64
                        end,
                        callback = function()
                            G_reader_settings:saveSetting("mokuro_font_size", 64)
                        end,
                    },
                    {
                        text = _("Huge (80)"),
                        checked_func = function()
                            return G_reader_settings:readSetting("mokuro_font_size") == 80
                        end,
                        callback = function()
                            G_reader_settings:saveSetting("mokuro_font_size", 80)
                        end,
                    },
                },
            },
            {
                text = _("Status"),
                callback = function()
                    local msg = self.mokuro_data and 
                        string.format(_("Loaded: %d pages"), #self.mokuro_data.pages) or
                        _("No mokuro data loaded")
                    UIManager:show(InfoMessage:new{
                        text = msg,
                    })
                end,
            },
            {
                text = _("About"),
                keep_menu_open = true,
                callback = function()
                    UIManager:show(InfoMessage:new{
                        text = _([[Mokuro Reader adds support for manga processed with mokuro OCR.

Tap on text bubbles to see the OCR'd text in a popup at the bottom.

Hold and drag your finger to select text, then release to look it up in your dictionaries.
For Japanese: Spaces between characters are automatically removed for proper dictionary lookup!

Font size can be adjusted in the Mokuro Reader menu.]]),
                        timeout = 10,
                    })
                end,
            },
        },
    }
end

function MokuroReader:onCloseDocument()
    self.mokuro_data = nil
    self.current_page = nil
    if self.mokuro_popup then
        UIManager:close(self.mokuro_popup)
        self.mokuro_popup = nil
    end
end

logger.info("MokuroReader: Module loaded successfully")

return MokuroReader
