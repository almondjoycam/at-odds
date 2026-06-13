class_name Dealer extends Node3D

var card_packed: PackedScene = preload("res://props/card.tscn")
var suits: Array[Card.Suit] = [Card.Suit.HEARTS, Card.Suit.SPADES, Card.Suit.DIAMONDS, Card.Suit.CLUBS]
var ranks: Array = range(13)
var deck: Array[Card]
@export var material: CardMaterials

@onready var players: Array[Node] = get_tree().get_nodes_in_group("NPC")

func _ready() -> void:
	shuffle()

func shuffle() -> void:
	for s in suits:
		for r in ranks:
			var card: Card = card_packed.instantiate() as Card
			card.suit = s
			card.rank = r
			deck.append(card)
	assert(len(deck) == 52, "deck machine broke")
	deck.shuffle()
	for i in range(len(deck)):
		add_child(deck[i])
		var timer = get_tree().create_timer(0.2)
		var card_deal: Vector3 = players[i % 4].global_position - global_position
		card_deal += Vector3.UP
		deck[i].apply_central_force(card_deal * randf_range(7, 8))
		await timer.timeout
