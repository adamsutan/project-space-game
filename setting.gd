extends Control


func _on_h_slider_value_changed(value: float) -> void:
	var volume_db = lerp(-40, 0, value / 100.0)  # Maps 0–100 to -40–0 dB
	AudioServer.set_bus_volume_db(0, volume_db)



func _on_check_box_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0,toggled_on)

func _on_resolution_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920,1080))
		1:
			DisplayServer.window_set_size(Vector2i(1600,900))
		2:
			DisplayServer.window_set_size(Vector2i(1280,720))

func _on_check_box_2_toggled(toggled_on: bool) -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	if toggled_on :DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main menu.tscn")
