extends CharacterBody2D
var pos: Vector2
var rota: float
var dir: float
var speed= 2000

func _ready():
	global_position=pos
	global_rotation=rota

func _physics_process(delta):
	velocity=Vector2(speed,0).rotated(dir)
	move_and_slide()

func _on_timer_timeout() -> void:
	queue_free() # Replace with function body.


# Tambahkan fungsi ini untuk menangani tabrakan
func _on_body_entered(body):
	# Bisa tambahkan logika, misalnya cek apakah body adalah musuh
	queue_free()


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.scene_file_path == "res://enemy.tscn":
		queue_free()# Replace with function body.
