class_name Puas
extends Area2D
## Púas: quitan un corazón al caballero mientras las toca (RF-05, RN-01, RN-02).

var _caballero_en_contacto: Caballero = null


func _physics_process(_delta: float) -> void:
	if _caballero_en_contacto != null:
		_caballero_en_contacto.recibir_dano()


func _on_body_entered(body: Node2D) -> void:
	if body is Caballero:
		_caballero_en_contacto = body as Caballero


func _on_body_exited(body: Node2D) -> void:
	if body == _caballero_en_contacto:
		_caballero_en_contacto = null
