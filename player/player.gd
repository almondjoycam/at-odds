class_name Player extends Node3D

@onready var players: Array[Node] = $"../Set".get_children()
var move: Vector3 = Vector3.ZERO

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	pass
