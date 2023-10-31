extends CharacterBody2D

@export  var stats = {
	"Speed":250, 
	"Bullet Speed":1500, 
	"Firerate":0.2
}

signal died
var js
var js2
var firing = false

@onready var hitbox = get_node("Area2D")

@export var BulletToUse = preload("res://Scenes/Bullet.tscn")
var raycast

var InRange = []

@onready var map = get_parent().get_node("Map")
@onready var enemyfolder = get_parent().get_node("FoesFolder")

func _ready():
#	js2 = get_parent().get_node("UI/Aiming")
#	js = get_parent().get_node("UI/MJs")
	raycast = get_node("RayCast2D")
#	if get_parent().get_parent().IsMobile:
#		js.visible = true
#		js2.visible = true
#	else :
#		js.visible = false
#		js2.visible = false


func _physics_process(_delta):
	var veloc = Vector2()

	if Input.is_action_pressed("ui_up"):
		veloc.y -= 1;
	if Input.is_action_pressed("ui_down"):
		veloc.y += 1;
	if Input.is_action_pressed("ui_left"):
		veloc.x -= 1;
	if Input.is_action_pressed("ui_right"):
		veloc.x += 1;

#	velocity = js.get_output()
	set_velocity(velocity * stats["Speed"])
	move_and_slide()
	veloc = veloc;
	
func loop():
	while firing:
		fire()
		await (get_tree().create_timer(0.2))
		if not Input.is_action_pressed("LMB"):
			firing = false

func _process(_delta):
	if Input.is_action_pressed("LMB"):
		if not firing:
			firing = true
			loop()

var isfire = false
func fire():
	var target = null
	var distance = Vector2.ZERO
	
	for i in enemyfolder.get_children():
		if map.local_to_map(i.position).distance_to(map.local_to_map(position)) >= 20:
			continue
		if not target:
			target = i
			distance = target.global_position - global_position
			raycast.set_target_position(distance)
			print(raycast.get_collider(), "bruh",target,"not target")
			if raycast.get_collider() == target:
				isfire = true
			
		else:
			if i.global_position.distance_to(global_position) <= target.global_position.distance_to(global_position):
				target = i
				distance = target.global_position - global_position
				raycast.set_target_position(distance)
				print(raycast.get_collider(),"bruh", target, "else target")
				if raycast.get_collider() == target:
					isfire = true
		
	if target and fire:
		var bullet = BulletToUse.instantiate()
		bullet.position = $Sprite2D.position
		add_child(bullet)
#		var angle = (get_global_mouse_position() - bullet.position).normalized()
		var angle = distance.normalized()
		bullet.apply_impulse(Vector2(angle.x, angle.y) * stats["Bullet Speed"], Vector2())
	
		bullet.look_at(target.global_position)
		target = null
		isfire = false




func _on_area_2d_damaged():
	died.emit()
