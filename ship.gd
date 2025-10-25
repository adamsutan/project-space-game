extends CharacterBody2D

var speed := 200  # pixels per second

func _process(delta):
	if Input.is_action_pressed("ui_up"):
		position.y -= speed * delta
	elif Input.is_action_pressed("ui_down"):
		position.y += speed * delta
