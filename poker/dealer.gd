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
	Global.win_selected.connect(end_game)

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

func end_game(selected_winner: NPC) -> void:
	print(hand_score(selected_winner.get_cards()))
	var results := compare_all_hands()
	if results[0] != selected_winner:
		Global.game_over.emit(false)
	else:
		Global.game_over.emit(true)

func compare_all_hands() -> Array[NPC]:
	var standings: Array[NPC]
	var temp: NPC
	for player in players:
		standings.append(player as NPC)
	for i in range(len(standings)):
		for j in range(i):
			if compare_hands(standings[i].get_cards(), standings[j].get_cards()) > 0:
				temp = standings[i]
				standings[i] = standings[j]
				standings[j] = temp
	return standings

static func compare_hands(hand1: Array[Card], hand2: Array[Card]) -> int:
	return hand_score(hand1) - hand_score(hand2)

static func hand_score(hand: Array[Card]) -> int:
	var rank_sum: int = 0
	var same_suit: bool = true
	var same_rank: bool = true
	var starting_rank: int = hand[0].rank
	var starting_suit: Card.Suit = hand[0].suit
	for card in hand:
		if card.rank == 0:
			rank_sum += 13
		else:
			rank_sum += card.rank
		if card.suit != starting_suit:
			same_suit = false
		if card.rank != starting_rank:
			same_rank = false
	return rank_sum * (4 if same_suit else 1) * (4 if same_rank else 1)
