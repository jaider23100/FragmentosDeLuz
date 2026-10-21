class_name Enemigo
extends CharacterBody2D
## Clase base de los enemigos: vida, golpes recibidos y daño por contacto al caballero.
##
## Las clases hijas implementan [method _mover] con su comportamiento propio.

## Golpes de espada necesarios para derrotar al enemigo (RN-05).
@export var vida_maxima: int = 1

var vida: int = 1

var _caballero_en_contacto: Caballero = null


func _ready() -> void:
	vida = vida_maxima


func _physics_process(delta: float) -> void:
	_mover(delta)
	if _caballero_en_contacto != null:
		_caballero_en_contacto.recibir_dano()


## Resta 1 de vida; al llegar a 0 el enemigo muere (RN-05).
func recibir_golpe() -> void:
	if vida <= 0:
		return
	vida -= 1
	if vida == 0:
		morir()
	else:
		_al_recibir_golpe()


## Suma los puntos del enemigo derrotado (RN-04) y lo elimina del nivel.
func morir() -> void:
	EstadoJuego.registrar_enemigo_derrotado()
	queue_free()


## Comportamiento propio de cada enemigo; lo implementan las clases hijas.
func _mover(_delta: float) -> void:
	pass


## Reacción a un golpe que no lo derrota; la pueden implementar las clases hijas.
func _al_recibir_golpe() -> void:
	pass


func _on_area_dano_body_entered(body: Node2D) -> void:
	if body is Caballero:
		_caballero_en_contacto = body as Caballero


func _on_area_dano_body_exited(body: Node2D) -> void:
	if body == _caballero_en_contacto:
		_caballero_en_contacto = null
