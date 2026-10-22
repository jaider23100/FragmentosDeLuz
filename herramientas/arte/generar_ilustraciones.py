"""Ilustraciones de la introducción y del final (320x110), compuestas con los sprites propios. Arte propio.

Uso: python generar_ilustraciones.py <carpeta_sprites> <carpeta_salida>
"""
import random
import sys
from pathlib import Path

from PIL import Image, ImageDraw

ANCHO, ALTO = 320, 110
FONDO = (24, 30, 27)
SUELO = (61, 52, 40)
CIAN, CIAN_CLARO = (95, 243, 255), (220, 255, 255)
MORADO, MORADO_OSCURO, NEGRO = (74, 44, 102), (46, 26, 64), (26, 26, 36)


def cuadro(hoja: Image.Image, indice: int, ancho: int) -> Image.Image:
    return hoja.crop((indice * ancho, 0, (indice + 1) * ancho, hoja.height))


def estrellas(dibujo: ImageDraw.ImageDraw, cantidad: int, color: tuple[int, int, int]) -> None:
    for _ in range(cantidad):
        dibujo.point((random.randrange(ANCHO), random.randrange(ALTO - 30)), fill=color)


def morvak(dibujo: ImageDraw.ImageDraw, x: int, y: int) -> None:
    """Hechicero encapuchado: túnica triangular, capucha y ojos rojos."""
    dibujo.polygon([(x, y - 44), (x + 18, y), (x - 18, y)], fill=NEGRO)
    dibujo.polygon([(x, y - 42), (x + 15, y - 2), (x - 15, y - 2)], fill=MORADO_OSCURO)
    dibujo.polygon([(x, y - 42), (x + 7, y - 2), (x - 3, y - 2)], fill=MORADO)
    dibujo.ellipse([x - 8, y - 46, x + 8, y - 30], fill=NEGRO)
    dibujo.ellipse([x - 6, y - 44, x + 6, y - 32], fill=MORADO_OSCURO)
    dibujo.point([(x - 2, y - 38), (x + 2, y - 38)], fill=(217, 67, 59))
    dibujo.line([(x + 10, y - 26), (x + 24, y - 40)], fill=NEGRO, width=2)


def intro(sprites: Path) -> Image.Image:
    imagen = Image.new("RGB", (ANCHO, ALTO), FONDO)
    dibujo = ImageDraw.Draw(imagen)
    estrellas(dibujo, 40, (70, 80, 75))
    dibujo.rectangle([0, ALTO - 14, ANCHO, ALTO], fill=SUELO)
    santuario = cuadro(Image.open(sprites / "objetos" / "santuario.png").convert("RGBA"), 0, 32)
    imagen.paste(santuario, (60, ALTO - 14 - 32), santuario)
    morvak(dibujo, 180, ALTO - 14)
    fragmento = cuadro(Image.open(sprites / "objetos" / "fragmento.png").convert("RGBA"), 1, 8)
    for i, (fx, fy) in enumerate([(205, 40), (222, 28), (240, 46), (232, 66), (214, 58)]):
        imagen.paste(fragmento, (fx, fy), fragmento)
        dibujo.line([(196, 54), (fx + 3, fy + 4)], fill=(40, 120, 130))
    return imagen


def final(sprites: Path) -> Image.Image:
    imagen = Image.new("RGB", (ANCHO, ALTO), (30, 42, 48))
    dibujo = ImageDraw.Draw(imagen)
    centro = (160, 52)
    for i in range(16):
        angulo = i * 22.5
        import math
        fin = (centro[0] + math.cos(math.radians(angulo)) * 140, centro[1] + math.sin(math.radians(angulo)) * 140)
        dibujo.line([centro, fin], fill=(45, 70, 78), width=3)
    estrellas(dibujo, 30, (120, 160, 170))
    dibujo.rectangle([0, ALTO - 14, ANCHO, ALTO], fill=(74, 70, 52))
    santuario = cuadro(Image.open(sprites / "objetos" / "santuario.png").convert("RGBA"), 1, 32).resize((64, 64), Image.NEAREST)
    imagen.paste(santuario, (128, ALTO - 14 - 64), santuario)
    caballero = cuadro(Image.open(sprites / "caballero" / "caballero_quieto.png").convert("RGBA"), 0, 24)
    imagen.paste(caballero, (96, ALTO - 14 - 24 + 1), caballero)
    for x, y in [(110, 20), (210, 26), (190, 12), (128, 30), (232, 50), (90, 44)]:
        dibujo.point((x, y), fill=CIAN_CLARO)
        dibujo.point([(x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)], fill=CIAN)
    return imagen


def main() -> None:
    random.seed(3)
    sprites, salida = Path(sys.argv[1]), Path(sys.argv[2])
    salida.mkdir(parents=True, exist_ok=True)
    intro(sprites).save(salida / "ilustracion_intro.png")
    final(sprites).save(salida / "ilustracion_final.png")
    print("ilustraciones en", salida)


if __name__ == "__main__":
    main()
