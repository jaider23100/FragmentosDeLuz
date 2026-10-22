class_name Moneda
extends Coleccionable
## Moneda opcional: suma 10 puntos (RF-12, RN-04).


func _al_recoger() -> void:
	EstadoJuego.registrar_moneda()
	GestorAudio.reproducir_efecto("moneda")
