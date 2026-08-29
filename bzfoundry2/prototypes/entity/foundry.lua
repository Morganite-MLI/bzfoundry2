require("util")
local futil = require("data-util")
local meld = require("meld")

local graphics_path = mods["bzfoundry2-sagraphics"] and "__bzfoundry2-sagraphics__" or "__bzfoundry2__"

local fuel = {"chemical"}
if mods.Krastorio2 then table.insert(fuel, "kr-vehicle-fuel") end
if mods["aai-industry"] then table.insert(fuel, "processed-chemical") end

local foundry = table.deepcopy(data.raw["assembling-machine"]["electric-foundry"])
meld(foundry, {
  name = "foundry",
  next_upgrade = "electric-foundry",
  icon = graphics_path .. "/graphics/icons/foundry.png",
  icon_size = 64,
  minable = {mining_time = 0.2, result = "foundry"},
  corpse = mods["bzfoundry2-sagraphics"] and "foundry-remnants" or "medium-small-remnants",
  energy_usage = "180kW",
  energy_source = {
    type = "burner",
    fuel_categories = fuel,
    effectivity = 1,
    emissions_per_minute = { pollution = 8 },
    fuel_inventory_size = 1,
    smoke =
    {
      {
        name = "smoke",
        frequency = 20,
        position = {1, -1.7},
        starting_vertical_speed = 0.1,
        starting_frame_deviation = 60
      }
    }
  },
})

if mods["bzfoundry2-sagraphics"] then
  foundry.graphics_set.animation.layers[1].filenames = {
    "__bzfoundry2-sagraphics__/graphics/entity/foundry/foundry-main-1.png",
    "__bzfoundry2-sagraphics__/graphics/entity/foundry/foundry-main-2.png"
  }
else
  foundry.working_sound = {sound = { filename = "__base__/sound/furnace.ogg" }}
  foundry.graphics_set = {
    animation =
    {
      layers =
      {
        {
          filename = "__bzfoundry2__/graphics/entity/foundry/hr-foundry.png",
          priority = "high",
          width = 280,
          height = 239,
          frame_count = 1,
          shift = util.by_pixel(8, 4),
          scale = 0.5
        }
      }
    },
    working_visualisations =
      {
        {
          fadeout = true,
          effect = "flicker",
          animation =
          {
            layers =
            {
              {
                filename = "__base__/graphics/entity/stone-furnace/stone-furnace-fire.png",
                priority = "extra-high",
                line_length = 8,
                width = 41,
                height = 100,
                frame_count = 48,
                shift = util.by_pixel(-1, 9),
                scale = 1.1,
                draw_as_glow = true;
              }
            }
          }
        },
      {
        fadeout = true,
        effect = "flicker",
        animation =
        {
          filename = "__base__/graphics/entity/steel-furnace/steel-furnace-ground-light.png",
          priority = "high",
          line_length = 1,
          draw_as_light = true,
          width = 152,
          height = 126,
          shift = util.by_pixel(1, 72),
          blend_mode = "additive",
          scale = 0.5
        },
      }
      }
  }
end

data:extend({foundry})

futil.add_crafting_category("assembling-machine", "foundry", "basic-founding")
