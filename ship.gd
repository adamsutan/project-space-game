extends CharacterBody2D

@export var thrust_accel: float = 600.0     # akselerasi maju
@export var reverse_accel: float = 400.0    # akselerasi mundur
@export var strafe_accel: float = 450.0     # akselerasi strafe
@export var rotation_speed: float = 3.0     # rad/s
@export var max_speed: float = 350.0        # batas kecepatan normal
@export var linear_damp: float = 2.0        # "drag" saat tidak throttle (arcade)
@export var boost_multiplier: float = 1.8   # boost menaikkan accel & max_speed
@export var boost_damp_scale: float = 0.7   # drag sedikit berkurang saat boost
@export var brake_accel: float = 1200.0     # pengereman aktif


var _thrusting := false
var _boosting := false
var bullet_path=preload("res://bullet.tscn")


func _physics_process(delta: float) -> void:
	var accel := Vector2.ZERO
	look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("shoot"):
		fire()
		
	_boosting = Input.is_action_pressed("boost")

	# --- Arah lokal kapal ---
	var right := Vector2.UP.rotated(rotation)    # kanan kapal
	var forward := Vector2.RIGHT.rotated(rotation)  # "hidung" kapal

	# --- Thrust dan Strafe menggunakan match-case ---
	_thrusting = false

	# --- Directional Controls
	for action in ["thrust_forward", "thrust_reverse", "strafe_left", "strafe_right"]:
		if Input.is_action_pressed(action):
			match action:
				"thrust_forward":
					accel += forward * thrust_accel
					_thrusting = true
				"thrust_reverse":
					accel -= forward * reverse_accel
					_thrusting = true
				"strafe_left":
					accel -= right * strafe_accel
					_thrusting = true
				"strafe_right":
					accel += right * strafe_accel
					_thrusting = true


	# --- Boost memengaruhi accel & top speed ---
	var boost_mul := boost_multiplier if _boosting else 1.0
	accel *= boost_mul
	var current_max_speed := max_speed * boost_mul

	# --- Integrasi akselerasi ---
	velocity += accel * delta

	# --- Brake aktif (Space) mengurangi kecepatan ke 0 cepat ---
	if Input.is_action_pressed("brake") and velocity.length() > 0.0:
		var brake_dir := -velocity.normalized()
		velocity += brake_dir * brake_accel * delta

	## --- Drag saat tidak menekan gas (arcade feel) ---
	#var damp := linear_damp * (_boosting ? boost_damp_scale : 1.0)
	#if not _thrusting and velocity.length() > 0.0:
		## dorong ke 0 dengan laju konstan
		#velocity = velocity.move_toward(Vector2.ZERO, damp * max_speed * delta)

	# --- Batasi kecepatan maksimum ---
	if velocity.length() > current_max_speed:
		velocity = velocity.normalized() * current_max_speed

	move_and_slide()

func fire():
	var bullet=bullet_path.instantiate()
	bullet.dir=rotation
	bullet.pos=$Node2D.global_position
	bullet.rota=global_rotation
	get_parent().add_child(bullet)
