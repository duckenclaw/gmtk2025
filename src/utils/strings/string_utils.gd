extends Node
class_name StringUtils

#static func get_date_time_string():
	#var time = OS.get_datetime()
	#return str(time.day) + "." + str(time.month) + "." + str(time.year) + " " +\
		#str(time.hour) + ":" + str(time.minute) + ":" + str(time.second)

static func begins_with_one_of(string: String, subsequences: Array[String]) -> bool:
	for subsequence in subsequences:
		if string.begins_with(subsequence):
			return true
	return false

static func last_symbol(string: String) -> String:
	return string.substr(string.length() - 1)

static func get_filename_without_extension(path: String) -> String:
	var start_index = path.rfind("/") + 1
	var end_index = path.rfind(".")
	var filename_without_extension = path.substr(start_index, end_index - start_index)
	return filename_without_extension

static func join_with_or(items: Array) -> String:
	if items.size() == 0:
		return ""
	elif items.size() == 1:
		return items[0]
	elif items.size() == 2:
		return "%s or %s" % [items[0], items[1]]
	else:
		return "%s, or %s" % [", ".join(items.slice(0, -1)), items[-1]]

static func get_resource_properties_string(resource: Resource) -> String:
	if resource == null:
		return "null"
	
	var result := "\n" + resource.get_class() + "("
	var filtered_props = get_properties_without_base(resource)
	for prop in filtered_props:
		var name = prop.name
		var value = resource.get(name)
		result += "\n    %s: %s" % [name, str(value)]
	result += "\n)"
	return result

static func get_properties_without_base(resource: Resource) -> Array:
	var all_props := resource.get_property_list()
	var parent_props := Resource.new().get_property_list()
	var parent_prop_names := parent_props.map(func(p): return p.name)
	
	var result_props: Array

	for prop in all_props:
		if not parent_prop_names.has(prop.name):
			result_props.append(prop)

	return result_props
