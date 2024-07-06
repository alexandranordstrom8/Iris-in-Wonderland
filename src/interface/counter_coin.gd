extends Panel

var amount = 0

func _on_interface_coin_count_changed(_amount):
	amount += _amount
	$HBoxContainer/Label.text = str(amount)
