extends Object
class_name Parse

static func digit(val : int, digits : int = 2) -> String :
	var text : String = str(val)
	return "0".repeat(digits - text.length()) + text
	
static func enums(text : String, names: Array[String]) -> int :
	for i in range(names.size()):
		if names[i] == text:
			return i
	return -1 # _value not found
