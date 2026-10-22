extends GutTest
## Pruebas de la máquina de estados del murciélago (RF-08, RN-05, diagrama DE-02).

const EscenaMurcielago: PackedScene = preload("res://scenes/enemigos/murcielago.tscn")

var _murcielago: Murcielago


func before_each() -> void:
	EstadoJuego.reiniciar()
	_murcielago = EscenaMurcielago.instantiate()
	add_child_autofree(_murcielago)


func test_despierta_y_persigue_cuando_el_caballero_se_acerca() -> void:
	assert_eq(_murcielago.evaluar_estado(100.0, 0.0), Murcielago.Estado.DORMIDO, "A 100 px sigue dormido")
	assert_eq(_murcielago.evaluar_estado(70.0, 0.0), Murcielago.Estado.PERSIGUIENDO, "RF-08: a menos de 80 px persigue")


func test_regresa_cuando_el_caballero_se_aleja_y_vuelve_a_dormir() -> void:
	_murcielago.estado = Murcielago.Estado.PERSIGUIENDO
	assert_eq(_murcielago.evaluar_estado(150.0, 40.0), Murcielago.Estado.REGRESANDO, "RF-08: a más de 140 px regresa")
	_murcielago.estado = Murcielago.Estado.REGRESANDO
	assert_eq(_murcielago.evaluar_estado(150.0, 1.0), Murcielago.Estado.DORMIDO, "Al llegar a su origen duerme")


func test_muere_con_dos_golpes() -> void:
	_murcielago.recibir_golpe()
	assert_eq(_murcielago.vida, 1, "RN-05: sigue activo tras el primer golpe")
	_murcielago.recibir_golpe()
	assert_eq(_murcielago.estado, Murcielago.Estado.MUERTO, "RN-05: muere con el segundo")
	assert_eq(EstadoJuego.puntos, 50, "RN-04: suma 50 puntos")
