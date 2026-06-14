class_name Table extends StaticBody3D

@onready var player := get_tree().get_first_node_in_group("player") as Player

func _input_event(_camera: Camera3D, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	var mouse_input = event as InputEventMouseButton
	if mouse_input and mouse_input.is_pressed():
		player.table_selected.emit()
