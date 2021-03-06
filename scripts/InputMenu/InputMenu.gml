// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function InputMenu(){
	var vw = view_get_wview(0);
	var vh = view_get_hview(0);
	//
	var _w = 320;
	var _h = 80;
	var _pad = 10;
	var _x = (vw - _w) div 2;
	var _y = (vh - _h * maxplayers - _pad * (maxplayers - 1)) div 2;
	var p;
	for (p = 0; p < maxplayers; p++) {
		if (input_kind[p] < 0) {
			var i, k;
			//
			var n = gmt_count + 1;
			for (i = gmt_active; i < n; i++) {
				for (k = 0; k < maxplayers; k++) {
					if (input_kind[k] == 0 && input_index[k] == i) break;
				}
				if (k < maxplayers) continue;
				//
				if (keyboard_check_pressed(256 * i + vk_enter)) {
					input_kind[p] = 0;
					input_index[p] = i;
					break;
				}
			}
			if (i < n) break;
			//
			for (i = 0; i < 12; i++) {
				for (k = 0; k < maxplayers; k++) {
					if (input_kind[k] == 1 && input_index[k] == i) break;
				}
				if (k < maxplayers) continue;
				//
				if (gamepad_button_check(i, gp_start)) {
					input_kind[p] = 1;
					input_index[p] = i;
					break;
				}
			}
			if (i < n) break;
		} else {
			if (input_pressed(p, input.back)
				|| input_kind[p] == 1 && !gamepad_is_connected(input_index[p])
			) {
				input_kind[p] = -1;
				input_index[p] = -1;
				break;
			}
		}
	}
	var changedSlots = p < maxplayers;
	var only2p = false;
	var canstart = !only2p || input_count_active() >= 2;
	if (!changedSlots && canstart && input_pressed_any(input.accept)) {
		is_input = false;
		levelSelect.sync();
	}
	var noStartText = "\nNeed two players to start.";
	var nop1 = (only2p
		? "\nNeed two players to start."
		: "\nCan't start with P1 not assigned."
	);
	for (var p = 0; p < maxplayers; p++) {
		draw_rectangle_px(_x, _y, _x + _w, _y + _h, 0, 0, input_kind[p] >= 0 ? 0.5 : 0.2);
		draw_rectangle_px(_x, _y, _x + _w, _y + _h, 1, -1);
		var s; switch (input_kind[p]) {
			case 0:
				s = "Keyboard";
				if (input_index[p] > 0) s += " " + string(input_index[p]);
				s += canstart ? "\nEnter to start" : noStartText;
				s += "\nEsc to unassign";
				break;
			case 1:
				s = "Gamepad " + string(input_index[p]);
				s += canstart ? "\nStart/A/Button1 to start" : noStartText;
				s += "\nBack/select to unassign";
				break;
			default:
				s = "Empty";
				var kbi = array_find_index(input_kind, 0);
				if (kbi < 0 || input_index[kbi] == gmt_index + 1) {
					s += "\nEnter (keyboard) or"
				}
				s += "\nStart (gamepad) to assign";
		}
		draw_text_shadow(_x + 4, _y + 4, "Player " + string(p + 1) + ": " + s);
		_y += _h + _pad;
	}
}