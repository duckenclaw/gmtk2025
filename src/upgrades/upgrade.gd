extends Resource
class_name Upgrade

var title: String = "Upgrade"
var mult: float = 1.0
var desctiption: String = ""
var texture: CompressedTexture2D

var condition: Callable
var action: Callable
