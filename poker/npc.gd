class_name NPC extends StaticBody3D

@onready var mesh: MeshInstance3D = $MeshInstance3D
var highlight_mat: StandardMaterial3D = preload("res://props/textures/highlight.tres")
var selected: bool = false:
	set(toggle):
		selected = toggle
		if selected:
			mesh.material_override = highlight_mat
		else:
			mesh.material_override = null

func _ready() -> void:
	input_ray_pickable = true

func _input_event(_camera: Camera3D, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	var mouse_input = event as InputEventMouseButton
	if mouse_input and mouse_input.is_pressed():
		selected = not selected
