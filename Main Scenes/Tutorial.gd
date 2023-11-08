extends Node2D

#Each time you make a new enemy instance, instantiate them by defining it as
#a variable and then connecting it to the current player instance and
#connect its signals to the main scene
onready var player: Player = $Player

onready var key1 = $Key
onready var door1 = $Door

onready var B2 = $B1
onready var B3 = $B2
onready var B4 = $B3
onready var B5 = $B4
onready var B6 = $B5
 
onready var R2 = $R1
onready var R3 = $R2
onready var R4 = $R3
onready var R5 = $R4

onready var G2 = $G1
onready var G3 = $G2
onready var G4 = $G3

onready var a_e_1 = $a_e_1
onready var a_e_2 = $a_e_2
onready var a_e_3 = $a_e_3
onready var a_e_4 = $a_e_4


onready var rocket1 = $RT1

onready var turret1 = $T1


func _ready():
	get_tree().call_group("archers", "init_player")

	a_e_1.player = player
	a_e_2.player = player
	a_e_3.player = player
	a_e_4.player = player
	
	rocket1.player = player
	turret1.player = player
	
	key1.door = door1
	key1.connect("key_picked_up", self, "door_open")
	
	player.connect("player_fired_bullet", self, "handle_bullet_spawned")
	player.connect("player_fired_laser", self, "handle_laser_spawned")
	player.connect("player_switched_weapon", self, "handle_switched_weapon")
	
	B2.connect("picked_up", self, "ammo_pick_up")
	B3.connect("picked_up", self, "ammo_pick_up")
	B4.connect("picked_up", self, "ammo_pick_up")
	B5.connect("picked_up", self, "ammo_pick_up")
	B6.connect("picked_up", self, "ammo_pick_up")
	
	R2.connect("picked_up", self, "ammo_pick_up")
	R3.connect("picked_up", self, "ammo_pick_up")
	R4.connect("picked_up", self, "ammo_pick_up")
	R5.connect("picked_up", self, "ammo_pick_up")

	G2.connect("picked_up", self, "ammo_pick_up")
	G3.connect("picked_up", self, "ammo_pick_up")
	G4.connect("picked_up", self, "ammo_pick_up")
	
	
	rocket1.connect("rocket", self, "handle_enemy_rocket_spawned")
	turret1.connect("shoot", self, "handle_enemy_bullet_spawned")
	
	a_e_1.connect("shoot", self, "handle_enemy_bullet_spawned")
	a_e_2.connect("shoot", self, "handle_enemy_bullet_spawned")
	a_e_3.connect("shoot", self, "handle_enemy_bullet_spawned")
	a_e_4.connect("shoot", self, "handle_enemy_bullet_spawned")


func handle_enemy_rocket_spawned(bullet: Explosive, a_position: Vector2, direction: Vector2):
	add_child(bullet)
	bullet.global_position = a_position
	bullet.set_direction(direction)


func handle_bullet_spawned(bullet: FireBall, a_position: Vector2, direction: Vector2):
	add_child(bullet)
	bullet.global_position = a_position
	bullet.set_direction(direction)


func handle_enemy_bullet_spawned(bullet: EnemyShot, a_position: Vector2, direction: Vector2):
	add_child(bullet)
	bullet.global_position = a_position
	bullet.set_direction(direction)

func ammo_pick_up(type: int):
	if type == 0:
		player.red_ammo += 10
	elif type == 1:
		player.blue_ammo += 5
	elif type == 2:
		player.green_ammo += 2

func handle_switched_weapon(weapon: int):
	pass

func handle_laser_spawned(bullet: Laser, a_position: Vector2, direction: Vector2):
	add_child(bullet)
	bullet.set_is_casting(true)
	var fire_to = a_position + (direction * 100)
	#Sets the laser origin to the player's wand point
	bullet.global_position = a_position
	#Because the origin is now set to the player, we need to subtract the wand
	#coordinates from the coordinates of where the player clicked to get the 
	#relative end point of the raycast
	bullet.cast_to = fire_to-a_position
	#The origin is now the wand point, so the laser is drawn starting from origin
	bullet.get_node("Line2D").add_point(Vector2(0,0))
	bullet.get_node("Line2D").add_point(fire_to-a_position)


func door_open(door: door):
	door.queue_free()
