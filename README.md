# Knihovna pro zpracování MARCXML souborů z Almy


##  marcxmltotsv

Skript na převod MARCXML souboru na TSV. Jako parametr můžeme zadat šablonu ve formátu: `{číslo pole podpole:oddělovač}`. Několik podpolí oddělíme čárkou.

Příklad pro vypsání autora, názvu, vydavatele, roku vydání a ISBN:

    $ ./marcxmltotsv $'{100a};{700a:; }\t{245a,b,n,p}\t{260b}\t{260c}\t{020a}' < ~/Stažené/BIBLIOGRAPHIC_16353957890006986_1.xml

Používáme `$'...` aby se expandovaly tabulátory

- `{100a}` - vypíše obsah pole 100a
- `{700a:; }` - opakující se 700a oddělí středníkem a mezerou
- `{245a,b,n,p}` - vypíše podpole a, b, n, p

## Použití knihovny

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

