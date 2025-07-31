extends Node
class_name DictUtils

static func remove_by_value(dict: Dictionary, value_to_remove) -> void:
	for key in dict.keys():
		if dict[key] == value_to_remove:
			dict.erase(key)
