extends CharacterBody2D

@onready var health_info: Label = $HealthInfo

var speed = 40
var explosion_scene = preload("res://explosion.tscn")
var player = null
var player_chase = false
var _health = 100

func _ready() -> void:
	health_info.text = str(_health)

func _physics_process(delta: float) -> void:
	if player_chase:
		position += (player.position - position) / speed
		$AnimatedSprite2D.play("move")
	else:
		$AnimatedSprite2D.play("idle")

func _on_detection_area_body_entered(body: Node2D) -> void:
	# Cek apakah nama scene-nya "ship" atau filename-nya "ship.tscn"
	if body.name == "Ship" or body.scene_file_path == "res://ship.tscn":
		player = body
		player_chase = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.name == "Ship" or body.scene_file_path == "res://ship.tscn":
		player = null
		player_chase = false

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "Bullet" or body.scene_file_path == "res://bullet.tscn":
		_health -= 20
		health_info.text = str(_health)
		
		if _health <= 0:
			queue_free()
		
