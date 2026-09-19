"""Genera SPLASH_android12.png a partir de SPLASH.png.

Android 12+ (windowSplashScreenAnimatedIcon, ver pubspec.yaml) fuerza
CUALQUIER imagen puesta ahi a un icono pequeno con margen de seguridad -
usar el diseno completo de SPLASH.png sin ajustar cortaba "esri Colombia".
Este script no cambia el diseno: toma el bbox real del contenido (todo lo
que no es el color de fondo), lo escala para que el lado mas grande ocupe
como maximo TARGET_FILL del lienzo, y lo centra sobre el mismo color de
fondo muestreado del propio PNG (no un hex a mano, para que la costura sea
invisible).

Correr de nuevo si SPLASH.png cambia:
    python assets/splash/generar_splash_android12.py
"""

from pathlib import Path

from PIL import Image

CARPETA = Path(__file__).parent
SRC = CARPETA / "SPLASH.png"
DST = CARPETA / "SPLASH_android12.png"
TARGET_FILL = 0.50


def bbox_contenido(img: Image.Image, bg: tuple[int, int, int], tol: int = 20):
    px = img.load()
    w, h = img.size
    minx, miny, maxx, maxy = w, h, 0, 0
    for y in range(h):
        for x in range(w):
            r, g, b = px[x, y]
            br, bgc, bb = bg
            if abs(r - br) > tol or abs(g - bgc) > tol or abs(b - bb) > tol:
                minx, miny = min(minx, x), min(miny, y)
                maxx, maxy = max(maxx, x), max(maxy, y)
    return minx, miny, maxx, maxy


def main() -> None:
    img = Image.open(SRC).convert("RGB")
    w, h = img.size
    bg = img.getpixel((0, 0))

    minx, miny, maxx, maxy = bbox_contenido(img, bg)
    content_w, content_h = maxx - minx, maxy - miny
    print(
        f"contenido actual: {content_w}x{content_h} sobre {w}x{h} "
        f"({content_w / w:.0%} x {content_h / h:.0%})"
    )

    scale = (TARGET_FILL * w) / max(content_w, content_h)
    print(f"factor de escala: {scale:.3f}")

    nuevo_w, nuevo_h = round(w * scale), round(h * scale)
    escalada = img.resize((nuevo_w, nuevo_h), Image.LANCZOS)

    canvas = Image.new("RGB", (w, h), bg)
    offset = ((w - nuevo_w) // 2, (h - nuevo_h) // 2)
    canvas.paste(escalada, offset)
    canvas.save(DST)
    print(f"guardado: {DST} ({w}x{h}, fondo {bg})")


if __name__ == "__main__":
    main()
