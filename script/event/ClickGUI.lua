local function FindPath(finish, start)
   local possibilities = {}
         possibilities[start.unit_number] = {entity=start, FromStart=0, FromFinish=DistanceBetween(start.position, finish.position), difficulty=DistanceBetween(start.position, finish.position)}
   local analyzed = {}
   local found = false
   while (found == false) do
      local current
      local ID
      for i, d in pairs(possibilities) do
         current = d
         ID = i
         break
      end
      for i, option in pairs(possibilities) do
         if (option.difficulty <= current.difficulty and option.FromFinish < current.FromFinish) then
            current = option
            ID = i
         end
      end
      possibilities[ID] = nil
      analyzed[current.entity.unit_number] = current
      if (current.entity.unit_number == finish.unit_number) then
         found = true
         break
      end

      for each, neighbor in pairs(current.entity.neighbours["copper"]) do
         local FromStart = current.FromStart + DistanceBetween(current.entity.position, neighbor.position)
         if (analyzed[neighbor.unit_number] == nil and (#neighbor.neighbours["copper"] > 1 or neighbor.unit_number == finish.unit_number) and (possibilities[neighbor.unit_number] == nil or possibilities[neighbor.unit_number].FromStart > FromStart)) then
            local difficulty = FromStart + DistanceBetween(neighbor.position, finish.position)
            possibilities[neighbor.unit_number] = {entity=neighbor, FromStart=FromStart, FromFinish=DistanceBetween(neighbor.position, finish.position), difficulty=difficulty, parent=current.entity}
         end
      end
   end

   if (found == true) then
      local backtrack = false
      local path = {}
      local WhereDidYouComeFrom = finish
      --table.insert(path, WhereDidYouComeFrom)
      while (backtrack == false) do
         WhereDidYouComeFrom = analyzed[WhereDidYouComeFrom.unit_number].parent
         table.insert(path, WhereDidYouComeFrom)
         if (WhereDidYouComeFrom.unit_number == start.unit_number) then
            backtrack = true
         end
      end
      return path
   end
end

ClickableStuff = {
	RTCloseGUI = function(event, player)
		event.element.parent.parent.destroy()
	end,
	ZiplineAutoPath = function(event, player)
		local PlayerProperties = global.AllPlayers[player.index]
		local start = global.ZiplineTerminals[event.element.tags.start].entity
		local finish = global.ZiplineTerminals[event.element.tags.finish].entity
		if (start.valid and finish.valid and start.electric_network_id == finish.electric_network_id) then
			GetOnZipline(player, PlayerProperties, start)
			PlayerProperties.zipline.path = FindPath(start, finish)
			PlayerProperties.zipline.FinalStop = finish

		elseif (start.valid and finish.valid and start.electric_network_id ~= finish.electric_network_id) then
			player.print({"zipline-stuff.NotOnSameNetwork"})

		else
			player.print({"zipline-stuff.MissingChoice"})
		end
		event.element.parent.parent.parent.destroy()
	end,
	RTStartRenameTerminal = function(event, player)
		local PlayerProperties = global.AllPlayers[player.index]
		local header = event.element.parent
		local TerminalName = event.element.parent.TerminalName.caption
		event.element.parent.TerminalName.destroy()
		event.element.destroy()
		header.add{type="textfield", name="TerminalName", text=TerminalName, clear_and_focus_on_right_click=true}.style.font = "heading-1"
		header.add{
			type = "sprite-button",
			style = "frame_action_button",
			sprite = "utility/check_mark_green",
			tooltip = {"zipline-stuff.ChangeName"},
			-- hovered_sprite = "utility/rename_icon_small_black",
			-- clicked_sprite = "utility/rename_icon_small_black",
			tags = {RTEffect="RTRenameTerminal"}
		}
	end,
	RTRenameTerminal = function(event, player)
		local PlayerProperties = global.AllPlayers[player.index]
		local header = event.element.parent
		local TerminalName = event.element.parent.TerminalName.text
		global.ZiplineTerminals[event.element.parent.parent.tags.ID].name = TerminalName
		event.element.parent.TerminalName.destroy()
		event.element.destroy()
		header.add{type="label", name="TerminalName", caption=TerminalName}.style.font = "heading-1"
		header.add{
			type = "sprite-button",
			style = "frame_action_button",
			sprite = "utility/rename_icon_small_white",
			hovered_sprite = "utility/rename_icon_small_black",
			clicked_sprite = "utility/rename_icon_small_black",
			tooltip = {"zipline-stuff.rename"},
			tags = {RTEffect="RTStartRenameTerminal"}
		}
	end
}

-- element :: LuaGuiElement: The clicked element.
-- player_index :: uint: The player who did the clicking.
-- button :: defines.mouse_button_type: The mouse button used if any.
-- alt :: boolean: If alt was pressed.
-- control :: boolean: If control was pressed.
-- shift :: boolean: If shift was pressed.
local function ClickGUI(event)
local player = game.players[event.player_index]
	local TriggerEffect = event.element.tags.RTEffect
	if (ClickableStuff[TriggerEffect]) then
		ClickableStuff[TriggerEffect](event, player)
	end
end

return ClickGUI

-- RTZiplineTerminalGUI
	-- TerminalHeader
		-- Terminal
		-- name
		-- rename button
	-- scroller
		-- layout table
			-- button
			-- camera
