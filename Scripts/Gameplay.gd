extends Node

var random = RandomNumberGenerator.new()

@onready  var UI = get_node("UI")
@onready  var button = get_node("UI/TitleScreen/Play")
@onready  var player = get_node("Gameplay/Player")
@onready var enemyfolder = get_node("Gameplay/FoesFolder")

@onready  var enemy = preload("res://Scenes/Enemy.tscn")

@export  var IsMobile = false

@export  var DefaultPlayerStats = {
	"Speed":200, 
	"Bullet Speed":1500, 
	"Firerate":1
}

@onready  var tilemap = get_node("Gameplay/Map")
var score = 0
var highscore = 0
var isplayinh = false

func uiToggle(boolean):
	UI.get_node("TitleScreen").visible = boolean
	UI.get_node("ScoreDisplay").visible = not boolean

func resetplayer():
	for stat in DefaultPlayerStats:
		player.position = Vector2(0, 0)
		
func resetGame():
	resetplayer()
	isplayinh = false
	uiToggle(true)
	score = 0
	tilemap.clear()
	for en in enemyfolder.get_children():
		enemyfolder.remove_child(en)

func newLevel():
	tilemap.clear()
	var avail_spawns = []
	var walker = Walker.new(Vector2(0, 0))
	var map = walker.walk(150)
	player.position = Vector2(0, 0)
	walker.queue_free()
	for vector in map:
		tilemap.set_cell(1, vector, 0)
		if Vector2(0, 0).distance_to(vector) > 10:
			avail_spawns.append(tilemap.map_to_local(vector))
	tilemap.update_bitmadssk_region()
	spawnEnemies(avail_spawns)
	
func spawnEnemies(spawns):
	player.get_node("Area2D").monitoring = false
	var count = random.randi_range(3, 10)
	for _i in range(count):
		var num = random.randi_range(0, spawns.size())
		var pos = spawns[num]
		var newe = enemy.instantiate()
		enemyfolder.add_child(newe)
		newe.global_position = tilemap.to_global(pos + tilemap.cell_size / 2)
		spawns.erase(num)
	spawns.clear()
	player.get_node("Area2D").monitoring = true

func _on_Play_pressed():
	newLevel()
	get_tree().change_scene_to_file("res://Gameplay.tscn")

func _on_EnemyFolder_child_exiting_tree(_node):
	if not isplayinh:
		return
	score += 1
	UI.get_node("ScoreDisplay").text = "Score: " + str(score)
	if enemyfolder.get_child_count() == 1:
		newLevel()

func _on_Player_died():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
	resetGame() #ace with function body.
