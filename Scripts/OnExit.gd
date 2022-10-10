extends RigidBody2D



func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Area2D_body_entered(body):
	if "Map" in body.name or "Enemy" in body.name:
		queue_free()
		if "Enemy" in body.name:
			body.queue_free()


func _on_Timer_timeout():
	queue_free()
