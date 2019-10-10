extends Sprite

const BULLET = preload("res://Utility/Weapons/Rifles/Bullet.tscn")

export(int) var damage = 50

export(int) var _max_ammo
var _ammo : int
export(int) var magazine_size
var magazine : int
var _can_shoot: bool = true

# overrides

func _ready():
    magazine = magazine_size  # one magazine is always loaded

func shoot():
    print("magazine = " + str(magazine))
    if _can_shoot and magazine > 0:
        print("shooting")
        magazine -= 1
        var bullet = BULLET.instance()
        bullet.damage = damage
        bullet.position = $BulletSpawn.global_position
        bullet.direction = -1 if not flip_h else 1
        add_child(bullet)
        _can_shoot = false
        $TimeBtwnShots.start()
        

# own functions
func reload():
    print("reloading")
    print("ammo = " + str(_ammo))
    var diff = magazine_size - magazine
    if _ammo > diff:
        magazine += diff
        _ammo -= diff
    else:
        magazine += _ammo
        _ammo = 0

func add_ammo(amount : int):
    print("added ammo" + str(amount))
    assert (amount > 0)
    _ammo += amount
    if _ammo > _max_ammo:
        _ammo = _max_ammo


func _on_TimeBtwnShots_timeout():
    _can_shoot = true

