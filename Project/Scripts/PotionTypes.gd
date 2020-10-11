extends Node


enum PotionType { HEALING, POISON, EXPLOSIVE }

const HEALTH_CHANGE = {
	PotionType.EXPLOSIVE: -20,
	PotionType.HEALING: 20,
	PotionType.POISON: -10
}

const potions = {
	PotionType.EXPLOSIVE: "res://Assets/Potions/Explosive_potion.obj",
	PotionType.HEALING: "res://Assets/Potions/Healing_potion.obj",
	PotionType.POISON: "res://Assets/Potions/Poison_potion.obj"
}
