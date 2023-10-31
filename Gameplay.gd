extends Node
class_name Game

var Random = RandomNumberGenerator.new()

func NewLevel(tilemap):
	tilemap.clear()
	var avail_spawns = []
	var walker = Walker.new(Vector2(0, 0))
	var map = walker.walk(150)
	for player in range(2):
		continue
	walker.queue_free()
	for vector in map:
		tilemap.set_cellv(vector, 0)
		if Vector2(0, 0).distance_to(vector) > 10:
			avail_spawns.append(tilemap.map_to_local(vector))
	tilemap.update_bitmask_region()
#	spawnEnemies(avail_spawns)
