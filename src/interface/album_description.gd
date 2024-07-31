extends Control

func show_desc(unlocked : bool):
	if unlocked:
		self.show()
	else:
		self.hide()

func hide_desc():
	self.hide()
