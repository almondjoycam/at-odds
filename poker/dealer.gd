class_name Dealer extends Node3D

var card_packed: PackedScene = preload("res://props/card.tscn")
var suits: Array[Card.Suit] = [Card.Suit.HEARTS, Card.Suit.SPADES, Card.Suit.DIAMONDS, Card.Suit.CLUBS]
var ranks: Array = range(13)
var deck: Array[Card]
var deal_index: int
signal ready_for_next_phase
@export var material: CardMaterials

@onready var table: Node3D = $"../Table"
@onready var players: Array[Node] = get_tree().get_nodes_in_group("NPC")
@onready var dealing_position: Vector3 = $Deck.position

func _ready() -> void:
	deal_index = 0
	shuffle()
	deal_community(3)
	await ready_for_next_phase
	deal(2)
	await ready_for_next_phase
	print(deal_index)
	#deal_community(5)

func shuffle() -> void:
	for s in suits:
		for r in ranks:
			var card: Card = card_packed.instantiate() as Card
			card.suit = s
			card.rank = r
			#card.tex = material.texture_from_card_data(s, r)
			deck.append(card)
	assert(len(deck) == 52, "deck machine broke")
	deck.shuffle()

func deal(num_per_player: int) -> void:
	for i in range(num_per_player * len(players)):
		add_child(deck[deal_index + i])
		deck[deal_index + i].position = dealing_position
		var timer := get_tree().create_timer(0.2)
		var player_index = i % len(players)
		var card_deal: Vector3 = players[player_index].global_position - global_position
		deck[deal_index + i].apply_central_force(card_deal * randf_range(7, 8))
		await timer.timeout
		deck[deal_index + i].reparent(players[player_index])
	deal_index += num_per_player * len(players)
	ready_for_next_phase.emit()

func deal_community(num: int) -> void:
	for i in range(num):
		add_child(deck[deal_index + i])
		deck[deal_index + i].position = dealing_position
		var timer := get_tree().create_timer(0.2)
		var community_deal := Vector3(i, 1, 4)
		deck[deal_index + i].apply_central_force(community_deal * 5)
		await timer.timeout
		deck[deal_index + i].reparent(table)
	deal_index += num
	ready_for_next_phase.emit()
