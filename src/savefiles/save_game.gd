class_name SaveGame
extends Resource

const SAVE_FILE_PATH = "user://save.tres"
const PLAYER_PATH = "res://Iris-in-Wonderland/src/savefiles/player_values.tres"
const ITEM_LIST_PATH = "res://Iris-in-Wonderland/src/savefiles/inventory.tres"

@export var player_values : Resource = PlayerValues.new()
@export var inventory : Resource = Inventory.new()
@export var unlocked_characters : Resource = UnlockedCharacters.new()

static func exists() -> bool:
	return ResourceLoader.exists(SAVE_FILE_PATH)

func write_to_file():
	ResourceSaver.save(self, SAVE_FILE_PATH)

static func load_file() -> Resource:
	if exists():
		return load(SAVE_FILE_PATH)
	return null

func reset():
	OS.move_to_trash(ProjectSettings.globalize_path(SAVE_FILE_PATH))
