class_name HUD extends Control

@onready var hand_ui := $HandUI as Control
@onready var win_selector := $HandUI/SelectWin as Control
@onready var card_template: TextureRect = $HandUI/Hand/Card as TextureRect
@export var card_material: CardMaterials
var current_player: NPC

func _ready() -> void:
	Global.game_over.connect(display_game_over)

func set_cards_in_hand(cards: Array[Card], player: NPC = null) -> void:
	current_player = player
	for card in cards:
		var card_node := card_template.duplicate() as TextureRect
		card_node.texture = card_material.texture_from_card_data(card.suit, card.rank)
		card_node.show()
		card_node.hidden.connect(card_node.queue_free)
		card_template.get_parent().add_child(card_node)
	if player:
		hand_ui.get_node("Label").text = player.name
		win_selector.show()
	else:
		hand_ui.get_node("Label").text = "Community"
		win_selector.hide()
	hand_ui.show()

func hide_hand_ui() -> void:
	hand_ui.hide()
	current_player = null
	for node in get_tree().get_nodes_in_group("NPC"):
		(node as NPC).selected = false

func select_win() -> void:
	if current_player:
		Global.win_selected.emit(current_player)

func display_game_over(win: bool) -> void:
	if win:
		$GameOverScreens/Win.show()
	else:
		$GameOverScreens/Lose.show()
	get_tree().create_timer(3).timeout.connect(get_tree().reload_current_scene)
