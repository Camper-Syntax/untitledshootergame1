extends CharacterBody2D

var target: CharacterBody2D
var speed = 100
var veloc

func _physics_process(delta):
	if target:
		veloc = global_position.direction_to(target.global_position).normalized()
# warning-ignore:return_value_discarded
		move_and_collide(veloc * speed * delta)

func _on_Range_body_entered(body):
	if body.name == "Player":
		target = body

func _on_Range_body_exited(body):
	if body.name == "Player":
		target = null

func _on_Hitbox_body_entered(body):
	if "Bullet" in body.name:
		queue_free()
