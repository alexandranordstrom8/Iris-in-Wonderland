extends Panel

var amount = 0

func init(coins):
	amount = coins
	$Label.text = str(amount)

func _on_interface_coin_count_changed(_amount):
	amount += _amount
	$Label.text = str(amount)

func _on_interface_init(coins, _hp, _sp):
	amount = coins
	$Label.text = str(amount)
