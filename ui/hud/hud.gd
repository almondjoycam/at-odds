class_name HUD extends Control

@onready var hand_ui := $HandUI as Control
@onready var card_template: TextureRect = $HandUI/Hand/Card as TextureRect
@export var card_material: CardMaterials

func set_cards_in_hand(player_name: String, cards: Array[Card]) -> void:
	for card in cards:
		var card_node := card_template.duplicate() as TextureRect
		card_node.texture = card_material.texture_from_card_data(card.suit, card.rank)
		card_node.show()
		card_node.hidden.connect(card_node.queue_free)
		card_template.get_parent().add_child(card_node)
	hand_ui.get_node("Label").text = player_name
	hand_ui.show()

func hide_hand_ui() -> void:
	hand_ui.hide()
	for node in get_tree().get_nodes_in_group("NPC"):
		(node as NPC).selected = false
