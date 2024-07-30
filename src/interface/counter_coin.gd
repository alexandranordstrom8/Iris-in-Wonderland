extends Panel

var amount = 0
var max_amount = 50

func init(coins):
	amount = coins
	max_amount = Save.coin_max
	check_max()
	$Label.text = str(amount)

func check_max():
	if amount >= max_amount:
		$Label.set("theme_override_colors/font_color", Color.LIGHT_CORAL)
		$Label.set("theme_override_colors/font_outline_color", Color.RED)
	else:
		$Label.set("theme_override_colors/font_color", Color.WHITE)
		$Label.set("theme_override_colors/font_outline_color", null)

func _on_interface_coin_count_changed(_amount):
	amount += _amount
	check_max()
	$Label.text = str(amount)
