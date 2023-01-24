# Knihovna pro zpracování MARCXML souborů z Almy

## Použití




```
kpse.set_program_name "luatex"
local marcxml = require "marcxml"
local text = io.read("*all")

-- the function in the second argument process each bib record
-- once it is loaded
marcxml.load(text,function(rec)
  print "*****************"
  -- record contains tag numbers and table with fields
  for tag,field in pairs(rec) do
    local t={}
    -- process subfileds
    -- each field contans subfields
    for x,y in ipairs(field) do
      t[#t+1] = y.value
    end
    print(tag, table.concat(t, "; "))
  end
end)
```

