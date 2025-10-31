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

func _physics_process(delta: float) -> void:
	var accel := Vector2.ZERO
	#var turning := 0.0

	## --- Rotasi (Q/E) ---
	#if Input.is_action_pressed("turn_left"):
		#turning -= 1.0
	#if Input.is_action_pressed("turn_right"):
		#turning += 1.0
	#rotation += turning * rotation_speed * delta
	
	#var target_angle := (get_global_mouse_position() - global_position).angle()
	#rotation = lerp_angle(rotation, target_angle, 10.0 * delta)


	_boosting = Input.is_action_pressed("boost")

	# --- Arah lokal kapal ---
	var forward := Vector2.UP.rotated(rotation)     # "hidung" kapal
	var right := Vector2.RIGHT.rotated(rotation)    # kanan kapal

	# --- Thrust maju/mundur ---
	_thrusting = false
	if Input.is_action_pressed("thrust_forward"):
		accel += forward * thrust_accel
		_thrusting = true
	elif Input.is_action_pressed("thrust_reverse"):
		accel -= forward * reverse_accel
		_thrusting = true

	# --- Strafe kiri/kanan (A/D) ---
	if Input.is_action_pressed("strafe_left"):
		accel -= right * strafe_accel
		_thrusting = true
	if Input.is_action_pressed("strafe_right"):
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
