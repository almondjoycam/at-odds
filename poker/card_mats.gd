class_name CardMaterials extends Resource

@export var deck_back: Texture2D
@export var heart_mats: Array[Texture2D]
@export var spade_mats: Array[Texture2D]
@export var diamond_mats: Array[Texture2D]
@export var club_mats: Array[Texture2D]

func texture_from_card_data(suit: Card.Suit, rank: int) -> Texture2D:
	match suit:
		Card.Suit.HEARTS:
			return heart_mats[rank]
		Card.Suit.SPADES:
			return spade_mats[rank]
		Card.Suit.DIAMONDS:
			return diamond_mats[rank]
		Card.Suit.CLUBS:
			return club_mats[rank]
		_:
			return deck_back
