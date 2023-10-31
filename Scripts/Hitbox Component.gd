extends Area2D

signal damaged

func body_entered(body):
	print(body)
	if body in is_in_group("Placeholder1-Bullets"):
		damaged.emit()
