extends Panel

var amount = 0

func init(coins):
	amount = coins
	$HBoxContainer/Label.text = str(amount)

func _on_interface_coin_count_changed(_amount):
	amount += _amount
	$HBoxContainer/Label.text = str(amount)

func _on_interface_init(coins, _hp, _sp):
	amount = coins
	$HBoxContainer/Label.text = str(amount)
