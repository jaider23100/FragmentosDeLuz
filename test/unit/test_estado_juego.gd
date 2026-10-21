extends GutTest
## Pruebas de las reglas de negocio RN-01 a RN-10 implementadas en EstadoJuego.

const EstadoJuegoScript: GDScript = preload("res://scripts/autoload/estado_juego.gd")

var _estado: Node


func before_each() -> void:
	_estado = EstadoJuegoScript.new()
	add_child_autofree(_estado)


func test_inicia_con_3_corazones_0_puntos_y_0_fragmentos() -> void:
	assert_eq(_estado.corazones, 3, "RN-01: corazones iniciales")
	assert_eq(_estado.puntos, 0)
	assert_eq(_estado.fragmentos, 0)


func test_recibir_dano_resta_un_corazon() -> void:
	var aplicado: bool = _estado.recibir_dano()
	assert_true(aplicado)
	assert_eq(_estado.corazones, 2, "RN-01: de 3 a 2")


func test_corazones_nunca_bajan_de_cero() -> void:
	for i: int in 5:
		_estado.recibir_dano(true)
	assert_eq(_estado.corazones, 0, "RN-01: no baja de 0")


func test_invulnerabilidad_bloquea_dano_durante_un_segundo() -> void:
	_estado.recibir_dano()
	_estado.avanzar_tiempo(0.5)
	var aplicado: bool = _estado.recibir_dano()
	assert_false(aplicado, "RN-02: invulnerable a los 0,5 s")
	assert_eq(_estado.corazones, 2)


func test_invulnerabilidad_termina_despues_de_un_segundo() -> void:
	_estado.recibir_dano()
	_estado.avanzar_tiempo(1.2)
	_estado.recibir_dano()
	assert_eq(_estado.corazones, 1, "RN-02: a los 1,2 s vuelve a recibir daño")


func test_caida_ignora_invulnerabilidad_y_usa_checkpoint() -> void:
	_estado.activar_checkpoint(Vector2(1450, 393))
	_estado.recibir_dano()
	_estado.recibir_dano(true)
	assert_eq(_estado.corazones, 1, "RN-03: la caída siempre resta")
	assert_eq(_estado.obtener_punto_reaparicion(Vector2(40, 392)), Vector2(1450, 393))


func test_sin_checkpoint_reaparece_en_el_inicio() -> void:
	assert_eq(_estado.obtener_punto_reaparicion(Vector2(40, 392)), Vector2(40, 392), "RN-03")


func test_puntaje_de_fragmentos_monedas_y_enemigos() -> void:
	_estado.recoger_fragmento()
	_estado.recoger_fragmento()
	for i: int in 3:
		_estado.registrar_moneda()
	_estado.registrar_enemigo_derrotado()
	assert_eq(_estado.puntos, 280, "RN-04: 2x100 + 3x10 + 50")
	assert_eq(_estado.fragmentos, 2)


func test_mensaje_de_fragmentos_faltantes_en_singular_y_plural() -> void:
	for i: int in 3:
		_estado.recoger_fragmento()
	assert_eq(_estado.mensaje_faltantes(), "Faltan 2 fragmentos", "RN-06: plural")
	_estado.recoger_fragmento()
	assert_eq(_estado.mensaje_faltantes(), "Falta 1 fragmento", "RN-06: singular")


func test_solo_gana_con_los_5_fragmentos() -> void:
	for i: int in 4:
		_estado.recoger_fragmento()
	assert_false(_estado.puede_ganar(), "RN-06: con 4/5 no gana")
	assert_eq(_estado.completar_nivel(), -1)
	_estado.recoger_fragmento()
	assert_true(_estado.puede_ganar(), "RN-06: con 5/5 gana")


func test_derrota_al_llegar_a_cero_corazones() -> void:
	watch_signals(_estado)
	for i: int in 3:
		_estado.recibir_dano(true)
	assert_signal_emitted(_estado, "jugador_murio", "RN-07")
	assert_eq(_estado.fase, EstadoJuegoScript.Fase.DERROTA)


func test_puntaje_final_suma_bono_por_corazones() -> void:
	for i: int in 5:
		_estado.recoger_fragmento()
	_estado.recibir_dano()
	watch_signals(_estado)
	var puntaje_final: int = _estado.completar_nivel()
	assert_eq(puntaje_final, 700, "RN-08: 500 puntos + 2 corazones x 100")
	assert_signal_emitted_with_parameters(_estado, "nivel_completado", [700])


func test_reiniciar_restaura_el_estado_inicial() -> void:
	_estado.recibir_dano()
	_estado.recoger_fragmento()
	_estado.activar_checkpoint(Vector2(100, 100))
	_estado.reiniciar()
	assert_eq(_estado.corazones, 3, "RN-10")
	assert_eq(_estado.puntos, 0)
	assert_eq(_estado.fragmentos, 0)
	assert_false(_estado.hay_checkpoint)
