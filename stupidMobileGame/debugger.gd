extends Control

onready var container = $VBoxContainer
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func cos_show(txt:Array):
	$VBoxContainer/Label1.text = str(txt[0])
	$VBoxContainer/Label2.text = str(txt[1])
	$VBoxContainer/Label3.text = str(txt[2])
