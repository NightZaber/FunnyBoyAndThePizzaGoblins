AGSScriptModule        �  //----------------------------------------------------------------------------------------------------
// game_start()
//----------------------------------------------------------------------------------------------------
function game_start()
{
	lblActionText.Text = "";	
}

//----------------------------------------------------------------------------------------------------
// on_mouse_click()
//----------------------------------------------------------------------------------------------------
function on_mouse_click(MouseButton button)
{
	// when mouse is clicked, text label is cleared
	lblActionText.Text = "";
	
	// when game is paused, clicks aren't processed
	if (IsGamePaused())
	{
		return;
	}
	
	// Left Mouse Button on Object/Character/Hotspot/Location
	// when no inventory is selected:
	// - INTERACT with target
	// - walk to location
	// else
	// - USE inventory on target
	else if (button == eMouseLeft)
	{
		if (GetLocationType(mouse.x, mouse.y) != eLocationNothing)
		{
			if (player.ActiveInventory == null)
			{
				ProcessClick(mouse.x, mouse.y, eModeInteract);
			}
			else
			{
				ProcessClick(mouse.x, mouse.y, eModeUseinv);
			}			
			
		}
		else
		{
			if (player.ActiveInventory == null)
			{
				ProcessClick(mouse.x, mouse.y, eModeWalkto);
			}
			else
			{
				player.ActiveInventory = null;
			}
		}			
	}

	// Right Mouse Button on Object/Character/Hotspot/Location
	// when no inventory is selected:
	// - EXAMINE target
	// else
	// - DESELECT inventory
	else if (button == eMouseRight)
	{
		if (player.ActiveInventory != null)
		{
			player.ActiveInventory = null;
		}
		
		else if (GetLocationType(mouse.x, mouse.y) != eLocationNothing)
		{
			ProcessClick(mouse.x, mouse.y, eModeLookat);
		}
	}
	
	// Left Mouse Button on Inventory Item
	// when no inventory is selected:
	// - INTERACT with target 
	// - SELECT target
	// else
	// - USE inventory on target
	else if (button == eMouseLeftInv)
	{
		InventoryItem *i = InventoryItem.GetAtScreenXY(mouse.x, mouse.y);
		if (i != null)
		{
			if (i.GetProperty("propInstantUse") == true)
			{
				if (player.ActiveInventory == null)
				{
					i.RunInteraction(eModeInteract);
				}
				else
				{
					i.RunInteraction(eModeUseinv);
				}
			}
			else
			{
				if (player.ActiveInventory == null)
				{
					player.ActiveInventory = i;
				}
				else
				{
					if (i.ID != player.ActiveInventory.ID)
					{
						i.RunInteraction(eModeUseinv);
					}
				}
			}
		}
	}
	
	// Right Mouse Button on Inventory Item
	// when no inventory is selected:
	// - EXAMINE target
	// else
	// - DESELECT INVENTORY
	else if (button == eMouseRightInv)
	{
		if (player.ActiveInventory != null)
		{
			player.ActiveInventory = null;
			return;
		}
		
		InventoryItem *i = InventoryItem.GetAtScreenXY(mouse.x, mouse.y);
		if (i != null)
		{
			i.RunInteraction(eModeLookat);
		}
	}
	
}

//----------------------------------------------------------------------------------------------------
// repeatedly_execute()
//----------------------------------------------------------------------------------------------------
function repeatedly_execute()
{
	// Inventory GUI: 
	// - make visible if mouse "touches" trigger zone
	// - make invisible if mouse leaves inventory GUI
	if (!gInventoryBar.Visible && mouse.y <= INVENTORY_POPUP_POSITION)
	{
		gInventoryBar.Visible = true;
	}
	
	if (gInventoryBar.Visible && mouse.y > gInventoryBar.Height)
	{
		gInventoryBar.Visible = false;
	}
	
	// Action Text
	// We always display the name of what is under the mouse, with one exception:
	// IF the player has an inventory item selected and hovers over the same inventory item, 
	// we display nothing to indicate that an item can not be used on itself
	if (player.ActiveInventory == null)
	{
		lblActionText.Text = Game.GetLocationName(mouse.x, mouse.y);
	}
	else
	{
		InventoryItem *i = InventoryItem.GetAtScreenXY(mouse.x, mouse.y);
		if (i != null && (i.ID == player.ActiveInventory.ID))
		{
			lblActionText.Text = "";
		}
		else
		{
			lblActionText.Text = Game.GetLocationName(mouse.x, mouse.y);
		}
	}

} �  // Script header for the "Lightweight BASS Template"
//
//
// Version: 2.0
//
//
// Author(s): 
// Ghost
// 
//
// Abstract: 
// This template implements a simple "two mouse buttons" interface, as seen in "Beneath A Steel Sky"
// Left-click is "walk/interact", right-click is "examine" 
// The graphics included may be freely used and altered in any way.
//
//
// Contact and Support:
// The current thread for this template is http://www.adventuregamestudio.co.uk/forums/index.php?topic=48441.0
// Or just eMail me at lostcraft@web.de
//
//
// Dependencies:
//   AGS 3.2 or later
//
//
// Licence:
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated 
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation 
// the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and 
// to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of 
// the Software.
//
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO 
// THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
// TORT OR OTHERWISE, ARISING  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER  DEALINGS IN THE 
// SOFTWARE*.
//
//
// *It's been tested a lot though, and we have established it will not turn your computer into a steaming pile of 
// pumpkins.

// change this to the y position the mouse most be at to make the inventory GUI visible
#define INVENTORY_POPUP_POSITION 7  u��&        ej��