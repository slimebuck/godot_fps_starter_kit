extends Spatial

export (int, "full size", "small") var kit_size = 1 setget kit_size_change

## 0 = full size pickup, 1 = small pickup
const HEALTH_AMOUNTS = [70, 30]

const RESPAWN_TIME = 20

var respawn_timer = 0
var is_ready = false

func _ready():
	$Holder/Health_Pickup_Trigger.connect("body_entered", self, "trigger_body_entered")

	is_ready = true

	kit_size_change_values(0, false)
	kit_size_change_values(1, false)
	kit_size_change_values(kit_size, true)


func _physics_process(delta):
	if respawn_timer > 0:
		respawn_timer -= delta

		if respawn_timer <= 0:
			kit_size_change_values(kit_size, true)


func kit_size_change(value):
	if is_ready:
		kit_size_change_values(kit_size, false)
		kit_size = value
		kit_size_change_values(kit_size, true)
	else:
		kit_size = value


func kit_size_change_values(size, enable):
	if size == 0:
		$Holder/Health_Pickup_Trigger/Shape_Kit.disabled = !enable
		$Holder/Health_Kit.visible = enable
	elif size == 1:
		$Holder/Health_Pickup_Trigger/Shape_Kit_Small.disabled = !enable
		$Holder/Health_Kit_Small.visible = enable


func trigger_body_entered(body):
	if body.has_method("add_health"):
		body.add_health(HEALTH_AMOUNTS[kit_size])
		kit_size_change_values(kit_size, false)

		create_sound("pickupitem")


func create_sound(sound_name, position=null):
	## Play the inputted sound at the inputted position
	## (NOTE: it will only play at the inputted position if you are using a AudioPlayer3D node)
	Globals.play_sound(sound_name, false, position)