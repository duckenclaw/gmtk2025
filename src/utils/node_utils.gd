extends Node
class_name NodeUtils

static func queue_free_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
