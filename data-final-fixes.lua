function MakeProjectile(ThingData)
  
TheProjectile = table.deepcopy(data.raw.stream["acid-stream-spitter-small"])
	TheProjectile.name = ThingData.name.."-projectileFromRenaiTransportation"
	TheProjectile.special_neutral_target_damage = {amount = 0, type = "acid"}
	--TheProjectile.scale = 5     --does nothing as far as i can tell
	--TheProjectile.particle_buffer_size = 90
    TheProjectile.particle_spawn_interval = 0
    TheProjectile.particle_spawn_timeout = 0
    TheProjectile.particle_vertical_acceleration = 0.0035 -- gravity, default 0.0045
	if (ThingData.name == "MaybeIllBeTracer") then
		TheProjectile.particle_horizontal_speed = 10
		TheProjectile.shadow = nil
	else
	    TheProjectile.particle_horizontal_speed = 0.18 -- speed, default 0.3375
	end

    TheProjectile.particle_horizontal_speed_deviation = 0
    --TheProjectile.particle_start_alpha = 0.5
    --TheProjectile.particle_end_alpha = 1
    --TheProjectile.particle_alpha_per_part = 0.8
    --TheProjectile.particle_scale_per_part = 0.8
    --TheProjectile.particle_loop_frame_count = 15
    --TheProjectile.particle_fade_out_duration = 2
    --TheProjectile.particle_loop_exit_threshold = 0.25
	
	TheProjectile.working_sound = nil
	
	TheProjectile.initial_action =
	  {
		type = "direct",
		action_delivery =
		{
		  type = "instant",
		  target_effects =
		  {
			{
			  type = "script",
			  effect_id = ThingData.name.."-LandedRT"
			}
		  }
		}
	  }
	  
if (ThingData.icons) then
	if (ThingData.icon_size) then
		TheProjectile.particle.size = ThingData.icon_size
	else
		TheProjectile.particle.size = ThingData.icons[1].icon_size
	end
	
	TheProjectile.particle.layers = {}
	for iconlayer, iconspecs in pairs(ThingData.icons) do
		if (iconspecs.icon_size) then
			eeee = iconspecs.icon_size
		else
			eeee = TheProjectile.particle.size
		end
		
		if (iconspecs.tint) then
			rrrr = iconspecs.tint
		else
			rrrr = nil
		end
	
		table.insert(TheProjectile.particle.layers, 
			{
				filename = iconspecs.icon,
				line_length = 1,
				frame_count = 1,
				priority = "high",
				scale = 19.2/eeee,
				size = eeee,
				tint = rrrr
			})
	end
	
elseif (ThingData.icon) then
	TheProjectile.particle = {
      filename = ThingData.icon,
      line_length = 1,
      width = ThingData.icon_size,
      height = ThingData.icon_size,
      frame_count = 1,
      --shift = util.mul_shift(util.by_pixel(-2, 30), data.scale),
      --tint = data.tint,
      priority = "high",
      scale = 19.2/ThingData.icon_size --0.3 of a tile
      --animation_speed = 1,
    }
else
	TheProjectile.particle = {
      filename = "__RenaiTransportation__/graphics/icon.png",
      line_length = 1,
      width = 32,
      height = 32,
      frame_count = 1,
      --shift = util.mul_shift(util.by_pixel(-2, 30), data.scale),
      --tint = data.tint,
      priority = "high",
      scale = 19.2/32 --0.3 of a tile
      --animation_speed = 1,
    }
end	
	
	TheProjectile.spine_animation = nil

	data:extend({TheProjectile})
end


function MakePrimedProjectile(ThingData)-------------------------------------------
  
TheProjectile = table.deepcopy(data.raw.stream["acid-stream-spitter-small"])
	TheProjectile.name = ThingData.name.."-projectileFromRenaiTransportationPrimed"
	TheProjectile.special_neutral_target_damage = {amount = 0, type = "acid"}
    TheProjectile.particle_spawn_interval = 0
    TheProjectile.particle_spawn_timeout = 0
    TheProjectile.particle_vertical_acceleration = 0.004 -- gravity, default 0.0045
    TheProjectile.particle_horizontal_speed = 0.3 -- speed, default 0.3375
    TheProjectile.particle_horizontal_speed_deviation = 0
	TheProjectile.working_sound = nil
	
	if (ThingData.ammo_type and ThingData.ammo_type.category == "cannon-shell") then -- tank shells
		TheProjectile.initial_action = data.raw.projectile[ThingData.ammo_type.action.action_delivery.projectile].final_action
		  
	elseif (ThingData.capsule_action) then --capsules with thrown actions: grenades, combat robots, poison, slowdown
		if (ThingData.capsule_action.attack_parameters.ammo_type.action[1]) then
			TheProjectile.initial_action = data.raw.projectile[ThingData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile].action
		elseif (ThingData.capsule_action.attack_parameters.ammo_type.action) then
			TheProjectile.initial_action = data.raw.projectile[ThingData.capsule_action.attack_parameters.ammo_type.action.action_delivery.projectile].action
		end
	elseif (data.raw["land-mine"][ThingData.place_result]) then  --landmines
		TheProjectile.initial_action = 
		  {
			type = "direct",
			action_delivery =
			{
			  type = "instant",
			  target_effects =
			  {
				{
				  type = "create-entity",
				  entity_name = ThingData.place_result --ThingData.name
				}
			  }
			}
		  }
		  
	elseif (ThingData.ammo_type.action.action_delivery.type == "artillery") then -- artillery
		TheProjectile.initial_action = data.raw["artillery-projectile"][ThingData.ammo_type.action.action_delivery.projectile].action
		
	else -- rockets/atomic bombs/other
		TheProjectile.initial_action = data.raw.projectile[ThingData.ammo_type.action.action_delivery.projectile].action
		 
	end
	
if (ThingData.icons) then
	if (ThingData.icon_size) then
		TheProjectile.particle.size = ThingData.icon_size
	else
		TheProjectile.particle.size = ThingData.icons[1].icon_size
	end
	
	TheProjectile.particle.layers = {}
	for iconlayer, iconspecs in pairs(ThingData.icons) do
		if (iconspecs.icon_size) then
			eeee = iconspecs.icon_size
		else
			eeee = TheProjectile.particle.size
		end
	
		table.insert(TheProjectile.particle.layers, 
			{
				filename = iconspecs.icon,
				line_length = 1,
				frame_count = 1,
				priority = "high",
				scale = 19.2/eeee,
				size = eeee,
				tint = {255,70,70}
			})
	end
else
	TheProjectile.particle = {
      filename = ThingData.icon,
      line_length = 1,
      width = ThingData.icon_size,
      height = ThingData.icon_size,
      frame_count = 1,
	  tint = {255,70,70},
      --shift = util.mul_shift(util.by_pixel(-2, 30), data.scale),
      priority = "high",
      scale = 19.2/ThingData.icon_size --0.3
      --animation_speed = 1,
    }
end	
	TheProjectile.spine_animation = nil

	data:extend({TheProjectile})
end

---------------------------------------Thrower----------------------------------------------------------------------
function MakeThrowerVariant(ThingData)

TheItem = table.deepcopy(data.raw.item[ThingData.minable.result])
	TheItem.name = "RTThrower-"..TheItem.name.."-Item"
	TheItem.subgroup = "throwers"
	TheItem.place_result = "RTThrower-"..ThingData.name
	if (TheItem.icon) then
		TheItem.icons =
			{
				{
				icon = TheItem.icon,
				icon_size = TheItem.icon_size,
				icon_mipmaps = TheItem.icon_mipmaps
				},
				
				{
				icon = "__RenaiTransportation__/graphics/ThrowerInserter/overlay.png",
				icon_size = 64,
				icon_mipmaps = 4
				}
			}
	else
		table.insert(TheItem.icons, {icon = "__RenaiTransportation__/graphics/ThrowerInserter/overlay.png",	icon_size = 64, icon_mipmaps = 4})
	end

if (ThingData.name == "inserter" or ThingData.name == "burner-inserter") then
	isitenabled = true
else
	isitenabled = false
end
TheRecipe = 
	{
		type = "recipe",
		name = "RTThrower-"..ThingData.name.."-Recipe",
		enabled = isitenabled,
		energy_required = 1,
		ingredients = 
			{
				{ThingData.minable.result, 1},
				{"copper-cable", 4}
			},
		result = TheItem.name
	}

TheThrower = table.deepcopy(data.raw.inserter[ThingData.name])
	TheThrower.name = "RTThrower-"..ThingData.name
	TheThrower.minable = {mining_time = 0.1, result = TheItem.name}
	TheThrower.localised_name ="Thrower "..ThingData.name
	TheThrower.insert_position = {0, 14.9}
	TheThrower.allow_custom_vectors = true
	ItsRange = 15
	
	if (TheThrower.energy_per_rotation) then
		TheThrower.energy_per_movement = "1J" -- this prevents inserters from elongating first and then rotating when energy is low
	end

	if (TheThrower.name == "RTThrower-inserter") then
	    TheThrower.extension_speed = 0.027 -- default 0.03, needs to be a but slower so we don't get LongB0is
		TheThrower.rotation_speed = 0.020 -- default 0.014
	elseif (TheThrower.name == "RTThrower-long-handed-inserter") then
		TheThrower.insert_position = {0, 24.9}
		ItsRange = 25
	end
	
	if (TheThrower.localised_description) then
		TheThrower.localised_description = {"test.combo", "This inserter has been re-wired to throw items "..ItsRange.." tiles through the air. Range can be configured once researched using Interact (default F).", TheThrower.localised_description}
	else
		TheThrower.localised_description = "This inserter has been re-wired to throw items "..ItsRange.." tiles through the air. Range can be configured once researched using Interact (default F)."
	end	
	TheThrower.hand_size = 0
	TheThrower.hand_base_picture = 
		{
		filename = "__RenaiTransportation__/graphics/ThrowerInserter/hr-inserter-hand-base.png",
        priority = "extra-high",
        width = 32,
        height = 136,
        scale = 0.25
		}
	TheThrower.hand_closed_picture = 
		{
		filename = "__RenaiTransportation__/graphics/ThrowerInserter/hr-inserter-hand-closed.png",
        priority = "extra-high",
        width = 72,
        height = 164,
        scale = 0.25
		}
	TheThrower.hand_open_picture =
		{
		filename = "__RenaiTransportation__/graphics/ThrowerInserter/hr-inserter-hand-open.png",
        priority = "extra-high",
        width = 72,
        height = 164,
        scale = 0.25
		}
data:extend({TheThrower, TheItem, TheRecipe})
if (isitenabled == false) then
	table.insert(data.raw["technology"]["RTThrowerTime"].effects,{type="unlock-recipe",recipe=TheRecipe.name})	
end
end

----- Get the sprites of the carriage to use during a jump
function MakeCarriageSprites(ThingData)
	if (ThingData.pictures and ThingData.pictures.layers) then
		local UpSprites = {{
							filename = "__RenaiTransportation__/graphics/TrainRamp/trains/base/WheelsVertical.png",
							size = {200,500},
							scale = 0.5,
							tint = {0.5, 0.5, 0.5}
						  }}
		local RightSprites = {{
							filename = "__RenaiTransportation__/graphics/TrainRamp/trains/base/WheelsHorizontal.png",
							size = {500,200},
							shift = {0,-0.5},
							scale = 0.5,
							tint = {0.5, 0.5, 0.5}
							}}
		local DownSprites = {{
							filename = "__RenaiTransportation__/graphics/TrainRamp/trains/base/WheelsVertical.png",
							size = {200,500},
							scale = 0.5,
							tint = {0.5, 0.5, 0.5}
							}}
		local LeftSprites = {{
							filename = "__RenaiTransportation__/graphics/TrainRamp/trains/base/WheelsHorizontal.png",
							size = {500,200},
							shift = {0,-0.5},
							scale = 0.5,
							tint = {0.5, 0.5, 0.5}
							}}
		local MaskUpSprites = {}
		local MaskRightSprites = {}
		local MaskDownSprites = {}
		local MaskLeftSprites = {}
		-- local SpriteSize = {1,1}
		-- local SpriteScale = 1
		
		for each, SpriteSet in pairs(ThingData.pictures.layers) do
			if ((SpriteSet.flags == nil or (SpriteSet.flags and SpriteSet.flags[1] ~= "mask" and SpriteSet.flags[1] ~= "shadow")) and SpriteSet.draw_as_shadow == nil) then  -- carriage "body" sprite
				if (SpriteSet.hr_version and SpriteSet.hr_version.filenames and (SpriteSet.hr_version.line_length*SpriteSet.hr_version.lines_per_file)%4 == 0) then
					if (SpriteSet.hr_version.back_equals_front ~= true) then
						UpSprites[each+1] = {filename = SpriteSet.hr_version.filenames[1+0], 
											x = SpriteSet.hr_version.width*(0%SpriteSet.hr_version.line_length), 
											y = SpriteSet.hr_version.height*math.floor((0%(SpriteSet.hr_version.line_length*SpriteSet.hr_version.lines_per_file))/SpriteSet.hr_version.line_length), 
											size = {SpriteSet.hr_version.width, SpriteSet.hr_version.height}, 
											scale = SpriteSet.hr_version.scale, 
											shift = SpriteSet.hr_version.shift}
						RightSprites[each+1] = {filename = SpriteSet.hr_version.filenames[1+math.floor(0.25*#SpriteSet.hr_version.filenames)], 
											x = SpriteSet.hr_version.width*((0.25*#SpriteSet.hr_version.filenames*SpriteSet.hr_version.line_length*SpriteSet.hr_version.lines_per_file)%SpriteSet.hr_version.line_length), 
											y = SpriteSet.hr_version.height*math.floor(((0.25*#SpriteSet.hr_version.filenames*SpriteSet.hr_version.line_length*SpriteSet.hr_version.lines_per_file)%(SpriteSet.hr_version.line_length*SpriteSet.hr_version.lines_per_file))/SpriteSet.hr_version.line_length), 
											size = {SpriteSet.hr_version.width, SpriteSet.hr_version.height}, 
											scale = SpriteSet.hr_version.scale, 
											shift = SpriteSet.hr_version.shift}
						DownSprites[each+1] = {filename = SpriteSet.hr_version.filenames[1+math.floor(0.5*#SpriteSet.hr_version.filenames)], 
											x = SpriteSet.hr_version.width*((0.5*#SpriteSet.hr_version.filenames*SpriteSet.hr_version.line_length*SpriteSet.hr_version.lines_per_file)%SpriteSet.hr_version.line_length), 
											y = SpriteSet.hr_version.height*math.floor(((0.5*#SpriteSet.hr_version.filenames*SpriteSet.hr_version.line_length*SpriteSet.hr_version.lines_per_file)%(SpriteSet.hr_version.line_length*SpriteSet.hr_version.lines_per_file))/SpriteSet.hr_version.line_length), 
											size = {SpriteSet.hr_version.width, SpriteSet.hr_version.height}, 
											scale = SpriteSet.hr_version.scale, 
											shift = SpriteSet.hr_version.shift}
						LeftSprites[each+1] = {filename = SpriteSet.hr_version.filenames[1+math.floor(0.75*#SpriteSet.hr_version.filenames)], 
											x = SpriteSet.hr_version.width*((0.75*#SpriteSet.hr_version.filenames*SpriteSet.hr_version.line_length*SpriteSet.hr_version.lines_per_file)%SpriteSet.hr_version.line_length), 
											y = SpriteSet.hr_version.height*math.floor(((0.75*#SpriteSet.hr_version.filenames*SpriteSet.hr_version.line_length*SpriteSet.hr_version.lines_per_file)%(SpriteSet.hr_version.line_length*SpriteSet.hr_version.lines_per_file))/SpriteSet.hr_version.line_length), 
											size = {SpriteSet.hr_version.width, SpriteSet.hr_version.height}, 
											scale = SpriteSet.hr_version.scale, 
											shift = SpriteSet.hr_version.shift}
					else
						UpSprites[each+1] = {filename = SpriteSet.hr_version.filenames[1+0], 
											x = SpriteSet.hr_version.width*(0%SpriteSet.hr_version.line_length), 
											y = SpriteSet.hr_version.height*math.floor((0%(SpriteSet.hr_version.line_length*SpriteSet.hr_version.lines_per_file))/SpriteSet.hr_version.line_length), 
											size = {SpriteSet.hr_version.width, SpriteSet.hr_version.height}, 
											scale = SpriteSet.hr_version.scale, 
											shift = SpriteSet.hr_version.shift}
						RightSprites[each+1] = {filename = SpriteSet.hr_version.filenames[1+math.floor(0.5*#SpriteSet.hr_version.filenames)], 
											x = SpriteSet.hr_version.width*((0.5*#SpriteSet.hr_version.filenames*SpriteSet.hr_version.line_length*SpriteSet.hr_version.lines_per_file)%SpriteSet.hr_version.line_length), 
											y = SpriteSet.hr_version.height*math.floor(((0.5*#SpriteSet.hr_version.filenames*SpriteSet.hr_version.line_length*SpriteSet.hr_version.lines_per_file)%(SpriteSet.hr_version.line_length*SpriteSet.hr_version.lines_per_file))/SpriteSet.hr_version.line_length), 
											size = {SpriteSet.hr_version.width, SpriteSet.hr_version.height}, 
											scale = SpriteSet.hr_version.scale, 
											shift = SpriteSet.hr_version.shift}
						DownSprites[each+1] = {filename = UpSprites[each+1].filename, x = UpSprites[each+1].x, y = UpSprites[each+1].y, size = {SpriteSet.hr_version.width, SpriteSet.hr_version.height}, scale = SpriteSet.hr_version.scale, shift = SpriteSet.hr_version.shift}
						LeftSprites[each+1] = {filename = RightSprites[each+1].filename, x = RightSprites[each+1].x, y = RightSprites[each+1].y, size = {SpriteSet.hr_version.width, SpriteSet.hr_version.height}, scale = SpriteSet.hr_version.scale, shift = SpriteSet.hr_version.shift}
					end
					
				elseif (SpriteSet.filenames and (SpriteSet.line_length*SpriteSet.lines_per_file)%4 == 0) then
					if (SpriteSet.back_equals_front ~= true) then
						UpSprites[each+1] = {filename = SpriteSet.filenames[1+0], 
											x = SpriteSet.width*(0%SpriteSet.line_length), 
											y = SpriteSet.height*math.floor((0%(SpriteSet.line_length*SpriteSet.lines_per_file))/SpriteSet.line_length), 
											size = {SpriteSet.width, SpriteSet.height}, 
											scale = SpriteSet.scale, 
											shift = SpriteSet.shift}
						RightSprites[each+1] = {filename = SpriteSet.filenames[1+math.floor(0.25*#SpriteSet.filenames)], 
											x = SpriteSet.width*((0.25*#SpriteSet.filenames*SpriteSet.line_length*SpriteSet.lines_per_file)%SpriteSet.line_length), 
											y = SpriteSet.height*math.floor(((0.25*#SpriteSet.filenames*SpriteSet.line_length*SpriteSet.lines_per_file)%(SpriteSet.line_length*SpriteSet.lines_per_file))/SpriteSet.line_length), 
											size = {SpriteSet.width, SpriteSet.height}, 
											scale = SpriteSet.scale, 
											shift = SpriteSet.shift}
						DownSprites[each+1] = {filename = SpriteSet.filenames[1+math.floor(0.5*#SpriteSet.filenames)], 
											x = SpriteSet.width*((0.5*#SpriteSet.filenames*SpriteSet.line_length*SpriteSet.lines_per_file)%SpriteSet.line_length), 
											y = SpriteSet.height*math.floor(((0.5*#SpriteSet.filenames*SpriteSet.line_length*SpriteSet.lines_per_file)%(SpriteSet.line_length*SpriteSet.lines_per_file))/SpriteSet.line_length), 
											size = {SpriteSet.width, SpriteSet.height}, 
											scale = SpriteSet.scale, 
											shift = SpriteSet.shift}
						LeftSprites[each+1] = {filename = SpriteSet.filenames[1+math.floor(0.75*#SpriteSet.filenames)], 
											x = SpriteSet.width*((0.75*#SpriteSet.filenames*SpriteSet.line_length*SpriteSet.lines_per_file)%SpriteSet.line_length), 
											y = SpriteSet.height*math.floor(((0.75*#SpriteSet.filenames*SpriteSet.line_length*SpriteSet.lines_per_file)%(SpriteSet.line_length*SpriteSet.lines_per_file))/SpriteSet.line_length), 
											size = {SpriteSet.width, SpriteSet.height}, 
											scale = SpriteSet.scale, 
											shift = SpriteSet.shift}
					else
						UpSprites[each+1] = {filename = SpriteSet.filenames[1+0], 
											x = SpriteSet.width*(0%SpriteSet.line_length), 
											y = SpriteSet.height*math.floor((0%(SpriteSet.line_length*SpriteSet.lines_per_file))/SpriteSet.line_length), 
											size = {SpriteSet.width, SpriteSet.height}, 
											scale = SpriteSet.scale, 
											shift = SpriteSet.shift}
						RightSprites[each+1] = {filename = SpriteSet.filenames[1+math.floor(0.5*#SpriteSet.filenames)], 
											x = SpriteSet.width*((0.5*#SpriteSet.filenames*SpriteSet.line_length*SpriteSet.lines_per_file)%SpriteSet.line_length), 
											y = SpriteSet.height*math.floor(((0.5*#SpriteSet.filenames*SpriteSet.line_length*SpriteSet.lines_per_file)%(SpriteSet.line_length*SpriteSet.lines_per_file))/SpriteSet.line_length), 
											size = {SpriteSet.width, SpriteSet.height}, 
											scale = SpriteSet.scale, 
											shift = SpriteSet.shift}
						DownSprites[each+1] = {filename = UpSprites[each+1].filename, x = UpSprites[each+1].x, y = UpSprites[each+1].y, size = {SpriteSet.width, SpriteSet.height}, scale = SpriteSet.scale, shift = SpriteSet.shift}
						LeftSprites[each+1] = {filename = RightSprites[each+1].filename, x = RightSprites[each+1].x, y = RightSprites[each+1].y, size = {SpriteSet.width, SpriteSet.height}, scale = SpriteSet.scale, shift = SpriteSet.shift}
					end
				end

				
			elseif (SpriteSet.flags and SpriteSet.flags[1] == "mask" and SpriteSet.draw_as_shadow == nil) then	-- carriage mask
				if (SpriteSet.hr_version and SpriteSet.hr_version.filenames and (SpriteSet.hr_version.line_length*SpriteSet.hr_version.lines_per_file)%4 == 0) then
					if (SpriteSet.hr_version.back_equals_front ~= true) then
						MaskUpSprites[each] = {filename = SpriteSet.hr_version.filenames[1+0], 
											x = SpriteSet.hr_version.width*(0%SpriteSet.hr_version.line_length), 
											y = SpriteSet.hr_version.height*math.floor((0%(SpriteSet.hr_version.line_length*SpriteSet.hr_version.lines_per_file))/SpriteSet.hr_version.line_length), 
											size = {SpriteSet.hr_version.width, SpriteSet.hr_version.height}, 
											scale = SpriteSet.hr_version.scale, 
											shift = SpriteSet.hr_version.shift}
						MaskRightSprites[each] = {filename = SpriteSet.hr_version.filenames[1+math.floor(0.25*#SpriteSet.hr_version.filenames)], 
											x = SpriteSet.hr_version.width*((0.25*#SpriteSet.hr_version.filenames*SpriteSet.hr_version.line_length*SpriteSet.hr_version.lines_per_file)%SpriteSet.hr_version.line_length), 
											y = SpriteSet.hr_version.height*math.floor(((0.25*#SpriteSet.hr_version.filenames*SpriteSet.hr_version.line_length*SpriteSet.hr_version.lines_per_file)%(SpriteSet.hr_version.line_length*SpriteSet.hr_version.lines_per_file))/SpriteSet.hr_version.line_length), 
											size = {SpriteSet.hr_version.width, SpriteSet.hr_version.height}, 
											scale = SpriteSet.hr_version.scale, 
											shift = SpriteSet.hr_version.shift}
						MaskDownSprites[each] = {filename = SpriteSet.hr_version.filenames[1+math.floor(0.5*#SpriteSet.hr_version.filenames)], 
											x = SpriteSet.hr_version.width*((0.5*#SpriteSet.hr_version.filenames*SpriteSet.hr_version.line_length*SpriteSet.hr_version.lines_per_file)%SpriteSet.hr_version.line_length), 
											y = SpriteSet.hr_version.height*math.floor(((0.5*#SpriteSet.hr_version.filenames*SpriteSet.hr_version.line_length*SpriteSet.hr_version.lines_per_file)%(SpriteSet.hr_version.line_length*SpriteSet.hr_version.lines_per_file))/SpriteSet.hr_version.line_length), 
											size = {SpriteSet.hr_version.width, SpriteSet.hr_version.height}, 
											scale = SpriteSet.hr_version.scale, 
											shift = SpriteSet.hr_version.shift}
						MaskLeftSprites[each] = {filename = SpriteSet.hr_version.filenames[1+math.floor(0.75*#SpriteSet.hr_version.filenames)], 
											x = SpriteSet.hr_version.width*((0.75*#SpriteSet.hr_version.filenames*SpriteSet.hr_version.line_length*SpriteSet.hr_version.lines_per_file)%SpriteSet.hr_version.line_length), 
											y = SpriteSet.hr_version.height*math.floor(((0.75*#SpriteSet.hr_version.filenames*SpriteSet.hr_version.line_length*SpriteSet.hr_version.lines_per_file)%(SpriteSet.hr_version.line_length*SpriteSet.hr_version.lines_per_file))/SpriteSet.hr_version.line_length), 
											size = {SpriteSet.hr_version.width, SpriteSet.hr_version.height}, 
											scale = SpriteSet.hr_version.scale, 
											shift = SpriteSet.hr_version.shift}
					else
						MaskUpSprites[each] = {filename = SpriteSet.hr_version.filenames[1+0], 
											x = SpriteSet.hr_version.width*(0%SpriteSet.hr_version.line_length), 
											y = SpriteSet.hr_version.height*math.floor((0%(SpriteSet.hr_version.line_length*SpriteSet.hr_version.lines_per_file))/SpriteSet.hr_version.line_length), 
											size = {SpriteSet.hr_version.width, SpriteSet.hr_version.height}, 
											scale = SpriteSet.hr_version.scale,
											shift = SpriteSet.hr_version.shift}
						MaskRightSprites[each] = {filename = SpriteSet.hr_version.filenames[1+math.floor(0.5*#SpriteSet.hr_version.filenames)], 
											x = SpriteSet.hr_version.width*((0.5*#SpriteSet.hr_version.filenames*SpriteSet.hr_version.line_length*SpriteSet.hr_version.lines_per_file)%SpriteSet.hr_version.line_length), 
											y = SpriteSet.hr_version.height*math.floor(((0.5*#SpriteSet.hr_version.filenames*SpriteSet.hr_version.line_length*SpriteSet.hr_version.lines_per_file)%(SpriteSet.hr_version.line_length*SpriteSet.hr_version.lines_per_file))/SpriteSet.hr_version.line_length), 
											size = {SpriteSet.hr_version.width, SpriteSet.hr_version.height}, 
											scale = SpriteSet.hr_version.scale, 
											shift = SpriteSet.hr_version.shift}
						MaskDownSprites[each] = {filename = MaskUpSprites[each].filename, x = MaskUpSprites[each].x, y = MaskUpSprites[each].y, size = {SpriteSet.hr_version.width, SpriteSet.hr_version.height}, scale = SpriteSet.hr_version.scale, shift = SpriteSet.hr_version.shift}
						MaskLeftSprites[each] = {filename = MaskRightSprites[each].filename, x = MaskRightSprites[each].x, y = MaskRightSprites[each].y, size = {SpriteSet.hr_version.width, SpriteSet.hr_version.height}, scale = SpriteSet.hr_version.scale, shift = SpriteSet.hr_version.shift}
					end
					
				elseif (SpriteSet.filenames and (SpriteSet.line_length*SpriteSet.lines_per_file)%4 == 0) then
					if (SpriteSet.back_equals_front ~= true) then
						MaskUpSprites[each] = {filename = SpriteSet.filenames[1+0], 
											x = SpriteSet.width*(0%SpriteSet.line_length), 
											y = SpriteSet.height*math.floor((0%(SpriteSet.line_length*SpriteSet.lines_per_file))/SpriteSet.line_length), 
											size = {SpriteSet.width, SpriteSet.height}, 
											scale = SpriteSet.scale, 
											shift = SpriteSet.shift}
						MaskRightSprites[each] = {filename = SpriteSet.filenames[1+math.floor(0.25*#SpriteSet.filenames)], 
											x = SpriteSet.width*((0.25*#SpriteSet.filenames*SpriteSet.line_length*SpriteSet.lines_per_file)%SpriteSet.line_length), 
											y = SpriteSet.height*math.floor(((0.25*#SpriteSet.filenames*SpriteSet.line_length*SpriteSet.lines_per_file)%(SpriteSet.line_length*SpriteSet.lines_per_file))/SpriteSet.line_length), 
											size = {SpriteSet.width, SpriteSet.height}, 
											scale = SpriteSet.scale, 
											shift = SpriteSet.shift}
						MaskDownSprites[each] = {filename = SpriteSet.filenames[1+math.floor(0.5*#SpriteSet.filenames)], 
											x = SpriteSet.width*((0.5*#SpriteSet.filenames*SpriteSet.line_length*SpriteSet.lines_per_file)%SpriteSet.line_length), 
											y = SpriteSet.height*math.floor(((0.5*#SpriteSet.filenames*SpriteSet.line_length*SpriteSet.lines_per_file)%(SpriteSet.line_length*SpriteSet.lines_per_file))/SpriteSet.line_length), 
											size = {SpriteSet.width, SpriteSet.height}, 
											scale = SpriteSet.scale, 
											shift = SpriteSet.shift}
						MaskLeftSprites[each] = {filename = SpriteSet.filenames[1+math.floor(0.75*#SpriteSet.filenames)], 
											x = SpriteSet.width*((0.75*#SpriteSet.filenames*SpriteSet.line_length*SpriteSet.lines_per_file)%SpriteSet.line_length), 
											y = SpriteSet.height*math.floor(((0.75*#SpriteSet.filenames*SpriteSet.line_length*SpriteSet.lines_per_file)%(SpriteSet.line_length*SpriteSet.lines_per_file))/SpriteSet.line_length), 
											size = {SpriteSet.width, SpriteSet.height}, 
											scale = SpriteSet.scale, 
											shift = SpriteSet.shift}
					else
						MaskUpSprites[each] = {filename = SpriteSet.filenames[1+0], 
											x = SpriteSet.width*(0%SpriteSet.line_length), 
											y = SpriteSet.height*math.floor((0%(SpriteSet.line_length*SpriteSet.lines_per_file))/SpriteSet.line_length), 
											size = {SpriteSet.width, SpriteSet.height}, 
											scale = SpriteSet.scale,  
											shift = SpriteSet.shift}
						MaskRightSprites[each] = {filename = SpriteSet.filenames[1+math.floor(0.5*#SpriteSet.filenames)], 
											x = SpriteSet.width*((0.5*#SpriteSet.filenames*SpriteSet.line_length*SpriteSet.lines_per_file)%SpriteSet.line_length), 
											y = SpriteSet.height*math.floor(((0.5*#SpriteSet.filenames*SpriteSet.line_length*SpriteSet.lines_per_file)%(SpriteSet.line_length*SpriteSet.lines_per_file))/SpriteSet.line_length), 
											size = {SpriteSet.width, SpriteSet.height}, 
											scale = SpriteSet.scale, 
											shift = SpriteSet.shift}
						MaskDownSprites[each] = {filename = MaskUpSprites[each].filename, x = MaskUpSprites[each].x, y = MaskUpSprites[each].y, size = {SpriteSet.width, SpriteSet.height}, scale = SpriteSet.scale, shift = SpriteSet.shift}
						MaskLeftSprites[each] = {filename = MaskRightSprites[each].filename, x = MaskRightSprites[each].x, y = MaskRightSprites[each].y, size = {SpriteSet.width, SpriteSet.height}, scale = SpriteSet.scale, shift = SpriteSet.shift}
					end
				end
			end
		end -- for loop end
		
		if (#UpSprites>1 and #RightSprites>1 and #DownSprites>1 and #LeftSprites>1) then
			data:extend({
				{
					type = "sprite",
					name = "RT"..ThingData.name.."up",
					layers = UpSprites
				},
				{
					type = "sprite",
					name = "RT"..ThingData.name.."right",
					layers = RightSprites
				},
				{
					type = "sprite",
					name = "RT"..ThingData.name.."down",
					layers = DownSprites
				},
				{
					type = "sprite",
					name = "RT"..ThingData.name.."left",
					layers = LeftSprites
				}				
			})
		end		
		if (#MaskUpSprites>0 and #MaskRightSprites>0 and #MaskDownSprites>0 and #MaskLeftSprites>0) then
			data:extend({
				{
					type = "sprite",
					name = "RT"..ThingData.name.."Maskup",
					layers = MaskUpSprites
				},
				{
					type = "sprite",
					name = "RT"..ThingData.name.."Maskright",
					layers = MaskRightSprites
				},
				{
					type = "sprite",
					name = "RT"..ThingData.name.."Maskdown",
					layers = MaskDownSprites
				},
				{
					type = "sprite",
					name = "RT"..ThingData.name.."Maskleft",
					layers = MaskLeftSprites
				}				
			})		
		end
	end
end


--- loop through data.raw ---------------------------------
---- Make thrower variants first so that the projectile generating will work

for ThingID, ThingData in pairs(data.raw.inserter) do	
	-- lots of requirements to make sure not pick up any "function only" inserters from other mods --
	if (settings.startup["RTThrowersSetting"].value == true and settings.startup["RTModdedThrowers"].value == true) then
		if (ThingData.type == "inserter" 
			and ThingData.energy_source.type ~= "void" 
			and ThingData.draw_held_item ~= false 
			and ThingData.selectable_in_game ~= false 
			and ThingData.minable 
			and ThingData.minable.result
			and ThingData.rotation_speed ~= 0
			and ThingData.extension_speed ~= 0
			and data.raw.item[ThingData.minable.result] ~= nil
			and not string.find(ThingData.name, "RTThrower-")
			--and (not ThingData.name ~= "thrower-inserter") 
		)then
			MakeThrowerVariant(ThingData)
		end
	elseif (settings.startup["RTThrowersSetting"].value == true and settings.startup["RTModdedThrowers"].value == false) then
		if (ThingData.name == "burner-inserter" 
		or ThingData.name == "inserter" 
		or ThingData.name == "fast-inserter"
		or ThingData.name == "long-handed-inserter"	
		or ThingData.name == "filter-inserter"
		or ThingData.name == "stack-filter-inserter"
		or ThingData.name == "stack-inserter") 
		then
			MakeThrowerVariant(ThingData)
		end	
	end
end


for Category, ThingsTable in pairs(data.raw) do
	for ThingID, ThingData in pairs(ThingsTable) do	
		if (ThingData.stack_size ) then
			MakeProjectile(ThingData)
			
			if (settings.startup["RTBounceSetting"].value == true) then
				if (ThingData.type == "ammo" -- looking for things like rockets, tank shells, missles, etc
					and ThingData.ammo_type.action --if this ammo does something
					and ThingData.ammo_type.action.action_delivery --in the form of
					and (ThingData.ammo_type.action.action_delivery.type == "projectile" --a projectile
						 or ThingData.ammo_type.action.action_delivery.type == "artillery") --artillery gets its own projectile catagory
					) then
					MakePrimedProjectile(ThingData)
				elseif 
					(
						(
							Category == "capsule" --if its a capsule
							and ThingData.capsule_action.type == "throw" --with a thrown action
							and 
							(
								( -- 0.18.36+ capsule action notation
								ThingData.capsule_action.attack_parameters.ammo_type.action[1]
								and data.raw.projectile[ThingData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile]--that has an associated projectile
								and data.raw.projectile[ThingData.capsule_action.attack_parameters.ammo_type.action[1].action_delivery.projectile].action --that does something
								)
								or	
								( -- old capsule action notation
								ThingData.capsule_action.attack_parameters.ammo_type.action
								and data.raw.projectile[ThingData.capsule_action.attack_parameters.ammo_type.action.action_delivery.projectile]--that has an associated projectile
								and data.raw.projectile[ThingData.capsule_action.attack_parameters.ammo_type.action.action_delivery.projectile].action --that does something
								)
							)
						) 
						or data.raw["land-mine"][ThingData.place_result]
					) then
					MakePrimedProjectile(ThingData)
				end
			end
		end

		
		if (settings.startup["RTZiplineSetting"].value == true) then
			if (ThingData.type == "electric-pole") then
				if (ThingData.connection_points.wire and ThingData.connection_points.wire.copper) then
					Points = ThingData.connection_points.wire.copper
				elseif (ThingData.connection_points[1].wire and ThingData.connection_points[1].wire.copper) then
					xavg = 0
					yavg = 0
					for each, varient in pairs(ThingData.connection_points) do
						xavg = xavg + varient.wire.copper[1]
						yavg = yavg + varient.wire.copper[2]
					end
					Points = {xavg/#ThingData.connection_points, yavg/#ThingData.connection_points}
				end
				if (Points ~= nil) then
					data:extend
					({
						{
							type = "recipe",
							name = "RTGetTheGoods-"..ThingData.name.."X",
							enabled = false,
							hidden = true,
							emissions_multiplier = Points[1],
							ingredients = 
								{
									{"infinity-chest", 360}
								},
							result = "infinity-chest"
						},
						{
							type = "recipe",
							name = "RTGetTheGoods-"..ThingData.name.."Y",
							enabled = false,
							hidden = true,
							emissions_multiplier = Points[2],
							ingredients = 
								{
									{"infinity-chest", 360}
								},
							result = "infinity-pipe"
						},
					})
				end
			end
		end
		
		if (Category == "locomotive" or Category == "cargo-wagon" or Category == "fluid-wagon") then
			MakeCarriageSprites(ThingData)
		end
		
	end
end

MakeProjectile(
	{
		name = "test",
		icon = "__RenaiTransportation__/graphics/nothing.png",
		icon_size = 32
	}
)

MakeProjectile(
	{
		name = "MaybeIllBeTracer",
		icon = "__RenaiTransportation__/graphics/nothing.png",
		icon_size = 32
	}
)
