extends Sprite

const BULLET = preload("res://Items/Weapons/Rifles/Bullet.tscn")
var hud_node  # this can be a children of the hud too!
export(int) var damage = 50

export(int) var _max_ammo
export(int) var init_ammo
var _ammo : int
export(int) var magazine_size
export(float) var time_to_shoot
var magazine : int
var _can_shoot: bool = true


# overrides
func _ready():
    _ammo = init_ammo
    reload()
    $TimeBtwnShots.wait_time = time_to_shoot

# functions
func pass_hud_node(hud_node_in):
    hud_node = hud_node_in
    assert(hud_node != null)
    hud_node.get_node("Ammo").text = str(_ammo)
    hud_node.get_node("Magazine").text = str(magazine) + "/" + str(magazine_size)

func shoot():
    print("magazine = " + str(magazine))
    if _can_shoot and magazine > 0:
        print("shooting")
        _can_shoot = false
        $TimeBtwnShots.start()
        magazine -= 1
        if hud_node != null:
            hud_node.get_node("Magazine").text = str(magazine)+"/"+str(magazine_size)
        # spawn the bullet
        var bullet = BULLET.instance()
        bullet.damage = damage
        bullet.position = $BulletSpawn.global_position
        bullet.direction = -1 if flip_h else 1
        add_child(bullet)
        

func reload():
    print("reloading")
    var diff = magazine_size - magazine
    if _ammo > diff:
        magazine += diff
        _ammo -= diff
    else:
        magazine += _ammo
        _ammo = 0

    if hud_node != null:
        hud_node.get_node("Ammo").text = str(_ammo)
        hud_node.get_node("Magazine").text = str(magazine) + "/" + str(magazine_size)

func add_ammo(amount : int):
    print("added ammo" + str(amount))
    assert (amount > 0)
    _ammo += amount
    if _ammo > _max_ammo:
        _ammo = _max_ammo
    if hud_node != null:
        hud_node.get_node("Ammo").text = str(_ammo)

func _on_TimeBtwnShots_timeout():
    _can_shoot = true

