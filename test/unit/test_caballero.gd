extends GutTest
## Pruebas de los movimientos especiales del caballero (RF-02, RF-03).
##
## El caballero se crea sin suelo debajo, así que is_on_floor() es false (está en el aire).

const EscenaCaballero: PackedScene = preload("res://scenes/jugador/caballero.tscn")

var _caballero: Caballero


func before_each() -> void:
	_caballero = EscenaCaballero.instantiate()
	add_child_autofree(_caballero)
	await wait_physics_frames(1)


func test_doble_salto_solo_una_vez_en_el_aire() -> void:
	assert_true(_caballero.doble_salto(), "RF-02: primer salto aéreo")
	assert_eq(_caballero.velocity.y, -_caballero.velocidad_doble_salto)
	assert_eq(_caballero.estado, Caballero.Estado.DOBLE_SALTO)
	assert_false(_caballero.doble_salto(), "RF-02: no hay tercer salto")


func test_dash_en_el_aire_solo_una_vez_por_salto() -> void:
	assert_true(_caballero.dash(), "RF-03: primer dash en el aire")
	assert_eq(_caballero.estado, Caballero.Estado.DASH)
	await wait_seconds(_caballero.duracion_dash + _caballero.enfriamiento_dash + 0.1)
	assert_true(_caballero.puede_dash, "El enfriamiento terminó")
	assert_false(_caballero.dash(), "RF-03: sin tocar el suelo no hay segundo dash")


func test_dash_bloqueado_durante_el_enfriamiento() -> void:
	_caballero.dash()
	assert_false(_caballero.puede_dash, "RF-03: enfriamiento activo")
	assert_false(_caballero.dash())


func test_dash_avanza_sin_gravedad_hacia_donde_mira() -> void:
	_caballero.direccion = -1
	_caballero.dash()
	await wait_physics_frames(2)
	assert_eq(_caballero.velocity, Vector2(-_caballero.velocidad_dash, 0.0), "RF-03: horizontal y sin caer")
