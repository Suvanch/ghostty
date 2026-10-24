"""Make a dark, ink-toned copy of a print for use behind terminal text.

usage: sumi_tone.py <input.jpg> <output.jpg> <preview.png>
"""
import sys
from PIL import Image, ImageChops, ImageDraw, ImageFont, ImageOps

BG = (0x12, 0x11, 0x10)  # Sumi theme background
TEXT = (0xE3, 0xD9, 0xC3)  # Sumi theme foreground
KEEP_COLOR = 0.5  # 0 = grey ink, 1 = original colors
STRENGTH = 0.35  # brightness ceiling; dial it down live with background-image-opacity
LEFT = 0.25  # strength on the left (text side) relative to the right


def smoothstep(a, b, x):
    t = min(max((x - a) / (b - a), 0.0), 1.0)
    return t * t * (3 - 2 * t)


src, dst, preview = sys.argv[1:4]
img = Image.open(src).convert("RGB")

gray = ImageOps.grayscale(img).convert("RGB")
toned = Image.blend(gray, img, KEEP_COLOR)

# Left-to-right fade: dim where text sits, strongest on the right
ramp = Image.linear_gradient("L").rotate(90).resize(img.size)
ramp = ramp.point(
    lambda v: round(255 * STRENGTH * (LEFT + (1 - LEFT) * smoothstep(0.3, 0.7, v / 255)))
)
toned = ImageChops.multiply(toned, Image.merge("RGB", [ramp] * 3))

out = ImageChops.add(Image.new("RGB", img.size, BG), toned)
out.save(dst, quality=92)

# Preview with sample terminal text on top
p = out.copy()
draw = ImageDraw.Draw(p)
try:
    font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf", 26)
except OSError:
    font = ImageFont.load_default()
for i in range(30):
    y = 30 + i * 41
    draw.text((40, y), "~/Desktop/Projects  ls -la  drwxr-xr-x  suvanch  4096  config", fill=TEXT, font=font)
    draw.text((1000, y), "readable text test 0123456789", fill=TEXT, font=font)
p.save(preview)
print("wrote", dst)
