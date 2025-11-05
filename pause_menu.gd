extends Control

func _ready() -> void:
	$AnimationPlayer.play("RESET")
	set_visible(false)

func resume():
	set_visible(false)
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")

func pause():
	get_tree().paused = true
	set_visible(true)
	$AnimationPlayer.play("blur")

func testpause():
	if Input.is_action_just_pressed("pause") and get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("pause") and get_tree().paused == true:
		resume()

func _on_continue_pressed() -> void:
	resume()

func _on_setting_pressed() -> void:
	get_tree().change_scene_to_file("res://setting.tscn")

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main menu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _process(delta):
	testpause()

func _notification(what: int) -> void:
	match what :
		Node.NOTIFICATION_PAUSED:
			hide()
		Node.NOTIFICATION_UNPAUSED :
			show()
