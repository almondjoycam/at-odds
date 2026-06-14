class_name Player extends Node3D

@onready var hud: HUD = $"../Hud" as HUD

signal player_selected(player: NPC)

func _ready() -> void:
	player_selected.connect(_on_player_selected)

func _on_player_selected(player: NPC):
	hud.set_cards_in_hand(player.name, player.get_cards())
