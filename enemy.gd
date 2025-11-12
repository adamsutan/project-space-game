extends CharacterBody2D

var speed = 40
var player = null
var player_chase = false

func _physics_process(delta: float) -> void:
	if player_chase:
		position += (player.position - position) / speed
		$AnimatedSprite2D.play("move")
	else:
		$AnimatedSprite2D.play("idle")

func _on_detection_area_body_entered(body: Node2D) -> void:
	# Cek apakah nama scene-nya "ship" atau filename-nya "ship.tscn"
	if body.name == "ship" or body.scene_file_path == "res://ship.tscn":
		player = body
		player_chase = true
	

func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false
