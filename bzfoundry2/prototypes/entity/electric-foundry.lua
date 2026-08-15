require("util")
local futil = require("data-util")
require ("sound-util")
require ("circuit-connector-sprites")
local hit_effects = require("__base__.prototypes.entity.hit-effects")
local sounds = require("__base__.prototypes.entity.sounds")

local graphics_set
local graphics_path = mods["bzfoundry2-sagraphics"] and "__bzfoundry2-sagraphics__" or "__bzfoundry2__"
local sound_set
local circuit_connector

if mods["bzfoundry2-sagraphics"] then
    circuit_connector = circuit_connector_definitions["foundry"]
    graphics_set = require("__bzfoundry2-sagraphics__/foundry-pictures").graphics_set
    sound_set = require("__bzfoundry2-sagraphics__/foundry-sounds")
else
    circuit_connector = circuit_connector_definitions.create_vector
    (
        universal_connector_template,
        {
            { variation = 2, main_offset = util.by_pixel( 40, 6), shadow_offset = util.by_pixel( 43, 8), show_shadow = false },
            { variation = 2, main_offset = util.by_pixel( 40, 6), shadow_offset = util.by_pixel( 43, 8), show_shadow = false },
            { variation = 2, main_offset = util.by_pixel( 40, 6), shadow_offset = util.by_pixel( 43, 8), show_shadow = false },
            { variation = 2, main_offset = util.by_pixel( 40, 6), shadow_offset = util.by_pixel( 43, 8), show_shadow = false }
        }
    )
    graphics_set = {
    animation =
    {
      layers =
      {
        {
          filename = "__bzfoundry2__/graphics/entity/electric-foundry/hr-electric-foundry.png",
          priority = "high",
          width = 280,
          height = 239,
          frame_count = 1,
          shift = util.by_pixel(8, 4),
          scale = 0.5,
        },
      }
    },
    working_visualisations =
    {
      {
        north_position = {0.0, 0.0},
        east_position = {0.0, 0.0},
        south_position = {0.0, 0.0},
        west_position = {0.0, 0.0},
        animation =
        {
          filename = "__bzfoundry2__/graphics/entity/electric-foundry/hr-electric-foundry-animation.png",
          priority = "extra-high",
          animation_speed = 0.05,
          line_length = 4,
          width = 280,
          height = 239,
          frame_count = 4,
          axially_symmetrical = false,
          direction_count = 1,
          shift = util.by_pixel(8, 4),
          scale = 0.5
        },
      },
      {
        fadeout = true,
        --draw_as_light = true,
        effect = "flicker",
        animation =
        {
          filename = "__bzfoundry2__/graphics/entity/electric-foundry/electric-foundry-glow.png",
          priority = "extra-high",
          draw_as_glow=true,
          width = 25,
          height = 29,
          frame_count = 1,
          shift = util.by_pixel(0, 36),
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
      },
    }
    }
    sound_set = {sound = { filename = "__base__/sound/electric-furnace.ogg" }} 
end
    
data:extend({
  {
    type = "assembling-machine",
    name = "electric-foundry",
    icon = graphics_path .. "/graphics/icons/electric-foundry.png",
    icon_size = mods["bzfoundry2-sagraphics"] and 64 or 128,
    flags = {"placeable-neutral","player-creation"},
    minable = {mining_time = 0.2, result = "electric-foundry"},
    max_health = 300,
    fast_replaceable_group = "foundry",
    corpse = mods["bzfoundry2-sagraphics"] and "electric-foundry-remnants" or "medium-small-remnants",
    dying_explosion = mods["bzfoundry2-sagraphics"] and "foundry-explosion" or nil,
    circuit_wire_max_distance = assembling_machine_circuit_wire_max_distance,
    circuit_connector = circuit_connector,
    collision_box = {{-1.7, -1.7}, {1.7, 1.7}},
    selection_box = {{-2, -2}, {2, 2}},
    crafting_categories = {"founding", futil.me.smelt() and "smelting" or nil},
    energy_usage = "360kW",
    drain = "12kW",
    crafting_speed = 4,
    energy_source =
    {
      type = "electric",
      emissions_per_minute = { pollution = 2 },
      usage_priority = "secondary-input",
    },
    allowed_effects = {"consumption", "speed", "productivity", "pollution", "quality"},
    damaged_trigger_effect = hit_effects.entity(),
    drawing_box_vertical_extension = 1.3,
    module_slots = 3,
    icon_draw_specification = {scale = 2, shift = {0, -0.3}},
    icons_positioning =
    {
      {inventory_index = defines.inventory.assembling_machine_modules, shift = {0, 1.25}}
    },
    perceived_performance = {minimum = 0.25, maximum = 20},
    graphics_set = graphics_set,
    open_sound = sounds.steam_open,
    close_sound = sounds.steam_close,
    working_sound = sound_set
    
  }
})

futil.add_crafting_category("assembling-machine", "electric-foundry", "basic-founding")
