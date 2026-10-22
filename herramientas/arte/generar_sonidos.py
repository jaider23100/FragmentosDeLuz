"""Sintetiza los efectos de sonido propios de Fragmentos de Luz (estilo 8 bits). Recurso propio del equipo.

Genera: doble_salto, dash, espada, golpe_enemigo, checkpoint y victoria (WAV mono, 22 050 Hz, 16 bits).
Uso: python generar_sonidos.py <carpeta_salida>
"""
import math
import random
import struct
import sys
import wave
from pathlib import Path

FRECUENCIA_MUESTREO = 22050


def onda(tipo: str, fase: float) -> float:
    if tipo == "cuadrada":
        return 1.0 if (fase % 1.0) < 0.5 else -1.0
    if tipo == "triangular":
        return 4.0 * abs((fase % 1.0) - 0.5) - 1.0
    if tipo == "ruido":
        return random.uniform(-1.0, 1.0)
    return math.sin(2 * math.pi * fase)


def barrido(tipo: str, f_inicio: float, f_fin: float, duracion: float, volumen: float = 0.4) -> list[float]:
    """Tono que va de f_inicio a f_fin con envolvente de ataque corto y caída lineal."""
    n = int(duracion * FRECUENCIA_MUESTREO)
    muestras, fase = [], 0.0
    for i in range(n):
        t = i / n
        fase += (f_inicio + (f_fin - f_inicio) * t) / FRECUENCIA_MUESTREO
        envolvente = min(1.0, i / 120) * (1.0 - t)
        muestras.append(onda(tipo, fase) * envolvente * volumen)
    return muestras


def notas(secuencia: list[tuple[float, float]], tipo: str = "cuadrada", volumen: float = 0.35) -> list[float]:
    resultado: list[float] = []
    for frecuencia, duracion in secuencia:
        resultado += barrido(tipo, frecuencia, frecuencia, duracion, volumen)
    return resultado


def guardar(ruta: Path, muestras: list[float]) -> None:
    with wave.open(str(ruta), "wb") as archivo:
        archivo.setnchannels(1)
        archivo.setsampwidth(2)
        archivo.setframerate(FRECUENCIA_MUESTREO)
        archivo.writeframes(b"".join(struct.pack("<h", int(max(-1.0, min(1.0, m)) * 32767)) for m in muestras))


def main() -> None:
    random.seed(7)
    salida = Path(sys.argv[1])
    salida.mkdir(parents=True, exist_ok=True)
    sonidos = {
        "doble_salto": barrido("cuadrada", 420, 980, 0.16) + barrido("triangular", 980, 1300, 0.08, 0.25),
        "dash": barrido("ruido", 0, 0, 0.14, 0.35),
        "espada": barrido("ruido", 0, 0, 0.05, 0.3) + barrido("cuadrada", 1400, 600, 0.07, 0.25),
        "golpe_enemigo": barrido("cuadrada", 260, 90, 0.12, 0.45),
        "checkpoint": notas([(523, 0.08), (659, 0.08), (784, 0.16)], "triangular", 0.4),
        "victoria": notas([(523, 0.12), (659, 0.12), (784, 0.12), (1047, 0.36)], "cuadrada", 0.3),
    }
    for nombre, muestras in sonidos.items():
        guardar(salida / f"{nombre}.wav", muestras)
        print(f"{nombre}.wav ({len(muestras) / FRECUENCIA_MUESTREO:.2f} s)")


if __name__ == "__main__":
    main()
