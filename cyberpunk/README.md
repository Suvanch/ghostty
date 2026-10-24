# Ghostty Cyberpunk Terminal Setup

A record and rebuild guide for my Ghostty terminal on Linux Mint, themed after *Cyberpunk: Edgerunners* and *The Matrix*: a slightly see-through black window, a slate/indigo/purple/brown color scheme, the Share Tech Mono HUD font, a glitchy cursor trail, faint CRT scanlines, and an animated intro with live system stats and a movie quote. The intro is a breathing, tentacled creature with a red eye, and it is also a working QR code: point a phone camera at it and it opens https://github.com/Suvanch.

*Created 2026-10-22, QR creature added 2026-10-23 · Ghostty 1.3.1 · Starship 1.27.0 · Python 3.12 · Linux Mint 22.3 (Cinnamon, X11)*

---

## Contents

1. [Quick rebuild](#1-quick-rebuild)
2. [What's in this folder](#2-whats-in-this-folder)
3. [The result](#3-the-result)
4. [How it fits together](#4-how-it-fits-together)
5. [Rebuild step by step](#5-rebuild-step-by-step)
6. [Customizing](#6-customizing)
7. [Troubleshooting](#7-troubleshooting)
8. [Reverting](#8-reverting)

---

## 1. Quick rebuild

On a machine that already has Ghostty, Python 3, the JetBrainsMono Nerd Font and Starship (see [section 5](#5-rebuild-step-by-step) if not):

```bash
cd ~/Desktop/Projects/ghostty-terminal/cyberpunk
./install.sh
```

Then open a new Ghostty window. The script:

- backs up anything it would overwrite into `~/.config/ghostty/pre-cyberpunk-backup-<date>/`
- copies the config, theme, shaders, prompt config and font into place
- rewrites `/home/suvanch` in the config to your home folder, so a different username works
- installs the intro to `~/.local/bin/edgerunner-fetch`, with `qr-ring` beside it
- adds the intro + Starship block to `~/.bashrc`, only if it isn't there already
- checks the config with `ghostty +validate-config`

It's safe to run again.

---

## 2. What's in this folder

`files/` mirrors where each file goes, using visible names (`config` instead of `.config`):

```
cyberpunk/
├── README.md                     # this guide
├── install.sh                    # puts everything in place (section 1)
├── edgerunner-fetch              # the intro: creature/ring + stats + quote    → ~/.local/bin/edgerunner-fetch
├── qr-ring                       # the scannable QR creature the intro draws   → ~/.local/bin/qr-ring
├── qr-test                       # prints a plain QR code (google.com), for testing a phone's scanner
└── files/
    ├── bashrc-additions.sh       # block appended to ~/.bashrc
    ├── config/
    │   ├── ghostty/
    │   │   ├── config            # main Ghostty settings                        → ~/.config/ghostty/config
    │   │   ├── themes/Edgerunner # color scheme                                 → ~/.config/ghostty/themes/
    │   │   └── shaders/
    │   │       ├── sandevistan_trail.glsl  # cursor afterimage                  → ~/.config/ghostty/shaders/
    │   │       └── crt.glsl                # scanlines + vignette               → ~/.config/ghostty/shaders/
    │   └── starship.toml         # prompt layout                                → ~/.config/starship.toml
    └── local/share/fonts/ShareTechMono/
        ├── ShureTechMonoNerdFontMono-Regular.ttf   # the font                   → ~/.local/share/fonts/ShareTechMono/
        └── OFL.txt                                 # font license (free to copy)
```

**`edgerunner-fetch` and `qr-ring` in this folder are the master copies.** Edit them here, then re-install them (see [Customizing](#6-customizing)). The copies under `files/` are snapshots taken on 2026-10-22. If you change a live file in `~/.config`, copy it back here.

---

## 3. The result

When a Ghostty window opens, the intro plays until you press any key:

```
               @@@@@@@@@@@@@@@@%
           %@@@@%#**+++$=====#*#@@@%
        #@@#+-:::----%&%#%... .@.:=#@@@
      #%#=%    ...:#%🬞🬵🬎🬱🬏&$ .=%+   :+%@@
    *%#=.@       $#🬞🬵🬆🬟🬹🬑🬊🬱🬏@%#.      :+@@#
   #%*: #.     #%#%🬬🬮🬇🬬-🬝🬃🬯🬝&🬏%@       .-#@@       SUVANCH@SUVANCH
  @@+.  %+.  %@@🬇🬺🬚$🬂🬪🬭🬂🬭🬜🬂#🬍🬀$🬏$#    ..:-#@@      ─────────────────────
 @@*:.  =%#@$🬞🬭@🬁🬎🬱🬞🬏&🬂🬎🬂&🬞🬏🬰🬭🬻.🬃@#@..:::-+%@@     os     Linux Mint 22.3
@@@=:....@#🬞🬵🬆🬡🬐🬊:🬰:🬱🬁🬪🬱🬁🬂-:🬒🬬🬃🬟🬹🬆🬞🬏@&:--==*@@@    uptime 19h 46m
@@#=::.&$🬞🬵🬭🬀@🬵🬝🬻🬕🬊🬲🬑&@@🬵🬱🬀▐🬇🬻🬐.🬱%🬁🬭🬱🬏#$===+%@@    cpu    ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰ 100%
@@+-:$@🬞🬵🬆🬟🬂🬪🬭🬀%🬏🬊&🬬🬝🬉🬪🬭🬲🬷🬄▐@🬕🬬🬊🬆🬭🬜🬂🬑🬊🬱🬏&#==*@@    temp   ▰▰▰▰▰▰▰▰▰▰▰▰▱▱▱▱  76°C
@@=@@@🬵🬕🬀🬹.🬺🬓🬂🬺🬏🬂🬵🬻🬻🬹🬺🬜.🬕🬟🬇🬆🬁🬨🬆🬞🬻🬂🬦🬻.🬹🬁🬨🬱%@@+@@    mem    ▰▰▰▰▰▰▰▱▱▱▱▱▱▱▱▱  41%  4.7/11.5 GiB
@%-.#$🬁🬊🬱🬑🬎🬆🬭🬜🬂#🬍🬀🬰@🬍🬆 🬫.🬆🬁🬬🬱🬯🬐#🬂🬪🬭🬊🬎🬟🬵🬆🬀@%:=%@    disk   ▰▰▱▱▱▱▱▱▱▱▱▱▱▱▱▱  13%  62/468 GiB
@@-   $#🬁🬊🬱🬜🬂#$🬫🬎:🬛🬇🬎🬪🬏🬸🬹🬹🬹🬎🬡.🬎🬺🬏#🬂🬪🬵🬆🬀#@..:=@@    net    ↓ 8.7 KB/s   ↑ 20.6 KB/s
%@+.    %%🬁&🬉🬀%🬊🬀🬁🬵🬜🬀-::::🬺🬹🬋🬲🬹@🬸🬂🬪🬃🬀$$ ...-*@%    ping   11 ms  1.1.1.1
*@%=@     @$$🬊▐🬺🬎🬻🬂🬺+🬝🬆🬭🬊🬬+🬲🬻🬕🬊🬓🬁🬆$%@ ...:-+@@*    corpo  ▰▰▰▱▱▱▱▱▱▱▱▱▱▱▱▱  21  extreme fear
 %@%=:*     %&🬁🬊🬇🬆🬞🬝+🬺🬱🬂🬵🬻+=🬬🬲$@%&% ..::-=*@@@
  @@@+:.@:.:%@@%%&🬸🬺🬜🬊-=+++-🬋🬆🬀$@...=:--=#@@@      ████████
   %@@#-:..@@%=-@%🬁🬊🬹🬻++🬌🬍🬎🬆🬀&$-...::-=+@@@@
     %@%+:..:@-:==$$🬁🬂🬸🬐🬇🬆🬀%&#:.....:=#@@@
       #@%+-:.-+:::-@#🬁🬂@##@=     .-*@@@
         +%%#*=-:@::::&$%=%   .:=*#%%*
            +#%@@%%#*%++@=++*#%%%#+
                  #%@@@@%%#*+

                                ▌ Free your mind.  — Morpheus
```

(One frame, without color. The diamond of block characters in the middle is the QR code; the ASCII around it is the breathing ring and the tentacles reaching out to it. The creature is 47×24 characters. In color, the code sweeps green → blue → purple, the tentacles are yellow, and the red eye sits in the center.)

| Feature | Details |
|---|---|
| **Window** | Black background at 90% opacity (`background-opacity = 0.9`), 24×18 px padding, 110×30 cells. |
| **Theme** | *Edgerunner* (`themes/Edgerunner`), built from `#000000`, `#424153` slate, `#333399` indigo, `#663399` purple and `#663300` brown. Those are too dark to read as text on black, so the text colors are lighter tints of the same hues. The cursor is purple `#9966cc` and the selection is indigo `#333399`. |
| **Font** | Share Tech Mono 14pt, a HUD-style monospace font. The Nerd Font patched build is named **"ShureTechMono Nerd Font Mono"**: Nerd Fonts had to rename it for licensing reasons. JetBrainsMono Nerd Font fills in missing glyphs. |
| **Cursor trail** | `sandevistan_trail.glsl`: when the cursor jumps, it leaves a 0.22 s afterimage that splits into purple and indigo ghosts, cut by glitch lines. |
| **CRT** | `crt.glsl`: faint horizontal scanlines and darker corners. |
| **QR creature** | The intro's main art, drawn by `qr-ring`. A QR code for `https://github.com/Suvanch`, turned 45° into a diamond, disguised as a living thing: <br>• **Breathing:** one breath every 3 s, a quicker inhale and a longer exhale. It starts at the center and rolls outward, so the ring swells a moment after the code brightens. <br>• **Heartbeat:** a lub-dub pulse about once a second, in the eye. <br>• **Tentacles:** six yellow tentacles, thick at the root and thin at the tip, with a wave running along them and curling tips. They almost always reach just to the ring and follow it as it breathes; now and then one pulls back for a moment. <br>• **Red eye:** blinks every 4.3 s, holds its gaze, then darts somewhere else every 1.7 s. Its slit pupil widens on each inhale. <br>• **Colors:** a green → blue → purple sweep turns around the code, which is what makes it look like it's spinning. Characters drift through the code, with glitch characters flickering in and out. <br>• **Hidden code:** the real code is on screen only every 3rd frame. Shimmering stand-ins fill the frames between, so the three corner squares that give a QR code away never sit still. A fourth decoy "eye" balances them. <br>Pressing a key leaves the real code on screen, so it can still be scanned from scrollback. |
| **Intro ring** | The original sandevistan ring: an ASCII plasma ring with rotating spokes and a pulsing core, in cyan, pink and yellow. It's the fallback when the window is too small for the creature, or `qr-ring` / `python3-qrcode` is missing. Unlike the creature, it can shrink. |
| **Exiting** | The intro loops until a key is pressed, and that key is discarded rather than typed into the prompt. |
| **Live stats** | Refreshed every second while the intro plays: CPU %, CPU temperature, memory %, disk % (each with a bar), network ↓/↑ speed, ping to 1.1.1.1, and **corpo**: CNN's stock-market Fear & Greed index. The label is pink on the fear side and yellow on the greed side. |
| **Quote** | A random line from *The Matrix* or *Edgerunners*. It types itself in below the art, followed by the speaker's name. |
| **Responsive layout** | The art and stats are centered as a block. From 97×27 the creature and stats both show (the default 110×30 window fits). From 51×27 the creature shows alone. Below that, the plain ring takes over and shrinks to fit. The quote wraps to fit. |
| **Prompt** | Starship, carried over from the earlier ukiyo-e setup: two lines, kanji markers (枝 git branch, 蛇 Python, 時 slow-command time), with colors taken from the theme. |

---

## 4. How it fits together

```
Ghostty starts
 ├─ reads ~/.config/ghostty/config
 │    ├─ theme = Edgerunner        → ~/.config/ghostty/themes/Edgerunner
 │    ├─ font-family ×3            → Share Tech Mono, then JetBrainsMono Nerd Font, then Noto CJK
 │    └─ custom-shader ×2          → sandevistan_trail.glsl, then crt.glsl (run in order on the GPU)
 └─ launches bash
      └─ ~/.bashrc (last block)    → only if interactive + inside Ghostty + not already shown
           ├─ ~/.local/bin/edgerunner-fetch
           │    ├─ loads ~/.local/bin/qr-ring (which builds the QR code with python3-qrcode);
           │    │    if either is missing, it draws the plain ring instead
           │    ├─ starts background threads: ping every 2 s; fetch Fear & Greed
           │    │    (cached in ~/.cache/edgerunner-fetch/fear-greed.json for 30 min)
           │    ├─ switches to the alternate screen and redraws the whole layout at a fixed
           │    │    20 frames/s for the current window size, so resizing can't scramble it;
           │    │    every 3rd frame draws the real code, the others its shimmering stand-in
           │    ├─ re-reads /proc (CPU, memory, network) and the disk every second
           │    └─ on a key press: switches back and prints the final frame to the normal
           │         screen, so it stays in scrollback above the prompt
           └─ starship init bash       → every prompt is drawn from ~/.config/starship.toml
```

**Design notes:**

- **Where the stats come from:** CPU % and network speed are differences between two readings of `/proc/stat` and `/proc/net/dev`. Loopback, Docker, `veth`, bridge and `virbr` interfaces are skipped, so traffic isn't counted twice. Temperature is the CPU package sensor (`coretemp` on Intel, `k10temp`/`zenpower` on AMD) in `/sys/class/hwmon`. Ping runs the system `ping` command. None of these need extra packages.
- **Fear & Greed:** CNN rejects requests that don't look like a browser, so the script sends browser-like headers. If the fetch fails, the last cached value is shown; with no cache, the row shows `…`.
- **Startup noise guard:** stray input in the first 0.5 s is thrown away, so the intro isn't skipped by accident when the window opens.
- **Why the alternate screen:** the old approach redrew in place by moving the cursor up a fixed number of lines. When the window was resized, the terminal re-wrapped those lines and the layout broke.

**How the QR creature stays scannable.** A scanner only needs to see which squares of the code are dark and which are light. It ignores color and anything outside the code. Every effect is built around that, and each was tested with a QR decoder on frames rendered in the terminal font, plus a simulated phone camera:

- **Inverted code:** the code's dark squares are drawn lit and its light squares are left black, so it glows on the black window. Phone cameras read inverted codes; a few older scanner apps don't.
- **Diamond:** scanners don't care about rotation. A grid turned 45° looks jagged in half-block characters, so it's drawn in sextant characters (🬞🬭🬹), which split each cell into 2×3 small blocks. Ghostty draws these itself, whatever the font. The diamond fits inside the same ring as the square, because a square's corners stay the same distance from its center when it turns.
- **The color is free:** the lit squares can be any color, as long as they never get dim enough to look dark. They breathe between 68% and 100% brightness.
- **Colors close in brightness:** the scanner judges each square against its neighbors, so a much brighter color next to a darker one turns the darker one "dark". A near-white eyelid did that to a deep green eye, and a deep red eye failed next to the yellow tentacles. So the eye uses a brighter red, its colors stay close in brightness, and the tentacles fade out right around it. The sweep goes green → blue → purple: a direct green → purple blend would pass through gray.
- **Characters inside the code:** a dark character drawn over a lit square, or a dim one in a dark square, leaves each square reading the same. The dense `@#$%&` characters in the dark squares are kept at 35% brightness or less. At full brightness, nothing decoded.
- **Flashing:** a phone camera takes about 30 photos a second and blends whatever was on screen during each one. With the real code every 3rd frame at 20 frames/s, enough photos catch it cleanly. Scans took at most about 0.6 s, even in dim light, where the phone exposes each photo longer. The stand-in frames change each square only twice a second, so they shimmer instead of strobing.
- **The decoy eye** is a thick ring with a dot, built around the code's small alignment square. To a person it looks like a fourth corner square. A scanner skips it, because a real corner square has 1:1:3:1:1 proportions and this one doesn't. Error correction covers the data squares it replaces.
- **Size:** the code is 25×25 squares, the smallest version that has the alignment square the decoy needs. The link is encoded in capitals (`HTTPS://GITHUB.COM/SUVANCH`). QR codes have a compact mode for capitals, digits and a few symbols, which keeps it at 25×25 with 25% error correction. Lowercase would need 29×29, too big for the ring and the 30-row window. Scanners treat `https://` and the domain name the same in either case, and so does GitHub for usernames.

---

## 5. Rebuild step by step

### Step 1 — Install Ghostty

Ghostty isn't in Mint's default repositories. Follow the Linux instructions at **https://ghostty.org/download**; for Ubuntu-based systems like Mint they point to a community-maintained `.deb` package. Then check:

```bash
ghostty --version
```

### Step 2 — Install the JetBrainsMono Nerd Font and Starship

Both go into your home folder, so no `sudo` is needed. (Share Tech Mono itself is included in this folder and installed in Step 3.)

```bash
# JetBrainsMono Nerd Font (fallback font)
mkdir -p ~/Downloads/nerdfont ~/.local/share/fonts/JetBrainsMono
curl -L -o ~/Downloads/nerdfont/JetBrainsMono.zip \
  https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
unzip -o ~/Downloads/nerdfont/JetBrainsMono.zip '*.ttf' -d ~/.local/share/fonts/JetBrainsMono
fc-cache -f

# Starship (prompt)
mkdir -p ~/Downloads/starship ~/.local/bin
curl -L -o ~/Downloads/starship/starship.tar.gz \
  https://github.com/starship/starship/releases/latest/download/starship-x86_64-unknown-linux-gnu.tar.gz
tar -xzf ~/Downloads/starship/starship.tar.gz -C ~/Downloads/starship
install -m755 ~/Downloads/starship/starship ~/.local/bin/starship
```

Python 3 and `ping` come with Mint. The QR creature needs `sudo apt install python3-qrcode`; without it, the intro shows the plain ring. The prompt's kanji markers need a Japanese font; Mint usually ships Noto CJK. If kanji show as boxes, run `sudo apt install fonts-noto-cjk`.

### Step 3 — Install the setup

```bash
cd ~/Desktop/Projects/ghostty-terminal/cyberpunk
./install.sh
```

<details>
<summary>Or do it by hand</summary>

```bash
cd ~/Desktop/Projects/ghostty-terminal/cyberpunk
mkdir -p ~/.config/ghostty/themes ~/.config/ghostty/shaders ~/.local/bin ~/.local/share/fonts/ShareTechMono
sed "s|/home/suvanch|$HOME|g" files/config/ghostty/config > ~/.config/ghostty/config
cp files/config/ghostty/themes/Edgerunner ~/.config/ghostty/themes/
cp files/config/ghostty/shaders/*.glsl ~/.config/ghostty/shaders/
cp files/config/starship.toml ~/.config/starship.toml
cp files/local/share/fonts/ShareTechMono/* ~/.local/share/fonts/ShareTechMono/ && fc-cache -f
install -m 755 edgerunner-fetch qr-ring ~/.local/bin/
cat files/bashrc-additions.sh >> ~/.bashrc
```
</details>

### Step 4 — Check

```bash
ghostty +validate-config          # prints nothing when the config is fine
fc-list | grep -i shuretech       # the font is installed
command -v edgerunner-fetch       # the intro is on your PATH
```

Open a new Ghostty window. To see shader errors, start Ghostty from another terminal with `ghostty 2>&1 | grep -i shader`. Each shader should log `loaded custom shader`.

---

## 6. Customizing

After editing a Ghostty file, save it and press **Ctrl+Shift+,** to reload. Changes to the intro show in the next new window.

**Editing the intro:** change `edgerunner-fetch` or `qr-ring` in this folder, then install them:

```bash
cd ~/Desktop/Projects/ghostty-terminal/cyberpunk && install -m 755 edgerunner-fetch qr-ring ~/.local/bin/
```

| What | Where | How |
|---|---|---|
| **Quotes** | `edgerunner-fetch`, the `QUOTES` list near the top | One per line: `("quote text", "speaker"),`. Use single quotes around a quote that contains `"`. |
| **QR link** | `qr-ring`: `URL` | Up to 29 characters from `A–Z 0–9 $%*+-./:` and space (it's encoded in capitals) keeps the code at 25×25. A longer link makes a bigger code that no longer fits the ring. Keep the `https://`: without it, many scanners show plain text and don't open a link. |
| **Breathing** | `qr-ring`: `BREATH` (seconds per breath) | Also changes how far the ring swells (`ring_radius()`) and how fast the breath travels outward (`field()`). |
| **Tentacles** | `qr-ring`: `TENTACLES` (how many), `TWIST` (how far they spiral); `tentacle_shapes()` | `tentacle_shapes()` sets their reach, sway, curl and how often they pull back. |
| **Eye** | `qr-ring`: `EYE_W`, `EYE_H`, `IRIS_R` (size), `BLINK_EVERY`; `IRIS, IRIS_DEEP, PUPIL, SCLERA, LID` (colors); `eye_state()` (gaze) | Sizes are fractions of the ring's radius. Keep the eye's colors close to each other in brightness, and not dark (see the design notes). |
| **Creature colors** | `qr-ring`: `GR, BL, PU` (the sweep), `YE` (tentacles) | Avoid dark colors such as deep blue or deep red, which make lit squares read as dark. |
| **Characters in the code** | `qr-ring`: `DENSE`, `DENSE_K` (brightness of the dense characters), `GLITCH` | `DENSE_K` above about 0.35 starts to break scanning. |
| **QR flashing** | `edgerunner-fetch`: `QR_FLASH = 3` | Real code every Nth frame. 1 = always (scans fastest), 4 = more hidden but slow in dim light. |
| **Trying options** | run `qr-ring` with switches | `--diamond`, `--decoy`, `--dense`, `--flash N`, `--burst`, `--halo`, `--round`, `--no-texture`, all described at the top of the file. The intro uses `qr-ring --diamond --decoy --dense --flash 3`. |
| **Plain ring size / look** | `edgerunner-fetch`: `W, H = 40, 19`; the `frame()` function | The fallback ring. Keep W ≈ 2×H so it stays round. |
| **Plain ring colors** | `edgerunner-fetch`: `CY, YE, MA, DIM, FG` | RGB tuples, separate from the Ghostty theme. These also color the stats panel. |
| **Ping target** | `edgerunner-fetch`: `PING_HOST = "1.1.1.1"` | Any host or IP. |
| **Fear & Greed refresh** | `edgerunner-fetch`: `FNG_MAX_AGE` (seconds) | Delete `~/.cache/edgerunner-fetch/fear-greed.json` to force a fetch. |
| **When stats hide** | `edgerunner-fetch`: `PANEL_W`, `GAP`, `MARGIN` | The stats show when the window has art width + `GAP` + `PANEL_W` + 2×`MARGIN` columns: 97 with the creature, 90 with the plain ring. |
| **Transparency** | `config`: `background-opacity` | 1 = solid black; lower shows more of the desktop. |
| **Terminal colors** | `themes/Edgerunner` | `foreground`, `cursor-color`, `selection-background`, `palette = 0..15`. |
| **Font / size** | `config`: `font-family`, `font-size` | Use the exact name from `ghostty +list-fonts`. |
| **Cursor trail** | `sandevistan_trail.glsl`: `DURATION`, `OPACITY`, `SPLIT`, `PURPLE`, `INDIGO` | Colors are 0–1 RGB. Comment out its `custom-shader` line to turn it off. |
| **Scanlines / corners** | `crt.glsl`: `SCANLINES`, `VIGNETTE` | 0 turns either off. Remove its `custom-shader` line to drop the shader. |
| **Turn off the intro** | `~/.bashrc` | Delete or comment out the `edgerunner-fetch` block. Run `edgerunner-fetch` by hand any time. |

---

## 7. Troubleshooting

| Problem | Cause & fix |
|---|---|
| **No intro when opening Ghostty** | Check `command -v edgerunner-fetch` (is `~/.local/bin` on your PATH?) and that the `.bashrc` block exists. It only runs once per window: if `TERM_INTRO_SHOWN` is already set in your environment (for example when testing from inside another Ghostty shell), it's skipped. Try `env -u TERM_INTRO_SHOWN bash -i`. |
| **Ring shows but doesn't move** | Make sure the installed copy is current (`diff` it with this folder's). The ring stops only on a key press or Ctrl+C. |
| **Stats missing** | The window is too narrow or short: under 97×27 with the creature, about 90×22 with the plain ring. Make it bigger and they appear right away. |
| **Plain ring instead of the QR creature** | The window is under 51×27 (28 rows for a two-line quote), `qr-ring` isn't in `~/.local/bin` next to `edgerunner-fetch`, or `python3-qrcode` is missing (check with `python3 -c "import qrcode"`). |
| **The QR code won't scan** | Hold the phone 20–40 cm from the screen and keep it steady for a second. In a dark room it takes longer. To test, set `QR_FLASH = 1` (code always on), or run `qr-test`, which prints a plain code. If that scans and the creature doesn't, undo your last change to `qr-ring`'s colors, `DENSE_K` or the eye. Turning off the CRT shader and lowering the window's transparency can also help. |
| **Sextant characters show as boxes** | The diamond is drawn with Unicode sextants (U+1FB00–1FB3B). Ghostty draws them itself; other terminals may need a font that has them. |
| **`temp` shows n/a** | No `coretemp`/`k10temp`/`zenpower` sensor. List them with `cat /sys/class/hwmon/*/name` and add the right name in `cpu_temp()`. |
| **`ping` shows offline** | No network, or ICMP is blocked. Check with `ping -c1 1.1.1.1`. |
| **`corpo` stays at `…`** | Offline, or CNN blocked the request. Test with `curl -s -A "Mozilla/5.0" -H "Referer: https://www.cnn.com/" https://production.dataviz.cnn.io/index/fearandgreed/graphdata`. "I'm a teapot" means it's blocked. |
| **Window isn't see-through** | Transparency needs a compositor. Cinnamon has one by default; some lightweight desktops don't. |
| **Wrong font / boxes** | Check `fc-list \| grep -i shuretech`. If it's missing, re-run `install.sh` or copy the `.ttf` and run `fc-cache -f`. |
| **Shader has no effect** | Run `ghostty 2>&1 \| grep -i shader` and look for errors. Paths in `config` must be absolute and match your username (`install.sh` fixes this). |
| **Warning about `config.ghostty`** | Ghostty also reads `config.ghostty`. An empty one only causes a harmless warning; delete it to keep everything in `config`. |
| **Config error on start** | Run `ghostty +validate-config`; it names the bad line. |

---

## 8. Reverting

Earlier versions are kept in `~/.config/ghostty/`:

- **`ukiyoe-backup/`**: the ink-wash / ukiyo-e setup that came right before this one (config, themes, shaders, `bashrc`). Its full guide is `~/Desktop/Projects/ghostty-terminal/ghostty-ukiyoe-setup.md`, and its intro `term-intro` is still installed in `~/.local/bin`.
- **`neon-backup/`**: the first neon version.
- **`config.backup`**: the original config from before any changes.
- **`pre-cyberpunk-backup-<date>/`**: created by `install.sh` whenever it overwrites something.

To go back to ukiyo-e:

```bash
cp ~/.config/ghostty/ukiyoe-backup/config ~/.config/ghostty/config
sed -i 's/edgerunner-fetch/term-intro/g' ~/.bashrc
```
