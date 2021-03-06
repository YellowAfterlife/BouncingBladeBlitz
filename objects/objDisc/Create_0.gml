var a = 90;
image_angle = a;
ax = lengthdir_x(1, a);
ay = lengthdir_y(1, a);
vel = 0.5;
colist = ds_list_create();
function addTrail(x1, y1, x2, y2) {
	var t = instance_create_layer(x1, y1, "WallBots", objTrail);
	var l = point_distance(x1, y1, x2, y2);
	var d = point_direction(x1, y1, x2, y2);
	t.image_angle = d;
	t.image_xscale = l / 4;
	
	// see if we've ran over any players on our way:
	ds_list_clear(colist);
	var playersHit = 0;
	var dx = lengthdir_x(1, d - 90);
	var dy = lengthdir_x(1, d - 90);
	for (var k = -2; k <= 2; k += 2) { // disc is 9px wide but we check a 4px wide line
		var n = collision_line_list(
			x1 + dx * k, y1 + dy * k,
			x2 + dx * k, y2 + dy * k,
			objPlayer, true, true, colist, false
		);
		for (var i = 0; i < n; i++) {
			if (colist[|i].getHit(l, d)) playersHit += 1;
		}
	}
	
	// disappear if we've hit player(s) and not in coop move:
	if (playersHit > 0
		&& !(objControl.coopMode || input_count_active() == 1)
	) {
		with (objControl) {
			discVel = other.vel;
			updateScoreForCurrentRoom();
		}
		instance_create_layer(x, y, "WallTops", objDiscExplode);
		instance_destroy();
	}
}