extends Node
class_name ArrayUtils

static func create_array(length: int) -> Array:
	var array = Array()
	array.resize(length)
	array.fill(null)
	return array

static func fill_array(array: Array, create_item: Callable):
	for i in array.size():
		array[i] = create_item
	return array

static func filter_array_from_nulls(array: Array) -> Array:
	var new_array = Array()
	for item in array:
		if is_instance_valid(item):
			new_array.append(item)
	return new_array

static func arrays_are_equal(array1: Array[int], array2: Array[int]) -> bool:
	if array1.size() != array2.size():
		return false
	
	for i in array1.size():
		if array1[i] != array2[i]:
			return false
	
	return true

static func first(array: Array[Variant], condition: Callable) -> Variant:
	for item in array:
		if condition.call(item):
			return item
	return null

static func intersect(array1: Array, array2: Array):
	var intersection = []
	for item in array1:
		if array2.has(item):
			intersection.append(item)
	return intersection


#static func map(array: Array, map_function: FuncRef) -> Array:
	#var output := []
	#for value in array:
		#output.append(map_function.call_func(value))
	#return output

static func map_by_var(array: Array, var_name: String) -> Array:
	var output := []
	for value in array:
		output.append(value.get(var_name))
	return output

#static func filter(array: Array, filter_function: FuncRef) -> Array:
	#var output := []
	#for value in array:
		#if filter_function.call_func(value):
			#output.append(value)
	#return output
#
#static func sort_by_var(array: Array, var_name: String) -> Array:
	#var output := Array()
	#output.append_array(array)
	#output.sort_custom(VarComparator.new(var_name), "compare")
	#return output
#
#static func sort_by_func(array: Array, func_name: String) -> Array:
	#var output := Array()
	#output.append_array(array)
	#output.sort_custom(FuncComparator.new(func_name), "compare")
	#return output

# Ascending sorter
class VarComparator:
	var var_name: String
	
	func _init(var_name):
		self.var_name = var_name
	
	func compare(a, b) -> bool:
		return a.get(var_name) < b.get(var_name)


# Ascending sorter
class FuncComparator:
	var func_name: String
	
	func _init(func_name):
		self.func_name = func_name
	
	func compare(a, b) -> bool:
		return a.call(func_name) < b.call(func_name)
