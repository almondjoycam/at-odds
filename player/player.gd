class_name Player extends Node3D

@onready var hud: HUD = $"../Hud" as HUD
@export var table: Node3D

signal player_selected(player: NPC)
signal table_selected()

func _ready() -> void:
	player_selected.connect(_on_player_selected)
	table_selected.connect(_on_table_selected)

func _on_player_selected(player: NPC) -> void:
	hud.set_cards_in_hand(player.get_cards(), player)

func _on_table_selected() -> void:
	var community_cards: Array[Card]
	for node in table.get_children():
		var card = node as Card
		if card:
			community_cards.append(card)
	hud.set_cards_in_hand(community_cards)
