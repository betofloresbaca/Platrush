extends HBoxContainer

func _ready():
	var base_level = get_tree().get_first_node_in_group("base_level")
	if base_level != null:
		base_level.connect("coin_total_changed", Callable(self,"_on_base_level_coin_total_changed"))
		update_display(base_level.collected_coins, base_level.total_coins)

func _on_base_level_coin_total_changed(collected_coins, total_coins):
	update_display(collected_coins, total_coins)

func update_display(collected_coins, total_coins):
	$CoinLabel.text = str(collected_coins, "/", total_coins)
