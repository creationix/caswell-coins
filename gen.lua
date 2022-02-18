local bit = require 'bit'
local lshift = bit.lshift

local nameTemplate = "BP/recipes/coin%s-%s.json"

local upTemplate = [[
{
    "format_version": "1.12",
    "minecraft:recipe_shapeless": {
        "description": { "identifier": "caswell:coin%s-%s" },
        "priority": %s,
        "tags": [ "crafting_table" ],
        "ingredients": [{
            "item": "caswell:coin%s",
            "count": %s
        }],
        "result": {
            "item": "caswell:coin%s"
        }
    }
}    
]]

local downTemplate = [[
{
    "format_version": "1.12",
    "minecraft:recipe_shapeless": {
        "description": { "identifier": "caswell:coin%s-%s" },
        "priority": %s,
        "tags": [ "crafting_table" ],
        "ingredients": [{ "item": "caswell:coin%s" }],
        "result": {
            "item": "caswell:coin%s",
            "count": %s
        }
    }
}    
]]

local fs = require('fs')

for power = 0, 7 do
    local from = lshift(1,power)
    for up = power+1, math.min(power + 2, 7) do
        local to = lshift(1,up)
        local count = to/from
        local priority = (up-power)*2-1
        local filename = string.format(nameTemplate, from, to)
        local file = string.format(upTemplate, from, to, priority, from, count, to)
        p(filename)
        print(file)
        assert(fs.writeFileSync(filename, file))
    end
    for down = power-1, math.max(power - 2, 0),-1 do
        local to = lshift(1,down)
        local count = from/to
        local priority = (power-down)*2
        local filename = string.format(nameTemplate, from, to)
        local file = string.format(downTemplate, from, to, priority, from, to, count)
        p(filename)
        print(file)
        assert(fs.writeFileSync(filename, file))
    end
end