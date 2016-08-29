
extends Control

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	get_node("Knight/Sprite").set_frame(7*13)
	get_node("KnightWait").connect("pressed",get_node("Knight"),"wait")
	get_node("AttackArcher").connect("pressed",get_node("Knight"),'attack',[get_node("Archer")])
	
	get_node("Archer/Sprite").set_frame(5*13)
	get_node("ArcherWait").connect("pressed",get_node("Archer"),'wait')
	get_node("AttackKnight").connect("pressed",get_node("Archer"),'attack',[get_node("Knight")])
