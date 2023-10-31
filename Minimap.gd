extends Control


@export var camera_node: NodePath
@export var tilemap_node: NodePath
@export var cell_colors: Dictionary
@export var enemy_node: NodePath
@export var zoom = 1.0


var camera
var tilemap
var enemy_folder

func _ready():
	camera = get_node(camera_node)
	tilemap = get_node(tilemap_node)
	enemy_folder = get_node(enemy_node)

func _draw():
	draw_set_transform(size / 2, 0, Vector2.ONE)
	
	

	var camera_position = camera.get_camera_screen_center()
	var camera_cell = tilemap.local_to_map(camera_position)
	var tilemap_offset = camera_cell + (camera_position - tilemap.map_to_local(camera_cell)) / tilemap.cell_size

	var cells = tilemap.get_used_cells_by_id(0)
	for cell in cells:
		draw_rect(Rect2((cell - tilemap_offset) * zoom, Vector2.ONE * zoom), cell_colors[0])
			
	for enemy in enemy_folder.get_children():
		var color = cell_colors["enemy"]
		var enemy_pos = tilemap.local_to_map(enemy.position)
		draw_circle(enemy_pos, 1*zoom, color)
	
	draw_circle(Vector2.ZERO, 1 * zoom, Color.BLUE)

func _process(_delta):
	update()
