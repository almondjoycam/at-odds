class_name Card extends Node3D

enum Suit { HEARTS, SPADES, DIAMONDS, CLUBS }


var rank: int
var suit: Suit
var label: String
var tex: Texture2D:
	set(new_texture):
		tex = new_texture
		$MeshInstance3D.material_override.albedo_texture = tex

func _ready() -> void:
	pass

func set_label():
	pass
