extends GutTest
## Pruebas de los movimientos especiales del caballero (RF-02, RF-03).
##
## El caballero se crea sin suelo debajo, así que is_on_floor() es false (está en el aire).

const EscenaCaballero: PackedScene = preload("res://scenes/jugador/caballero.tscn")

var _caballero: Caballero


func before_each() -> void:
	EstadoJuego.reiniciar()
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


func test_ataque_bloqueado_durante_el_enfriamiento() -> void:
	assert_true(_caballero.atacar(), "RF-04: primer ataque")
	assert_eq(_caballero.estado, Caballero.Estado.ATACANDO)
	assert_false(_caballero.atacar(), "RF-04: no hay segundo ataque antes de 0,35 s")
	await wait_seconds(_caballero.enfriamiento_ataque + 0.05)
	assert_true(_caballero.atacar(), "RF-04: tras el enfriamiento vuelve a atacar")


func test_dano_pasa_a_herido_con_retroceso() -> void:
	_caballero.direccion = 1
	_caballero.recibir_dano()
	assert_eq(_caballero.estado, Caballero.Estado.HERIDO, "RF-05: estado HERIDO")
	assert_eq(EstadoJuego.corazones, 2, "RN-01: pierde un corazón")
	assert_lt(_caballero.velocity.x, 0.0, "RF-05: retrocede en sentido contrario a donde mira")


func test_dano_durante_invulnerabilidad_no_resta() -> void:
	_caballero.recibir_dano()
	_caballero.recibir_dano()
	assert_eq(EstadoJuego.corazones, 2, "RN-02: invulnerable tras el primer golpe")


func test_dano_mortal_pasa_a_muerto() -> void:
	EstadoJuego.corazones = 1
	_caballero.recibir_dano()
	assert_eq(_caballero.estado, Caballero.Estado.MUERTO, "RN-07: sin corazones queda MUERTO")
	assert_false(_caballero.atacar(), "Muerto no puede atacar")


func test_dash_avanza_sin_gravedad_hacia_donde_mira() -> void:
	_caballero.direccion = -1
	_caballero.dash()
	await wait_physics_frames(2)
	assert_eq(_caballero.velocity, Vector2(-_caballero.velocidad_dash, 0.0), "RF-03: horizontal y sin caer")
