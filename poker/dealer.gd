class_name Dealer extends Node3D

var card_packed: PackedScene = preload("res://props/card.tscn")
var suits: Array[Card.Suit] = [Card.Suit.HEARTS, Card.Suit.SPADES, Card.Suit.DIAMONDS, Card.Suit.CLUBS]
var ranks: Array = range(13)
var deck: Array[Card]
@export var material: CardMaterials

@onready var players: Array[Node] = get_tree().get_nodes_in_group("NPC")

func _ready() -> void:
	shuffle()
	deal(2)

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
		add_child(deck[i])
		deck[i].position.z += 2
		deck[i].position.y += 1
		var timer := get_tree().create_timer(0.2)
		var player_index = i % len(players)
		var card_deal: Vector3 = players[player_index].global_position - global_position
		card_deal += Vector3.UP
		deck[i].apply_central_force(card_deal * randf_range(6, 7))
		await timer.timeout
		deck[i].reparent(players[player_index])
