extends Node
class_name NodeUtils

static func queue_free_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

static func has_intersecting_groups(node, groups: Array[String]):
	var intersection = ArrayUtils.intersect(node.get_groups(), groups)
	return not ArrayUtils.intersect(node.get_groups(), groups).is_empty()
