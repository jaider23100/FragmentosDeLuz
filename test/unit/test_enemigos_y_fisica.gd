extends GutTest
## Pruebas de los enemigos (RN-04, RN-05) y de la corriente de viento (RF-10).

const EscenaSlime: PackedScene = preload("res://scenes/enemigos/slime.tscn")
const EscenaCaballero: PackedScene = preload("res://scenes/jugador/caballero.tscn")
const EscenaViento: PackedScene = preload("res://scenes/objetos/viento.tscn")


func before_each() -> void:
	EstadoJuego.reiniciar()


func test_slime_muere_con_un_golpe_y_suma_50_puntos() -> void:
	var slime: Slime = EscenaSlime.instantiate()
	add_child_autoqfree(slime)
	slime.recibir_golpe()
	assert_eq(slime.vida, 0, "RN-05: el slime se derrota con 1 golpe")
	assert_eq(EstadoJuego.puntos, 50, "RN-04: enemigo derrotado = 50 puntos")
	assert_true(slime.is_queued_for_deletion(), "El slime desaparece del nivel")


func test_enemigo_con_dos_de_vida_resiste_el_primer_golpe() -> void:
	var slime: Slime = EscenaSlime.instantiate()
	slime.vida_maxima = 2
	add_child_autofree(slime)
	slime.recibir_golpe()
	assert_eq(slime.vida, 1, "RN-05: con 2 de vida sigue activo tras un golpe")
	assert_eq(EstadoJuego.puntos, 0, "Todavía no suma puntos")


func test_viento_aplica_y_quita_su_fuerza_al_caballero() -> void:
	var caballero: Caballero = EscenaCaballero.instantiate()
	var viento: Viento = EscenaViento.instantiate()
	add_child_autofree(caballero)
	add_child_autofree(viento)
	viento._on_body_entered(caballero)
	assert_eq(caballero.fuerza_viento, viento.fuerza, "RF-10: dentro del viento recibe su fuerza")
	assert_gt(viento.fuerza, caballero.gravedad, "RF-10: la fuerza supera la gravedad, así que sube")
	viento._on_body_exited(caballero)
	assert_eq(caballero.fuerza_viento, 0.0, "RF-10: al salir vuelve la gravedad normal")
