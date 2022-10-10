extends KinematicBody2D

export  var stats = {
	"Speed":200, 
	"Bullet Speed":1500, 
	"Firerate":0.2
}

signal died

var joystick
var joystick2
var firing = false
export  var BulletToUse = preload("res://Scenes/Bullet.tscn")

func _ready():
	joystick2 = get_parent().get_parent().get_node("UI/Aiming")
	joystick = get_parent().get_parent().get_node("UI/MovementJoystick")
	if get_parent().get_parent().IsMobile:
		joystick.visible = true
		joystick2.visible = true
	else :
		joystick.visible = false
		joystick2.visible = false
	
func _physics_process(_delta):
	var velocity = Vector2()

	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1;
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1;
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1;
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1;

	velocity = joystick.get_output()
	velocity = move_and_slide(velocity * stats["Speed"]);
	
func loop():
	while firing:
		fire()
		yield (get_tree().create_timer(0.2), "timeout")
		if not joystick2.is_pressed():
			firing = false

func _input(event):
	if joystick2.is_pressed():
		if not firing:
			firing = true
			loop()
		
func fire():
	var bullet = BulletToUse.instance()
	bullet.position = position
	
#	var angle = (get_global_mouse_position() - bullet.position).normalized()
	var angle = (joystick2.get_output().normalized() + position - bullet.position).normalized()
	bullet.apply_impulse(Vector2(), Vector2(angle.x, angle.y) * stats["Bullet Speed"])
	get_parent().add_child(bullet)
	bullet.look_at(angle + bullet.position)

func _on_Area2D_body_entered(body):
	if "Enemy" in body.name:
		print(body.name, " touched you")
		print(position, body.position)
		print(body.get_parent())
		emit_signal("died")
