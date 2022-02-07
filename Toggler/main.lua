-- Reference of all available actions
-- https://github.com/xournalpp/xournalpp/blob/b5643c2e39b54e165f22e0f53c53e7f7a643424a/src/core/enums/ActionType.enum.h

-- Register all Toolbar actions and intialize all UI stuff
function initUi()
    app.registerUi({["callback"] = "togglePen", ["accelerator"] = "<Alt>1"});
    app.registerUi({["callback"] = "toolSizeIncrease", ["accelerator"] = "<Alt>2"});
    app.registerUi({["callback"] = "toolSizeDecrease", ["accelerator"] = "<Alt>3"});
    app.registerUi({["callback"] = "toggleSelector", ["accelerator"] = "<Alt>4"});
    app.registerUi({["callback"] = "toggleShapes", ["accelerator"] = "<Alt>5"});
    app.registerUi({["callback"] = "toggleLineStyle", ["accelerator"] = "<Alt>6"});
end


SELECTORS = {
    {'selectObject', 'ACTION_TOOL_SELECT_OBJECT'},
    {'selectRect', 'ACTION_TOOL_SELECT_RECT'}
}

SHAPES = {
    {'default', '**CLEAR**'},
    {'rectangle', 'ACTION_TOOL_DRAW_RECT'},
    {'ellipse', 'ACTION_TOOL_DRAW_ELLIPSE'},
    -- {'line', 'ACTION_TOOL_DRAW_???'},     -- can't find the action API
    {'arrow', 'ACTION_TOOL_DRAW_ARROW'}
}

BRUSH_SIZES = {
    {'veryThin', 'ACTION_SIZE_VERY_FINE'},
    {'thin', 'ACTION_SIZE_FINE'},
    {'medium', 'ACTION_SIZE_MEDIUM'},
    {'thick', 'ACTION_SIZE_THICK'},
    {'veryThick', 'ACTION_SIZE_VERY_THICK'}
}

TOOLS = {
    {'pen', 'ACTION_TOOL_PEN'},
    {'eraser', 'ACTION_TOOL_ERASER'}
}

LINE_STYLES = {
    {'plain', 'ACTION_TOOL_LINE_STYLE_PLAIN'},
    {'dash', 'ACTION_TOOL_LINE_STYLE_DASH'},
    {'dashdot', 'ACTION_TOOL_LINE_STYLE_DASH_DOT'},
    {'dot', 'ACTION_TOOL_LINE_STYLE_DOT'}
}


-- Makeshift timer function
function getTime()
    return os.time() + os.clock()
end

function togglePen()
    local DELTA = 0.3
    local deltaTime

    if lastPressTime ~= nil then
        deltaTime = getTime() - lastPressTime
    end

    if deltaTime ~= nil and deltaTime < DELTA then
        app.uiAction({["action"]="ACTION_TOOL_HAND"})
    else
        local currentTool = app.getToolInfo('active')['type']
        local newTool = toggler(currentTool, TOOLS)
        app.uiAction({["action"]=newTool})
    end
    lastPressTime = getTime()
end

function toggleSelector()
    local currentSelector = app.getToolInfo('active')['type']
    local newSelector = toggler(currentSelector, SELECTORS)
    app.uiAction({["action"]=newSelector})
end

function toggleShapes()
    local currentShape = app.getToolInfo('active')['drawingType']
    local newShape = toggler(currentShape, SHAPES)
    if newShape ~= '**CLEAR**' then
        app.uiAction({["action"]=newShape})
    else
        -- Simple hacky way to disable tool from any tool
        app.uiAction({["action"]='ACTION_TOOL_DRAW_RECT'})
        app.uiAction({["action"]='ACTION_TOOL_DRAW_RECT', ['enabled']=false})
    end
end

function toggleLineStyle()
    local currentStyle = app.getToolInfo('active')['lineStyle']
    local newStyle = toggler(currentStyle, LINE_STYLES)
    app.uiAction({["action"]=newStyle})
end


function toggler(kw, table, ...)

    local decrease, cycle
    if ... ~= nil then
        local t = ...
        decrease, cycle = t.decrease, t.cycle
    end
    if decrease == nil then           -- "decrease" option defaults to false
        decrease = false
    end
    if cycle == nil then              -- "cycle" option defaults to true
        cycle = true
    end


    local length = 0                  -- python: "length = len(table)"
    local index = 0                   -- pytoon: "index = list(table.keys()).index(kw)"
    for i,pair in ipairs(table) do
        if kw == pair[1] then
            index = i
        end
        length = length + 1
    end

    if decrease then
        index = index - 1
    else
        index = index + 1
    end

    -- if cycle is true, wrap back to the other end, else just stay at the start/end index
    if cycle then
        index = (index - 1) % length + 1
    else
        if index < 1 then
            index = 1
        elseif index > length then
            index = length
        end
    end

    return table[index][2]
end

function toolSizeDecrease()
    local currentSize = app.getToolInfo('active')['size']['name']
    local newSize = toggler(currentSize, BRUSH_SIZES, {decrease=false, cycle=false})
    app.uiAction({["action"] = newSize})
end

function toolSizeIncrease()
    local currentSize = app.getToolInfo('active')['size']['name']
    local newSize = toggler(currentSize, BRUSH_SIZES, {decrease=true, cycle=false})
    app.uiAction({["action"] = newSize})
end


-- Useful functions for debugging
-- https://gist.github.com/jubnzv/1c97bc120910c4e6aaa2bff4df073219
function table_to_string(tbl)
    local result = "{"
    for k, v in pairs(tbl) do
        -- Check the key type (ignore any numerical keys - assume its an array)
        if type(k) == "string" then
            result = result.."[\""..k.."\"]".."="
        end

        -- Check the value type
        if type(v) == "table" then
            result = result..table_to_string(v)
        elseif type(v) == "boolean" then
            result = result..tostring(v)
        else
            result = result.."\""..v.."\""
        end
        result = result..","
    end
    -- Remove leading commas from the result
    if result ~= "" then
        result = result:sub(1, result:len()-1)
    end
    return result.."}"
end
