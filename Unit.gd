
extends Control
export(int) var HP #Hit points
export(int) var Exertion #The resource to use anything with
export(int) var Dexterity #ranged Attack Power && Dodge Chance
export(int) var Intelligence #magic Attack Power && Mana Regen
export(int) var Strength #melee Attack Power && Damage Mitigation

var _HP #The amount after some was taken away
var _Exertion #the amount after some was consumed

export(int) var AttackCost

export(String, "Magic", "Melee", "Ranged") var AttackType
export(String, MULTILINE) var UnitName = ''
export(Texture) var UnitImage
#attacks the target which is another unit
func attack(target):
	if _Exertion < AttackCost:
		get_node("CombatText").set_text("Not Enough Exertion. Wait and then try again")
		return
	var attackPower
	if AttackType == "Magic":
		attackPower = Intelligence
	elif AttackType == "Melee":
		attackPower = Strength
	elif AttackType == "Ranged":
		attackPower = Dexterity

	var absorbed = round(attackPower*(target.Strength*0.1))

	var totalDamage = attackPower - absorbed
	
	var dodged = false
	
	#This is bad. Don't do chance like this in a real game. Use a d20 or 3D6 so the chances are more consistant.
	var ch = rand_range(1,100)
	print(ch)
	if ch < target.Dexterity*10:
		totalDamage = 0
		dodged = true
	
	target.takeDamage(totalDamage,dodged)
	consumeExertion(AttackCost)

func consumeExertion(amount):
	_Exertion = _Exertion-amount
	get_node("Exertion").set_text(str(_Exertion))

func wait():
	_Exertion += 1+Intelligence
	if _Exertion > Exertion:
		_Exertion = Exertion
	get_node("Exertion").set_text(str(_Exertion))
	get_node("CombatText").set_text("Rested...restored "+str(1+Intelligence)+" Exertion")

func takeDamage(amount,dodged):
	_HP = _HP-amount
	if _HP > 0 :
		get_node("HP").set_text(str(_HP))
		if dodged:
			get_node("CombatText").set_text("DODGED!")
		else:
			get_node("CombatText").set_text("-"+str(amount)+" HP")
	else:
		die()

func die():
	print("Do something with death here")
	get_node("HP").set_text("Dead")
	get_node("Sprite").set_frame((20*13)+5)

func _ready():
	_Exertion = Exertion
	_HP = HP
	get_node("Exertion").set_text(str(_Exertion))
	get_node("HP").set_text(str(_HP))
	get_node("UnitName").set_text(UnitName)
	get_node("Sprite").set_texture(UnitImage)
