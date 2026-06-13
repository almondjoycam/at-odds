class_name Player extends Node3D

@onready var players: Array[Node] = $"../Set".get_children()
var move: Vector3 = Vector3.ZERO
@export var move_speed: float = 10.

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	move.x = Input.get_axis("move_left", "move_right")
	move.z = Input.get_axis("move_up", "move_down")
	translate_object_local(move * delta * move_speed)

func _input(event: InputEvent) -> void:
	pass
