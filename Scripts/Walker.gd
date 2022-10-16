extends Node
class_name Walker

const DIRECTIONS = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]

var pos = Vector2.ZERO
var direction = Vector2.RIGHT
var step_history = []
const max_rooms = 10
const max_step_before_turn = 15
var steps_since_turn = 0
var rooms = []
var room_count = 0

func _init(starting_position):
	pos = starting_position
	step_history.append(pos)

func walk(steps):
	place_room(pos)
	for step in steps:
		if steps_since_turn >= max_step_before_turn:
			change_direction()
		
		if step():
			bigger_hallway(pos, direction)
			step_history.append(pos)
		if room_count >= max_rooms:
			return step_history
				
	return step_history

func bigger_hallway(position, curdirection):
	if curdirection == Vector2.UP or curdirection == Vector2.DOWN:
		step_history.append(position + Vector2.LEFT)
		step_history.append(position + Vector2.RIGHT)
	elif curdirection == Vector2.LEFT or curdirection == Vector2.RIGHT:
		step_history.append(position + Vector2.UP)
		step_history.append(position + Vector2.DOWN)

func step():
	var target_position = pos + direction
	steps_since_turn += 1
	pos = target_position
	return true

func change_direction():
	place_room(pos)
	steps_since_turn = 0
	var directions = DIRECTIONS.duplicate()
	directions.erase(direction)
	directions.shuffle()
	direction = directions.pop_front()
		

func create_room(position, size):
	return {position = position, size = size}

func place_room(position):
	var size = Vector2(randi() % 5 + 5, randi() % 5 + 5)
	var top_left_corner = (position - size / 2).ceil()
	rooms.append(create_room(position, size))
	room_count += 1
	for y in size.y:
		for x in size.x:
			var new_step = top_left_corner + Vector2(x, y)
			step_history.append(new_step)

func get_end_room():
	return rooms[ - 1]








