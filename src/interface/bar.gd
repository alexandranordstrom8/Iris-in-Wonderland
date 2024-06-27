extends HBoxContainer

var _max_value = 100

func init(_max):
	_max_value = _max
	$TextureProgressBar.max_value = _max_value

func _on_interface_hp_changed(hp):
	$counter/Label.text = str(hp)
	$TextureProgressBar.value = hp

func _on_interface_sp_changed(sp):
	$counter/Label.text = str(sp)
	$TextureProgressBar.value = sp
