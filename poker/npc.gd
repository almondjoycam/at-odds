class_name NPC extends StaticBody3D

@onready var mesh: MeshInstance3D = $MeshInstance3D as MeshInstance3D
@onready var player := get_tree().get_first_node_in_group("player") as Player

var highlight_mat: StandardMaterial3D = preload("res://props/textures/highlight.tres")
var default_mat: StandardMaterial3D = preload("res://props/textures/player_default.tres")
var selected: bool:
	set(toggle):
		selected = toggle
		if selected:
			mesh.material_override = highlight_mat
			player.player_selected.emit(self)
		else:
			mesh.material_override = default_mat

func _ready() -> void:
	input_ray_pickable = true
	selected = false

func _input_event(_camera: Camera3D, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	var mouse_input = event as InputEventMouseButton
	if mouse_input and mouse_input.is_pressed():
		selected = true

func get_cards() -> Array[Card]:
	var cards: Array[Card]
	for node in get_children():
		var card = node as Card
		if card:
			cards.append(card)
	return cards
