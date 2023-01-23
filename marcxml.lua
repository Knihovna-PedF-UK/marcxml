kpse.set_program_name "luatex"
local xml_parser = require "luaxml-mod-xml"
local domobject = require "luaxml-domobject"




-- @param text -- MARCXML string
-- @param fn -- callback function that will be executed on each individual record
local function newload(text, fn) 
  local records = {}
  -- current record
  local current = {}
  -- number of current field 
  local current_field 
  -- current field that holds data
  local field = {}
  local handler = function()
    local obj = {}
    obj.starttag = function(self, name, attr)
      if name == "datafield" or name == "controlfield" then
        -- each numerical tag is used only once, multiple uses of the tag are saved as subtables
        current_field = attr["tag"]
        field = current[current_field] or {}
        if name == "controlfield" then
          -- we must initialize token for controlfield, as it doesn't have any child elements
          table.insert(field, {type="control"})
        end
      elseif name == "subfield" then
        table.insert(field, {type="subfield", code = attr["code"]})
      end
    end
    obj.endtag = function(self, name)
      if name == "record"  then
        -- process the closed record using optional function
        if fn then fn(current) end
        table.insert(records, current)
        current = {}
      elseif name == "datafield" or name == "controlfield" then
        -- save the current field
        current[current_field] = field
      end
    end
    obj.text = function(self, text)
      -- get the current field and save the text as an value
      local curr = field[#field]
      if curr then
        curr.value = text
      end

    end
    return obj
  end
  local parser = xml_parser.xmlParser(handler())
  parser:parse(text)
  return records
end

print "start"
local text = io.read("*all")

newload(text,function(rec)
  print "*****************"
  for tag,field in pairs(rec) do
    local t={}
    -- process subfileds
    for x,y in ipairs(field) do
      t[#t+1] = y.value
    end
    print(tag, table.concat(t, "; "))
  end
end)

-- pokus s DOMem - je to moc pomalý
-- print "parse xml"
-- local dom = domobject.parse(text)

-- print "start processing"
-- for i, rec in ipairs(dom:query_selector("record")) do
--   print(i,"***********")
--   for _, data in ipairs(rec:query_selector("controlfield,datafield")) do
--     local tag = data:get_attribute("tag")
--     local text
--     if data:get_element_name() == "datafield" then
--       text = ""
--       for _, sub in ipairs(data:query_selector("subfield")) do
--         local tag = sub:get_attribute("code") or ""
--         text = text ..  "(" .. tag .. ") " .. sub:get_text() .. " "
--       end
--     else 
--       text = data:get_text()
--     end

--     print(tag, text)
--   end

-- end

-- load(text, function(record)
-- end)
--

return {
  load = newload,
  mapping = mapping
}
