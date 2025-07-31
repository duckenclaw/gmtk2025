extends Node
class_name NF # NumberFormat

const MAX_NUMBERS = 4

enum NumberFormatType {
	LETTER_SUFFIXES,
	POWERS_OF_TEN,
}

static var format_type: NumberFormatType = NumberFormatType.LETTER_SUFFIXES

static func min_sec(seconds_total: int) -> String:
	var hours: int = seconds_total / 3600
	var minutes: int = (seconds_total % 3600) / 60
	var seconds: int = seconds_total % 60

	var parts: Array[String] = []

	if hours > 0:
		parts.append("%d h." % hours)
	if minutes > 0 or hours > 0:
		parts.append("%d min." % minutes)
	
	parts.append("%d sec." % seconds)

	return " ".join(parts)

static func big_int(value: float) -> String:
	match format_type:
		NumberFormatType.LETTER_SUFFIXES:
			return format_number_letter_suffixes(value)
		NumberFormatType.POWERS_OF_TEN:
			return format_number_powers_of_10(value)
	return "ERROR"


static func big(value: float) -> String:
	match format_type:
		NumberFormatType.LETTER_SUFFIXES:
			return format_number_letter_suffixes(value)
		NumberFormatType.POWERS_OF_TEN:
			return format_number_powers_of_10(value)
	return "ERROR"

static func format_number_letter_suffixes(value: float) -> String:
	var suffixes: Array[String] = ["", "K", "M", "B", "T", "Q", "S"]
	return format_number_with_suffixes(value, suffixes, 1000)

static func format_number_powers_of_10(value: float) -> String:
	var suffixes: Array[String] = ["", " * ^3", " * ^6", " * ^9", " * ^12", " * ^15", " * ^18"]
	return format_number_with_suffixes(value, suffixes, 1000)

static func format_number_with_suffixes(value: float, suffixes: Array[String], base: int) -> String:
	var abs_value: float = abs(value)
	var index: int = 0
	
	if abs_value < base:
		var result = str(int(abs_value))
		if value < 0:
			result = "-" + result
		return result

	while abs_value >= base and index < suffixes.size() - 1:
		abs_value /= base
		index += 1

	var integer_part: int = int(abs_value)
	var int_len: int = str(integer_part).length()
	var decimal_places: int = max(0, MAX_NUMBERS - int_len)

	# Format with the allowed decimal places
	var format_str: String = "%." + str(decimal_places) + "f"
	var result: String = format_str % abs_value

	# Remove trailing .0 or unnecessary zeroes
	if "." in result:
		while result.ends_with("0"):
			result = result.left(result.length() - 1)
		if result.ends_with("."):
			result = result.left(result.length() - 1)
	
	#var extra_spaces = MAX_NUMBERS + 1 - result.length()
	#var dot_position = result.find(".")
	#if dot_position > 0:
		#extra_spaces += result.length() - dot_position
	#result = " ".repeat(extra_spaces) +  result
	
	if value < 0:
		result = "-" + result

	return result + suffixes[index]
