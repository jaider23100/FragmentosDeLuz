class_name Fragmento
extends Coleccionable
## Fragmento del Cristal de Luz: suma 1 al contador y 100 puntos (RF-11, RN-04).


func _al_recoger() -> void:
	EstadoJuego.recoger_fragmento()
